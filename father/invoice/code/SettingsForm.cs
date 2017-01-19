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
        public static int beginYear = 2008; // Первый путь в Base.workingDirectory соответствует 2008 году
        private int prevYear, currYear;

        //================================================================================
        // SettingsForm()
        //================================================================================
        public SettingsForm()
        {
            InitializeComponent();
        }

        //================================================================================
        // SettingsForm_Shown
        //    Инициализация проводимая при загрузке формы
        //================================================================================
        private void SettingsForm_Shown(object sender, EventArgs e)
        {
            DateTime dateTime = DateTime.Now;

            // С декабря уже начинаем перещёлкиваться на следующий год
            currYear = dateTime.Month > 11 ? dateTime.Year + 1 : dateTime.Year;
            prevYear = currYear - 1;

            // Выставляем имена для лэблов
            prevYearDirLabel.Text = "Папка для счёт-фактур " + prevYear.ToString() + " года";
            currYearDirLabel.Text = "Папка для счёт-фактур " + currYear.ToString() + " года";

            // Загрузка данных из базы
            prices.Lines           = Base.prices;
            deleteCheckBox.Checked = Base.confirmDelete;
            unpayCheckBox.Checked  = Base.confirmUnpay;
            prevYearDirPath.Text   = Base.workingDirectory[prevYear - beginYear];
            currYearDirPath.Text   = Base.workingDirectory[currYear - beginYear];
        }

        //================================================================================
        // editCompaniesButton_Click
        //    Показываем форму редактирования компаний
        //================================================================================
        private void editCompaniesButton_Click(object sender, EventArgs e)
        {
            (new EditCompanyForm()).ShowSettingsDialog(this.Left + this.Width + 10, this.Top);
        }

        //================================================================================
        // changeTemplate_Click
        //    Выбор файла-шаблона
        //================================================================================
        private void changeTemplate_Click(object sender, EventArgs e)
        {
            //...
        }

        //================================================================================
        // changePrevYearDir_Click
        //    Выбор папки для prevYear
        //================================================================================
        private void changePrevYearDir_Click(object sender, EventArgs e)
        {
            if (selectFolderDialog.ShowDialog() == DialogResult.OK)
                prevYearDirPath.Text = selectFolderDialog.SelectedPath;
        }

        //================================================================================
        // changeCurrYearDir_Click
        //    Выбор папки для currYear
        //================================================================================
        private void changeCurrYearDir_Click(object sender, EventArgs e)
        {
            if (selectFolderDialog.ShowDialog() == DialogResult.OK)
                currYearDirPath.Text = selectFolderDialog.SelectedPath;
        }

        //================================================================================
        // applyButtonClick
        //    Закрытие формы кнопкой apply
        //================================================================================
        private void applyButtonClick(object sender, EventArgs e)
        {
            // Сохраняем в базу всё, что наменяли
            Base.prices        = prices.Lines;
            Base.confirmDelete = deleteCheckBox.Checked;
            Base.confirmUnpay  = unpayCheckBox.Checked;

            Base.workingDirectory[prevYear - beginYear] = prevYearDirPath.Text;
            Base.workingDirectory[currYear - beginYear] = currYearDirPath.Text;

            Close();
        }

        //================================================================================
        // cancelButtonClick
        //    Закрытие формы кнопкой cancel
        //================================================================================
        private void cancelButtonClick(object sender, EventArgs e)
        {
            Close(); // Просто закрываем ничего не сохраняя
        }
    }
}