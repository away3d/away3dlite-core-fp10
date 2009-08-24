package away3dlite.templates
{
	import away3dlite.cameras.Camera3D;
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.core.render.GroupRenderer;
	import away3dlite.core.utils.TextUtil;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.*;
	
	import net.hires.debug.Stats;

	/**
	 * SimpleView
	 * @author katopz
	 */
	public class SimpleView extends Sprite
	{
		protected var renderer:GroupRenderer;

		protected var scene:Scene3D;
		protected var camera:Camera3D;
		protected var view:View3D;
		
		protected var stats:Stats;

		protected var _isDebug:Boolean;
		protected var debugText:TextField;
		protected var title:String;

		public function SimpleView()
		{
			title = "Away3DLite";
			addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init();
			start();
		}

		protected function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			scene = new Scene3D();
			camera = new Camera3D();
			camera.z = -1000;

			view = new View3D();
			view.scene = scene;
			view.camera = camera;

			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;

			addChild(view);

			var viewPort:Sprite = new Sprite();
			addChild(viewPort);

			create();

			stats = new Stats();
			addChild(stats);
			
			debugText = TextUtil.getTextField(title);
			debugText.x = 80;
			debugText.textColor = 0xFFFFFF;
			debugText.filters = [new GlowFilter(0x000000, 1, 4, 4, 2, 1)];
			addChild(debugText);

			isDebug = true;
		}

		protected function create():void
		{
			// override me
		}

		protected function start():void
		{
			addEventListener(Event.ENTER_FRAME, run, false, 0, true);
		}

		protected function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, run);
		}

		protected function run(event:Event):void
		{
			prerender()
			view.render();
			if (_isDebug)
				debug();
			draw();
		}

		protected function prerender():void
		{
			// override me
		}
		
		protected function debug():void
		{
			// override me
			debugText.text = title;
		}
		
		protected function draw():void
		{
			// override me
		}

		protected function get isDebug():Boolean
		{
			return _isDebug;
		}

		protected function set isDebug(value:Boolean):void
		{
			_isDebug = value;
			debugText.visible = _isDebug;
		}
	}
}