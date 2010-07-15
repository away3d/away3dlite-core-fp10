package away3dlite.containers
{
	import away3dlite.lights.AbstractLight3D;
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	import away3dlite.core.base.*;
	import away3dlite.materials.*;
	
	import flash.geom.*;
	import flash.display.*;
	
	use namespace arcane;
	
    /**
    * The root container of all 3d objects in a single scene
    */
	public class Scene3D extends ObjectContainer3D
	{
		private var _index:int;
		
		arcane var _id:uint;
		/** @private */
		arcane var _broadcaster:Sprite = new Sprite();
    	/** @private */
    	arcane var _materialsSceneList:Vector.<Material> = new Vector.<Material>();
    	/** @private */
    	arcane var _materialsPreviousList:Vector.<Material> = new Vector.<Material>();
    	/** @private */
    	arcane var _materialsNextList:Vector.<Material> = new Vector.<Material>();
    	/** @private */
    	arcane var _sceneLights:Vector.<AbstractLight3D> = new Vector.<AbstractLight3D>();
    	/** @private */
    	arcane function removeSceneMaterial(mat:Material):void
    	{
    		
    		if (!(--mat._faceCount[_id])) {
    			
    			_materialsSceneList[mat._id[_id]] = null;
    			
    			//reduce the length of the material list if the removed material is at the end
    			if (mat._id[_id] == _materialsSceneList.length - 1) {
    				_materialsSceneList.length--;
    				_materialsNextList.length--;
    			}
    		}
    	}
    	/** @private */
    	arcane function addSceneMaterial(mat:Material):void
    	{
    		if (mat._faceCount.length <= _id)
    			mat._id.length = mat._faceCount.length = _id + 1;
    		
    		if (!mat._faceCount[_id]) {
    			
				var i:uint = 0;
				var length:uint = _materialsSceneList.length;
    			while (i < length) {
    				//add the material to the first available space
    				if (!_materialsSceneList[i]) {
    					_materialsSceneList[mat._id[_id] = i] = mat;
    					break;
    				} else {
	    				i++;
    				}
    			}
    			//increase the length of the material list if the added material is at the end
    			if (i == length) {
    				_materialsSceneList.length++;
    				_materialsNextList.length++;
    				_materialsSceneList[mat._id[_id] = i] = mat;
    			}
    		}
			//this in above conditional causes flex java error
			mat._faceCount[_id]++;
    	}
    	/** @private */
		arcane function addSceneLight(light:AbstractLight3D):void
		{
			_sceneLights[_sceneLights.length] = light;
		}
    	/** @private */
		arcane function removeSceneLight(light:AbstractLight3D):void
		{
			_index = _sceneLights.indexOf(light);
			
			if (_index != -1)
				_sceneLights.splice(_index, 1);
		}
    	/** @private */
		arcane override function project(camera:Camera3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			_materialsNextList = new Vector.<Material>(_materialsNextList.length);
			
			super.project(camera, parentSceneMatrix3D);
			
			var i:uint;
			var matPrevious:Material;
			var matNext:Material;
			
			if (_materialsPreviousList.length > _materialsNextList.length)
				i = _materialsNextList.length = _materialsPreviousList.length;
			else
				i = _materialsPreviousList.length = _materialsNextList.length;
			
			while (i--) {
				matPrevious = _materialsPreviousList[i];
				matNext = _materialsNextList[i];
				if (matPrevious != matNext) {
					if (matPrevious)
						matPrevious.notifyDeactivate(this);
					if (matNext)
						matNext.notifyActivate(this);
				}
			}
			
			_materialsPreviousList = _materialsNextList;
		}
		
    	private static var _idTotal:uint = 0;
    	        
        /**
        * Returns the lights of the scene as an array of 3d lights.
        */
		public function get sceneLights():Vector.<AbstractLight3D>
		{
			return _sceneLights;
		}
		
		/**
		 * Creates a new <code>Scene3D</code> object
	     * 
	     * @param	...childArray		An array of 3d objects to be added as children of the container on instatiation. Can contain an initialisation object
	     */
		public function Scene3D(...childArray)
		{
			_id = _idTotal++;
			
			super();
			
			for each (var child:Object3D in childArray)
				addChild(child);
			
			_scene = this;
		}
	}
}
