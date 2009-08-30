package away3dlite.core.render
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	import away3dlite.materials.Material;
	
	import flash.display.*;
	
	use namespace arcane;
	
	/**
	 * @author robbateman
	 */
	public class FastRenderer extends Renderer
	{
		private var _indices:Vector.<int>;
		private var _uvtData:Vector.<Number>;
		private var _i:int;
		
		private function collectFaces(object:Object3D):void
		{
			if (object is ObjectContainer3D) {
				var container:ObjectContainer3D = object as ObjectContainer3D;
				var _container_children:Array = container.children;
				
				if (sortMeshes)
					_container_children.sortOn("screenZ", 18);
				
				var _child:Object3D;
				
				for each (_child in _container_children)
				{
					if(_child.layer)
						_child.layer.graphics.clear();
					
					collectFaces(_child);
				}
				
			} else if (object is Mesh) {
				
				var mesh:Mesh = object as Mesh;
				var _mesh_material:Material = mesh.material;
				var _mesh_material_graphicsData:Vector.<IGraphicsData> = _mesh_material.graphicsData;
				
				_mesh_material_graphicsData[_mesh_material.trianglesIndex] = mesh._triangles;
				
				_faces = mesh._faces;
				_indices = mesh._indices;
				_uvtData = mesh._uvtData;
				
				if(!_faces.length)
					return;
				
				if (mesh.sortFaces)
					sortFaces();
				
				if(object.layer)
				{
					object.layer.graphics.drawGraphicsData(_mesh_material_graphicsData);
				}else{
					_view_graphics_drawGraphicsData(_mesh_material_graphicsData);
				}
				
				var _faces_length:int = _faces.length;
				_view._totalFaces += _faces_length;
				_view._renderedFaces += _faces_length;
			}
			
			++_view._totalObjects;
			++_view._renderedObjects;
		}
		
		protected override function sortFaces():void
		{
			super.sortFaces();
			
			i = -1;
			_i = -1;
            while (i++ < 255) {
            	j = q1[i];
                while (j) {
                    _face = _faces[j-1];
                    _indices[int(++_i)] = _face.i0;
					_indices[int(++_i)] = _face.i1;
					_indices[int(++_i)] = _face.i2;
					
					j = np1[j];
                }
            }
		}
		
		public var sortMeshes:Boolean = true;
		
		/**
		 * 
		 */
		public function FastRenderer()
		{
			
		}
		
		/**
		 * 
		 */
		public override function render():void
		{
			_scene = _view.scene;
			
			collectFaces(_scene);
		}
	}
}
