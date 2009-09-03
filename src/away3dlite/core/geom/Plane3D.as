package away3dlite.core.geom
{
    import away3dlite.core.base.*;
    
    import flash.geom.Vector3D;
    
    /** Plane in 3D space */
    public class Plane3D
    {
    	private var _len:Number;
    	
    	public static const FRONT:int = 1;
    	public static const BACK:int = -1;
    	public static const INTERSECT:int = 0;
    	public static const EPSILON:Number = 0.001;
    	
    	
    	/**
    	 * The A coefficient of this plane. (Also the x dimension of the plane normal)
    	 */
        public var a:Number;

    	/**
    	 * The B coefficient of this plane. (Also the y dimension of the plane normal)
    	 */   
        public var b:Number;
    
    	/**
    	 * The C coefficient of this plane. (Also the z dimension of the plane normal)
    	 */    	
        public var c:Number;

    	/**
    	 * The D coefficient of this plane. (Also the inverse dot product between normal and point)
    	 */
        public var d:Number;
	
	
		//arbitrary point on this plane, only avail during closest computation
    	private var _point:Vector3D = new Vector3D();
		
		/**
		 * Create a Plane3D with ABCD coefficients
		 */
        public function Plane3D(a:Number=0, b:Number=0, c:Number=0, d:Number=0)
        {
            this.a = a;
            this.b = b;
            this.c = c;
            this.d = d;
        }

		/**
		 * Fills this Plane3D with the coefficients from 3 points in 3d space.
		 * @param p0 Vector3D
		 * @param p1 Vector3D
		 * @param p2 Vector3D
		 */
        public function from3points(p0:Vector3D, p1:Vector3D, p2:Vector3D):void
        {
            var d1x:Number = p1.x - p0.x;
            var d1y:Number = p1.y - p0.y;
            var d1z:Number = p1.z - p0.z;

            var d2x:Number = p2.x - p0.x;
            var d2y:Number = p2.y - p0.y;
            var d2z:Number = p2.z - p0.z;

            a = d1y*d2z - d1z*d2y;
            b = d1z*d2x - d1x*d2z;
            c = d1x*d2y - d1y*d2x;
            d = - (a*p0.x + b*p0.y + c*p0.z);
        }
        
        /**
		 * Fills this Plane3D with the coefficients from 3 vertices in 3d space.
		 * @param v0 Vector3D
		 * @param v1 Vector3D
		 * @param v2 Vector3D
		 */
        public function from3vertices(v0:Vector3D, v1:Vector3D, v2:Vector3D):void
        {
            var d1x:Number = v1.x - v0.x;
            var d1y:Number = v1.y - v0.y;
            var d1z:Number = v1.z - v0.z;

            var d2x:Number = v2.x - v0.x;
            var d2y:Number = v2.y - v0.y;
            var d2z:Number = v2.z - v0.z;

            a = d1y*d2z - d1z*d2y;
            b = d1z*d2x - d1x*d2z;
            c = d1x*d2y - d1y*d2x;
            d = - (a*v0.x + b*v0.y + c*v0.z);
        }
        
        /**
		 * Fills this Plane3D with the coefficients from the plane's normal and a point in 3d space.
		 * @param normal Vector3D
		 * @param point  Vector3D
		 */
        public function fromNormalAndPoint( normal:Vector3D, point:Vector3D):void
        {
        	a = normal.x;
        	b = normal.y;
        	c = normal.z;
        	d = -(a*point.x + b*point.y + c*point.z);
        	
        	_point = normal;
        }
	
		/**
		 * Normalize this Plane3D
		 * @return Plane3D This Plane3D.
		 */
		public function normalize():Plane3D
		{
			var len:Number = Math.sqrt(a*a + b*b + c*c);
			a /= len;
			b /= len;
			c /= len;
			d /= len;
			return this;
		}
		
		/**
		 * Returns the signed distance between this Plane3D and the point p.
		 * @param p Vector3D
		 * @returns Number
		 */
        public function distance(p:Vector3D):Number
        {	
        	_len = a*p.x + b*p.y + c*p.z + d;
        	if ((_len > -EPSILON) && (_len < EPSILON))
                _len = 0;
            
            return _len;
        }

		/**
		 * Classify a point against this Plane3D. (in front, back or intersecting)
		 * @param p Vector3D
		 * @return int Plane3.FRONT or Plane3D.BACK or Plane3D.INTERSECT
		 */
		public function classifyPoint(p:Vector3D):int
		{
			var len:Number = a*p.x + b*p.y + c*p.z + d;
            if((len > -EPSILON) && (len < EPSILON)) 
            	return Plane3D.INTERSECT;
            else if(len < 0)
            	return Plane3D.BACK;
            else if(len > 0)
            	return Plane3D.FRONT;
            else 
            	return Plane3D.INTERSECT;
		}

		
		/**
		 * Finds the closest point on this Plane3 in relation to point.
		 * XXX Untested
		 * @param point Vector3D
		 * @return Vector3D
		 */
		public function closestPointFrom(point:Vector3D):Vector3D
		{
			//first find an arbitrary point on this plane
			_point.x = 0;
			_point.y = 0;
		
			if(c != 0)
				_point.z = -d/c;
			else
				_point.z = -d/b;
			
			//then compute
			var closest:Vector3D = point.subtract(_point);
			
			var len:Number = (a*_point.x + b*_point.y + c*_point.z);
			
			closest.x -= len*a;
			closest.y -= len*b;
			closest.z -= len*c;
			
			return closest;
		}
		
		public function getIntersectionLineNumbers( v0: Vector3D, v1: Vector3D ): Vector3D
		{
			var d0: Number = _point.x * v0.x + _point.y * v0.y + _point.z * v0.z - d;
			var d1: Number = _point.x * v1.x + _point.y * v1.y + _point.z * v1.z - d;
			var m: Number = d1 / ( d1 - d0 );
			
			return new Vector3D(

					v1.x + ( v0.x - v1.x ) * m,

					v1.y + ( v0.y - v1.y ) * m,

					v1.z + ( v0.z - v1.z ) * m

				);
		}
		
		public function getIntersectionLine( v0: Vector3D, v1: Vector3D ): Vector3D
		{
			var d0: Number = _point.x * v0.x + _point.y * v0.y + _point.z * v0.z - d;
			var d1: Number = _point.x * v1.x + _point.y * v1.y + _point.z * v1.z - d;
			var m: Number = d1 / ( d1 - d0 );
			return new Vector3D(

					v1.x + ( v0.x - v1.x ) * m,

					v1.y + ( v0.y - v1.y ) * m,

					v1.z + ( v0.z - v1.z ) * m

				);

		}
		
		/**
		 * Transform this plane with the 4x4 transform matrix m4x4.
		 * XXX Untested
		 *
		public function transform(mat:Matrix3D):void
		{
			var ta:Number = a;
			var tb:Number = b;
			var tc:Number = c;
			var td:Number = d;
			
			//_mt.inverse4x4(m4x4);
			
			a = ta*mat.sxx + tb*mat.syx + tc*mat.szx + td*mat.swx;
			b = ta*mat.sxy + tb*mat.syy + tc*mat.szy + td*mat.swy;
			c = ta*mat.sxz + tb*mat.syz + tc*mat.szz + td*mat.swz;
			d = ta*mat.tx + tb*mat.ty + tc*mat.tz + td*mat.tw;
			
			normalize();
		}
		*/
    }
}
