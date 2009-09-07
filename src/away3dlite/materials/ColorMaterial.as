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
			
			_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, _alpha < 1, int(_alpha*0xFF) << 24 | _color);
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
			
			_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, _alpha < 1, int(_alpha*0xFF) << 24 | _color);
		}
		
		/**
		 * 
		 */
		public function ColorMaterial(color:int = 0xFFFFFF, alpha:Number = 1)
		{
			super();
			
			_color = color;
			_alpha = alpha?alpha:1;
			
			_graphicsBitmapFill = new GraphicsBitmapFill(new BitmapData(2, 2, _alpha < 1, int(_alpha*0xFF) << 24 | _color));
			
			graphicsData = Vector.<IGraphicsData>([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsEndFill]);
			graphicsData.fixed = true;
			
			trianglesIndex = 2;
		}
	}
}