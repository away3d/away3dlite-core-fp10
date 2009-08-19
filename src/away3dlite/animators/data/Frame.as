package away3dlite.animators.data
{
	import flash.geom.*;

	/**
	 * @author katopz
	 */
	public class Frame
	{
		public var name:String;
		public var vertices:Vector.<Vector3D>;

		/**
		 * Create a new Frame with a name and a set of vertices
		 *
		 * @param name	The name of the frame
		 * @param vertices	An array of Vertex objects
		 */
		public function Frame(name:String, vertices:Vector.<Vector3D>)
		{
			this.name = name;
			this.vertices = vertices;
		}

		public function toString():String
		{
			return "[Frame][name:" + name + "][vertices:" + vertices.length + "]";
		}
	}
}