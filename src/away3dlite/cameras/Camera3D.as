package away3dlite.cameras
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * Basic camera used to resolve a view.
	 * 
	 * @see	away3d.containers.View3D
	 */
	public class Camera3D extends Object3D
	{
		/** @private */
		arcane var view:View3D;
		
		private var _focus:Number = 100;
		private var _zoom:Number = 10;
		private var _projection:PerspectiveProjection = new PerspectiveProjection();
		private var _viewMatrix3D:Matrix3D = new Matrix3D();
		
		protected const toRADIANS:Number = Math.PI/180;
		protected const toDEGREES:Number = 180/Math.PI;
		
		private var _fieldOfViewDirty:Boolean = true;
		
		public function get projection():PerspectiveProjection
		{
			return _projection;
		}
		
		/**
		 * A divisor value for the perspective depth of the view.
		 */
		public function get focus():Number
		{
			return _focus;
		}
		public function set focus(val:Number):void
		{
			_focus = val;
			_fieldOfViewDirty = true;
		}
		
		/**
		 * Provides an overall scale value to the view
		 */
		public function get zoom():Number
		{
			return _zoom;
		}
		
		public function set zoom(val:Number):void
		{
			_zoom = val;
			_fieldOfViewDirty = true;
		}
		public function get viewMatrix3D():Matrix3D
		{
			return _viewMatrix3D;
		}
    	
		public function unproject(mX:Number, mY:Number):Vector3D
		{	
			var persp:Number = (_focus*_zoom) / _focus;
			var vector:Vector3D = new Vector3D(mX/persp, -mY/persp, _focus);
			return transform.matrix3D.transformVector(vector);
		}
		
		/**
		 * Creates a new <code>Camera3D</code> object.
		 */
		public function Camera3D()
		{
			super();
			
			transform.matrix3D = new Matrix3D();
		}
    	
		/**
		 * Updates the transformation matrix used to resolve the scene to the view.
		 */
		public function update():void
		{
			_projection = root.transform.perspectiveProjection;
			
			if(_fieldOfViewDirty)
			{
				_projection.fieldOfView = 360*Math.atan2(stage.stageWidth, 2*_zoom*_focus)/Math.PI;
				_fieldOfViewDirty = false;
			}
			
			_viewMatrix3D = transform.matrix3D.clone();
			_viewMatrix3D.prependTranslation(0, 0, -_focus);
			_viewMatrix3D.invert();
			_viewMatrix3D.append(_projection.toMatrix3D());
			
			updateDirty(_viewMatrix3D);
		}
	}
}
