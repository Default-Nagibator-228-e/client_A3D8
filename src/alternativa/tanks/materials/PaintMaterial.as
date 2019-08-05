package alternativa.tanks.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.*;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import flash.display.BitmapData;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class PaintMaterial extends StandardMaterial
   {
       
      
      protected var fragConst:Vector.<Number>;
      
      private var programs:Dictionary;
      
      protected var spriteSheetBitmap:BitmapData;
      
      protected var lightMapBitmap:BitmapData;
      
      public function PaintMaterial(param1:BitmapData, param2:BitmapData, param3:BitmapData, param4:int = 0)
      {
         this.programs = new Dictionary();
         super(new BitmapTextureResource(param3));
      }
   }
}
