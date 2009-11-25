package away3dlite.primitives
{
	import away3dlite.arcane;
	import away3dlite.materials.*;
	
	import flash.geom.*;

	use namespace arcane;
	
    /**
    * Creates a single 3d line segment.
    */ 
	public class LineSegment extends AbstractPrimitive
	{
		private var _start:Vector3D;
		private var _end:Vector3D;

		/**
		 * @inheritDoc
		 */
		protected override function buildPrimitive():void
		{
			super.buildPrimitive();
			
			_vertices.push(_start.x, _start.y, _start.z);
			_uvtData.push(0, 0, 0);
			
			_vertices.push(_end.x, _end.y, _end.z);
			_uvtData.push(0, 0, 0);
			
			_indices.push(0, 1, 1);
			_faceLengths.push(3);
		}
    	
    	/**
    	 * Defines the starting position of the line segment. Defaults to (0, 0, 0).
    	 */
		public function set start(value:Vector3D):void
		{
			_start.x = value.x;
			_start.y = value.y;
			_start.z = value.z;
			
			_primitiveDirty = true;
		}
		
		public function get start():Vector3D
		{
			return _start;
		}
    	
    	/**
    	 * Defines the ending position of the line segment. Defaults to (100, 100, 100).
    	 */
		public function set end(value:Vector3D):void
		{
			_end.x = value.x;
			_end.y = value.y;
			_end.z = value.z;
			
			_primitiveDirty = true;
		}
		
		public function get end():Vector3D
		{
			return _end;
		}
    	
		/**
		 * Creates a new <code>LineSegment</code> object.
		 * 
		 * @param	material	Defines the global material used on the faces in the plane.
		 * @param	start		Defines the starting position of the line segment.
		 * @param	end			Defines the ending position of the line segment.
		 */
		public function LineSegment(material:Material = null, start:Vector3D = null, end:Vector3D = null)
		{
			super(material);
			
			_start = start || new Vector3D(0, 0, 0);
			_end = end || new Vector3D(100, 100, 100);
			
			this.bothsides = true;
		}
	}
}