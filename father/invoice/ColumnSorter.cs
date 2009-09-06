using System;
using System.Collections;
using System.Text;
using System.Windows.Forms;
using System.Collections.Generic;

namespace Invoice
{
    class ColumnSorter : IComparer
    {
        private int sortColumn;
        public int SortColumn
        {
            set { sortColumn = value; }
            get { return sortColumn; }
        }

        private SortOrder OrderOfSort;
        private CaseInsensitiveComparer ObjectCompare;

        public ColumnSorter()
        {
            sortColumn = 0;
            OrderOfSort = SortOrder.None;
            ObjectCompare = new CaseInsensitiveComparer();
        }

        int IComparer.Compare(object x, object y)
        {
            int compareResult = 0;
            string a = ((ListViewItem)x).SubItems[sortColumn].Text,
                   b = ((ListViewItem)y).SubItems[sortColumn].Text;

            switch (sortColumn)
            {
                case 0: 
                {
                    string[] c = a.Split('/'), d = b.Split('/');

                    int k = Convert.ToInt32(c[1]) == Convert.ToInt32(d[1]) ? 0 : 1;
                    compareResult = Convert.ToInt32(c[k]) < Convert.ToInt32(d[k]) ? -1 : 1;

                    break;
                }
                case 1: compareResult = DateTime.Compare(Convert.ToDateTime(a), Convert.ToDateTime(b)); break;
                case 2: compareResult = String.Compare(a, b); break;
                case 3: compareResult = Convert.ToInt32(a) < Convert.ToInt32(b) ? -1 : 1; break;
            }            
            
            if (OrderOfSort == SortOrder.Ascending)
                return compareResult;
            else if (OrderOfSort == SortOrder.Descending)
                return -compareResult;
            else return 0;
        }

        public SortOrder Order
        {
            set { OrderOfSort = value; }
            get { return OrderOfSort;  }
        }
    }
}
