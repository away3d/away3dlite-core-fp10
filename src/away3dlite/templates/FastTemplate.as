package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;

	use namespace arcane;
	
	/**
	 * Template setup designed for speed.
	 */
	public class FastTemplate extends Template
	{
		/**
		 * @inheritDoc
		 */
		arcane override function init():void
		{
			super.init();
			
			view.renderer = new FastRenderer();
			view.clipping = new Clipping();
			view.mouseEnabled = false;
		}
	}
}