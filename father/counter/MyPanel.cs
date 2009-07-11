using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms.Layout;
using System.ComponentModel;

namespace SP.VisualComponents
{
    public class DemoFlowLayout : LayoutEngine
    {
        public override bool Layout( object container, LayoutEventArgs layoutEventArgs)
        {
            foreach (Control c in (container as Control).Controls)
            {
                if (!c.Visible)
                    continue;

                Point p = c.Location;
                if (p.X < 2) p.X = 2;
                if (p.Y < 15) p.Y = 15;
                c.Location = p;
            }
            return false;
        }
    }

    class RollPanel : Panel
    {
        private DemoFlowLayout layoutEngine = new DemoFlowLayout();
        private Brush TextBrush = new SolidBrush(Color.FromArgb(50, 50, 50));

        private int oldHeight;

        private bool minimized = false;
        public bool Minimized
        {
            get { return minimized; }
            set 
            {
                if (minimized != value)
                {
                    if (minimized = value)
                    {
                        oldHeight = this.Height;
                        this.Height = 16;
                    }
                    else
                        this.Height = oldHeight;

                    OnPaint(null);
                }
                OnResize(null);
            }
        }

        public override LayoutEngine LayoutEngine
        {
            get { return layoutEngine; }
        }

        [Browsable(true)]
        public override string Text
        {
            get { return base.Text; }
            set { base.Text = value; }
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            //base.OnPaint(e);

            Graphics g = Graphics.FromHwnd(this.Handle);

            g.Clear(SystemColors.Control);

            g.DrawString(this.Text, this.Font, TextBrush, new PointF(1.0F, 1.0F));

            if (minimized)
            {
                g.DrawRectangle(Pens.DarkGray, new Rectangle(0, 0, Size.Width - 1, Size.Height - 1));
            }
            else
            {
                g.DrawRectangle(Pens.DarkGray, new Rectangle(0, 0, Size.Width - 1, Size.Height - 1));
                g.DrawRectangle(Pens.DarkGray, new Rectangle(2, 15, Size.Width - 5, Size.Height - 18));
            }
        }

        
        protected override void OnMouseDoubleClick(MouseEventArgs e)
        {
            base.OnMouseDoubleClick(e);
            if (e.Y <= 15)
            {
                Minimized = !Minimized;
            }
        }

    }
}
