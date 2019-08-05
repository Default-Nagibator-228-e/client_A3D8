package alternativa.tanks.models.sfx.flame
{
   import alternativa.engine3d.materials.Material;
   import alternativa.tanks.engine3d.TextureAnimation;
   import flash.media.Sound;
   
   public class FlamethrowerSFXData
   {
       
      
      public var materials:Vector.<Material>;
      
      public var flameSound:Sound;
      
      
      public var data:TextureAnimation;
	  
	  public var shot:TextureAnimation;
      
      public function FlamethrowerSFXData()
      {
         super();
      }
   }
}
