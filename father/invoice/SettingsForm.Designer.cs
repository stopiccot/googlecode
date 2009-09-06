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
            this.button1 = new System.Windows.Forms.Button();
            this.templatePath = new System.Windows.Forms.TextBox();
            this.changeTemplate = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.deleteCheckBox = new System.Windows.Forms.CheckBox();
            this.unpayCheckBox = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.cancelButton = new System.Windows.Forms.Button();
            this.applyButton = new System.Windows.Forms.Button();
            this.prices = new SP.VisualComponents.NumberTextBox();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(12, 12);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(267, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "Редактировать список компаний";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // templatePath
            // 
            this.templatePath.Location = new System.Drawing.Point(12, 54);
            this.templatePath.Name = "templatePath";
            this.templatePath.ReadOnly = true;
            this.templatePath.Size = new System.Drawing.Size(193, 20);
            this.templatePath.TabIndex = 1;
            // 
            // changeTemplate
            // 
            this.changeTemplate.Location = new System.Drawing.Point(211, 52);
            this.changeTemplate.Name = "changeTemplate";
            this.changeTemplate.Size = new System.Drawing.Size(68, 23);
            this.changeTemplate.TabIndex = 2;
            this.changeTemplate.Text = "Изменить";
            this.changeTemplate.UseVisualStyleBackColor = true;
            this.changeTemplate.Click += new System.EventHandler(this.changeTemplate_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(9, 38);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(46, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "Шаблон";
            // 
            // deleteCheckBox
            // 
            this.deleteCheckBox.AutoSize = true;
            this.deleteCheckBox.Location = new System.Drawing.Point(12, 80);
            this.deleteCheckBox.Name = "deleteCheckBox";
            this.deleteCheckBox.Size = new System.Drawing.Size(157, 17);
            this.deleteCheckBox.TabIndex = 5;
            this.deleteCheckBox.Text = "Подтверждение удаления";
            this.deleteCheckBox.UseVisualStyleBackColor = true;
            // 
            // unpayCheckBox
            // 
            this.unpayCheckBox.AutoSize = true;
            this.unpayCheckBox.Location = new System.Drawing.Point(12, 103);
            this.unpayCheckBox.Name = "unpayCheckBox";
            this.unpayCheckBox.Size = new System.Drawing.Size(159, 17);
            this.unpayCheckBox.TabIndex = 6;
            this.unpayCheckBox.Text = "Подтверждение неоплаты";
            this.unpayCheckBox.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(9, 123);
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
            this.cancelButton.Location = new System.Drawing.Point(204, 410);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(75, 23);
            this.cancelButton.TabIndex = 9;
            this.cancelButton.Text = "Отмена";
            this.cancelButton.UseVisualStyleBackColor = true;
            this.cancelButton.Click += new System.EventHandler(this.cancelButtonClick);
            // 
            // applyButton
            // 
            this.applyButton.Location = new System.Drawing.Point(123, 410);
            this.applyButton.Name = "applyButton";
            this.applyButton.Size = new System.Drawing.Size(75, 23);
            this.applyButton.TabIndex = 10;
            this.applyButton.Text = "Применить";
            this.applyButton.UseVisualStyleBackColor = true;
            this.applyButton.Click += new System.EventHandler(this.applyButtonClick);
            // 
            // prices
            // 
            this.prices.Location = new System.Drawing.Point(12, 139);
            this.prices.Multiline = true;
            this.prices.Name = "prices";
            this.prices.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.prices.Size = new System.Drawing.Size(267, 265);
            this.prices.TabIndex = 8;
            // 
            // SettingsForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(291, 445);
            this.Controls.Add(this.applyButton);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.prices);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.unpayCheckBox);
            this.Controls.Add(this.deleteCheckBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.changeTemplate);
            this.Controls.Add(this.templatePath);
            this.Controls.Add(this.button1);
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

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox templatePath;
        private System.Windows.Forms.Button changeTemplate;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.CheckBox deleteCheckBox;
        private System.Windows.Forms.CheckBox unpayCheckBox;
        private System.Windows.Forms.Label label3;
        //private System.Windows.Forms.TextBox prices;
        private SP.VisualComponents.NumberTextBox prices;
        private System.Windows.Forms.OpenFileDialog openFileDialog;
        private System.Windows.Forms.Button cancelButton;
        private System.Windows.Forms.Button applyButton;
    }
}