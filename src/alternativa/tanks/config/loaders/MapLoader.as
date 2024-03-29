package alternativa.tanks.config.loaders
{
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.primitives.Box;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.physics.collision.primitives.CollisionRect;
   import alternativa.physics.collision.primitives.CollisionTriangle;
   import alternativa.proplib.PropLibRegistry;
   import alternativa.proplib.PropLibrary;
   import alternativa.proplib.objects.PropMesh;
   import alternativa.proplib.objects.PropObject;
   import alternativa.proplib.objects.PropSprite;
   import alternativa.proplib.types.PropData;
   import alternativa.proplib.types.PropGroup;
   import alternativa.tanks.Triangle;
   import alternativa.tanks.help.MD5;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   
   [Event(name="complete",type="flash.events.Event")]
   public class MapLoader extends EventDispatcher
   {
      
      private static const STATIC_COLLISION_GROUP:int = 255;
      
      private static const MAX_BATCH_SIZE:int = 20;
      
      private static var objectMatrix:Matrix3D = new Matrix3D();
      
      private static var components:Vector.<Vector3D> = Vector.<Vector3D>([new Vector3D(),new Vector3D(),new Vector3D(1,1,1)]);
      
      public var mapXml:XML;
      
      public var propLibRegistry:PropLibRegistry;
      
      private var loader:URLLoader;
      
      private var _objects:Vector.<Object3D>;
      
      private var _lights:Vector.<Light3D>;
      
      private var _sprites:Vector.<Object3D>;
            
      private var _collisionPrimitives:Vector.<CollisionPrimitive>;
      
      private var _visualCollisionObjects:Vector.<Object3D>;
      
      private var spawnPoints:Object;
      
      private var materialUsersRegistry:MaterialUsersRegistry = new MaterialUsersRegistry();
      
      private var batchTextureBuilder:BatchTextureBuilder;
      
      private var mipMapResolution:Number = 5;
      
      public function MapLoader()
      {
         this._objects = new Vector.<Object3D>();
         this._sprites = new Vector.<Object3D>();
         this._lights = new Vector.<Light3D>();
         this.spawnPoints = {};
         super();
      }
      
      private static function isNaNVector(v:Vector3) : Boolean
      {
         return isNaN(v.x) || isNaN(v.y) || isNaN(v.z);
      }
      
      private static function readVector3(xml:XMLList, result:Vector3) : void
      {
         var element:XML = null;
         if(xml.length() > 0)
         {
            element = xml[0];
            result.x = Number(element.x);
            result.y = Number(element.y);
            result.z = Number(element.z);
         }
         else
         {
            result.x = result.y = result.z = 0;
         }
      }
      
      private static function readVector3D(xml:XMLList, result:Vector3D) : void
      {
         var el:XML = null;
         el = null;
         if(xml.length() > 0)
         {
            el = xml[0];
            result.x = Number(el.x);
            result.y = Number(el.y);
            result.z = Number(el.z);
         }
         else
         {
            result.x = result.y = result.z = 0;
         }
      }
      
      private static function xmlToString(xml:XML, defaultValue:String) : String
      {
         if(xml == null)
         {
            return defaultValue;
         }
         return xml.toString() || defaultValue;
      }
      
      public function load(url:XML, libRegistry:PropLibRegistry) : void
      {
         if(libRegistry == null)
         {
            throw new ArgumentError("Parameter libRegistry cannot be null");
         }
         this.propLibRegistry = libRegistry;
         this.mapXml = url;
         this.parseProps();
         this.parseCollisionPrimitives();
         this.runTextureBuilder();
      }
      
      public function get lights() : Vector.<Light3D>
      {
         return this._lights;
      }
      
      public function get objects() : Vector.<Object3D>
      {
         return this._objects;
      }
      
      public function get sprites() : Vector.<Object3D>
      {
         return this._sprites;
      }
      
      public function get collisionPrimitives() : Vector.<CollisionPrimitive>
      {
         return this._collisionPrimitives;
      }
      
      public function getFlagPosition(type:String) : Vector3D
      {
         var xmlList:XMLList = this.mapXml.elements("ctf-flags").elements("flag-" + type);
         if(xmlList.length() == 0)
         {
            return null;
         }
         var position:Vector3D = new Vector3D();
         readVector3D(xmlList,position);
         return position;
      }
      
      public function get visualCollisionObjects() : Vector.<Object3D>
      {
         if(this._visualCollisionObjects != null)
         {
            return this._visualCollisionObjects;
         }
         this._visualCollisionObjects = new Vector.<Object3D>();
         return this._visualCollisionObjects;
      }
      
      private function onLoadingComplete(e:Event) : void
      {
         this.mapXml = XML(this.loader.data);
         this.loader = null;
         this.parseProps();
         this.parseCollisionPrimitives();
         this.runTextureBuilder();
      }
      
      private function parseProps() : void
      {
         var library:PropLibrary = this.propLibRegistry.libraries[0];
		 for each(var group:PropGroup in library.rootGroup.groups)
         {
			 for each(var prop:PropData in group.props)
			 {
				 var propObject:PropObject = prop.getDefaultState().getDefaultObject();
				 if(propObject is PropMesh)
				 {
					this.parsePropMesh(PropMesh(propObject));
				 }
				 else if(propObject is PropSprite)
				 {
					this.parsePropSprite(null,PropSprite(propObject));
				 }
			 }
         }
      }
      
      private function parsePropMesh(propMesh:PropMesh) : void
      {
         var mesh:Mesh = Mesh(propMesh.object.clone());
         this._objects.push(mesh);
         this.materialUsersRegistry.addMesh(propMesh,new MeshWrapper(mesh));
      }
      
      private function parsePropSprite(propXml:XML, propSprite:PropSprite) : void
      {
         var sprite:Sprite3D = Sprite3D(propSprite.object.clone());
         this._sprites.push(sprite);
         var position:Vector3D = components[0];
         readVector3D(propXml.position,position);
         sprite.x = position.x;
         sprite.y = position.y;
         sprite.z = position.z;
         sprite.width = propSprite.scale;
         this.materialUsersRegistry.addSprite3D(propSprite,new Sprite3DWrapper(sprite));
      }
      
      private function parseCollisionPrimitives() : void
      {
         var rotation:Vector3 = null;
         var primitive:CollisionPrimitive = null;
         var primitiveXml:XML = null;
         var v0:Vector3 = null;
         var v1:Vector3 = null;
         var v2:Vector3 = null;
         this._collisionPrimitives = new Vector.<CollisionPrimitive>();
         var rotationMatrix:Matrix3 = new Matrix3();
         var halfSize:Vector3 = new Vector3();
         var position:Vector3 = new Vector3();
         rotation = new Vector3();
         var collisionXml:XMLList = this.mapXml.elements("collision-geometry")[0].elements("collision-plane");
         for each(primitiveXml in collisionXml)
         {
            halfSize.x = 0.5 * Number(primitiveXml.width);
            halfSize.y = 0.5 * Number(primitiveXml.length);
            halfSize.z = 0;
            readVector3(primitiveXml.position,position);
            readVector3(primitiveXml.rotation,rotation);
            rotationMatrix.setRotationMatrix(rotation.x,rotation.y,rotation.z);
            primitive = new CollisionRect(halfSize,STATIC_COLLISION_GROUP);
            primitive.transform.setFromMatrix3(rotationMatrix,position);
            this._collisionPrimitives.push(primitive);
         }
         collisionXml = this.mapXml.elements("collision-geometry")[0].elements("collision-box");
         for each(primitiveXml in collisionXml)
         {
            readVector3(primitiveXml.size,halfSize);
            halfSize.scaleBy(0.5);
            readVector3(primitiveXml.position,position);
            readVector3(primitiveXml.rotation,rotation);
            rotationMatrix.setRotationMatrix(rotation.x,rotation.y,rotation.z);
            primitive = new CollisionBox(halfSize,STATIC_COLLISION_GROUP);
            primitive.transform.setFromMatrix3(rotationMatrix,position);
            this._collisionPrimitives.push(primitive);
         }
         v0 = new Vector3();
         v1 = new Vector3();
         v2 = new Vector3();
         collisionXml = this.mapXml.elements("collision-geometry")[0].elements("collision-triangle");
         for each(primitiveXml in collisionXml)
         {
            readVector3(primitiveXml.v0,v0);
            readVector3(primitiveXml.v1,v1);
            readVector3(primitiveXml.v2,v2);
            if(!(isNaNVector(v0) || isNaNVector(v1) || isNaNVector(v2)))
            {
               readVector3(primitiveXml.position,position);
               readVector3(primitiveXml.rotation,rotation);
               rotationMatrix.setRotationMatrix(rotation.x,rotation.y,rotation.z);
               primitive = new CollisionTriangle(v0,v1,v2,STATIC_COLLISION_GROUP);
               primitive.transform.setFromMatrix3(rotationMatrix,position);
               this._collisionPrimitives.push(primitive);
            }
         }
      }
      
      private function runTextureBuilder() : void
      {
         this.batchTextureBuilder = new BatchTextureBuilder();
         this.batchTextureBuilder.addEventListener(Event.COMPLETE,this.onTexturesComplete);
         this.batchTextureBuilder.run(this.mipMapResolution,MAX_BATCH_SIZE,this.materialUsersRegistry.meshEntries,this.materialUsersRegistry.spriteEntries);
      }
      
      private function onTexturesComplete(e:Event) : void
      {
         this.batchTextureBuilder.removeEventListener(Event.COMPLETE,this.onTexturesComplete);
         this.batchTextureBuilder = null;
         this.complete();
      }
      
      private function complete() : void
      {
         this.propLibRegistry = null;
         this.materialUsersRegistry = null;
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}