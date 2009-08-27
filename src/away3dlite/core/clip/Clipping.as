package away3dlite.core.clip
{
	import away3dlite.cameras.Camera3D;
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	import away3dlite.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	/**
	 * Dispatched when the clipping properties of a clipping object update.
	 * 
	 * @eventType away3dlite.events.ClipEvent
	 * 
	 * @see #maxX
	 * @see #minX
	 * @see #maxY
	 * @see #minY
	 * @see #maxZ
	 * @see #minZ
	 */
	[Event(name="clippingUpdated",type="away3dlite.events.ClippingEvent")]
	
	/**
	 * Dispatched when the clipping properties of a screenClipping object update.
	 * 
	 * @eventType away3dlite.events.ClipEvent
	 * 
	 * @see #maxX
	 * @see #minX
	 * @see #maxY
	 * @see #minY
	 * @see #maxZ
	 * @see #minZ
	 */
	[Event(name="screenUpdated",type="away3dlite.events.ClippingEvent")]
	
	use namespace arcane;
	
    /**
    * Base clipping class for no clipping.
    */
    public class Clipping extends EventDispatcher
    {
    	protected var _view:View3D;
        protected var _face:Face;
        protected var _faces:Vector.<Face>;
        protected var _screenVertices:Vector.<Number>;
        protected var _uvtData:Vector.<Number>;
        protected var _index:int;
    	protected var _indexX:int;
    	protected var _indexY:int;
    	protected var _indexZ:int;
        protected var _screenVerticesCull:Vector.<int> = new Vector.<int>();
		protected var _minX:Number;
		protected var _minY:Number;
		protected var _minZ:Number;
		protected var _maxX:Number;
		protected var _maxY:Number;
		protected var _maxZ:Number;
        
    	private var _clippingClone:Clipping;
    	private var _stage:Stage;
    	private var _stageWidth:Number;
    	private var _stageHeight:Number;
    	private var _localPointTL:Point = new Point(0, 0);
    	private var _localPointBR:Point = new Point(0, 0);
		private var _globalPointTL:Point = new Point(0, 0);
		private var _globalPointBR:Point = new Point(0, 0);
		private var _miX:Number;
		private var _miY:Number;
		private var _maX:Number;
		private var _maY:Number;
		private var _clippingupdated:ClippingEvent;
		private var _screenupdated:ClippingEvent;
		
		private function onScreenUpdate(event:ClippingEvent):void
		{
			notifyScreenUpdate();
		}
		
        private function notifyClippingUpdate():void
        {
            if (!hasEventListener(ClippingEvent.CLIPPING_UPDATED))
                return;
			
            if (_clippingupdated == null)
                _clippingupdated = new ClippingEvent(ClippingEvent.CLIPPING_UPDATED, this);
                
            dispatchEvent(_clippingupdated);
        }
		
        private function notifyScreenUpdate():void
        {
            if (!hasEventListener(ClippingEvent.SCREEN_UPDATED))
                return;
			
            if (_screenupdated == null)
                _screenupdated = new ClippingEvent(ClippingEvent.SCREEN_UPDATED, this);
                
            dispatchEvent(_screenupdated);
        }
		
    	/**
    	 * Minimum allowed x value for primitives
    	 */
    	public function get minX():Number
		{
			return _minX;
		}
		
		public function set minX(value:Number):void
		{
			if (_minX == value)
				return;
			
			_minX = value;
			
			notifyClippingUpdate();
		}
    	
    	/**
    	 * Minimum allowed y value for primitives
    	 */
        public function get minY():Number
		{
			return _minY;
		}
		
		public function set minY(value:Number):void
		{
			if (_minY == value)
				return;
			
			_minY = value;
			
			notifyClippingUpdate();
		}
    	
    	/**
    	 * Minimum allowed z value for primitives
    	 */
        public function get minZ():Number
		{
			return _minZ;
		}
		
		public function set minZ(value:Number):void
		{
			if (_minZ == value)
				return;
			
			_minZ = value;
			
			notifyClippingUpdate();
		}
        
    	/**
    	 * Maximum allowed x value for primitives
    	 */
        public function get maxX():Number
		{
			return _maxX;
		}
		
		public function set maxX(value:Number):void
		{
			if (_maxX == value)
				return;
			
			_maxX = value;
			
			notifyClippingUpdate();
		}
    	
    	/**
    	 * Maximum allowed y value for primitives
    	 */
        public function get maxY():Number
		{
			return _maxY;
		}
		
		public function set maxY(value:Number):void
		{
			if (_maxY == value)
				return;
			
			_maxY = value;
			
			notifyClippingUpdate();
		}
    	
    	/**
    	 * Maximum allowed z value for primitives
    	 */
        public function get maxZ():Number
		{
			return _maxZ;
		}
		
		public function set maxZ(value:Number):void
		{
			if (_maxZ == value)
				return;
			
			_maxZ = value;
			
			notifyClippingUpdate();
		}
        
		/**
		 * Creates a new <code>Clipping</code> object.
		 * 
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function Clipping()
        {
        	super();
        }
        
		/**
		 * Collects faces to be rendered from a mesh.
		 * 
		 * @param	mesh	The mesh used as a souce for faces.
		 * @param	faces	The array storing the faces to be rendered.
		 */
        public function collectFaces(mesh:Mesh, faces:Vector.<Face>):void
        {
        	_faces = mesh._faces;
        	
        	for each(_face in _faces)
        		faces[faces.length] = _face;
        }
		
		/**
		 * Returns a clipping object initilised with the edges of the flash movie as the clipping bounds.
		 */
        public function screen(container:Sprite, _loaderWidth:Number, _loaderHeight:Number):Clipping
        {
        	if (!_clippingClone) {
        		_clippingClone = clone();
        		_clippingClone.addOnClippingUpdate(onScreenUpdate);
        	}
        	
			_stage = container.stage;
			
        	if (_stage.scaleMode == StageScaleMode.NO_SCALE) {
        		_stageWidth = _stage.stageWidth;
        		_stageHeight = _stage.stageHeight;
        	} else if (_stage.scaleMode == StageScaleMode.EXACT_FIT) {
        		_stageWidth = _loaderWidth;
        		_stageHeight = _loaderHeight;
        	} else if (_stage.scaleMode == StageScaleMode.SHOW_ALL) {
        		if (_stage.stageWidth/_loaderWidth < _stage.stageHeight/_loaderHeight) {
        			_stageWidth = _loaderWidth;
        			_stageHeight = _stage.stageHeight*_stageWidth/_stage.stageWidth;
        		} else {
        			_stageHeight = _loaderHeight;
        			_stageWidth = _stage.stageWidth*_stageHeight/_stage.stageHeight;
        		}
        	} else if (_stage.scaleMode == StageScaleMode.NO_BORDER) {
        		if (_stage.stageWidth/_loaderWidth > _stage.stageHeight/_loaderHeight) {
        			_stageWidth = _loaderWidth;
        			_stageHeight = _stage.stageHeight*_stageWidth/_stage.stageWidth;
        		} else {
        			_stageHeight = _loaderHeight;
        			_stageWidth = _stage.stageWidth*_stageHeight/_stage.stageHeight;
        		}
        	}
        	
        	if(_stage.align == StageAlign.TOP_LEFT) {
        		
            	_localPointTL.x = 0;
            	_localPointTL.y = 0;
                
                _localPointBR.x = _stageWidth;
            	_localPointBR.y = _stageHeight;
                
	        } else if(_stage.align == StageAlign.TOP_RIGHT) {
	        	
	        	_localPointTL.x = _loaderWidth - _stageWidth;
            	_localPointTL.y = 0;
            	
            	_localPointBR.x = _loaderWidth;
            	_localPointBR.y = _stageHeight;
                
	        } else if(_stage.align==StageAlign.BOTTOM_LEFT) {
	        	
	        	_localPointTL.x = 0;
            	_localPointTL.y = _loaderHeight - _stageHeight;
            	
            	_localPointBR.x = _stageWidth;
            	_localPointBR.y = _loaderHeight;
            	
	        } else if(_stage.align==StageAlign.BOTTOM_RIGHT) {
	        	
	        	_localPointTL.x = _loaderWidth - _stageWidth;
	        	_localPointTL.y = _loaderHeight - _stageHeight;
	        	
	        	_localPointBR.x = _loaderWidth;
	        	_localPointBR.y = _loaderHeight;
	        	
	        } else if(_stage.align == StageAlign.TOP) {
	        	
	        	_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
            	_localPointTL.y = 0;
            	
            	_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
            	_localPointBR.y = _stageHeight;
            	
	        } else if(_stage.align==StageAlign.BOTTOM) {
            	
	        	_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
            	_localPointTL.y = _loaderHeight - _stageHeight;
            	
            	_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
            	_localPointBR.y = _loaderHeight;
            	
	        } else if(_stage.align==StageAlign.LEFT) {
	        	
	        	_localPointTL.x = 0;
            	_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
            	
            	_localPointBR.x = _stageWidth;
            	_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
            	
	        } else if(_stage.align==StageAlign.RIGHT) {
            	
	        	_localPointTL.x = _loaderWidth - _stageWidth;
            	_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
            	
            	_localPointBR.x = _loaderWidth;
            	_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
            	
	        } else {
            	
	        	_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
            	_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
            	
            	_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
            	_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
        	}
        	
        	_globalPointTL = container.globalToLocal(_localPointTL);
        	_globalPointBR = container.globalToLocal(_localPointBR);
        	
			_miX = _globalPointTL.x;
            _miY = _globalPointTL.y;
            _maX = _globalPointBR.x;
            _maY = _globalPointBR.y;
            
            if (_minX > _miX)
            	_clippingClone.minX = _minX;
            else
            	_clippingClone.minX = _miX;
            
            if (_maxX < _maX)
            	_clippingClone.maxX = _maxX;
            else
            	_clippingClone.maxX = _maX;
            
            if (_minY > _miY)
            	_clippingClone.minY = _minY;
            else
            	_clippingClone.minY = _miY;
            
            if (_maxY < _maY)
            	_clippingClone.maxY = _maxY;
            else
            	_clippingClone.maxY = _maY;
            
            _clippingClone.minZ = _minZ;
            _clippingClone.maxZ = _maxZ;
            
            return _clippingClone;
        }
				
		/**
		 * 
		 */
		public function setView(view:View3D):void
		{
			_view = view;
		}
		
		public function clone(object:Clipping = null):Clipping
        {
        	var clipping:Clipping = object || new Clipping();
        	
        	clipping.minX = minX;
        	clipping.minY = minY;
        	clipping.minZ = minZ;
        	clipping.maxX = maxX;
        	clipping.maxY = maxY;
        	clipping.maxZ = maxZ;
        	return clipping;
        }
        
        /**
		 * Used to trace the values of a rectangle clipping object.
		 * 
		 * @return A string representation of the rectangle clipping object.
		 */
        public override function toString():String
        {
        	return "{minX:" + minX + " maxX:" + maxX + " minY:" + minY + " maxY:" + maxY + " minZ:" + minZ + " maxZ:" + maxZ + "}";
        }
        
		/**
		 * Default method for adding a clippingUpdated event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function addOnClippingUpdate(listener:Function):void
        {
            addEventListener(ClippingEvent.CLIPPING_UPDATED, listener, false, 0, false);
        }
		
		/**
		 * Default method for removing a clippingUpdated event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function removeOnClippingUpdate(listener:Function):void
        {
            removeEventListener(ClippingEvent.CLIPPING_UPDATED, listener, false);
        }
        
		/**
		 * Default method for adding a screenUpdated event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function addOnScreenUpdate(listener:Function):void
        {
            addEventListener(ClippingEvent.SCREEN_UPDATED, listener, false, 0, false);
        }
		
		/**
		 * Default method for removing a screenUpdated event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function removeOnScreenUpdate(listener:Function):void
        {
            removeEventListener(ClippingEvent.SCREEN_UPDATED, listener, false);
        }
    }
}