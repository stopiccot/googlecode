﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace libdrag
{
	public class DraggablePoint
	{
		// owner form and owner draggable point group
		internal DragForm ownerForm = null;
		internal DraggablePointGroup ownerGroup = null;

		// Point position
		private PointF position;

		// is point being dragged?
		private bool drag = false;

		// is point active/selected?
		public bool active = false;

		// Radius of DraggablePoint
		private const float PointRadius = 7.0f;
		private float PointRadiusCoeff = 1.0f;

		public object userData = null;
				
		// Constructors
		public DraggablePoint(PointF position)
		{
			this.position  = position;
		}

		public DraggablePoint(PointF position, object userData)
		{
			this.position  = position;
			this.userData  = userData;
		}

		// Checks if cursor is over DraggablePoint
		private bool mouseHit(int x, int y)
		{
			PointF posFS = this.ownerForm.TransformToFormSpace(this.position);

			double distance = Math.Sqrt(Math.Pow(x - posFS.X, 2.0) + Math.Pow(y - posFS.Y, 2.0));
			return distance < PointRadiusCoeff * PointRadius;
		}

		internal void Paint(PaintEventArgs e)
		{
			float R = PointRadiusCoeff * PointRadius;
			PointF posFS = this.ownerForm.TransformToFormSpace(this.position);

			// Draw point
			RectangleF rect = new RectangleF(posFS.X - R, posFS.Y - R, 2 * R, 2 * R);
			Color brushColor = this.active ? this.ownerGroup.ActiveColor : this.ownerGroup.Color;
			Color penColor = this.active ? this.ownerGroup.ActiveBorderColor : this.ownerGroup.BorderColor;
			e.Graphics.FillEllipse(new SolidBrush(brushColor), rect);
			e.Graphics.DrawArc(new Pen(penColor, 2.0f), rect, 0.0f, 360.0f);
		}

		public bool MouseDown(MouseEventArgs e)
		{
			if (mouseHit(e.X, e.Y))
			{
				drag = true;
				return true;
			}

			return false;
		}

		internal void Snap()
		{
			if (!this.ownerForm.FieldSettings.SnapToGrid) 
				return;

			// Snaps are made in World Space
			float gridSize = this.ownerForm.FieldSettings.GridSize;
			this.position.X = gridSize * (float)Math.Round(this.position.X / gridSize);
			this.position.Y = gridSize * (float)Math.Round(this.position.Y / gridSize);
		}

		public bool MouseMove(MouseEventArgs e)
		{
			if (drag)
			{
				this.PositionFS = new PointF(e.X, e.Y);
				Snap();
			}

			if (drag || mouseHit(e.X, e.Y))
			{
				this.PointRadiusCoeff = 1.2f;
				return true;
			}

			this.PointRadiusCoeff = 1.0f;
			return false;
		}

		public void MouseUp(MouseEventArgs e)
		{
			drag = false;
		}

		public PointF PositionFS
		{
			get
			{
				return this.ownerForm.TransformToFormSpace(this.position);
			}
			set
			{
				this.position = this.ownerForm.TransformToWorldSpace(value);
			}
		}

		public PointF PositionWS
		{
			get
			{
				return this.position;
			}
			set
			{
				this.position = value;
			}
		}
	}
}
