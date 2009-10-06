package away3dlite.materials
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * Base particle material class.
	 */
	public class ParticleMaterial
	{
		private var _bitmapData:BitmapData;
		
		private const DEFAULT_BITMAPDATA:BitmapData = new BitmapData(1, 1);
		
		private var _currentFrame:int = 0;
		private var _totalFrames:int = 0;
		
		public var frames:Vector.<BitmapData>;
		public var dirty:Boolean;
		
		//cacheScaleBitmap
		public var scales:Vector.<BitmapData>;
		public var matrixs:Vector.<Matrix>;
		
		public var cacheScaleBitmap:Boolean;
		public var maxScale:int;
		public var quality:int;
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
			dirty = true;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		/**
		 * Creates a new <code>ParticleMaterial</code> object.
		 */
		public function ParticleMaterial(bitmapData:BitmapData = null, cacheScaleBitmap:Boolean = false)
		{
			this.cacheScaleBitmap = cacheScaleBitmap;
			this.bitmapData = bitmapData?bitmapData:DEFAULT_BITMAPDATA;
			
			addFrame(_bitmapData);
		}
		
		// TODO add MovieClip
		public function addFrame(frameBitmapData:BitmapData, maxScale:int = 2, quality:int = 10, smooth:Boolean = false):void
		{
			this.maxScale = maxScale = (maxScale < 1)?1:maxScale;
			this.quality = quality = (quality < 1)?1:quality;
			
			if (!frames || _bitmapData==DEFAULT_BITMAPDATA)
				frames = new Vector.<BitmapData>();
			
			frames.fixed = false;
			frames.push(frameBitmapData);
			frames.fixed = true;
			
			_totalFrames = frames.length;
			
			bitmapData = frames[0];
			
			// scale buffer
			if (cacheScaleBitmap)
			{
				if(!scales)
				{
					scales = new Vector.<BitmapData>();
					matrixs = new Vector.<Matrix>();
				}else{
					scales.fixed = false;
					matrixs.fixed = false;
				}

				//bufferring
				var _scaleBitmapData:BitmapData;
				var _matrix:Matrix = new Matrix();
				var _scale:Number;
				
				var j:int=0;
				for (var i:int = 0; i < maxScale*quality; i++)
				{
					_scale = i/quality;
					_matrix.a = _matrix.d = _scale = (_scale<=0)?(i+1)/quality:_scale;
					
					var _w:int = int(frameBitmapData.width * _scale);
					var _h:int = int(frameBitmapData.height * _scale);
					 
					_scaleBitmapData = new BitmapData((_w<1)?1:_w, (_h<1)?1:_h, true, 0x000000);
					_scaleBitmapData.draw(frameBitmapData, _matrix, null, null, new Rectangle(0, 0, _scaleBitmapData.width, _scaleBitmapData.height), smooth);
					
					scales.push(_scaleBitmapData.clone());
					matrixs.push(_matrix.clone());
					
					j++;
				}
				
				scales.fixed = true;
				matrixs.fixed = true;
			}
		}
	}
}