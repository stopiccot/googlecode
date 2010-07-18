using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace libdrag
{
    public delegate void DraggablePointEventHandler(DraggablePoint draggablePoint);

    public class DragForm : Form
    {
        protected List<DraggablePoint> dpoints = new List<DraggablePoint>();

        // Properties
        private float gridSize = 0.0f;

        public float GridSize
        {
            get { return gridSize; }
            set { DraggablePoint.gridSize = gridSize = value; }
        }

        private bool snapToGrid = false;

        public bool SnapToGrid
        {
            get { return snapToGrid; }
            set { DraggablePoint.snapToGrid = snapToGrid = value; }
        }

        // Constructor
        public DragForm()
        {
            if (!this.DesignMode)
            {
                this.Paint += new System.Windows.Forms.PaintEventHandler(this.OnPaint);
                this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.OnMouseDown);
                this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.OnMouseMove);
                this.MouseUp += new System.Windows.Forms.MouseEventHandler(this.OnMouseUp);
            }
        }

        public event PaintEventHandler BeforePointsPaint;
        public event PaintEventHandler AfterPointsPaint;

        public event DraggablePointEventHandler DraggablePointMouseDown;

        private void PaintGrid(PaintEventArgs e)
        {
            if (gridSize > 0.0f)
            {
                for (int i = 0; i < 100; i++)
                {
                    e.Graphics.DrawLine(Pens.LightGray, new PointF(0.0f, gridSize * i), new PointF(10000.0f, gridSize * i));
                    e.Graphics.DrawLine(Pens.LightGray, new PointF(gridSize * i, 0.0f), new PointF(gridSize * i, 10000.0f));
                }
            }
        }

        private void PaintDraggablePoints(PaintEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
                dpoint.Paint(e);
        }

        private void OnPaint(object sender, PaintEventArgs e)
        {
            e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

            PaintGrid(e);

            if (BeforePointsPaint != null)
                BeforePointsPaint(sender, e);

            PaintDraggablePoints(e);

            if (AfterPointsPaint != null)
                AfterPointsPaint(sender, e);
        }

        private void OnMouseDown(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
            {
                if (dpoint.MouseDown(e))
                {
                    if (DraggablePointMouseDown != null)
                        DraggablePointMouseDown(dpoint);

                    break;
                }
            }

            Invalidate();
        }

        private void OnMouseMove(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
                if (dpoint.MouseMove(e))
                    break;

            Invalidate();
        }

        private void OnMouseUp(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
                dpoint.MouseUp(e);

            Invalidate();
        }
    }
}
