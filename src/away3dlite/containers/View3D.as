package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	import away3dlite.core.render.*;
	
	import flash.display.Sprite;
	
	use namespace arcane;
	
	/**
	 * Sprite container used for storing camera, scene, session, renderer and clip references, and resolving mouse events
	 */
	public class View3D extends Sprite
	{
		private var _renderer:IRenderer;
		private var _camera:Camera3D;
		private var _scene:ObjectContainer3D;
        
        /**
         * Camera used when rendering.
         * 
         * @see #render()
         */
		public function get camera():Camera3D
		{
			return _camera;
		}
		public function set camera(val:Camera3D):void
		{
			if (_camera == val)
				return;
				
			if (_camera) {
				removeChild(_camera);
				_camera.view = null;
			}
			
			_camera = val;
			
			if (_camera) {
				addChild(_camera);
				_camera.view = this;
			}
		}
		
        /**
         * Renderer object used to traverse the scenegraph and output the drawing primitives required to render the scene to the view.
         * 
         * @see #render()
         */
		public function get renderer():IRenderer
		{
			return _renderer;
		}
		public function set renderer(val:IRenderer):void
		{
			if (_renderer == val)
				return;
			
			_renderer = val;
			_renderer.setView(this);
		}
        
		/**
		 * Scene used when rendering.
         * 
         * @see render()
         */
		public function get scene():ObjectContainer3D
		{
			return _scene;
		}
		public function set scene(val:ObjectContainer3D):void
		{
			if (_scene == val)
				return;
			
			if (_scene) {
				removeChild(_scene);
			}
			
			_scene = val;
			
			if (_scene) {
				addChild(_scene);
			}
		}
        
		/**
		 * Creates a new <code>View3D</code> object.
		 */
		public function View3D()
		{
			super();
			
			renderer = new BasicRenderer();
			camera = new Camera3D();
			scene = new Scene3D();
		}
        
        /**
         * Renders a snapshot of the view.
         */
		public function render():void
		{
			camera.update();
			
			_scene.project(camera.viewMatrix3D);
			
			graphics.clear();
			
			renderer.render(_scene);
		}
	}
}
