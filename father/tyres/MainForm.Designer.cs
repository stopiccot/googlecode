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
            this.leftFrontTyre = new System.Windows.Forms.NumericUpDown();
            this.rightFrontTyre = new System.Windows.Forms.NumericUpDown();
            this.rightRearTyre = new System.Windows.Forms.NumericUpDown();
            this.leftRearTyre = new System.Windows.Forms.NumericUpDown();
            this.maxTread = new System.Windows.Forms.NumericUpDown();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.numericUpDown1 = new System.Windows.Forms.NumericUpDown();
            ((System.ComponentModel.ISupportInitialize)(this.leftFrontTyre)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightFrontTyre)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightRearTyre)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.leftRearTyre)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.maxTread)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown1)).BeginInit();
            this.SuspendLayout();
            // 
            // leftFrontTyre
            // 
            this.leftFrontTyre.DecimalPlaces = 1;
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
            // 
            // rightFrontTyre
            // 
            this.rightFrontTyre.DecimalPlaces = 1;
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
            // 
            // rightRearTyre
            // 
            this.rightRearTyre.DecimalPlaces = 1;
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
            // 
            // leftRearTyre
            // 
            this.leftRearTyre.DecimalPlaces = 1;
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
            // 
            // maxTread
            // 
            this.maxTread.DecimalPlaces = 1;
            this.maxTread.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.maxTread.Location = new System.Drawing.Point(205, 28);
            this.maxTread.Name = "maxTread";
            this.maxTread.Size = new System.Drawing.Size(75, 26);
            this.maxTread.TabIndex = 4;
            // 
            // textBox1
            // 
            this.textBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.textBox1.Location = new System.Drawing.Point(12, 118);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(156, 26);
            this.textBox1.TabIndex = 5;
            this.textBox1.Text = "100";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 9);
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
            // numericUpDown1
            // 
            this.numericUpDown1.DecimalPlaces = 1;
            this.numericUpDown1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.numericUpDown1.Location = new System.Drawing.Point(205, 60);
            this.numericUpDown1.Name = "numericUpDown1";
            this.numericUpDown1.Size = new System.Drawing.Size(75, 26);
            this.numericUpDown1.TabIndex = 8;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(292, 162);
            this.Controls.Add(this.numericUpDown1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.maxTread);
            this.Controls.Add(this.rightRearTyre);
            this.Controls.Add(this.leftRearTyre);
            this.Controls.Add(this.rightFrontTyre);
            this.Controls.Add(this.leftFrontTyre);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MainForm";
            this.Text = "tyres";
            this.Load += new System.EventHandler(this.MainForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.leftFrontTyre)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightFrontTyre)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightRearTyre)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.leftRearTyre)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.maxTread)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.NumericUpDown leftFrontTyre;
        private System.Windows.Forms.NumericUpDown rightFrontTyre;
        private System.Windows.Forms.NumericUpDown rightRearTyre;
        private System.Windows.Forms.NumericUpDown leftRearTyre;
        private System.Windows.Forms.NumericUpDown maxTread;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.NumericUpDown numericUpDown1;


    }
}

