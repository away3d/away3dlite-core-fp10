package away3dlite.containers
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Layer
	 * @author katopz
	 */
	public class Layer extends Sprite 
	{
		public function Layer()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			x = stage.stageWidth/2;
			y = stage.stageHeight/2;
		}
	}
}