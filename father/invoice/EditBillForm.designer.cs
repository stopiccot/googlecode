namespace Invoice
{
    partial class EditBillForm
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
            this.billDate = new System.Windows.Forms.DateTimePicker();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.billCompany = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.applyButton = new System.Windows.Forms.Button();
            this.cancelButton = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.billNumber = new System.Windows.Forms.NumericUpDown();
            this.label4 = new System.Windows.Forms.Label();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.checkBox2 = new System.Windows.Forms.CheckBox();
            this.checkBox3 = new System.Windows.Forms.CheckBox();
            this.checkBox4 = new System.Windows.Forms.CheckBox();
            this.car = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.checkBox5 = new System.Windows.Forms.CheckBox();
            this.checkBox6 = new System.Windows.Forms.CheckBox();
            this.checkBox7 = new System.Windows.Forms.CheckBox();
            this.textBox2 = new Stopiccot.VisualComponents.NumberTextBox();
            this.textBox3 = new Stopiccot.VisualComponents.NumberTextBox();
            this.textBox4 = new Stopiccot.VisualComponents.NumberTextBox();
            this.textBox5 = new Stopiccot.VisualComponents.NumberTextBox();
            this.textBox6 = new Stopiccot.VisualComponents.NumberTextBox();
            this.textBox7 = new Stopiccot.VisualComponents.NumberTextBox();
            this.totalPriceLabel = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.billNumber)).BeginInit();
            this.SuspendLayout();
            // 
            // billDate
            // 
            this.billDate.Checked = false;
            this.billDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.billDate.Location = new System.Drawing.Point(12, 25);
            this.billDate.Name = "billDate";
            this.billDate.Size = new System.Drawing.Size(153, 20);
            this.billDate.TabIndex = 0;
            this.billDate.ValueChanged += new System.EventHandler(this.dateTimePicker1_ValueChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(9, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(33, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Дата";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(9, 48);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(58, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Компания";
            // 
            // billCompany
            // 
            this.billCompany.AllowDrop = true;
            this.billCompany.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.billCompany.FormattingEnabled = true;
            this.billCompany.ItemHeight = 13;
            this.billCompany.Location = new System.Drawing.Point(12, 65);
            this.billCompany.MaxDropDownItems = 20;
            this.billCompany.Name = "billCompany";
            this.billCompany.Size = new System.Drawing.Size(237, 21);
            this.billCompany.TabIndex = 3;
            this.billCompany.SelectedIndexChanged += new System.EventHandler(this.billCompany_SelectedIndexChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label3.Location = new System.Drawing.Point(29, 333);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(42, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "Сумма:";
            // 
            // applyButton
            // 
            this.applyButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.applyButton.Location = new System.Drawing.Point(181, 357);
            this.applyButton.Name = "applyButton";
            this.applyButton.Size = new System.Drawing.Size(100, 23);
            this.applyButton.TabIndex = 6;
            this.applyButton.Text = "Создать";
            this.applyButton.UseVisualStyleBackColor = true;
            this.applyButton.Click += new System.EventHandler(this.applyButton_Click);
            // 
            // cancelButton
            // 
            this.cancelButton.Location = new System.Drawing.Point(12, 357);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(100, 23);
            this.cancelButton.TabIndex = 7;
            this.cancelButton.Text = "Отмена";
            this.cancelButton.UseVisualStyleBackColor = true;
            this.cancelButton.Click += new System.EventHandler(this.cancelButton_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(255, 63);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(26, 23);
            this.button3.TabIndex = 8;
            this.button3.Text = "...";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // billNumber
            // 
            this.billNumber.Location = new System.Drawing.Point(180, 25);
            this.billNumber.Maximum = new decimal(new int[] {
            1000,
            0,
            0,
            0});
            this.billNumber.Name = "billNumber";
            this.billNumber.Size = new System.Drawing.Size(101, 20);
            this.billNumber.TabIndex = 9;
            this.billNumber.ValueChanged += new System.EventHandler(this.billNumber_ValueChanged);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(177, 9);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(41, 13);
            this.label4.TabIndex = 10;
            this.label4.Text = "Номер";
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.checkBox1.Location = new System.Drawing.Point(12, 151);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(63, 17);
            this.checkBox1.TabIndex = 11;
            this.checkBox1.Tag = "1";
            this.checkBox1.Text = "Осмотр";
            this.checkBox1.UseVisualStyleBackColor = true;
            this.checkBox1.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // checkBox2
            // 
            this.checkBox2.AutoSize = true;
            this.checkBox2.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.checkBox2.Location = new System.Drawing.Point(12, 177);
            this.checkBox2.Name = "checkBox2";
            this.checkBox2.Size = new System.Drawing.Size(89, 17);
            this.checkBox2.TabIndex = 12;
            this.checkBox2.Tag = "2";
            this.checkBox2.Text = "Заключение";
            this.checkBox2.UseVisualStyleBackColor = true;
            this.checkBox2.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // checkBox3
            // 
            this.checkBox3.AutoSize = true;
            this.checkBox3.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.checkBox3.Location = new System.Drawing.Point(12, 203);
            this.checkBox3.Name = "checkBox3";
            this.checkBox3.Size = new System.Drawing.Size(149, 17);
            this.checkBox3.TabIndex = 13;
            this.checkBox3.Tag = "4";
            this.checkBox3.Text = "Выезд по месту осмотра";
            this.checkBox3.UseVisualStyleBackColor = true;
            this.checkBox3.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // checkBox4
            // 
            this.checkBox4.AutoSize = true;
            this.checkBox4.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.checkBox4.Location = new System.Drawing.Point(12, 229);
            this.checkBox4.Name = "checkBox4";
            this.checkBox4.Size = new System.Drawing.Size(196, 17);
            this.checkBox4.TabIndex = 14;
            this.checkBox4.Tag = "8";
            this.checkBox4.Text = "Расчёт вреда в случае гибели ТС";
            this.checkBox4.UseVisualStyleBackColor = true;
            this.checkBox4.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // car
            // 
            this.car.Location = new System.Drawing.Point(12, 102);
            this.car.Multiline = true;
            this.car.Name = "car";
            this.car.Size = new System.Drawing.Size(269, 41);
            this.car.TabIndex = 26;
            this.car.TextChanged += new System.EventHandler(this.car_TextChanged);
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(9, 86);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(123, 13);
            this.label9.TabIndex = 27;
            this.label9.Text = "Траспортное средство";
            // 
            // checkBox5
            // 
            this.checkBox5.AutoSize = true;
            this.checkBox5.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.checkBox5.Location = new System.Drawing.Point(12, 255);
            this.checkBox5.Name = "checkBox5";
            this.checkBox5.Size = new System.Drawing.Size(172, 17);
            this.checkBox5.TabIndex = 28;
            this.checkBox5.Tag = "8";
            this.checkBox5.Text = "Расчёт деф. эксплуатции ТС";
            this.checkBox5.UseVisualStyleBackColor = true;
            this.checkBox5.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // checkBox6
            // 
            this.checkBox6.AutoSize = true;
            this.checkBox6.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.checkBox6.Location = new System.Drawing.Point(12, 281);
            this.checkBox6.Name = "checkBox6";
            this.checkBox6.Size = new System.Drawing.Size(135, 17);
            this.checkBox6.TabIndex = 29;
            this.checkBox6.Tag = "8";
            this.checkBox6.Text = "Расчёт стоимости ТС ";
            this.checkBox6.UseVisualStyleBackColor = true;
            this.checkBox6.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // checkBox7
            // 
            this.checkBox7.AutoSize = true;
            this.checkBox7.Location = new System.Drawing.Point(12, 307);
            this.checkBox7.Name = "checkBox7";
            this.checkBox7.Size = new System.Drawing.Size(86, 17);
            this.checkBox7.TabIndex = 30;
            this.checkBox7.Text = "Перерасчет";
            this.checkBox7.UseVisualStyleBackColor = true;
            this.checkBox7.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(220, 175);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(61, 20);
            this.textBox2.TabIndex = 32;
            this.textBox2.Text = "0";
            this.textBox2.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.textBox2.Value = new decimal(new int[] {
            0,
            0,
            0,
            0});
            this.textBox2.TextChanged += new System.EventHandler(this.subpriceTextBox_TextChanged);
            // 
            // textBox3
            // 
            this.textBox3.Location = new System.Drawing.Point(220, 201);
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new System.Drawing.Size(61, 20);
            this.textBox3.TabIndex = 33;
            this.textBox3.Text = "0";
            this.textBox3.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.textBox3.Value = new decimal(new int[] {
            0,
            0,
            0,
            0});
            this.textBox3.TextChanged += new System.EventHandler(this.subpriceTextBox_TextChanged);
            // 
            // textBox4
            // 
            this.textBox4.Location = new System.Drawing.Point(220, 227);
            this.textBox4.Name = "textBox4";
            this.textBox4.Size = new System.Drawing.Size(61, 20);
            this.textBox4.TabIndex = 34;
            this.textBox4.Text = "0";
            this.textBox4.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.textBox4.Value = new decimal(new int[] {
            0,
            0,
            0,
            0});
            this.textBox4.TextChanged += new System.EventHandler(this.subpriceTextBox_TextChanged);
            // 
            // textBox5
            // 
            this.textBox5.Location = new System.Drawing.Point(220, 253);
            this.textBox5.Name = "textBox5";
            this.textBox5.Size = new System.Drawing.Size(61, 20);
            this.textBox5.TabIndex = 35;
            this.textBox5.Text = "0";
            this.textBox5.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.textBox5.Value = new decimal(new int[] {
            0,
            0,
            0,
            0});
            this.textBox5.TextChanged += new System.EventHandler(this.subpriceTextBox_TextChanged);
            // 
            // textBox6
            // 
            this.textBox6.Location = new System.Drawing.Point(220, 279);
            this.textBox6.Name = "textBox6";
            this.textBox6.Size = new System.Drawing.Size(61, 20);
            this.textBox6.TabIndex = 36;
            this.textBox6.Text = "0";
            this.textBox6.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.textBox6.Value = new decimal(new int[] {
            0,
            0,
            0,
            0});
            this.textBox6.TextChanged += new System.EventHandler(this.subpriceTextBox_TextChanged);
            // 
            // textBox7
            // 
            this.textBox7.Location = new System.Drawing.Point(220, 305);
            this.textBox7.Name = "textBox7";
            this.textBox7.Size = new System.Drawing.Size(61, 20);
            this.textBox7.TabIndex = 37;
            this.textBox7.Text = "0";
            this.textBox7.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.textBox7.Value = new decimal(new int[] {
            0,
            0,
            0,
            0});
            this.textBox7.TextChanged += new System.EventHandler(this.subpriceTextBox_TextChanged);
            // 
            // totalPriceLabel
            // 
            this.totalPriceLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 13F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.totalPriceLabel.Location = new System.Drawing.Point(133, 328);
            this.totalPriceLabel.Name = "totalPriceLabel";
            this.totalPriceLabel.Size = new System.Drawing.Size(154, 22);
            this.totalPriceLabel.TabIndex = 38;
            this.totalPriceLabel.Text = "0.00";
            this.totalPriceLabel.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // EditBillForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(290, 392);
            this.Controls.Add(this.totalPriceLabel);
            this.Controls.Add(this.textBox7);
            this.Controls.Add(this.textBox6);
            this.Controls.Add(this.textBox5);
            this.Controls.Add(this.textBox4);
            this.Controls.Add(this.textBox3);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.checkBox7);
            this.Controls.Add(this.checkBox6);
            this.Controls.Add(this.checkBox5);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.car);
            this.Controls.Add(this.checkBox4);
            this.Controls.Add(this.checkBox3);
            this.Controls.Add(this.checkBox2);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.billNumber);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.applyButton);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.billCompany);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.billDate);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "EditBillForm";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Редактирование счёт-фактуры";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.EditBillForm_FormClosing);
            ((System.ComponentModel.ISupportInitialize)(this.billNumber)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DateTimePicker billDate;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox billCompany;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button applyButton;
        private System.Windows.Forms.Button cancelButton;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.NumericUpDown billNumber;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.CheckBox checkBox2;
        private System.Windows.Forms.CheckBox checkBox3;
        private System.Windows.Forms.CheckBox checkBox4;
        private System.Windows.Forms.TextBox car;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.CheckBox checkBox5;
        private System.Windows.Forms.CheckBox checkBox6;
        private System.Windows.Forms.CheckBox checkBox7;
        private Stopiccot.VisualComponents.NumberTextBox textBox2;
        private Stopiccot.VisualComponents.NumberTextBox textBox3;
        private Stopiccot.VisualComponents.NumberTextBox textBox4;
        private Stopiccot.VisualComponents.NumberTextBox textBox5;
        private Stopiccot.VisualComponents.NumberTextBox textBox6;
        private Stopiccot.VisualComponents.NumberTextBox textBox7;
        private System.Windows.Forms.Label totalPriceLabel;
    }
}