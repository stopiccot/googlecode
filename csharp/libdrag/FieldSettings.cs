using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace libdrag
{
	public class FieldSettings
	{
		// Owner form for calling Invalidate()
		private DragForm owner = null;

		public PointF Origin { get; set; }
		public bool PointCanBeSelected { get; set; }

		// Render settings
		public float Scale { get; set; }
		public float MinScale { get; set; }
		public float MaxScale { get; set; }

		// Grid settings
		public bool SnapToGrid { get; set; }
		public float GridSize { get; set; }

		// Fill default values in costructor
		public FieldSettings(DragForm owner)
		{
			this.owner = owner;
			this.Origin = new PointF(0.0f, 0.0f);
			this.Scale = 100.0f;
			this.MaxScale = 2000.0f;
			this.MinScale = 1.0f;
			this.SnapToGrid = false;
			this.GridSize = 0.0f;
			this.PointCanBeSelected = false;
		}
	}
}
