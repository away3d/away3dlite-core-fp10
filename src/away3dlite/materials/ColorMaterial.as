package away3dlite.materials
{
	import flash.display.*;
	import flash.geom.*;

	/**
	 * ColorMaterial
	 * @author katopz
	 */
	public class ColorMaterial extends Material
	{
		private var _color:uint;
		private var _alpha:Number;
		
		/**
		 * 
		 */
		public function get color():uint
		{
			return _color;
		}
		public function set color(val:uint):void
		{
			if (_color == val)
				return;
			
			_color = val;
			
			_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, false, val);
		}
		
		/**
		 * 
		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		public function set alpha(val:Number):void
		{
			if (_alpha == val)
				return;
			
			_alpha = val;
		}
		
		/**
		 * 
		 */
		public function ColorMaterial(color:uint = 0xFFFFFF, alpha:Number = 1)
		{
			_color = color;
			_alpha = alpha;
			
			//_stroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(_color, _alpha));
			_graphicsBitmapFill = new GraphicsBitmapFill(new BitmapData(2, 2, (_alpha<1), _color), new Matrix(), true, true);
			
			graphicsData = Vector.<IGraphicsData>([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsBitmapFill]);
			graphicsData.fixed = true;
			
			trianglesIndex = 2;
		}
	}
}