package alternativa.tanks.sfx
{
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.engine3d.AnimatedSprite3D;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.geom.Matrix;
   
   public class AnimatedSpriteEffectNew extends PooledObject implements IGraphicEffect
   {
       
      
      private var sprite:AnimatedSprite3D;
      
      private var currentFrame:Number;
      
      private var framesPerMs:Number;
      
      private var loopsCount:int;
      
      private var positionProvider:Object3DPositionProvider;
      
      private var container:Scene3DContainer;
	  
	  private var light:OmniLight;
	  
	  private var lt:Boolean;
	  
	  private var p12:int = 0;
      
      private var p13:int = 0;
      
      public function AnimatedSpriteEffectNew(param1:ObjectPool)
      {
         super(param1);
         this.sprite = new AnimatedSprite3D(1, 1);
		 this.light = new OmniLight(16745512, 500, 1000);
      }
      
      public function init(param1:Number, param2:Number, param3:TextureAnimation, param4:Number, param5:Object3DPositionProvider, param6:Number = 0.5, param7:Number = 0.5, param11:uint = 0, param12:int = 500, param13:int = 1000, param14:int = 5, param15:Boolean = true) : void
      {
		 var d:BitmapData = (param3.material[param14].diffuseMap as BitmapTextureResource).data;
		 var e:uint = d.getPixel32(int(d.width * 0.5), int(d.height * 0.5));
         this.initSprite(param1,param2,param4,param6,param7,param3);
         param5.initPosition(this.sprite);
         this.framesPerMs = 0.001 * param3.fps;
         this.positionProvider = param5;
         this.currentFrame = 0;
         this.loopsCount = 1;
		 lt = param15;
		 p12 = param12;
		 p13 = param13;
		 this.light.color = e;
		 this.light.attenuationBegin = param12;
		 this.light.attenuationEnd = param13;
      }
      
      public function initLooped(param1:Number, param2:Number, param3:TextureAnimation, param4:Number, param5:Object3DPositionProvider, param6:Number = 0.5, param7:Number = 0.5, param11:int = -1) : void
      {
         this.init(param1,param2,param3,param4,param5,param6,param7);
         this.loopsCount = param11;
      }
      
      public function addToContainer(param1:Scene3DContainer) : void
      {
         this.container = param1;
         param1.addChild(this.sprite);
		 if (lt)
		 {
			sprite.addChild(this.light);
		 }
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
		 //if (this.sprite.getNumFrames() > this.currentFrame)
		 //{
			 this.sprite.setFrameIndex(int(this.currentFrame));
			 this.currentFrame = this.currentFrame + param1 * this.framesPerMs;
			 this.positionProvider.updateObjectPosition(this.sprite, param2, param1);
			 //this.positionProvider.updateObjectPosition(this.light, param2, param1);
			 light.attenuationBegin -= param1;
			 light.attenuationEnd -= param1;
			 //throw new Error(e);
			 if(this.loopsCount > 0 && this.currentFrame >= this.sprite.getNumFrames())
			 {
				this.loopsCount--;
				if(this.loopsCount == 0)
				{
					light.attenuationBegin = p12;
					light.attenuationEnd = p13;
				   return false;
				}
				this.currentFrame = this.currentFrame - this.sprite.getNumFrames();
			 }
		 //}
         return true;
      }
      
      public function destroy() : void
      {
         this.container.removeChild(this.sprite);
		 if (lt)
		 {
			sprite.removeChild(this.light);
		 }
         this.container = null;
         this.sprite.clear();
         this.positionProvider.destroy();
         this.positionProvider = null;
      }
      
      public function kill() : void
      {
         this.loopsCount = 1;
         this.currentFrame = this.sprite.getNumFrames();
      }
      
      private function initSprite(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param7:TextureAnimation) : void
      {
         this.sprite.width = param1;
         this.sprite.height = param2;
         this.sprite.rotation = param3;
         this.sprite.originX = param4;
         this.sprite.originY = param5;
         this.sprite.setAnimationData(param7);
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
   }
}