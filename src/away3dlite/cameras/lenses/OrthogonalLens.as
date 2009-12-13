package away3dlite.cameras.lenses
{
	import away3dlite.arcane;
	use namespace arcane;
	
	public class OrthogonalLens extends AbstractLens
	{
		/** @private */
		override arcane function _update():void
		{
			_view = _camera._view;
			_scale = _camera.zoom / _camera.focus;			
			_projectionMatrix3D.identity();
			_projectionMatrix3D.appendScale(_scale, _scale, 1);
		}
		
		private var _scale:Number;
		
		public function OrthogonalLens()
		{
			super();
		}
	}
}