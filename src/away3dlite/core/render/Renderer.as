package away3dlite.core.render
{
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
		/** @private */
		arcane function setView(view:View3D):void
		{
			_view = view;
			_view_graphics_drawGraphicsData = _view.graphics.drawGraphicsData;
		}
		
		private var ql:Vector.<int> = new Vector.<int>(256, true);
		private var k:int;
		private var q0:Vector.<int>;
		private var np0:Vector.<int>;
		private var _screenVertexArrays:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
        private var _screenVertices:Vector.<Number>;
        private var _screenMouseVertexArrays:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
        private var _screenMouseVertices:Vector.<int>;
        private var _index:int;
    	private var _indexX:int;
    	private var _indexY:int;
        /** @private */
		protected var i:int;
		/** @private */
		protected var j:int;
		/** @private */
		protected var q1:Vector.<int>;
		/** @private */
		protected var np1:Vector.<int>;
		/** @private */
		protected var _view:View3D;
		/** @private */
		protected var _scene:Scene3D;
		/** @private */
		protected var _face:Face;
		/** @private */
		protected var _faces:Vector.<Face> = new Vector.<Face>();
		/** @private */
		protected var _sort:Vector.<int> = new Vector.<int>();
		/** @private */
		protected var _faceStore:Vector.<int> = new Vector.<int>();
		/** @private */
		protected var _clipping:Clipping;
		/** @private */
		protected var _screenZ:int;
		/** @private */
		protected var _pointFace:Face;
		/** @private */
        protected var _mouseEnabled:Boolean;
        /** @private */
        protected var _mouseEnabledArray:Vector.<Boolean> = new Vector.<Boolean>();
        /** @private */
    	
		/** @private */
		protected var _view_graphics_drawGraphicsData:Function;
		
		/** @private */
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
		
		/** @private */
		protected function getMouseFace(x:Number, y:Number):void
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
	    				
	    				//flagged for edge detection
	    				var vertices:Vector.<Number> = _face.mesh._screenVertices;
						var v0x:Number = vertices[_face.x0];
						var v0y:Number = vertices[_face.y0];
						var v1x:Number = vertices[_face.x1];
						var v1y:Number = vertices[_face.y1];
						var v2x:Number = vertices[_face.x2];
						var v2y:Number = vertices[_face.y2];
						if ((v0x*(y - v1y) + v1x*(v0y - y) + x*(v1y - v0y)) < -0.001)
			                continue;
			
			            if ((v0x*(v2y - y) + x*(v0y - v2y) + v2x*(y - v0y)) < -0.001)
			                continue;
			
			            if ((x*(v2y - v1y) + v1x*(y - v2y) + v2x*(v1y - y)) < -0.001)
			                continue;
			            
	    				_screenZ = _sort[i];
						_pointFace = _face;
	    			}
				}
			}
		}
		
		/** @private */
		protected function collectScreenVertices(mesh:Mesh):void
		{
			mesh._vertexId = _screenVertexArrays.length;
			_screenVertexArrays.push(mesh._screenVertices);
		}
		
		/** @private */
		protected function collectPointVertices(x:Number, y:Number):void
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
		
		/**
		 * Creates a new <code>Renderer</code> object.
		 */
		function Renderer()
		{
		}
		
		/**
		 * Returns the face object directly under the given point.
		 * 
		 * @param x		The x coordinate of the point.
		 * @param y		The y coordinate of the point.
		 */
		public function getFaceUnderPoint(x:Number, y:Number):Face
		{
			x;
			y;
			return null;
		}
		
		/**
		 * Renders the contents of the scene to the view.
		 * 
		 * @see awa3dlite.containers.Scene3D
		 * @see awa3dlite.containers.View3D
		 */
		public function render():void
		{
			_scene = _view.scene;
			
			_clipping = _view.screenClipping;
			
			_mouseEnabled = _scene.mouseEnabled;
			_mouseEnabledArray.length = 0;
			_pointFace = null;
			
			_screenVertexArrays.length = 0;
		}
	}
}
