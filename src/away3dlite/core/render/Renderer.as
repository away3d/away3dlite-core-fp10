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
