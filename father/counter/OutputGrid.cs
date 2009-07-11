using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.ComponentModel;
using System.Collections.Specialized;

namespace Stopiccot.VisualComponents
{
    public class OutputGridItem
    {
        public OutputGrid owner = null;

        private bool _checked = false;
        public bool Checked
        {
            get { return _checked; }
            set 
            { 
                _checked = value; 
            }
        }

        private bool checkBox = false;
        public bool CheckBox
        {
            get { return checkBox; }
            set { checkBox = value; }
        }

        private StringCollection items = new StringCollection();
        public StringCollection SubItems
        {
            get { return items; }
            set { items = value; }
        }

        private Font font = new Font("Tahoma", 8.25F, FontStyle.Regular, GraphicsUnit.Point, ((byte)(204)));
        public Font Font
        {
            get { return font; }
            set { font = value; }
        }

        private Color fontColor = Color.Black;
        public Color FontColor
        {
            get { return fontColor; }
            set
            {
                fontColor = value;
                fontBrush = new SolidBrush(fontColor);
            }
        }

        private Brush fontBrush = Brushes.Black;
        public Brush FontBrush
        {
            get { return fontBrush; }
        }

        public OutputGridItem(string[] subItems)
        {
            items.AddRange(subItems);
        }

        public OutputGridItem(string[] subItems, bool Checked)
        {
            items.AddRange(subItems);
            checkBox = true;
            _checked = Checked;
        }
    }

    public class OutputGrid : DoubleBufferControl
    {
        class OutputGridItemsEnumerator : IEnumerator
        {
            private OutputGridItems enumerableItems;
            private int index;

            public OutputGridItemsEnumerator(OutputGridItems items)
            {
                index = -1;
                enumerableItems = items;
            }

            public object Current
            {
                get { return enumerableItems[index]; }
            }

            public bool MoveNext()
            {
                index++;
                return index < enumerableItems.Count;
            }

            public void Reset()
            {
                throw new Exception("The method or operation is not implemented.");
            }

        }

        public class OutputGridItems : List<OutputGridItem>
        {
            private OutputGrid Owner;

            public OutputGridItems(OutputGrid owner)
            {
                Owner = owner;
            }

            public void Add(OutputGridItem item)
            {
                item.owner = Owner;
                base.Add(item);
                Owner.Update();
            }

            public void AddRange(IEnumerable<OutputGridItem> collection)
            {
                foreach (OutputGridItem item in collection)
                    item.owner = Owner;

                base.AddRange(collection);
                Owner.Update();
            }
        }

        public OutputGrid()
        {
            items = new OutputGridItems(this);
        }

        protected void Update()
        {
            checkBoxes = false;
            foreach (OutputGridItem item in items)
                if (item.CheckBox)
                {
                    checkBoxes = true;
                    break;
                }

            OnPaint(null);
        }
        
        private bool checkBoxes = false;

        private OutputGridItems items;

        public OutputGridItems Items
        {
            get { return items; }
            set 
            {
                items = value;
                Update();
            }
        }

        private int[] columns = new int[] { };

        public int[] Columns
        {
            get { return columns; }
            set { columns = value; OnPaint(null); }
        }

        private Image checkBoxImage = new Bitmap(1, 1);

        [Category("Appearance")]
        public Image CheckBoxImage
        {
            get { return checkBoxImage; }
            set
            {
                if (value.Width == 4 * value.Height)
                    checkBoxImage = value;
            }
        }

        private Color hoverColor = Color.FromArgb(230, 230, 230);
        private Brush hoverBrush = new SolidBrush(Color.FromArgb(230, 230, 230));

        [Category("Appearance")]
        public Color HoverColor
        {
            get { return hoverColor; }
            set
            {
                hoverColor = value;
                hoverBrush = new SolidBrush(hoverColor);
                OnPaint(null);
            }
        }

        private bool grid = false;

        [Category("Appearance")]
        public bool Grid
        {
            get { return grid; }
            set { grid = value; OnPaint(null); }
        }

        private int hoverIndex = -1;
        private int hoverCheckBoxIndex = -1;
        private int itemHeight = 15;

        public int ItemHeight
        {
            get { return itemHeight; }
            set { itemHeight = value; OnPaint(null); }
        }

