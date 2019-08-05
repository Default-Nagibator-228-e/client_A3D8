package alternativa.tanks.models.battlefield
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Resource;
   import alternativa.engine3d.core.View;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.shadows.DirectionalLightShadow;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.display.AxisIndicator;
   import alternativa.tanks.models.battlefield.decals.DecalFactory;
   import alternativa.tanks.models.battlefield.decals.FadingDecalsRenderer;
   import alternativa.tanks.models.battlefield.decals.Queue;
   import alternativa.tanks.models.battlefield.decals.RotationState;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Object3DContainerProxy;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class BattleView3D extends Sprite
   {
      
      private static const MAX_TEMPORARY_DECALS:int = 100;
      
      private static const DECAL_FADING_TIME_MS:int = 20000;
       
      
      public var camera:GameCamera;
      
      public var rootContainer:Object3D;
      
      private var skyboxContainer:Object3D;
      
      private var mainContainer:Object3D;
      
      private var frontContainer:Object3D;
      
      private var mapContainer:Object3D;
      
      private var mapContainerProxy:Object3DContainerProxy;
      
      private var frontContainerProxy:Object3DContainerProxy;
      
      private var _showAxisIndicator:Boolean;
	  
	  public static var dirLight:DirectionalLight = new DirectionalLight(Number(String("0x"+"FFA64D")));//FFA64D
      
      public static var shadow:DirectionalLightShadow = new DirectionalLightShadow(15000, 12000, -13000, 13000, 2048, 1);
	  
	  private var axisIndicator:AxisIndicator;
      
      private var decalFactory:DecalFactory;
      
      private const temporaryDecals:Queue = new Queue();
      
      private const allDecals:Dictionary = new Dictionary();
      
      private var fadingDecalRenderer:FadingDecalsRenderer;
      
      public var overlay:Shape;
	  	  
	  public var col:ICollisionDetector;
      
      private const BG_COLOR:uint = 10066176;
	        
      public function BattleView3D(showAxisIndicator:Boolean, collisionDetector:ICollisionDetector, bs:BattlefieldModel)
      {
         super();
         mouseEnabled = false;
         tabEnabled = false;
         focusRect = false;
		 col = collisionDetector;
         this.camera = new GameCamera();
         this.camera.nearClipping = 10;
         this.camera.farClipping = 50000;
         this.camera.view = new View(100,100);
         this.camera.view.focusRect = false;
         this.decalFactory = new DecalFactory(collisionDetector);
         this.fadingDecalRenderer = new FadingDecalsRenderer(DECAL_FADING_TIME_MS,bs);
         addChild(this.camera.view);
         this.mapContainerProxy = new Object3DContainerProxy();
         this.rootContainer = new Object3D();
         this.rootContainer.addChild(this.skyboxContainer = new Object3D());
         this.rootContainer.addChild(this.mainContainer = new Object3D());
         this.rootContainer.addChild(this.frontContainer = new Object3D());
         this.frontContainerProxy = new Object3DContainerProxy(this.frontContainer);
         this.rootContainer.addChild(this.camera);
         Main.stage.quality = StageQuality.HIGH;
         this.overlay = new Shape();
         addChild(this.overlay);
         this.showAxisIndicator = false;
      }
	  
	  public function addDecal(param1:Vector3, param2:Vector3, param3:Number, param4:TextureMaterial, param5:RotationState = null) : void
      {
         var _loc6_:Decal = this.createDecal(param1, param2, param3, param4, param5);
         if(_loc6_ != null)
         {
            this.temporaryDecals.put(_loc6_);
            this.fadingDecalRenderer.add(this.temporaryDecals.pop());
         }
      }
      
      private function createDecal(param1:Vector3, param2:Vector3, param3:Number, param4:TextureMaterial, param5:RotationState = null) : Decal
      {
         var _loc6_:Decal = null;
         if(param5 == null)
         {
            param5 = RotationState.USE_RANDOM_ROTATION;
         }
         _loc6_ = this.decalFactory.createDecal(param1,param2,param3,param4,param5);
         this._mapContainer.addChildAt(_loc6_,0);
         this.allDecals[_loc6_] = true;
         return _loc6_;
      }
      
      public function removeDecal(param1:Decal) : void
      {
         if(param1 != null)
         {
            this._mapContainer.removeChild(param1);
            delete this.allDecals[param1];
         }
      }
      
      public function enableSoftParticles() : void
      {
         
      }
      
      public function disnableSoftParticles() : void
      {
         
      }
      
      public function enableFog() : void
      {
         //this.camera.fogColor = 16777215;//8450000;//4143;
         //this.camera.fogNear = 5000;
         //this.camera.fogFar = 15000;
         //this.camera.fogStrength = 1;
         //this.camera.fogAlpha = 0.5;
      }
      
      public function disnableFog() : void
      {
         //this.camera.fogStrength = 0;
      }
      
      public function set showAxisIndicator(value:Boolean) : void
      {
         if(this._showAxisIndicator == value)
         {
            return;
         }
         this._showAxisIndicator = value;
         if(value)
         {
            this.axisIndicator = new AxisIndicator(50);
            addChild(this.axisIndicator);
         }
         else
         {
            removeChild(this.axisIndicator);
            this.axisIndicator = null;
         }
      }
      
      public function resize(w:Number, h:Number) : void
      {
         this.camera.view.width = w;
         this.camera.view.height = h;
         if(this._showAxisIndicator)
         {
            this.axisIndicator.y = (h + this.camera.view.height >> 1) - 2 * this.axisIndicator.size;
         }
         this.camera.updateFov();
      }
      
      public function update() : void
      {
         if(this._showAxisIndicator)
         {
            this.axisIndicator.update(this.camera);
         }
         this.camera.render(Game.stage3D);
		 shadow.centerX = camera.x;
		 shadow.centerY = camera.y;
      }
      
      public function get _mapContainer() : Object3D
      {
         return this.mapContainer;
      }
      
      public function set _mapContainer(value:Object3D) : void
      {
         if(this.mapContainer != null)
         {
            this.mainContainer.removeChild(this.mapContainer);
            this.mapContainer = null;
         }
         this.mapContainerProxy.setContainer(value);
         this.mapContainer = value;
         if(this.mapContainer != null)
         {
            this.mainContainer.addChild(this.mapContainer);
         }
         this.frontContainer.name = "FRONT CONTAINER";
         this.mapContainer.name = "MAP CONTAINER";
      }
      
      public function initLights(lights:Vector.<Light3D>) : void
      {
      }
      
      public function clearContainers() : void
      {
         this.clear(this.rootContainer);
         this.clear(this.mapContainer);
         this.clear(this.skyboxContainer);
         this.clear(this.frontContainer);
      }
      
      private function clear(container:Object3D) : void
      {
         while(container.numChildren > 0)
         {
            container.removeChildAt(0);
         }
      }
      
      public function addDynamicObject(object:Object3D) : void
      {
         if(this.mapContainer != null)
         {
            this.mapContainer.addChild(object);
         }
      }
      
      public function removeDynamicObject(object:Object3D) : void
      {
         if(this.mapContainer != null)
         {
            this.mapContainer.removeChild(object);
         }
      }
      
      public function getFrontContainer() : Scene3DContainer
      {
         return this.frontContainerProxy;
      }
      
      public function getMapContainer() : Scene3DContainer
      {
         return this.mapContainerProxy;
      }
      
      public function setSkyBox(param1:Object3D) : void
      {
         if(this.skyboxContainer.numChildren > 0)
         {
            this.skyboxContainer.removeChildAt(0);
         }
         this.skyboxContainer.addChild(param1);
      }
   }
}
