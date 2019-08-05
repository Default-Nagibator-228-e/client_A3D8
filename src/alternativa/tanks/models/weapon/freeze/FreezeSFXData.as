package alternativa.tanks.models.weapon.freeze
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.media.Sound;
   
   public class FreezeSFXData
   {
       
      
      public var particleMaterials:Vector.<TextureMaterial>;
      
      public var planeMaterials:Vector.<TextureMaterial>;
      
      public var shotSound:Sound;
      
      public var particleSpeed:Number;
      
      public function FreezeSFXData()
      {
         super();
      }
   }
}
