package away3dlite.core.base
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.loaders.utils.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	use namespace arcane;
    
	/**
	 * Dispatched when a user moves the cursor while it is over the 3d object.
	 * 
	 * @eventType away3d.events.MouseEvent3D
	 */
	[Event(name="mouseMove",type="away3dlite.events.MouseEvent3D")]
    
	/**
	 * Dispatched when a user presses the left hand mouse button while the cursor is over the 3d object.
	 * 
	 * @eventType away3dlite.events.MouseEvent3D
	 */
	[Event(name="mouseDown",type="away3dlite.events.MouseEvent3D")]
    
	/**
	 * Dispatched when a user releases the left hand mouse button while the cursor is over the 3d object.
	 * 
	 * @eventType away3dlite.events.MouseEvent3D
	 */
	[Event(name="mouseUp",type="away3dlite.events.MouseEvent3D")]
    
	/**
	 * Dispatched when a user moves the cursor over the 3d object.
	 * 
	 * @eventType away3dlite.events.MouseEvent3D
	 */
	[Event(name="mouseOver",type="away3dlite.events.MouseEvent3D")]
    
	/**
	 * Dispatched when a user moves the cursor away from the 3d object.
	 * 
	 * @eventType away3dlite.events.MouseEvent3D
	 */
	[Event(name="mouseOut",type="away3dlite.events.MouseEvent3D")]
	
	/**
	 * Dispatched when a user rolls over the 3d object.
	 * 
	 * @eventType away3dlite.events.MouseEvent3D
	 */
	[Event(name="rollOver",type="away3dlite.events.MouseEvent3D")]
    
	/**
	 * Dispatched when a user rolls out of the 3d object.
	 * 
	 * @eventType away3dlite.events.MouseEvent3D
	 */
	[Event(name="rollOut",type="away3dlite.events.MouseEvent3D")]
	
	/**
	 * @author robbateman
	 */
	public class Object3D extends Sprite
	{
		arcane var _screenZ:Number = 0;
		arcane var _scene:Scene3D;
		arcane var _viewTransform:Matrix3D;
		arcane var _sceneTransform:Matrix3D;
		arcane var _mouseEnabled:Boolean;
		
		arcane function updateScene(val:Scene3D):void
		{
		}
		
		// Layer
		public var layer:Sprite;
		
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
		public var animationLibrary:AnimationLibrary = new AnimationLibrary();
		
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
		
		public function get viewTransform():Matrix3D
		{
			return _viewTransform;
		}
		
		public function get sceneTransform():Matrix3D
		{
			return _sceneTransform;
		}
		
		public function get position():Vector3D
		{
			return transform.matrix3D.position;
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
        
        public function project(viewMatrix3D:Matrix3D, parentMatrix3D:Matrix3D = null):void
		{
			
			_sceneTransform = transform.matrix3D.clone();
			
			if (parentMatrix3D)
				_sceneTransform.append(parentMatrix3D);
				
			_viewTransform = _sceneTransform.clone();
			_viewTransform.append(viewMatrix3D);
			
			_screenZ = _viewTransform.position.z;
		}
		
		/**
		 * Duplicates the 3d object's properties to another <code>Object3D</code> object
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied
		 * @return						The new object instance with duplicated properties applied
		 */
		 public function clone(object:Object3D = null):Object3D
		 {
            var object3D:Object3D = object || new Object3D();
            
            object3D.transform.matrix3D = transform.matrix3D.clone();
            object3D.name = name;
            object3D.filters = filters.concat();
            object3D.blendMode = blendMode;
            object3D.alpha = alpha;
            object3D.visible = visible;
            object3D.mouseEnabled = mouseEnabled;
            object3D.useHandCursor = useHandCursor;
            
            return object3D;
        }
	}
}
