using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace libdrag
{
    public class DraggablePointGroup
    {
        private DragForm ownerForm = null;

        public List<DraggablePoint> dpoints = new List<DraggablePoint>();
        
        public bool Visible { get; set; }
		
        internal DraggablePointGroup(DragForm ownerForm)
        {
            this.ownerForm = ownerForm;
			this.Visible = true;
        }

        // Methods for adding new draggable points. AVOID ADDING DIRECTLY
        public DraggablePoint AddDraggablePointWS(PointF point, object userData)
        {
            DraggablePoint dpoint = new DraggablePoint(point, userData, this.ownerForm);
            dpoint.Snap();
            this.dpoints.Add(dpoint);
			return dpoint;
        }

		public DraggablePoint AddDraggablePointWS(float x, float y, object userData)
		{
			return this.AddDraggablePointWS(new PointF(x, y), userData);
		}

		public DraggablePoint AddDraggablePointFS(PointF point, object userData)
        {
            return this.AddDraggablePointWS(ownerForm.TransformToWorldSpace(point), userData);
        }

		public DraggablePoint AddDraggablePointFS(float x, float y, object userData)
		{
			return this.AddDraggablePointFS(new PointF(x, y), userData);
		}

        public void Paint(PaintEventArgs e)
        {
            if (this.Visible)
            {
                foreach (DraggablePoint point in this.dpoints)
                {
                    point.Paint(e);
                }
            }
        }
    }
}
