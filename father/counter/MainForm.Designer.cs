namespace counter
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
            this.label1 = new System.Windows.Forms.Label();
            this.crashDate = new System.Windows.Forms.DateTimePicker();
            this.label2 = new System.Windows.Forms.Label();
            this.createDate = new System.Windows.Forms.DateTimePicker();
            this.noInRB = new System.Windows.Forms.CheckBox();
            this.registrationDate = new System.Windows.Forms.DateTimePicker();
            this.noOutRB = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.countButton = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.odometr = new Stopiccot.VisualComponents.NumberTextBox();
            this.categoryChooser = new Stopiccot.VisualComponents.Chooser();
            this.outputGrid = new Stopiccot.VisualComponents.OutputGrid();
            this.myPanel = new Stopiccot.VisualComponents.RollPanel();
            this.infoGrid = new Stopiccot.VisualComponents.OutputGrid();
            this.myPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.Location = new System.Drawing.Point(9, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(66, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Дата ДТП";
            // 
            // crashDate
            // 
            this.crashDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.crashDate.Location = new System.Drawing.Point(12, 25);
            this.crashDate.Name = "crashDate";
            this.crashDate.Size = new System.Drawing.Size(170, 20);
            this.crashDate.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label2.Location = new System.Drawing.Point(9, 48);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(92, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Дата выпуска";
            // 
            // createDate
            // 
            this.createDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.createDate.Location = new System.Drawing.Point(12, 64);
            this.createDate.Name = "createDate";
            this.createDate.Size = new System.Drawing.Size(170, 20);
            this.createDate.TabIndex = 3;
            // 
            // noInRB
            // 
            this.noInRB.Checked = true;
            this.noInRB.CheckState = System.Windows.Forms.CheckState.Checked;
            this.noInRB.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.noInRB.Location = new System.Drawing.Point(12, 90);
            this.noInRB.Name = "noInRB";
            this.noInRB.Size = new System.Drawing.Size(14, 14);
            this.noInRB.TabIndex = 4;
            this.noInRB.UseVisualStyleBackColor = true;
            this.noInRB.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // registrationDate
            // 
            this.registrationDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.registrationDate.Location = new System.Drawing.Point(12, 107);
            this.registrationDate.Name = "registrationDate";
            this.registrationDate.Size = new System.Drawing.Size(170, 20);
            this.registrationDate.TabIndex = 5;
            // 
            // noOutRB
            // 
            this.noOutRB.AutoSize = true;
            this.noOutRB.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.noOutRB.Location = new System.Drawing.Point(12, 129);
            this.noOutRB.Name = "noOutRB";
            this.noOutRB.Size = new System.Drawing.Size(174, 17);
            this.noOutRB.TabIndex = 6;
            this.noOutRB.Text = "Не имеет пробега зарубежом";
            this.noOutRB.UseVisualStyleBackColor = true;
            this.noOutRB.CheckedChanged += new System.EventHandler(this.noOutRB_CheckedChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label3.Location = new System.Drawing.Point(9, 149);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(119, 13);
            this.label3.TabIndex = 7;
            this.label3.Text = "Категория пробега";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label4.Location = new System.Drawing.Point(9, 190);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(131, 13);
            this.label4.TabIndex = 9;
            this.label4.Text = "Показания одометра";
            // 
            // countButton
            // 
            this.countButton.Location = new System.Drawing.Point(12, 232);
            this.countButton.Name = "countButton";
            this.countButton.Size = new System.Drawing.Size(170, 23);
            this.countButton.TabIndex = 11;
            this.countButton.Text = "Посчитать";
            this.countButton.UseVisualStyleBackColor = true;
            this.countButton.Click += new System.EventHandler(this.countButton_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label5.Location = new System.Drawing.Point(25, 90);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(108, 13);
            this.label5.TabIndex = 14;
            this.label5.Text = "Регистрация в РБ";
            // 
            // odometr
            // 
            this.odometr.Location = new System.Drawing.Point(12, 206);
            this.odometr.Name = "odometr";
            this.odometr.Size = new System.Drawing.Size(170, 20);
            this.odometr.TabIndex = 10;
            this.odometr.Text = "0";
            this.odometr.Value = 0;
            // 
            // categoryChooser
            // 
            this.categoryChooser.CellSize = new System.Drawing.Point(20, 20);
            this.categoryChooser.Items = new string[] {
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7"};
            this.categoryChooser.Location = new System.Drawing.Point(12, 165);
            this.categoryChooser.Name = "categoryChooser";
            this.categoryChooser.SelctedIndex = 0;
            this.categoryChooser.Size = new System.Drawing.Size(170, 22);
            this.categoryChooser.TabIndex = 8;
            // 
            // outputGrid
            // 
            this.outputGrid.CheckBoxImage = ((System.Drawing.Image)(resources.GetObject("outputGrid.CheckBoxImage")));
            this.outputGrid.Columns = new int[] {
        250};
            this.outputGrid.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.outputGrid.Grid = true;
            this.outputGrid.HoverColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(230)))), ((int)(((byte)(230)))));
            this.outputGrid.ItemHeight = 22;
            this.outputGrid.Location = new System.Drawing.Point(192, 25);
            this.outputGrid.Name = "outputGrid";
            this.outputGrid.Size = new System.Drawing.Size(378, 177);
            this.outputGrid.TabIndex = 15;
            this.outputGrid.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.outputGrid_ItemCheck);
            this.outputGrid.ItemChecked += new Stopiccot.VisualComponents.OutputGrid.ItemCheckedEventHandler(this.outputGrid_ItemChecked);
            // 
            // myPanel
            // 
            this.myPanel.Controls.Add(this.infoGrid);
            this.myPanel.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.myPanel.Location = new System.Drawing.Point(192, 208);
            this.myPanel.Minimized = false;
            this.myPanel.Name = "myPanel";
            this.myPanel.Size = new System.Drawing.Size(378, 238);
            this.myPanel.TabIndex = 17;
            this.myPanel.Text = "Таблица";
            this.myPanel.Resize += new System.EventHandler(this.myPanel_Resize);
            // 
            // infoGrid
            // 
            this.infoGrid.CheckBoxImage = ((System.Drawing.Image)(resources.GetObject("infoGrid.CheckBoxImage")));
            this.infoGrid.Columns = new int[] {
        80,
        70,
        80,
        90};
            this.infoGrid.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.infoGrid.Grid = true;
            this.infoGrid.HoverColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(230)))), ((int)(((byte)(230)))));
            this.infoGrid.ItemHeight = 20;
            this.infoGrid.Location = new System.Drawing.Point(2, 15);
            this.infoGrid.Name = "infoGrid";
            this.infoGrid.Size = new System.Drawing.Size(374, 221);
            this.infoGrid.TabIndex = 16;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(577, 422);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.countButton);
            this.Controls.Add(this.odometr);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.noOutRB);
            this.Controls.Add(this.registrationDate);
            this.Controls.Add(this.noInRB);
            this.Controls.Add(this.createDate);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.crashDate);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.categoryChooser);
            this.Controls.Add(this.outputGrid);
            this.Controls.Add(this.myPanel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Счётчик пробега";
            this.Shown += new System.EventHandler(this.MainForm_Shown);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing);
            this.myPanel.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DateTimePicker crashDate;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DateTimePicker createDate;
        private System.Windows.Forms.CheckBox noInRB;
        private System.Windows.Forms.DateTimePicker registrationDate;
        private System.Windows.Forms.CheckBox noOutRB;
        private System.Windows.Forms.Label label3;
        private Stopiccot.VisualComponents.Chooser categoryChooser;
        private System.Windows.Forms.Label label4;
        private Stopiccot.VisualComponents.NumberTextBox odometr;
        private System.Windows.Forms.Button countButton;
        private System.Windows.Forms.Label label5;
        private Stopiccot.VisualComponents.OutputGrid outputGrid;
        private Stopiccot.VisualComponents.OutputGrid infoGrid;
        private Stopiccot.VisualComponents.RollPanel myPanel;
    }
}