using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using Invoice;

namespace Invoice
{
    public partial class EditBillForm : Form
    {
        public EditBillForm()
        {
            InitializeComponent();

            priceComboBox.Items.AddRange(Base.prices);
        }

        private void UpdateCompanies()
        {
            billCompany.Items.Clear();

            foreach (Company company in Base.companyList)
                billCompany.Items.Add(company.ShortName);                
        }

        private void validate()
        {
            applyButton.Enabled = !selectedBill.Company.Equals(Company.nullCompany) && priceComboBox.Text != "";
        }

        private Bill selectedBill, applyBill;
        private int editIndex;
        private bool customCompany;

        private void SetCompany(Company company)
        {
            selectedBill.Company = company;

            if ( customCompany )
                billCompany.Items.RemoveAt(billCompany.Items.Count - 1);

            customCompany = false;
                
            if ( selectedBill.Company.Equals(Company.nullCompany) )
                billCompany.SelectedIndex = -1;
            else
            {
                int index = Base.companyList.IndexOf(selectedBill.Company);
                if (index >= 0) billCompany.SelectedIndex = index;
                else
                {
                    customCompany = true;
                    billCompany.Items.Add('[' + company.ShortName + ']');
                    billCompany.SelectedIndex = billCompany.Items.Count - 1;                    
                }
            }
        }

        public void Show(int index, bool edit)
        {
            editIndex = index;

            applyBill = edit ? (Bill)Base.billList[editIndex] : null;
            selectedBill = ((Bill)Base.billList[editIndex]).Copy();
            
            UpdateCompanies(); 

            billDate.Value = selectedBill.Date;
            billNumber.Value = selectedBill.Number;

            SetCompany(selectedBill.Company);

            priceComboBox.Value = selectedBill.Price;
            car.Text = selectedBill.Car;

            int workDone = selectedBill.WorkDone;

            checkBox1.Checked = (selectedBill.WorkDone & 1) == 1; checkBox1.Tag = "1";
            checkBox2.Checked = (selectedBill.WorkDone & 2) == 2; checkBox2.Tag = "2";
            checkBox3.Checked = (selectedBill.WorkDone & 4) == 4; checkBox3.Tag = "4";
            checkBox4.Checked = (selectedBill.WorkDone & 8) == 8; checkBox4.Tag = "8";

            selectedBill.WorkDone = workDone;

            applyButton.Text = edit ? "Применить" : "Создать";
            applyButton.Enabled = edit;

            this.Text = (edit ? "Редактирование" : "Создание") + " счёт-фактуры";

            ShowDialog();
        }

        private void cancelButton_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void applyButton_Click(object sender, EventArgs e)
        {
            applyBill = selectedBill;
            Close();
        }

        private void EditBillForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (applyBill != null)
                Base.billList[editIndex] = applyBill;
            else
                Base.billList.RemoveAt(editIndex);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            SetCompany((new EditCompanyForm()).ShowEditDialog(selectedBill.Company, this.Left + this.Width + 10, this.Top));
        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {
            selectedBill.Date = billDate.Value;
        }

        private void billCompany_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (billCompany.SelectedIndex != -1)
                if ( !customCompany || billCompany.SelectedIndex != billCompany.Items.Count - 1 )
                    SetCompany((Company)Base.companyList[billCompany.SelectedIndex]);
            validate();
        }

        private void billNumber_ValueChanged(object sender, EventArgs e)
        {
            selectedBill.Number = (int)billNumber.Value;
        }

        private void car_TextChanged(object sender, EventArgs e)
        {
            selectedBill.Car = car.Text;
        }

        private void checkBox_CheckedChanged(object sender, EventArgs e)
        {
            selectedBill.WorkDone ^= Convert.ToInt32((string)((CheckBox)sender).Tag);
        }

        private void priceComboBox_TextChanged(object sender, EventArgs e)
        {
            if (priceComboBox.Text != "")
                selectedBill.Price = priceComboBox.Value;
            validate();
        }

        private void priceComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
     }
}