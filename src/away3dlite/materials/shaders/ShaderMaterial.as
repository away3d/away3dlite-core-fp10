package away3dlite.materials.shaders 
{
	
	import open3d.geom.Vertex;
	import flash.geom.Vector3D;
	import open3d.objects.Light;
	import open3d.materials.BitmapMaterial;
	import away3dlite.materials.shaders.IShader;

	import flash.display.BitmapData;
	import flash.geom.Matrix3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class ShaderMaterial extends BitmapMaterial implements IShader 
	{
		protected var _light : Light;
		protected var normals : Vector.<Vector3D>;
		protected var vertices : Vector.<Vertex>;
		protected var _verticesIn : Vector.<Number>;
		protected var faceNormals : Vector.<Vector3D>;
		
		public function ShaderMaterial(light:Light,bitmapData : BitmapData)
		{
			_light =light;
			super(bitmapData);
		}
		
		public function calculateNormals(verticesIn : Vector.<Number>,indices : Vector.<int>,uvtData:Vector.<Number> =null,vertexNormals:Vector.<Number> =null) : void
		{
			
			
			_verticesIn =verticesIn;
			var trianglesLength : int = indices.length / 3;
			faceNormals = new Vector.<Vector3D>(trianglesLength, true);
			vertices = new Vector.<Vertex>(_verticesIn.length / 3, true);
			
			var vec1 : Vector3D = new Vector3D();
			var vec2 : Vector3D = new Vector3D();
			var vec3 : Vector3D = new Vector3D();
			var ind1 : int;
			var ind2 : int;
			var ind3 : int;
			for (var i : int = 0;i < trianglesLength; i++) 
			{
				
				ind1 = indices[i * 3] * 3	;		
				vec1.x =_verticesIn[ind1];	
				vec1.y = _verticesIn[ind1 + 1];
				vec1.z =_verticesIn[ind1 + 2];
				
				ind2 = indices[i * 3 + 1] * 3;
				vec2.x = _verticesIn[ind2];	
				vec2.y = _verticesIn[ind2 + 1];
				vec2.z = _verticesIn[ind2 + 2];
				
				
				ind3 = indices[i * 3 + 2] * 3;
				vec3.x = _verticesIn[ind3];	
				vec3.y = _verticesIn[ind3 + 1];
				vec3.z = _verticesIn[ind3 + 2];
				
				
				var faceNormal : Vector3D = calculateNormal(vec1, vec2, vec3);
			
				faceNormals[i] = faceNormal;
				
				vertices[ind1/3] = addNormal(vertices[ind1/3], faceNormal);
				vertices[ind2/3 ] = addNormal(vertices[ind2/3], faceNormal);
				vertices[ind3/3] = addNormal(vertices[ind3/3], faceNormal);
			}
		}
		private function addNormal(v : Vertex, faceNormal : Vector3D) : Vertex 
		{
			if (v == null) v = new Vertex();
		
			v.addFaceNormal(faceNormal);
			return v;
		}
		public function calculateNormal(vec1 : Vector3D,vec2 : Vector3D,vec3 : Vector3D) : Vector3D 
		{
			var normal : Vector3D = new Vector3D();
			var dif1 : Vector3D = vec2.subtract(vec1);
			var dif2 : Vector3D = vec3.subtract(vec1);
			normal = dif1.crossProduct(dif2);
			
			normal.normalize();
			return normal;
		}
		public function getUVData(m : Matrix3D) : Vector.<Number>
		{
			//throw new IllegalOperationError("ShaderMaterial: override getUVData");
			
			return null;
		}
	}
}
