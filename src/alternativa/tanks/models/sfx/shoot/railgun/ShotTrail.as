package alternativa.tanks.models.sfx.shoot.railgun
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.primitives.Plane1;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import flash.display.BitmapData;
   
   public class ShotTrail extends Plane1
   {
      
      private var bottomV:Number;
      
      private var distanceV:Number;
	  
      
      public function ShotTrail(param1:Number = 0, param2:Number = 0, param3:TextureMaterial = null, param4:Number = 0)
      {
         super(param1, param2);
		 setMaterialToAllSurfaces(param3);
		 this.geometry.upload(Game.context);
         useShadow = false;
      }
      
      public function clear() : void
      {
         setMaterialToAllSurfaces(null);
      }
      
      public function update(param1:Number) : void
      {
      }
   }
}
