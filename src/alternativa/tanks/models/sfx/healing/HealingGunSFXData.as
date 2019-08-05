package alternativa.tanks.models.sfx.healing
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.tanks.engine3d.TextureAnimation;
   import flash.media.Sound;
   
   public class HealingGunSFXData
   {
       
      
      public var idleSparkMaterials:Vector.<Material>;
      
      public var idleSound:Sound;
      
      public var healSparkMaterials:Vector.<Material>;
      
      public var healShaftMaterials:Vector.<TextureMaterial>;
      
      public var healShaftEndMaterials:Vector.<Material>;
      
      public var healSound:Sound;
      
      public var damageSparkMaterials:Vector.<Material>;
      
      public var damageShaftMaterials:Vector.<TextureMaterial>;
      
      public var damageShaftEndMaterials:Vector.<Material>;
      
      public var damageSound:Sound;
      
      public var idleSparkData:TextureAnimation;
      
      public var healSparkData:TextureAnimation;
      
      public var healShaftEndData:TextureAnimation;
      
      public var healShaftData:TextureAnimation;
      
      public var damageSparkData:TextureAnimation;
      
      public var damageShaftData:TextureAnimation;
      
      public var damageShaftEndData:TextureAnimation;
      
      public function HealingGunSFXData()
      {
         super();
      }
   }
}
