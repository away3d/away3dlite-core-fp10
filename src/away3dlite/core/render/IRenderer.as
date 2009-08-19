package away3dlite.core.render {

	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	
	/**
	 * @author robbateman
	 */
	public interface IRenderer {
		
		function setView(View:View3D):void;
		function render(object:Object3D):void
	}
}
