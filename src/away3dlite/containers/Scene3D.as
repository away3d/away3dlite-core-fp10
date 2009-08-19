package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	
	use namespace arcane;
	
    /**
    * The root container of all 3d objects in a single scene
    */
	public class Scene3D extends ObjectContainer3D
	{
		arcane var _dirtyFaces:Boolean = true;
    	
		/**
		 * Creates a new <code>Scene3D</code> object
		 */
		public function Scene3D()
		{
			super();
			
			_scene = this;
		}
	}
}
