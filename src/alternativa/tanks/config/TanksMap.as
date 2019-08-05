package alternativa.tanks.config
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.materials.StandardMaterial;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.tanks.config.loaders.MapLoader;
   import alternativa.tanks.models.battlefield.BattleView3D;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Vector3D;
   
   public class TanksMap extends ResourceLoader
   {
       
      
      public var mapContainer:Object3D;
      
      private var loader:MapLoader;
      
      private var spawnMarkers:Object;
      
      private var ctfFlags:Object;
      
      private var mapId:String;
      
      public function TanksMap(config:Config, idMap:String)
      {
         this.spawnMarkers = {};
         this.ctfFlags = {};
         this.mapId = idMap;
         super("Tank map loader", config);
      }
      
      override public function run() : void
      {
         this.loader = new MapLoader();
         this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.load(config.xml,config.propLibRegistry);
      }
      
      public function get collisionPrimitives() : Vector.<CollisionPrimitive>
      {
         return this.loader.collisionPrimitives;
      }
      
      public function showSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(!visible)
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      public function hideSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(visible)
            {
               this.mapContainer.removeChild(marker);
            }
         }
      }
      
      public function toggleSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(visible)
            {
               this.mapContainer.removeChild(marker);
            }
            else
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      public function showCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null && marker.parent == null)
         {
            this.mapContainer.addChild(marker);
         }
      }
      
      public function hideCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null && marker.parent != null)
         {
            this.mapContainer.removeChild(marker);
         }
      }
      
      public function toggleCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null)
         {
            if(marker.parent != null)
            {
               this.mapContainer.removeChild(marker);
            }
            else
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      private function getCTFFlagMarker(type:String) : Sprite3D
      {
         return this.ctfFlags[type];
      }
      
      private function getSpawnMarkers(type:String) : Vector.<Object3D>
      {
         return null;
      }
      
      private function onLoadingComplete(e:Event) : void
      {
         var sprite:Sprite3D = null;
         this.mapContainer = this.createContainer(this.loader.objects);
         this.mapContainer.name = "Visual Kd-tree";
         for each(sprite in this.loader.sprites)
         {
            this.mapContainer.addChild(sprite);
         }
		 BattleView3D.shadow.addCaster(this.mapContainer);
         BattlefieldModel(Main.osgi.getService(IBattleField)).build(this.mapContainer,this.collisionPrimitives,this.loader.lights);
         completeTask();
      }
      
      private function createContainer(objects:Vector.<Object3D>) : Object3D
      {
         var container:Object3D = new Object3D();
         for each(var me:Object3D in objects)
         {
            container.addChild(me);
         }
         return container;
      }
   }
}

import alternativa.engine3d.core.Object3D;

class SpawnMarkersData
{
    
   
   public var markers:Vector.<Object3D>;
   
   function SpawnMarkersData()
   {
      super();
   }
}
