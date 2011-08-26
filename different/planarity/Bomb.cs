using System;
using System.Collections.Generic;
using System.Text;

namespace planarity
{
    public class Bomb
    {
        public osg.Vec3d position;
        public bool dead = false;

        public Bomb(osg.Vec3d pos)
        {
            this.position = pos;
        }
    }
}
