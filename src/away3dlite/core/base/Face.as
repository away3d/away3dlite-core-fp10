package away3dlite.core.base
{
	import flash.geom.Vector3D;
	import away3dlite.arcane;
	import away3dlite.materials.*;
	
	use namespace arcane;
	
	/**
	 * Face value object. Stores information on each face in a mesh.
	 */
	public class Face
	{
		private var uvtData:Vector.<Number>;
		
		private var vertices:Vector.<Number>;
		
		private var screenVertices:Vector.<Number>;
		
		/**
		 * Mesh object to which the face belongs.
		 */
		public var mesh:Mesh;
		
		/**
		 * Material of the face.
		 */
		public var material:Material;
		
		/**
		 * Index value of the face.
		 */
		public var faceIndex:int;
		
		/**
		 * Index value of the first vertex in the face.
		 */
		public var i0:int;
		
		/**
		 * Index value of the second vertex in the face.
		 */
		public var i1:int;
		
		/**
		 * Index value of the third vertex in the face.
		 */
		public var i2:int;
		
		/**
		 * Index value of the fourth vertex in the face.
		 */
		public var i3:int;
		
		/**
		 * x index of the first screen vertex.
		 */
		public var x0:int;
		
		/**
		 * y index of the first screen vertex.
		 */
		public var y0:int;
				
		/**
		 * x index of the second screen vertex.
		 */
		public var x1:int;
				
		/**
		 * y index of the second screen vertex.
		 */
		public var y1:int;
				
		/**
		 * x index of the third screen vertex.
		 */
		public var x2:int;
				
		/**
		 * y index of the third screen vertex.
		 */
		public var y2:int;
				
		/**
		 * x index of the fourth screen vertex.
		 */
		public var x3:int;
				
		/**
		 * y index of the fourth screen vertex.
		 */
		public var y3:int;
		
		/**
		 * u index of the first mapping value.
		 */
		public var u0:int;
		
		/**
		 * v index of the first mapping value.
		 */
		public var v0:int;
		
		/**
		 * t index of the first mapping value.
		 */
		public var t0:int;
				
		/**
		 * u index of the second mapping value.
		 */
		public var u1:int;
				
		/**
		 * v index of the second mapping value.
		 */
		public var v1:int;
				
		/**
		 * t index of the second mapping value.
		 */
		public var t1:int;
						
		/**
		 * u index of the third mapping value.
		 */
		public var u2:int;
						
		/**
		 * v index of the third mapping value.
		 */
		public var v2:int;
						
		/**
		 * t index of the third mapping value.
		 */
		public var t2:int;
						
		/**
		 * u index of the fourth mapping value.
		 */
		public var u3:int;
						
		/**
		 * v index of the fourth mapping value.
		 */
		public var v3:int;
						
		/**
		 * t index of the fourth mapping value.
		 */
		public var t3:int;
		
		/*
		public var normalX:Number;
		
		public var normalY:Number;
		
		public var normalZ:Number;
		*/
		
		public function Face(mesh:Mesh, i:int, index:int, faceLength:int)
		{
			this.mesh = mesh;
			
			faceIndex = i;
			
			uvtData = mesh._uvtData;
			
			vertices = mesh._vertices;
			
			screenVertices = mesh._screenVertices;
			
			material = mesh._faceMaterials[i] || mesh.material;
			
			i0 = mesh._indices[int(index)];
			i1 = mesh._indices[int(index + 1)];
			i2 = mesh._indices[int(index + 2)];
			
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
			
			if (faceLength > 3) {
				i3 = mesh._indices[int(index + 3)];
				x3 = 2*i3;
				y3 = 2*i3 + 1;
				u3 = 3*i3;
				v3 = 3*i3 + 1;
				t3 = 3*i3 + 2;
			}
			/*
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
	        */
		}
		
		/**
		 * selected function for calculating the screen Z coordinate of the face.
		 */
		public var calculateScreenZ:Function;
		
		/**
		 * Returns the average screen Z coordinate of the face.
		 */
		public function calculateAverageZ():int
		{
			return i3? int((uvtData[t0] + uvtData[t1] + uvtData[t2] + uvtData[t3])*1000000) : int((uvtData[t0] + uvtData[t1] + uvtData[t2])*1000000);
		}
		
		/**
		 * Returns the furthest screen Z coordinate of the face.
		 */
		public function calculateFurthestZ():int
		{
			var z:Number = uvtData[t0];
			
			if (z > uvtData[t1])
				z = uvtData[t1];
			
			if (z > uvtData[t2])
				z = uvtData[t2];
			
			if (i3 && z > uvtData[t3])
				z = uvtData[t3];
			
			return int(z*1000000);
		}
		
		/**
		 * Returns the nearest screen Z coordinate of the face.
		 */
		public function calculateNearestZ():int
		{
			var z:Number = uvtData[t0];
			
			if (z < uvtData[t1])
				z = uvtData[t1];
			
			if (z < uvtData[t2])
				z = uvtData[t2];
			
			if (i3 && z < uvtData[t3])
				z = uvtData[t3];
			
			return int(z*1000000);
		}
		
		/**
		 * Returns the uvt coordinate of the face at the given screen coordinate.
		 * 
		 * @param x		The x value of the screen coordinate.
		 * @param y		The y value of the screen coordinate.
		 */
		public function calculateUVT(x:Number, y:Number):Vector3D
		{
			var v0x:Number = vertices[x0];
			var v0y:Number = vertices[y0];
			var v2x:Number = vertices[x2];
			var v2y:Number = vertices[y2];
			
			var ax:Number;
			var ay:Number;
			var az:Number;
			var au:Number;
			var av:Number;
			
			var bx:Number;
			var by:Number;
			var bz:Number;
			var bu:Number;
			var bv:Number;
			
			var cx:Number;
			var cy:Number;
			var cz:Number;
			var cu:Number;
			var cv:Number;
			
			if (i3 && (v0x*(v2y - y) + x*(v0y - v2y) + v2x*(y - v0y)) < 0) {
				az = uvtData[t0];
	            bz = uvtData[t2];
	            cz = uvtData[t3];
	            
				ax = (screenVertices[x0] - x)/az;
	            bx = (screenVertices[x2] - x)/bz;
	            cx = (screenVertices[x3] - x)/cz;
	            ay = (screenVertices[y0] - y)/az;
	            by = (screenVertices[y2] - y)/bz;
	            cy = (screenVertices[y3] - y)/cz;
	            
	            au = uvtData[u0];
	            av = uvtData[v0];
	            bu = uvtData[u2];
	            bv = uvtData[v2];
	            cu = uvtData[u3];
	            cv = uvtData[v3];
			} else {
				az = uvtData[t0];
	            bz = uvtData[t1];
	            cz = uvtData[t2];
	            
				ax = (screenVertices[x0] - x)/az;
	            bx = (screenVertices[x1] - x)/bz;
	            cx = (screenVertices[x2] - x)/cz;
	            ay = (screenVertices[y0] - y)/az;
	            by = (screenVertices[y1] - y)/bz;
	            cy = (screenVertices[y2] - y)/cz;
	            
	            au = uvtData[u0];
	            av = uvtData[v0];
	            bu = uvtData[u1];
	            bv = uvtData[v1];
	            cu = uvtData[u2];
	            cv = uvtData[v2];
			}
            
            var det:Number = ax*(by - cy) + bx*(cy - ay) + cx*(ay - by);
            
            var ad:Number = x*(by - cy) + bx*(cy - y) + cx*(y- by);
            var bd:Number = ax*(y - cy) + x*(cy - ay) + cx*(ay - y);
            var cd:Number = ax*(by - y) + bx*(y - ay) + x*(ay - by);
			
            return new Vector3D((ad*au + bd*bu + cd*cu)/det, (ad*av + bd*bv + cd*cv)/det, (ad/az + bd/bz + cd/cz)/det);
		}
	}
}