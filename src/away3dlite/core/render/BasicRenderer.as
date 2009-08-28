package away3dlite.core.render
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	import away3dlite.core.clip.*;
	import away3dlite.materials.*;
	
	import flash.display.*;
	
	use namespace arcane;
	
	/**
	 * @author robbateman
	 */
	public class BasicRenderer extends Renderer
	{
		private var _clipping:Clipping;
		private var _mesh:Mesh;
		private var _screenVertices:Vector.<Number>;
		private var _uvtData:Vector.<Number>;
		private var _ind:Vector.<int>;
		private var _vert:Vector.<Number>;
		private var _uvt:Vector.<Number>;
		private var _material:Material;
		private var _triangles:GraphicsTrianglePath = new GraphicsTrianglePath();
		private var _i:int;
		private var _j:int;
		private var _k:int;
		
		private function collectFaces(object:Object3D):void
		{
			if (object is ObjectContainer3D) {
				var container:ObjectContainer3D = object as ObjectContainer3D;
				
				var _child:Object3D;
				
				for each (_child in container.children)
					collectFaces(_child);
				
			} else if (object is Mesh) {
				var mesh:Mesh = object as Mesh;
				
				_clipping.collectFaces(mesh, _faces);
				
				_view._totalFaces += mesh._faces.length;
			}
			
			_view._totalObjects++;
			_view._renderedObjects++;
		}

		protected override function sortFaces():void
		{
			super.sortFaces();
			
			//reorder indices
			_material = null;
			_mesh = null;
			
			var _view_graphics_drawGraphicsData:Function = _view.graphics.drawGraphicsData;
			
			i = -1;
            while (i++ < 255) {
            	j = q1[i];
                while (j) {
                    _face = _faces[j-1];
					
					if (_material != _face.mesh.material) {
						if (_material) {
							_material.graphicsData[_material.trianglesIndex] = _triangles;
							_view_graphics_drawGraphicsData(_material.graphicsData);
						}
						
						_ind.length = 0;
						_vert.length = 0;
						_uvt.length = 0;
						_i = -1;
						_j = -1;
						_k = -1;
						_mesh = _face.mesh;
						_material = _mesh.material;
						_screenVertices = _mesh._screenVertices;
						_uvtData = _mesh._uvtData;
						_faceStore.length = 0;
						_faceStore.length = _mesh._vertices.length/3;
					} else if (_mesh != _face.mesh) {
						_mesh = _face.mesh;
						_screenVertices = _mesh._screenVertices;
						_uvtData = _mesh._uvtData;
						_faceStore.length = 0;
						_faceStore.length = _mesh._vertices.length/3;
					}
					
					if (_faceStore[_face.i0]) {
						_ind[++_i] = _faceStore[_face.i0] - 1;
					} else {
						_vert[++_j] = _screenVertices[_face.x0];
						_faceStore[_face.i0] = (_ind[++_i] = _j/2) + 1;
						_vert[++_j] = _screenVertices[_face.y0];
						
						_uvt[++_k] = _uvtData[_face.u0];
						_uvt[++_k] = _uvtData[_face.v0];
						_uvt[++_k] = _uvtData[_face.t0];
					}
					
					if (_faceStore[_face.i1]) {
						_ind[++_i] = _faceStore[_face.i1] - 1;
					} else {
						_vert[++_j] = _screenVertices[_face.x1];
						_faceStore[_face.i1] = (_ind[++_i] = _j/2) + 1;
						_vert[++_j] = _screenVertices[_face.y1];
						
						_uvt[++_k] = _uvtData[_face.u1];
						_uvt[++_k] = _uvtData[_face.v1];
						_uvt[++_k] = _uvtData[_face.t1];
					}
					
					if (_faceStore[_face.i2]) {
						_ind[++_i] = _faceStore[_face.i2] - 1;
					} else {
						_vert[++_j] = _screenVertices[_face.x2];
						_faceStore[_face.i2] = (_ind[++_i] = _j/2) + 1;
						_vert[++_j] = _screenVertices[_face.y2];
						
						_uvt[++_k] = _uvtData[_face.u2];
						_uvt[++_k] = _uvtData[_face.v2];
						_uvt[++_k] = _uvtData[_face.t2];
					}
					
					j = np1[j];
                }
			}
		}
		
		/**
		 * 
		 */
		public function BasicRenderer()
		{
			_ind = _triangles.indices = new Vector.<int>();
			_vert = _triangles.vertices = new Vector.<Number>();
			_uvt = _triangles.uvtData = new Vector.<Number>();
		}
		
		/**
		 * 
		 */
		public override function render():void
		{
			super.render();
			
			_scene = _view.scene;
			
			_clipping = _view.screenClipping;
			
			_faces.fixed = false;
			_faces.length = 0;
			
			collectFaces(_scene);
			
			_faces.fixed = true;
			
			_view._renderedFaces = _faces.length;
			
			_scene._dirtyFaces = false;
			
			if (!_faces.length)
				return;
			
			sortFaces();
			
			if (_material) {
				_material.graphicsData[_material.trianglesIndex] = _triangles;
				_view.graphics.drawGraphicsData(_material.graphicsData);
			}
		}
	}
	
}
