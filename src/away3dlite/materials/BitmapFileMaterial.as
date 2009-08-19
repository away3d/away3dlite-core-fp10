package away3dlite.materials
{
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
			var textureLoader:Loader = new Loader();
			textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureLoaded, false, 0, true);

			textureLoader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function onTextureLoaded(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, onTextureLoaded);
			bitmap = Bitmap(event.target.content).bitmapData;
		}
		
		/**
		 * 
		 */
		public function BitmapFileMaterial(url:String, color:uint = 0xFFFFFF, alpha:Number = 1)
		{
			super(new BitmapData(100, 100, (alpha < 1), color));
			
			loadTexture(url);
		}
	}
}
