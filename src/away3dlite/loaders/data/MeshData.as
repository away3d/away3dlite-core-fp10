package away3dlite.loaders.data
{
	/**
	 * Data class for the mesh data of a 3d object
	 */
	public class MeshData extends ObjectData
	{
		public var material:MaterialData;
		/**
		 * Defines the geometry used by the mesh instance
		 */
		public var geometry:GeometryData;
		 
		/**
		 *
		 */
		public var skeleton:String;
		
		/**
		 * Duplicates the mesh data's properties to another <code>MeshData</code> object
		 * 
		 * @param	object	The new object instance into which all properties are copied
		 * @return			The new object instance with duplicated properties applied
		 */
		public override function clone(object:ObjectData):void
		{
			super.clone(object);
			
			var mesh:MeshData = (object as MeshData);
			
			mesh.material = material;
			mesh.geometry = geometry;
			mesh.skeleton = skeleton;
		}
	}
}