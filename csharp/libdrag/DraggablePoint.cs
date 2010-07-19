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
        // Pen and brush to draw all DraggablePoints
        private static Pen pen = new Pen(Color.Gray, 2.0f);
        private static Brush brush = new SolidBrush(Color.FromArgb(0xCC, 0xCC, 0xCC));

        // Point position
        private PointF position;

        // True if point is being dragged
        bool drag = false;

        // Radius of DraggablePoint
        private const float PointRadius = 7.0f;
        private float PointRadiusCoeff = 1.0f;

        // Grid variables
        public static bool snapToGrid = false;
        public static float gridSize = 0.0f;
        public static PointF origin = new PointF(0.0f, 0.0f);

        // user data
        public object userData = null;
        
        // Constructors
        public DraggablePoint(PointF position)
        {
            this.position = position;
            snap();
        }

        public DraggablePoint(PointF position, object userData)
        {
            this.position = position;
            this.userData = userData;
            snap();
        }

        // Checks if cursor is over DraggablePoint
        private bool mouseHit(int x, int y)
        {
            double distance = Math.Sqrt(Math.Pow(x - position.X - origin.X, 2.0) + Math.Pow(y - position.Y - origin.Y, 2.0));
            return distance < PointRadiusCoeff * PointRadius;
        }

        public void Paint(PaintEventArgs e)
        {
            float R = PointRadiusCoeff * PointRadius;
            RectangleF rect = new RectangleF(position.X + origin.X - R, position.Y + origin.Y - R, 2 * R, 2 * R);
            e.Graphics.FillEllipse(brush, rect);
            e.Graphics.DrawArc(pen, rect, 0.0f, 360.0f);
        }

        public bool MouseDown(MouseEventArgs e)
        {
            if (mouseHit(e.X, e.Y))
            {
                drag = true;
                return true;
            }

            return false;
        }

        private void snap()
        {
            if (!snapToGrid) return;

            this.position.X = gridSize * (float)Math.Round(this.position.X / gridSize);
            this.position.Y = gridSize * (float)Math.Round(this.position.Y / gridSize);
        }

        public bool MouseMove(MouseEventArgs e)
        {
            if (drag)
            {
                this.position.X = e.X - origin.X;
                this.position.Y = e.Y - origin.Y;
                snap();
            }

            if (drag || mouseHit(e.X, e.Y))
            {
                this.PointRadiusCoeff = 1.2f;
                return true;
            }

            this.PointRadiusCoeff = 1.0f;
            return false;
        }

        public void MouseUp(MouseEventArgs e)
        {
            drag = false;
        }

        public PointF Position
        {
            get
            {
                return new PointF(this.position.X + origin.X, this.position.Y + origin.Y);
            }
        }

        public PointF RealPosition
        {
            get
            {
                return this.position;
            }
        }
    }
}
