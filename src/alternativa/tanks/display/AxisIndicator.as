package alternativa.tanks.display
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import flash.display.Shape;
   
   use namespace alternativa3d;
   
   public class AxisIndicator extends Shape
   {
       
      
      private var _size:int;
      
      private var axis1:Vector.<Number>;
	  
      private var bitOffset:int = 0;
      
      public function AxisIndicator(size:int)
      {
         this.axis1 = Vector.<Number>([0,0,0,0,0,0]);
         super();
         this._size = size;
      }
      
      public function update(camera:Camera3D) : void
      {
         var kx:Number = NaN;
         var ky:Number = NaN;
         graphics.clear();
      }
      
      public function get size() : int
      {
         return this._size;
      }
   }
}
