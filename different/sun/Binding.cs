using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace sun
{
	public class Binding
	{
		public string name;
		public Label label;
		public TrackBar trackBar;
		public float min;
		public float value;
		public float max;

		public static Dictionary<string, float> values = new Dictionary<string, float>();

		public Binding(string name, Label label, TrackBar trackBar, float min, float defaultValue, float max)
		{
			this.name = name;
			this.label = label;
			this.trackBar = trackBar;
			this.min = min;
			this.value = defaultValue;
			this.max = max;

			this.trackBar.Minimum = 0;
			this.trackBar.Maximum = 100;
			this.trackBar.Value = (int)(100.0f * (this.value - this.min) / (this.max - this.min));
			this.trackBar.Scroll += new System.EventHandler(this.onScroll);

			update();
		}

		private void update()
		{
			this.label.Text = this.name + ": " + this.value.ToString();
			Binding.values[this.name] = this.value;
		}

		private void onScroll(object sender, EventArgs e)
		{
			this.value = this.min + (this.max - this.min) * this.trackBar.Value / 100.0f;
			update();
		}
	}
}
