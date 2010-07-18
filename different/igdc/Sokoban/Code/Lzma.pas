{$I-}
unit Lzma;
//==============================================================================
// Unit: Lzma.pas
// Desc: Модуль распаковки 7z-архивов. Писался не как универсальный, а пол свои
//       нужды. То есть мои архивы, как он распаковывает, но гарантировать
//       совместимость со всеми 7z-архивами я бы не стал. Можете поковырять,
//       если кому-нибудь интересно :) Ноль объектно-ориентированности т.к.
//       это по сути просто перевод C-исходников. Может перепишу ООП. Может :)
//       ©2006 .gear
//==============================================================================
interface
  function AssignArchive(FileName: String): Integer;
  function ExtractToMemory(var Size: Longword; var Name: String): PByte;
  function CloseArchive(): Integer;

implementation
const
  kCrcPoly = $EDB88320;
  kBufferSize = 4096;
  kMethodIDSize = 15;
  
  k7zSignatureSize = 6;
  k7zSignature : array[0..5]of Byte = ($37, $7A, $BC, $AF, $27, $1C);

  kUtf8Limits: array[0..4]of Byte  = ($C0, $E0, $F0, $F8, $FC);

  k_Copy = 1;// : array[0..1]of Byte = ($0, 1);
  k_LZMA = 2;//: array[0..2]of Byte = ($3, $1, $1, $3 };

  k7zMajorVersion = 0;
  k7zStartHeaderSize = $20;

  kLzmaStreamWasFinishedId    = -1;
  k7zIdEnd                    = 0;
  k7zIdHeader                 = 1;
  k7zIdArchiveProperties      = 2;
  k7zIdAdditionalStreamsInfo  = 3;
  k7zIdMainStreamsInfo        = 4;
  k7zIdFilesInfo              = 5;
  k7zIdPackInfo               = 6;
  k7zIdUnPackInfo             = 7;
  k7zIdSubStreamsInfo         = 8;
  k7zIdSize                   = 9;
  k7zIdCRC                    = 10;
  k7zIdFolder                 = 11;
  k7zIdCodersUnPackSize       = 12;
  k7zIdNumUnPackStream        = 13;
  k7zIdEmptyStream            = 14;
  k7zIdEmptyFile              = 15;
  k7zIdAnti                   = 16;
  k7zIdName                   = 17;
  k7zIdCreationTime           = 18;
  k7zIdLastAccessTime         = 19;
  k7zIdLastWriteTime          = 20;
  k7zIdWinAttributes          = 21;
  k7zIdComment                = 22;
  k7zIdEncodedHeader          = 23;
  k7zIdStartPos               = 24;

  SZ_OK                       = 0;
  SZE_DATA_ERROR              = 1;
  SZE_OUTOFMEMORY             = 2;
  SZE_CRC_ERROR               = 3;
  SZE_NOTIMPL                 = 4;
  SZE_FAIL                    = 5;
  SZE_ARCHIVE_ERROR           = 6;

  LZMA_RESULT_OK              = 0;
  LZMA_RESULT_DATA_ERROR      = 1;
  LZMA_PROPERTIES_SIZE        = 5;
  LZMA_LIT_SIZE               = 768;
  LZMA_BASE_SIZE              = 1846;

  kNumPosBitsMax              = 4;
  kNumPosStatesMax            = 1 shl kNumPosBitsMax;
  kLenNumLowBits              = 3;
  kLenNumLowSymbols           = 1 shl kLenNumLowBits;
  kLenNumMidBits              = 3;
  kLenNumMidSymbols           = 1 shl kLenNumMidBits;
  kLenNumHighBits             = 8;
  kLenNumHighSymbols          = 1 shl kLenNumHighBits;
  kNumBitModelTotalBits       = 11;
  kBitModelTotal              = 1 shl kNumBitModelTotalBits;
  kNumTopBits                 = 24;
  kTopValue                   = 1 shl kNumTopBits;
  kNumMoveBits                = 5;
  
  LenChoice                   = 0;
  LenChoice2                  = LenChoice + 1;
  LenLow                      = LenChoice2 + 1;
  LenMid                      = LenLow + (kNumPosStatesMax shl kLenNumLowBits);
  LenHigh                     = LenMid + (kNumPosStatesMax shl kLenNumMidBits);
  kNumLenProbs                = LenHigh + kLenNumHighSymbols;

  kNumStates                  = 12;
  kNumLitStates               = 7;
  kStartPosModelIndex         = 4;
  kEndPosModelIndex           = 14;
  kNumFullDistances           = 1 shl (kEndPosModelIndex shr 1);
  kNumPosSlotBits             = 6;
  kNumLenToPosStates          = 4;
  kNumAlignBits               = 4;
  kAlignTableSize             = 1 shl kNumAlignBits;
  kMatchMinLen                = 2;

  IsMatch                     = 0;
  IsRep                       = IsMatch + (kNumStates shl kNumPosBitsMax);
  IsRepG0                     = IsRep + kNumStates;
  IsRepG1                     = IsRepG0 + kNumStates;
  IsRepG2                     = IsRepG1 + kNumStates;
  IsRep0Long                  = IsRepG2 + kNumStates;
  constPosSlot                = IsRep0Long + (kNumStates shl kNumPosBitsMax);
  SpecPos                     = constPosSlot + (kNumLenToPosStates shl kNumPosSlotBits);
  Align                       = SpecPos + kNumFullDistances - kEndPosModelIndex;
  LenCoder                    = Align + kAlignTableSize;
  RepLenCoder                 = LenCoder + kNumLenProbs;
  Literal                     = RepLenCoder + kNumLenProbs;

type
  UInt16 = Word;
  UInt32 = LongWord;
  SizeT  = UInt32;
  UInt64 = Int64;
  TFileSize = LongWord;
  SZ_RESULT = Integer;

  TFileSizeArray = array of TFileSize;
  TUInt32Array = array of UInt32;
  TByteArray = array of Byte;

  TSzByteBuffer = record
    Capacity: LongWord;
    Items: PByte;
  end;

  TSzData = record
    Data: PByte;
    Size: Word;
  end;

  TInArchiveInfo = record
    StartPositionAfterHeader: TFileSize;
    DataStartPosition: TFileSize;
  end;

  TMethodID = record
    ID: array[0..kMethodIDSize]of Byte;
    IDSize: Byte;
  end;

  TCoderInfo = record
    NumInStreams: UInt32;
    NumOutStreams: Uint32;
    MethodID: TMethodID;
    Properties: TSzByteBuffer;
  end;

  TCoderInfoArray = array of TCoderInfo;

  TBindPair = record
    InIndex: UInt32;
    OutIndex: Uint32;
  end;

  TBindPairArray = array of TBindPair;

  TFolder = record
    NumCoders: UInt32;
    Coders: TCoderInfoArray;
    NumBindPairs: Uint32;
    BindPairs: TBindPairArray;
    NumPackStreams: UInt32;
    PackStreams: TUInt32Array;
    UnPackSizes: TFileSizeArray;
    UnPackCrcDefined: Integer;
    UnPackCRC: UInt32;
    NumUnPackStreams: UInt32;
  end;

  TFolderArray = array of TFolder;
  
  TFileItem = record
    Size: TFileSize;
    FileCRC: UInt32;
    Name: String;
    IsFileCRCDefined: Byte;
    HasStream: Byte;
    IsDirectory: Byte;
    IsAnti: Byte;
  end;

  TFileItemArray = array of TFileItem;
  
  TArchiveDatabase = record
    NumPackStreams: UInt32;
    PackSizes: TFileSizeArray;
    PackCRCsDefined: TByteArray;
    PackCRCs: TUInt32Array;
    NumFolders: UInt32;
    Folders: TFolderArray;
    NumFiles: UInt32;
    Files: TFileItemArray;
  end;

  TArchiveDatabaseEx = record
    Database: TArchiveDatabase;
    ArchiveInfo: TInArchiveInfo;
    FolderStartPackStreamIndex: TUInt32Array;
    PackStreamStartPositions: TFileSizeArray;
    FolderStartFileIndex: TUInt32Array;
    FileIndexToFolderIndexMap: TUInt32Array;
  end;

  TArchive = record
    ArchiveFile: File;
    Database: TArchiveDatabaseEx;
  end;

  TLzmaInCallback = function: Integer;
//int (*Read)(void *object, const unsigned char **buffer, SizeT *bufferSize);

  TLzmaInCallbackImp = record
    InCallback: TLzmaInCallback;
  //ISzInStream *InStream;
    Size: UInt32; //size_t
  end;

  TLzmaProperties = record
    lc: Integer;
    lp: Integer;
    pb: Integer;
  end;

  PProb = ^TProb;
  TProb = UInt32;
  TProbArray = array of TProb;

  TLzmaDecoderState = record
    Properties: TLzmaProperties;
    Probs: TProbArray;
    Buffer: PByte;
    BufferLim: PByte;
  end;

var
  CrcTable: array[0..255]of LongWord;
  Archive : TArchive;
  hr      : Integer;
  g_Buffer: array[0..kBufferSize-1] of Byte;
  _i: UInt32;
  _OutBuffer: TSzByteBuffer;
  BlockIndex: Uint32 = $FFFFFFFF;
  
{$REGION ' 7zCrc '}
//==============================================================================
// Name: InitCrcTable
//==============================================================================
  procedure InitCrcTable;
  var i,j,r: LongWord;
  begin
       for i := 0 to 255 do
       begin
            r := i;
            for j := 0 to 7 do
            begin
                 if (r and 1)=1 then r := (r shr 1) xor kCrcPoly
                                else r := r shr 1;
            end;
            CrcTable[i] := r;
       end;
  end;
