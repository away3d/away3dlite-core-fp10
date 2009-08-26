package away3dlite.materials
{
	import flash.display.*;

	/**
	 * BitmapMaterial : embed image as texture
	 * @author katopz
	 */
	public class BitmapMaterial extends Material
	{
		public function BitmapMaterial(bitmapData:BitmapData = null)
		{
			_graphicsBitmapFill.bitmapData = bitmapData || new BitmapData(100, 100, false, 0x000000);
			
			graphicsData = Vector.<IGraphicsData>([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsEndFill]);
			graphicsData.fixed = true;
			
			trianglesIndex = 2;
		}
		
		public function get bitmap():BitmapData
		{
			return _graphicsBitmapFill.bitmapData;
		}
		public function set bitmap(val:BitmapData):void
		{
			_graphicsBitmapFill.bitmapData = val;
		}
		
		public function get repeat():Boolean
		{
			return _graphicsBitmapFill.repeat;
		}
		public function set repeat(val:Boolean):void
		{
			_graphicsBitmapFill.repeat = val;
		}
		
		public function get smooth():Boolean
		{
			return _graphicsBitmapFill.smooth;
		}
		public function set smooth(val:Boolean):void
		{
			_graphicsBitmapFill.smooth = val;
		}
		
		public function get width():int
		{
			return _graphicsBitmapFill.bitmapData.width;
		}
		
		public function get height():int
		{
			return _graphicsBitmapFill.bitmapData.height;
		}
	}
}