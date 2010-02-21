package away3dlite.lights
{

	/**
	 * @author robbateman
	 */
	public class PointLight3D extends AbstractLight3D
	{
		
		private var _ambient:Number;
		private var _diffuse:Number;
		private var _specular:Number;
		
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		
		
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
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(val:Number):void
		{
			if (_x == val)
				return;
			
			_x = val;
		}
		
		/**
		 * 
		 */
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(val:Number):void
		{
			if (_y == val)
				return;
			
			_y = val;
		}
		
		/**
		 * 
		 */
		public function get z():Number
		{
			return _z;
		}
		
		public function set z(val:Number):void
		{
			if (_z == val)
				return;
			
			_z = val;
		}
		
		
		/**
		 * 
		 */
		public function PointLight3D()
		{
			
		}
	}
}
