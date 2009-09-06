using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Invoice
{
    class MyListViewItem : ListViewItem
    {
        public int translatedIndex;

        public MyListViewItem( string[] items, bool check, int index )
        {
            if (items.Length > 0) this.Text = items[0];
            for (int i = 1; i < items.Length; ++i)
                this.SubItems.Add(items[i]);

            Checked = check;
            translatedIndex = index;
        }        
    }

    class MyListView : ListView
    {
        private bool doubleClick = false;
        private int selectedIndex = -1;

        public int SelectedIndex
        {
            get { return selectedIndex; }
            set { if ( value >= 0 ) Items[value].Selected = true; }
        }

        public int TranslatedIndex
        {
            get { return ((MyListViewItem)Items[selectedIndex]).translatedIndex; }
        }

        public int Translate(int i)
        {
            return ((MyListViewItem)Items[i]).translatedIndex; 
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
