using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace osg
{
    public struct Vec3d
    {
        public double x, y, z;

        // Constructors
        public Vec3d()
        {
            this.x = 0.0;
            this.y = 0.0;
            this.z = 0.0;
        }

        public Vec3d(double x, double y, double z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        // implicit conversion between PointF and osg.Vec3d
        public static implicit operator PointF(Vec3d vec)
        {
            return new PointF((float)vec.x, (float)vec.z);
        }

        public static implicit operator Vec3d(PointF p)
        {
            return new Vec3d(p.X, 0.0, p.Y);
        }

        // vector length
        public double length
        {
            get
            {
                return Math.Sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
            }
        }

        // dot and cross product
        public static double dot(Vec3d a, Vec3d b)
        {
            return a.x * b.x + a.y * b.y + a.z * b.z;
        }

        public static Vec3d cross(Vec3d a, Vec3d b)
        {
            return new Vec3d(a.y * b.z - b.y * a.z, b.x * a.z - a.x * b.z, a.x * b.y - b.x * a.y);
        }

        // dot and cross product like in osg
        public static double operator *(Vec3d a, Vec3d b)
        {
            return Vec3d.dot(a, b);
        }

        public static Vec3d operator ^(Vec3d a, Vec3d b)
        {
            return Vec3d.cross(a, b);
        }

        // all other operators
        public static Vec3d operator -(Vec3d a)
        {
            return new Vec3d(-a.x, -a.y, -a.z);
        }

        public static Vec3d operator +(Vec3d a, Vec3d b)
        {
            return new Vec3d(a.x + b.x, a.y + b.y, a.z + b.z);
        }

        public static Vec3d operator -(Vec3d a, Vec3d b)
        {
            return new Vec3d(a.x - b.x, a.y - b.y, a.z - b.z);
        }

        public static Vec3d operator *(Vec3d a, double d)
        {
            return new Vec3d(a.x * d, a.y * d, a.z * d);
        }

        public static Vec3d operator *(double d, Vec3d a)
        {
            return a * d;
        }

        public static Vec3d operator /(Vec3d a, double d)
        {
            return a * (1.0 / d);
        }
    }
}
