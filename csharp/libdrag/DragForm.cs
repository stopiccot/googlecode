using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace libdrag
{
    public class DragForm : Form
    {
        protected List<DraggablePoint> dpoints = new List<DraggablePoint>();

        public DragForm()
        {
            if (!this.DesignMode)
            {
                this.Paint += new System.Windows.Forms.PaintEventHandler(this.OnPaint);
                this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.OnMouseDown);
                this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.OnMouseMove);
                this.MouseUp += new System.Windows.Forms.MouseEventHandler(this.OnMouseUp);
            }
        }

        public event PaintEventHandler BeforePointsPaint;
        public event PaintEventHandler AfterPointsPaint;

        private void PaintDraggablePoints(object sender, PaintEventArgs e)
        {
            // fuck
            foreach (DraggablePoint dpoint in this.dpoints)
            {
                dpoint.Paint(e);
            }
        }

        // huita

        private void OnPaint(object sender, PaintEventArgs e)
        {
            e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

            if (BeforePointsPaint != null)
            {
                //MessageBox.Show("BeforePointsPaint");
                BeforePointsPaint(sender, e);
            }

            PaintDraggablePoints(sender, e);

            if (AfterPointsPaint != null)
            {
                //MessageBox.Show("AfterPointsPaint");
                AfterPointsPaint(sender, e);
            }
        }

        private void OnMouseDown(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
                dpoint.MouseDown(e);

            Invalidate();
        }

        private void OnMouseMove(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
                dpoint.MouseMove(e);

            Invalidate();
        }

        private void OnMouseUp(object sender, MouseEventArgs e)
        {
            foreach (DraggablePoint dpoint in this.dpoints)
                dpoint.MouseUp(e);

            Invalidate();
        }
    }
}
