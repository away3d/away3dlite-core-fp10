package away3dlite.materials
{
	import away3dlite.core.utils.Debug;
	import away3dlite.loaders.utils.LoaderUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;

	/**
	 * BitmapFileMaterial : load external image as texture
	 * @author katopz
	 */
	public class BitmapFileMaterial extends BitmapMaterial
	{
		private function loadTexture(url:String):void
		{
			LoaderUtil.load(url, onTextureLoaded);
		}
		
		private function onTextureLoaded(event:Event):void
		{
			if(event.type==Event.COMPLETE)
			{
				event.target.removeEventListener(Event.COMPLETE, onTextureLoaded);
				bitmap = Bitmap(event.target.content).bitmapData;
			}
		}
		
		/**
		 * 
		 */
		public function BitmapFileMaterial(url:String, color:uint = 0xFFFFFF, alpha:Number = 1)
		{
			super(new BitmapData(2, 2, alpha < 1, int(alpha*0xFF) << 24 | color));
			
			loadTexture(url);
		}
	}
}
