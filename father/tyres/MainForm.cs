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

        private void leftFrontTyre_ValueChanged(object sender, EventArgs e)
        {
            //..
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            //...
            //leftFrontTyre.Text = (4.3).ToString("0.0");
        }

        private void leftFrontTyre_SelectedItemChanged(object sender, EventArgs e)
        {
            this.Text += ".";
        }
    }
}
