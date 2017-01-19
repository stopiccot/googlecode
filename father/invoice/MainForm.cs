using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Reflection;
using System.Windows.Forms;
using System.IO;

namespace Invoice
{
    public partial class MainForm : Stopiccot.SavePositionForm
    {
        private ColumnSorter columnSorter;
        private EditBillForm editBillForm;
        private SelectDateForm selectDateForm;

        //================================================================================
        // MainForm
        //================================================================================
        public MainForm()
        {
            InitializeComponent();

            // Версия в названии главной формы
            this.Text = "Счёт-фактуры " + Utils.ToStringWithoutZeroes(new Version(Application.ProductVersion));

            // Сортировка колонок
            listView.ListViewItemSorter = columnSorter = new ColumnSorter();

            // Загружаем базу и запихиваем счёт-фактуры в listView
            Base.Load();
            buildBillList();

            // Выставляем запомненную позицию формы
            this.Position = Base.FormPosition;

            // Выставляем запомненную ширину для каждой колонки
            foreach (ColumnHeader column in listView.Columns)
                column.Width = Base.columnWidth[column.Index];

            toggleToolButton.Checked = Base.showPayed;

            // Создаём все вспомогательные формы
            editBillForm = new EditBillForm();
            selectDateForm = new SelectDateForm();

            // Код апдейтера юзает WebClient.DownloadStringAsync, который хоть
            // и Async, но порядочно тормозит (4-5 с.) Поэтому делаем ему
            // "принудительный Async".
            backgroundWorker.RunWorkerAsync();
        }

        //================================================================================
        // backgroundWorker_DoWork
        //================================================================================
        private void backgroundWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            // Проверяем обновление
            var updater = new Update.Updater("https://raw.githubusercontent.com/stopiccot/googlecode/master/father/releases/invoice/invoice2-version.xml");
            updater.checkForUpdates();
        }

