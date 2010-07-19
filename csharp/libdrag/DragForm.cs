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

        private PointF origin = new PointF(0.0f, 0.0f);

        public PointF Origin
        {
            get { return origin; }
            set { DraggablePoint.origin = origin = value; }
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

        private static Pen BoldLightGray = new Pen(Color.LightGray, 2.0f);

        private void PaintGrid(PaintEventArgs e)
        {
            if (gridSize > 0.0f)
            {
                const float bigNum = 10000.0f;

                for (int i = -200; i < 200; i++)
                {
                    e.Graphics.DrawLine(Pens.LightGray, new PointF(origin.X - bigNum, origin.Y + gridSize * i), new PointF(origin.X + bigNum, origin.Y + gridSize * i));
                    e.Graphics.DrawLine(Pens.LightGray, new PointF(origin.X + gridSize * i, origin.Y - bigNum), new PointF(origin.X + gridSize * i, origin.Y + bigNum));
                }

                e.Graphics.DrawLine(Pens.Gray, new PointF(origin.X - bigNum, origin.Y), new PointF(origin.X + bigNum, origin.Y));
                e.Graphics.DrawLine(Pens.Gray, new PointF(origin.X, origin.Y - bigNum), new PointF(origin.X, origin.Y + bigNum));
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

        private int mouseDownX = 0, mouseDownY = 0;
        private bool gridDrag = false;
        private PointF oldOrigin = new PointF(0.0f, 0.0f);

        private void OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
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
            }

            if (e.Button == MouseButtons.Middle)
            {
                gridDrag = true;
                mouseDownX = e.X;
                mouseDownY = e.Y;
                oldOrigin = this.origin;
            }

            Invalidate();
        }

        private void OnMouseMove(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
            {
                if (dpoint.MouseMove(e))
                    break;
            }

            if (gridDrag)
            {
                this.Origin = new PointF(oldOrigin.X + e.X - mouseDownX, oldOrigin.Y + e.Y - mouseDownY);
            }

            Invalidate();
        }

        private void OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                foreach (DraggablePoint dpoint in this.dpoints)
                    dpoint.MouseUp(e);
            }

            // Stop drag grid
            if (e.Button == MouseButtons.Middle)
            {
                gridDrag = false;
            }

            Invalidate();
        }
    }
}
