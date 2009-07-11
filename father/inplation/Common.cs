using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace Stopiccot.VisualComponents
{
    public static class StringFormats
    {
        public static StringFormat centeredVH, centeredV, centeredH;

        static StringFormats()
        {
            centeredVH = new StringFormat();
            centeredVH.Alignment = StringAlignment.Center;
            centeredVH.LineAlignment = StringAlignment.Center;

            centeredH = new StringFormat();
            centeredH.Alignment = StringAlignment.Center;

            centeredV = new StringFormat();
            centeredV.LineAlignment = StringAlignment.Center;
        }
    }

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
