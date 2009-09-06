using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Drawing;
using System.Xml;
using System.Xml.Serialization;
using System.Windows.Forms;
using System.IO;

namespace Invoice
{
    public class SerializableBase
    {
        public bool confirmDelete;
        public bool confirmUnpay;
        public bool showPayed;
        public string templateDoc;
        public FormPostion FormPosition;
        public string[] prices;
        public int[] columnWidth;
        public Bill[] bills;
        public Company[] companies;
    }

    public static class Base
    {
        private static SerializableBase _base = new SerializableBase();
        private static string baseFile = System.Environment.CurrentDirectory + "\\base.xml";
        private static int numberBackups = 10;

        public static bool confirmDelete = true;
        public static bool confirmUnpay = true;
        public static bool showPayed = true;

        public static string templateDoc = "";

        public static FormPostion FormPosition = new FormPostion(100, 100, 800, 600, false);

        public static int[] columnWidth = { 100, 100, 100, 100 };
        public static string[] prices = {};

        public static List<Bill> billList = new List<Bill>();
        public static List<Company> companyList = new List<Company>();

        public static Bill lastBill
        {
            get { return (Bill)billList[billList.Count - 1]; }
        }

        public static void Save()
        {
            _base.confirmDelete = Base.confirmDelete;
            _base.confirmUnpay = Base.confirmUnpay;
            _base.showPayed = Base.showPayed;
            _base.templateDoc = Base.templateDoc;
            _base.FormPosition = Base.FormPosition;
            _base.columnWidth = Base.columnWidth;
            _base.prices = Base.prices;
            _base.bills = (Bill[])Base.billList.ToArray();
            _base.companies = (Company[])Base.companyList.ToArray();
            
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.NewLineOnAttributes = false;

            // BACKUP!
            if (numberBackups > 0)
            {
                if (File.Exists(baseFile + "." + numberBackups.ToString() + ".bak"))
                    File.Delete(baseFile + "." + numberBackups.ToString() + ".bak");

                for (int i = numberBackups; i > 1; )
                {
                    string s2 = baseFile + "." + i.ToString() + ".bak";
                    string s1 = baseFile + "." + (--i).ToString() + ".bak";
                    if (File.Exists(s1)) File.Move(s1, s2);
                }
                if (File.Exists(baseFile)) File.Move(baseFile, baseFile + ".1.bak");
            }

            XmlWriter writer = XmlWriter.Create(baseFile, settings);

            writer.WriteStartDocument();
                (new XmlSerializer(typeof(SerializableBase))).Serialize(writer, _base);
            writer.WriteEndDocument();            
            writer.Close();
        }

        public static void Load()
        {
            if (!File.Exists(baseFile))
            {
                MessageBox.Show("База не обнаружена!");
                return;
            }

            XmlReader xml = XmlReader.Create(baseFile);
            _base = (SerializableBase)(new XmlSerializer(typeof(SerializableBase))).Deserialize(xml);
            xml.Close();

            Base.prices = _base.prices;
            Base.confirmDelete = _base.confirmDelete;
            Base.confirmUnpay = _base.confirmUnpay;
            Base.showPayed = _base.showPayed;
            Base.templateDoc = _base.templateDoc;
            Base.FormPosition = _base.FormPosition;
            Array.Copy(_base.columnWidth, Base.columnWidth, _base.columnWidth.Length);
            Base.billList.AddRange(_base.bills);
            Base.companyList.AddRange(_base.companies);
        }
    }
}
