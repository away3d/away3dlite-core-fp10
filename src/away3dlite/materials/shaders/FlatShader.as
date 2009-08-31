package away3dlite.materials.shaders 
{
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.geom.Matrix3D;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import open3d.objects.Light;
	
	import away3dlite.materials.shaders.IShader;

	import flash.display.BitmapData;
	

	/**
	 * @author kris@neuroproductions.be
	 */
	public class FlatShader extends ShaderMaterial implements IShader 
	{
		public function FlatShader(light:Light)
		{
					
			var bmd:BitmapData =getShadingBitmap(0xFF0000);
			super(light,bmd);
		}
		override public function getUVData(m : Matrix3D) : Vector.<Number>
		{
			
			var projectMatrix:Matrix3D = m.clone();
			projectMatrix.position =new Vector3D(0,0,0);
			
			var uvData : Vector.<Number> = new Vector.<Number>();
			var projectedNormal : Vector3D ;
			
			var texCoord : Point = new Point(); 
			// projecting vertex normals
			// TODO: optimize: keep normals in a Vector and use Matrix.transformVectors
			for (var i : int = 0;i < faceNormals.length; i++) 
			{
				
				projectedNormal = m.transformVector(faceNormals[i]);

				
				calculateTexCoord(texCoord, projectedNormal, false);
				uvData.push(texCoord.x, texCoord.y, 1,texCoord.x, texCoord.y, 1,texCoord.x, texCoord.y, 1);
			}
			
			return uvData;
		}
		protected function calculateTexCoord(texCoord : Point, normal : Vector3D,doubleSided : Boolean = false ) : void 
		{
			var v : Vector3D = _light.direction;
			texCoord.x = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.x < 0) texCoord.x = (doubleSided) ? -texCoord.x : 0;
			v = _light.halfVector;
			texCoord.y = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.y < 0) texCoord.y = (doubleSided) ? -texCoord.y : 0;
		}
		protected function getShadingBitmap(color : uint, alpha_ : Number = 1.0,amb : int = 64, dif : int = 192, spc : int = 0, pow : Number = 8, emi : int = 0, doubleSided : Boolean = false) : BitmapData 
		{
			var colorTable : BitmapData = new BitmapData(256, 256, false);
			var i : int, r : int, c : int,
            lightTable : BitmapData = new BitmapData(256, 256, false),
            rct : Rectangle = new Rectangle();
        
			// base color
			var alpha : Number = alpha_;
			colorTable.fillRect(colorTable.rect, color);

			// ambient/diffusion/emittance
			var ea : Number = (256 - emi) * 0.00390625,
            eb : Number = emi * 0.5;
			r = dif - amb;
			rct.width = 1; 
			rct.height = 256; 
			rct.y = 0;
			for (i = 0;i < 256; ++i) 
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
				for (i = 0;i < 256; ++i) 
				{
					rct.y = i;
					c = int(Math.pow(i * 0.0039215686, pow) * spc);
					lightTable.fillRect(rct, ((c < 255) ? c : 255) * 0x10101);
				}
				colorTable.draw(lightTable, null, null, BlendMode.ADD);
			}
			lightTable.dispose();
			var _nega_filter : int = 0;
			// double sided
			_nega_filter = (doubleSided) ? -1 : 0;
			return colorTable;
		}
		
	}
}
