using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

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
}