        private int GetHoverIndex(int x, int y)
        {
            return y / itemHeight;
        }

        private int GetHoverCheckBoxIndex(int x, int y)
        {
            int i = 0, k = checkBoxImage.Height, m = (itemHeight - k + 1) / 2;
            x -= m;
            y -= m;
    
            foreach (OutputGridItem item in items)
            {
                if ( item.CheckBox && x >= 0 && x < k && 
                    y >= i * itemHeight && y < k + i * itemHeight )
                    return i;

                i++;
            }
            return -1;
        }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            base.OnMouseMove(e);

            if (hoverIndex != GetHoverIndex(e.X, e.Y))
            {
                hoverIndex = GetHoverIndex(e.X, e.Y);
                OnPaint(null);
            }

            hoverCheckBoxIndex = GetHoverCheckBoxIndex(e.X, e.Y);
            OnPaint(null);
        }

        public delegate void ItemCheckedEventHandler();
        public event ItemCheckEventHandler ItemCheck;
        public event ItemCheckedEventHandler ItemChecked;

        protected override void OnMouseClick(MouseEventArgs e)
        {
            base.OnMouseClick(e);

            if (e.Button == MouseButtons.Left)
            {
                int index = GetHoverCheckBoxIndex(e.X, e.Y);
                if (index != -1)
                {
                    if (ItemCheck != null)
                    {
                        ItemCheckEventArgs evnt = new ItemCheckEventArgs(index, CheckState.Checked, CheckState.Unchecked);
                        ItemCheck(this, evnt);
                    }
                    items[index].Checked = !items[index].Checked;
                    if (ItemChecked != null)
                    {
                        ItemChecked();
                    }
                    OnPaint(null);
                }
            }                
        }

        protected override void OnMouseLeave(EventArgs e)
        {
            base.OnMouseLeave(e);

            hoverIndex = -1;
            OnPaint(null);
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);

            g.Clear(Color.White);

            Pen gridPen = Pens.DarkGray;

            int i = 0;
            foreach (OutputGridItem item in items)
            {
                if (hoverIndex == i)
                    g.FillRectangle(hoverBrush,
                        new Rectangle(0, itemHeight * i + 1, this.Size.Width, itemHeight - 1));

                int checkBoxMargin = (itemHeight - checkBoxImage.Height + 1) / 2;

                {   // Drawing checkboxes
                    if (item.CheckBox)
                    {
                        int k = checkBoxImage.Height, m = checkBoxMargin;
                        int n = 0;
                        if (hoverCheckBoxIndex == i) n += 1;
                        if (item.Checked) n += 2;

                        g.DrawImage(checkBoxImage,
                            new Rectangle(m, m + i * itemHeight, k, k),
                            new Rectangle(n * k, 0, k, k),
                            GraphicsUnit.Pixel);
                    }
                }

                {   // Drawing text
                    int n = 0, w = 0, k = 2;

                    if (this.checkBoxes) k += checkBoxImage.Height + checkBoxMargin;

                    foreach (string s in item.SubItems)
                    {
                        if (n < columns.Length)
                            w = columns[n];
                        else
                            if (n == columns.Length)
                                w = this.Size.Width - k;
                            else
                                break;

                        g.DrawString(s, item.Font, item.FontBrush,
                            new Rectangle(k, itemHeight * i, w, itemHeight),
                            StringFormats.centeredV);

                        k += w;

                        if (this.checkBoxes && n == 0)
                            k -= checkBoxImage.Height + checkBoxMargin;
                        n++;
                    }
                }

                i++;
                if ( grid )
                    g.DrawLine(gridPen, new Point(0, i * itemHeight), new Point(this.Size.Width, i * itemHeight));
            }

            // Drawing grid
            g.DrawRectangle(gridPen,
                new Rectangle(0, 0, Size.Width - 1, Size.Height - 1));
            
            if ( grid )
            {
                int n = 0;
                foreach (int column in columns)
                {
                    n += column;
                    g.DrawLine(gridPen, new Point(n, 0), new Point(n, this.Size.Height));
                }
            }

            FlipBuffer();
        }

        public override void Refresh()
        {
            //base.Refresh();
            OnPaint(null);
        }
    }
}
