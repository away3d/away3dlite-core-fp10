package away3dlite.lights
{
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	
	use namespace arcane;
	
	/**
	 * @author robbateman
	 */
	public class AbstractLight3D
	{
		private var _color:uint;
		/** @private */
		arcane var _red:Number;
		/** @private */
		arcane var _green:Number;
		/** @private */
		arcane var _blue:Number;
		/** @private */
		arcane var _camera:Camera3D;
		
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
			
			_red = ((_color & 0xFF0000) >> 16)/255;
            _green = ((_color & 0xFF00) >> 8)/255;
            _blue  = (_color & 0xFF)/255;
		}
		
		/**
		 * 
		 */
		public function AbstractLight3D()
		{
			
		}
	}
}
