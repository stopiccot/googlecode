using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace SP.VisualComponents
{
    class AppleButton : DoubleBufferControl
    {
        private Image icon = null;
        private Brush brush1, brush2 = null;
        private Pen pen = new Pen(Color.FromArgb(135, Color.Black), 1.0f);
        private bool mouseDown = false;

        public Image Icon
        {
            get { return icon; }
            set { icon = value; Invalidate(); }
        }

        private void CreateBrushes()
        {
            brush1 = new LinearGradientBrush(this.ClientRectangle,
                Color.FromArgb(220, 220, 220), Color.FromArgb(250, 250, 250), -90.0f);
            brush2 = new LinearGradientBrush(this.ClientRectangle,
                Color.FromArgb(250, 250, 250), Color.FromArgb(230, 230, 230), -90.0f);
        }

        protected override void OnLocationChanged(EventArgs e)
        {
            base.OnLocationChanged(e);
            CreateBrushes();
        }

        protected override void OnSizeChanged(EventArgs e)
        {
            base.OnSizeChanged(e);
            CreateBrushes();
        }

        protected override void OnMouseDown(MouseEventArgs e)
        {
            base.OnMouseDown(e);
            mouseDown = true; 
            Invalidate();
        }

        protected override void OnMouseUp(MouseEventArgs e)
        {
            base.OnMouseUp(e);
            mouseDown = false;
            Invalidate();
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);

            g.FillRectangle( mouseDown ? brush2 : brush1, ClientRectangle);
            g.DrawRectangle( pen, new Rectangle(ClientRectangle.Location, ClientRectangle.Size - new Size(1,1)) );

            if (icon != null)
               g.DrawImage(icon, new Point((ClientRectangle.Width - icon.Width) / 2, (ClientRectangle.Height - icon.Height) / 2));

            FlipBuffer();
        }
    }
}
