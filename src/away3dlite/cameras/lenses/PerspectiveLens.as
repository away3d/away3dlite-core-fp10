package away3dlite.cameras.lenses
{
	import away3dlite.arcane;
	
	import flash.geom.*;
	
	use namespace arcane;
	
	public class PerspectiveLens extends AbstractLens
	{
		/** @private */
		override arcane function _update():void
		{
			_view = _camera._view;
			_root = _view.root;
			_projection = _root.transform.perspectiveProjection;
			
			_projection.focalLength = _camera.zoom*_camera.focus;
			
			_projectionMatrix3D = _projection.toMatrix3D();
		}
		
		private var _projection:PerspectiveProjection;
		
		public function PerspectiveLens()
		{
			super();
		}
		
		public override function unProject(x:Number, y:Number, z:Number):Vector3D
		{
			var persp:Number = z/(_camera.zoom*_camera.focus);
			return new Vector3D(x*persp, y*persp, z);
		}
	}
}