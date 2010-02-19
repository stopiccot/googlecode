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

            int count = DateTime.Now.Year - 2009 + 1;
            
            Label[] labels = new Label[count];
            Button[] buttons = new Button[count];
            TextBox[] textBoxes = new TextBox[count];

            for (int i = 0; i < count; i++)
            {
                labels[i] = new Label();
                labels[i].Text = "Папка для накладных " + (2009 + i).ToString() + " года";
                labels[i].AutoSize = true;
                labels[i].Location = new Point(templatePathLabel.Left, templatePathLabel.Top + 40 + 40 * i);

                buttons[i] = new Button();
                buttons[i].Text = "Выбрать";
                buttons[i].Location = new Point(changeTemplateButton.Left, changeTemplateButton.Top + 40 + 40 * i);
                buttons[i].Size = changeTemplateButton.Size;

                textBoxes[i] = new TextBox();
                textBoxes[i].Text = "D:\\code\\" + (2009 + i).ToString() + ".doc";
                textBoxes[i].Location = new Point(templatePathEdit.Left, templatePathEdit.Top + 40 + 40 * i);
                textBoxes[i].Size = new Size(268, 20);
                textBoxes[i].ReadOnly = true;

                this.Controls.Add(labels[i]);
                this.Controls.Add(buttons[i]);
                this.Controls.Add(textBoxes[i]);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            (new EditCompanyForm()).ShowSettingsDialog(this.Left + this.Width + 10, this.Top);
        }

        private void SettingsForm_Shown(object sender, EventArgs e)
        {
            templatePathEdit.Text = Base.templateDoc;
            toolTip.SetToolTip(templatePathEdit, templatePathEdit.Text);
            
            prices.Lines = Base.prices;
            deleteCheckBox.Checked = Base.confirmDelete;
            unpayCheckBox.Checked = Base.confirmUnpay;
        }

        private void changeTemplate_Click(object sender, EventArgs e)
        {
            openFileDialog.FileName = "";
            openFileDialog.Filter = "Документ Word|*.doc";
            if (openFileDialog.ShowDialog() == DialogResult.OK)
                templatePathEdit.Text = openFileDialog.FileName;
        }

        private void applyButtonClick(object sender, EventArgs e)
        {
            Base.prices = prices.Lines;
            Base.templateDoc = templatePathEdit.Text;
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