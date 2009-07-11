namespace Inplation
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.minimizeButton = new Stopiccot.VisualComponents.AppleButton();
            this.nextButton = new Stopiccot.VisualComponents.AppleButton();
            this.closeButton = new Stopiccot.VisualComponents.AppleButton();
            this.prevButton = new Stopiccot.VisualComponents.AppleButton();
            this.reloadButton = new Stopiccot.VisualComponents.AppleButton();
            this.SuspendLayout();
            // 
            // toolTip
            // 
            this.toolTip.AutoPopDelay = 5000;
            this.toolTip.InitialDelay = 1000;
            this.toolTip.ReshowDelay = 200;
            // 
            // minimizeButton
            // 
            this.minimizeButton.Icon = global::Inplation.Properties.Resources.minimize;
            this.minimizeButton.Location = new System.Drawing.Point(194, 5);
            this.minimizeButton.Name = "minimizeButton";
            this.minimizeButton.Size = new System.Drawing.Size(26, 22);
            this.minimizeButton.TabIndex = 9;
            this.toolTip.SetToolTip(this.minimizeButton, "Свернуть");
            this.minimizeButton.Click += new System.EventHandler(this.minimizeButton_Click);
            // 
            // nextButton
            // 
            this.nextButton.Icon = global::Inplation.Properties.Resources.next;
            this.nextButton.Location = new System.Drawing.Point(169, 5);
            this.nextButton.Name = "nextButton";
            this.nextButton.Size = new System.Drawing.Size(26, 22);
            this.nextButton.TabIndex = 8;
            this.toolTip.SetToolTip(this.nextButton, "Следующий месяц");
            this.nextButton.Click += new System.EventHandler(this.nextButton_Click);
            // 
            // closeButton
            // 
            this.closeButton.Icon = ((System.Drawing.Image)(resources.GetObject("closeButton.Icon")));
            this.closeButton.Location = new System.Drawing.Point(219, 5);
            this.closeButton.Name = "closeButton";
            this.closeButton.Size = new System.Drawing.Size(26, 22);
            this.closeButton.TabIndex = 7;
            this.toolTip.SetToolTip(this.closeButton, "Закрыть программу");
            this.closeButton.Click += new System.EventHandler(this.appleButton1_Click);
            // 
            // prevButton
            // 
            this.prevButton.Icon = global::Inplation.Properties.Resources.prev;
            this.prevButton.Location = new System.Drawing.Point(30, 5);
            this.prevButton.Name = "prevButton";
            this.prevButton.Size = new System.Drawing.Size(26, 22);
            this.prevButton.TabIndex = 6;
            this.toolTip.SetToolTip(this.prevButton, "Предыдущий месяц");
            this.prevButton.Click += new System.EventHandler(this.prevButton_Click);
            // 
            // reloadButton
            // 
            this.reloadButton.Icon = ((System.Drawing.Image)(resources.GetObject("reloadButton.Icon")));
            this.reloadButton.Location = new System.Drawing.Point(5, 5);
            this.reloadButton.Name = "reloadButton";
            this.reloadButton.Size = new System.Drawing.Size(26, 22);
            this.reloadButton.TabIndex = 0;
            this.toolTip.SetToolTip(this.reloadButton, "Обновить курсы");
            this.reloadButton.Click += new System.EventHandler(this.reloadButton_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(250, 139);
            this.Controls.Add(this.minimizeButton);
            this.Controls.Add(this.nextButton);
            this.Controls.Add(this.closeButton);
            this.Controls.Add(this.prevButton);
            this.Controls.Add(this.reloadButton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Location = new System.Drawing.Point(600, 250);
            this.Name = "MainForm";
            this.SavePositionToRegistry = true;
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Курсы валют";
            this.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.MainForm_MouseDoubleClick);
            this.Paint += new System.Windows.Forms.PaintEventHandler(this.MainForm_Paint);
            this.MouseUp += new System.Windows.Forms.MouseEventHandler(this.MainForm_MouseUp);
            this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.MainForm_MouseMove);
            this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.MainForm_MouseDown);
            this.ResumeLayout(false);

        }
        #endregion

        private Stopiccot.VisualComponents.AppleButton reloadButton;
        private Stopiccot.VisualComponents.AppleButton prevButton;
        private Stopiccot.VisualComponents.AppleButton closeButton;
        private Stopiccot.VisualComponents.AppleButton nextButton;
        private System.Windows.Forms.ToolTip toolTip;
        private Stopiccot.VisualComponents.AppleButton minimizeButton;
    }
}

