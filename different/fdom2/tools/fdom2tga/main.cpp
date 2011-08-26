#include <iostream>
using namespace std;

typedef unsigned char byte;

int main(int argc, char* argv[])
{
	if (argc < 2) 
	{
		cout << "Usage: fdom2tga input.dat [out.tga]" << endl;
		return -1;
	}

	FILE *input, *output;

	fopen_s(&input, argv[1], "r");
	fopen_s(&output, argc == 3 ? argv[2] : "out.tga", "wb");

	int size;
	fscanf(input, "%d", &size);

	byte *data = new byte[ 3 * size * size ];

	for (int i = 0; i < size; i++)
		for (int j = 0; j < size; j++)
		{
			char c, R, G, B;
			fread((void*)&c, 1, 1, input);

			while ( c == 10 || c == 32)
				fread((void*)&c, 1, 1, input);
		
			switch (c)
			{
				case 'R': R = 255; G =   0; B =   0; break;
				case 'r': R = 127; G =   0; B =   0; break;
				case 'G': R =   0; G = 255; B =   0; break;
				case 'g': R =   0; G = 127; B =   0; break;
				case 'B': R =   0; G =   0; B = 255; break;
				case 'b': R =   0; G =   0; B = 127; break;
				case 'Y': R = 255; G = 255; B =   0; break;
				case 'y': R = 127; G = 127; B =   0; break;
				case 'O': R = 255; G = 127; B =   0; break;
				case 'o': R = 127; G =  63; B =   0; break;
				case 'C': R =   0; G = 255; B = 255; break;
				case 'c': R =   0; G = 127; B = 127; break;
				case 'N': R =   0; G = 127; B = 255; break;
				case 'n': R =   0; G =  63; B = 127; break;
				case 'W': R = 255; G = 255; B = 255; break;
				case 'K': R = 169; G = 169; B = 169; break;
				case 'k': R =  84; G =  84; B =  84; break;
				case 'w': R =   0; G =   0; B =   0; break;
				default: R = 255; G = 0; B = 180;
			}

			data[ 3 * ( size * (size - i - 1) + j ) + 0 ] = B;
			data[ 3 * ( size * (size - i - 1) + j ) + 1 ] = G;
			data[ 3 * ( size * (size - i - 1) + j ) + 2 ] = R;
		}

	byte TGA_Header[] = {0, 0,  2, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	fwrite((void*)TGA_Header, 1, 12, output);
	fwrite((void*)&size, 2, 1, output);
	fwrite((void*)&size, 2, 1, output);

	byte b = 24;
	fwrite((void*)&b, 1, 1, output);

	b = 1;
	fwrite((void*)&b, 1, 1, output);

	fwrite((void*)data, 1, 3 * size * size, output);

	fclose(output);
	fclose(input);

	return 0;
}