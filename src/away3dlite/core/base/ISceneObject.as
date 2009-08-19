package away3dlite.core.base {

	import away3dlite.containers.*;
	import flash.geom.*;
	
	/**
	 * @author robbateman
	 */
	public interface ISceneObject {
		
		function get screenZ():Number;
		
		function get scene():Scene3D;
		
		function project(parentMatrix3D:Matrix3D):void
	}
}
