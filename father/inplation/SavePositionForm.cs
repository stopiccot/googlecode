using System;
using System.Windows.Forms;
using System.Drawing;
using Microsoft.Win32;

namespace Stopiccot
{
    public struct FormPostion
    {
        public bool Maximized;
        public Size Size;
        public Point Location;

        public FormPostion(int Left, int Top, int Width, int Height, bool Max)
        {
            this.Location = new Point(Left, Top);
            this.Size = new Size(Width, Height);
            this.Maximized = Max;
        }
    }

    public class SavePositionForm : Form
    {
        private FormPostion position;
        private bool saveToRegistry = false;
        private static string RegPath = "Software\\SP\\" + System.Reflection.Assembly.GetExecutingAssembly().FullName.Split(',')[0];

        public Boolean SavePositionToRegistry
        {
            get { return saveToRegistry; }
            set { saveToRegistry = value; }
        }

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

        protected override void OnLocationChanged(EventArgs e)
        {
            base.OnLocationChanged(e);
            if (!position.Maximized)
                position.Location = Location;
        }

        protected override void OnSizeChanged(EventArgs e)
        {
            base.OnSizeChanged(e);
            if (!position.Maximized)
                position.Size = Size;
        }

        protected override void OnMove(EventArgs e)
        {
 	        base.OnMove(e);
            position.Maximized = WindowState == FormWindowState.Maximized;
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            if (saveToRegistry)
                try
                {
                    string[] s = ((string)Registry.LocalMachine.OpenSubKey(RegPath).GetValue("SavePositionForm " + this.Name)).Split(' ');
                    this.Position = new FormPostion(Convert.ToInt32(s[0]), Convert.ToInt32(s[1]), Convert.ToInt32(s[2]), Convert.ToInt32(s[3]), Convert.ToBoolean(s[4]));
                }
                catch { }
        }

        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            base.OnClosing(e);
            if (saveToRegistry)
                Registry.LocalMachine.CreateSubKey(RegPath).SetValue("SavePositionForm " + this.Name,
                    position.Location.X.ToString() + ' ' +
                    position.Location.Y.ToString() + ' ' +
                    position.Size.Width.ToString() + ' ' +
                    position.Size.Height.ToString() + ' ' +
                    position.Maximized.ToString());
        }
    }    
}
