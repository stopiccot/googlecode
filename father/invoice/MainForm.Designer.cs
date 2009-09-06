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
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.fileMenuButton = new System.Windows.Forms.ToolStripMenuItem();
            this.newMenuButton = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripSeparator();
            this.closeMenuButton = new System.Windows.Forms.ToolStripMenuItem();
            this.settingsMenuButton = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.newToolButton = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.wordToolButton = new System.Windows.Forms.ToolStripButton();
            this.printToolButton = new System.Windows.Forms.ToolStripButton();
            this.deleteToolButton = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.toggleToolButton = new System.Windows.Forms.ToolStripButton();
            this.deletePayedToolButton = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripButton1 = new System.Windows.Forms.ToolStripButton();
            this.listView = new Invoice.MyListView();
            this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader2 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader3 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader4 = new System.Windows.Forms.ColumnHeader();
            this.menuStrip1.SuspendLayout();
            this.toolStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileMenuButton,
            this.settingsMenuButton});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(879, 24);
            this.menuStrip1.TabIndex = 3;
            this.menuStrip1.Text = "menuStrip1";
            this.menuStrip1.Visible = false;
            // 
            // fileMenuButton
            // 
            this.fileMenuButton.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.newMenuButton,
            this.toolStripMenuItem1,
            this.closeMenuButton});
            this.fileMenuButton.Name = "fileMenuButton";
            this.fileMenuButton.Size = new System.Drawing.Size(45, 20);
            this.fileMenuButton.Text = "Файл";
            // 
            // newMenuButton
            // 
            this.newMenuButton.Image = global::Invoice.Properties.Resources._new;
            this.newMenuButton.Name = "newMenuButton";
            this.newMenuButton.Size = new System.Drawing.Size(190, 22);
            this.newMenuButton.Text = "Новая счёт-фактура";
            this.newMenuButton.Click += new System.EventHandler(this.newBill);
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(187, 6);
            // 
            // closeMenuButton
            // 
            this.closeMenuButton.Name = "closeMenuButton";
            this.closeMenuButton.Size = new System.Drawing.Size(190, 22);
            this.closeMenuButton.Text = "Выход";
            this.closeMenuButton.Click += new System.EventHandler(this.toolStripMenuItem4_Click);
            // 
            // settingsMenuButton
            // 
            this.settingsMenuButton.Name = "settingsMenuButton";
            this.settingsMenuButton.Size = new System.Drawing.Size(73, 20);
            this.settingsMenuButton.Text = "Настройки";
            this.settingsMenuButton.Click += new System.EventHandler(this.settingsMenuButton_Click);
            // 
            // toolStrip1
            // 
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.newToolButton,
            this.toolStripSeparator1,
            this.wordToolButton,
            this.printToolButton,
            this.deleteToolButton,
            this.toolStripSeparator2,
            this.toggleToolButton,
            this.deletePayedToolButton,
            this.toolStripSeparator3,
            this.toolStripButton1});
            this.toolStrip1.Location = new System.Drawing.Point(0, 0);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(879, 25);
            this.toolStrip1.TabIndex = 4;
            this.toolStrip1.Text = "toolStrip1";
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
            this.newToolButton.Click += new System.EventHandler(this.newBill);
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
            this.deleteToolButton.Click += new System.EventHandler(this.toolStripButton4_Click);
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
            // toolStripButton1
            // 
            this.toolStripButton1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton1.Image = global::Invoice.Properties.Resources.settings;
            this.toolStripButton1.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton1.Name = "toolStripButton1";
            this.toolStripButton1.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton1.Text = "Настройки";
            this.toolStripButton1.Click += new System.EventHandler(this.toolStripButton1_Click);
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
            this.listView.Size = new System.Drawing.Size(879, 454);
            this.listView.TabIndex = 5;
            this.listView.UseCompatibleStateImageBehavior = false;
            this.listView.View = System.Windows.Forms.View.Details;
            this.listView.ColumnWidthChanged += new System.Windows.Forms.ColumnWidthChangedEventHandler(this.listView_ColumnWidthChanged);
            this.listView.DoubleClick += new System.EventHandler(this.listView_DoubleClick);
            this.listView.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.listView_ItemCheck);
            this.listView.KeyDown += new System.Windows.Forms.KeyEventHandler(this.listView_KeyDown);
            this.listView.ColumnClick += new System.Windows.Forms.ColumnClickEventHandler(this.listView_ColumnClick);
            this.listView.ItemSelectionChanged += new System.Windows.Forms.ListViewItemSelectionChangedEventHandler(this.listViewSelectionChanged);
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
            // MainForm
            // 
            this.ClientSize = new System.Drawing.Size(879, 479);
            this.Controls.Add(this.listView);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.menuStrip1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Cчёт-фактуры 1.0.5";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MainForm_FormClosed);
            this.Shown += new System.EventHandler(this.MainForm_Shown);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private MyListView listView;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem fileMenuButton;
        private System.Windows.Forms.ToolStripMenuItem newMenuButton;
        private System.Windows.Forms.ToolStripMenuItem closeMenuButton;
        private System.Windows.Forms.ToolStripMenuItem settingsMenuButton;
        private System.Windows.Forms.ToolStrip toolStrip1;
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
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem1;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
        private System.Windows.Forms.ToolStripButton toolStripButton1;

    }
}

