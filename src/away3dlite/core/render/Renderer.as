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
		private var _screenT:Number;
		private var _i:int;
		private var _j:int;
		private var _k:int;
		private var q:Vector.<int> = new Vector.<int>(256, true);
		private var ql:Vector.<int> = new Vector.<int>(256, true);
		private var empty:int = -1;
		protected var _view:View3D;
		
		protected function shellSort(data:Vector.<Face>, sort:Vector.<Number>):void
		{
			var n:int = data.length;
			var inc:int = int(n/2);
			while(inc) {
				for(_i = inc; _i < n; _i++) {
					_tempSort1 = sort[_i];
					_tempData = data[_i];
					_j = _i;
					
					while(_j >= inc && (_tempSort2 = sort[_k = _j - inc]) > _tempSort1) {
						sort[_j] = _tempSort2;
						data[_j] = data[_k];
						_j = _k;
					}
					sort[_j] = _tempSort1;
					data[_j] = _tempData;
				}
				
				inc = int(inc / 2);
			}			
			/*
			while(inc) {
				
				for(_i; _i<n; ++_i) {
					_tempSort1 = sort[_i];
					_tempData = data[_i];
					_j = _i;
					while(_j >= inc && (_tempSort2 = sort[int(_j - inc)]) > _tempSort1) {
						
						sort[_j] = _tempSort2;
						data[_j] = data[_j - inc];
						
						_j = _j - inc;
					}
					
					sort[_j] = _tempSort1;
					data[_j] = _tempData;
				}
				
				inc = int(inc / 2.2);
			}
			var n:int = faces.length;
			for (_i = 0; _i < n-1; _i++) {
				if (faces[_i].screenT > faces[_i + 1].screenT) {
					_temp = faces[_i];
					faces[_i] = faces[_i + 1];
					faces[_i + 1] = _temp;
				}
			}
			var n:int = data.length;
			
			var inc:int = int(n/2);
			
			while(inc) {
				for(_i = inc; _i < n; _i++) {
					
					_temp = data[_i];
					_screenT = _temp.screenT;
					_j = _i;
					
					while(_j >= inc && (data[int(_j - inc)] as Face).screenT > _screenT) {
						data[_j] = data[int(_j - inc)];
						_j = int(_j - inc);
					}
					
					data[_j] = _temp;
				}
				
				inc = int(inc / 2.2);
			}
			 
			 */
		}
		
		public function radixSort(data:Vector.<Face>):void
		{
	        var i:int, j:int, k:int, l:int, m:int, _q_length:int, _data_length:int = data.length, np0:Vector.<Face> = new Vector.<Face>(_data_length, true), np1:Vector.<int> = new Vector.<int>(_data_length, true);
	        
	        for(k = 0; k < 16; k += 8) {
	        	
	        	l = 255 << k;
	        	
	            for(i = 0; i < _data_length; np0[i] = data[i], np1[int(i++)] = empty)
	                if(q[j = (l & data[i].screenT) >> k] == empty)
	                    ql[j] = q[j] = i;
	                else
	                    ql[j] = np1[ql[j]] = i;
	            
	            _q_length = q.length;
	            for(m = q[i = j = 0]; i < _q_length; q[int(i++)] = empty)
	                for(m = q[i]; m != empty; m = np1[m])
	                    data[int(j++)] = np0[m];
	        }
	    }
		
		function Renderer()
		{
			var _q_length:int = q.length;
			for(var i:int = 0; i < _q_length; q[int(i++)] = -1);
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
