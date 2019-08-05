package alternativa.tanks.models.sfx.shoot.railgun
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.AnimSprite;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.display.BitmapData;
   
   use namespace alternativa3d;
   
   public class ChargeEffect extends PooledObject implements IGraphicEffect
   {
      
      private static var globalPosition:Vector3 = new Vector3();
      
      private static var matrix:Matrix4 = new Matrix4();
       
      
      protected var sprite:AnimSprite;
      
      private var _owner:ClientObject;
      
      private var framesPerMillisecond:Number;
      
      private var currFrame:Number;
      
      private var materials:Vector.<TextureMaterial>;
      
      private var numFrames:int;
      
      private var localMuzzlePosition:Vector3;
      
      private var turret:Object3D;
	  
	  private var light:OmniLight;
      
      public function ChargeEffect(objectPool:ObjectPool)
      {
         this.localMuzzlePosition = new Vector3();
         super(objectPool);
		 this.light = new OmniLight(16745512,200,400);
      }
      
      public function init(owner:ClientObject, width:Number, height:Number, materials:Vector.<TextureMaterial>, localMuzzlePosition:Vector3, turret:Object3D, rotation:Number, fps:Number) : void
      {
			 this._owner = owner;
			 this.initSprite(width,height,rotation);
			 this.materials = materials;
			 this.framesPerMillisecond = 0.001 * fps;
			 this.localMuzzlePosition.vCopy(localMuzzlePosition);
			 this.localMuzzlePosition.y = this.localMuzzlePosition.y + 10;
			 this.turret = turret;
			 this.numFrames = materials.length;
			 var ds:BitmapData = BitmapTextureResource((materials[1] as TextureMaterial).diffuseMap).data;
			 this.light.color = ds.getPixel32(int(ds.width * 0.5), int(ds.height * 0.5));
			 this.currFrame = 1;
			 this.sprite.material = materials[1];
			 this.sprite.frame = 1;
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         container.addChild(this.sprite);
		 container.addChild(this.light);
      }
      
      public function get owner() : ClientObject
      {
         return this._owner;
      }
      
      public function play(timeDelta:int, camera:GameCamera) : Boolean
      {
         if(this.currFrame + 1 >= this.numFrames)
         {
            //trace("return false");
            return false;
         }
         matrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         matrix.transformVector(this.localMuzzlePosition,globalPosition);
         this.sprite.x = globalPosition.x;
         this.sprite.y = globalPosition.y;
         this.sprite.z = globalPosition.z;
         this.sprite.material = materials[int(this.currFrame)];
         this.sprite.loop = true;
		 this.light.x = this.sprite.x;
         this.light.y = this.sprite.y;
         this.light.z = this.sprite.z;
         this.currFrame = this.currFrame + this.framesPerMillisecond * timeDelta;
         return true;
      }
      
      public function destroy() : void
      {
         this.sprite.removeFromParent();
		 this.light.removeFromParent();
         this.sprite.material = null;
         this.materials = null;
         storeInPool();
      }
      
      public function kill() : void
      {
         this.currFrame = this.numFrames + 1;
      }
      
      override protected function getClass() : Class
      {
         return ChargeEffect;
      }
      
      private function initSprite(width:Number, height:Number, rotation:Number) : void
      {
         if(this.sprite == null)
         {
            this.sprite = new AnimSprite(width,height);
         }
         else
         {
            this.sprite.width = width;
            this.sprite.height = height;
         }
         this.sprite.rotation = rotation;
		 this.sprite.useShadow = false;
      }
   }
}
