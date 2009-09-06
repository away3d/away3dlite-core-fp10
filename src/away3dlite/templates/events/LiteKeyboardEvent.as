package away3dlite.templates.events
{
	import flash.events.Event;
	import flash.geom.Vector3D;

	/**
	 * @author katopz
	 */
	public class LiteKeyboardEvent extends Event
	{
		public static const KEY_PRESS:String = "lite-key-press";

		public var data:Object;

		public function LiteKeyboardEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}

		override public function clone():Event
		{
			return new LiteKeyboardEvent(type, data, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("LiteKeyboardEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}
