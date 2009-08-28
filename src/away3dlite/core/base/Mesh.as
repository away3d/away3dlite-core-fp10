package away3dlite.core.base
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.materials.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * @author robbateman
	 */
	public class Mesh extends Object3D
	{
		/** @private */
		arcane var _screenVertices:Vector.<Number>;
		/** @private */
		arcane var _uvtData:Vector.<Number>;
		/** @private */
		arcane var _indices:Vector.<int>;
		/** @private */
		arcane var _triangles:GraphicsTrianglePath = new GraphicsTrianglePath();
		/** @private */
		arcane var _faces:Vector.<Face> = new Vector.<Face>();
		/** @private */
		arcane var _vertices:Vector.<Number> = new Vector.<Number>();
		/** @private */
		arcane override function updateScene(val:Scene3D):void
		{
			if (scene == val)
				return;
			
			_scene = val;
		}
		
		
		private var _material:Material;
		private var _bothsides:Boolean;
		
		public var sortFaces:Boolean = true;
		
		/**
		 * 
		 */
		public function get vertices():Vector.<Number>
		{
			return _vertices;
		}
		
		/**
		 * 
		 */
		public function get faces():Vector.<Face>
		{
			return _faces;
		}
		
		/**
		 * 
		 */
		public function buildFaces():void
		{
			_faces.length = 0;
			var i:int = _faces.length = _indices.length/3;
			
			while (i--) {
				// 3 point of face 
				var i3:int = int(i*3);
				_faces[i] = new Face(this, _indices[int(i3 + 0)], _indices[int(i3 + 1)], _indices[int(i3 + 2)]);
			}
			
			// speed up
			_vertices.fixed = true;
			_uvtData.fixed = true;
			_indices.fixed = true;
			
			// calculate normals for the shaders
			//if (_material is IShader)
 			//	IShader(_material).calculateNormals(vertices, _triangles.indices, uvtData, _vertexNormals);
 			if (_scene)
 				_scene._dirtyFaces = true;
		}
		
		/**
		 * 
		 */
		public function get material():Material
		{
			return _material;
		}
		public function set material(val:Material):void
		{
			if (_material == val)
				return;
			
			_material = val;
		}
		
		/**
		 * 
		 */
		public function get bothsides():Boolean
		{
			return _bothsides;
		}
		public function set bothsides(val:Boolean):void
		{
			_bothsides = val;
			
			if (_bothsides) {
				_triangles.culling = TriangleCulling.NONE;
			} else {
				_triangles.culling = TriangleCulling.POSITIVE;
			}
		}
		
		
		/**
		 * 
		 */
		public function Mesh()
		{
			super();
			
			//default value for matrix3d
			transform.matrix3D = new Matrix3D();
			
			// private use
			_screenVertices = _triangles.vertices = new Vector.<Number>();
			_uvtData = _triangles.uvtData = new Vector.<Number>();
			_indices = _triangles.indices = new Vector.<int>();
			
			bothsides = false;
			material = new ColorMaterial();
		}
		
		/**
		 * 
		 */
		public override function project(parentMatrix3D:Matrix3D):void
		{
			super.project(parentMatrix3D);
			
			Utils3D.projectVectors(_viewTransform, vertices, _screenVertices, _uvtData);
		}
	}
}
