package away3dlite.primitives
{
	import away3dlite.arcane;
	import away3dlite.materials.Material;
    
	use namespace arcane;
	
    /**
    * Creates a 3d sphere primitive.
    */ 
    public class Sphere extends AbstractPrimitive
    {
        private var _radius:Number = 100;
        private var _segmentsW:int = 8;
        private var _segmentsH:int = 6;
        private var _yUp:Boolean = true;
        
        /**
         * for away3d user
         * @param object
         * 
         */        
        public function init(object:Object):Sphere
        {
        	for(var data:* in object)
	        	try{
	      			this[data] = object[data];
	        	}catch(e:*){trace(e)};
	        return this;
		}
        
        /**
         * for other engine user
         * @param material
         * @param radius
         * @param segmentsW
         * @param segmentsH
         * 
         */
        public function create(material:Material=null, radius:Number=100, segmentsW:int=8, segmentsH:int=6):Sphere
        {
        	this.material = material;
        	this.radius = radius;
        	this.segmentsW = segmentsW;
        	this.segmentsH = segmentsH;
        	return this;
        }
        
		/**
		 * @inheritDoc
		 */
    	protected override function buildPrimitive():void
    	{
    		super.buildPrimitive();
    		
            var i:int;
            var j:int;

            for (j = 0; j <= _segmentsH; ++j) { 
                var horangle:Number = Math.PI*j/_segmentsH;
                var z:Number = -_radius*Math.cos(horangle);
                var ringradius:Number = _radius*Math.sin(horangle);
                
                for (i = 0; i <= _segmentsW; ++i) { 
                    var verangle:Number = 2*Math.PI*i/_segmentsW;
                    var x:Number = ringradius*Math.cos(verangle);
                    var y:Number = ringradius*Math.sin(verangle);
                    
                    _yUp? _vertices.push(x, -z, y) : _vertices.push(x, y, z);
                    
                    _uvtData.push(i/_segmentsW, 1 - j/_segmentsH, 1);
                }
            }
            
            for (j = 1; j <= _segmentsH; ++j) {
                for (i = 1; i <= _segmentsW; ++i) {
                    var a:int = (_segmentsW + 1)*j + i;
                    var b:int = (_segmentsW + 1)*j + i - 1;
                    var c:int = (_segmentsW + 1)*(j - 1) + i - 1;
                    var d:int = (_segmentsW + 1)*(j - 1) + i;
                    
                    if (j < _segmentsH)
                    	_indices.push(a,b,c);
                    if (j > 1)
						_indices.push(a,c,d);
                }
            }
    	}
    	
    	/**
    	 * Defines the radius of the sphere. Defaults to 100.
    	 */
    	public function get radius():Number
    	{
    		return _radius;
    	}
    	
    	public function set radius(val:Number):void
    	{
    		if (_radius == val)
    			return;
    		
    		_radius = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of horizontal segments that make up the sphere. Defaults to 8.
    	 */
    	public function get segmentsW():Number
    	{
    		return _segmentsW;
    	}
    	
    	public function set segmentsW(val:Number):void
    	{
    		if (_segmentsW == val)
    			return;
    		
    		_segmentsW = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of vertical segments that make up the sphere. Defaults to 1.
    	 */
    	public function get segmentsH():Number
    	{
    		return _segmentsH;
    	}
    	
    	public function set segmentsH(val:Number):void
    	{
    		if (_segmentsH == val)
    			return;
    		
    		_segmentsH = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines whether the coordinates of the sphere points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
    	 */
    	public function get yUp():Boolean
    	{
    		return _yUp;
    	}
    	
    	public function set yUp(val:Boolean):void
    	{
    		if (_yUp == val)
    			return;
    		
    		_yUp = val;
    		_primitiveDirty = true;
    	}
		
		/**
		 * Creates a new <code>Sphere</code> object.
		 *
		 * @param	init			[optional]	An initialisation object for specifying default instance properties.
		 */
        public function Sphere(object:Object=null)
        {
            super();
            
            if(object)
            	init(object);
			
			type = "Sphere";
        	url = "primitive";
        }
    }
}