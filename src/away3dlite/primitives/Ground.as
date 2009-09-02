package away3dlite.primitives
{
	import away3dlite.arcane;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
    
	use namespace arcane;
	
    /**
    * Creates a 3d ground primitive.
    */ 
    public class Ground extends Plane
    {
     	protected override function buildPrimitive():void
    	{
    		super.buildPrimitive();
    		
    		var m:Matrix3D = new Matrix3D();
    		m.appendRotation(90, Vector3D.X_AXIS);
    		m.transformVectors(_vertices, _vertices);
    	}
    }
}
