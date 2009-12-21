package away3dlite.cameras.lenses
{
	import away3dlite.arcane;
	
	import flash.geom.*;
	
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
		
		public override function unProject(x:Number, y:Number, z:Number):Vector3D
		{
			var scale:Number = _camera.focus/_camera.zoom;
			return new Vector3D(x*scale, y*scale, z*scale);
		}
	}
}