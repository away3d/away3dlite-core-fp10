package away3dlite.templates
{
	import away3dlite.core.render.*;
	
	/**
	 * Fast Template
	 * @author katopz
	 */
	public class FastTemplate extends Template
	{
		protected override function init():void
		{
			super.init();
			
			view.renderer = renderer;
		}
		
		public var renderer:FastRenderer = new FastRenderer();
	}
}