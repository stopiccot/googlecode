using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace planarity
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();

            Random random = new Random();

            for (int i = 0; i < 9; i++)
                dpoints.Add(new DraggablePoint(new osg.Vec3d(100.0 + random.NextDouble() * 600.0, 0.0, 100.0 + random.NextDouble() * 400.0)));

            //for (int i = 0; i < 5; i++)
            //    bombs.Add(new Bomb(new osg.Vec3d(100.0 + random.NextDouble() * 600.0, 0.0, 100.0 + random.NextDouble() * 400.0)));
            //bomb = new Bomb();
            //bomb.position = new osg.Vec3d(100.0 + random.NextDouble() * 600.0, 0.0, 100.0 + random.NextDouble() * 400.0);
            //dpoints.Add(new DraggablePoint(new osg.Vec3d(100.0, 0.0, 100.0)));
        }

        private List<Bomb> bombs = new List<Bomb>();
        private List<DraggablePoint> dpoints = new List<DraggablePoint>();

        private void timer_Tick(object sender, EventArgs e)
        {
            int explosion = -1;

            foreach (DraggablePoint dpoint in dpoints)
            {
                dpoint.update();
                for (int i = 0; i < bombs.Count; i++)
                {
                    Bomb b = bombs[i];
                    if (!b.dead && (dpoint.Position - b.position).length < 25.0)
                        explosion = i;
                    
                }
            }

            if (explosion != -1)
            {
                Bomb b = bombs[explosion];
                b.dead = true;

                foreach (DraggablePoint dpoint in dpoints)
                {
                    dpoint.direction = -(b.position - dpoint.Position);
                    dpoint.speed = Math.Min(dpoint.speed + 10.0f, 20.0f);
                }
            }


            Invalidate();
        }

        private Pen pen = new Pen(Color.FromArgb(255, 200, 200, 200), 2.0f);
        private Pen boldRedPen = new Pen(Color.Red, 2.0f);

        private void MainForm_Paint(object sender, PaintEventArgs e)
        {
            e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

            e.Graphics.DrawLine(pen, dpoints[0].Position, dpoints[1].Position);
            e.Graphics.DrawLine(pen, dpoints[0].Position, dpoints[2].Position);
            e.Graphics.DrawLine(pen, dpoints[1].Position, dpoints[2].Position);
            e.Graphics.DrawLine(pen, dpoints[1].Position, dpoints[3].Position);
            e.Graphics.DrawLine(pen, dpoints[2].Position, dpoints[3].Position);
            e.Graphics.DrawLine(pen, dpoints[3].Position, dpoints[4].Position);
            e.Graphics.DrawLine(pen, dpoints[3].Position, dpoints[5].Position);
            e.Graphics.DrawLine(pen, dpoints[3].Position, dpoints[6].Position);
            e.Graphics.DrawLine(pen, dpoints[7].Position, dpoints[0].Position);
            e.Graphics.DrawLine(pen, dpoints[7].Position, dpoints[1].Position);
            e.Graphics.DrawLine(pen, dpoints[7].Position, dpoints[3].Position);
            e.Graphics.DrawLine(pen, dpoints[7].Position, dpoints[4].Position);
            e.Graphics.DrawLine(pen, dpoints[7].Position, dpoints[6].Position);
            e.Graphics.DrawLine(pen, dpoints[8].Position, dpoints[6].Position);
            e.Graphics.DrawLine(pen, dpoints[8].Position, dpoints[5].Position);
            e.Graphics.DrawLine(pen, dpoints[8].Position, dpoints[3].Position);
            e.Graphics.DrawLine(pen, dpoints[8].Position, dpoints[2].Position);
            e.Graphics.DrawLine(pen, dpoints[8].Position, dpoints[0].Position);

            foreach (Bomb b in bombs)
            {
                if (!b.dead)
                {
                    float bombR = 15.0f;
                    RectangleF rect = new RectangleF((float)(b.position.x - bombR), (float)(b.position.z - bombR), 2 * bombR, 2 * bombR);
                    e.Graphics.FillEllipse(Brushes.Pink, rect);
                    e.Graphics.DrawArc(boldRedPen, rect, 0.0f, 360.0f);
                }
            }

            foreach (DraggablePoint dpoint in dpoints)
            {
                dpoint.Paint(e);
            }
        }

        private void MainForm_MouseMove(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in dpoints)
            {
                dpoint.MouseMove(e);
            }

            //Invalidate();
        }

        private void MainForm_MouseDown(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in dpoints)
            {
                dpoint.MouseDown(e);
            }
        }

        private void MainForm_MouseUp(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in dpoints)
            {
                dpoint.MouseUp(e);
            }
        }
    }
}
