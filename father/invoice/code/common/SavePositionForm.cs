using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace Invoice
{
    //================================================================================
    // FormPostion
    //    Структура, описывающая положение формы
    //================================================================================
    public struct FormPostion
    {
        public bool Maximized; // Развёрнута ли фома на весь экран
        public Size Size;      // Размеры формы
        public Point Location; // Позиция формы

        public FormPostion(int Left, int Top, int Width, int Height, bool Max)
        {
            this.Location = new Point(Left, Top);
            this.Size = new Size(Width, Height);
            this.Maximized = Max;
        }
    }

    //================================================================================
    // SavePositionForm
    //    Форма запоминающая свою позицию
    //================================================================================
    public class SavePositionForm : Form
    {
        private FormPostion position;

        public FormPostion Position
        {
            get { return position; }
            set 
            {
                Location = value.Location;
                Size = value.Size;
                WindowState = value.Maximized ? FormWindowState.Maximized : FormWindowState.Normal;
                position = value;
            }
        }

        protected override void OnResizeEnd(EventArgs e)
        {
            base.OnResizeEnd(e);
            position.Location = Location;
            position.Size = Size;
        }

        protected override void OnMove(EventArgs e)
        {
 	        base.OnMove(e);
            position.Maximized = WindowState == FormWindowState.Maximized;
        }        
    }    
}
