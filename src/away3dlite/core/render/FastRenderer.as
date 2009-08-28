package away3dlite.core.render
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	
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
				
				if (sortMeshes)
					container.children.sortOn("screenZ", 18);
				
				var _child:Object3D;
				
				for each (_child in container.children)
					collectFaces(_child);
				
			} else if (object is Mesh) {
				
				var mesh:Mesh = object as Mesh;
				
				mesh.material.graphicsData[mesh.material.trianglesIndex] = mesh._triangles;
				
				_faces = mesh._faces;
				_indices = mesh._indices;
				_uvtData = mesh._uvtData;
				
				if(!_faces.length)
					return;
				
				if (mesh.sortFaces)
					sortFaces();
				
				_view.graphics.drawGraphicsData(mesh.material.graphicsData);
				
				_view._totalFaces += _faces.length;
				_view._renderedFaces += _faces.length;
			}
			
			_view._totalObjects++;
			_view._renderedObjects++;
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
