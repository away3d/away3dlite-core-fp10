package away3dlite.animators.data
{
	import flash.geom.Vector3D;
	
	/**
	 * Old Face Style, to be merge with new Face style
	 * @author katopz
	 */
	public class FaceData
	{
		public var a:uint;
		public var b:uint;
		public var c:uint;

		public var v0:Vector3D;
		public var v1:Vector3D;
		public var v2:Vector3D;
		
		public var uvMap:Vector.<UV>;

		public function FaceData(a:uint, b:uint, c:uint, v:Vector.<Vector3D>, uvMap:Vector.<UV> = null)
		{
			this.a = a;
			this.b = b;
			this.c = c;

			this.v0 = v[a];
			this.v1 = v[b];
			this.v2 = v[c];

			this.uvMap = uvMap;
		}

		public function getNormal():Vector3D
		{
			// TODO : optimize
			var ab:Vector3D = new Vector3D(v1.x - v0.x, v1.y - v0.y, v1.z - v0.z);
			var ac:Vector3D = new Vector3D(v2.x - v0.x, v2.y - v0.y, v2.z - v0.z);
			var n:Vector3D = ac.crossProduct(ab);
			n.normalize();
			return n;
		}
	}
}
