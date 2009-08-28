package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;
	import away3dlite.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * Sprite container used for storing camera, scene, session, renderer and clip references, and resolving mouse events
	 */
	public class View3D extends Sprite
	{
		/** @private */
		arcane var _totalFaces:int;
		/** @private */
		arcane var _totalObjects:int;
		/** @private */
		arcane var _renderedFaces:int;
		/** @private */
		arcane var _renderedObjects:int;
		
		private var _renderer:Renderer;
		private var _camera:Camera3D;
		private var _scene:Scene3D;
        private var _clipping:Clipping;
        private var _screenClipping:Clipping;
        private var _loaderWidth:Number;
		private var _loaderHeight:Number;
		private var _loaderDirty:Boolean;
        private var _screenClippingDirty:Boolean;
        private var _viewZero:Point = new Point();
		private var _x:Number;
		private var _y:Number;
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		
		private function onClippingUpdated(e:ClippingEvent):void
		{
			_screenClippingDirty = true;
		}
		
		private function onScreenUpdated(e:ClippingEvent):void
		{
			
		}
		
		private function onStageResized(event:Event):void
		{
			_screenClippingDirty = true;
		}
		
		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(Event.RESIZE, onStageResized);
		}
		
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
		public function get renderer():Renderer
		{
			return _renderer;
		}
		public function set renderer(val:Renderer):void
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
		public function get scene():Scene3D
		{
			return _scene;
		}
		public function set scene(val:Scene3D):void
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
		 * Clipping used when rendering.
         * 
         * @see render()
         */
		public function get clipping():Clipping
		{
			return _clipping;
		}
		public function set clipping(val:Clipping):void
		{
			if (_clipping == val)
				return;
			
        	if (_clipping) {
        		_clipping.removeOnClippingUpdate(onClippingUpdated);
        		_clipping.removeOnScreenUpdate(onScreenUpdated);
        	}
        	
			_clipping = val;
			_clipping.setView(this);
			
        	if (_clipping) {
        		_clipping.addOnClippingUpdate(onClippingUpdated);
        		_clipping.addOnScreenUpdate(onScreenUpdated);
        	} else {
        		throw new Error("View cannot have clip set to null");
        	}
        	
        	_screenClippingDirty = true;
		}
		
		/**
		 * 
		 */
        public function get screenClipping():Clipping
        {
        	if (_screenClippingDirty) {
        		updateScreenClipping();
        		_screenClippingDirty = false;
        		
        		return _screenClipping = _clipping.screen(this, _loaderWidth, _loaderHeight);
        	}
        	
        	return _screenClipping;
        }
		
		/**
		 * 
		 */
		public function get totalFaces():int
		{
			return _totalFaces;
		}
		
		/**
		 * 
		 */
		public function get totalObjects():int
		{
			return _totalObjects;
		}
		
		/**
		 * 
		 */
		public function get renderedFaces():int
		{
			return _renderedFaces;
		}
		
		/**
		 * 
		 */
		public function get renderedObjects():int
		{
			return _renderedObjects;
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
			clipping = new RectangleClipping();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
        
        /**
         * Renders a snapshot of the view.
         */
		public function render():void {
			_totalFaces = 0;
			_totalObjects = 0;
			_renderedFaces = 0;
			_renderedObjects = 0;
			
			updateScreenClipping();
			
			camera.update();
			
			_scene.project(camera.viewMatrix3D);
			
			graphics.clear();
			
			renderer.render();
		}
		
        
		public function updateScreenClipping():void
		{
        	//check for loaderInfo update
        	try {
        		_loaderWidth = loaderInfo.width;
        		_loaderHeight = loaderInfo.height;
        		if (_loaderDirty) {
        			_loaderDirty = false;
        			_screenClippingDirty = true;
        		}
        	} catch (error:Error) {
        		_loaderDirty = true;
        		_loaderWidth = stage.stageWidth;
        		_loaderHeight = stage.stageHeight;
        	}
        	
			//check for global view movement
        	_viewZero.x = 0;
        	_viewZero.y = 0;
        	_viewZero = localToGlobal(_viewZero);
        	
			if (_x != _viewZero.x || _y != _viewZero.y || stage.scaleMode != StageScaleMode.NO_SCALE && (_stageWidth != stage.stageWidth || _stageHeight != stage.stageHeight)) {
        		_x = _viewZero.x;
        		_y = _viewZero.y;
        		_stageWidth = stage.stageWidth;
        		_stageHeight = stage.stageHeight;
        		_screenClippingDirty = true;
   			}
		}
	}
}
