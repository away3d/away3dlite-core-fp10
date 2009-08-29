package away3dlite.templates
{
	import away3dlite.cameras.*;
	import away3dlite.containers.*;
	import away3dlite.core.render.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	
	import net.hires.debug.Stats;

	/**
	 * Fast Template
	 * @author katopz
	 */
	public class FastTemplate extends Sprite
	{
		private var stats:Stats;
		private var debugText:TextField;
		private var _title:String;
		private var _debug:Boolean;
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function onEnterFrame(event:Event):void
		{
			onPreRender();
			
			view.render();
			
			if (_debug) {
				debugText.text = _title + ", Object3D(s) : " + view.totalObjects + ", Face(s) : " + view.totalFaces;
				onDebug();
			}
			
			onPostRender();
		}
		
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			//init scene
			scene = new Scene3D();
			
			//init camera
			camera = new Camera3D();
			camera.z = -1000;
			
			//init view
			view = new View3D();
			view.scene = scene;
			view.camera = camera;
			view.renderer = new FastRenderer();
			
			//center view to stage
			view.x = stage.stageWidth/2;
			view.y = stage.stageHeight/2;
			
			//add view to the displaylist
			addChild(view);
			
			//init stats panel
			stats = new Stats();
			
			//add stats to the displaylist
			addChild(stats);
			
			//init debug textfield
			debugText = new TextField();
			debugText.selectable = false;
			debugText.mouseEnabled = false;
			debugText.mouseWheelEnabled = false;
			debugText.defaultTextFormat = new TextFormat("Tahoma", 12, 0x000000);
			debugText.autoSize = "left";
			debugText.x = 80;
			debugText.textColor = 0xFFFFFF;
			debugText.filters = [new GlowFilter(0x000000, 1, 4, 4, 2, 1)];
			
			//add debug textfield to the displaylist
			addChild(debugText);
			
			//set default debug
			_debug = true;
			
			//set default title
			_title = "Away3DLite";
			
			//add enterframe listener
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			//trigger onInit method
			onInit();
		}
		
		protected function onInit():void
		{
			// override me
		}

		protected function onPreRender():void
		{
			// override me
		}
		
		protected function onDebug():void
		{
			// override me
		}
		
		protected function onPostRender():void
		{
			// override me
		}
		
		public function get title():String
		{
			return _title;
		}
		public function set title(val:String):void
		{
			if (_title == val)
				return;
			
			_title = val;
			
			debugText.text = _title + ", Object3D(s) : " + view.totalObjects + ", Face(s) : " + view.totalFaces;
		}
		
		public function get debug():Boolean
		{
			return _debug;
		}
		
		public function set debug(val:Boolean):void
		{
			if (_debug == val)
				return;
			
			_debug = val;
			
			debugText.visible = _debug;
			stats.visible = _debug;
		}

		public var scene:Scene3D;
		
		public var camera:Camera3D;
		
		public var view:View3D;
		
		public function FastTemplate()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}