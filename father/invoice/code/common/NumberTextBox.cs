using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using Invoice;

namespace Stopiccot.VisualComponents
{
    //================================================================================
    // TextBox
    //    Текстбокс только для чисел
    //================================================================================
    class NumberTextBox : TextBox
    {
        public const string AllowedChars = "0123456789.,";

        public NumberTextBox() : base()
        {
            this.Value = 0;
        }

        public decimal Value
        {
            get { return Utils.ConvertToDecimal(Text); }
            set { Text = value.ToString(); }
        }

        protected override void OnKeyPress(KeyPressEventArgs e)
        {
            if (this.Multiline)
            {
                if (Lines.Length > 0)
                {
                    int index = GetLineFromCharIndex(SelectionStart);
                    if (Lines[index] == "0")
                        Lines[index] = "";
                }
            } else
                if (Text == "0") Text = "";

            if (AllowedChars.IndexOf(e.KeyChar) == -1 && e.KeyChar != (char)8 && e.KeyChar != (char)13)
                e.KeyChar = (char)0;

            base.OnKeyPress(e);
        }

        protected override void OnLeave(EventArgs e)
        {
            int index = (Text = "\r\n" + Text + "\r\n").IndexOf("\r\n\r\n");
            while (index != -1)
            {
                Text = Text.Remove(index, 2);
                index = Text.IndexOf("\r\n\r\n", index);
            }

            Text = Text.Substring(2, Text.Length - 4);

            base.OnLeave(e);
        }
    }
}
