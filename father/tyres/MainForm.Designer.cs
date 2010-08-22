namespace tyres
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
            this.leftFrontTyre = new System.Windows.Forms.NumericUpDown();
            this.rightFrontTyre = new System.Windows.Forms.NumericUpDown();
            this.rightRearTyre = new System.Windows.Forms.NumericUpDown();
            this.leftRearTyre = new System.Windows.Forms.NumericUpDown();
            this.maxTread = new System.Windows.Forms.NumericUpDown();
            this.tуrePrice = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.minTread = new System.Windows.Forms.NumericUpDown();
            this.resultLabel = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.leftFrontTyre)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightFrontTyre)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightRearTyre)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.leftRearTyre)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.maxTread)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.minTread)).BeginInit();
            this.SuspendLayout();
            // 
            // leftFrontTyre
            // 
            this.leftFrontTyre.DecimalPlaces = 2;
            this.leftFrontTyre.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.leftFrontTyre.Increment = new decimal(new int[] {
            1,
            0,
            0,
            65536});
            this.leftFrontTyre.Location = new System.Drawing.Point(12, 28);
            this.leftFrontTyre.Name = "leftFrontTyre";
            this.leftFrontTyre.Size = new System.Drawing.Size(75, 26);
            this.leftFrontTyre.TabIndex = 0;
            this.leftFrontTyre.ValueChanged += new System.EventHandler(this.updatePrice);
            this.leftFrontTyre.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.onKeyPress);
            // 
            // rightFrontTyre
            // 
            this.rightFrontTyre.DecimalPlaces = 2;
            this.rightFrontTyre.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.rightFrontTyre.Increment = new decimal(new int[] {
            1,
            0,
            0,
            65536});
            this.rightFrontTyre.Location = new System.Drawing.Point(93, 28);
            this.rightFrontTyre.Name = "rightFrontTyre";
            this.rightFrontTyre.Size = new System.Drawing.Size(75, 26);
            this.rightFrontTyre.TabIndex = 1;
            this.rightFrontTyre.ValueChanged += new System.EventHandler(this.updatePrice);
            this.rightFrontTyre.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.onKeyPress);
            // 
            // rightRearTyre
            // 
            this.rightRearTyre.DecimalPlaces = 2;
            this.rightRearTyre.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.rightRearTyre.Increment = new decimal(new int[] {
            1,
            0,
            0,
            65536});
            this.rightRearTyre.Location = new System.Drawing.Point(93, 60);
            this.rightRearTyre.Name = "rightRearTyre";
            this.rightRearTyre.Size = new System.Drawing.Size(75, 26);
            this.rightRearTyre.TabIndex = 3;
            this.rightRearTyre.ValueChanged += new System.EventHandler(this.updatePrice);
            this.rightRearTyre.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.onKeyPress);
            // 
            // leftRearTyre
            // 
            this.leftRearTyre.DecimalPlaces = 2;
            this.leftRearTyre.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.leftRearTyre.Increment = new decimal(new int[] {
            1,
            0,
            0,
            65536});
            this.leftRearTyre.Location = new System.Drawing.Point(12, 60);
            this.leftRearTyre.Name = "leftRearTyre";
            this.leftRearTyre.Size = new System.Drawing.Size(75, 26);
            this.leftRearTyre.TabIndex = 2;
            this.leftRearTyre.ValueChanged += new System.EventHandler(this.updatePrice);
            this.leftRearTyre.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.onKeyPress);
            // 
            // maxTread
            // 
            this.maxTread.DecimalPlaces = 2;
            this.maxTread.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.maxTread.Increment = new decimal(new int[] {
            1,
            0,
            0,
            65536});
            this.maxTread.Location = new System.Drawing.Point(214, 28);
            this.maxTread.Name = "maxTread";
            this.maxTread.Size = new System.Drawing.Size(75, 26);
            this.maxTread.TabIndex = 4;
            this.maxTread.Value = new decimal(new int[] {
            75,
            0,
            0,
            65536});
            this.maxTread.ValueChanged += new System.EventHandler(this.updatePrice);
            // 
            // tуrePrice
            // 
            this.tуrePrice.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.tуrePrice.Location = new System.Drawing.Point(12, 118);
            this.tуrePrice.Name = "tуrePrice";
            this.tуrePrice.Size = new System.Drawing.Size(156, 26);
            this.tуrePrice.TabIndex = 5;
            this.tуrePrice.Text = "50";
            this.tуrePrice.TextChanged += new System.EventHandler(this.updatePrice);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(9, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(109, 13);
            this.label1.TabIndex = 6;
            this.label1.Text = "Глубина протектора";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(9, 102);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(72, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "Цена колеса";
            // 
            // minTread
            // 
            this.minTread.DecimalPlaces = 2;
            this.minTread.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.minTread.Increment = new decimal(new int[] {
            1,
            0,
            0,
            65536});
            this.minTread.Location = new System.Drawing.Point(214, 60);
            this.minTread.Name = "minTread";
            this.minTread.Size = new System.Drawing.Size(75, 26);
            this.minTread.TabIndex = 8;
            this.minTread.Value = new decimal(new int[] {
            16,
            0,
            0,
            65536});
            this.minTread.ValueChanged += new System.EventHandler(this.updatePrice);
            // 
            // resultLabel
            // 
            this.resultLabel.AutoSize = true;
            this.resultLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.resultLabel.Location = new System.Drawing.Point(200, 121);
            this.resultLabel.Name = "resultLabel";
            this.resultLabel.Size = new System.Drawing.Size(57, 20);
            this.resultLabel.TabIndex = 9;
            this.resultLabel.Text = "label3";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(182, 35);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(26, 13);
            this.label3.TabIndex = 10;
            this.label3.Text = "max";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(185, 67);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(23, 13);
            this.label4.TabIndex = 11;
            this.label4.Text = "min";
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(300, 162);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.resultLabel);
            this.Controls.Add(this.minTread);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.tуrePrice);
            this.Controls.Add(this.maxTread);
            this.Controls.Add(this.rightRearTyre);
            this.Controls.Add(this.leftRearTyre);
            this.Controls.Add(this.rightFrontTyre);
            this.Controls.Add(this.leftFrontTyre);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Рассчет стоимости колес";
            this.Load += new System.EventHandler(this.MainForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.leftFrontTyre)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightFrontTyre)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightRearTyre)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.leftRearTyre)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.maxTread)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.minTread)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.NumericUpDown leftFrontTyre;
        private System.Windows.Forms.NumericUpDown rightFrontTyre;
        private System.Windows.Forms.NumericUpDown rightRearTyre;
        private System.Windows.Forms.NumericUpDown leftRearTyre;
        private System.Windows.Forms.NumericUpDown maxTread;
        private System.Windows.Forms.TextBox tуrePrice;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.NumericUpDown minTread;
        private System.Windows.Forms.Label resultLabel;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;


    }
}

