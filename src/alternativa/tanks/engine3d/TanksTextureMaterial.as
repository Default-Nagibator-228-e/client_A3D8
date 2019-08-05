package alternativa.tanks.engine3d
{
   import alternativa.engine3d.materials.StandardMaterial;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.materials.VertexLightTextureMaterial;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import flash.display.BitmapData;
   
   public class TanksTextureMaterial extends TextureMaterial
   {
       
      
      public function TanksTextureMaterial(param1:BitmapData = null, param2:Boolean = false, param3:Boolean = true, param4:int = 0, param5:Number = 1)
      {
		 if (param1 == null) param1 = new BitmapData(1,1);
		 var dsd:BitmapTextureResource = new BitmapTextureResource(param1);
		 dsd.upload(Game.context);
		 /*var b:BitmapData = new BitmapData(1, 1, false, 0x7F7FFF);
		 var d:BitmapTextureResource = new BitmapTextureResource(b);
		 d.upload(Game.context);
		 var b1:BitmapData = new BitmapData(1, 1, false, 0xFFA64D);
		 var d1:BitmapTextureResource = new BitmapTextureResource(b1);
		 d1.upload(Game.context);*/
         super(dsd);
		 //specularPower = 0.07;
		 this.alphaThreshold = 1;
		 //transparentPass = true;
		 //opaquePass = true;
      }
   }
}
