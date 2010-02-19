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
            this.components = new System.ComponentModel.Container();
            this.editCompaniesButton = new System.Windows.Forms.Button();
            this.templatePathEdit = new System.Windows.Forms.TextBox();
            this.changeTemplateButton = new System.Windows.Forms.Button();
            this.templatePathLabel = new System.Windows.Forms.Label();
            this.deleteCheckBox = new System.Windows.Forms.CheckBox();
            this.unpayCheckBox = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.cancelButton = new System.Windows.Forms.Button();
            this.applyButton = new System.Windows.Forms.Button();
            this.toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.editTemplateButton = new System.Windows.Forms.Button();
            this.prices = new SP.VisualComponents.NumberTextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // editCompaniesButton
            // 
            this.editCompaniesButton.Location = new System.Drawing.Point(12, 12);
            this.editCompaniesButton.Name = "editCompaniesButton";
            this.editCompaniesButton.Size = new System.Drawing.Size(336, 23);
            this.editCompaniesButton.TabIndex = 0;
            this.editCompaniesButton.Text = "Редактировать список компаний";
            this.editCompaniesButton.UseVisualStyleBackColor = true;
            this.editCompaniesButton.Click += new System.EventHandler(this.button1_Click);
            // 
            // templatePathEdit
            // 
            this.templatePathEdit.Location = new System.Drawing.Point(12, 54);
            this.templatePathEdit.Name = "templatePathEdit";
            this.templatePathEdit.ReadOnly = true;
            this.templatePathEdit.Size = new System.Drawing.Size(168, 20);
            this.templatePathEdit.TabIndex = 1;
            this.toolTip.SetToolTip(this.templatePathEdit, "100500");
            // 
            // changeTemplateButton
            // 
            this.changeTemplateButton.Location = new System.Drawing.Point(286, 52);
            this.changeTemplateButton.Name = "changeTemplateButton";
            this.changeTemplateButton.Size = new System.Drawing.Size(62, 23);
            this.changeTemplateButton.TabIndex = 2;
            this.changeTemplateButton.Text = "Выбрать";
            this.changeTemplateButton.UseVisualStyleBackColor = true;
            this.changeTemplateButton.Click += new System.EventHandler(this.changeTemplate_Click);
            // 
            // templatePathLabel
            // 
            this.templatePathLabel.AutoSize = true;
            this.templatePathLabel.Location = new System.Drawing.Point(9, 38);
            this.templatePathLabel.Name = "templatePathLabel";
            this.templatePathLabel.Size = new System.Drawing.Size(46, 13);
            this.templatePathLabel.TabIndex = 3;
            this.templatePathLabel.Text = "Шаблон";
            // 
            // deleteCheckBox
            // 
            this.deleteCheckBox.AutoSize = true;
            this.deleteCheckBox.Location = new System.Drawing.Point(12, 168);
            this.deleteCheckBox.Name = "deleteCheckBox";
            this.deleteCheckBox.Size = new System.Drawing.Size(157, 17);
            this.deleteCheckBox.TabIndex = 5;
            this.deleteCheckBox.Text = "Подтверждение удаления";
            this.deleteCheckBox.UseVisualStyleBackColor = true;
            // 
            // unpayCheckBox
            // 
            this.unpayCheckBox.AutoSize = true;
            this.unpayCheckBox.Location = new System.Drawing.Point(12, 191);
            this.unpayCheckBox.Name = "unpayCheckBox";
            this.unpayCheckBox.Size = new System.Drawing.Size(159, 17);
            this.unpayCheckBox.TabIndex = 6;
            this.unpayCheckBox.Text = "Подтверждение неоплаты";
            this.unpayCheckBox.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 211);
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
            this.cancelButton.Location = new System.Drawing.Point(273, 410);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(75, 23);
            this.cancelButton.TabIndex = 9;
            this.cancelButton.Text = "Отмена";
            this.cancelButton.UseVisualStyleBackColor = true;
            this.cancelButton.Click += new System.EventHandler(this.cancelButtonClick);
            // 
            // applyButton
            // 
            this.applyButton.Location = new System.Drawing.Point(192, 410);
            this.applyButton.Name = "applyButton";
            this.applyButton.Size = new System.Drawing.Size(75, 23);
            this.applyButton.TabIndex = 10;
            this.applyButton.Text = "Применить";
            this.applyButton.UseVisualStyleBackColor = true;
            this.applyButton.Click += new System.EventHandler(this.applyButtonClick);
            // 
            // editTemplateButton
            // 
            this.editTemplateButton.Location = new System.Drawing.Point(186, 52);
            this.editTemplateButton.Name = "editTemplateButton";
            this.editTemplateButton.Size = new System.Drawing.Size(94, 23);
            this.editTemplateButton.TabIndex = 11;
            this.editTemplateButton.Text = "Редактировать";
            this.editTemplateButton.UseVisualStyleBackColor = true;
            // 
            // prices
            // 
            this.prices.Location = new System.Drawing.Point(12, 227);
            this.prices.Multiline = true;
            this.prices.Name = "prices";
            this.prices.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.prices.Size = new System.Drawing.Size(336, 177);
            this.prices.TabIndex = 8;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(286, 92);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(62, 23);
            this.button1.TabIndex = 14;
            this.button1.Text = "Выбрать";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // SettingsForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(360, 445);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.editTemplateButton);
            this.Controls.Add(this.applyButton);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.prices);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.unpayCheckBox);
            this.Controls.Add(this.deleteCheckBox);
            this.Controls.Add(this.templatePathLabel);
            this.Controls.Add(this.changeTemplateButton);
            this.Controls.Add(this.templatePathEdit);
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
        private System.Windows.Forms.TextBox templatePathEdit;
        private System.Windows.Forms.Button changeTemplateButton;
        private System.Windows.Forms.Label templatePathLabel;
        private System.Windows.Forms.CheckBox deleteCheckBox;
        private System.Windows.Forms.CheckBox unpayCheckBox;
        private System.Windows.Forms.Label label3;
        //private System.Windows.Forms.TextBox prices;
        private SP.VisualComponents.NumberTextBox prices;
        private System.Windows.Forms.OpenFileDialog openFileDialog;
        private System.Windows.Forms.Button cancelButton;
        private System.Windows.Forms.Button applyButton;
        private System.Windows.Forms.ToolTip toolTip;
        private System.Windows.Forms.Button editTemplateButton;
        private System.Windows.Forms.Button button1;
    }
}