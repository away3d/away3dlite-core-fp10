package away3dlite.core.base
{
	import away3dlite.containers.*;
	import away3dlite.arcane;
	import away3dlite.loaders.utils.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * @author robbateman
	 */
	public class Object3D extends Sprite
	{
		arcane var _screenZ:Number = 0;
		arcane var _scene:Scene3D;
		arcane var _viewTransform:Matrix3D;
		arcane function updateScene(val:Scene3D):void
		{
		}
		
		/**
		 * 
		 */
		public var materialLibrary:MaterialLibrary = new MaterialLibrary();
		
		/**
		 * 
		 */
		public var geometryLibrary:GeometryLibrary = new GeometryLibrary();
		
		/**
		 * 
		 */
		public var type:String;
		
		/**
		 * 
		 */
		public var url:String;
		
		/**
		 * 
		 */
		public function get scene():Scene3D
		{
			return _scene;
		}
		
		/**
		 * 
		 */
		public function get screenZ():Number
		{
			return _screenZ;
		}
		
		/**
		 * 
		 */
		public function Object3D()
		{
			super();
		}
		
				
		/**
		 * Rotates the 3d object around to face a point defined relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 * 
		 * @param	target		The vector defining the point to be looked at
		 * @param	upAxis		An optional vector used to define the desired up orientation of the 3d object after rotation has occurred
		 */
        public function lookAt(target:Vector3D, upAxis:Vector3D = null):void
        {
        	transform.matrix3D.pointAt(target, Vector3D.Z_AXIS, upAxis || new Vector3D(0,-1,0));
        }
        
        public function project(parentMatrix3D:Matrix3D):void
		{
			_viewTransform = transform.matrix3D.clone();
			_viewTransform.append(parentMatrix3D);
			
			_screenZ = _viewTransform.position.z;
		}
	}
}
