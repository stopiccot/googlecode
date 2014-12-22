using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Invoice
{
    public partial class EditCompanyForm : Form
    {
        public EditCompanyForm()
        {
            InitializeComponent();
            listBox.SelectedIndex = -1;
        }

        private Company selectedCompany;

        public Company ShowEditDialog(Company company, int x, int y)
        {
            SetEditingCompany(company);

            this.Left = x;
            this.Top = y;

            delButton.Visible = addButton.Visible = listBox.Visible = false;
            this.Width = 272 + (panel.Left = 9);
                        
            ShowDialog();

            return selectedCompany;
        }
                
        public void ShowSettingsDialog(int x, int y)
        {
            this.Left = x;
            this.Top = y;

            delButton.Visible = addButton.Visible = listBox.Visible = true;

            if (Base.companyList.Count > 0)
            {
                UpdateList();
                listBox.SelectedIndex = 0;
            }     

            ShowDialog();
        }

        private void UpdateList()
        {
            int selected = listBox.SelectedIndex;

            listBox.Items.Clear();

            foreach (Company company in Base.companyList)
                listBox.Items.Add(company.ShortName);

            listBox.SelectedIndex = selected;
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            Company.NewCompany();
            UpdateList();
            listBox.SelectedIndex = listBox.Items.Count - 1;
            shortName.Focus();
        }

        private void SetEditingCompany(Company? company)
        {
            if ( shortName.Enabled = fullName.Enabled = contractDate.Enabled = contractNumber.Enabled =
                 contractString.Enabled = delButton.Enabled = company != null )
            {
                selectedCompany = (Company)company;
                shortName.Text = selectedCompany.ShortName;
                fullName.Text = selectedCompany.FullName;
                contractDate.Value = selectedCompany.ContractDate;
                contractNumber.Text = selectedCompany.ContractNumber;
                contractString.Text = selectedCompany.Director;
            }
            else
                shortName.Text = fullName.Text = contractNumber.Text = contractString.Text = "";

        }

        private void listBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetEditingCompany(listBox.SelectedIndex >= 0 ? (Company)Base.companyList[listBox.SelectedIndex] : (Company?)null);
        }

        private void delButton_Click(object sender, EventArgs e)
        {
            Base.companyList.RemoveAt(listBox.SelectedIndex);
            if (listBox.SelectedIndex != 0)
                listBox.SelectedIndex--;
            else
                if (Base.companyList.Count == 0) listBox.SelectedIndex = -1;
            UpdateList();
        }

        private void shortName_TextChanged(object sender, EventArgs e)
        {
            selectedCompany.ShortName = shortName.Text;

            if (listBox.SelectedIndex >= 0)
                Base.companyList[listBox.SelectedIndex] = selectedCompany;

            UpdateList();
        }

        private void fullName_TextChanged(object sender, EventArgs e)
        {
            selectedCompany.FullName = fullName.Text;

            if ( listBox.SelectedIndex >= 0 )
                Base.companyList[listBox.SelectedIndex] = selectedCompany;
        }

        private void contractDate_ValueChanged(object sender, EventArgs e)
        {
            selectedCompany.ContractDate = contractDate.Value;

            if (listBox.SelectedIndex >= 0)
                Base.companyList[listBox.SelectedIndex] = selectedCompany;
        }

        private void contractNumber_TextChanged(object sender, EventArgs e)
        {
            selectedCompany.ContractNumber = contractNumber.Text;

            if (listBox.SelectedIndex >= 0)
                Base.companyList[listBox.SelectedIndex] = selectedCompany;
        }

        private void contractString_TextChanged(object sender, EventArgs e)
        {
            selectedCompany.Director = contractString.Text;

            if (listBox.SelectedIndex >= 0)
                Base.companyList[listBox.SelectedIndex] = selectedCompany;
        }
    }
}