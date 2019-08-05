package utils
{
   import alternativa.engine3d.materials.StandardMaterial;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.materials.VertexLightTextureMaterial;
   import flash.display.BitmapData;
   
   public class MaterialEntry
   {
       
      
      public var keyData:Object;
      
      public var texture:BitmapData;
      
      public var material:VertexLightTextureMaterial;
      
      public var referenceCount:int;
      
      public function MaterialEntry(param1:Object, param2:VertexLightTextureMaterial)
      {
         super();
         this.keyData = param1;
         this.texture = param1 as BitmapData;
         this.material = param2;
      }
   }
}
