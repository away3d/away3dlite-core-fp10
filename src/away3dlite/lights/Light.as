package away3dlite.lights
{
	import away3dlite.materials.ColorMaterial;
	import away3dlite.primitives.Sphere;
	
	import flash.geom.Vector3D;

	/**
	 * @author kris
	 */
	public class Light extends Sphere
	{
		public var direction:Vector3D = new Vector3D();
		public var halfVector:Vector3D = new Vector3D();

		public function Light()
		{
			updatePosition();
			
			radius = 10;
			segmentsW = 5;
			segmentsH = 5;
			material = new ColorMaterial(0xFFFFFF);
		}

		override public function set x(value:Number):void
		{
			super.x = value;
			updatePosition();
		}

		override public function set y(value:Number):void
		{
			super.y = value;
			updatePosition();
		}

		override public function set z(value:Number):void
		{
			super.z = value;
			updatePosition();
		}

		public function updatePosition():void
		{
			direction.x = this.x * -1;
			direction.y = this.y * -1;
			direction.z = this.z * -1;
			direction.normalize();
			halfVector.x = direction.x;
			halfVector.y = direction.y;
			halfVector.z = direction.z + 1;
			halfVector.normalize();
		}

		public function setPosition(x:Number, y:Number, z:Number):void
		{
			super.x = x;
			super.y = y;
			super.z = z;
			updatePosition();
		}
	}
}