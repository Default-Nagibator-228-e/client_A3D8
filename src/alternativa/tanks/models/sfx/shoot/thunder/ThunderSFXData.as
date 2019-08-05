package alternativa.tanks.models.sfx.shoot.thunder
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.media.Sound;
   
   public class ThunderSFXData
   {
       
      
      public var shotMaterial:Material;
      
      public var explosionMaterials:Vector.<TextureMaterial>;
      
      public var shotSound:Sound;
      
      public var explosionSound:Sound;
      
      public function ThunderSFXData()
      {
         super();
      }
   }
}
