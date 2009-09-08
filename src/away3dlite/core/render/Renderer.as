package away3dlite.core.render
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	import away3dlite.core.clip.*;
	
	use namespace arcane;
	
	/**
	 * @author robbateman
	 */
	public class Renderer
	{
		private var ql:Vector.<int> = new Vector.<int>(256, true);
		
		protected var i:int;
		protected var j:int;
		protected var k:int;
		protected var q0:Vector.<int>;
		protected var q1:Vector.<int>;
		protected var np0:Vector.<int>;
		protected var np1:Vector.<int>;
		protected var _view:View3D;
		protected var _scene:Scene3D;
		protected var _face:Face;
		protected var _faces:Vector.<Face> = new Vector.<Face>();
		protected var _sort:Vector.<int> = new Vector.<int>();
		protected var _faceStore:Vector.<int> = new Vector.<int>();
		protected var _clipping:Clipping;
		protected var _screenZ:int;
		protected var _mouseFace:Face;
		private var _screenVertexArrays:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
        private var _screenVertices:Vector.<Number>;
        protected var _screenMouseVertexArrays:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
        protected var _screenMouseVertices:Vector.<int>;
        protected var _mouseEnabled:Boolean;
        protected var _mouseEnabledArray:Vector.<Boolean> = new Vector.<Boolean>();
        private var _index:int;
    	private var _indexX:int;
    	private var _indexY:int;
    	
		// by pass
		protected var _view_graphics_drawGraphicsData:Function;
		
		protected function sortFaces():void
		{
	        // by pass
	        var _faces_length:int = _faces.length;
	        
	        q0 = new Vector.<int>(256, true);
	        q1 = new Vector.<int>(256, true);
	        np0 = new Vector.<int>(_faces_length + 1, true);
	        np1 = new Vector.<int>(_faces_length + 1, true);
	        
        	i = -1;
        	j = 0;
            for each (_face in _faces)
                if((q0[k = (255 & (_sort[int(++i)] = _face.calculateScreenZ()))]))
                    ql[k] = np0[ql[k]] = ++j;
                else
                    ql[k] = q0[k] = ++j;
            
            i = -1;
            while (i++ < 255) {
            	j = q0[i];
                while (j)
                    if((q1[k = (65280 & _sort[j-1]) >> 8]))
	                    j = np0[ql[k] = np1[ql[k]] = j];
	                else
	                    j = np0[ql[k] = q1[k] = j];
            }
		}
		
		protected function getMouseFace():void
		{
			var mouseCount:int;
        	var mouseCountX:int;
        	var mouseCountY:int;
        	var i:int = _faces.length;
			while (i--) {
				if (_screenZ < _sort[i] && (_face = _faces[i]).mesh._mouseEnabled) {
					_screenMouseVertices = _screenMouseVertexArrays[_face.mesh._vertexId];
	    			mouseCount = _screenMouseVertices[_face.i0] + _screenMouseVertices[_face.i1] + _screenMouseVertices[_face.i2];
	    			mouseCountX = (mouseCount >> 2 & 3);
	    			mouseCountY = (mouseCount & 3);
	    			if (mouseCountX && mouseCountX < 3 && mouseCountY && mouseCountY < 3) {
	    				_screenZ = _sort[i];
						_mouseFace = _face;
	    			}
				}
			}
		}
		
		protected function collectScreenVertices(mesh:Mesh):void
		{
			mesh._vertexId = _screenVertexArrays.length;
			_screenVertexArrays.push(mesh._screenVertices);
		}
		
		protected function collectMouseVertices(x:Number, y:Number):void
		{
			_screenMouseVertexArrays.fixed = false;
        	_screenMouseVertexArrays.length = _screenVertexArrays.length;
        	_screenMouseVertexArrays.fixed = true;
        	
        	var i:int = _screenVertexArrays.length;
        	
        	while (i--) {
				_screenVertices = _screenVertexArrays[i];
				_screenMouseVertices = _screenMouseVertexArrays[i] = _screenMouseVertexArrays[i] || new Vector.<int>();
				
				_screenMouseVertices.fixed = false;
				_screenMouseVertices.length = 0;
        		_index = _screenMouseVertices.length = _screenVertices.length/2;
	        	_screenMouseVertices.fixed = true;
        		
	        	while (_index--) {
	        		_indexY = (_indexX = _index*2) + 1;
	        		
	        		if (_screenVertices[_indexX] < x)
	        			_screenMouseVertices[_index] += 4;
	        		
	        		if (_screenVertices[_indexY] < y)
	        			_screenMouseVertices[_index] += 1;
	        	}
        	}
		}
		
		function Renderer()
		{
		}
		
		/**
		 * 
		 */
		public function setView(view:View3D):void
		{
			_view = view;
			_view_graphics_drawGraphicsData = _view.graphics.drawGraphicsData;
		}
		
		/**
		 * 
		 */
		public function render():void
		{
			_scene = _view.scene;
			
			_mouseEnabled = _scene.mouseEnabled;
			_mouseEnabledArray.length = 0;
			_mouseFace = null;
			
			_clipping = _view.screenClipping;
			
			_screenVertexArrays.length = 0;
		}
		
		public function getFaceUnderMouse():Face
		{
			return null;
		}
	}
}
