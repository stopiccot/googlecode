using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Net;
using System.IO;

namespace Invoice.Update
{
    public partial class UpdateForm : Form
    {
        private UpdateInfo updateInfo;
        private WebClient webClient;
        private string backupExe, currentExe, newExe;
        private bool updateComplete = false;

        public UpdateForm(UpdateInfo updateInfo)
        {
            InitializeComponent();

            this.updateInfo = updateInfo;
            this.statusLabel.Text = "Доступна более новая версия " + updateInfo.version;
        }

        //================================================================================
        // UpdateForm_FormClosing
        //    Корректное завершение асинхронного скачивания при закрытии формы
        //================================================================================
        private void UpdateForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (webClient != null && webClient.IsBusy)
                webClient.CancelAsync();
        }

        //================================================================================
        // setDownloadProgress
        //    Обновление UI во время скачивания
        //================================================================================
        private void setDownloadProgress(long downloaded, long all)
        {
            // Размер в килобайтах
            float downloadedF = downloaded / 1024.0f, allF = all / 1024.0f;

            this.statusLabel.Text = "Скачиваем обновление: ";
            if (allF < 1024.0f)
            {
                // Прогресс в килобайтах
                this.statusLabel.Text += (int)downloadedF + " Kb / " + (int)allF + " Kb";
            }
            else
            {
                downloadedF /= 1024.0f; allF /= 1024.0f; // Размер в мегабайтах

                // Прогресс в мегабайтах, двух знаков после запятой будет достаточно
                this.statusLabel.Text += downloadedF.ToString("0.00") + " Mb / " + allF.ToString("0.00") + " Mb";
            }

            this.progressBar.Value = (int)(this.progressBar.Maximum * downloadedF / allF);
        }

        //================================================================================
        // downloadUpdate
        //    Скачивание новой версии
        //================================================================================
        private void downloadUpdate()
        {
            if (webClient != null) return; // Чтоб случайно не начать качать дважды

            nextnextnextButton.Enabled = false;

            currentExe = Directory.GetCurrentDirectory() + "\\invoice.exe";
            backupExe = currentExe + ".bak";
            newExe = Directory.GetCurrentDirectory() + "\\" + Path.GetFileName(updateInfo.uri);

            webClient = new WebClient();
            webClient.Encoding = Encoding.UTF8;

            webClient.DownloadProgressChanged +=
                delegate(object senderObject, DownloadProgressChangedEventArgs eventArgs)
                {
                    try
                    {
                        // Почему-то евент на 100% приходит дважды
                        if (!updateComplete)
                            setDownloadProgress(eventArgs.BytesReceived, eventArgs.TotalBytesToReceive);
                    }
                    catch
                    {
                        webClient.CancelAsync();

                        statusLabel.ForeColor = Color.Red;
                        statusLabel.Text = "Произошла ошибка во время обновления.";
                        cancelButton.Text = "Жаль";
                    }
                };

            webClient.DownloadFileCompleted +=
                delegate(object senderObject, AsyncCompletedEventArgs eventArgs)
                {
                    try
                    {
                        if (eventArgs.Error != null)
                            throw new Exception();
                        
                        updateComplete = true;

                        statusLabel.Text = "Обновление скачано.\r\nТеперь осталось только перезапустить программу.";

                        nextnextnextButton.Enabled = true;
                        nextnextnextButton.Text = "Перезапустить программу";
                        cancelButton.Text = "Потом";

                        // Удаляем старый бэкап
                        if (File.Exists(backupExe))
                            File.Delete(backupExe);

                        // Бэкапим текущую версию и заменяем её новой
                        File.Move(currentExe, backupExe);
                        File.Move(newExe, currentExe);
                    }
                    catch
                    {
                        webClient.CancelAsync();

                        statusLabel.ForeColor = Color.Red;
                        statusLabel.Text = "Произошла ошибка во время обновления.";
                        cancelButton.Text = "Жаль";
                    }
                };

            webClient.DownloadFileAsync(new Uri(updateInfo.uri), newExe);
        }

        //================================================================================
        // nextnextnextButton_Click
        //================================================================================
        private void nextnextnextButton_Click(object sender, EventArgs e)
        {
            if (!updateComplete)
                downloadUpdate();
            else
                Application.Restart();
        }

        //================================================================================
        // cancelButton_Click
        //================================================================================
        private void cancelButton_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
