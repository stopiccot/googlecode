using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace osgmath
{
    public class osgMath
    {
        public static double cos(osg.Vec3d a, osg.Vec3d b)
        {
            return (a * b) / a.length / b.length;
        }
    }
}
