package alternativa.tanks.sfx
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.engine3d.UVFrame;
   
   public class AnimatedPlane extends Plane
   {
	  
	  private var h:TextureAnimation;
      
      private var uvFrames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      private var framesPerTimeUnit:Number = 0;
      
      public function AnimatedPlane(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0, param5:Number = 10)
      {
         super(param1,param2);
      }
      
      public function init(param1:TextureAnimation, param2:Number) : void
      {
		 h = param1;
         setMaterialToAllSurfaces(param1.material[0]);
         this.uvFrames = param1.frames;
         this.numFrames = this.uvFrames.length;
         this.framesPerTimeUnit = param2;
      }
      
      public function setTime(param1:Number) : void
      {
         var _loc2_:int = param1 * this.framesPerTimeUnit;
         if(_loc2_ >= this.numFrames)
         {
            _loc2_ = this.numFrames - 1;
         }
         this.setFrame(this.uvFrames[_loc2_]);
		 setMaterialToAllSurfaces(h.material[_loc2_]);
      }
      
      public function clear() : void
      {
         setMaterialToAllSurfaces(null);
         this.uvFrames = null;
         this.numFrames = 0;
      }
      
      public function getOneLoopTime() : Number
      {
         return this.numFrames / this.framesPerTimeUnit;
      }
      
      private function setFrame(param1:UVFrame) : void
      {
         //this.a.u = param1.topLeftU;
         //this.a.v = param1.topLeftV;
         //this.b.u = param1.topLeftU;
         //this.b.v = param1.bottomRightV;
         //this.c.u = param1.bottomRightU;
         //this.c.v = param1.bottomRightV;
         //this.d.u = param1.bottomRightU;
         //this.d.v = param1.topLeftV;
      }
   }
}
