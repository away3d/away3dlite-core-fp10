package away3dlite.cameras.lenses
{
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	import away3dlite.containers.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	use namespace arcane;
	
	public class AbstractLens
	{
		/** @private */
		arcane var _view:View3D;
		/** @private */
		arcane var _root:DisplayObject;
		/** @private */
		arcane var _camera:Camera3D;
		/** @private */
		arcane var _projectionMatrix3D:Matrix3D = new Matrix3D();		
		/** @private */
		arcane function _update():void
		{
			
		}
		
		public function AbstractLens()
		{
		}
		
		public function unProject(x:Number, y:Number, z:Number):Vector3D
		{
			return new Vector3D(x, y, z);
		}
	}
}