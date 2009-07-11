using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.IO;

namespace counter
{
    public class SerializableBase
    {
        public FormPostion formPosition;
        public bool panelMinimized;
        public string[][] partsWear;
    }

    public static class Base
    {
        private static SerializableBase _base = new SerializableBase();
        private static string baseFile = System.Environment.CurrentDirectory + "\\base.xml";
        public static FormPostion formPosition = new FormPostion(100, 100, 583, 100, false);
        public static bool panelMinimized = true;
        public static string[][] partsWear = new string[][] { 
            new string[] { "1", "2", "3" },
            new string[] { "4", "5", "6" } };

        public static void Save()
        {
            _base.formPosition = Base.formPosition;
            _base.panelMinimized = Base.panelMinimized;
            _base.partsWear = Base.partsWear;

            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.NewLineOnAttributes = false;

            XmlWriter writer = XmlWriter.Create(baseFile, settings);

            writer.WriteStartDocument();
                (new XmlSerializer(typeof(SerializableBase))).Serialize(writer, _base);
            writer.WriteEndDocument();
            writer.Close();
        }

        public static void Load()
        {
            if (!File.Exists(baseFile))
                return;

            XmlReader xml = XmlReader.Create(baseFile);
            _base = (SerializableBase)(new XmlSerializer(typeof(SerializableBase))).Deserialize(xml);
            xml.Close();

            Base.formPosition = _base.formPosition;
            Base.panelMinimized = _base.panelMinimized;
            Base.partsWear = _base.partsWear;
        }
    }
}
