package away3dlite.templates
{
	import away3dlite.core.clip.RectangleClipping;
	import away3dlite.core.render.*;
	
	/**
	 * SimpleView
	 * @author katopz
	 */
	public class BasicTemplate extends Template
	{
		protected override function init():void
		{
			super.init();
			
			view.renderer = renderer;
			view.clipping = clipping;
		}
		
		public var renderer:BasicRenderer = new BasicRenderer();
		
		public var clipping:RectangleClipping = new RectangleClipping();
	}
}