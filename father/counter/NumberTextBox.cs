using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace SP.VisualComponents
{
    class NumberTextBox : TextBox
    {
        public int Value
        {
            get 
            {
                if ( Multiline )
                    throw new Exception("Value property accessed when NumberTextBox is in multiline mode");
                return Convert.ToInt32(Text);
            }
            set
            {
                if (Multiline)
                    throw new Exception("Value property accessed when NumberTextBox is in multiline mode");
                Text = value.ToString();
            }
        }
        protected override void OnKeyPress(KeyPressEventArgs e)
        {
            if (this.Multiline)
            {
                if (Lines[GetLineFromCharIndex(SelectionStart)] == "0")
                    Lines[GetLineFromCharIndex(SelectionStart)] = "";
            } else
                if (Text == "0") Text = "";

            if (Text.Length >= 9 || ( "0123456789".IndexOf(e.KeyChar) == -1 && e.KeyChar != (char)8 && e.KeyChar != (char)13) )
                e.KeyChar = (char)0;

            base.OnKeyPress(e);
        }

        protected override void OnLeave(EventArgs e)
        {
            if (Text == "") Text = "0";

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
