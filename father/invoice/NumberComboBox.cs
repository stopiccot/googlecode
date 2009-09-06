using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace SP.VisualComponents
{
    public class NumberComboBox : ComboBox
    {
        private string oldText;

        public NumberComboBox()
        {
            this.Value = 0;
        }

        public int Value
        {
            get { return Convert.ToInt32(Text); }
            set { Text = value.ToString(); }
        }

        protected override void OnTextChanged(EventArgs e)
        {
            try
            {
                int i = Convert.ToInt32(Text);
            }
            catch //( Exception ex )
            {
                Text = oldText;
                return;
            }

            oldText = Text;

            base.OnTextChanged(e);
        }

        protected override void OnKeyPress(KeyPressEventArgs e)
        {
            if (Text == "0") Text = "";

            if ( ( Text.Length < 9 && ("0123456789".IndexOf(e.KeyChar) != -1 ) || e.KeyChar == (char)8))
                base.OnKeyPress(e);
            else e.KeyChar = (char)0;
        }
    }
}
