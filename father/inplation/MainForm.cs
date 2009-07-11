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

namespace Inplation
{
    public partial class MainForm : Stopiccot.SavePositionForm
    {
        [Serializable]
        public class Rate
        {
            public string Euro, Rub;
            public Rate(string E, string R)
            {
                Euro = E; Rub = R;
            }
        }

        #region [ XmlRequestCode ]
        /*
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
        */
        #endregion

        private Month currentMonth = Month.LastMonth();
        private Dictionary<string, Rate> Rates = new Dictionary<string, Rate>();
        private WebClient webClient = new WebClient();
        private Queue<DateTime> q = new Queue<DateTime>();
        private DateTime requestDate;

        public string ReqDateString
        {
            get { return requestDate.ToShortDateString(); }
        }

        private string getRate(string s, string keyStr)
        {
            keyStr += "</td><td align=right>";
            int i = s.IndexOf(keyStr); i += keyStr.Length;
            return s.Substring(i, s.IndexOf('<', i) - i).Replace('.',',');
        }

        private void makeRequest()
        {
            if (q.Count == 0) return;

            requestDate = q.Dequeue();

            string url = "http://www.nbrb.by/statistics/rates/RatesDaily.asp?fromDate=" +
                requestDate.Year.ToString() + '-' + requestDate.Month.ToString("00") + '-' + requestDate.Day.ToString("00");

            webClient.DownloadStringAsync(new Uri(url));

            #region [ XmlRequestCode ]
            /*
             * Нифига не пашет так как сайт нацбанка runtime error кидает часто, если запросить xmlку
             * 
            
            string url = "http://www.nbrb.by/Services/XmlExRates.aspx?ondate=" +
                date.Month.ToString() + '/' + date.Day.ToString() + '/' + date.Year.ToString();

            webClient.DownloadFileAsync(new Uri(url), date.ToShortDateString() + ".xml");

            webClient.DownloadProgressChanged +=
                delegate(object sender, DownloadProgressChangedEventArgs e)
                {
                    if (e.ProgressPercentage == 100)
                    {
                        XmlReader xml = XmlReader.Create(date.ToShortDateString() + ".xml");
                        DailyExRates dailyExRates = (DailyExRates)(new XmlSerializer(typeof(DailyExRates))).Deserialize(xml);
                        xml.Close();

                        string Euro = "Ошибка", Rub = "Ошибка";

                        foreach (Currency c in dailyExRates.Currency)
                            if (c.CharCode == "EUR") Euro = c.Rate;
                            else
                                if (c.CharCode == "RUB") Rub = c.Rate;

                        dictionary.Add(date.ToShortDateString(), new DailyRate(Euro, Rub));

                        File.Delete(date.ToShortDateString() + ".xml");

                        OnPaint(null);

                        if (q.Count != 0)
                            makeRequest();
                    }
                };
             */
            #endregion
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
                    string s; Rate rate;

                    try
                    {
                        s = e.Result.Replace("\r\n", "").Replace("\t", "");
                    }
                    catch
                    {
                        MessageBox.Show("Произошла ошибка в процессе обновления.\nВозможно отсутствует подключение к интернету", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        q.Clear();
                        return;
                    }

                    try
                    {
                        rate = new Rate(getRate(s, "евро"), getRate(s, "российский рубль"));
                        double d = Convert.ToDouble(rate.Euro) + Convert.ToDouble(rate.Rub);
                    }
                    catch
                    {
                        MessageBox.Show("Произошла ошибка в процессе обновления.\nВозможно изменилась структура сайта нацбанка", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        q.Clear();
                        return;
                    }

                    Rates.Add(ReqDateString, new Rate(getRate(s, "евро"), getRate(s, "российский рубль")));
                    OnPaint(null);

                    makeRequest();                    
                };
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
                    Rectangle R = new Rectangle(0, 31 + 16 * i, Width / 3, 16);

                    bufferGraphics.DrawString(d.ToString("dd.MM"), Tahoma, FontBrush, R, StringFormats.centeredVH);
                    R.X = R.X + Width / 3;

                    if (mousePos.X >= R.X && mousePos.X < R.X + R.Width &&
                        mousePos.Y >= R.Y && mousePos.Y < R.Y + R.Height)
                        bufferGraphics.DrawRectangle(pen, R);

                    bufferGraphics.DrawString(rate.Euro, Tahoma, FontBrush, R, StringFormats.centeredVH);
                    R.X = R.X + Width / 3;

                    if (mousePos.X >= R.X && mousePos.X < R.X + R.Width &&
                        mousePos.Y >= R.Y && mousePos.Y < R.Y + R.Height)
                        bufferGraphics.DrawRectangle(pen, R);

                    bufferGraphics.DrawString(rate.Rub, Tahoma, FontBrush, R, StringFormats.centeredVH);
                }
                else
                    bufferGraphics.DrawString(d.ToString("dd.MM"), Tahoma, InactiveFontBrush, new Rectangle(0, 31 + 16 * i, Width / 3, 16), StringFormats.centeredVH);

                d = d.AddDays(1.0);
            }

            bufferGraphics.DrawRectangle(pen, new Rectangle(0, 0, this.Width - 1, this.Height - 1));
            bufferGraphics.DrawLine(pen, new Point(1, 31), new Point(this.Width - 1, 31));
            bufferGraphics.DrawLine(pen, new Point(this.Width / 3, 31), new Point(this.Width / 3, this.Height));
            bufferGraphics.DrawLine(pen, new Point(2 * this.Width / 3, 31), new Point(2 * this.Width / 3, this.Height));

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
            if (e.Y > 31 && e.X >= Width / 3)
                if (Rates.TryGetValue(currentMonth.FirstDay.AddDays((e.Y - 31) / 16).ToShortDateString(), out rate))
                    Clipboard.SetText(e.X >= 2 * Width / 3 ? rate.Rub : rate.Euro);    
        }
    }
}