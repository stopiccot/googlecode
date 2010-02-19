using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace Invoice
{
    public partial class MainForm : SavePositionForm
    {
        private ColumnSorter columnSorter;

        public MainForm()
        {
            InitializeComponent();

            // Версия в названии главной формы
            Version currentVersion = new Version(Application.ProductVersion);
            this.Text = "Cчёт-фактуры " + currentVersion.Major + "." + currentVersion.Minor + "." + currentVersion.Build;

            // Проверяем обновление
            Update.Updater updater = new Update.Updater("http://stopiccot.googlecode.com/files/invoice-version.xml");
            updater.checkForUpdates();

            listView.ListViewItemSorter = columnSorter = new ColumnSorter();

            Base.Load();

            this.Position = Base.FormPosition;
            toggleToolButton.Checked = Base.showPayed;

            foreach (ColumnHeader column in listView.Columns)
                column.Width = Base.columnWidth[column.Index];
        }

        private void newBill(object sender, EventArgs e)
        {
            (new Bill()).Add();
            (new EditBillForm()).Show(Base.billList.Count - 1, false);
            RebuildList();
            listView.SelectedIndex = listView.Items.Count - 1;
        }

        private void listView_DoubleClick(object sender, EventArgs e)
        {
            int index = listView.SelectedIndex;
            if ( index >= 0 )
            {
                (new EditBillForm()).Show(listView.TranslatedIndex, true);
                RebuildList();
                listView.SelectedIndex = index;
            }
        }

        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Base.FormPosition = this.Position;
            Base.Save();
            Word.Close();
        }

        private bool updatingList = false;

        private void RebuildList()
        {
            if (updatingList) return; updatingList = true;

            listView.Items.Clear();

            int i = -1;

            foreach (Bill bill in Base.billList)
                if ( ++i >= 0 && (Base.showPayed || !bill.Payed) )
                    listView.Items.Add(new MyListViewItem(new string[] 
                        { bill.Number.ToString() + '/' + bill.Date.Month.ToString(),
                        bill.Date.ToString("dd.MM.yy"),
                        bill.Company.ShortName, bill.Price.ToString() },
                        bill.Payed, i));

            updatingList = false;

            listViewSelectionChanged(null, null);
        }

        private void listView_ColumnWidthChanged(object sender, ColumnWidthChangedEventArgs e)
        {
            int minWidth = 12;

            foreach (ColumnHeader column in listView.Columns)
                minWidth += (Base.columnWidth[column.Index] = column.Width);

            this.MinimumSize = new Size(minWidth, 209);
        }

        private void toolStripMenuItem4_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void settingsMenuButton_Click(object sender, EventArgs e)
        {
            (new SettingsForm()).ShowDialog();
        }

        delegate bool FilterFunction<T>(T item);

        private List<T> Filter<T>(List<T> list, FilterFunction<T> f)
        {
            List<T> newList = new List<T>();

            foreach (T t in list)
                if (!f(t))
                    newList.Add(t);

            return newList;
        }

        private void DeleteInvoices(string confirmText, FilterFunction<MyListViewItem> filterFunction)
        {
            if (!Base.confirmDelete ||
                MessageBox.Show(confirmText, "Подтверждение", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation) == DialogResult.Yes)
            {
                List<int> indexes = new List<int>();

                foreach (MyListViewItem item in listView.Items)
                    if (filterFunction(item))
                        indexes.Add(item.Index);

                int i = 0;
                foreach (int index in indexes)
                {
                    Base.billList.RemoveAt(((MyListViewItem)listView.Items[index - i]).translatedIndex - i);
                    listView.Items.RemoveAt(index - i);
                    i++;
                }

                listViewSelectionChanged(null, null);
            }
        }

        private void toolStripButton4_Click(object sender, EventArgs e)
        {
            DeleteInvoices("Удалить данные счёт-фактуры?", delegate(MyListViewItem item)
            {
                return listView.SelectedItems.Contains(item);
            });
        }

        private void deletePayedToolButton_Click(object sender, EventArgs e)
        {
            if ( listView.SelectedItems.Count > 1 )
            {
                DeleteInvoices("Вы уверены, что хотите удалить оплаченные счёт-фактуры?", delegate(MyListViewItem item)
                {
                    return item.Checked && listView.SelectedItems.Contains(item);
                });
            }
            else
            {
                Base.billList = Filter<Bill>(Base.billList, delegate(Bill invoice)
                {
                    return invoice.Payed;
                });

                RebuildList();
            }
        }

        private void listViewSelectionChanged(object sender, ListViewItemSelectionChangedEventArgs e)
        {
            wordToolButton.Enabled = deleteToolButton.Enabled = printToolButton.Enabled = (listView.SelectedItems.Count != 0);
        }

        private void listView_ColumnClick(object sender, ColumnClickEventArgs e)
        {
            if (e.Column == columnSorter.SortColumn)
                columnSorter.Order = columnSorter.Order == SortOrder.Ascending ? SortOrder.Descending : SortOrder.Ascending;
            else
            {
                columnSorter.SortColumn = e.Column;
                columnSorter.Order = SortOrder.Ascending;
            }
            listView.Sort();
        }

        private void listView_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            if (e.CurrentValue == CheckState.Checked)
                if (Base.confirmUnpay && MessageBox.Show("Вы уверены, что данная счёт-фактура не оплачена?", "Подтверждение", MessageBoxButtons.YesNo) == DialogResult.No)
                    e.NewValue = CheckState.Checked;

            ((Bill)Base.billList[listView.Translate(e.Index)]).Payed = e.NewValue == CheckState.Checked;
        }

        private void toggleToolButton_Click(object sender, EventArgs e)
        {
            Base.showPayed = toggleToolButton.Checked;
            RebuildList();
        }

        private void MainForm_Shown(object sender, EventArgs e)
        {
            RebuildList();
        }

        private void wordToolButton_Click(object sender, EventArgs e)
        {
            string s = CreateWordDocument((Bill)Base.billList[listView.TranslatedIndex]);

            if (s != null)
            {
                System.Diagnostics.ProcessStartInfo info = new System.Diagnostics.ProcessStartInfo(s);
                info.UseShellExecute = true;
                info.Verb = "open";
                System.Diagnostics.Process.Start(info);
            }
        }

        private void printToolButton_Click(object sender, EventArgs e)
        {
            string s = CreateWordDocument((Bill)Base.billList[listView.TranslatedIndex]);

            if (s != null)
            {
                Word.OpenDocument(s, true);
                Word.PrintDocument();
                Word.CloseDocument();
            }
        }

        private string CreateWordDocument(Bill bill)
        {
            if (!File.Exists(Base.templateDoc))
            {
                MessageBox.Show("Файл шаблон не обнаружен", "Ошибка");
                return null;
            }

            string FileName = Path.GetDirectoryName(Base.templateDoc) + "\\сч-ф" + bill.Company.ShortName + bill.Number.ToString() + '-' + bill.Date.Month.ToString("00") + ".doc";

            Word.OpenDocument(Base.templateDoc, true);

            Word.Replace("%number%", bill.Number.ToString() + '/' + bill.Date.Month.ToString());
            Word.Replace("%date%", bill.Date.ToString("d.MM.yyyy"));
            Word.Replace("%fullName%", bill.Company.FullName);
            Word.Replace("%contractNumber%", bill.Company.ContractNumber);
            Word.Replace("%contractDate%", bill.Company.ContractDate.ToString("d.MM.yyyy"));
            Word.Replace("%car%", bill.Car);
            Word.Replace("%price%", bill.Price.ToString());
            Word.Replace("%priceString%", Utils.ConvertToString(bill.Price));
            Word.Replace("%director%", bill.Company.Director);
            Word.Replace("%directorName%", Utils.ExtractDirectorName(bill.Company.Director));

            int n = 0; string s = "";

            if ((bill.WorkDone & 1) == 1)
                s += (++n).ToString() + ".Акт осмотра.\r";

            if ((bill.WorkDone & 2) == 2)
            {
                s += (++n).ToString() + ".Заключение о размере вреда.\r";
                s += (++n).ToString() + ".Калькуляция ремонтно-восстановительных работ.\r";
            }

            if ((bill.WorkDone & 4) == 4)
                s += (++n).ToString() + ".Выезд по месту осмотра.\r";

            if ((bill.WorkDone & 8) == 8)
                s += (++n).ToString() + ".Расчёт вреда в случае гибели ТС.\r";

            Word.Replace("%workDone%", s);

            s = "";

            if ((bill.WorkDone & 1) == 1)
                s += "проведение осмотра, составление акта осмотра, ";

            if ((bill.WorkDone & 2) == 2)
                s += "cocтавление заключения о размере вреда, ";

            if (s.Length > 0)
                s = Utils.UpFirstLetter(s).Substring(0, s.Length - 2);

            Word.Replace("%workDoneString%", s);

            Word.SaveAs(FileName);

            Word.CloseDocument();

            return FileName;
        }

        private void listView_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyValue == 46)
                MessageBox.Show("Delete!");
        }

        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            (new SettingsForm()).ShowDialog();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            //...
        }
    }
}