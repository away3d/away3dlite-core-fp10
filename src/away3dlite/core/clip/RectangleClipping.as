package away3dlite.core.clip
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
	
	use namespace arcane;
	
    /**
    * Rectangle clipping
    */
    public class RectangleClipping extends Clipping
    {
        public function RectangleClipping()
        {
            super();
        }
        
		/**
		 * @inheritDoc
		 */
        public override function collectFaces(mesh:Mesh, faces:Array):void
        {
        	_faces = mesh._faces;
        	_uvtData = mesh._uvtData;
			_screenVertices = mesh._screenVertices;
			
        	_screenVerticesCull.length = 0;
        	_index = _screenVerticesCull.length = _screenVertices.length/2;
        	
        	while (_index--) {
        		_indexX = _index*2;
        		_indexY = _indexX + 1;
        		_indexZ = _index*3 + 2;
        		
        		if (_uvtData[_indexZ] < 0)
        			_screenVerticesCull[_index] = 3;
        		else if (_screenVertices[_indexX] < _minX || _screenVertices[_indexX] > _maxX || _screenVertices[_indexY] < _minY || _screenVertices[_indexY] > _maxY)
	        			_screenVerticesCull[_index] = 1;
        	}
        	
        	for each(_face in _faces)
        		if ((mesh.bothsides || _screenVertices[_face.x0]*(_screenVertices[_face.y2] - _screenVertices[_face.y1]) + _screenVertices[_face.x1]*(_screenVertices[_face.y0] - _screenVertices[_face.y2]) + _screenVertices[_face.x2]*(_screenVertices[_face.y1] - _screenVertices[_face.y0]) > 0)
        			&& (_screenVerticesCull[_face.i0] + _screenVerticesCull[_face.i1] + _screenVerticesCull[_face.i2] < 3))
						faces[faces.length] = _face;
        }
        
		public override function clone(object:Clipping = null):Clipping
        {
        	var clipping:RectangleClipping = (object as RectangleClipping) || new RectangleClipping();
        	
        	super.clone(clipping);
        	
        	return clipping;
        }
    }
}