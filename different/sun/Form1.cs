using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace sun
{
	public partial class Form1 : Form
	{
		List<Binding> bindings = new List<Binding>();
		
		public Form1()
		{
			InitializeComponent();

			bindings.Add(new Binding("outerR", outerRLabel, outerRTrackBar, 10.0f, 100.0f, 200.0f));
			bindings.Add(new Binding("innerR", innerRLabel, innerRTrackBar, 10.0f,  75.0f, 200.0f));
			bindings.Add(new Binding("rayR", rayRLabel, rayRTrackBar, 1.0f, 12.0f, 100.0f));
			bindings.Add(new Binding("rayCount", rayCountLabel, rayCountTrackBar, 1.0f, 12.0f, 100.0f));
			
			bindings.Add(new Binding("eyeR", eyeRLabel, eyeRTrackBar, 1.0f, 22.0f, 100.0f));
			bindings.Add(new Binding("eyeAngle", eyeAngleLabel, eyeAngleTrackBar, 1.0f, 65.0f, 190.0f));
			bindings.Add(new Binding("eyeX", eyeXLabel, eyeXTrackBar, 0.0f, 35.0f, 200.0f));
			bindings.Add(new Binding("eyeY", eyeYLabel, eyeYTrackBar, 0.0f, 20.0f, 200.0f));

			bindings.Add(new Binding("mouthX", mouthXLabel, mouthXTrackBar, 0.0f, 0.0f, 200.0f));
			bindings.Add(new Binding("mouthY", mouthYLabel, mouthYTrackBar, 0.0f, 5.0f, 200.0f));
			bindings.Add(new Binding("mouthRX", mouthRXLabel, mouthRXTrackBar, 1.0f, 60.0f, 200.0f));
			bindings.Add(new Binding("mouthRY", mouthRYLabel, mouthRYTrackBar, 1.0f, 55.0f, 200.0f));
			bindings.Add(new Binding("mouthAngle", mouthAngleLabel, mouthAngleTrackBar, 0.0f, 80.0f, 180.0f));

			bindings.Add(new Binding("thickness", thicknessLabel, thicknessTrackBar, 1.0f, 3.0f, 20.0f));

			panel1.BackColor = color1;
			panel2.BackColor = color2;
		}

		private double shift = 0.0f;
		private Color color1 = Color.Orange;
		private Color color2 = Color.Yellow;
		private Color color3 = Color.FromArgb(255, 252, 175);

		private void DrawSun(Graphics g, float centerX, float centerY, float cf, double delta)
		{
			g.Clear(Color.White);

			int N = 10;
			
			double angle = 0.0;

			double RR = 10000.0f;
			double dd = 2 * Math.PI / 30.0f;

			while (angle <= 2 * Math.PI)
			{
				double x1 = centerX + RR * Math.Cos(angle);
				double y1 = centerY + RR * Math.Sin(angle);

				angle += dd;

				double x2 = centerX + RR * Math.Cos(angle);
				double y2 = centerY + RR * Math.Sin(angle);

				PointF[] points = new PointF[] { new PointF(centerX, centerY), new PointF((float)x1, (float)y1), new PointF((float)x2, (float)y2) };
				g.FillPolygon(new SolidBrush(color2), points);

				angle += dd;
			}

			
			//float cf = 1.0f;
			Pen p = new Pen(Color.Black, cf * Binding.values["thickness"]);

			angle = 0.0;
			//const double delta = 3 * 2 * Math.PI / 360;

			//float centerX = this.ClientSize.Width / 2.0f - 100.0f;
			//float centerY = this.ClientSize.Height / 2.0f;
			double R = 100.0;

			float outerR = cf * Binding.values["outerR"];
			float innerR = cf * Binding.values["innerR"];
			float rayR = cf * Binding.values["rayR"];
			float rayCount = (int)Binding.values["rayCount"];
			float eyeR = cf * Binding.values["eyeR"];
			float eyeAngle = Binding.values["eyeAngle"];
			float eyeX = cf * Binding.values["eyeX"];
			float eyeY = cf * Binding.values["eyeY"];
			float mouthX = cf * Binding.values["mouthX"];
			float mouthY = cf * Binding.values["mouthY"];
			float mouthRX = cf * Binding.values["mouthRX"];
			float mouthRY = cf * Binding.values["mouthRY"];
			float mouthAngle = Binding.values["mouthAngle"];

			while (angle <= 2 * Math.PI)
			{
				R = outerR + rayR * Math.Sin(rayCount * (angle + shift));
				double x1 = centerX + R * Math.Cos(angle);
				double y1 = centerY + R * Math.Sin(angle);

				angle += delta;

				R = outerR + rayR * Math.Sin(rayCount * (angle + shift));
				double x2 = centerX + R * Math.Cos(angle);
				double y2 = centerY + R * Math.Sin(angle);

				PointF[] points = new PointF[] { new PointF(centerX, centerY), new PointF((float)x1, (float)y1), new PointF((float)x2, (float)y2) };
				g.FillPolygon(new SolidBrush(color1), points);
			}
			g.FillEllipse(new SolidBrush(Color.Yellow), new RectangleF(centerX - innerR, centerY - innerR, 2 * innerR, 2 * innerR));

			g.DrawArc(p,
				new RectangleF(
					centerX - eyeX - eyeR,
					centerY - eyeY - eyeR,
					2 * eyeR, 2 * eyeR
					),
				270.0f - eyeAngle,
				2 * eyeAngle
				);

			g.DrawArc(p,
				new RectangleF(
					centerX + eyeX - eyeR,
					centerY - eyeY - eyeR,
					2 * eyeR, 2 * eyeR
					),
				270.0f - eyeAngle,
				2 * eyeAngle
				);

			g.DrawArc(p,
				new RectangleF(centerX - mouthX - mouthRX, centerY - mouthY - mouthRY, 2 * mouthRX, 2 * mouthRY),
				90.0f - mouthAngle,
				2 * mouthAngle
				);
			 
		}

		private void Form1_Paint(object sender, PaintEventArgs e)
		{
			e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

			DrawSun(e.Graphics, this.ClientSize.Width / 2.0f - 100.0f, this.ClientSize.Height / 2.0f, 1.0f,
				3 * 2 * Math.PI / 360);
		}

		private void Form1_Load(object sender, EventArgs e)
		{

		}

		private void timer1_Tick(object sender, EventArgs e)
		{
			shift += 0.02;
			this.Invalidate();
		}

		private void panel1_Click(object sender, EventArgs e)
		{
			colorDialog.Color = color1;
			if (colorDialog.ShowDialog() == DialogResult.OK)
			{
				color1 = colorDialog.Color;
				panel1.BackColor = color1;
			}
		}

		private void panel2_Click(object sender, EventArgs e)
		{
			colorDialog.Color = color2;
			if (colorDialog.ShowDialog() == DialogResult.OK)
			{
				color2 = colorDialog.Color;
				panel2.BackColor = color2;
			}
		}

		private void button1_Click(object sender, EventArgs e)
		{
			if (saveFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
			{
				int size = 10000;
				Bitmap bmp = new Bitmap(size, size);
				DrawSun(Graphics.FromImage(bmp), size / 2, size / 2, 40.0f, 0.5 * 2 * Math.PI / 360);
				bmp.Save(saveFileDialog.FileName);
			}
		}
	}
}
