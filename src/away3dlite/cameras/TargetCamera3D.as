package away3dlite.cameras
{
	import flash.geom.Matrix3D;
    import away3dlite.core.base.*;
	
	
    /**
    * Extended camera used to automatically look at a specified target object.
    * 
    * @see away3dlite.containers.View3D
    */
    public class TargetCamera3D extends Camera3D
    {
        /**
        * The 3d object targeted by the camera.
        */
        public var target:Object3D;
    	
	    /**
	    * Creates a new <code>TargetCamera3D</code> object.
	    * 
	    * @param	init	[optional]	An initialisation object for specifying default instance properties.
	    */
        public function TargetCamera3D()
        {
            super();
            
            target = new Object3D();
            target.transform.matrix3D = new Matrix3D();
        }
        
		/**
		 * @inheritDoc
		 */
        public override function update():void
		{
            if (target != null)
                lookAt(target.transform.matrix3D.position);
            
			super.update();
        }
    }

}   
