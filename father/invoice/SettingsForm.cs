using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Invoice
{
    public partial class SettingsForm : Form
    {
        public SettingsForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            (new EditCompanyForm()).ShowSettingsDialog(this.Left + this.Width + 10, this.Top);
        }

        private void SettingsForm_Shown(object sender, EventArgs e)
        {
            templatePath.Text = Base.templateDoc;
            prices.Lines = Base.prices;
            deleteCheckBox.Checked = Base.confirmDelete;
            unpayCheckBox.Checked = Base.confirmUnpay;
        }

        private void changeTemplate_Click(object sender, EventArgs e)
        {
            openFileDialog.FileName = "";
            openFileDialog.Filter = "Документ Word|*.doc";
            if (openFileDialog.ShowDialog() == DialogResult.OK)
                templatePath.Text = openFileDialog.FileName;
        }

        private void applyButtonClick(object sender, EventArgs e)
        {
            Base.prices = prices.Lines;
            Base.templateDoc = templatePath.Text;
            Base.confirmDelete = deleteCheckBox.Checked;
            Base.confirmUnpay = unpayCheckBox.Checked;
            Close();
        }

        private void cancelButtonClick(object sender, EventArgs e)
        {
            Close();
        }
    }
}