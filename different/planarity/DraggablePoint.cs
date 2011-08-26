using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace planarity
{
    public class DraggablePoint
    {
        // Pen to draw all DraggablePoints
        private static Pen pen = new Pen(Color.Gray, 2.0f);

        // Point position
        private osg.Vec3d position;
        public osg.Vec3d direction;

        public double speed = 0.0;
        public double turning = 0.0;

        public double maxSpeed = 0.3;

        // Radius of DraggablePoint
        private const float PointRadius = 10.0f;

        // Is point being moved?
        private bool drag = false;

        private static Random random = new Random();

        // Checks if cursor is over DraggablePoint
        private bool mouseHit(int x, int y)
        {
            double distance = Math.Sqrt((x - position.x) * (x - position.x) + (y - position.z) * (y - position.z));
            return distance < PointRadius;
        }

        public DraggablePoint(osg.Vec3d pos)
        {
            this.position = pos;

            this.direction = new osg.Vec3d(random.NextDouble(), 0.0, random.NextDouble());
        }

        private static Brush brush = new SolidBrush(Color.FromArgb(0xCC, 0xCC, 0xCC));
        public void Paint(PaintEventArgs e)
        {
            RectangleF rect = new RectangleF((float)position.x - PointRadius, (float)position.z - PointRadius, 2 * PointRadius, 2 * PointRadius);
            e.Graphics.FillEllipse(brush, rect);
            e.Graphics.DrawArc(pen, rect, 0.0f, 360.0f);
        }

        public void update()
        {
            if (!drag)
            {
                if (speed < maxSpeed)
                    speed = Math.Min(speed + 0.005, maxSpeed);
                else
                    speed = Math.Max(speed - 0.05, maxSpeed);

                if (speed > 0.0)
                    this.position += this.direction / this.direction.length * speed;
            }

            if (speed > maxSpeed)
            {
                if (this.position.x < 10.0 || this.position.x > 800.0)
                    this.direction.x = -this.direction.x;

                if (this.position.z < 10.0 || this.position.z > 600.0)
                    this.direction.z = -this.direction.z;
            }

            this.position.x = Math.Max(Math.Min(this.position.x, 800.0), 10.0);
            this.position.z = Math.Max(Math.Min(this.position.z, 600.0), 10.0);

            turning += (random.NextDouble() - 0.5) / 20.0;
            turning = Math.Max(Math.Min(turning, 1.0), -1.0);
            turning *= 0.9;

            double angle = Math.PI / 2.0 * turning;

            double x = Math.Cos(angle) * this.direction.x + Math.Sin(angle) * this.direction.z;
            double z = -Math.Sin(angle) * this.direction.x + Math.Cos(angle) * this.direction.z;

            this.direction.x = x;
            this.direction.z = z;
        }

        public void MouseDown(MouseEventArgs e)
        {
            if (mouseHit(e.X, e.Y))
            {
                drag = true;
                speed = -1.5;
            }
        }

        public void MouseMove(MouseEventArgs e)
        {
            if (drag)
            {
                this.position.x = e.X;
                this.position.z = e.Y;
            }
        }

        public void MouseUp(MouseEventArgs e)
        {
            drag = false;
        }

        public osg.Vec3d Position
        {
            get
            {
                return this.position;
            }
        }
    }
}
