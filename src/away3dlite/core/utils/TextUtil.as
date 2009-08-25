package away3dlite.core.utils
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * TextUtil
	 * @author katopz
	 */
	public class TextUtil
	{
		public static function getTextField(text:String = null, textFormat:TextFormat = null):TextField
		{
			var _textField:TextField = new TextField();

			_textField.selectable = false;
			_textField.mouseEnabled = false;
			_textField.mouseWheelEnabled = false;
			_textField.defaultTextFormat = textFormat ? textFormat : new TextFormat("Tahoma", 12, 0x000000);
			_textField.autoSize = "left";

			if (text)
				_textField.text = text;

			return _textField;
		}
	}
}