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
		private var _x:Number;
		private var _y:Number;
		
		private function collectParticles(object:Object3D):void
		{
			if (object is ObjectContainer3D) {
				var children:Array = (object as ObjectContainer3D).children;
				var child:Object3D;
				
				for each (child in children) 
				{
					if(child.layer)
						child.layer.graphics.clear();
					
					collectParticles(child);
				}
					
			}else if (object is Particles) {
				var _particles_lists:Array = (object as Particles).lists;
				
				if(_particles_lists.length>0)
					_particles = _particles.concat(_particles_lists);
			}
		}
		
		private function collectFaces(object:Object3D):void
		{
			_mouseEnabledArray.push(_mouseEnabled);
			_mouseEnabled = object._mouseEnabled = (_mouseEnabled && object.mouseEnabled);
			
			if (object is ObjectContainer3D) {
				var children:Array = (object as ObjectContainer3D).children;
				var child:Object3D;
				
				if (sortObjects)
					children.sortOn("screenZ", 18);
				
				for each (child in children) 
				{
					if(child.canvas)
					{
						var _child_canvas:Sprite = child.canvas;
						_child_canvas.parent.setChildIndex(_child_canvas, children.indexOf(child));
						_child_canvas.graphics.clear();
					}
					collectFaces(child);
				}
				
			} else if (object is Mesh) {
				
				var mesh:Mesh = object as Mesh;
				var _mesh_material:Material = mesh.material;
				var _mesh_material_graphicsData:Vector.<IGraphicsData> = _mesh_material.graphicsData;
				
				_mesh_material_graphicsData[_mesh_material.trianglesIndex] = mesh._triangles;
				
				_faces = mesh._faces;
				_sort = mesh._sort;
				_indices = mesh._indices;
				_uvtData = mesh._uvtData;
				
				if(!_faces.length)
					return;
				
				if (_view.mouseEnabled && _mouseEnabled)
					collectScreenVertices(mesh);
				
				if (mesh.sortFaces)
					sortFaces();
				
				drawParticles(object.screenZ);
				
				if(object.layer)
				{
					object.layer.graphics.drawGraphicsData(_mesh_material_graphicsData);
				}
				else if(object.canvas)
				{
					object.canvas.graphics.drawGraphicsData(_mesh_material_graphicsData);
				}else{
					_view_graphics_drawGraphicsData(_mesh_material_graphicsData);
				}
				
				var _faces_length:int = _faces.length;
				_view._totalFaces += _faces_length;
				_view._renderedFaces += _faces_length;
			}
			
			_mouseEnabled = _mouseEnabledArray.pop();
			
			++_view._totalObjects;
			++_view._renderedObjects;
		}
		
		private function collectPointFaces(object:Object3D):void
		{
			if (object is ObjectContainer3D) {
				var children:Array = (object as ObjectContainer3D).children;
				var child:Object3D;
				
				for each (child in children)
					collectPointFaces(child);
				
			} else if (object is Mesh) {
				var mesh:Mesh = object as Mesh;
				
				_faces = mesh._faces;
				_sort = mesh._sort;
				
				collectPointFace(_x, _y);
			}
		}
		
		/** @private */
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
		
		/**
		 * @inheritDoc
		 */
		public override function getFaceUnderPoint(x:Number, y:Number):Face
		{
			_x = x;
			_y = y;
			
			collectPointVertices(x, y);
			
			_screenZ = 0;
			
			collectPointFaces(_scene);
			
			return _pointFace;
		}
			
		/**
		 * Creates a new <code>FastRenderer</code> object.
		 */
		public function FastRenderer()
		{
			sortObjects = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function render():void
		{
			super.render();
			
			collectParticles(_scene);
			
			// sort merged particles
			_particles.sortOn("screenZ", 18);
				
			collectFaces(_scene);
			
			// draw front
			drawParticles();
		}
	}
}
