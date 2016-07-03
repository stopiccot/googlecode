using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using Invoice;

namespace Stopiccot.VisualComponents
{
    //================================================================================
    // NumberComboBox
    //    Комбобокс только для чисел
    //================================================================================
    public class NumberComboBox : ComboBox
    {
        private string oldText;

        public NumberComboBox()
        {
            this.Value = 0;
        }

        public const string AllowedChars = "0123456789.,";

        public decimal Value
        {
            get { return Utils.ConvertToDecimal(Text); }
            set { Text = value.ToString();  }
        }

        protected override void OnTextChanged(EventArgs e)
        {
            try
            {
                decimal i = Utils.ConvertToDecimal(Text);
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

            if ( ( Text.Length < 9 && (AllowedChars.IndexOf(e.KeyChar) != -1 ) || e.KeyChar == (char)8))
                base.OnKeyPress(e);
            else e.KeyChar = (char)0;
        }
    }
}
