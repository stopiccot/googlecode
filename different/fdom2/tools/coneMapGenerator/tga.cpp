#include <iostream>

typedef unsigned char byte;

void *loadTGA(const wchar_t *FileName, int *width, int *height)
{
	byte TGA_Header[]    = {0, 0,  2, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	byte TGA_RLEHeader[] = {0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	byte header[12];
	bool RLE = false;

	FILE *input;
	_wfopen_s(&input, FileName, L"rb");
	if (!input) return NULL;

	fread(header, 1, 12, input);

	if ( !memcmp(header, TGA_RLEHeader, 12) ) RLE = true;
	else if ( !memcmp(header, TGA_Header, 12) ) RLE = false;
	else
	{
		fclose(input);
		return 0;
	}

	unsigned int Width = 0, Height = 0;
	fread(&Width,  2, 1, input);
	fread(&Height, 2, 1, input);

	byte PixelDepth;
	fread( &PixelDepth, 1, 1, input); PixelDepth /= 8;

	byte Dummy;
	fread( &Dummy, 1, 1, input);

	int ImageSize = Width * Height * PixelDepth;
	byte *Data = new byte[ ImageSize ];

	if (RLE)
	{
		byte *Temp = new byte[ ImageSize ];
		fread(Temp, 1, ImageSize, input);

		int i = 0, j = 0;
		while (i < ImageSize)
		{
			if ( Temp[j] & 0x80 )
			{
				Temp[j] &= 0x7F;
				do
				{
					Data[ i++ ] = Temp[ j + 3 ]; Data[ i++ ] = Temp[ j + 2 ]; Data[ i++ ] = Temp[ j + 1 ];
					if (PixelDepth == 4) Data[ i++ ] = Temp[ j + 4 ];
				}
				while ( Temp[j]-- );
				j += PixelDepth + 1;
			}
			else
			{
				int k = Temp[j];
				do
				{
					Data[ i++ ] = Temp[ j + 3 ]; Data[ i++ ] = Temp[ j + 2 ]; Data[ i++ ] = Temp[ j + 1 ];
					if (PixelDepth == 4) Data[ i++ ] = Temp[ j + 4 ];
					j += PixelDepth;
				}
				while ( k-- );
				j++;
			}
		}
		delete [] Temp;
	}
	else
	{
		fread( Data, 1, ImageSize, input);

		for(long i = 0; i < ImageSize; i += PixelDepth)
		{
			byte Temp;
			Temp      = Data[i];
			Data[i]   = Data[i+2];
			Data[i+2] = Temp;
		}
	}
	fclose(input);

	*width  = Width;
	*height = Height;
	return (void*)Data;
}
