package away3dlite.cameras.lenses
{
	import away3dlite.arcane;
	
	import flash.geom.*;
	
	use namespace arcane;
	
	public class ZoomFocusLens extends AbstractLens
	{
		/** @private */
		override arcane function _update():void
		{
			_view = _camera._view;
			_root = _view.root;
			_projection = _root.transform.perspectiveProjection;
			
			_projection.focalLength = _camera.zoom*_camera.focus;
			
			_projectionMatrix3D = _projection.toMatrix3D();
			_projectionMatrix3D.appendTranslation(0, 0, _camera.focus);
			
			_projectionData = _projectionMatrix3D.rawData;
			_projectionData[15] = _projectionData[14];
			_projectionMatrix3D.rawData = _projectionData;
		}
		
		private var _projection:PerspectiveProjection;
		private var _projectionData:Vector.<Number>;
		
		public function ZoomFocusLens()
		{
			super();
		}
	}
}