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
        }

        // Methods for adding new draggable points. AVOID ADDING DIRECTLY
        public void AddDraggablePointWS(PointF point, object userData)
        {
            DraggablePoint dpoint = new DraggablePoint(point, userData, this.ownerForm);
            dpoint.Snap();
            this.dpoints.Add(dpoint);
        }

        public void AddDraggablePointFS(PointF point, object userData)
        {
            AddDraggablePointWS(ownerForm.TransformToWorldSpace(point), userData);
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
