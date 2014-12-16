using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using Microsoft.Win32;

namespace Stopiccot
{
    //================================================================================
    // FormPostion
    //    Структура, описывающая положение формы
    //================================================================================
    public struct FormPosition
    {
        public bool Maximized; // Развёрнута ли фома на весь экран
        public Size Size;      // Размеры формы
        public Point Location; // Позиция формы

        public FormPosition(int Left, int Top, int Width, int Height, bool Max)
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
        private FormPosition position;
        private bool saveToRegistry = false;
        private static string RegPath = "Software\\SP\\" + System.Reflection.Assembly.GetExecutingAssembly().FullName.Split(',')[0];

        public Boolean SavePositionToRegistry
        {
            get { return saveToRegistry; }
            set { saveToRegistry = value; }
        }

        public FormPosition Position
        {
            get { return position; }
            set 
            {
                Location = value.Location;
                WindowState = value.Maximized ? FormWindowState.Maximized : FormWindowState.Normal;
                // Если размеры окна нельзя изменить, то нефиг читать значения из конфига
                // т.к. от версии к версии размеры окна могут меняться
                if (this.FormBorderStyle != FormBorderStyle.FixedDialog)
                    Size = value.Size;

                position = value;
            }
        }

        protected override void OnResizeEnd(EventArgs e)
        {
            base.OnResizeEnd(e);
            position.Location = Location;
            position.Size = Size;
            position.Maximized = WindowState == FormWindowState.Maximized;
        }

        protected override void OnMove(EventArgs e)
        {
 	        base.OnMove(e);
            position.Location = Location;
            position.Size = Size;
            position.Maximized = WindowState == FormWindowState.Maximized;
        }

        //================================================================================
        // OnLoad
        //    Если выбрано сохранение позиции формы в реестре, то загружаем из него
        //================================================================================
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            if (saveToRegistry)
            {
                try
                {
                    string value = (string)Registry.LocalMachine.OpenSubKey(RegPath).GetValue("SavePositionForm " + this.Name);
                    string[] s = value.Split(' ');
                    this.Position = new FormPosition(Convert.ToInt32(s[0]), Convert.ToInt32(s[1]), Convert.ToInt32(s[2]), Convert.ToInt32(s[3]), Convert.ToBoolean(s[4]));
                }
                catch
                { 
                    // Если не удалось ну и черт с ним. Покажем форму в дефолтном месте
                }
            }
        }

        //================================================================================
        // OnClosing
        //    Сохраняем позицию формы в реестр если надо
        //================================================================================
        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            base.OnClosing(e);
            
            if (saveToRegistry)
            {
                Registry.LocalMachine.CreateSubKey(RegPath).SetValue("SavePositionForm " + this.Name,
                    position.Location.X.ToString() + ' ' +
                    position.Location.Y.ToString() + ' ' +
                    position.Size.Width.ToString() + ' ' +
                    position.Size.Height.ToString() + ' ' +
                    position.Maximized.ToString());
            }
        }
    }    
}
