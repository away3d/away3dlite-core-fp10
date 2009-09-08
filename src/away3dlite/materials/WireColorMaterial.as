package away3dlite.materials
{
	import away3dlite.core.utils.*;
	
	import flash.display.*;

	/**
	 * ColorMaterial
	 * @author katopz
	 */
	public class WireColorMaterial extends ColorMaterial
	{
		private var _wireColor:uint;
		private var _wireAlpha:Number;
		private var _thickness:Number;
		
		/**
		 * 
		 */
		public function get wireColor():uint
		{
			return _wireColor;
		}
		public function set wireColor(val:uint):void
		{
			if (_wireColor == val)
				return;
			
			_wireColor = val;
			
			(_graphicsStroke.fill as GraphicsSolidFill).color = _wireColor;
		}
		
		/**
		 * 
		 */
		public function get wireAlpha():Number
		{
			return _wireAlpha;
		}
		public function set wireAlpha(val:Number):void
		{
			if (_wireAlpha == val)
				return;
			
			_wireAlpha = val;
			
			(_graphicsStroke.fill as GraphicsSolidFill).alpha = _wireAlpha;
		}
		
		/**
		 * 
		 */
		public function get thickness():Number
		{
			return _thickness;
		}
		public function set thickness(val:Number):void
		{
			if (_thickness == val)
				return;
			
			_thickness = val;
			
			_graphicsStroke.thickness = _thickness;
		}
		
		/**
		 * 
		 */
		public function WireColorMaterial(color:* = null, alpha:Number = 1, wireColor:* = null, wireAlpha:Number = 1, thickness:Number = 1)
		{
			super(color, alpha);
			
			_wireColor = Cast.color(wireColor || 0x000000);
			_wireAlpha = wireAlpha;
			
			_thickness = thickness;
			
			_graphicsStroke.fill = new GraphicsSolidFill(_wireColor, _wireAlpha);
			_graphicsStroke.thickness = _thickness;
		}
	}
}