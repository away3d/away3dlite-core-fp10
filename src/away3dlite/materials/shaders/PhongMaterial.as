package away3dlite.materials.shaders
{
	import away3dlite.lights.Light;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class PhongMaterial extends VertexShaderMaterial implements IShader
	{
		public function PhongMaterial(light:Light, bitmapData:BitmapData)
		{

			super(light, bitmapData);
		}

		override protected function calculateTexCoord(texCoord:Point, normal:Vector3D, doubleSided:Boolean = false):void
		{
			var v:Vector3D = _light.direction;
			texCoord.x = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.x < 0)
				texCoord.x = (doubleSided) ? -texCoord.x : 0;
			v = _light.halfVector;
			texCoord.y = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.y < 0)
				texCoord.y = (doubleSided) ? -texCoord.y : 0;
		}
	}
}