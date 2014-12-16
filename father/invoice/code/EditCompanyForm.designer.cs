namespace Invoice
{
    partial class EditCompanyForm
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
            this.listBox = new System.Windows.Forms.ListBox();
            this.addButton = new System.Windows.Forms.Button();
            this.delButton = new System.Windows.Forms.Button();
            this.panel = new System.Windows.Forms.Panel();
            this.label5 = new System.Windows.Forms.Label();
            this.contractString = new System.Windows.Forms.TextBox();
            this.contractNumber = new System.Windows.Forms.ComboBox();
            this.contractDate = new System.Windows.Forms.DateTimePicker();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.fullName = new System.Windows.Forms.TextBox();
            this.shortName = new System.Windows.Forms.TextBox();
            this.panel.SuspendLayout();
            this.SuspendLayout();
            // 
            // listBox
            // 
            this.listBox.FormattingEnabled = true;
            this.listBox.Location = new System.Drawing.Point(12, 12);
            this.listBox.Name = "listBox";
            this.listBox.Size = new System.Drawing.Size(115, 160);
            this.listBox.TabIndex = 0;
            this.listBox.SelectedIndexChanged += new System.EventHandler(this.listBox_SelectedIndexChanged);
            // 
            // addButton
            // 
            this.addButton.Location = new System.Drawing.Point(12, 178);
            this.addButton.Name = "addButton";
            this.addButton.Size = new System.Drawing.Size(86, 23);
            this.addButton.TabIndex = 1;
            this.addButton.Text = "Добавить";
            this.addButton.UseVisualStyleBackColor = true;
            this.addButton.Click += new System.EventHandler(this.addButton_Click);
            // 
            // delButton
            // 
            this.delButton.Enabled = false;
            this.delButton.Image = global::Invoice.Properties.Resources.del;
            this.delButton.Location = new System.Drawing.Point(104, 178);
            this.delButton.Name = "delButton";
            this.delButton.Size = new System.Drawing.Size(23, 23);
            this.delButton.TabIndex = 12;
            this.delButton.UseVisualStyleBackColor = true;
            this.delButton.Click += new System.EventHandler(this.delButton_Click);
            // 
            // panel
            // 
            this.panel.Controls.Add(this.label5);
            this.panel.Controls.Add(this.contractString);
            this.panel.Controls.Add(this.contractNumber);
            this.panel.Controls.Add(this.contractDate);
            this.panel.Controls.Add(this.label6);
            this.panel.Controls.Add(this.label7);
            this.panel.Controls.Add(this.label8);
            this.panel.Controls.Add(this.fullName);
            this.panel.Controls.Add(this.shortName);
            this.panel.Location = new System.Drawing.Point(133, 11);
            this.panel.Name = "panel";
            this.panel.Size = new System.Drawing.Size(260, 192);
            this.panel.TabIndex = 14;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label5.Location = new System.Drawing.Point(0, 117);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(57, 13);
            this.label5.TabIndex = 20;
            this.label5.Text = "Директор";
            // 
            // contractString
            // 
            this.contractString.Enabled = false;
            this.contractString.Location = new System.Drawing.Point(3, 133);
            this.contractString.Multiline = true;
            this.contractString.Name = "contractString";
            this.contractString.Size = new System.Drawing.Size(254, 56);
            this.contractString.TabIndex = 19;
            this.contractString.TextChanged += new System.EventHandler(this.contractString_TextChanged);
            // 
            // contractNumber
            // 
            this.contractNumber.Enabled = false;
            this.contractNumber.FormattingEnabled = true;
            this.contractNumber.Items.AddRange(new object[] {
            "б\\н"});
            this.contractNumber.Location = new System.Drawing.Point(134, 94);
            this.contractNumber.Name = "contractNumber";
            this.contractNumber.Size = new System.Drawing.Size(123, 21);
            this.contractNumber.TabIndex = 18;
            this.contractNumber.TextChanged += new System.EventHandler(this.contractNumber_TextChanged);
            // 
            // contractDate
            // 
            this.contractDate.Enabled = false;
            this.contractDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.contractDate.Location = new System.Drawing.Point(3, 94);
            this.contractDate.Name = "contractDate";
            this.contractDate.Size = new System.Drawing.Size(125, 20);
            this.contractDate.TabIndex = 17;
            this.contractDate.ValueChanged += new System.EventHandler(this.contractDate_ValueChanged);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label6.Location = new System.Drawing.Point(0, 78);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(50, 13);
            this.label6.TabIndex = 16;
            this.label6.Text = "Договор";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label7.Location = new System.Drawing.Point(0, 39);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(94, 13);
            this.label7.TabIndex = 15;
            this.label7.Text = "Полное название";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label8.Location = new System.Drawing.Point(0, 0);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(127, 13);
            this.label8.TabIndex = 14;
            this.label8.Text = "Сокращенное название";
            // 
            // fullName
            // 
            this.fullName.Enabled = false;
            this.fullName.Location = new System.Drawing.Point(3, 55);
            this.fullName.Name = "fullName";
            this.fullName.Size = new System.Drawing.Size(254, 20);
            this.fullName.TabIndex = 13;
            this.fullName.TextChanged += new System.EventHandler(this.fullName_TextChanged);
            // 
            // shortName
            // 
            this.shortName.Enabled = false;
            this.shortName.Location = new System.Drawing.Point(3, 16);
            this.shortName.Name = "shortName";
            this.shortName.Size = new System.Drawing.Size(254, 20);
            this.shortName.TabIndex = 12;
            this.shortName.TextChanged += new System.EventHandler(this.shortName_TextChanged);
            // 
            // EditCompanyForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(400, 211);
            this.Controls.Add(this.panel);
            this.Controls.Add(this.delButton);
            this.Controls.Add(this.addButton);
            this.Controls.Add(this.listBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "EditCompanyForm";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Редактирование компаний";
            this.panel.ResumeLayout(false);
            this.panel.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListBox listBox;
        private System.Windows.Forms.Button addButton;
        private System.Windows.Forms.Button delButton;
        private System.Windows.Forms.Panel panel;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox contractString;
        private System.Windows.Forms.ComboBox contractNumber;
        private System.Windows.Forms.DateTimePicker contractDate;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox fullName;
        private System.Windows.Forms.TextBox shortName;
    }
}