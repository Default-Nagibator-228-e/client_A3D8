package alternativa.tanks.engine3d
{
   import alternativa.engine3d.materials.StandardMaterial;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.materials.VertexLightTextureMaterial;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import flash.display.BitmapData;
   
   public class TextureMaterialFactory
   {
       
      
      public function TextureMaterialFactory()
      {
         super();
      }
      
      public static function createTextureMaterial(param1:BitmapData) : VertexLightTextureMaterial
      {
		 var dsd:BitmapTextureResource = new BitmapTextureResource(param1);
		 dsd.upload(Game.context);
		 /*var b:BitmapData = new BitmapData(1, 1, false, 0x7F7FFF);
		 var d:BitmapTextureResource = new BitmapTextureResource(b);
		 d.upload(Game.context);
		 var b1:BitmapData = new BitmapData(1, 1, false, 0xFFA64D);
		 var d1:BitmapTextureResource = new BitmapTextureResource(b1);
		 d1.upload(Game.context);*/
		 var material:VertexLightTextureMaterial = new VertexLightTextureMaterial(dsd);
		// material.specularPower = 0.07;
		 material.alphaThreshold = 1;
		 //material.transparentPass = false;
		 //material.opaquePass = true;
         return material;
      }
   }
}
