package alternativa.tanks.models.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.SimplePlane;
   import flash.display.BitmapData;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.SFXUtils;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class MeshShotEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const STATE_BRIGHT:int = 1;
      
      private static const STATE_FADE:int = 2;
      
      private static var turretMatrix:Matrix4 = new Matrix4();
      
      private static var globalPosition:Vector3 = new Vector3();
       
      
      private var sprite:SimplePlane;
      
      private var brightTime:int;
      
      private var fadeTime:int;
      
      private var turret:Object3D;
      
      private var localPosition:Vector3;
      
      private var time:int;
      
      private var state:int;
	  
	  private var light:OmniLight = new OmniLight(16745512, 500, 1000);
	  
	  private var p12:int = 0;
      
      private var p13:int = 0;
      
      public function MeshShotEffect(objectPool:ObjectPool)
      {
         this.localPosition = new Vector3();
         super(objectPool);
         this.sprite = new SimplePlane(100, 100,1,1);
		 this.sprite.useShadow = false;
      }
      
      public function init(material:Material, localMuzzlePosition:Vector3, turret:Object3D, localOffset:Number, size:Number, brightTime:int, fadeTime:int,param12:int=500,param13:int=1000,param14:Number=0) : void
      {
		 var fdgh:BitmapData = ((material as TextureMaterial).diffuseMap as BitmapTextureResource).data;
		 var e:uint = fdgh.getPixel32(int(fdgh.width * 0.5), int(fdgh.height * 0.5));
         this.localPosition.vCopy(localMuzzlePosition);
         this.localPosition.y += 4*localOffset;
		 //this.localPosition.x += 4*localOffset;
         this.turret = turret;
         this.brightTime = brightTime;
         this.fadeTime = fadeTime;
		 this.sprite = new SimplePlane(size, size, 1, 1);
         this.sprite.setMaterialToAllSurfaces(material);
         this.sprite.rotationZ = param14;
         this.sprite.alpha = 1;
		 this.sprite.geometry.upload(Game.context);
         this.state = STATE_BRIGHT;
         this.time = brightTime;
		 this.light.color = e;
		 this.light.attenuationBegin = size + param12;
		 this.light.attenuationEnd = size + param13;
		 p12 = size + param12;
		 p13 = size + param13;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         switch(this.state)
         {
            case STATE_BRIGHT:
               if(this.time < 0)
               {
                  this.state = STATE_FADE;
                  this.time = this.fadeTime;
				  light.attenuationBegin = p12;
				  light.attenuationEnd = p13;
               }
               else
               {
                  this.time = this.time - millis;
               }
               break;
            case STATE_FADE:
               if(this.time < 0)
               {
                  return false;
               }
               this.time = this.time - millis;
               this.sprite.alpha = this.time / this.fadeTime;
               break;
         }
         turretMatrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         turretMatrix.transformVector(this.localPosition, globalPosition);
		 SFXUtils.alignObjectPlaneToView(sprite, globalPosition, new Vector3(this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ), camera.pos);
         this.sprite.x = globalPosition.x;
         this.sprite.y = globalPosition.y;
         this.sprite.z = globalPosition.z;
		 this.sprite.rotationX = this.turret.rotationX;
         this.sprite.rotationY = this.turret.rotationY;
         this.sprite.rotationZ = this.turret.rotationZ;
		 light.attenuationBegin -= millis;
		 light.attenuationEnd -= millis;
         return true;
      }
      
      public function destroy() : void
      {
         this.sprite.alternativa3d::removeFromParent();
		 this.light.alternativa3d::removeFromParent();
         this.sprite.setMaterialToAllSurfaces(null);
         this.turret = null;
         storeInPool();
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         container.addChild(this.sprite);
		 this.sprite.useShadow = false;
		 //container.addChild(this.light);
      }
      
      public function kill() : void
      {
      }
      
      override protected function getClass() : Class
      {
         return SpriteShotEffect;
      }
   }
}
