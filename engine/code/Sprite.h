#include "PythonBinding.h"
#include "AbstractRender.h"
#include <vector>
#include <string>
#include <map>

std::map<std::string, Texture*> textures;
std::map<std::string, Effect*> effects;

class Sprite : public PyObject
{
		static std::vector<Sprite*>	sprites;
	public:	static VertexBuffer *buffer;

	public:

		Texture *texture;
		Effect *effect;

		float angle;
		float2 pos;
		float2 pivot;
		float2 size;

		static bool initVertexBuffer()
		{
			VertexXYZUV v[6];
			v[0].Pos.x = 0.0; v[0].Pos.y = 0.0;
			v[1].Pos.x = 1.0; v[1].Pos.y = 0.0;
			v[2].Pos.x = 0.0; v[2].Pos.y = 1.0;
			v[3].Pos.x = 0.0; v[3].Pos.y = 1.0;
			v[4].Pos.x = 1.0; v[4].Pos.y = 0.0;
			v[5].Pos.x = 1.0; v[5].Pos.y = 1.0;

			for (int i = 0; i < 6; ++i)
				v[i].Tex.u = v[i].Pos.x,
				v[i].Tex.v = v[i].Pos.y,
				v[i].Pos.z = 0.5f;

			buffer = Render->createVertexBuffer(6, VertexType::XYZUV, v, true);
			
			return true;
		}

		static void renderAll()
		{
			for (std::vector<Sprite*>::iterator s = sprites.begin(); s != sprites.end(); ++s)
			{
				(*s)->render();
			}
		}

		virtual int init(Sprite *self, PyObject *args, PyObject *kwds)
		{
			char *texture_name;
			float width, height;

			static char *keywords[] = { "texture", "width", "height", NULL };

			if (!PyArg_ParseTupleAndKeywords(args, kwds, "s|ff", keywords,
				&texture_name, &width, &height))
				return -1;

			if (texture_name)
				self->texture = textures[texture_name];

			self->effect = effects["fx"];
			self->effect->setTexture("texture0", self->texture);
			
			self->effect->setMatrix("projection", (float*)&Render->getProjectionMatrix2D());

			self->angle = 0.0f;

			self->pos.x = 300.0f;
			self->pos.y = 300.0f;

			self->pivot.x = 100.0f;
			self->pivot.y = 100.0f;

			self->size.x = 256.0f;
			self->size.y = 256.0f;

			sprites.push_back(self);


			return 0;
		}

		virtual void render()
		{
			angle = (float)GetTickCount() / 1000.0f;

			float4x4 world;

			float cos_angle = cos(angle), sin_angle = sin(angle);
			world.m[0][0] =  size.x * cos_angle;
			world.m[0][1] = -size.x * sin_angle;
			world.m[1][0] =  size.y * sin_angle;
			world.m[1][1] =  size.y * cos_angle;
			world.m[3][0] = -pivot.x * cos_angle - pivot.y * sin_angle + pos.x;
			world.m[3][1] =  pivot.x * sin_angle - pivot.y * cos_angle + pos.y;

			effect->setMatrix("world", (float*)&world);

			effect->render(buffer);
		}

		static int pyInit(PyObject *self, PyObject *args, PyObject *kwds)
		{
			Sprite *sprite = (Sprite*)self;
			return sprite->init(sprite, args, kwds);
		}

		static PyObject *pyMethod(PyObject *self, PyObject *args, PyObject *kwds)
		{
			Sprite *sprite = (Sprite*)self;
			Py_RETURN_NONE;
		}
};

std::vector<Sprite*> Sprite::sprites;
VertexBuffer *Sprite::buffer;