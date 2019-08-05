package alternativa.tanks.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   use namespace alternativa3d;
   
   public class AnimatedPaintMaterial extends PaintMaterial
   {
       
      
      private var programs:Dictionary;
      
      private var lastFrame:int = -1;
      
      private var fps:int;
      
      private var numFrames:int;
      
      private var numFramesX:int;
      
      private var numFramesY:int;
      
      private var currentFrame:Number;
      
      public var scaleX:Number;
      
      public var scaleY:Number;
      
      private var time:int;
      
      private var frameWidth:Number;
      
      private var frameHeight:Number;
      
      public function AnimatedPaintMaterial(param1:BitmapData, param2:BitmapData, param3:BitmapData, param4:int, param5:int, param6:int, param7:int, param8:int = 0)
      {
         super(param1,param2,param3,param8);
      }
      
      public function update() : void
      {
         
      }
   }
}
