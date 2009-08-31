package away3dlite.materials.shaders 
{
	import open3d.objects.Light;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class NormalMaterial extends VertexShaderMaterial implements IShader
	{

		private var _zValue : Boolean

		public function NormalMaterial(light : Light,zValue : Boolean = false)
		{
			this._zValue = zValue;
			if (zValue)
			{
				var bmd : BitmapData = getShadingBitmapZ()
			}
			else
			{
				var bmd : BitmapData = getShadingBitmapXY()
			}
			super(light, bmd);
		}

		
		override protected function calculateTexCoord(texCoord : Point, normal : Vector3D,doubleSided : Boolean = false ) : void 
		{
			if (_zValue)
			{
				texCoord.x = 0.5 + (normal.z / 2);
			texCoord.y = 0.5 + (-normal.z / 2);
			}
			else
			{
				texCoord.x = 0.5 + (normal.x / 2);
			texCoord.y = 0.5 + (-normal.y / 2);
			}
			
		}

		protected function getShadingBitmapXY() : BitmapData 
		{
			var point : Point = new Point(0, 0);
			var mat : BitmapData = new BitmapData(255, 255, false, 0);
			var tempMat : BitmapData = new BitmapData(255, 255, false, 0);
			var tempHolder : Sprite = new Sprite();
			
			//red
			var fillType : String = GradientType.LINEAR;
			var colors : Array = [0xFFFFFF, 0x000000];
			var alphas : Array = [1, 1];
			var ratios : Array = [0x00, 0xFF];
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(255, 255, 0, 0, 0);
			tempHolder.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, SpreadMethod.PAD);       
			tempHolder.graphics.drawRect(0, 0, 255, 255);
			tempMat.draw(tempHolder);
			mat.copyChannel(tempMat, tempMat.rect, point, BitmapDataChannel.RED, BitmapDataChannel.RED);
			
	
			//green
			matrix.createGradientBox(255, 255, Math.PI * 1.5, 0, 0);
			tempHolder.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, SpreadMethod.PAD);       
			tempHolder.graphics.drawRect(0, 0, 255, 255);
			tempMat.draw(tempHolder);
			mat.copyChannel(tempMat, tempMat.rect, point, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
			
			tempMat.dispose();
			return mat;
		}

		protected function getShadingBitmapZ() : BitmapData 
		{
			var point : Point = new Point(0, 0);
			var mat : BitmapData = new BitmapData(255, 255, false, 0);
			var tempMat : BitmapData = new BitmapData(255, 255, false, 0);
			var tempHolder : Sprite = new Sprite();
			
			//blue
			var fillType : String = GradientType.LINEAR;
			var colors : Array = [0xFFFFFF, 0x000000];
			var alphas : Array = [1, 1];
			var ratios : Array = [0x00, 0xFF];
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(255, 255, 0, 0, 0);
			tempHolder.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, SpreadMethod.PAD);       
			tempHolder.graphics.drawRect(0, 0, 255, 255);
			tempMat.draw(tempHolder);
			mat.copyChannel(tempMat, tempMat.rect, point, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
			
			
			
			tempMat.dispose();
			return mat;
		}
	}
}
