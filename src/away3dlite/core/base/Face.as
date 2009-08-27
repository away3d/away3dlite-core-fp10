package away3dlite.core.base
{
	import away3dlite.arcane;
	
	use namespace arcane;
	
	/**
	 * Face
	 * @author katopz
	 */
	public class Face
	{
		private var uvtData:Vector.<Number>;
		
		private var vertices:Vector.<Number>;
		
		// use for refer back to mesh
		public var mesh:Mesh;
		
		// index values
		public var i0:int;
		public var i1:int;
		public var i2:int;
		
		// for faster access
		public var x0:int;
		public var y0:int;
		
		public var x1:int;
		public var y1:int;
		
		public var x2:int;
		public var y2:int;
		
		public var u0:int;
		public var v0:int;
		public var t0:int;
		
		public var u1:int;
		public var v1:int;
		public var t1:int;
		
		public var u2:int;
		public var v2:int;
		public var t2:int;
		
		public var screenT:int;
		
		public var normalX:Number;
		
		public var normalY:Number;
		
		public var normalZ:Number;
		
		public function Face(mesh:Mesh, i0:int, i1:int, i2:int)
		{
			uvtData = mesh._uvtData;
			
			vertices = mesh._vertices;
			
			this.mesh = mesh;
			
			this.i0 = i0;
			this.i1 = i1;
			this.i2 = i2;
			
			x0 = 2*i0;
			y0 = 2*i0 + 1;
			
			x1 = 2*i1;
			y1 = 2*i1 + 1;
			
			x2 = 2*i2;
			y2 = 2*i2 + 1;
			
			u0 = 3*i0;
			v0 = 3*i0 + 1;
			t0 = 3*i0 + 2;
			
			u1 = 3*i1;
			v1 = 3*i1 + 1;
			t1 = 3*i1 + 2;
			
			u2 = 3*i2;
			v2 = 3*i2 + 1;
			t2 = 3*i2 + 2;
			
			var d1x:Number = vertices[u1] - vertices[u0];
	        var d1y:Number = vertices[v1] - vertices[v0];
	        var d1z:Number = vertices[t1] - vertices[t0];
	    
	        var d2x:Number = vertices[u2] - vertices[u0];
	        var d2y:Number = vertices[v2] - vertices[v0];
	        var d2z:Number = vertices[t2] - vertices[t0];
	    
	        var pa:Number = d1y*d2z - d1z*d2y;
	        var pb:Number = d1z*d2x - d1x*d2z;
	        var pc:Number = d1x*d2y - d1y*d2x;
	        
	        var pdd:Number = Math.sqrt(pa*pa + pb*pb + pc*pc);
	
	        normalX = pa / pdd;
	        normalY = pb / pdd;
	        normalZ = pc / pdd;
		}
		
		public function calculateScreenZ():void
		{
			screenT = ((uvtData[t0] + uvtData[t1] + uvtData[t2])*100000);
		}
	}
}