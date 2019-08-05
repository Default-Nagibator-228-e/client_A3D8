package alternativa.tanks.vehicles.tanks 
{
	import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import alternativa.tanks.materials.LeftTrackMaterial;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
	public class LeftTrackSkin 
	{
		
		private var ratio:Number;
      
		private var distance:Number = 0;
	  
		public var material:LeftTrackMaterial;
		
		public function LeftTrackSkin() 
		{
			
		}
		
		public function move(param1:Number) : void
		  {
			 this.distance += param1/1250;
			 if (material != null) material.distance = this.distance;
		  }
		  
		  public function setMaterial(param1:LeftTrackMaterial) : void
		  {
			 param1.name = "tracks";
			 this.material = param1;
		  }
		
	}

}