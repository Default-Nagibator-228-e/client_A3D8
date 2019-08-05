package alternativa.tanks.sfx
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.primitives.Plane;
   
   public class SimplePlane extends Plane
   {
      
      private var originX:Number;
      
      private var originY:Number;
      
      public function SimplePlane(param1:Number, param2:Number, param3:Number, param4:Number)
      {
		 super(param1, param2);//(-param3 * param1)+((-param3 * param1)+param1),(-param4 * param2)+((-param4 * param2)+param2));
         this.originX = param3;
         this.originY = param4;
         /*boundBox.minX = -param3 * param1;
         boundBox.maxX = boundBox.minX + param1;
         boundBox.minY = -param4 * param2;
         boundBox.maxY = boundBox.minY + param2;
         boundBox.minZ = 0;
         boundBox.maxZ = 0;*/
      }
      
      public function set width(param1:Number) : void
      {
         boundBox.minX = -this.originX * param1;
         boundBox.maxX = boundBox.minX + param1;
      }
      
      public function get length() : Number
      {
         return boundBox.maxY - boundBox.minY;
      }
      
      public function set length(param1:Number) : void
      {
         boundBox.minY = -this.originY * param1;
         boundBox.maxY = boundBox.minY + param1;
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         this.width = param1;
         this.length = param2;
      }
   }
}