//==============================================================================
// Name: CrcInit
//==============================================================================
  procedure CrcInit(var Crc: Uint32);
  begin
       Crc := $FFFFFFFF;
  end;
//==============================================================================
// Name: CrcGetDigest
//==============================================================================
  function CrcGetDigest(var Crc: UInt32): UInt32;
  begin
       Result := Crc xor $FFFFFFFF;
  end; 
//==============================================================================
// Name: CrcUpdateByte
//==============================================================================
  procedure CrcUpdateByte(var Crc: UInt32; b: Byte);
  begin
       Crc := CrcTable[Byte(Crc) xor b] xor (Crc shr 8);
  end;
//==============================================================================
// Name: CrcUpdateUInt16
//==============================================================================
  procedure CrcUpdateUInt16(var Crc: UInt32; v: UInt16);
  begin
       CrcUpdateByte(Crc, Byte(v));
       CrcUpdateByte(Crc, Byte(v shr 8));
  end;
//==============================================================================
// Name: CrcUpdateUInt32
//==============================================================================
  procedure CrcUpdateUInt32(var Crc: UInt32; v: UInt32);
  var i: integer;
  begin
       for i := 0 to 3 do
            CrcUpdateByte(Crc, Byte(v shr (8*i)));
  end;
//==============================================================================
// Name: CrcUpdateUInt64
//==============================================================================
  procedure CrcUpdateUInt64(var Crc: UInt32; v: UInt64);
  var i: integer;
  begin
       for i := 0 to 7 do
       begin
            CrcUpdateByte(Crc, Byte(v));
            v := v shr 8;
       end;
  end;
//==============================================================================
// Name: CrcUpdate
//==============================================================================
  procedure CrcUpdate(var Crc: UInt32; Data: Pointer; Size: LongWord);
  var v: UInt32; p: PByte;
  begin
       v := Crc;
       p := PByte(Data);
       while (Size>0) do
       begin
            v := CrcTable[Byte(v) xor P^] xor (v shr 8);
            Dec(Size);
            Inc(p);
       end;
       Crc := v;
  end;
//==============================================================================
// Name: CrcCalculateDigest
//==============================================================================
  function CrcCalculateDigest(Data: Pointer; Size: LongWord): UInt32;
  var Crc: UInt32;
  begin
       CrcInit(Crc);
       CrcUpdate(Crc, Data, Size);
       Result := CrcGetDigest(Crc);
  end;
//==============================================================================
// Name: CrcVerifyDigest
//==============================================================================
  function CrcVerifyDigest(Digest: UInt32; Data: Pointer; Size: LongWord): Boolean;
  begin
       Result := CrcCalculateDigest(Data, Size) = Digest;
  end;
{$ENDREGION}

{$REGION ' Input '}
//==============================================================================
// Name: ReadByte
//==============================================================================
  function ReadByte: Byte;
  var Processed: Integer;
  begin
       BlockRead(Archive.ArchiveFile, Result, 1, Processed);
       if Processed <> 1 then hr := SZE_ARCHIVE_ERROR;
  end;

  procedure ReadBytes(Size: Word; P: PByte);
  var
    ToRead,Processed: Integer;
    R: PByte;
  begin
       while Size>0 do
       begin
            if Size>kBufferSize then ToRead := kBufferSize
                                else ToRead := Size;
            Dec(Size, ToRead);
            BlockRead(Archive.ArchiveFile,g_Buffer, ToRead ,Processed);
            if Processed <> ToRead then
            begin
                 hr := SZE_ARCHIVE_ERROR;
                 Exit;
            end;
            R := PByte(@g_Buffer[0]);
            while Processed > 0do
            begin
                 P^ := R^;
                 Inc(R); Inc(P);
                 Dec(Processed);
            end;
       end;
  end;
