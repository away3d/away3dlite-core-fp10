package away3dlite.core.render
{

	import away3dlite.containers.View3D;
	import away3dlite.core.base.*;
	
	/**
	 * @author robbateman
	 */
	public class Renderer
	{
		private var _nextface:Face;
		private var _prevface:Face;
		private var _swapped:Boolean;
		private var _tempSort1:Number;
		private var _tempSort2:Number;
		private var _tempData:Face;
		protected var i:int;
		protected var j:int;
		protected var k:int;
		protected var q0:Vector.<int>;
		protected var q1:Vector.<int>;
		protected var np0:Vector.<int>;
		protected var np1:Vector.<int>;
		protected var sort:Vector.<int>;
		
		//private var q0:Vector.<int> = new Vector.<int>(256, true);
		private var q0l:Vector.<int> = new Vector.<int>(256, true);
		//private var q1:Vector.<int> = new Vector.<int>(256, true);
		private var q1l:Vector.<int> = new Vector.<int>(256, true);
		//private var empty:int = -1;
		protected var _view:View3D;
		
		protected var _face:Face;
		
		protected var _faces:Vector.<Face> = new Vector.<Face>();
		
		protected var _faceStore:Vector.<int> = new Vector.<int>();
		
		protected function sortFaces():void
		{
	        q0 = new Vector.<int>(256, true);
	        q1 = new Vector.<int>(256, true);
	        np0 = new Vector.<int>(_faces.length + 1, true);
	        np1 = new Vector.<int>(_faces.length + 1, true);
	        sort = new Vector.<int>(_faces.length, true);
	        
        	k = 0;
        	i = -1;
            for each (_face in _faces)
                if(!(q0[j = (255 & (sort[int(++i)] = _face.calculateScreenZ()))]))
                    q0l[j] = q0[j] = ++k;
                else
                    q0l[j] = np0[q0l[j]] = ++k;
            
            i = -1;
            while (i < 255) {
            	j = q0[int(++i)];
                while (j) {
                    if(!(q1[k = (65280 & sort[j-1]) >> 8]))
	                    q1l[k] = q1[k] = j;
	                else
	                    q1l[k] = np1[q1l[k]] = j;
	                
	                j = np0[j];
                }
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
		}
		
		/**
		 * 
		 */
		public function render(object:Object3D):void
		{
			
		}
	}
}
