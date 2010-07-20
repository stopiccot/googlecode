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

        public FieldSettings FieldSettings { get; set; }
        
        // Constructor
        public DragForm()
        {
            this.FieldSettings = new FieldSettings(this);

            if (!this.DesignMode)
            {
                this.Paint += new System.Windows.Forms.PaintEventHandler(this.OnPaint);
                this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.OnMouseDown);
                this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.OnMouseMove);
                this.MouseUp += new System.Windows.Forms.MouseEventHandler(this.OnMouseUp);
                this.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.OnMouseWheel);
                this.Resize += new System.EventHandler(this.OnResize);
            }
        }

        // Methods for adding new draggable points. AVOID ADDING DIRECTLY
        public void AddDraggablePointWS(PointF point, object userData)
        {
            DraggablePoint dpoint = new DraggablePoint(point, userData);
            dpoint.ownerForm = this;
            dpoint.Snap();
            this.dpoints.Add(dpoint);
        }

        public void AddDraggablePointFS(PointF point, object userData)
        {
            AddDraggablePointWS(TransformToWorldSpace(point), userData);
        }
        
        // Methods for transformation between two spaces
        public PointF TransformToFormSpace(PointF point)
        {
            return new PointF(this.FieldSettings.Scale * point.X + this.FieldSettings.Origin.X + this.Width / 2.0f, this.FieldSettings.Scale * point.Y + this.FieldSettings.Origin.Y + this.Height / 2.0f);
        }

        public PointF TransformToWorldSpace(PointF point)
        {
            return new PointF((point.X - this.FieldSettings.Origin.X - this.Width / 2.0f) / this.FieldSettings.Scale, (point.Y - this.FieldSettings.Origin.Y - this.Height / 2.0f) / this.FieldSettings.Scale);
        }
        
        // Handing events
        public event PaintEventHandler BeforePointsPaint;
        public event PaintEventHandler AfterPointsPaint;

        public event DraggablePointEventHandler DraggablePointMouseDown;

        private static Pen BoldLightGray = new Pen(Color.LightGray, 2.0f);
        private static Pen BoldBlack = new Pen(Color.Black, 2.0f);

        private void PaintGrid(PaintEventArgs e)
        {
            if (this.FieldSettings.GridSize > 0.0f)
            {
                const float bigNum = 100.0f;

                for (int i = -500; i < 500; i++)
                {
                    e.Graphics.DrawLine(Pens.LightGray, TransformToFormSpace(new PointF(-bigNum, this.FieldSettings.GridSize * i)), TransformToFormSpace(new PointF(bigNum, this.FieldSettings.GridSize * i)));
                    e.Graphics.DrawLine(Pens.LightGray, TransformToFormSpace(new PointF(this.FieldSettings.GridSize * i, -bigNum)), TransformToFormSpace(new PointF(this.FieldSettings.GridSize * i, bigNum)));
                }

                // OX and OY axises
                e.Graphics.DrawLine(Pens.Black, TransformToFormSpace(new PointF(-bigNum, 0.0f)), TransformToFormSpace(new PointF(bigNum, 0.0f)));
                e.Graphics.DrawLine(Pens.Black, TransformToFormSpace(new PointF(0.0f, -bigNum)), TransformToFormSpace(new PointF(0.0f, bigNum)));
            }
        }

        private void PaintDraggablePoints(PaintEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
            {
                dpoint.ownerForm = this;
                dpoint.Paint(e);
            }
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
                oldOrigin = this.FieldSettings.Origin;
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
                this.FieldSettings.Origin = new PointF(oldOrigin.X + e.X - mouseDownX, oldOrigin.Y + e.Y - mouseDownY);
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

        private void OnMouseWheel(object sender, MouseEventArgs e)
        {
            // Чтоб зумить относительно центра камеры
            PointF center = TransformToWorldSpace(new PointF(this.Width / 2.0f, this.Height / 2.0f));
            
            this.FieldSettings.Scale *= 1.0f + e.Delta / 600.0f;
            this.FieldSettings.Scale = Math.Min(this.FieldSettings.MaxScale, Math.Max(this.FieldSettings.MinScale, this.FieldSettings.Scale));

            center = TransformToFormSpace(center);
            this.FieldSettings.Origin = new PointF(this.FieldSettings.Origin.X + this.Width / 2.0f - center.X, this.FieldSettings.Origin.Y + this.Height / 2.0f - center.Y);

            Invalidate();
        }

        private void OnResize(object sender, EventArgs e)
        {
            Invalidate();
        }
    }
}
