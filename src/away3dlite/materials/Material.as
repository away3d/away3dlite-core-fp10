package away3dlite.materials
{
	import flash.display.*;
	
	/**
	 * Material
	 * @author katopz
	 */	
	public class Material
	{
		private const DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF00FF));
		private var _debug:Boolean = false;
		
		protected var _graphicsStroke:GraphicsStroke = new GraphicsStroke();
		
		protected var _graphicsBitmapFill:GraphicsBitmapFill = new GraphicsBitmapFill();
		
		protected var _graphicsEndFill:GraphicsEndFill = new GraphicsEndFill();
		
		/**
		 * 
		 */
		protected var _triangles:GraphicsTrianglePath;
		
		/**
		 * 
		 */
		public var graphicsData:Vector.<IGraphicsData>;
		
		/**
		 * 
		 */
		public var trianglesIndex:int;
		
		/**
		 * 
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		public function set debug(val:Boolean):void
		{
			if (_debug == val)
				return;
				
			_debug = val;
			
			graphicsData.fixed = false;
			
			if(_debug) {
				graphicsData.shift();
				graphicsData.unshift(DEBUG_STROKE);
			} else {
				graphicsData.shift();
				graphicsData.unshift(_graphicsStroke);
			}
			
			graphicsData.fixed = true;
		}
		
		/**
		 * 
		 */
		public function Material() 
		{
			graphicsData = new Vector.<IGraphicsData>();
		}
	}
}