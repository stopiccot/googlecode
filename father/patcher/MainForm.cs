using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace patcher
{
    using Properties;

    public partial class MainForm : Form
    {
        private const string fileName = "D://Program Files//invoice//invoice.exe";

        public MainForm()
        {
            InitializeComponent();
        }

        public bool installUpdate()
        {
            if (File.Exists(fileName + ".old")) File.Delete(fileName + ".old");
            if (File.Exists(fileName)) File.Move(fileName, fileName + ".old");
            else return false;

            FileStream fileStream = new FileStream(fileName, FileMode.CreateNew);
            fileStream.Write(Resources.invoice, 0, Resources.invoice.Length);
            fileStream.Close();

            return true;
        }

        private void Form1_Shown(object sender, EventArgs e)
        {
            okButton.Left = (Width - okButton.Width) / 2;

            if (installUpdate())
            {
                label1.Text = "Обновление до версии 1.02\nуспешно установлено";
                okButton.Enabled = true;
            }
            else
                label1.Text = "Не удалось установить обновление";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}