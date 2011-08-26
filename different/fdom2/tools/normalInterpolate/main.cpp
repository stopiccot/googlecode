#include <iostream>
#include <map>
#include <fstream>
using namespace std;

struct vector3
{
	double x, y, z;

	friend bool operator < (const vector3 &a, const vector3 &b)
	{
		if (a.x != b.x) return a.x < b.x;
		if (a.y != b.y) return a.y < b.y;
		return a.z < b.z;
	}

	friend istream& operator >> (istream& in, vector3& vec)
	{
		in >> vec.x >> vec.y >> vec.z;
		return in;
	}

	friend ostream& operator << (ostream& out, vector3& vec)
	{
		out << vec.x << " " << vec.y << " " << vec.z;
		return out;
	}
};

struct new_normal
{
	vector3 normal;
	int count;
};

int main()
{
	int nVertexes;
	vector3 vertex, normal;
	double texcoord_x, texcoord_y;
	map<vector3, new_normal*> normals;

	{
		ifstream input("input.txt");
		input >> nVertexes;

		for (int i = 0; i < nVertexes; ++i)
		{
			input >> vertex >> texcoord_x >> texcoord_y >> normal;
			new_normal* n = normals[vertex];
			
			if (!n)
			{
				n = new new_normal();
				n->normal.x = normal.x;
				n->normal.y = normal.y;
				n->normal.z = normal.z;
				normals[vertex] = n;
			}
			else
			{
				n->normal.x = (n->count * n->normal.x + normal.x) / double(n->count + 1);
				n->normal.y = (n->count * n->normal.y + normal.y) / double(n->count + 1);
				n->normal.z = (n->count * n->normal.z + normal.z) / double(n->count + 1);
				n->count++;
			}
		}

		input.close();
	}

	ifstream input("input.txt");
	ofstream output("output.txt");

	input >> nVertexes;
	output << nVertexes << endl;

	for (int i = 0; i < nVertexes; ++i)
	{
		input >> vertex >> texcoord_x >> texcoord_y >> normal;
		output << vertex << " " << texcoord_x << " " << texcoord_y << " " << normals[vertex]->normal << endl;
	}

	input.close();
	output.close();
}