using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Serialization;
using System.Net;
using Stopiccot.VisualComponents;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;
using System.Globalization;

namespace Inplation
{
    public partial class MainForm : Stopiccot.SavePositionForm
    {
        [Serializable]
        public class Rate
        {
            public string EUR, USD, RUR;
            public Rate(string EUR, string USD, string RUR)
            {
                this.EUR = EUR; this.USD = USD; this.RUR = RUR;
            }
        }

        public struct Currency
        {
            [XmlAttribute]
            public int Id;
            public int NumCode;
            public string CharCode;
            public int Scale;
            public string Name;
            public string Rate;
        }

        public struct DailyExRates
        {
            [XmlAttribute]
            public string Date;
            [XmlElement]
            public Currency[] Currency;
        }

        private Month currentMonth = Month.LastMonth();
        private Dictionary<string, Rate> Rates = new Dictionary<string, Rate>();
        private WebClient webClient = new WebClient();
        private Queue<DateTime> q = new Queue<DateTime>();
        private DateTime requestDate;

        public string ReqDateString
        {
            get { return requestDate.ToShortDateString(); }
        }

        private void makeRequest()
        {
            if (q.Count == 0) return;

            requestDate = q.Dequeue();

            string url = "http://www.nbrb.by/Services/XmlExRates.aspx?ondate=" +
                requestDate.ToString("yyyy-MM-dd");

            webClient.DownloadStringAsync(new Uri(url));
        }
                    
