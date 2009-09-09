#ifndef VERTEX_TYPES_H
#define VERTEX_TYPES_H

typedef union _float2 {
	struct {
		float x;
		float y;
	};
	struct {
		float u;
		float v;
	};
} float2;

typedef union _float3 {
	struct {
		float x;
		float y;
		float z;
	};
	struct {
		float r;
		float g;
		float b;
	};
} float3;

typedef union _float4 {
	struct {
		float x;
		float y;
		float z;
		float w;
	};
	struct {
		float r;
		float g;
		float b;
		float a;
	};
} float4;

typedef struct _float4x4 {
	union {
		struct {
			float _11, _12, _13, _14;
			float _21, _22, _23, _24;
			float _31, _32, _33, _34;
			float _41, _42, _43, _44;
		};
		float m[4][4];
	};

	// default constructor creates E
	_float4x4()
	{
		for (int i = 0; i < 4; ++i)
			for (int j = 0; j < 4; ++j)
				m[i][j] = (i == j) ? 1.0f : 0.0f;
	}
} float4x4;

typedef float4x4 matrix;

typedef struct _VertexType {
	enum
	{
		XYZUV,
	};
} VertexType;

struct VertexXYZUV
{
	float3 Pos;
	float2 Tex;
};


#endif