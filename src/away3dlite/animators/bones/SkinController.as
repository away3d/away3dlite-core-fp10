package away3dlite.animators.bones
{
	import away3dlite.containers.*;
	
	import flash.geom.*;
	
    public class SkinController
    {
    	private var _inverseSceneTransform:Matrix3D;
        private var _sceneTransform:Matrix3D;
        
    	public var name:String;
		public var joint:ObjectContainer3D;
        public var bindMatrix:Matrix3D;
        public var parent:ObjectContainer3D;
        public var skinVertices:Vector.<SkinVertex> =  new Vector.<SkinVertex>();
        
        public function get sceneTransform():Matrix3D
        {
        	return _sceneTransform;
        }
        
        public function update():void
        {
        	if (!joint)
        		return;
        	
        	_sceneTransform = joint.transform.getRelativeMatrix3D(parent);
        	//_inverseSceneTransform = parent.sceneTransform.clone();
        	//_inverseSceneTransform.invert();
        	_sceneTransform.prepend(bindMatrix);
        	//_sceneTransform.append(_inverseSceneTransform);
        }
        
    }
}
