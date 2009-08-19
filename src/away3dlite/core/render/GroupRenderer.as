package away3dlite.core.render
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	
	use namespace arcane;
	
	/**
	 * @author robbateman
	 */
	public class GroupRenderer implements IRenderer
	{
		private var _view:View3D;
		private var _face:Face;
		private var _faces:Array;
		private var _indices:Vector.<int>;
		private var _uvtData:Vector.<Number>;
		private var _i:int;
		
		/**
		 * 
		 */
		public function GroupRenderer()
		{
			
		}
		
		/**
		 * 
		 */
		public function setView(view:View3D):void
		{
			_view = view;
		}
		
		/**
		 * 
		 */
		public function render(object:Object3D):void
		{
			
			if (object is ObjectContainer3D) {
				var container:ObjectContainer3D = object as ObjectContainer3D;
				
				container.children.sortOn("screenZ", 18);
				
				var _child:Object3D;
				
				for each (_child in container.children)
					render(_child);
				
			} else if (object is Mesh) {
				
				var mesh:Mesh = object as Mesh;
				
				mesh.material.graphicsData[mesh.material.trianglesIndex] = mesh._triangles;
				
				_faces = mesh.faces;
				_indices = mesh._indices;
				_uvtData = mesh._uvtData;
				
				if(!_faces.length)
					return;
				
				// get last depth after projected
				for each (_face in _faces)
					_face.calculateScreenZ();
				
				// sortOn (faster than Vector.sort)
				_faces.sortOn("screenT", 16);
				
				//reorder indices
				_i = -1;
				for each(_face in _faces) {
					_indices[int(++_i)] = _face.i0;
					_indices[int(++_i)] = _face.i1;
					_indices[int(++_i)] = _face.i2;
				}
				
				_view.graphics.drawGraphicsData(mesh.material.graphicsData);
			}
		}
	}
	
}
