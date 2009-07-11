using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace SP.VisualComponents
{
    public class DoubleBufferControl : Control
    {
        private Image bufferImage;
        protected Graphics g;

        public DoubleBufferControl()
        {
            Size = new Size(1, 1);
        }

        protected void FlipBuffer()
        {
            Graphics.FromHwnd(this.Handle).DrawImage(bufferImage, new Point(0, 0));
        }

        protected override void OnResize(EventArgs e)
        {
            base.OnResize(e);
            bufferImage = new Bitmap(this.Size.Width, this.Size.Height);
            g = Graphics.FromImage(bufferImage);
        }
    }
}
