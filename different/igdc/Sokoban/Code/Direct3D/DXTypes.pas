
{$MINENUMSIZE 4}
{$ALIGN ON}

unit DXTypes;

interface

(*$HPPEMIT '#include "dxsdkver.h"' *)

uses Windows;

(*==========================================================================;
 *
 *  File:   dxsdkver.h
 *  Content:    DirectX SDK Version Include File
 *
 ****************************************************************************)
const
  _DXSDK_PRODUCT_MAJOR  = 9;
  {$EXTERNALSYM _DXSDK_PRODUCT_MAJOR}
  _DXSDK_PRODUCT_MINOR  = 12;
  {$EXTERNALSYM _DXSDK_PRODUCT_MINOR}
  _DXSDK_BUILD_MAJOR    = 589;
  {$EXTERNALSYM _DXSDK_BUILD_MAJOR}
  _DXSDK_BUILD_MINOR    = 0000;
  {$EXTERNALSYM _DXSDK_BUILD_MINOR}



(****************************************************************************
 *  Other files
 ****************************************************************************)
type
  // TD3DValue is the fundamental Direct3D fractional data type
  D3DVALUE = Single;
  {$EXTERNALSYM D3DVALUE}
  TD3DValue = D3DVALUE;
  {$NODEFINE TD3DValue}
  PD3DValue = ^TD3DValue;
  {$NODEFINE PD3DValue}

  D3DCOLOR = type DWord;
  {$EXTERNALSYM D3DCOLOR}
  TD3DColor = D3DCOLOR;
  {$NODEFINE TD3DColor}
  PD3DColor = ^TD3DColor;
  {$NODEFINE PD3DColor}

  _D3DVECTOR = packed record
    x: Single;
    y: Single;
    z: Single;
  end {_D3DVECTOR};
  {$EXTERNALSYM _D3DVECTOR}
  D3DVECTOR = _D3DVECTOR;
  {$EXTERNALSYM D3DVECTOR}
  TD3DVector = _D3DVECTOR;
  {$NODEFINE TD3DVector}
  PD3DVector = ^TD3DVector;
  {$NODEFINE PD3DVector}

  REFERENCE_TIME = LONGLONG;
  {$EXTERNALSYM REFERENCE_TIME}
  TReferenceTime = REFERENCE_TIME;
  {$NODEFINE TReferenceTime}
  PReferenceTime = ^TReferenceTime;
  {$NODEFINE PReferenceTime}


// ==================================================================
// Here comes generic Windows types for Win32 / Win64 compatibility
//

  UInt64 = Int64; // for a while

  //
  // The INT_PTR is guaranteed to be the same size as a pointer.  Its
  // size with change with pointer size (32/64).  It should be used
  // anywhere that a pointer is cast to an integer type. UINT_PTR is
  // the unsigned variation.
  //
  {$EXTERNALSYM INT_PTR}
  {$EXTERNALSYM UINT_PTR}
  {$EXTERNALSYM LONG_PTR}
  {$EXTERNALSYM ULONG_PTR}
  {$EXTERNALSYM DWORD_PTR}
  INT_PTR = Longint;
  UINT_PTR = LongWord;
  LONG_PTR = Longint;
  ULONG_PTR = LongWord;
  DWORD_PTR = LongWord;
  PINT_PTR = ^INT_PTR;
  PUINT_PTR = ^UINT_PTR;
  PLONG_PTR = ^LONG_PTR;
  PULONG_PTR = ^ULONG_PTR;

  PtrInt = Longint;
  PtrUInt = Longword;
  PPtrInt = ^PtrInt;
  PPtrUInt = ^PtrUInt;

  //
  // SIZE_T used for counts or ranges which need to span the range of
  // of a pointer.  SSIZE_T is the signed variation.
  //
  {$EXTERNALSYM SIZE_T}
  {$EXTERNALSYM SSIZE_T}
  SIZE_T = ULONG_PTR;
  SSIZE_T = LONG_PTR;
  PSIZE_T = ^SIZE_T;
  PSSIZE_T = ^SSIZE_T;

  SizeInt = SSIZE_T;
  SizeUInt = SIZE_T;
  PSizeInt = PSSIZE_T;
  PSizeUInt = PSIZE_T;

implementation

end.

