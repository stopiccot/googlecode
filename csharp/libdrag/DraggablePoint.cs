using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace libdrag
{
    public class DraggablePoint
    {
        // Pen to draw all DraggablePoints
        private static Pen pen = new Pen(Color.Gray, 2.0f);

        // Point position
        private PointF position;

        // Radius of DraggablePoint
        private const float PointRadius = 8.0f;

        private static Brush brush = new SolidBrush(Color.FromArgb(0xCC, 0xCC, 0xCC));

        public DraggablePoint(PointF pos)
        {
            this.position = pos;
        }

        // Checks if cursor is over DraggablePoint
        private bool mouseHit(int x, int y)
        {
            double distance = Math.Sqrt((x - position.X) * (x - position.X) + (y - position.Y) * (y - position.Y));
            return distance < PointRadius;
        }

        bool drag = false;

        public void Paint(PaintEventArgs e)
        {
            RectangleF rect = new RectangleF(position.X - PointRadius, position.Y - PointRadius, 2 * PointRadius, 2 * PointRadius);
            e.Graphics.FillEllipse(brush, rect);
            e.Graphics.DrawArc(pen, rect, 0.0f, 360.0f);
        }

        public void MouseDown(MouseEventArgs e)
        {
            if (mouseHit(e.X, e.Y))
            {
                drag = true;
            }
        }

        public void MouseMove(MouseEventArgs e)
        {
            if (drag)
            {
                this.position.X = e.X;
                this.position.Y = e.Y;
            }
        }

        public void MouseUp(MouseEventArgs e)
        {
            drag = false;
        }

        public PointF Position
        {
            get
            {
                return this.position;
            }
        }
    }
}
