package away3dlite.loaders.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;	
	
	public class LoaderUtil
	{
		public static function load(uri:String, eventHandler:Function = null, type:String = "auto"):Object
		{
			if(type=="auto")
			switch(getType(uri))
			{
				case "jpg":
				case "png":
				case "gif":
				case "swf":
					type="asset";
				break;
				case "text":
				case "json":
				case "xml":
					type=URLLoaderDataFormat.TEXT;
				break;
				default :
					type=URLLoaderDataFormat.BINARY;
				break;
			}
			
			if(type=="asset")
			{
				//The Loader class is used to load SWF files or image (JPG, PNG, or GIF) files. 
				//Use the load() method to initiate loading. The loaded display object is added as a child of the Loader object. 
				var loader:Loader = new Loader();
				
			    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventHandler, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventHandler, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventHandler, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(Event.OPEN, eventHandler, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler, false, 0, true);
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
				{
				    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventHandler, false, 0, true);
		            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventHandler, false, 0, true);
		            loader.contentLoaderInfo.addEventListener(Event.INIT, eventHandler, false, 0, true);
		            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventHandler, false, 100, true);
		            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler, false, 0, true);
		            loader.contentLoaderInfo.addEventListener(Event.OPEN, eventHandler, false, 0, true);  
		            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler, false, 0, true);
		            try{loader.close();}catch (e:Error){};
				}, false, 0, true);
				
				try
				{
					loader.load(new URLRequest(uri), new LoaderContext(false, ApplicationDomain.currentDomain));
				}
				catch (e:Error)
				{
					trace(" ! Error in loading file (" + uri + "): \n" + e.message + "\n" + e.getStackTrace());
				}
				return loader;
			}else{
				//The URLLoader class downloads data from a URL as text, binary data, or URL-encoded variables. 
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = type;
				
			    urlLoader.addEventListener(ProgressEvent.PROGRESS, eventHandler, false, 0, true);
	            urlLoader.addEventListener(Event.COMPLETE, eventHandler, false, 0, true);
	            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, eventHandler, false, 0, true);
	            urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler, false, 0, true);
	            urlLoader.addEventListener(Event.OPEN, eventHandler, false, 0, true);
	            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler, false, 0, true);
				
				urlLoader.addEventListener(Event.COMPLETE, function():void
				{
				    urlLoader.removeEventListener(ProgressEvent.PROGRESS, eventHandler);
		            urlLoader.removeEventListener(Event.COMPLETE, eventHandler);
		            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, eventHandler);
		            urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
		            urlLoader.removeEventListener(Event.OPEN, eventHandler);
		            urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
		            try{urlLoader.close();}catch (e:Error){};
				}, false, 0, true);
				
				try
				{
					urlLoader.load(new URLRequest(uri));
				}
				catch (e:Error)
				{
					trace(" ! Error in loading file (" + uri + "): \n" + e.message + "\n" + e.getStackTrace());
				}
				return urlLoader;
			}
		}
		
		public static function getType(value:String):String
		{
			//file.something.type?q#a
			value = value.split("#")[0];
			//file.something.type?q
			value = value.split("?")[0];
			//file.something.type
			var results:Array = value.split(".");
			//type
			return results[results.length - 1];
		}
	}
}