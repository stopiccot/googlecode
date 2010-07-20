using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace libdrag
{
    public class FieldSettings
    {
        // Owner form for calling Invalidate()
        private DragForm owner = null;

        // render settings
        private PointF origin = new PointF(0.0f, 0.0f);
        private float scale = 100.0f;
        private float minScale = 2000.0f;
        private float maxScale = 1.0f;
        
        // Grid settings
        private bool snapToGrid = false;
        private float gridSize = 0.0f;

        // Fill default values in costructor
        public FieldSettings(DragForm owner)
        {
            this.owner = owner;
        }

        public PointF Origin
        {
            get { return origin; }
            set { origin = value; owner.Invalidate(); }
        }

        public float Scale
        {
            get { return scale; }
            set { scale = value; owner.Invalidate(); }
        }
        
        public float MinScale
        {
            get { return minScale; }
            set { minScale = value; }
        }

        public float MaxScale
        {
            get { return maxScale; }
            set { maxScale = value; }
        }

        public bool SnapToGrid
        {
            get { return snapToGrid; }
            set { snapToGrid = value; owner.Invalidate(); }
        }

        public float GridSize
        {
            get { return gridSize; }
            set { gridSize = value; owner.Invalidate(); }
        }
    }
}
