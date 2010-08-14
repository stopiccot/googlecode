using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace tyres
{
    public partial class MainForm : Stopiccot.SavePositionForm
    {
        public MainForm()
        {
            InitializeComponent();
            this.SavePositionToRegistry = true;
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            leftFrontTyre.Value = (maxTread.Value + minTread.Value) / 2.0m;
            rightFrontTyre.Value = (maxTread.Value + minTread.Value) / 2.0m;
            leftRearTyre.Value = (maxTread.Value + minTread.Value) / 2.0m;
            rightRearTyre.Value  = (maxTread.Value + minTread.Value) / 2.0m;
        }

        private void updatePrice(object sender, EventArgs e)
        {
            try
            {
                decimal delta = maxTread.Value - minTread.Value;
                decimal result = 0;

                //this.Text = leftFrontTyre.Value.ToString() + " " + rightFrontTyre.Value.ToString() +
                //    " " + leftRearTyre.Value.ToString() + " " + rightRearTyre.Value.ToString() + " " + maxTread.Value.ToString() + " " + minTread.Value.ToString();

                result += (leftFrontTyre.Value - minTread.Value) / delta;
                result += (rightFrontTyre.Value - minTread.Value) / delta;
                result += (leftRearTyre.Value - minTread.Value) / delta;
                result += (rightRearTyre.Value - minTread.Value) / delta;

                result -= 4 * 0.5m;
                result *= 4 * decimal.Parse(tуrePrice.Text);
                resultLabel.Text = result.ToString("0.00");

                if (result > 0.0m)
                    resultLabel.ForeColor = Color.Green;
                else if (result < 0.0m)
                    resultLabel.ForeColor = Color.Red;
                else
                    resultLabel.ForeColor = Color.Black;
            }
            catch
            {
                resultLabel.Text = "Ошибка";
                resultLabel.ForeColor = Color.Red;
            }
        }
    }
}
