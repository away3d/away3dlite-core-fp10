package away3dlite.materials.shaders
{
	import flash.geom.Utils3D;
	import flash.display.Bitmap;
	import open3d.geom.Vertex;
	import open3d.materials.BitmapMaterial;
	import open3d.objects.Light;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.IGraphicsData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	/**
	 * @author kris
	 */


	public class PhongColorMaterial extends PhongMaterial
	{





		public function PhongColorMaterial(light:Light, color:uint = 0xFF0000, alpha_:Number = 1.0, amb:int = 64, dif:int = 192, spc:int = 0, pow:Number = 8, emi:int = 0, doubleSided:Boolean = false)
		{
			var bitmapData:BitmapData = getShadingBitmap(color, alpha_, amb, dif, spc, pow, emi, doubleSided);
			super(light, bitmapData);
		}






		protected function getShadingBitmap(color:uint, alpha_:Number = 1.0, amb:int = 64, dif:int = 192, spc:int = 0, pow:Number = 8, emi:int = 0, doubleSided:Boolean = false):BitmapData
		{
			var colorTable:BitmapData = new BitmapData(256, 256, false);
			var i:int, r:int, c:int, lightTable:BitmapData = new BitmapData(256, 256, false), rct:Rectangle = new Rectangle();

			// base color
			var alpha:Number = alpha_;
			colorTable.fillRect(colorTable.rect, color);

			// ambient/diffusion/emittance
			var ea:Number = (256 - emi) * 0.00390625, eb:Number = emi * 0.5;
			r = dif - amb;
			rct.width = 1;
			rct.height = 256;
			rct.y = 0;
			for (i = 0; i < 256; ++i)
			{
				rct.x = i;
				lightTable.fillRect(rct, (((i * r) >> 8) + amb) * 0x10101);
			}
			colorTable.draw(lightTable, null, new ColorTransform(ea, ea, ea, 1, eb, eb, eb, 0), BlendMode.HARDLIGHT);

			// specular/power
			if (spc > 0)
			{
				rct.width = 256;
				rct.height = 1;
				rct.x = 0;
				for (i = 0; i < 256; ++i)
				{
					rct.y = i;
					c = int(Math.pow(i * 0.0039215686, pow) * spc);
					lightTable.fillRect(rct, ((c < 255) ? c : 255) * 0x10101);
				}
				colorTable.draw(lightTable, null, null, BlendMode.ADD);
			}
			lightTable.dispose();
			var _nega_filter:int = 0;
			// double sided
			_nega_filter = (doubleSided) ? -1 : 0;
			return colorTable;
		}


	}
}
