using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Invoice
{
    class BillListViewItem : ListViewItem
    {
        public int translatedIndex;

        public BillListViewItem(Bill bill, int index)
        {
            // Первая колонка - номер / месяц
            this.Text = bill.Number.ToString() + '/' + bill.Date.Month.ToString();
            // Вторая колонка - дата
            this.SubItems.Add(bill.Date.ToString("dd.MM.yy"));
            // Третья колонка - краткое название компании
            this.SubItems.Add(bill.Company.ShortName);
            // Четвёртая колонка - цена
            this.SubItems.Add(bill.Price.ToString());

            this.Checked = bill.Payed;
            translatedIndex = index;
        }

        public BillListViewItem(string[] items, bool check, int index )
        {
            if (items.Length > 0) this.Text = items[0];
            for (int i = 1; i < items.Length; ++i)
                this.SubItems.Add(items[i]);

            Checked = check;
            translatedIndex = index;
        }        
    }

    class BillListView : ListView
    {
        private bool doubleClick = false;
        private int selectedIndex = -1;

        public int SelectedIndex
        {
            get 
            { 
                return selectedIndex; 
            }
            set 
            {
                if (value >= 0)
                {
                    this.SelectedItems.Clear();

                    this.Items[value].Selected = true;
                    this.Items[value].EnsureVisible();
                    this.Items[value].Focused = true;
                }
            }
        }

        public int TranslatedSelectedIndex
        {
            get 
            {
                if (selectedIndex == -1)
                    return -1;

                return ((BillListViewItem)Items[selectedIndex]).translatedIndex; 
            }
            set
            {
                selectedIndex = -1;

                foreach (ListViewItem item in this.Items)
                {
                    if (((BillListViewItem)item).translatedIndex == value)
                    {
                        item.Selected = true;
                        item.EnsureVisible();
                        item.Focused = true;
                        break;
                    }
                }
            }
        }

        public int Translate(int i)
        {
            return ((BillListViewItem)Items[i]).translatedIndex; 
        }

        protected override void OnMouseDown(MouseEventArgs e)
        {
            doubleClick = e.Clicks == 2;
            base.OnMouseDown(e);
        }

        protected override void OnItemCheck(ItemCheckEventArgs ice)
        {
            if ( doubleClick || ( Control.ModifierKeys & Keys.Control ) == Keys.Control 
                             || ( Control.ModifierKeys & Keys.Shift ) == Keys.Shift )
            {
                ice.NewValue = ice.CurrentValue;
                doubleClick = false;
            }
            else base.OnItemCheck(ice);                
        }

        protected override void OnSelectedIndexChanged(EventArgs e)
        {
            selectedIndex = SelectedIndices.Count > 0 ? SelectedIndices[0] : -1;
            base.OnSelectedIndexChanged(e);
        }
    }
}