        public MainForm()
        {
            InitializeComponent();

            try
            {
                Stream stream = new FileStream("inplation.base", FileMode.Open, FileAccess.Read, FileShare.None);
                Rates = (Dictionary<string, Rate>)(new BinaryFormatter()).Deserialize(stream);
                stream.Close();
            }
            catch
            {
                MessageBox.Show("Произошла ошибка при загрузке базы.\nДанные о курсах утеряны, но их можно скачать заново.", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            webClient.DownloadStringCompleted +=
                delegate(object sender, DownloadStringCompletedEventArgs e)
                {
                    DailyExRates dailyExRates;

                    try
                    {
                        XmlReader xml = XmlReader.Create(new StringReader(e.Result));
                        dailyExRates = (DailyExRates)(new XmlSerializer(typeof(DailyExRates))).Deserialize(xml);
                        xml.Close();
                    }
                    catch
                    {
                        MessageBox.Show("Не удалось получить xml-данные в процессе обновления. Надо срочно позвонить Лёше.", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        q.Clear();
                        return;
                    }

                    try
                    {
                        string EUR = "Ошибка", USD = "Ошибика", RUR = "Ошибка";

                        foreach (Currency currency in dailyExRates.Currency)
                        {
                            if (currency.CharCode == "EUR") EUR = currency.Rate;
                            if (currency.CharCode == "USD") USD = currency.Rate;
                            if (currency.CharCode == "RUB") RUR = currency.Rate;
                        }

                        // Проверям, что это были на самом деле числа. 
                        // CultureInfo.InvariantCulture.NumberFormat - чтоб игнорировать точка или 
                        // запятая используется в качестве разделителя
                        double d = Convert.ToDouble(EUR, CultureInfo.InvariantCulture.NumberFormat)
                                 + Convert.ToDouble(USD, CultureInfo.InvariantCulture.NumberFormat)
                                 + Convert.ToDouble(RUR, CultureInfo.InvariantCulture.NumberFormat);

                        // Добавляем в список
                        Rates.Add(ReqDateString, new Rate(EUR, USD, RUR));
                    }
                    catch
                    {
                        MessageBox.Show("Не удалось прочитать xml-данные в процессе обновления. Надо срочно позвонить Лёше.", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        q.Clear();
                        return;
                    }

                    OnPaint(null);

                    makeRequest();
                };

            closeButton.Left = this.Width - closeButton.Width + 5;
            minimizeButton.Left = closeButton.Left - minimizeButton.Width + 1;
            nextButton.Left = minimizeButton.Left - nextButton.Width + 1;
        }

        private Image bufferImage;
        private Graphics bufferGraphics;
        private Point mousePos;

        protected override void OnResize(EventArgs e)
        {
            base.OnResize(e);
            bufferImage = new Bitmap(this.Size.Width, this.Size.Height);
            bufferGraphics = Graphics.FromImage(bufferImage);
        }

        public static Color GrayColor(Byte c)
        {
            return Color.FromArgb(c, c, c);
        }
        static SolidBrush OddBrush = new SolidBrush(GrayColor(240));
        static SolidBrush EvenBrush  = new SolidBrush(GrayColor(255));
        //static SolidBrush MouseHoverBrush = new SolidBrush(Color.FromArgb(40,Color.Black));
        static SolidBrush FontBrush = new SolidBrush(GrayColor(75));
        static SolidBrush InactiveFontBrush = new SolidBrush(GrayColor(175));
        static Pen pen = new Pen(Color.FromArgb(100, Color.Black), 1.0f);

        static Font Tahoma  = new Font("Tahoma", 8.25F, FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
        static Font TahomaB = new Font("Tahoma", 8.25F, FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));

        private void MainForm_Paint(object sender, PaintEventArgs e)
        {
            this.Height = 31 + currentMonth.Days * 16;

            for (int i = 0; i < 32; i++)
                bufferGraphics.FillRectangle(i % 2 == 1 ? OddBrush : EvenBrush,
                    new Rectangle(0, 31 + 16 * i, this.Width, 16));

            LinearGradientBrush GradientBrush = new LinearGradientBrush(
                new Rectangle(0, 0, this.Width, 31), GrayColor(190), GrayColor(235), -90.0f);

            bufferGraphics.FillRectangle(GradientBrush, new Rectangle(0,0,this.Width,31));            

            bufferGraphics.DrawString(currentMonth.Name, TahomaB, FontBrush, new Rectangle(57, 0, this.Width - 136, 31), StringFormats.centeredVH);

            DateTime d = currentMonth.FirstDay;

            for (int i = 0; i < currentMonth.Days; i++)
            {
                Rate rate;

                if (Rates.TryGetValue(d.ToShortDateString(), out rate))
                {
                    Rectangle R = new Rectangle(0, 31 + 16 * i, Width / 4, 16);

                    bufferGraphics.DrawString(d.ToString("dd.MM"), Tahoma, FontBrush, R, StringFormats.centeredVH);
                    R.X = R.X + Width / 4;

                    if (mousePos.X >= R.X && mousePos.X < R.X + R.Width &&
                        mousePos.Y >= R.Y && mousePos.Y < R.Y + R.Height)
                        bufferGraphics.DrawRectangle(pen, R);

                    bufferGraphics.DrawString(rate.EUR, Tahoma, FontBrush, R, StringFormats.centeredVH);
                    R.X = R.X + Width / 4;

                    if (mousePos.X >= R.X && mousePos.X < R.X + R.Width &&
                        mousePos.Y >= R.Y && mousePos.Y < R.Y + R.Height)
                        bufferGraphics.DrawRectangle(pen, R);

                    bufferGraphics.DrawString(rate.USD, Tahoma, FontBrush, R, StringFormats.centeredVH);
                    R.X = R.X + Width / 4;

                    if (mousePos.X >= R.X && mousePos.X < R.X + R.Width &&
                        mousePos.Y >= R.Y && mousePos.Y < R.Y + R.Height)
                        bufferGraphics.DrawRectangle(pen, R);

                    bufferGraphics.DrawString(rate.RUR, Tahoma, FontBrush, R, StringFormats.centeredVH);
                }
                else
                    bufferGraphics.DrawString(d.ToString("dd.MM"), Tahoma, InactiveFontBrush, new Rectangle(0, 31 + 16 * i, Width / 4, 16), StringFormats.centeredVH);

                d = d.AddDays(1.0);
            }

            bufferGraphics.DrawRectangle(pen, new Rectangle(0, 0, this.Width - 1, this.Height - 1));
            bufferGraphics.DrawLine(pen, new Point(1, 31), new Point(this.Width - 1, 31));
            bufferGraphics.DrawLine(pen, new Point(this.Width / 4, 31), new Point(this.Width / 4, this.Height));
            bufferGraphics.DrawLine(pen, new Point(2 * this.Width / 4, 31), new Point(2 * this.Width / 4, this.Height));
            bufferGraphics.DrawLine(pen, new Point(3 * this.Width / 4, 31), new Point(3 * this.Width / 4, this.Height));

            Graphics.FromHwnd(this.Handle).DrawImage(this.bufferImage, new Point(0, 0));
        }

        private bool drag = false;
        private Size dragStart, dragStartLoc;

        private void MainForm_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Y <= 31)
            {
                drag = true;
                dragStart = (Size)PointToScreen(e.Location);
                dragStartLoc = (Size)Location;
            }
        }

        private void MainForm_MouseMove(object sender, MouseEventArgs e)
        {
            mousePos = e.Location;

            OnPaint(null);

            if (drag)
                Location = (Point)(dragStartLoc + (Size)PointToScreen(e.Location) - dragStart);
        }

        private void MainForm_MouseUp(object sender, MouseEventArgs e)
        {
            drag = false;
        }

        private void appleButton1_Click(object sender, EventArgs e)
        {
            Stream stream = new FileStream("inplation.base", FileMode.Create, FileAccess.Write, FileShare.None);
            (new BinaryFormatter()).Serialize(stream, Rates);
            stream.Close();

            Close();
        }

        private void nextButton_Click(object sender, EventArgs e)
        {
            currentMonth = currentMonth.Next();
            OnPaint(null);
        }

        private void prevButton_Click(object sender, EventArgs e)
        {
            currentMonth = currentMonth.Previous();
            OnPaint(null);
        }

        private void reloadButton_Click(object sender, EventArgs e)
        {
            Rate Rate; DateTime date;

            for (int i = 0; i < currentMonth.Days; i++)
            {
                date = currentMonth.FirstDay.AddDays(i);
                if (!Rates.TryGetValue(date.ToShortDateString(), out Rate))
                {
                    bool add = true;

                    foreach (DateTime d in q)
                        if (d == date)
                            add = false;

                    if ( add )
                        q.Enqueue(currentMonth.FirstDay.AddDays(i));
                }                    
            }

            if (!webClient.IsBusy)
                makeRequest();                    
        }

        private void minimizeButton_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void MainForm_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            Rate rate;
            if (e.Y > 31 && e.X >= Width / 4)
                if (Rates.TryGetValue(currentMonth.FirstDay.AddDays((e.Y - 31) / 16).ToShortDateString(), out rate))
                {
                    if (e.X >= 3 * Width / 4)
                        Clipboard.SetText(rate.RUR);
                    else if (e.X >= 2 * Width / 4)
                        Clipboard.SetText(rate.USD);
                    else
                        Clipboard.SetText(rate.EUR);
                }
        }
    }
}