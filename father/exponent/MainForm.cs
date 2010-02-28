using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace exponent
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private double[] Tf = { 0.08, 0.07, 0.08, 0.07, 0.06, 0.07, 0.06, 0.05, 0.04, 0.1, 0.16, 0.09, 0.12 };
        private double[] Lf = { 0.0055, 0.0050, 0.0045, 0.0035, 0.0025, 0.0045, 0.0035, 0.0025, 0.0015, 0.003, 0.001, 0.002, 0.001 };

        private double parseDoubleAnyway(string value)
        {
            try
            {
                return Convert.ToDouble(value);
            }
            catch
            {
                try
                {
                    return Convert.ToDouble(value.Replace('.',','));
                }
                catch
                {
                    try
                    {
                        return Convert.ToDouble(value.Replace(',', '.'));
                    }
                    catch
                    {
                        throw new Exception();
                    }
                }
            }
        }

        private double getValue(TextBox textBox)
        {
            try
            {
                textBox.ForeColor = Color.Black;
                return parseDoubleAnyway(textBox.Text);
            }
            catch
            {
                textBox.ForeColor = Color.Red;
            }

            return Double.NegativeInfinity;
        }

        private double zero = 0.0;

        private void calculate(object sender, EventArgs e)
        {
            double T = Tf[typeComboBox.SelectedIndex], L = Lf[typeComboBox.SelectedIndex];

            double k = T * getValue(TTextBox) + L * getValue(LTextBox);

            if (k > 0.0)
                resultLabel.Text = ((1.0 - Math.Exp(-k)) * 100.0).ToString("00.00") + "%";
            else
                resultLabel.Text = zero.ToString("00.00") + "%";
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            typeComboBox.SelectedIndex = 0;
        }
    }
}
