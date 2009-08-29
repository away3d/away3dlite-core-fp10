package away3dlite.core.render
{

	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.core.base.*;
	
	/**
	 * @author robbateman
	 */
	public class Renderer
	{
		private var ql:Vector.<int> = new Vector.<int>(256, true);
		
		protected var i:int;
		protected var j:int;
		protected var k:int;
		protected var q0:Vector.<int>;
		protected var q1:Vector.<int>;
		protected var np0:Vector.<int>;
		protected var np1:Vector.<int>;
		protected var sort:Vector.<int>;
		protected var _view:View3D;
		protected var _scene:Scene3D;
		protected var _face:Face;
		protected var _faces:Vector.<Face> = new Vector.<Face>();
		protected var _faceStore:Vector.<int> = new Vector.<int>();
		
		// by pass
		protected var _view_graphics_drawGraphicsData:Function;
		
		protected function sortFaces():void
		{
	        var _faces_length:int = _faces.length;
	        
	        q0 = new Vector.<int>(256, true);
	        q1 = new Vector.<int>(256, true);
	        np0 = new Vector.<int>(_faces.length + 1, true);
	        np1 = new Vector.<int>(_faces.length + 1, true);
	        sort = new Vector.<int>(_faces.length, true);
	        
        	i = -1;
        	j = 0;
            for each (_face in _faces)
                if((q0[k = (255 & (sort[int(++i)] = _face.calculateScreenZ()))]))
                    ql[k] = np0[ql[k]] = ++j;
                else
                    ql[k] = q0[k] = ++j;
            
            i = -1;
            while (i++ < 255) {
            	j = q0[i];
                while (j)
                    if((q1[k = (65280 & sort[j-1]) >> 8]))
	                    j = np0[ql[k] = np1[ql[k]] = j];
	                else
	                    j = np0[ql[k] = q1[k] = j];
            }
		}
		
		function Renderer()
		{
		}
		
		/**
		 * 
		 */
		public function setView(view:View3D):void
		{
			_view = view;
			_view_graphics_drawGraphicsData = _view.graphics.drawGraphicsData;
		}
		
		/**
		 * 
		 */
		public function render():void
		{
		}
	}
}
