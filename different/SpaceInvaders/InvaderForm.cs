using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

/**
 * <?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
    "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1"
     baseProfile="full"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:ev="http://www.w3.org/2001/xml-events"
     width="100%" height="100%">
<rect fill="white" x="0" y="0" width="100%" height="100%" />
<rect fill="silver" x="0" y="0" width="100%" height="100%" rx="1em"/>
</svg>
 */

namespace WindowsFormsApplication1
{
	public partial class InvaderForm : Form
	{
		public InvaderForm()
		{
			InitializeComponent();
		}

		private void DrawSquare(Graphics g, int x, int y, float squarePadding)
		{
			const float padding = 50.0f;
			const float squareWidth = 50.0f;
			g.FillRectangle(Brushes.White, padding + squareWidth * x + squarePadding / 2.0f, padding + squareWidth * y + squarePadding / 2.0f, squareWidth - squarePadding, squareWidth - squarePadding);
		}

		private bool noPadding = false;
		private float squarePadding = 6.0f;
		private int[,] grid = new int[,]{
				{ 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0 },
				{ 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 },
				{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
				{ 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0 },
				{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
				{ 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1 },
				{ 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1 },
				{ 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0 },
			};

		private void Form1_Paint(object sender, PaintEventArgs e)
		{
			Graphics g = Graphics.FromHwnd(this.Handle);
			g.Clear(Color.Black);

			for (int x = 0; x < 11; x++)
				for (int y = 0; y < 8; y++)
					if (grid[y, x] != 0)
						DrawSquare(g, x, y, noPadding ? 0.0f : squarePadding);
		}

		private void Form1_KeyDown(object sender, KeyEventArgs e)
		{
			noPadding = !noPadding;
			this.Invalidate();
		}

		private void trackBar1_ValueChanged(object sender, EventArgs e)
		{
			this.squarePadding = this.trackBar1.Value;
			this.Invalidate();
		}

		private void saveButton_Click(object sender, EventArgs e)
		{
			const float padding = 50.0f;
			const float squareWidth = 50.0f;

			TextWriter svg = new StreamWriter("D:\\invaders.svg");
			svg.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>");
			svg.WriteLine("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">");
			svg.WriteLine("<svg version=\"1.1\" baseProfile=\"full\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:ev=\"http://www.w3.org/2001/xml-events\" width=\"100%\" height=\"100%\">");
			svg.WriteLine(("<rect fill=\"black\" x=\"0\" y=\"0\" width=\"" + this.Width.ToString() + "\" height=\"" + this.Height.ToString() + "\" />").Replace(',', '.'));
			for (int x = 0; x < 11; x++)
			{
				for (int y = 0; y < 8; y++)
				{
					if (grid[y, x] != 0)
					{
						float left = (padding + squareWidth * x + squarePadding / 2.0f);
						float top = (padding + squareWidth * y + squarePadding / 2.0f);
						float width = (squareWidth - squarePadding);
						float height = (squareWidth - squarePadding);

						string ss = "<rect fill=\"white\" x=\"" + left.ToString() + "\" y=\"" + top.ToString() + "\" width=\"" + width.ToString() + "\" height=\"" + height.ToString() + "\" />";
						svg.WriteLine(ss.Replace(',', '.'));
					}
				}
			}
			svg.WriteLine("</svg>");
			svg.Close();
		}
	}
}
