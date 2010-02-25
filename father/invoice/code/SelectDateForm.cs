using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Invoice
{
    //================================================================================
    // SelectDateForm
    //    Форма для выбора даты при массовом удалении
    //================================================================================
    public partial class SelectDateForm : Form
    {
        public SelectDateForm()
        {
            InitializeComponent();
        }

        private bool confirm;

        //================================================================================
        // PickDate
        //    Подтверждение удаления и выбор даты
        //================================================================================
        public bool PickDate(ref DateTime date)
        {
            confirm = false;

            ShowDialog();

            if (confirm)
                date = dateTimePicker.Value;

            return confirm;
        }

        //================================================================================
        // confirmButton_Click
        //================================================================================
        private void confirmButton_Click(object sender, EventArgs e)
        {
            confirm = true;
            Close();
        }

        //================================================================================
        // cancelButton_Click
        //================================================================================
        private void cancelButton_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
