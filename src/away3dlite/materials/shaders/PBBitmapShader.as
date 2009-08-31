package away3dlite.materials.shaders
{
	import away3dlite.lights.Light;
	import away3dlite.materials.BitmapMaterial;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	/**
	 * @author kris@neuroproductions
	 */
	public class PBBitmapShader extends BitmapMaterial implements IShader
	{

		[Embed("../../pbks/LocalGlobalNormalBlend.pbj", mimeType = "application/octet-stream")]
		private var BlendShader:Class;

		[Embed("../../pbks/NormalMapAbstractShader.pbj", mimeType = "application/octet-stream")]
		private var NormalShader:Class;
		protected var _uvtData:Vector.<Number>;
		protected var _difuseBitmapData:BitmapData;
		protected var _normalmapBitmapData:BitmapData;
		protected var _light:Light;
		protected var shader:Shader;

		public var drawSprite:Sprite = new Sprite();
		protected var difuseBitmap:Bitmap;
		protected var normalBitmap:Bitmap;
		protected var normalSprite:Sprite = new Sprite();
		protected var difuseSprite:Sprite = new Sprite();
		protected var _filter:ShaderFilter;

		public function PBBitmapShader(light:Light, difuseBitmapData:BitmapData = null, normalmapBitmapData:BitmapData = null)
		{
			_light = light;
			_difuseBitmapData = difuseBitmapData;
			_normalmapBitmapData = normalmapBitmapData;
			shader = new Shader(new NormalShader() as ByteArray);
			_filter = new ShaderFilter(shader);
			difuseBitmap = new Bitmap(difuseBitmapData.clone());
			difuseSprite.addChild(difuseBitmap);
			super(difuseBitmapData.clone());
		}

		public function calculateNormals(verticesIn:Vector.<Number>, indices:Vector.<int>, uvtData:Vector.<Number> = null, vertexNormals:Vector.<Number> = null):void
		{

			var normalMapBuilder:NormalMapBuilder = new NormalMapBuilder();

			var targetMap:BitmapData = bitmap;
			// build a world map
			var normalWorldMap:BitmapData = normalMapBuilder.getWorldNormalMap(targetMap, verticesIn, indices, uvtData, vertexNormals);
			// blend the local and world normals
			if (_normalmapBitmapData != null)
			{
				var blendshader:Shader = new Shader(new BlendShader() as ByteArray);

				var tempSprite:Sprite = new Sprite();
				var bmWorld:Bitmap = new Bitmap(normalWorldMap);
				tempSprite.addChild(bmWorld);
				var bmLocal:Bitmap = new Bitmap(_normalmapBitmapData);
				bmLocal.blendShader = blendshader;
				tempSprite.addChild(bmLocal);
				normalWorldMap.draw(tempSprite);
			}

			//texture = normalWorldMap;

			normalBitmap = new Bitmap(normalWorldMap);
			drawSprite.addChild(difuseSprite);
			normalSprite.addChild(normalBitmap);
			drawSprite.addChild(normalSprite);




			this._uvtData = uvtData;
		}

		public function getUVData(m:Matrix3D):Vector.<Number>
		{


			var v:Vector.<Vector3D> = m.decompose();
			var matrixRot:Vector3D = v[1];

			var lightNormalX:Number;
			var lightNormalY:Number;
			var lightNormalZ:Number;


			// direction light:
			//	lightNormalX =_light.direction.x;
			//	lightNormalY =_light.direction.y;
			//	lightNormalZ =-_light.direction.z;

			// point light

			var lightVec:Vector3D = new Vector3D(_light.x, _light.y, _light.z);


			lightVec = lightVec.subtract(v[0]);
			lightVec.normalize();


			lightNormalX = -lightVec.x;
			lightNormalY = -lightVec.y;
			lightNormalZ = lightVec.z;

			shader.data.x.value = [matrixRot.x];
			shader.data.y.value = [matrixRot.y];
			shader.data.z.value = [matrixRot.z];
			shader.data.xl.value = [lightNormalX];
			shader.data.yl.value = [lightNormalY];
			shader.data.zl.value = [lightNormalZ];
			shader.data.inputi.input = _difuseBitmapData;
			_filter.shader = shader;

			normalSprite.filters = [_filter];

			bitmap.draw(normalSprite);
			return _uvtData;
		}
	}
}
