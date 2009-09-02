package away3dlite.animators.bones
{
	import flash.geom.*;
	
    public class SkinVertex
    {
    	private var _i:int;
    	private var _position:Vector3D = new Vector3D();
        private var _output:Vector3D;
        private var startIndex:int;
        private var vertices:Vector.<Number>;
		public var baseVertex:Vector3D;
        public var weights:Vector.<Number> = new Vector.<Number>();
        public var controllers:Vector.<SkinController> = new Vector.<SkinController>();
		
        public function SkinVertex(startIndex:int, vertices:Vector.<Number>)
        {
        	this.startIndex = startIndex;
        	this.vertices = vertices;
            baseVertex = new Vector3D(vertices[startIndex], vertices[startIndex + 1], vertices[startIndex + 2]);
        }

        public function update():void
        {
        	//reset values
            _output = new Vector3D();
            
            _i = weights.length;
            while (_i--) {
            	_position = controllers[_i].sceneTransform.transformVector(baseVertex);
				_position.scaleBy(weights[_i]);
				_output.add(_position);
            }
            
            vertices[startIndex] = _output.x;
            vertices[startIndex + 1] = _output.y;
            vertices[startIndex + 2] = _output.z;
        }
    }
}
