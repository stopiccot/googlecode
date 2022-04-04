﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Windows.Forms;
using System.Xml.Serialization;
using System.IO;
using System.Xml;

namespace Invoice.Update
{
    public class UpdateInfo
    {
        public string version;     // Версия
        public string uri;         // Ссылка для скачивания обновления
        public string description; // Всякое описалово
    }

    public class Updater
    {
        private Uri uri;

        public Updater(string uri)
        {
            this.uri = new Uri(uri);
        }

        //================================================================================
        // checkForUpdates
        //    Проверяет наличие обновлений
        //================================================================================
        public void checkForUpdates()
        {
            WebClient webClient = new WebClient();
            webClient.Encoding = Encoding.UTF8;

            // Fix for the broken downloads due to outdated TLS.
            // More here: https://stackoverflow.com/questions/23106611/the-underlying-connection-was-closed-webclient-error
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            ServicePointManager.DefaultConnectionLimit = 9999;

            webClient.DownloadStringCompleted +=
                delegate(object sender, DownloadStringCompletedEventArgs e)
                {
                    try
                    {
                        if (e.Error == null)
                        {
                            // На e.Result обязательно нужно делать Trim() т.к. первые 3 байта в строке
                            // представляют собой "невидимый хлам" (можешь глянуть xml-ку в хексе в листере EF BB BF)
                            // и это хлам при десериализации из файла автоматически выкидывается, а вот если
                            // строка пришла из интернета - нет.
                            StringReader stringReader = new StringReader(e.Result.Trim());
                            UpdateInfo[] updateInfo = (UpdateInfo[])(new XmlSerializer(typeof(UpdateInfo[]))).Deserialize(stringReader);
                            stringReader.Close();

                            UpdateInfo lastUpdateInfo = updateInfo[updateInfo.Length - 1];
                            Version currentVersion = new Version(Application.ProductVersion);
                            Version lastestVersion = new Version(lastUpdateInfo.version);

                            // Походу наше барахло устарело
                            if (lastestVersion > currentVersion)
                            {
                                UpdateForm updateForm = new UpdateForm(lastUpdateInfo);
                                updateForm.ShowDialog();
                            }
                        }
                    }
                    catch
                    {
                        // Просто ловим любые эксепшены, чтоб сломавшийся апдейт никак не влиял на
                        // работоспособность программы
                    }
                };
            
            webClient.DownloadStringAsync(this.uri);
        }
    }
}