        //================================================================================
        // MainForm_FormClosed
        //    Закрытие формы - всё сохраняем и закрываемся
        //================================================================================
        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Base.FormPosition = this.Position;
            Base.Save();
            Word.Close();
        }

        //================================================================================
        // buildBillList
        //    Строит список всех счёт-фактур.
        //================================================================================
        private void buildBillList()
        {
            listView.Items.Clear();

            // Добавляем элементы сначала во временный список, т.к. если напрямую
            // добавлять каждый элемент по-отдельности используя listView.Items.Add
            // будет неимоверно пиделить т.к. оно перерисовывает каждый раз после добавления
            var items = new List<BillListViewItem>();

            for (int i = 0; i < Base.billList.Count; i++)
            {
                Bill bill = Base.billList[i];

                // Оплаченные счёт-фактуры показываем только если стоит соотвествующий флажок
                if (Base.showPayed || !bill.Payed)
                    items.Add(new BillListViewItem(bill, i));
            }

            // За один раз добавляем все счёт-фактуры
            listView.Items.AddRange(items.ToArray());

            listViewSelectionChanged(null, null);
        }

        //================================================================================
        // createNewBill
        //    Создание новой счёт-фактуры
        //================================================================================
        private void createNewBill(object sender, EventArgs e)
        {
            var newBill = new Bill();
            newBill.Add();

            if (editBillForm.EditBill(Base.billList.Count - 1, false))
            {
                // Добавляем в список и выделяем
                listView.Items.Add(new BillListViewItem(Base.billList[Base.billList.Count - 1], Base.billList.Count - 1));
                listView.SelectedIndex = listView.Items.Count - 1;
            }
            else
            {
                Base.billList.RemoveAt(Base.billList.Count - 1);
            }
        }

        //================================================================================
        // listView_DoubleClick
        //    Даблтык на элемент списка
        //================================================================================
        private void listView_DoubleClick(object sender, EventArgs e)
        {
            // Если какая-то счёт-фактура выделена - редактируем её
            int index = listView.TranslatedSelectedIndex;
            if (index != -1)
            {
                if (editBillForm.EditBill(index, true))
                {
                    int selectedIndex = listView.SelectedIndex;

                    // Апдейтим один айтем листа, а не целый лист
                    listView.Items[listView.SelectedIndex] = new BillListViewItem(Base.billList[index], index);

                    listView.SelectedIndex = selectedIndex;
                }
            }
        }

        //================================================================================
        // listView_ColumnWidthChanged
        //    Апдейтим минимальные размеры формы при изменении размеров колонок listView
        //================================================================================
        private void listView_ColumnWidthChanged(object sender, ColumnWidthChangedEventArgs e)
        {
            int minWidth = 12;

            foreach (ColumnHeader column in listView.Columns)
                minWidth += (Base.columnWidth[column.Index] = column.Width);

            this.MinimumSize = new Size(minWidth, 209);
        }

        //================================================================================
        // DeleteInvoices
        //    Удаление счёт-фактур
        //================================================================================
        delegate bool FilterFunction<T>(T item);

        private void DeleteInvoices(string confirmText, FilterFunction<BillListViewItem> filterFunction)
        {
            if (!Base.confirmDelete ||
                MessageBox.Show(confirmText, "Подтверждение", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation) == DialogResult.Yes)
            {
                List<int> indicesToDelete = new List<int>();

                foreach (BillListViewItem item in listView.Items)
                    if (filterFunction(item))
                        indicesToDelete.Add(item.Index);

                indicesToDelete.Sort();

                int i = 0;
                foreach (int index in indicesToDelete)
                {
                    BillListViewItem deletingItem = (BillListViewItem)listView.Items[index - i];

                    for (int j = index - i + 1; j < listView.Items.Count; j++)
                    {
                        BillListViewItem item = (BillListViewItem)listView.Items[j];
                        if (item.translatedIndex > deletingItem.translatedIndex)
                            item.translatedIndex--;
                    }

                    Base.billList.RemoveAt(deletingItem.translatedIndex);
                    listView.Items.RemoveAt(index - i);

                    i++;
                }

                listViewSelectionChanged(null, null);
            }
        }

        //================================================================================
        // listViewSelectionChanged
        //    Чтоб дизэйблить кнопки в тулбаре, когда ничего не выделено.
        //================================================================================
        private void listViewSelectionChanged(object sender, ListViewItemSelectionChangedEventArgs e)
        {
            wordToolButton.Enabled = deleteToolButton.Enabled = printToolButton.Enabled = (listView.SelectedItems.Count != 0);
        }

        //================================================================================
        // listView_ColumnClick
        //    Клик по колонке listView. Сортировка списка.
        //================================================================================
        private void listView_ColumnClick(object sender, ColumnClickEventArgs e)
        {
            if (e.Column == columnSorter.SortColumn)
            {
                // Если список уже отсортирован по этой колонке, то меняем порядок сортировке
                columnSorter.Order = columnSorter.Order == SortOrder.Ascending ? SortOrder.Descending : SortOrder.Ascending;
            }
            else
            {
                // Если выбрали другую колонку, то сортируем по возрастанию
                columnSorter.SortColumn = e.Column; // Передаём сортеру номер колонки
                columnSorter.Order = SortOrder.Ascending;
            }

            listView.Sort();
        }

        //================================================================================
        // listView_ItemCheck
        //    Клик на чекбокс айтема в listView
        //================================================================================
        private void listView_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            // Если пытаемся снять галочку и в настройках выставлена проверка, то лишний
            // раз переспрашиваем
            if (e.CurrentValue == CheckState.Checked)
                if (Base.confirmUnpay && MessageBox.Show("Эта счёт-фактура точно не оплачена?", "Подтверждение", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                    e.NewValue = CheckState.Checked;

            Base.billList[listView.Translate(e.Index)].Payed = e.NewValue == CheckState.Checked;
        }

        //================================================================================
        // wordToolButton_Click
        //    Открыть doc-файл для выбранной счёт-фактуры в Microsoft Word
        //================================================================================
        private void wordToolButton_Click(object sender, EventArgs e)
        {
            // Создаём doc-файл
            string filename = CreateWordDocument(Base.billList[listView.TranslatedSelectedIndex]);

            // И если всё прошло успешно, то открываем его
            if (filename != null)
            {
                try
                {
                    System.Diagnostics.ProcessStartInfo info = new System.Diagnostics.ProcessStartInfo(filename);
                    info.UseShellExecute = true;
                    info.Verb = "open";
                    System.Diagnostics.Process.Start(info);
                }
                catch
                {
                    // По неведомым причинам на некоторых компах нормальный способ не работает
                    // пробуем открывать принудительно вордом
                    System.Diagnostics.ProcessStartInfo info = new System.Diagnostics.ProcessStartInfo();
                    info.FileName = "WINWORD.EXE";
                    info.Arguments = filename;
                    System.Diagnostics.Process.Start(info);
                }
            }
        }

        //================================================================================
        // printToolButton_Click
        //    Печать doc-файла для выбранной счёт-факутуры
        //================================================================================
        private void printToolButton_Click(object sender, EventArgs e)
        {
            // Создаём doc-файл
            string filename = CreateWordDocument(Base.billList[listView.TranslatedSelectedIndex]);

            // И если всё прошло успешно, то печатаем его
            if (filename != null)
            {
                Word.OpenDocument(filename, true);
                Word.PrintDocument();
                Word.CloseDocument();
            }
        }

        //================================================================================
        // deleteToolButton_Click
        //    Удаляет выделенные счёт-фактуры
        //================================================================================
        private void deleteToolButton_Click(object sender, EventArgs e)
        {
            string confirmText = listView.SelectedItems.Count == 1 ? "Удалить эту счёт-фактуру?" : "Удалить эти счёт-фактуры?";

            DeleteInvoices(confirmText, delegate(BillListViewItem item)
            {
                return listView.SelectedItems.Contains(item);
            });
        }

        //================================================================================
        // toggleToolButton_Click
        //================================================================================
        private void toggleToolButton_Click(object sender, EventArgs e)
        {
            Base.showPayed = toggleToolButton.Checked;

            // Запоминаем выделенный элемент
            int index = listView.TranslatedSelectedIndex;

            // и полностью перестраиваем список
            buildBillList();

            // Пытаемся восстановить выделение, но это не всегда возможно т.к. данная счёт-фактура
            // могла быть оплачена, а мы как раз спрятали все оплаченные счёт-фактуры
            if (index != -1)
            {
                listView.TranslatedSelectedIndex = index;
                if (listView.SelectedIndex != -1)
                    listView.Items[listView.SelectedIndex].EnsureVisible();
            }
        }

        //================================================================================
        // deletePayedToolButton_Click
        //    Массовое удаление оплаченных счёт-фактур
        //================================================================================
        private void deletePayedToolButton_Click(object sender, EventArgs e)
        {
            DateTime date = DateTime.Now;
            if (selectDateForm.PickDate(ref date))
            {
                List<int> indicesToRemove = new List<int>();

                for (int i = 0; i < Base.billList.Count; i++)
                {
                    Bill bill = Base.billList[i];
                    if (bill.Payed && bill.Date < date)
                        indicesToRemove.Add(i);
                }

                indicesToRemove.Sort();
                for (int i = 0; i < indicesToRemove.Count; i++)
                    Base.billList.RemoveAt(indicesToRemove[i] - i);

                buildBillList();
            }
        }

        //================================================================================
        // settingsToolButton_Click
        //    Показывает диалог настроек
        //================================================================================
        private void settingsToolButton_Click(object sender, EventArgs e)
        {
            (new SettingsForm()).ShowDialog();
        }

        //================================================================================
        // MaterializeTemplateDocument
        //    Если необходимо сохраняем из ресурсов на диск файл-шаблон
        //================================================================================
        private void MaterializeTemplateDocument()
        {
            Base.templateDoc = Path.Combine(Directory.GetCurrentDirectory(), "template-" + Utils.ToStringWithoutZeroes(new Version(Application.ProductVersion)) + ".doc");

            if (!File.Exists(Base.templateDoc))
            {
                using (Stream output = File.Create(Base.templateDoc))
                {
                    using (Stream input = Assembly.GetExecutingAssembly().GetManifestResourceStream("Invoice.template.doc"))
                    {
                        byte[] buffer = new byte[10240];
                        int bytesRead = 0;
                        while ((bytesRead = input.Read(buffer, 0, 10240)) > 0)
                        {
                            output.Write(buffer, 0, bytesRead);
                        }
                    }
                }
            }
        }

        //================================================================================
        // FillWorkDone
        //================================================================================
        private void FillWorkDone(Bill bill)
        {
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

            if ((bill.WorkDone & 16) == 16)
                s += (++n).ToString() + ".Расчёт деф. эксплуатации ТС.\r";

            if ((bill.WorkDone & 32) == 32)
                s += (++n).ToString() + ".Расчёт стоимости ТС.\r";

            if ((bill.WorkDone & 64) == 64)
                s += (++n).ToString() + ".Перерасчет цен согласно данных сервера нац. цен ( БАЭС ).\r";

            Word.Replace("%workDone%", s);
        }

        //================================================================================
        // FillWorkDoneString
        //================================================================================
        private void FillWorkDoneString(Bill bill)
        {
            string s = "";

            if ((bill.WorkDone & 1) == 1)
                s += "проведение осмотра, составление акта осмотра, ";

            if ((bill.WorkDone & 2) == 2)
                s += "cocтавление заключения о размере вреда, ";

            if (s.Length > 0)
                s = Utils.Capitalize(s).Substring(0, s.Length - 2);

            Word.Replace("%workDoneString%", s);
        }

        //================================================================================
        // FillSubprices
        //================================================================================
        private void FillSubprices(Bill bill)
        {
            string s = "";

            if (((bill.WorkDone & 1) == 1) || ((bill.WorkDone & 2) == 2))
                s += bill.Price2.ToString() + "\v";

            if ((bill.WorkDone & 4) == 4)
                s += bill.Price3.ToString() + "\v";

            if ((bill.WorkDone & 8) == 8)
                s += bill.Price4.ToString() + "\v";

            if ((bill.WorkDone & 16) == 16)
                s += bill.Price5.ToString() + "\v";

            if ((bill.WorkDone & 32) == 32)
                s += bill.Price6.ToString() + "\v";

            if ((bill.WorkDone & 64) == 64)
                s += bill.Price7.ToString() + "\v";

            Word.Replace("%subprices%", s);
        }

        //================================================================================
        // FillSubworkString
        //================================================================================
        private void FillSubworkString(Bill bill)
        {
            string s = "";

            if ((bill.WorkDone & 4) == 4)
                s += "- Выезд по месту осмотра.\v";

            if ((bill.WorkDone & 8) == 8)
                s += "- Расчёт вреда в случае гибели ТС.\v";

            if ((bill.WorkDone & 16) == 16)
                s += "- Расчёт деф. эксплуатации ТС.\v";

            if ((bill.WorkDone & 32) == 32)
                s += "- Расчёт стоимости ТС.\v";

            if ((bill.WorkDone & 64) == 64)
                s += "- Перерасчет цен согласно данных сервера нац. цен ( БАЭС ).\v";

            Word.Replace("%subworkString%", s);
        }

        //================================================================================
        // CreateWordDocument
        //    Создаёт doc-файл для данной счёт-фактуры
        //================================================================================
        private string CreateWordDocument(Bill bill)
        {
            MaterializeTemplateDocument();
            
            int year = bill.Date.Year;
            string filename = null;

            try
            {
                string workingDirectory = Base.workingDirectory[year - SettingsForm.beginYear];

                // Проверяем задана ли папка в которую нужно сохранять счёт-фактуры этого года
                if (!Directory.Exists(workingDirectory))
                    throw new Exception();

                // Полный путь к создаваемому doc-файлу
                filename = Path.Combine(workingDirectory, "сч-ф" + bill.Company.ShortName + bill.Number.ToString() + '-' + bill.Date.Month.ToString("00") + ".doc");
            }
            catch
            {
                MessageBox.Show("Не задана папка для счёт-фактур " + year.ToString() + " года.\n\rВыберите папку в настройках программы.", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return null;
            }

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

            FillWorkDone(bill);
            FillWorkDoneString(bill);
            FillSubprices(bill);
            FillSubworkString(bill);

            Word.SaveAs(filename);
            Word.CloseDocument();

            return filename;
        }

        private void listView_KeyDown(object sender, KeyEventArgs e)
        {
            //...
        }        
    }
}