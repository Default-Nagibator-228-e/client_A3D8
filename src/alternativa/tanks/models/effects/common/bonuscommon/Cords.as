package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.alternativa3d;
   import __AS3__.vec.Vector;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.math.Vector3;
	import flash.geom.Vector3D;
	
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.core.VertexAttributes;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
   
   use namespace alternativa3d;
   
   public class Cords extends Mesh
   {
      
        private var box:Object3D;
		private var parachute:Object3D;
		private var strapsNum:int;
		private var material:VertexLightTextureMaterial;
		
		private var numVertices:Number;
		private var vertices:Vector.<Number>;
		private var localVertices:Vector.<Number>;
		private var boxMountPoint:Vector.<Number> = new Vector.<Number>(3);
		private var boxMountPoint1:Vector.<Number> = new Vector.<Number>(3);
      
      public function Cords(radius:Number, boxHalfSize:Number, numStraps:int, box:Object3D, parachute:Object3D, mat:VertexLightTextureMaterial)
      {
			super();
			this.box = box;
			material = mat;
			material.alphaThreshold = 1;
			//material.opacityMap = material.diffuseMap;
			//material.opaquePass = false;
			//material.transparentPass = false;
			this.parachute = parachute;
			this.strapsNum = numStraps;
			createVertices(radius, boxHalfSize);
      }
      
      public function updateVertices() : void
      {
		    parachute.concatenatedMatrix.transformVectors(localVertices, vertices);
			box.concatenatedMatrix.transformVectors(boxMountPoint, boxMountPoint1);
			vertices[int(3 * numVertices - 3)] = boxMountPoint1[0];
			vertices[int(3 * numVertices - 2)] = boxMountPoint1[1];
			vertices[int(3 * numVertices - 1)] = boxMountPoint1[2];
			geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			geometry.calculateNormals();
			geometry.calculateTangents(0);
			calculateBoundBox();
			geometry.upload(Game.context);
      }
	  
	  private function createVertices(radius:Number, boxHalfSize:Number):void {
			var attributes:Array = [
				VertexAttributes.POSITION,
				VertexAttributes.POSITION,
				VertexAttributes.POSITION,
				VertexAttributes.TEXCOORDS[0],
				VertexAttributes.TEXCOORDS[0]
			];
			
			numVertices = strapsNum + 1;
			vertices = new Vector.<Number>(3 * numVertices);
			localVertices = new Vector.<Number>(3 * numVertices);
			var uvs:Vector.<Number> = new Vector.<Number>(2 * numVertices);
			var numFaces:Number = 2 * strapsNum;
			var indices:Vector.<uint> = new Vector.<uint>(4 * numFaces);
			
			var angleStep:Number = 2 * Math.PI / strapsNum;
			var i:int;
			var uv:Number = 0;
			for (i = 0; i < strapsNum; i++) {
				var angle:Number = i*angleStep;
				var i3:int = 3*i;
				localVertices[i3] = radius * Math.cos(angle);
				localVertices[i3 + 1] = radius * Math.sin(angle);
				localVertices[i3 + 2] = 0;
				var i8:int = 8*i;
				indices[i8] = 3;
				indices[i8 + 1] = i;
				indices[i8 + 2] = strapsNum;
				indices[i8 + 3] = i + 1 == strapsNum ? 0 : i + 1;
				
				indices[i8 + 4] = 3;
				indices[i8 + 5] = i + 1 == strapsNum ? 0 : i + 1;
				indices[i8 + 6] = strapsNum;
				indices[i8 + 7] = i;

				uvs[2 * i] = uv;
				//uvs[2 * i + 1] = uv;
				uv = uv == 0 ? 1 : 0;
			}
			// Нижняя точка
			localVertices[3*numVertices - 3] = localVertices[3*numVertices - 2] = 0;
			localVertices[3*numVertices - 1] = boxHalfSize;
			//uvs[2*numVertices - 2] = 0;
			uvs[2*numVertices-1] = 1;
			boxMountPoint[0] = boxMountPoint[1] = 0;
			boxMountPoint[2] = boxHalfSize;
			
			geometry = new Geometry(numVertices);
			geometry.numVertices = numVertices;
			geometry.indices = indices;
			geometry.addVertexStream(attributes);
			geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], uvs);
			addSurface(material, 0, numVertices*2);
			//geometry.calculateNormals();
			//geometry.calculateTangents(0);
			//calculateBoundBox();
		}
   }
}
