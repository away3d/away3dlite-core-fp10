package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;

	use namespace arcane;
	
	/**
	 * Template setup designed for general use.
	 */
	public class BasicTemplate extends Template
	{
		/**
		 * @inheritDoc
		 */
		arcane override function init():void
		{
			super.init();
			
			view.renderer = new BasicRenderer();
			view.clipping = new RectangleClipping();
		}
	}
}