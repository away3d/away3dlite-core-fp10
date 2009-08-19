package away3dlite.materials
{
	import flash.display.*;

	/**
	 * WireframeMaterial
	 * @author katopz
	 */
	public class WireframeMaterial extends Material
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
			
			_graphicsStroke.fill = new GraphicsSolidFill(_color);
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
		public function WireframeMaterial(color:uint = 0xFFFFFF, alpha:Number = 1)
		{
			_color = color;
			_alpha = alpha;
			
			_graphicsStroke.fill = new GraphicsSolidFill(_color);
			_graphicsStroke.thickness = 1;
			
			graphicsData = Vector.<IGraphicsData>([_graphicsStroke, _triangles]);
			graphicsData.fixed = true;
			
			trianglesIndex = 1;
		}
	}
}