//==============================================================================
// Name: SzReadByte
//==============================================================================
  function SzReadByte(var sd: TSzData): Byte;
  begin
       if sd.Size = 0 then begin hr := SZE_ARCHIVE_ERROR; Result := 0; Exit; end;
       Result := sd.Data^;
       Inc(sd.Data);
       Dec(sd.Size);
  end;

  function SzReadBytes(var sd: TSzData; Size: Word; P: PByte): SZ_RESULT;
  var i: Integer;
  begin
       for i := 0 to Size-1 do
       begin
            P^ := SzReadByte(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            Inc(P);
       end;
       Result := SZ_OK;
  end;
//==============================================================================
// Name: ReadUInt32 & SzReadUInt32
//==============================================================================
  function ReadUInt32: UInt32;
  var Processed: Integer;
  begin
       BlockRead(Archive.ArchiveFile, Result, 4, Processed);
       if Processed <> 4 then hr := SZE_ARCHIVE_ERROR;
  end;

  function SzReadUInt32(var sd: TSzData): UInt32;
  begin
       Result := SzReadByte(sd);
       if hr<>0 then Exit;
       Result := (SzReadByte(sd) shl 8) or Result;
       if hr<>0 then Exit;
       Result := (SzReadByte(sd) shl 16) or Result;
       if hr<>0 then Exit;
       Result := (SzReadByte(sd) shl 24) or Result;
  end;
//==============================================================================
// Name: ReadUInt64
//==============================================================================
  function ReadUInt64: UInt64;
  var Processed: Integer;
  begin
       BlockRead(Archive.ArchiveFile, Result, 8, Processed);
       if Processed <> 8 then hr := SZE_ARCHIVE_ERROR;
  end;
//==============================================================================
// Name: SzReadNumber
//==============================================================================
  function SzReadNumber(var sd: TSzData): UInt64;
  var
    HighPart: UInt64;
    FirstByte: Byte;
    Mask, b: Byte;
    i: Integer;
  begin
       hr := SZ_OK;
       Mask := $80;
       FirstByte := SzReadByte(sd);
       Result := 0;
       for i := 0 to 7 do
       begin
            if (FirstByte and Mask)= 0 then
            begin
                 HighPart := FirstByte and (Mask - 1);
                 Result := Result + (HighPart shl (8*i));
                 Exit;
            end;
            b := SzReadByte(sd);
            Result := Result or (UInt64(b) shl (8*i));
            Mask := Mask shr 1;
       end;
  end;
//==============================================================================
// Name: SzReadID
//==============================================================================
  function SzReadID(var sd: TSzData): UInt64;
  begin
       Result := SzReadNumber(sd);
  end;
//==============================================================================
// Name: SzReadSize
//==============================================================================
  function SzReadSize(var sd: TSzData): UInt64;
  begin
       Result := TFileSize(SzReadNumber(sd));
  end;
{$ENDREGION}

{$REGION ' LzmaDecode '}
//==============================================================================
// Name: LzmaGetNumProbs
//==============================================================================
  function LzmaGetNumProbs(Properties: TLzmaProperties): Integer;
  begin
       Result := LZMA_BASE_SIZE + (LZMA_LIT_SIZE shl (Properties.lc+Properties.lp));
  end;
//==============================================================================
// Name: LzmaDecodeProperties
//==============================================================================
  function LzmaDecodeProperties(var PropsRes: TLzmaProperties; P: PByte; Size: UInt32): Integer;
  var
    prop0: Byte;
  begin
       if Size < LZMA_PROPERTIES_SIZE then
       begin
            Result := LZMA_RESULT_DATA_ERROR;
            Exit;
       end;
       prop0 := P^;
       if prop0 >= 9*5*5 then
       begin
            Result := LZMA_RESULT_DATA_ERROR;
            Exit;
       end;

       PropsRes.pb := 0;
       PropsRes.lp := 0;
       while prop0 >= 9*5 do
       begin
            Inc(PropsRes.pb);
            if prop0 >= 9*5 then Dec(prop0,9*5) else prop0 := 0;
       end;
       while prop0 >= 9 do
       begin
            Inc(PropsRes.lp);
            if prop0 >=9 then Dec(prop0, 9) else prop0 := 0;
       end;
       PropsRes.lc := prop0;
       Result := LZMA_RESULT_OK;
  end;
//==============================================================================
// Name: LzmaDecode
//==============================================================================
  function LzmaDecode(var vs: TLzmaDecoderState;
                      var InCallback: TLzmaInCallBackImp;
                      var OutStream: PByte;
                      var OutSize: SizeT;
                      var OutSizeProcessed: SizeT): Integer;
  var
    i,mi,_Result: Integer;
    rep0, rep1, rep2, rep3: UInt32;
    State: Integer;
    P: TProbArray;
    prob,prob3,probLen: PProb;
    NowPos: SizeT;
    PreviousByte: Byte;
    PosStateMask: UInt32;
    LiteralPosMask: UInt32;
    lc: Integer;
    len: Integer;
    Range, Code: UInt32;
    NumProbs: Uint32;
    Buffer,BufferLim: PByte; // const Byte *Buffer; const Byte *Buffer;
    Size: SizeT;
    PosState: Integer;
    Bound: UInt32;
    Symbol: Integer;
    MatchByte: Integer;
    Bit,PosSlot: Integer;
    ProbLit: PProb;
    Temp: PByte;
    Distance: UInt32;
    NumBits,Offset,NumDirectBits: Integer;

    DumpFile: Text; __Size: Integer; T: Pbyte;

    procedure RC_TEST;
    var ToRead, Processed: Integer;
    begin
         if Buffer = BufferLim then
         begin
              if InCallback.Size>kBufferSize then ToRead := kBufferSize
                                         else ToRead := InCallback.Size;
               BlockRead(Archive.ArchiveFile,g_Buffer, ToRead ,Processed);
               if Processed > ToRead then
               begin
                    hr := SZE_ARCHIVE_ERROR;
                    Exit;
               end;
               Buffer := @g_Buffer[0];
               BufferLim := Buffer;
               Inc(BufferLim,Processed);
               Dec(InCallback.Size, Processed);
         end;
    end;

    function RC_READ_BYTE: Byte;
    begin
         Result := Buffer^;
         Inc(Buffer);
    end;
    
    procedure RC_NORMALIZE;
    begin
         if Range < kTopValue then
         begin
              RC_TEST;
              {RINOK}//...
              Range := Range shl 8;
              Code := (Code shl 8) or RC_READ_BYTE;
         end;
    end;

    function IfBit0(p: TProb): Boolean;
    begin
         RC_NORMALIZE;
         Bound := (Range shr kNumBitModelTotalBits)*p;
         Result := Code < Bound;
    end;

    procedure UpdateBit0(var p: TProb);
    begin
         Range := Bound;
         Inc(p,((kBitModelTotal - p) shr kNumMoveBits));
    end;

    procedure UpdateBit1(var p: TProb);
    begin
         Range := Range - Bound;
         Code := Code - Bound;
         Dec(p,(p shr kNumMoveBits));
    end;

    procedure RC_GET_BIT(var p: PProb; var mi: Integer);
    begin
         if IfBit0(p^) then
         begin
              UpdateBit0(p^);
              mi := mi shl 1;
         end else
         begin
              UpdateBit1(p^);
              mi := (mi shl 1)+1; // (mi+mi)+1;
         end;
    end;

    procedure RangeDecoderBitTreeDecode(var probs: PProb;
                                        NumLevels: Integer;
                                        var Res: Integer);
    var i: Integer; p: PProb;
    begin
         i := NumLevels;
         Res := 1;
         repeat
              p := probs;
              Inc(p,Res);
              RC_GET_BIT(p, Res);
              Dec(i);
         until i = 0;
         Dec(Res,(1 shl NumLevels));
    end;
    
  begin
       P := vs.Probs;
       PreviousByte := 0; NowPos := 0;
       PosStateMask := (1 shl (vs.Properties.pb))-1;
       LiteralPosMask := (1 shl (vs.Properties.lp))-1;
       lc := vs.Properties.lc;
       State := 0;
       rep0 := 1; rep1 := 1; rep2 := 1; rep3 := 1;
       len := 0;
       OutSizeProcessed := 0;

       NumProbs := Literal + (LZMA_LIT_SIZE shl (lc + vs.Properties.lp));
       for i := 0 to NumProbs-1 do
       begin
            P[i] := kBitModelTotal shr 1;
       end;

       {$REGION ' RC_INIT '}
       Buffer := nil;
       BufferLim := nil;
       Code := 0;
       Range := $FFFFFFFF;

       for i := 0 to 4 do
       begin
            RC_TEST;
            Code := (Code shl 8) or RC_READ_BYTE;
       end;
       {$ENDREGION}

       while (NowPos < OutSize) do
       begin
            PosState := NowPos and PosStateMask;
            prob := @p[IsMatch+(State shl kNumPosBitsMax)+PosState];
            if IfBit0(prob^) then
            begin
                 Symbol := 1;
                 UpdateBit0(prob^);
                 prob := @p[Literal+(LZMA_LIT_SIZE*(((NowPos and LiteralPosMask)shl lc)+(PreviousByte shr(8-lc))))];
                 if State >= kNumLitStates then
                 begin
                      Temp := outStream;
                      Inc(Temp,NowPos-rep0);
                      MatchByte := Temp^;
                      repeat
                            MatchByte := MatchByte shl 1;
                            Bit := MatchByte and $100;
                            ProbLit := prob;
                            Inc(ProbLit,$100+Bit+Symbol);
                            if IfBit0(ProbLit^) then
                            begin
                                 UpdateBit0(ProbLit^);
                                 Symbol := Symbol shl 1;
                                 if Bit <> 0 then Break;
                            end else
                            begin
                                 UpdateBit1(ProbLit^);
                                 Symbol := (Symbol shl 1)+1;
                                 if Bit = 0 then Break;
                            end;
                      until not (Symbol<$100);
                 end;
                 while Symbol<$100 do
                 begin
                      ProbLit := prob;
                      Inc(ProbLit,Symbol);
                      RC_GET_BIT(ProbLit, symbol)
                 end;
                 PreviousByte := Byte(Symbol);
                 Temp := outStream;
                 Inc(Temp,NowPos);
                 Temp^ := PreviousByte;
                 Inc(NowPos);

                 if State < 4 then State := 0 else
                 if State < 10 then Dec(State,3) else Dec(State,6);
            end else
            begin
                 UpdateBit1(prob^);
                 prob := @p[IsRep+State];
                 if IfBit0(prob^) then
                 begin
                      UpdateBit0(prob^);
                      rep3 := rep2;
                      rep2 := rep1;
                      rep1 := rep0;
                      if State < kNumLitStates then State := 0 else State := 3;
                      prob := @p[LenCoder];
                 end else
                 begin
                      UpdateBit1(prob^);
                      prob := @p[IsRepG0 + State];
                      if IfBit0(prob^) then
                      begin
                           UpdateBit0(prob^);
                           prob := @p[IsRep0Long+(State shl kNumPosBitsMax)+PosState];
                           if IfBit0(prob^) then
                           begin
                                UpdateBit0(prob^);
                                if NowPos = 0 then
                                begin
                                     Result := LZMA_RESULT_DATA_ERROR;
                                     Exit;
                                end;
                                if State < kNumLitStates then State := 9 else State := 11;

                                Temp := outStream;
                                Inc(Temp,NowPos-rep0);
                                PreviousByte := Temp^;

                                Temp := outStream;
                                Inc(Temp,NowPos);
                                Temp^ := PreviousByte;
                                Inc(NowPos);

                                Continue;
                           end else
                           begin
                                UpdateBit1(prob^);
                           end;
                      end else
                      begin
                           UpdateBit1(prob^);
                           prob := @p[IsRepG1 + State];
                           if IfBit0(prob^) then
                           begin
                                UpdateBit0(prob^);
                                Distance := rep1;
                           end else
                           begin
                                UpdateBit1(prob^);
                                prob := @p[IsRepG2+State];
                                if IfBit0(prob^) then
                                begin
                                     UpdateBit0(prob^);
                                     Distance := rep2;
                                end else
                                begin
                                     UpdateBit1(prob^);
                                     Distance := rep3;
                                     rep3 := rep2;
                                end;
                                rep2 := rep1;
                           end;
                           rep1 := rep0;
                           rep0 := Distance;
                      end;
                      if State < kNumLitStates then State := 8 else State := 11;
                      prob := @p[RepLenCoder];
                 end;
                 probLen := prob;
                 Inc(probLen,LenChoice);
                 if IfBit0(probLen^) then
                 begin
                      UpdateBit0(ProbLen^);
                      probLen := prob;
                      Inc(probLen,LenLow+(posState shl kLenNumLowBits));
                      Offset := 0;
                      NumBits := kLenNumLowBits;
                 end else
                 begin
                      UpdateBit1(probLen^);
                      probLen := prob;
                      Inc(probLen,LenChoice2);
                      if IfBit0(probLen^) then
                      begin
                           UpdateBit0(probLen^);
                           probLen := prob;
                           Inc(probLen,LenMid+(posState shl kLenNumMidBits));
                           Offset := kLenNumLowSymbols;
                           numBits := kLenNumMidBits;
                      end else
                      begin
                           UpdateBit1(probLen^);
                           probLen := prob;
                           Inc(probLen,LenHigh);
                           Offset := kLenNumLowSymbols+kLenNumMidSymbols;
                           numBits := kLenNumHighBits;
                      end;
                 end;
                 RangeDecoderBitTreeDecode(probLen, numBits, len);
                 Inc(len,offset);
                 if State<4 then
                 begin
                      Inc(State,kNumLitStates);
                      if len < kNumLenToPosStates then i := len else i := kNumLenToPosStates-1;
                      i := constPosSlot+(i shl kNumPosSlotBits);
                      prob := @p[i];
                    //prob = p + PosSlot +
                    //  ((len < kNumLenToPosStates ? len : kNumLenToPosStates - 1) <<
                    //   kNumPosSlotBits);
                      RangeDecoderBitTreeDecode(prob, kNumPosSlotBits, posSlot);
                      if PosSlot >= kStartPosModelIndex then
                      begin
                           NumDirectBits := (PosSlot shr 1)-1;
                           rep0 := 2 or (PosSlot and 1);
                           if PosSlot < kEndPosmodelIndex then
                           begin
                                rep0 := rep0 shl NumDirectBits;
                                prob := @p[SpecPos+rep0-PosSlot-1];
                           end else
                           begin
                                Dec(NumDirectBits,kNumAlignBits);
                                repeat
                                     RC_NORMALIZE;
                                     Range := Range shr 1;
                                     rep0 := rep0 shl 1;
                                     if Code >= Range then
                                     begin
                                          Dec(Code,Range);
                                          rep0 := rep0 or 1;
                                     end;
                                     Dec(NumDirectBits);
                                until NumDirectBits=0;
                                prob := @p[Align];
                                rep0 := rep0 shl kNumAlignBits;
                                NumDirectBits := kNumAlignBits;
                           end;
                           i := 1;
                           mi := 1;
                           repeat
                                {***************************}
                                prob3 := prob; Inc(prob3,mi);
                                if IfBit0(prob3^) then
                                begin
                                     UpdateBit0(prob3^);
                                     mi := mi shl 1;
                                end else
                                begin
                                     UpdateBit1(prob3^);
                                     mi := (mi shl 1)+1;
                                     rep0 := rep0 or i;
                                end;
                                i := i shl 1;
                                Dec(NumDirectBits);
                           until NumDirectBits=0;
                      end else
                           rep0 := PosSlot;

                      Inc(rep0); // ++rep0
                      if rep0 = 0 then
                      begin
                           len := kLzmaStreamWasFinishedId;
                           Break;
                      end;
                 end;
                 Inc(len,kMatchMinLen);
                 if rep0 > nowPos then
                 begin
                      Result := LZMA_RESULT_DATA_ERROR;
                      Exit;
                 end;

                 repeat
                      Temp := outStream;
                      Inc(Temp,NowPos-rep0);
                      PreviousByte := Temp^;

                      Dec(len);

                      Temp := outStream;
                      Inc(Temp,NowPos);
                      Temp^ := PreviousByte;
                      Inc(NowPos);
                 until not((len <>0)and(NowPos<outSize));
            end;
       end;
       RC_NORMALIZE;

       vs.Buffer := Buffer;
       vs.BufferLim := BufferLim;

       OutSizeProcessed := NowPos;
       Result := LZMA_RESULT_OK;
  end;
{$ENDREGION}

//==============================================================================
// Name: AreMethodsEqual
//==============================================================================
  function AreMethodsEqual(Method: TMethodID; _Type: Byte): Boolean;
  begin
       Result := False;
       case _Type of
       1: begin
               if Method.IDSize <> 1 then Exit;
               if Method.ID[0] <> 0 then Exit;
          end;
       2: begin
               if Method.IDSize <> 3 then Exit;
               if Method.ID[0] <> 3 then Exit;
               if Method.ID[1] <> 1 then Exit;
               if Method.ID[2] <> 1 then Exit;
          end;
       end;
       Result := True;
  end;

//==============================================================================
// Name: SzDecode
//==============================================================================
  function SzDecode(const PackSizes: TFileSizeArray; var Folder: TFolder;
                    var OutBuffer: PByte; var OutSize: UInt32;
                    var OutSizeProcessed: UInt32): SZ_RESULT;
  var
    si: Integer;
    //i: UInt32;
    InSize: UInt32;
    //Coder: TCoderInfo;
    lzmaCallback: TLzmaInCallbackImp;
    _Result: Integer;
    State: TLzmaDecoderState;
    outSizeProcessedLoc: SizeT;
  begin
       InSize := 0;
       if (Folder.NumPackStreams <> 1)or(Folder.NumCoders <> 1) then
       begin
            Result := SZE_NOTIMPL;
            hr := SZE_NOTIMPL;
            Exit;
       end;
       OutSizeProcessed := 0;

       for si := 0 to Folder.NumPackStreams-1 do
            Inc(InSize, PackSizes[si]);

       if AreMethodsEqual(Folder.Coders[0].MethodID, k_Copy) then
       begin
            //...
       end;
       if AreMethodsEqual(Folder.Coders[0].MethodID, k_LZMA) then
       begin
            lzmaCallback.Size := InSize;
          //lzmaCallback.InStream := InStream;
          //lzmaCallback.InCallback.Read := LzmaReadImp;
            if LzmaDecodeProperties(State.Properties,
                  Folder.Coders[0].Properties.Items,
                  Folder.Coders[0].Properties.Capacity) <> LZMA_RESULT_OK then
            begin
                 Result := SZE_FAIL;
                 hr := SZE_FAIL;
                 Exit;
            end;
            SetLength(State.Probs, LzmaGetNumProbs(State.Properties));
            {
            if State.Probs[0] = 0 then
            begin
                 Result := SZE_OUTOFMEMORY;
                 hr := SZE_OUTOFMEMORY;
                 Exit;
            end;
            }
            _Result := LzmaDecode(State,lzmaCallback,OutBuffer,OutSize,OutSizeProcessedLoc);
          //result = LzmaDecode(&state,
          //        &lzmaCallback.InCallback,
          //        outBuffer, (SizeT)outSize, &outSizeProcessedLoc);
             OutSizeProcessed := OutSizeProcessedLoc;
             State.Probs := nil;
             if _Result = LZMA_RESULT_DATA_ERROR then
             begin
                  Result := SZE_DATA_ERROR; hr := SZE_DATA_ERROR; Exit;
             end;
             if _Result <> LZMA_RESULT_OK then
             begin
                  Result := SZE_FAIL; hr := SZE_FAIL; Exit;
             end;
             Result := SZ_OK; hr := SZ_OK; Exit;
       end;
       Result := SZE_NOTIMPL; hr := SZE_NOTIMPL; Exit;
  end;
//==============================================================================
// Name: SzArchiveDatabaseInit
//==============================================================================
  procedure SzArchiveDatabaseInit(var db: TArchiveDatabase);
  begin
       FillChar(db, SizeOf(db), 0);
  end;
//==============================================================================
// Name: SzByteBufferCreate
//==============================================================================
  function SzByteBufferCreate(var Buffer: TSzByteBuffer; NewCapacity: Word): Boolean;
  begin
       Result := True;
       Buffer.Capacity := NewCapacity;
       if (NewCapacity = 0) then
       begin
            Buffer.Items := nil;
            Exit;
       end;
       GetMem(Buffer.Items, NewCapacity);
  end;
//==============================================================================
// Name: SzReadNumber32
//==============================================================================
  function SzReadNumber32(var sd: TSzData): UInt32;
  var Value64: UInt64;
  begin
       Value64 := SzReadNumber(sd);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       {
       if (Value64 >= $80000000) then
       begin
            hr := SZE_NOTIMPL;
            Exit;
       end;
       }
       // ((UInt64)(1) << ((sizeof(size_t) - 1) * 8 + 2)) = $04000000
       if (Value64 >= $04000000) then
       begin
            hr := SZE_NOTIMPL; Result := hr;
            Exit;
       end;
       Result := UInt32(Value64);
       hr := SZ_OK;
  end;
//==============================================================================
// Name: SzReadSwitch
//==============================================================================
  procedure SzReadSwitch(var sd: TSzData);
  var B: Byte;
  begin
       B := SzReadByte(sd);
       {RINOK}if (hr <> 0) then Exit;
       if B = 0 then hr := SZ_OK else hr := SZE_ARCHIVE_ERROR;
  end; 
//==============================================================================
// Name: SzSkeepDataSize & SzSkeepData
//==============================================================================
  procedure SzSkeepDataSize(var sd: TSzData; Size: UInt64);
  begin
       if Size > sd.Size then
       begin
            hr := SZE_ARCHIVE_ERROR;
            Exit;
       end;
       Inc(sd.Data,Size);
       Dec(sd.Size,Size);
  end;

  procedure SzSkeepData(var sd: TSzData);
  var Size: UInt64;
  begin
       Size := SzReadNumber(sd);
       {RINOK}if (hr <> 0) then Exit;
       SzSkeepDataSize(sd, Size);
  end;
//==============================================================================
// Name: SzWaitAttribute
//==============================================================================
  procedure SzWaitAttribute(var sd: TSzData; Attribute: UInt64);
  var _Type: UInt64;
  begin
       while True do
       begin
            _Type := SzReadID(sd);
            {RINOK}if (hr <> 0) then Exit;
            if _Type = Attribute then
            begin
                 hr := SZ_OK;
                 Exit;
            end;
            if _Type = k7zIdEnd then
            begin
                 hr := SZE_ARCHIVE_ERROR;
                 Exit;
            end;
            SzSkeepData(sd);
            {RINOK}if (hr <> 0) then Exit;
       end;
  end;
//==============================================================================
// Name: SzCoderInfoInit
//==============================================================================
  procedure SzCoderInfoInit(var Coder: TCoderInfo);
  begin
       FillChar(Coder, SizeOf(Coder), 0);
  end;
//==============================================================================
// Name: SzArDbGetFolderStreamPos
//==============================================================================
  function SzArDbGetFolderStreamPos(var db: TArchiveDatabaseEx;
               var FolderIndex: UInt32; IndexInFolder: UInt32): TFileSize;
  begin
       Result := db.ArchiveInfo.DataStartPosition +
         db.PackStreamStartPositions[db.FolderStartPackStreamIndex[FolderIndex]+IndexInFolder];
  end;
//==============================================================================
// Name: SzFolderFindBindPairForInStream
//==============================================================================
  function SzFolderFindBindPairForInStream(var Folder: TFolder; InStreamIndex: UInt32): Integer;
  var i: UInt32;
  begin
       i := 0;
       while i<Folder.NumBindPairs do
       begin
            if Folder.BindPairs[i].InIndex = InStreamIndex then
            begin
                 Result := i;
                 Exit;
            end;
            Inc(i);
       end;
       Result := -1;
  end;                     
//==============================================================================
// Name: SzFolderFindBindPairForOutStream
//==============================================================================
  function SzFolderFindBindPairForOutStream(var Folder: TFolder; OutStreamIndex: UInt32): Integer;
  var i: UInt32;
  begin
       i := 0;
       while i<Folder.NumBindPairs do
       begin
            if Folder.BindPairs[i].InIndex = OutStreamIndex then
            begin
                 Result := i;
                 Exit;
            end;
            Inc(i);
       end;
       Result := -1;
  end;
//==============================================================================
// Name: SzFolderGetNumOutStreams
//==============================================================================
  function SzFolderGetNumOutStreams(var Folder: TFolder): UInt32;
  var i: UInt32;
  begin
       Result := 0;
       for i := 0 to Folder.NumCoders-1 do
            Inc(Result, Folder.Coders[i].NumOutStreams);
  end;
//==============================================================================
// Name: SzFolderGetUnPackSize
//==============================================================================
  function SzFolderGetUnPackSize(var Folder: TFolder): TFileSize;
  var i: Integer;
  begin
       i := SzFolderGetNumOutStreams(Folder);
       if i = 0 then begin Result := 0; Exit; end;
       Dec(i);
       while i>=0 do
       begin
            if SzFolderFindBindPairForOutStream(Folder, i) < 0 then
            begin
                 Result := Folder.UnPackSizes[i];
                 Exit;
            end;
            Dec(i);
       end;
       Result := 0;
  end;
//==============================================================================
// Name: SzGetNextFolderItem
//==============================================================================
  function SzGetNextFolderItem(var sd: TSzData; var Folder: TFolder): SZ_RESULT;
  var
    i,j: Integer;
    n,pi: UInt32;
    MainByte: Byte;
    NumCoders: UInt32;
    NumBindPairs: UInt32;
    NumPackedStreams: UInt32;
    NumInStreams: UInt32;
    NumOutStreams: UInt32;
    PropertiesSize: UInt64;
  begin
       NumInStreams := 0;
       NumOutStreams := 0;
       
       NumCoders := SzReadNumber32(sd);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       Folder.NumCoders := NumCoders;

       SetLength(Folder.Coders, NumCoders);

       for i := 0 to NumCoders-1 do
            SzCoderInfoInit(Folder.Coders[i]);

       for i := 0 to NumCoders-1 do
       begin
            MainByte := SzReadByte(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            Folder.Coders[i].MethodID.IDSize := MainByte and $F;
            for j := 1 to Folder.Coders[i].MethodID.IDSize do
            begin
                 Folder.Coders[i].MethodID.ID[j-1] := SzReadByte(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            end;
            if (MainByte and $10) <> 0 then
            begin
                 Folder.Coders[i].NumInStreams := SzReadNumber32(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 Folder.Coders[i].NumOutStreams := SzReadNumber32(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            end else
            begin
                 Folder.Coders[i].NumInStreams := 1;
                 Folder.Coders[i].NumOutStreams := 1;
            end;
            if (MainByte and $20) <> 0 then
            begin
                 PropertiesSize := SzReadNumber(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 SzByteBufferCreate(Folder.Coders[i].Properties, PropertiesSize);
                 SzReadBytes(sd, PropertiesSize, Folder.Coders[i].Properties.Items);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            end;
            while (MainByte and $80) <> 0 do
            begin
                 MainByte := SzReadByte(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 SzSkeepDataSize(sd, (MainByte and $F));
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 if (MainByte and $10) <> 0 then
                 begin
                      n := SzReadNumber32(sd);
                      {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                      n := SzReadNumber32(sd);
                      {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 end;
                 if (MainByte and $20) <> 0 then
                 begin
                      PropertiesSize := SzReadNumber(sd);
                      {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                      SzSkeepDataSize(sd, PropertiesSize);
                      {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 end;
            end;
            Inc(NumInStreams,Folder.Coders[i].NumInStreams);
            Inc(NumOutStreams,Folder.Coders[i].NumOutStreams);
       end;

       NumBindPairs := NumOutStreams - 1;
       Folder.NumBindPairs := NumBindPairs;

       SetLength(Folder.BindPairs, NumBindPairs);

       i := 0;
       while i < NumBindPairs do
       begin
            Folder.BindPairs[i].InIndex := SzReadNumber32(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            Folder.BindPairs[i].OutIndex := SzReadNumber32(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            Inc(i);
       end;

       NumPackedStreams := NumInStreams - NumBindPairs;
       Folder.NumPackStreams := NumPackedStreams;

       SetLength(Folder.PackStreams, NumPackedStreams);

       if NumPackedStreams = 1 then
       begin
            pi := 0;
            for j := 0 to NumInStreams-1 do
            begin
                 if (SzFolderFindBindPairForInStream(folder, j) < 0) then
                 begin
                      Folder.PackStreams[pi] := j;
                      //Inc(pi);
                      Break;
                 end;
            end;
       end else
       begin
            for i := 0 to NumPackedStreams-1 do
            begin
                 Folder.PackStreams[i] := SzReadNumber32(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            end;
       end;
       Result := SZ_OK;
  end;
//==============================================================================
// Name: SzReadBoolVector
//==============================================================================
  function SzReadBoolVector(var sd: TSzData; var NumItems: UInt32;
                            var v: TByteArray): SZ_RESULT;
  var
    B,Mask: Byte;
    i: Integer;
  begin
       Mask := 0; B := 0;
       SetLength(v, NumItems);
       for i := 0 to NumItems-1 do
       begin
            if Mask = 0 then
            begin
                 B := SzReadByte(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 Mask := $80;
            end;
            if (B and Mask) <> 0 then v[i] := 1 else v[i] := 0;
            Mask := Mask shr 1;
       end;
       Result := SZ_OK;
  end;
//==============================================================================
// Name: SzReadBoolVector2
//==============================================================================
  function SzReadBoolVector2(var sd: TSzData; var NumItems: UInt32;
                             var  v: TByteArray): SZ_RESULT;
  var
    i: Integer;
    AllAreDefined: Byte;
  begin
       AllAreDefined := SzReadByte(sd);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       if AllAreDefined = 0 then
       begin
            Result := SzReadBoolVector(sd, NumItems, v);
            Exit;
       end;
       SetLength(v, NumItems);
       for i := 0 to NumItems-1 do v[i] := 1;
       Result := SZ_OK;
  end;
//==============================================================================
// Name: SzReadHashDigests
//==============================================================================
  function SzReadHashDigests(var sd: TSzData; var NumItems: UInt32;
                             var DigestsDefined: TByteArray;
                             var Digests: TUInt32Array): SZ_RESULT;
  var i: Integer;
  begin
       SzReadBoolVector2(sd, NumItems, DigestsDefined);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       SetLength(Digests, NumItems);
       for i := 0 to NumItems-1 do
       if DigestsDefined[i] = 1 then
       begin
            Digests[i] := SzReadUInt32(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       end;
       Result := SZ_OK;
  end;
//==============================================================================
// Name: SzReadUnPackInfo
//==============================================================================
  function SzReadUnPackInfo(var sd: TSzData;
                            var NumFolders: UInt32;
                            var Folders: TFolderArray): SZ_RESULT;
  var
    i,j : Integer;
    NumOutStreams: UInt32;
    _Type: UInt64;
    Res: SZ_RESULT;
    CRCsDefined: TByteArray;
    CRCs: TUInt32Array;
  begin
       SzWaitAttribute(sd, k7zIdFolder);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       NumFolders := SzReadNumber32(sd);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       SzReadSwitch(sd);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;

       SetLength(Folders, NumFolders);

       for i := 0 to NumFolders-1 do
            FillChar(Folders[i], SizeOf(TFolder), 0); //SzFolderInit(Folders[i]);

       for i := 0 to NumFolders-1 do
       begin
            SzGetNextFolderItem(sd,Folders[i]);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       end;

       SzWaitAttribute(sd, k7zIdCodersUnPackSize);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;

       for i := 0 to NumFolders-1 do
       begin
            NumOutStreams := SzFolderGetNumOutStreams(Folders[i]);
            SetLength(Folders[i].UnPackSizes, NumOutStreams);
            for j := 0 to NumOutStreams-1 do
            begin
                 Folders[i].UnPackSizes[j] := SzReadSize(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            end;
       end;

       while True do
       begin
            _Type := SzReadID(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            if _Type = k7zIdEnd then
            begin
                 Result := SZ_OK; hr := SZ_OK;
                 Exit;
            end;
            if _Type = k7zIdCRC then
            begin
                 Res := SzReadHashDigests(sd, NumFolders, CRCsDefined, CRCs);
                 if Res = SZ_OK then
                 begin
                      for i := 0 to NumFolders-1 do
                      begin
                           Folders[i].UnPackCrcDefined := CRCsDefined[i];
                           Folders[i].UnPackCRC := CRCs[i];
                      end;
                 end;
                 CRCsDefined := nil;
                 CRCs := nil;
                 Continue;
            end;
            SzSkeepData(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       end;
  end;

//==============================================================================
// Name: SzReadPackInfo
//==============================================================================
  function SzReadPackInfo(var sd: TSzData; var DataOffset: TFileSize;
                          var NumPackStreams: UInt32;
                          var PackSizes: TFileSizeArray;
                          var PackCRCsDefined: TByteArray;
                          var PackCRCs: TUInt32Array): SZ_RESULT;
  var
    i: UInt32;
    _Type: UInt64;
  begin
       DataOffset := SzReadSize(sd);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       NumPackStreams := SzReadNumber32(sd);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       SzWaitAttribute(sd, k7zidSize);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;

       SetLength(PackSizes, NumPackStreams);

       for i := 0 to NumPackStreams-1 do
       begin
            PackSizes[0] := SzReadSize(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       end;

       while True do
       begin
            _Type := SzReadID(sd);
            if _Type = k7zIdEnd then Break;
            if _Type = k7zIdCRC then
            begin
                 SzReadHashDigests(sd, NumPackStreams, PackCRCsDefined, PackCRCs);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 Continue;
            end;
            SzSkeepData(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       end;

       if Length(PackCRCsDefined) = 0 then
       begin
            SetLength(PackCRCsDefined, NumPackStreams);
            SetLength(PackCRCs, NumPackStreams);
            for i := 0 to NumPackStreams-1 do
            begin
                 PackCRCsDefined[i] := 0;
                 PackCRCs[i] := 0;
            end;
       end;
       Result := SZ_OK;
  end;
//==============================================================================
// Name: SzReadSubStreamsInfo
//==============================================================================
  function SzReadSubStreamsInfo(var sd: TSzData; var NumFolders: UInt32;
                                var Folders: TFolderArray;
                                var NumUnPackStreams: UInt32;
                                var UnPackSizes: TFileSizeArray;
                                var DigestsDefined: TByteArray;
                                var Digests: TUInt32Array): SZ_RESULT;
  var
    _Type: UInt64;
    i,j: Integer;
    Res: SZ_RESULT;
    si, NumDigests: UInt32;
    NumStreams: UInt32;
    Sum, Size: TFileSize;
    NumSubStreams: UInt32;
    DigestsIndex: Integer;
    DigestsDefined2: TByteArray;
    Digests2: TUInt32Array;
  begin
       _Type := 0;
       si := 0;
       NumDigests := 0;

       for i := 0 to NumFolders-1 do
            Folders[i].NumUnPackStreams := 1;
       NumUnPackStreams := NumFolders;

       while True do
       begin
            _Type := SzReadID(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            if _Type = k7zIdnumUnPackStream then
            begin
                 NumUnPackStreams := 0;
                 for i := 0 to NumFolders-1 do
                 begin
                      NumStreams := SzReadNumber32(sd);
                      {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                      Folders[i].NumUnPackStreams := NumStreams;
                      Inc(NumUnPackStreams, NumStreams);
                 end;
                 Continue;
            end;
            if (_Type = k7zIdCRC) or (_Type = k7zIdSize) then Break;
            if (_Type = k7zIdEnd)then Break;
            SzSkeepData(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       end;

       if NumUnPackStreams = 0 then
       begin
            UnPackSizes := nil;
            DigestsDefined := nil;
            Digests := nil;
       end else
       begin
            SetLength(unPackSizes, NumUnPackStreams);
            SetLength(DigestsDefined, NumUnPackStreams);
            SetLength(Digests, NumUnPackStreams);
       end;

       for i := 0 to numFolders-1 do
       begin
            NumSubStreams := Folders[i].NumUnPackStreams;
            if NumSubStreams = 0 then Continue;
            Sum := 0;
            if _Type = k7zIdSize then
            for j := 1 to NumSubStreams-1 do
            begin
                 Size := SzReadSize(sd);
                 UnPackSizes[si] := Size;
                 Inc(si);
                 Inc(Sum, Size);
            end;
            UnPackSizes[si] := SzFolderGetUnPackSize(Folders[i]) - Sum;
       end;

       if _Type = k7zIdSize then
       begin
            _Type := SzReadID(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       end;

       for i := 0 to NumUnPackStreams-1 do
       begin
            DigestsDefined[i] := 0;
            Digests[i] := 0;
       end;

       for i := 0 to NumFolders-1 do
       begin
            NumSubStreams := Folders[i].NumUnPackStreams;
            if (NumSubStreams <> 0)or(Folders[i].UnPackCrcDefined = 0)then
                 Inc(NumDigests, NumSubStreams);
       end;

       si := 0;

       while True do
       begin
            if _Type = k7zIdCRC then
            begin
                 DigestsIndex := 0;
                 DigestsDefined2 := nil;
                 Digests2 := nil;
                 Res := SzReadHashDigests(sd, NumDigests, DigestsDefined2, Digests2);
                 if (Res = SZ_OK) then
                 begin
                      for i := 0 to NumFolders-1 do
                      begin
                           NumSubStreams := Folders[i].NumUnPackStreams;
                           if (NumSubStreams = 1)and(Folders[i].UnPackCrcDefined = 1)then
                           begin
                                DigestsDefined[si] := 1;
                                Digests[si] := Folders[i].UnPackCRC;
                                Inc(si);
                           end else
                           begin
                                for j := 0 to NumSubStreams-1 do
                                begin
                                     DigestsDefined[si] := DigestsDefined2[DigestsIndex];
                                     Digests[si] := Digests2[DigestsIndex];
                                     Inc(DigestsIndex);
                                     Inc(si);
                                end;
                           end;
                      end;
                 end;
                 Digests2 := nil;
                 DigestsDefined2 := nil;
                 {RINOK}if (Res <> 0) then begin Result := Res; hr := Res; Exit; end;
            end else
            if _Type = k7zIdEnd then
            begin
                 Result := SZ_OK; hr := SZ_OK;
                 Exit;
            end else
            begin
                 SzSkeepData(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
            end;
            _Type := SzReadID(sd);
            {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       end;
  end;

//==============================================================================
// Name: SzReadStreamsInfo
//==============================================================================
  function SzReadStreamsInfo(var sd: TSzData; var DataOffset: TFileSize;
                             var db: TArchiveDatabase;
                             var NumUnPackStreams: UInt32;
                             var UnPackSizes: TFileSizeArray;
                             var DigestsDefined: TByteArray;
                             var Digests: TUInt32Array): SZ_RESULT;
  var
    _Type: UInt64;
  begin
       while True do
       begin
            _Type := SzReadID(sd);
          //if ((UInt64)(int)type != type) return SZE_FAIL;
            case _Type of
            k7zIdEnd:
              begin
                   Result := SZ_OK;
                   Exit;
              end;
            k7zIdPackInfo:
              begin
                   SzReadPackInfo(sd, DataOffset, db.NumPackStreams,
                       db.PackSizes, db.PackCRCsDefined, db.PackCRCs);
                   {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
              end;
            k7zIdUnPackInfo:
              begin
                   SzReadUnPackInfo(sd, db.NumFolders, db.Folders);
              end;
            k7zIdSubStreamsInfo:
              begin
                    SzReadSubStreamsInfo(sd, db.NumFolders, db.Folders,
                        NumUnPackStreams, UnPackSizes, DigestsDefined, Digests);
              end;
            else
              begin
                   Result := SZE_FAIL;
                   Exit;
              end;
            end;
       end;
  end;

//==============================================================================
// Name: SzFolderUnPackSize
//==============================================================================
  function SzFolderUnPackSize(var Folder: TFolder): TFileSize;
  var
    i: Integer;
  begin
       i := SzFolderGetNumOutStreams(Folder);
       if i = 0 then
       begin
            Result := 0;
            Exit;
       end;
       Dec(i);
       while i>=0 do
       begin
            if SzFolderFindBindPairForOutStream(Folder, i) < 0 then
            begin
                 Result := Folder.UnPackSizes[i];
                 Exit; 
            end;
            Dec(i);
       end;
       Result := 0;
  end;
//==============================================================================
// Name: SzReadAndDecodePackedStreams
//==============================================================================
  function SzReadAndDecodePackedStreams(var sd: TSzData; var outBuffer: TSzByteBuffer;
                                        BaseOffset: TFileSize): SZ_RESULT;
  var
    db: TArchiveDatabase;
    UnPackSizes: TFileSizeArray;
    DigestsDefined: TByteArray;
    Digests: TUInt32Array;
    Res: SZ_RESULT;
    NumUnPackStreams: UInt32;
    DataStartPos: TFileSize;
    Folder: TFolder;
    UnPackSize: TFileSize;
    OutRealSize: UInt32;

    procedure MemoryDump(P: PByte; Size: TFileSize);
    var DumpFile: Text; S: String; B: Byte;
    begin
         AssignFile(DumpFile, 'dump.txt');
         Rewrite(DumpFile);
         while Size>0 do
         begin
              B := P^;
              Str(B,S);
              S := S + '   ';
              Writeln(DumpFile,S);
              Dec(Size);
              Inc(P);
         end;
         CloseFile(DumpFile);
    end;

  begin
       FillChar(db, SizeOf(db), 0); //SzArchiveDatabaseInit(db);

       SzReadStreamsInfo(sd, DataStartPos, db, NumUnPackStreams,
          UnPackSizes, DigestsDefined, Digests);
       {
       RINOK(SzReadStreamsInfo(sd, &dataStartPos, db,
       &numUnPackStreams,  unPackSizes, digestsDefined, digests,
       allocTemp->Alloc, allocTemp));
       }
       Inc(DataStartPos, BaseOffset);

       if db.NumFolders <> 1 then
       begin
            Result := SZE_ARCHIVE_ERROR;
            Exit;
       end;

       Folder := db.Folders[0];
       UnPackSize := SzFolderUnPackSize(Folder);

       Seek(Archive.ArchiveFile, DataStartPos);

       if not SzByteBufferCreate(outBuffer, UnPackSize) then
       begin
            Result := SZE_OUTOFMEMORY;
            Exit;
       end;

       Res := SzDecode(db.PackSizes, Folder, outBuffer.Items, UnpackSize, OutRealSize);
       if Res <> SZ_OK then begin Result := Res; hr := Res; Exit; end;

       if OutRealSize <> UnPackSize then
       begin
            Result := SZE_FAIL; hr := SZE_FAIL;
            Exit;
       end;

       if Folder.UnPackCrcDefined = 1 then
       begin
            if not CrcVerifyDigest(Folder.UnPackCRC, OutBuffer.Items, UnPackSize)then
            begin
                 Result := SZE_FAIL; hr := SZE_FAIL;
                 Exit;
            end;
       end; 

     //Как очистить память, занятую переменной db ?
       UnPackSizes := nil;
       DigestsDefined := nil;
       Digests := nil;
       Result := SZ_OK;
  end;
//==============================================================================
// Name: SzReadArchiveProperties
//==============================================================================
   function SzReadArchiveProperties(var sd: TSzData): SZ_RESULT;
   var _Type: UInt64;
   begin
        while True do
        begin
             _Type := SzReadID(sd);
             {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
             if _Type = k7zIdEnd then Break;
             SzSkeepData(sd);
        end;
        Result := SZ_OK;
   end;
//==============================================================================
// Name: SzArDbExFill
//==============================================================================
   function SzArDbExFill(var db: TArchiveDatabaseEx): SZ_RESULT;
   var
     StartPos: Uint32;
     StartPosSize: TFileSize;
     i: Integer;
     FolderIndex: UInt32;
     IndexInFolder: UInt32;
     EmptyStream: Integer;
   begin
        StartPos := 0;
        StartPosSize := 0;
        FolderIndex := 0;
        IndexInFolder := 0;
        SetLength(db.FolderStartPackStreamIndex, db.Database.NumFolders);
        for i := 0 to db.Database.NumFolders-1 do
        begin
             db.FolderStartPackStreamIndex[i] := startPos;
             Inc(StartPos, db.Database.Folders[i].NumPackStreams);
        end;
        SetLength(db.PackStreamStartPositions, db.Database.NumPackStreams);
        for i := 0 to db.Database.NumPackStreams-1 do
        begin
             db.PackStreamStartPositions[i] := StartPosSize;
             Inc(StartPosSize, db.Database.PackSizes[i]);
        end;
                
        SetLength(db.FolderStartFileIndex, db.Database.NumFolders);
        SetLength(db.FileIndexToFolderIndexMap, db.Database.NumFiles);

        for i := 0 to db.Database.NumFiles-1 do
        begin
             EmptyStream := not db.Database.Files[i].HasStream;
             if (EmptyStream = 1)and(IndexInFolder=0) then
             begin
                  db.FileIndexToFolderIndexMap := nil; // ??? UInt32(-1);
                  Continue;
             end;
             if IndexInFolder = 0 then
             begin
                  while True do
                  begin
                       if FolderIndex >= db.Database.NumFolders then
                       begin
                            Result := SZE_ARCHIVE_ERROR; hr := SZE_ARCHIVE_ERROR;
                            Exit;
                       end;
                       db.FolderStartFileIndex[FolderIndex] := i;
                       if db.Database.Folders[FolderIndex].NumUnPackStreams <> 0 then Break;
                       Inc(FolderIndex);
                  end;
             end;
             db.FileIndexToFolderIndexMap[i] := FolderIndex;
             if EmptyStream = 1 then Continue;
             Inc(IndexInFolder);
             if IndexInFolder >= db.Database.Folders[FolderIndex].NumUnPackStreams then
             begin
                  Inc(FolderIndex);
                  IndexInFolder := 0;
             end;
        end;
        Result := SZ_OK; hr := SZ_OK;
   end;
//==============================================================================
// Name: SzReadFileNames
//==============================================================================
    function SzReadFileNames(var sd: TszData; NumFiles: Uint32; Files: TFileItemArray): SZ_RESULT;
   var
     i, numAdds: Integer;
     len, pos, value, c2: UInt32;
     Temp: PByte;
   begin
        for i := 0 to NumFiles-1 do
        begin
             len := 0;
             pos := 0;
             while (pos + 2 <= sd.Size) do
             begin
                  Temp := sd.Data;
                  Inc(Temp,pos);
                  Value := Temp^;
                  Temp := sd.Data;
                  Inc(temp,pos+1);
                  Value := Value or (Temp^ shl 8);

                  Inc(pos,2);
                  Inc(len);
                  if Value = 0 then Break;
                  if Value < $80 then Continue;
                  if (Value >= $D800) and (Value < $E000) then
                  begin
                       if Value >= $DC00 then
                       begin
                            Result := SZE_ARCHIVE_ERROR; hr := SZE_ARCHIVE_ERROR;
                            Exit;
                       end;
                       if (pos + 2 > sd.Size) then
                       begin
                            Result := SZE_ARCHIVE_ERROR; hr := SZE_ARCHIVE_ERROR;
                            Exit;
                       end;

                       Temp := sd.Data;
                       Inc(Temp,pos);
                       c2 := Temp^;
                       Temp := sd.Data;
                       Inc(temp,pos+1);
                       c2 := c2 or (Temp^ shl 8);

                       Inc(pos,2);
                       if (c2 < $DC00) or (c2 >= $E000) then
                       begin
                            Result := SZE_ARCHIVE_ERROR; hr := SZE_ARCHIVE_ERROR;
                            Exit;
                       end;
                       Value := ((Value - $D800)shl 10) or (c2 - $DC00);
                  end;
                  for numAdds := 1 to 4 do
                       if Value < (1 shl (numAdds*5+6))then Break;
                  Inc(Len,numAdds);
             end;
             SetLength(Files[i].Name, Len);
             Len := 0;
             while (2 <= sd.Size) do
             begin
                  Temp := sd.Data;
                  Value := Temp^;
                  Inc(Temp);
                  Value := Value or (Temp^ shl 8);
                  SzSkeepDataSize(sd, 2);
                  if Value < $80 then
                  begin
                       Files[i].Name[Len+1] := Chr(Byte(Value));
                       Inc(Len);
                       if Value = 0 then Break;
                       Continue;
                  end;
                  if (Value >= $D800)and(Value <= $E000) then
                  begin
                       Temp := sd.Data;
                       c2 := Temp^;
                       Inc(Temp);
                       c2 := c2 or (Temp^ shl 8);
                       SzSkeepDataSize(sd, 2);
                       Value := ((Value - $D800)shl 10) or (c2 - $DC00);
                  end;
                  for NumAdds := 1 to 4 do
                       if Value < (1 shl (numAdds*5+6))then Break;
                  Files[i].Name[Len+1] := Chr(Byte(kUtf8Limits[NumAdds-1] + (Value shr (6*numAdds))));
                  Inc(Len);
                  repeat
                       Dec(NumAdds);
                       Files[i].Name[Len+1] := Chr(Byte($80 + ((Value shr (6*NumAdds))and $3F)));
                       Inc(Len);
                  until not (NumAdds > 0);
                  Inc(Len,NumAdds);
             end;
        end;
        Result := SZ_OK;
   end;
//==============================================================================
// Name: SzReadHeader
//==============================================================================
   function SzReadHeader(var sd: TSzData; var db: TArchiveDatabaseEx): SZ_RESULT;
   var
     _Type, Size: UInt64;
     NumUnPackStreams: UInt32;
     NumFiles: UInt32;
     Files: TFileItemArray;
     NumEmptyStreams: UInt32;
     EmptyFileIndex: UInt32;
     SizeIndex: UInt32;
     i: Integer;
     UnPackSizes: TFileSizeArray;
     DigestsDefined: TByteArray;
     Digests: TUInt32Array;
     EmptyStreamVector: TByteArray;
     EmptyFileVector: TByteArray;
   begin
        _Type := SzReadID(sd);
        {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;

        if (_Type = k7zIdArchiveProperties) then
        begin
             SzReadArchiveProperties(sd);
             {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
             _Type := SzReadID(sd);
             {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
        end;

        if (_Type = k7zIdMainStreamsInfo) then
        begin
             SzReadStreamsInfo(sd,db.ArchiveInfo.DataStartPosition,db.Database,
               NumUnPackStreams, UnPackSizes, DigestsDefined, Digests);
             Inc(db.ArchiveInfo.DataStartPosition,db.ArchiveInfo.StartPositionAfterHeader);
             _Type := SzReadID(sd);
             {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
        end;

        if _Type = k7zIdEnd then
        begin
             Result := SZ_OK; hr := SZ_OK;
             Exit;
        end;

        if _Type <> k7zIdFilesInfo then
        begin
             Result := SZE_ARCHIVE_ERROR; hr := SZE_ARCHIVE_ERROR;
             Exit;
        end;

        NumFiles := SzReadNumber32(sd);
        {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;

        db.Database.NumFiles := NumFiles;

        SetLength(Files, NumFiles);

        for i := 0 to NumFiles-1 do
        begin
             // SzFileInit
             FillChar(Files[i],SizeOf(Files[i]),0);
             Files[i].HasStream := 1;
        end;

        while True do
        begin
             _Type := SzReadID(sd);
             {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
             if _Type = k7zIdEnd then Break;
             Size := SzReadNumber(sd);
             {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
           //if ((UInt64)(int)type != type)
           //{
           //  RINOK(SzSkeepDataSize(sd, size));
           //}
             case _Type of
             k7zIdName:
               begin
                    SzReadSwitch(sd);
                    {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                    SzReadFileNames(sd, NumFiles, Files);
                    {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
               end;
             k7zIdEmptyStream:
               begin
                    SzReadBoolVector(sd, NumFiles, EmptyStreamVector);
                    {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                    NumEmptyStreams := 0;
                    for i := 0 to NumFiles-1 do
                         if EmptyStreamVector[i] = 1 then
                              Inc(NumEmptyStreams);
               end;
             k7zIdEmptyFile:
               begin
                    SzReadBoolVector(sd, NumEmptyStreams, EmptyFileVector);
                    {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
               end;
             else
               begin
                    SzSkeepDataSize(sd, Size);
                    {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
               end;
             end;
        end;

        EmptyFileIndex := 0;
        SizeIndex := 0;

        for i := 0 to NumFiles-1 do
        begin
             Files[i].IsAnti := 0;
             if EmptyStreamVector = nil then
                  Files[i].HasStream := 1 else
             if EmptyStreamVector[i] = 1 then
                  Files[i].HasStream := 0 else Files[i].HasStream := 1;
             if Files[i].HasStream = 1 then
             begin
                  Files[i].IsDirectory := 0;
                  Files[i].Size := UnPackSizes[sizeIndex];
                  Files[i].FileCRC := Digests[sizeIndex];
                  Files[i].IsFileCRCDefined := DigestsDefined[sizeIndex];
                  Inc(sizeIndex);
             end else
             begin
                  if EmptyFileVector = nil then
                       Files[i].IsDirectory := 1 else
                  if EmptyFileVector[emptyFileIndex] = 1 then
                       Files[i].IsDirectory := 0 else Files[i].IsDirectory := 1;
                  Inc(emptyFileIndex);
                  Files[i].Size := 0;
                  Files[i].IsFileCRCDefined := 0;
             end;
        end;

        db.Database.Files := Files;
        SzArDbExFill(db);
         
        UnPackSizes := nil;
        DigestsDefined := nil;
        Digests := nil;
        EmptyStreamVector := nil;
        EmptyFileVector := nil;
        Result := SZ_OK;
        //  return SzArDbExFill(db, allocMain->Alloc);
   end;
//==============================================================================
// Name: SzArchiveOpen
//==============================================================================
  function SzArchiveOpen(var db: TArchiveDatabaseEx): Integer;
  var
    Version: Byte;
    _Type: UInt64;
    Crc: UInt32;
    sd: TSzData;
    CrcFromArchive: UInt32;
    NextHeaderOffset: UInt64;
    NextHeaderSize: UInt64;
    NextHeaderCRC: UInt64;
    Buffer: TSzByteBuffer;
    outBuffer: TSzByteBuffer;
    Res: SZ_RESULT;
  begin
       Res := SZ_OK;

       // Проверка корректности первых шести байт.
       if (ReadByte <> k7zSignature[0]) or
          (ReadByte <> k7zSignature[1]) or
          (ReadByte <> k7zSignature[2]) or
          (ReadByte <> k7zSignature[3]) or
          (ReadByte <> k7zSignature[4]) or
          (ReadByte <> k7zSignature[5]) then
       begin
            Result := SZE_ARCHIVE_ERROR;
            Exit;
       end;

       // Проверка версии архива
       Version := ReadByte;
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       if (Version <> k7zMajorVersion) then
       begin
            Result := SZE_ARCHIVE_ERROR;
            Exit;
       end;
       Version := ReadByte;
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;

       CrcFromArchive := ReadUInt32;
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;

       CrcInit(Crc);

       NextHeaderOffset := ReadUInt64;
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       CrcUpdateUInt64(Crc, NextHeaderOffset);
       NextHeaderSize := ReadUInt64;
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       CrcUpdateUInt64(Crc, NextHeaderSize);
       NextHeaderCRC := ReadUInt32;
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
       CrcUpdateUInt32(Crc, NextHeaderCRC);

       Archive.Database.ArchiveInfo.StartPositionAfterHeader := k7zStartHeaderSize;

       if CrcGetDigest(Crc) <> CrcFromArchive then
       begin
            Result := SZE_ARCHIVE_ERROR;
            Exit;
       end;

       if NextHeaderSize = 0 then
       begin
            Result := SZ_OK;
            Exit;
       end;

       Seek(Archive.ArchiveFile, TFileSize(k7zStartHeaderSize + NextHeaderOffset));

       SzByteBufferCreate(Buffer, NextHeaderSize);
       ReadBytes(NextHeaderSize, Buffer.Items);
       {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;

       if CrcVerifyDigest(NextHeaderCRC, Buffer.Items, NextHeaderSize) then
       begin
            while True do
            begin
                 sd.Data := Buffer.Items;
                 sd.Size := Buffer.Capacity;
                 _Type := SzReadID(sd);
                 {RINOK}if (hr <> 0) then begin Result := hr; Exit; end;
                 
                 if _Type = k7zIdHeader then
                 begin
                      Res := SzReadHeader(&sd, db);
                      Break;
                 end;
                 if _Type <> k7zIdEncodedHeader then
                 begin
                      Result := SZE_ARCHIVE_ERROR;
                 end;

                 hr := SzReadAndDecodePackedStreams(sd, outBuffer,
                           Archive.Database.ArchiveInfo.StartPositionAfterHeader);

                 if hr <> SZ_OK then
                 begin
                      FreeMem(outBuffer.Items, outBuffer.Capacity);
                      Result := hr;
                      Break;
                 end;

                 FreeMem(Buffer.Items, Buffer.Capacity);
                 Buffer.Items := outBuffer.Items;
                 Buffer.Capacity := outBuffer.Capacity;
            end;
       end;
       FreeMem(Buffer.Items, Buffer.Capacity);
       Result := Res;
     //  if Res <> SZ_OK then
     //       FreeMem(@db,SizeOf(db));
  end;
//==============================================================================
// Name: SzExtract
//==============================================================================
  function SzExtract(var db: TArchiveDatabaseEx; var FileIndex: UInt32;
                     var BlockIndex: Uint32; var OutBuffer: PByte;
                     var OutBufferSize: SizeT; var Offset: SizeT;
                     var OutSizeProcessed: SizeT): SZ_RESULT;
  var
    FolderIndex: UInt32;
    Folder: TFolder;
    UnPackSize: TFileSize;
    OutRealSize: SizeT;
    Res: SZ_RESULT;
    i: Integer;
    Temp: PByte;
  begin
       Res := SZ_OK;
       FolderIndex := db.FileIndexToFolderIndexMap[FileIndex];
       Offset := 0;
       OutSizeProcessed := 0;
       if FolderIndex = UInt32(-1)then
       begin
            BlockIndex := FolderIndex;
            outBuffer := nil;
            outBufferSize := 0;
            Result := SZ_OK;
            Exit;
       end;
       if (OutBuffer = nil)or(BlockIndex <> FolderIndex) then
       begin
            Folder := db.Database.Folders[FolderIndex];
            UnPackSize := SzFolderGetUnPackSize(Folder);
            BlockIndex := FolderIndex;
            OutBuffer := nil;
            Seek(Archive.ArchiveFile, Word(SzArDbGetFolderStreamPos(db, FolderIndex, 0)));
            OutBufferSize := UnPackSize;
            if UnPackSize <> 0 then
            begin
                 GetMem(OutBuffer, UnPackSize);
            end;
            Res := SzDecode(db.Database.PackSizes,//[db.FolderStartPackStreamIndex[FolderIndex]],
                     Folder, OutBuffer, UnPackSize, OutRealSize);
            if Res = SZ_OK then
            begin
                 if OutRealSize = UnPackSize then
                 begin
                      if Folder.UnPackCrcDefined = 1 then
                      begin
                           if not CrcVerifyDigest(Folder.UnPackCRC, OutBuffer, UnPackSize)then
                           begin
                                Result := SZE_FAIL;
                                Exit;
                           end;
                      end;
                 end;
            end else
            begin
                 Result := SZE_FAIL;
                 Exit;
            end;
       end;
       if Res = SZ_OK then
       begin
            i := db.FolderStartFileIndex[FolderIndex];
            while i < FileIndex do
            begin
                 Inc(Offset, db.Database.Files[i].Size);
                 Inc(i);
            end;
            OutSizeProcessed := db.Database.Files[FileIndex].Size;
            if (Offset + OutSizeProcessed > OutBufferSize) then
            begin
                 Result := SZE_FAIL;
                 Exit;
            end;
            if db.Database.Files[FileIndex].IsFileCRCDefined = 1 then
            begin
                 Temp := OutBuffer;
                 Inc(Temp, Offset);
                 if not CrcVerifyDigest(db.Database.Files[FileIndex].FileCRC, Temp, OutSizeProcessed) then
                 begin
                      Result := SZE_FAIL;
                      Exit;
                 end;
            end;
       end;
       Result := SZ_OK;
  end;
//==============================================================================
// Name: AssignArchive
//==============================================================================
  function AssignArchive(FileName: String): Integer;
  begin
       Assign(Archive.ArchiveFile, FileName);
       Reset(Archive.ArchiveFile, 1);
       InitCrcTable;
       FillChar(Archive.Database, SizeOf(Archive.Database), 0);
       Result := SzArchiveOpen(Archive.Database);
       _OutBuffer.Items := nil;
       SzByteBufferCreate(_OutBuffer, 1);
  end;
//==============================================================================
// Name: ExtractToMemory
//==============================================================================
  function ExtractToMemory(var Size: Longword; var Name: String): PByte;
  var
    Offset: Uint32;
    OutSizeProcessed: Uint32;
    Res: SZ_RESULT;
  begin
       if _i < Archive.Database.Database.NumFiles then
       begin
            Name := Archive.Database.Database.Files[_i].Name;
            Delete(Name,Length(Name),1);
            Res := SzExtract(Archive.Database, _i,
            BlockIndex, _OutBuffer.Items, Size,
            Offset, OutSizeProcessed);
            _OutBuffer.Capacity := OutSizeProcessed;
            Result := _OutBuffer.Items;
            Inc(Result, Offset);
            Inc(_i);
       end else
       begin
            Result := nil;
       end;
  end;
//==============================================================================
// Name: ExtractToMemory
//==============================================================================
  function CloseArchive(): Integer;
  begin
       FreeMem(_OutBuffer.Items);
       Archive.Database.Database.PackSizes := nil;
       Archive.Database.Database.PackCRCsDefined := nil;
       Archive.Database.Database.PackCRCs := nil;
       Archive.Database.Database.Folders := nil;
       Archive.Database.Database.Files := nil;
       CloseFile(Archive.ArchiveFile);
       Result := 0;
  end;

end.
