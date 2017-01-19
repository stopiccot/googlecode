namespace Invoice
{
    partial class SettingsForm
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
            this.editCompaniesButton = new System.Windows.Forms.Button();
            this.deleteCheckBox = new System.Windows.Forms.CheckBox();
            this.unpayCheckBox = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.cancelButton = new System.Windows.Forms.Button();
            this.applyButton = new System.Windows.Forms.Button();
            this.prevYearDirPath = new System.Windows.Forms.TextBox();
            this.changePrevYearDir = new System.Windows.Forms.Button();
            this.prevYearDirLabel = new System.Windows.Forms.Label();
            this.currYearDirLabel = new System.Windows.Forms.Label();
            this.changeCurrYearDir = new System.Windows.Forms.Button();
            this.currYearDirPath = new System.Windows.Forms.TextBox();
            this.selectFolderDialog = new System.Windows.Forms.FolderBrowserDialog();
            this.prices = new Stopiccot.VisualComponents.NumberTextBox();
            this.SuspendLayout();
            // 
            // editCompaniesButton
            // 
            this.editCompaniesButton.Location = new System.Drawing.Point(12, 12);
            this.editCompaniesButton.Name = "editCompaniesButton";
            this.editCompaniesButton.Size = new System.Drawing.Size(283, 23);
            this.editCompaniesButton.TabIndex = 0;
            this.editCompaniesButton.Text = "Редактировать список компаний";
            this.editCompaniesButton.UseVisualStyleBackColor = true;
            this.editCompaniesButton.Click += new System.EventHandler(this.editCompaniesButton_Click);
            // 
            // deleteCheckBox
            // 
            this.deleteCheckBox.AutoSize = true;
            this.deleteCheckBox.Location = new System.Drawing.Point(12, 127);
            this.deleteCheckBox.Name = "deleteCheckBox";
            this.deleteCheckBox.Size = new System.Drawing.Size(157, 17);
            this.deleteCheckBox.TabIndex = 5;
            this.deleteCheckBox.Text = "Подтверждение удаления";
            this.deleteCheckBox.UseVisualStyleBackColor = true;
            // 
            // unpayCheckBox
            // 
            this.unpayCheckBox.AutoSize = true;
            this.unpayCheckBox.Location = new System.Drawing.Point(12, 150);
            this.unpayCheckBox.Name = "unpayCheckBox";
            this.unpayCheckBox.Size = new System.Drawing.Size(159, 17);
            this.unpayCheckBox.TabIndex = 6;
            this.unpayCheckBox.Text = "Подтверждение неоплаты";
            this.unpayCheckBox.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(9, 170);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(35, 13);
            this.label3.TabIndex = 7;
            this.label3.Text = "Цены";
            // 
            // openFileDialog
            // 
            this.openFileDialog.FileName = "openFileDialog";
            // 
            // cancelButton
            // 
            this.cancelButton.Location = new System.Drawing.Point(220, 489);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(75, 23);
            this.cancelButton.TabIndex = 9;
            this.cancelButton.Text = "Отмена";
            this.cancelButton.UseVisualStyleBackColor = true;
            this.cancelButton.Click += new System.EventHandler(this.cancelButtonClick);
            // 
            // applyButton
            // 
            this.applyButton.Location = new System.Drawing.Point(139, 489);
            this.applyButton.Name = "applyButton";
            this.applyButton.Size = new System.Drawing.Size(75, 23);
            this.applyButton.TabIndex = 10;
            this.applyButton.Text = "Применить";
            this.applyButton.UseVisualStyleBackColor = true;
            this.applyButton.Click += new System.EventHandler(this.applyButtonClick);
            // 
            // prevYearDirPath
            // 
            this.prevYearDirPath.Location = new System.Drawing.Point(12, 58);
            this.prevYearDirPath.Name = "prevYearDirPath";
            this.prevYearDirPath.ReadOnly = true;
            this.prevYearDirPath.Size = new System.Drawing.Size(209, 20);
            this.prevYearDirPath.TabIndex = 11;
            // 
            // changePrevYearDir
            // 
            this.changePrevYearDir.Location = new System.Drawing.Point(227, 56);
            this.changePrevYearDir.Name = "changePrevYearDir";
            this.changePrevYearDir.Size = new System.Drawing.Size(68, 23);
            this.changePrevYearDir.TabIndex = 12;
            this.changePrevYearDir.Text = "Изменить";
            this.changePrevYearDir.UseVisualStyleBackColor = true;
            this.changePrevYearDir.Click += new System.EventHandler(this.changePrevYearDir_Click);
            // 
            // prevYearDirLabel
            // 
            this.prevYearDirLabel.AutoSize = true;
            this.prevYearDirLabel.Location = new System.Drawing.Point(9, 42);
            this.prevYearDirLabel.Name = "prevYearDirLabel";
            this.prevYearDirLabel.Size = new System.Drawing.Size(89, 13);
            this.prevYearDirLabel.TabIndex = 13;
            this.prevYearDirLabel.Text = "prevYearDirLabel";
            // 
            // currYearDirLabel
            // 
            this.currYearDirLabel.AutoSize = true;
            this.currYearDirLabel.Location = new System.Drawing.Point(9, 81);
            this.currYearDirLabel.Name = "currYearDirLabel";
            this.currYearDirLabel.Size = new System.Drawing.Size(86, 13);
            this.currYearDirLabel.TabIndex = 16;
            this.currYearDirLabel.Text = "currYearDirLabel";
            // 
            // changeCurrYearDir
            // 
            this.changeCurrYearDir.Location = new System.Drawing.Point(227, 95);
            this.changeCurrYearDir.Name = "changeCurrYearDir";
            this.changeCurrYearDir.Size = new System.Drawing.Size(68, 23);
            this.changeCurrYearDir.TabIndex = 15;
            this.changeCurrYearDir.Text = "Изменить";
            this.changeCurrYearDir.UseVisualStyleBackColor = true;
            this.changeCurrYearDir.Click += new System.EventHandler(this.changeCurrYearDir_Click);
            // 
            // currYearDirPath
            // 
            this.currYearDirPath.Location = new System.Drawing.Point(12, 97);
            this.currYearDirPath.Name = "currYearDirPath";
            this.currYearDirPath.ReadOnly = true;
            this.currYearDirPath.Size = new System.Drawing.Size(209, 20);
            this.currYearDirPath.TabIndex = 14;
            // 
            // prices
            // 
            this.prices.Location = new System.Drawing.Point(12, 186);
            this.prices.Multiline = true;
            this.prices.Name = "prices";
            this.prices.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.prices.Size = new System.Drawing.Size(283, 297);
            this.prices.TabIndex = 8;
            // 
            // SettingsForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(307, 521);
            this.Controls.Add(this.currYearDirLabel);
            this.Controls.Add(this.changeCurrYearDir);
            this.Controls.Add(this.currYearDirPath);
            this.Controls.Add(this.prevYearDirLabel);
            this.Controls.Add(this.changePrevYearDir);
            this.Controls.Add(this.prevYearDirPath);
            this.Controls.Add(this.applyButton);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.prices);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.unpayCheckBox);
            this.Controls.Add(this.deleteCheckBox);
            this.Controls.Add(this.editCompaniesButton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SettingsForm";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Настройки";
            this.Shown += new System.EventHandler(this.SettingsForm_Shown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button editCompaniesButton;
        private System.Windows.Forms.CheckBox deleteCheckBox;
        private System.Windows.Forms.CheckBox unpayCheckBox;
        private System.Windows.Forms.Label label3;
        //private System.Windows.Forms.TextBox prices;
        private Stopiccot.VisualComponents.NumberTextBox prices;
        private System.Windows.Forms.OpenFileDialog openFileDialog;
        private System.Windows.Forms.Button cancelButton;
        private System.Windows.Forms.Button applyButton;
        private System.Windows.Forms.TextBox prevYearDirPath;
        private System.Windows.Forms.Button changePrevYearDir;
        private System.Windows.Forms.Label prevYearDirLabel;
        private System.Windows.Forms.Label currYearDirLabel;
        private System.Windows.Forms.Button changeCurrYearDir;
        private System.Windows.Forms.TextBox currYearDirPath;
        private System.Windows.Forms.FolderBrowserDialog selectFolderDialog;
    }
}