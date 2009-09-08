package away3dlite.core.base
{
	import flash.geom.Vector3D;
	import away3dlite.arcane;
	import away3dlite.materials.*;
	
	use namespace arcane;
	
	/**
	 * Face
	 * @author katopz
	 */
	public class Face
	{
		private var uvtData:Vector.<Number>;
		
		private var vertices:Vector.<Number>;
		
		private var screenVertices:Vector.<Number>;
		
		// use for refer back to mesh
		public var mesh:Mesh;
		
		public var material:Material;
		
		// index values
		public var index:int;
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
		
		public var normalX:Number;
		
		public var normalY:Number;
		
		public var normalZ:Number;
		
		public function Face(mesh:Mesh, i:int)
		{
			this.mesh = mesh;
			
			index = i;
			
			uvtData = mesh._uvtData;
			
			vertices = mesh._vertices;
			
			screenVertices = mesh._screenVertices;
			
			material = mesh._faceMaterials[i] || mesh.material;
			
			i0 = mesh._indices[int(i*3 + 0)];
			i1 = mesh._indices[int(i*3 + 1)];
			i2 = mesh._indices[int(i*3 + 2)];
			
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
		
		public function calculateAverageZ():int
		{
			return int((uvtData[t0] + uvtData[t1] + uvtData[t2])*100000);
		}
		
		public function calculateFurthestZ():int
		{
			var z:Number = uvtData[t0];
			
			if (z > uvtData[t1])
				z = uvtData[t1];
			
			if (z > uvtData[t2])
				z = uvtData[t2];
			
			return int(z*100000);
		}
		
		public function calculateNearestZ():int
		{
			var z:Number = uvtData[t0];
			
			if (z < uvtData[t1])
				z = uvtData[t1];
			
			if (z < uvtData[t2])
				z = uvtData[t2];
			
			return int(z*100000);
		}
		
		public var calculateScreenZ:Function;
		
		public function calculateUVT(x:Number, y:Number):Vector3D
		{
			var azf:Number = (1/uvtData[t0] - 100)/100;
            var bzf:Number = (1/uvtData[t1] - 100)/100;
            var czf:Number = (1/uvtData[t2] - 100)/100;

            var faz:Number = 1 + azf;
            var fbz:Number = 1 + bzf;
            var fcz:Number = 1 + czf;
            
			var axf:Number = screenVertices[x0]*faz - x*azf;
            var bxf:Number = screenVertices[x1]*fbz - x*bzf;
            var cxf:Number = screenVertices[x2]*fcz - x*czf;
            var ayf:Number = screenVertices[y0]*faz - y*azf;
            var byf:Number = screenVertices[y1]*fbz - y*bzf;
            var cyf:Number = screenVertices[y2]*fcz - y*czf;

            var det:Number = axf*(byf - cyf) + bxf*(cyf - ayf) + cxf*(ayf - byf);
            var da:Number = x*(byf - cyf) + bxf*(cyf - y) + cxf*(y- byf);
            var db:Number = axf*(y - cyf) + x*(cyf - ayf) + cxf*(ayf - y);
            var dc:Number = axf*(byf - y) + bxf*(y - ayf) + x*(ayf - byf);

            return new Vector3D((da*uvtData[u0] + db*uvtData[u1] + dc*uvtData[u2])/det, (da*uvtData[v0] + db*uvtData[v1] + dc*uvtData[v2])/det, (da/uvtData[t0] + db/uvtData[t1] + dc/uvtData[t2])/det);
		}
	}
}