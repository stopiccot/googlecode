#include <iostream>
#include <math.h>
using namespace std;
typedef unsigned char byte;

void *loadTGA(const wchar_t *FileName, int *width, int *height);

byte *data;

int main(int argc, char* argv[])
{
	int w, h;
	data = (byte*)loadTGA(L"heightmap.tga", &w, &h);

	char der;

	int H, H1;
	double coneRatio;
	for (int i = 0; i < h; ++i)
		for (int j = 0; j < w; ++j)
		{
			byte temp         = data[3*(i*w+j)];
			data[3*(i*w+j)]   = 127 - (data[3*(i*w+j)+1] - 127);
			data[3*(i*w+j)+1] = 0xFF - temp;
		}
	/* // ConeMap
	for (int i1 = 0; i1 < h; ++i1)
	{
		for (int j1 = 0; j1 < w; ++j1)
		{
			if (j1 % 256 == 0)
				cout << i1 << " " << j1 << endl;

			H1 = data[3*(i1*w+j1)];
			coneRatio = 1.0;

			for (int i = 0; i < h; ++i)
				for (int j = 0; j < w; ++j)
				{
					H = data[3*(i*w+j)];
					if (H > H1)
						coneRatio = min(coneRatio, double(sqrt(double((i-i1)*(i-i1)+(j-j1)*(j-j1))))/double(H-H1));
				}

			data[3*(i1*w+j1)+1] = 255*coneRatio;
		}
	}
	*/
	/*
	for (int i = 0; i < h; ++i)
		for (int j = 0; j < w; ++j)
		{
			if (j == 0)
				der = data[3*(i*w + (j+1))] - data[3*(i*w + j)];
			else if (j == w - 1)
				der = data[3*(i*w + j)] - data[3*(i*w + (j-1))];
			else
				der = ( data[3*(i*w + (j+1))] - data[3*(i*w + (j-1))] ) / 2;

			data[3*(i*w + j) + 1] = 127 + der / 2;

			if (i == 0)
				der = data[3*(i*w + j)] - data[3*((i+1)*w + j)];
			else if (j == h - 1)
				der = data[3*(i*w + j)] - data[3*((i-1)*w + j)];
			else
				der = ( data[3*((i-1)*w + j)] - data[3*((i+1)*w + j)] ) / 2;

			data[3*(i*w + j) + 2] = 127 + der / 2;
		}
	*/

	byte TGA_Header[] = {0, 0,  2, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	FILE *output;
	_wfopen_s(&output, L"output.tga", L"wb");

	fwrite((void*)TGA_Header, 1, 12, output);
	fwrite((void*)&w, 2, 1, output);
	fwrite((void*)&h, 2, 1, output);

	byte b = 24;
	fwrite((void*)&b, 1, 1, output);

	b = 1;
	fwrite((void*)&b, 1, 1, output);

	fwrite((void*)data, 1, 3 * w * h, output);

	fclose(output);

	return 0;
}