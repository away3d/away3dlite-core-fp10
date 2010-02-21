package away3dlite.lights
{
	import away3dlite.arcane;
	
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * @author robbateman
	 */
	public class DirectionalLight3D extends AbstractLight3D
	{
		private const _TO_DEGREES:Number = 180/Math.PI;
		private var _ambient:Number = 0.5;
		private var _diffuse:Number = 0.5;
		private var _specular:Number = 1;
		
		private var _direction:Vector3D;
		private var _diffuseTransform:Matrix3D = new Matrix3D();
		private var _specularTransform:Matrix3D = new Matrix3D();
		private var _diffuseTransformDirty:Boolean;
		
		/**
		 * 
		 */
		public function get ambient():Number
		{
			return _ambient;
		}
		
		public function set ambient(val:Number):void
		{
			if (_ambient == val)
				return;
			
			_ambient = val;
		}
		
		/**
		 * 
		 */
		public function get diffuse():Number
		{
			return _diffuse;
		}
		
		public function set diffuse(val:Number):void
		{
			if (_diffuse == val)
				return;
			
			_diffuse = val;
		}
		
		/**
		 * 
		 */
		public function get specular():Number
		{
			return _specular;
		}
		
		public function set specular(val:Number):void
		{
			if (_specular == val)
				return;
			
			_specular = val;
		}
		
		/**
		 * 
		 */
		public function get direction():Vector3D
		{
			return _direction;
		}
		
		public function set direction(val:Vector3D):void
		{
			if (_direction == val)
				return;
			
			_direction = val;
			
			_diffuseTransformDirty = true;
		}
		
		public function get diffuseTransform():Matrix3D
		{
			if (_diffuseTransformDirty) {
				
				_diffuseTransformDirty = false;
				
				_direction.normalize();
				
	        	var nx:Number = _direction.x;
	        	var ny:Number = _direction.y;
	        	var mod:Number = Math.sqrt(nx*nx + ny*ny);
	        	
	        	_diffuseTransform.identity();
	        	
	        	if (mod)
	        		_diffuseTransform.prependRotation(-Math.acos(-_direction.z)*_TO_DEGREES, new Vector3D(ny/mod, -nx/mod, 0));
	        	else
	        		_diffuseTransform.prependRotation(-Math.acos(-_direction.z)*_TO_DEGREES, new Vector3D(0, 1, 0));
			}
			
			return _diffuseTransform;
		}
		
		public function get specularTransform():Matrix3D
		{
			var halfVector:Vector3D = new Vector3D(_camera.sceneMatrix3D.rawData[8], _camera.sceneMatrix3D.rawData[9], _camera.sceneMatrix3D.rawData[10]);
			halfVector = halfVector.add(_direction);
			halfVector.normalize();
			
			var nx:Number = halfVector.x;
        	var ny:Number = halfVector.y;
        	var mod:Number = Math.sqrt(nx*nx + ny*ny);
        	
        	_specularTransform.identity();
        	_specularTransform.prependRotation(Math.acos(-halfVector.z)*_TO_DEGREES, new Vector3D(-ny/mod, nx/mod, 0));
        	
			return _specularTransform;
		}
		/**
		 * 
		 */
		public function DirectionalLight3D()
		{
			
		}
	}
}
