using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace SP.VisualComponents
{
    class Chooser : DoubleBufferControl
    {
        private Font font, boldFont;

        private string[] items = new string[] { };

        public string[] Items
        {
            get { return items; }
            set { items = value; OnPaint(null); }
        }

        private Brush hoverBrush;
        private int hoverIndex = -1;
        private int selectedIndex = -1;

        public int SelctedIndex
        {
            get { return selectedIndex; }
            set { selectedIndex = value; OnPaint(null); }
        }

        protected override void OnBackColorChanged(EventArgs e)
        {
            base.OnBackColorChanged(e);
            double dark = .85;
            hoverBrush = new SolidBrush(Color.FromArgb((byte)(dark * this.BackColor.R),
                (byte)(dark * this.BackColor.G), (byte)(dark * this.BackColor.B)));
        }
        
        public Chooser()
        {
            font = new Font("Tahoma", 8.25F, FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            boldFont = new Font("Tahoma", 8.25F, FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            OnBackColorChanged(null);
        }

        private Point cellSize = new Point(20, 20);

        private int GetIndex(int X, int Y)
        {
            return ( X / cellSize.X + Y / cellSize.Y * (Size.Width / cellSize.X));
        }

        public Point CellSize
        {
            set { cellSize = value; OnPaint(null); }
            get { return cellSize; }
        }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            if (DesignMode)
                this.Cursor = Cursors.Help;
            base.OnMouseMove(e);
            hoverIndex = GetIndex(e.X, e.Y);
            OnPaint(null);
        }

        protected override void OnMouseLeave(EventArgs e)
        {
            base.OnMouseLeave(e);
            hoverIndex = -1;
            OnPaint(null);
        }

        protected override void OnMouseClick(MouseEventArgs e)
        {
            base.OnMouseClick(e);

            if (e.Button == MouseButtons.Left)
                selectedIndex = GetIndex(e.X, e.Y);

            OnPaint(null);
        }
        
        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);

            g.Clear(this.BackColor);

            int n = 0, x = 0, y = 0;

            foreach (string s in Items)
            {
                if (n == hoverIndex || n == 0 && DesignMode )
                    g.FillRectangle(hoverBrush,
                        new Rectangle(cellSize.X * x, cellSize.Y * y, cellSize.X, cellSize.Y));

                g.DrawString(s, n != selectedIndex ? font : boldFont, Brushes.Black,
                    new Rectangle(cellSize.X * x, cellSize.Y * y, cellSize.X, cellSize.Y),
                    StringFormats.centeredVH);

                n++; x++;
                if (x * cellSize.X > Size.Width)
                {
                    x = 0; y++;
                }
            }

            if (this.DesignMode)
            {
                Pen p = new Pen(Color.FromArgb(143, 140, 127));
                p.DashStyle = DashStyle.Dash;
                g.DrawRectangle(p, new Rectangle(0, 0, Size.Width - 1, Size.Height - 1));
            }

            FlipBuffer();
        }
    }
}
