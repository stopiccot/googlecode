namespace exponent
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
            this.resultLabel = new System.Windows.Forms.Label();
            this.typeComboBox = new System.Windows.Forms.ComboBox();
            this.TTextBox = new System.Windows.Forms.TextBox();
            this.LTextBox = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // resultLabel
            // 
            this.resultLabel.AutoSize = true;
            this.resultLabel.Font = new System.Drawing.Font("Tahoma", 27.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.resultLabel.Location = new System.Drawing.Point(288, 89);
            this.resultLabel.Name = "resultLabel";
            this.resultLabel.Size = new System.Drawing.Size(147, 45);
            this.resultLabel.TabIndex = 4;
            this.resultLabel.Text = "00,00%";
            // 
            // typeComboBox
            // 
            this.typeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.typeComboBox.Font = new System.Drawing.Font("Tahoma", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.typeComboBox.FormattingEnabled = true;
            this.typeComboBox.Items.AddRange(new object[] {
            "Мотоциклы СНГ",
            "Мотоциклы зарубежные",
            "Легковые СНГ (1.1 - 2.2)",
            "Легковые СНГ (3.2 - 3.3)",
            "Легковые СНГ (4.2 и выше)",
            "Легковые зарубежные (1.1 - 2.2)",
            "Легковые зарубежные (3.2 - 3.3)",
            "Легковые зарубежные (4.2 - 4.4)",
            "Легковые зарубежные (5.3 и выше)",
            "Грузовые СНГ",
            "Автобусы СНГ",
            "Грузовые зарубежные",
            "Автобусы зарубежные"});
            this.typeComboBox.Location = new System.Drawing.Point(12, 12);
            this.typeComboBox.Name = "typeComboBox";
            this.typeComboBox.Size = new System.Drawing.Size(423, 31);
            this.typeComboBox.TabIndex = 5;
            this.typeComboBox.SelectedIndexChanged += new System.EventHandler(this.calculate);
            // 
            // TTextBox
            // 
            this.TTextBox.Font = new System.Drawing.Font("Tahoma", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.TTextBox.Location = new System.Drawing.Point(12, 49);
            this.TTextBox.Name = "TTextBox";
            this.TTextBox.Size = new System.Drawing.Size(132, 30);
            this.TTextBox.TabIndex = 6;
            this.TTextBox.TextChanged += new System.EventHandler(this.calculate);
            // 
            // LTextBox
            // 
            this.LTextBox.Font = new System.Drawing.Font("Tahoma", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.LTextBox.Location = new System.Drawing.Point(206, 49);
            this.LTextBox.Name = "LTextBox";
            this.LTextBox.Size = new System.Drawing.Size(143, 30);
            this.LTextBox.TabIndex = 8;
            this.LTextBox.TextChanged += new System.EventHandler(this.calculate);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Tahoma", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label4.Location = new System.Drawing.Point(150, 52);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(40, 23);
            this.label4.TabIndex = 9;
            this.label4.Text = "лет";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Tahoma", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label5.Location = new System.Drawing.Point(355, 52);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(80, 23);
            this.label5.TabIndex = 10;
            this.label5.Text = "тыс. км.";
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(448, 143);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.LTextBox);
            this.Controls.Add(this.TTextBox);
            this.Controls.Add(this.typeComboBox);
            this.Controls.Add(this.resultLabel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "exponent";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label resultLabel;
        private System.Windows.Forms.ComboBox typeComboBox;
        private System.Windows.Forms.TextBox TTextBox;
        private System.Windows.Forms.TextBox LTextBox;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
    }
}

