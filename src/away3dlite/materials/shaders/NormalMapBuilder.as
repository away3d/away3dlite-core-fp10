package away3dlite.materials.shaders
{
	import away3dlite.core.base.Vertex;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.GradientType;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 * builds a world normal map of a mesh with uvt mapping
	 */

	public class NormalMapBuilder extends Sprite
	{
		protected var normals:Vector.<Vector3D>;
		protected var vertices:Vector.<Vertex>;
		protected var _verticesIn:Vector.<Number>;
		protected var faceNormals:Vector.<Vector3D>;

		public function NormalMapBuilder()
		{
		}

		public function getWorldNormalMap(targetMap:BitmapData, verticesIn:Vector.<Number>, indices:Vector.<int>, uvtData:Vector.<Number> = null, vertexNormals:Vector.<Number> = null):BitmapData
		{

			if (vertexNormals == null)
			{
				vertexNormals = getVertexNormals(verticesIn, indices);
			}

			// calculate the world normal maping, (seperated the XY and Z direction normal, its imposible to do it in one time ? )

			var uvXY:Point;
			var uvZ:Point;
			var uvtXY:Vector.<Number> = new Vector.<Number>();
			var uvtZ:Vector.<Number> = new Vector.<Number>();
			var startIndex:int;
			var directionVector:Vector3D;
			for (var i:int = 0; i < vertexNormals.length / 3; i++)
			{
				startIndex = i * 3;
				directionVector = new Vector3D(vertexNormals[startIndex], vertexNormals[startIndex + 1], vertexNormals[startIndex + 2]);
				uvXY = new Point();
				calculateTexCoordXY(uvXY, directionVector);
				uvtXY.push(uvXY.x, uvXY.y, 1);
				uvZ = new Point();
				calculateTexCoordZ(uvZ, directionVector);
				uvtZ.push(uvZ.x, uvZ.y, 1);
			}

			//
			// map the world normals to the input uvts
			//
			var w:int = targetMap.width;
			var h:int = targetMap.height;

			var graphicsDataXY:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
			var graphicsDataZ:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();

			graphicsDataXY.push(new GraphicsBitmapFill(getShadingBitmapXY()));
			graphicsDataZ.push(new GraphicsBitmapFill(getShadingBitmapZ()));

			var mapVector:Vector.<Number> = new Vector.<Number>();
			var uvtXYTri:Vector.<Number> = new Vector.<Number>();
			var uvtZTri:Vector.<Number> = new Vector.<Number>();

			var ind:Vector.<int> = new Vector.<int>();
			ind.push(0, 1, 2);

			var triLength:int = indices.length / 3;
			var index:int;

			for (i = 0; i < triLength; i++)
			{
				// not sure why i got error here
				try
				{
					uvtXYTri = new Vector.<Number>();
					uvtZTri = new Vector.<Number>();
					mapVector = new Vector.<Number>();

					startIndex = i * 3;

					index = indices[startIndex] * 3;
					uvtXYTri.push(uvtXY[index], uvtXY[index + 1], uvtXY[index + 2]);
					uvtZTri.push(uvtZ[index], uvtZ[index + 1], uvtZ[index + 2]);
					mapVector.push(uvtData[index] * w, uvtData[(index + 1)] * h);


					index = indices[startIndex + 1] * 3;
					uvtXYTri.push(uvtXY[index], uvtXY[index + 1], uvtXY[index + 2]);
					uvtZTri.push(uvtZ[index], uvtZ[index + 1], uvtZ[index + 2]);
					mapVector.push(uvtData[index] * w, uvtData[(index + 1)] * h);

					index = indices[startIndex + 2] * 3;
					uvtXYTri.push(uvtXY[index], uvtXY[index + 1], uvtXY[index + 2]);
					uvtZTri.push(uvtZ[index], uvtZ[index + 1], uvtZ[index + 2]);
					mapVector.push(uvtData[index] * w, uvtData[(index + 1)] * h);

					graphicsDataXY.push(new GraphicsTrianglePath(mapVector, ind, uvtXYTri, TriangleCulling.NONE));
					graphicsDataZ.push(new GraphicsTrianglePath(mapVector, ind, uvtZTri, TriangleCulling.NONE));
				}
				catch (e:*)
				{
				}
			}

			var holderNormalXY:Sprite = new Sprite();
			var holderNormalZ:Sprite = new Sprite();



			holderNormalXY.graphics.drawGraphicsData(graphicsDataXY);
			holderNormalZ.graphics.drawGraphicsData(graphicsDataZ);

			// add the blue Z channel to the red/green XY bitmap

			var bmdTempZ:BitmapData = new BitmapData(w, h, false, 0x000000);
			bmdTempZ.draw(holderNormalZ);
			var mapBmd:BitmapData = new BitmapData(w, h, false, 0x000000);
			mapBmd.draw(holderNormalXY);
			mapBmd.copyChannel(bmdTempZ, bmdTempZ.rect, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
			bmdTempZ.dispose();

			//map debugging
			/*var bm:Bitmap  =new Bitmap(mapBmd);
			 addChild(bm);*/
			return mapBmd;
		}

		public function calculateTexCoordXY(texCoord:Point, normal:Vector3D):void
		{

			texCoord.x = (normal.x + 1) / 2;
			texCoord.y = 1 - ((normal.y + 1) / 2);
		}

		public function calculateTexCoordZ(texCoord:Point, normal:Vector3D):void
		{
			texCoord.x = 1 - ((normal.z + 1) / 2);
			texCoord.y = (normal.y + 1) / 2;
		}

		// normal calculation
		///TODO: +- duplicated functions from ShaderMaterial and VertexShader Material, not good 

		protected function getVertexNormals(verticesIn:Vector.<Number>, indices:Vector.<int>):Vector.<Number>
		{
			var vertexNormals:Vector.<Number> = new Vector.<Number>;
			_verticesIn = verticesIn;
			var trianglesLength:int = indices.length / 3;
			faceNormals = new Vector.<Vector3D>(trianglesLength, true);
			vertices = new Vector.<Vertex>(_verticesIn.length / 3, true);

			var vec1:Vector3D = new Vector3D();
			var vec2:Vector3D = new Vector3D();
			var vec3:Vector3D = new Vector3D();
			var ind1:int;
			var ind2:int;
			var ind3:int;

			// calculate the normal triangles, push tri normal in vertex, to calculate het vertex normal
			for (var i:int = 0; i < trianglesLength; i++)
			{

				ind1 = indices[i * 3] * 3;
				vec1.x = _verticesIn[ind1];
				vec1.y = _verticesIn[ind1 + 1];
				vec1.z = _verticesIn[ind1 + 2];

				ind2 = indices[i * 3 + 1] * 3;
				vec2.x = _verticesIn[ind2];
				vec2.y = _verticesIn[ind2 + 1];
				vec2.z = _verticesIn[ind2 + 2];


				ind3 = indices[i * 3 + 2] * 3;
				vec3.x = _verticesIn[ind3];
				vec3.y = _verticesIn[ind3 + 1];
				vec3.z = _verticesIn[ind3 + 2];


				var faceNormal:Vector3D = calculateNormal(vec1, vec2, vec3);

				faceNormals[i] = faceNormal;

				vertices[ind1 / 3] = addNormal(vertices[ind1 / 3], faceNormal);
				vertices[ind2 / 3] = addNormal(vertices[ind2 / 3], faceNormal);
				vertices[ind3 / 3] = addNormal(vertices[ind3 / 3], faceNormal);
			}


			// calculate the normal for every vertex
			for each (var vertex:Vertex in vertices)
			{
				if (vertex)
				{
					vertex.calculateNormal();
					vertexNormals.push(vertex.normal.x, vertex.normal.y, vertex.normal.z);
				}
			}

			return vertexNormals;
		}

		private function addNormal(v:Vertex, faceNormal:Vector3D):Vertex
		{
			if (v == null)
				v = new Vertex();

			v.addFaceNormal(faceNormal);
			return v;
		}

		public function calculateNormal(vec1:Vector3D, vec2:Vector3D, vec3:Vector3D):Vector3D
		{
			var normal:Vector3D = new Vector3D();
			var dif1:Vector3D = vec2.subtract(vec1);
			var dif2:Vector3D = vec3.subtract(vec1);
			normal = dif1.crossProduct(dif2);

			normal.normalize();
			return normal;
		}

		//
		// bitmaps for the XY and Z maping  
		//
		protected function getShadingBitmapXY():BitmapData
		{
			var point:Point = new Point(0, 0);
			var mat:BitmapData = new BitmapData(255, 255, false, 0);
			var tempMat:BitmapData = new BitmapData(255, 255, false, 0);
			var tempHolder:Sprite = new Sprite();

			//red
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xFFFFFF, 0x000000];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matrix:Matrix = new Matrix();
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

		protected function getShadingBitmapZ():BitmapData
		{
			var point:Point = new Point(0, 0);
			var mat:BitmapData = new BitmapData(255, 255, false, 0);
			var tempMat:BitmapData = new BitmapData(255, 255, false, 0);
			var tempHolder:Sprite = new Sprite();

			//blue
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xFFFFFF, 0x000000];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matrix:Matrix = new Matrix();
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
