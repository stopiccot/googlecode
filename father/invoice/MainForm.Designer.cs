namespace Invoice
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.toolStrip = new System.Windows.Forms.ToolStrip();
            this.newToolButton = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.wordToolButton = new System.Windows.Forms.ToolStripButton();
            this.printToolButton = new System.Windows.Forms.ToolStripButton();
            this.deleteToolButton = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.toggleToolButton = new System.Windows.Forms.ToolStripButton();
            this.deletePayedToolButton = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.settingsToolButton = new System.Windows.Forms.ToolStripButton();
            this.listView = new Invoice.BillListView();
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.backgroundWorker = new System.ComponentModel.BackgroundWorker();
            this.toolStrip.SuspendLayout();
            this.SuspendLayout();
            // 
            // toolStrip
            // 
            this.toolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.newToolButton,
            this.toolStripSeparator1,
            this.wordToolButton,
            this.printToolButton,
            this.deleteToolButton,
            this.toolStripSeparator2,
            this.toggleToolButton,
            this.deletePayedToolButton,
            this.toolStripSeparator3,
            this.settingsToolButton});
            this.toolStrip.Location = new System.Drawing.Point(0, 0);
            this.toolStrip.Name = "toolStrip";
            this.toolStrip.Size = new System.Drawing.Size(312, 25);
            this.toolStrip.TabIndex = 4;
            this.toolStrip.Text = "toolStrip";
            // 
            // newToolButton
            // 
            this.newToolButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.newToolButton.Image = global::Invoice.Properties.Resources._new;
            this.newToolButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.newToolButton.Name = "newToolButton";
            this.newToolButton.Size = new System.Drawing.Size(23, 22);
            this.newToolButton.Text = "toolStripButton1";
            this.newToolButton.ToolTipText = "Новая счёт-фактура";
            this.newToolButton.Click += new System.EventHandler(this.createNewBill);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // wordToolButton
            // 
            this.wordToolButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.wordToolButton.Enabled = false;
            this.wordToolButton.Image = global::Invoice.Properties.Resources.word;
            this.wordToolButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.wordToolButton.Name = "wordToolButton";
            this.wordToolButton.Size = new System.Drawing.Size(23, 22);
            this.wordToolButton.Text = "toolStripButton2";
            this.wordToolButton.ToolTipText = "Открыть документ Word";
            this.wordToolButton.Click += new System.EventHandler(this.wordToolButton_Click);
            // 
            // printToolButton
            // 
            this.printToolButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.printToolButton.Enabled = false;
            this.printToolButton.Image = global::Invoice.Properties.Resources.print;
            this.printToolButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.printToolButton.Name = "printToolButton";
            this.printToolButton.Size = new System.Drawing.Size(23, 22);
            this.printToolButton.Text = "toolStripButton3";
            this.printToolButton.ToolTipText = "Распечатать";
            this.printToolButton.Click += new System.EventHandler(this.printToolButton_Click);
            // 
            // deleteToolButton
            // 
            this.deleteToolButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.deleteToolButton.Enabled = false;
            this.deleteToolButton.Image = global::Invoice.Properties.Resources.del;
            this.deleteToolButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.deleteToolButton.Name = "deleteToolButton";
            this.deleteToolButton.Size = new System.Drawing.Size(23, 22);
            this.deleteToolButton.Text = "toolStripButton4";
            this.deleteToolButton.ToolTipText = "Удалить";
            this.deleteToolButton.Click += new System.EventHandler(this.deleteToolButton_Click);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(6, 25);
            // 
            // toggleToolButton
            // 
            this.toggleToolButton.Checked = true;
            this.toggleToolButton.CheckOnClick = true;
            this.toggleToolButton.CheckState = System.Windows.Forms.CheckState.Checked;
            this.toggleToolButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toggleToolButton.Image = global::Invoice.Properties.Resources.done;
            this.toggleToolButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toggleToolButton.Name = "toggleToolButton";
            this.toggleToolButton.Size = new System.Drawing.Size(23, 22);
            this.toggleToolButton.Text = "toolStripButton5";
            this.toggleToolButton.ToolTipText = "Показывать оплаченные";
            this.toggleToolButton.Click += new System.EventHandler(this.toggleToolButton_Click);
            // 
            // deletePayedToolButton
            // 
            this.deletePayedToolButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.deletePayedToolButton.Image = global::Invoice.Properties.Resources.deldone;
            this.deletePayedToolButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.deletePayedToolButton.Name = "deletePayedToolButton";
            this.deletePayedToolButton.Size = new System.Drawing.Size(23, 22);
            this.deletePayedToolButton.Text = "toolStripButton6";
            this.deletePayedToolButton.ToolTipText = "Удалить оплаченные";
            this.deletePayedToolButton.Click += new System.EventHandler(this.deletePayedToolButton_Click);
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new System.Drawing.Size(6, 25);
            // 
            // settingsToolButton
            // 
            this.settingsToolButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.settingsToolButton.Image = global::Invoice.Properties.Resources.settings;
            this.settingsToolButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.settingsToolButton.Name = "settingsToolButton";
            this.settingsToolButton.Size = new System.Drawing.Size(23, 22);
            this.settingsToolButton.Text = "Настройки";
            this.settingsToolButton.Click += new System.EventHandler(this.settingsToolButton_Click);
            // 
            // listView
            // 
            this.listView.CheckBoxes = true;
            this.listView.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader2,
            this.columnHeader3,
            this.columnHeader4});
            this.listView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listView.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.listView.FullRowSelect = true;
            this.listView.GridLines = true;
            this.listView.Location = new System.Drawing.Point(0, 25);
            this.listView.Name = "listView";
            this.listView.SelectedIndex = -1;
            this.listView.Size = new System.Drawing.Size(312, 651);
            this.listView.TabIndex = 5;
            this.listView.TranslatedSelectedIndex = -1;
            this.listView.UseCompatibleStateImageBehavior = false;
            this.listView.View = System.Windows.Forms.View.Details;
            this.listView.ColumnClick += new System.Windows.Forms.ColumnClickEventHandler(this.listView_ColumnClick);
            this.listView.ColumnWidthChanged += new System.Windows.Forms.ColumnWidthChangedEventHandler(this.listView_ColumnWidthChanged);
            this.listView.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.listView_ItemCheck);
            this.listView.ItemSelectionChanged += new System.Windows.Forms.ListViewItemSelectionChangedEventHandler(this.listViewSelectionChanged);
            this.listView.DoubleClick += new System.EventHandler(this.listView_DoubleClick);
            this.listView.KeyDown += new System.Windows.Forms.KeyEventHandler(this.listView_KeyDown);
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "Счёт-фактура";
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "Дата";
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "Компания";
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "Сумма";
            // 
            // backgroundWorker
            // 
            this.backgroundWorker.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker_DoWork);
            // 
            // MainForm
            // 
            this.ClientSize = new System.Drawing.Size(312, 676);
            this.Controls.Add(this.listView);
            this.Controls.Add(this.toolStrip);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Cчёт-фактуры 1.0.5";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MainForm_FormClosed);
            this.toolStrip.ResumeLayout(false);
            this.toolStrip.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private BillListView listView;
        private System.Windows.Forms.ToolStrip toolStrip;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ToolStripButton newToolButton;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripButton wordToolButton;
        private System.Windows.Forms.ToolStripButton printToolButton;
        private System.Windows.Forms.ToolStripButton deleteToolButton;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripButton toggleToolButton;
        private System.Windows.Forms.ToolStripButton deletePayedToolButton;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
        private System.Windows.Forms.ToolStripButton settingsToolButton;
        private System.ComponentModel.BackgroundWorker backgroundWorker;

    }
}

