using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace libdrag
{
	public class DraggablePointGroup
	{
		private DragForm ownerForm = null;

		private List<DraggablePoint> dpoints = new List<DraggablePoint>();
		public IList<DraggablePoint> Points
		{
			get
			{
				return this.dpoints.AsReadOnly();
			}
		}

		public bool Visible { get; set; }
		public string Name { get; set; }

		// Colors to draw draggable points of this group
		public Color Color { get; set; }
		public Color BorderColor { get; set; }

		// Colors to draw draggable points of this group that are currently active
		public Color ActiveColor { get; set; }
		public Color ActiveBorderColor { get; set; }

		internal DraggablePointGroup(string name, DragForm ownerForm)
		{
			this.ownerForm = ownerForm;
			this.Name = name;
			this.Visible = true;
			this.Color = Color.FromArgb(0xBB, 0xBB, 0xBB);
			this.ActiveColor = Color.FromArgb(0xF0, 0xF0, 0xF0);
			this.BorderColor = Color.FromArgb(0x77, 0x77, 0x77);
			this.ActiveBorderColor = Color.FromArgb(0x77, 0x77, 0x77);
		}

		public DraggablePoint AddDraggablePointWS(PointF point)
		{
			return this.AddDraggablePointWS(point, null);
		}

		public DraggablePoint AddDraggablePointWS(PointF point, object userData)
		{
			DraggablePoint dpoint = new DraggablePoint(point, userData);
			dpoint.ownerGroup = this;
			dpoint.ownerForm = this.ownerForm;
			dpoint.Snap();
			this.dpoints.Add(dpoint);
			return dpoint;
		}

		public DraggablePoint AddDraggablePointWS(float x, float y)
		{
			return this.AddDraggablePointWS(x, y, null);
		}

		public DraggablePoint AddDraggablePointWS(float x, float y, object userData)
		{
			return this.AddDraggablePointWS(new PointF(x, y), userData);
		}

		public DraggablePoint AddDraggablePointFS(PointF point)
		{
			return this.AddDraggablePointFS(point, null);
		}

		public DraggablePoint AddDraggablePointFS(PointF point, object userData)
		{
			return this.AddDraggablePointWS(ownerForm.TransformToWorldSpace(point), userData);
		}

		public DraggablePoint AddDraggablePointFS(float x, float y)
		{
			return this.AddDraggablePointFS(x, y, null);
		}

		public DraggablePoint AddDraggablePointFS(float x, float y, object userData)
		{
			return this.AddDraggablePointFS(new PointF(x, y), userData);
		}

		public void Paint(PaintEventArgs e)
		{
			if (this.Visible)
			{
				foreach (DraggablePoint point in this.dpoints)
				{
					point.Paint(e);
				}
			}
		}
	}
}
