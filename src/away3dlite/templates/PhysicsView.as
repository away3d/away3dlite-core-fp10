package away3dlite.templates
{
	import away3dlite.materials.WireframeMaterial;
	
	// to be release soon
	import jiglib.plugin.away3dlite.*;
	
	/**
	 * PhysicsView
	 * @author katopz
	 */
	public class PhysicsView extends SimpleView
	{
		protected var physics:Away3DLitePhysics;
		
		override protected function init():void
		{
			super.init();
			physics = new Away3DLitePhysics(renderer, 10);
			physics.createGround(new WireframeMaterial(), 1000, 1000);
		}

		override protected function prerender():void
		{
			physics.step();
		}
	}
}