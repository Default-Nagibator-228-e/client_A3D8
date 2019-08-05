package forms.garage
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Resource;
   import alternativa.engine3d.core.View;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.SkyBox;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.osgid.service.locale.ILocaleService;
   import alternativa.tanks.Tank3D;
   import alternativa.tanks.Tank3DPart;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.typesd.Long;
   import controls.TankWindow2;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   import alternativa.tanks.gui.resource.tanks.TankResource;
   
   public class TankPreview extends Sprite
   {
      
      private var window:TankWindow2;
      
      private const windowMargin:int = 11;
      
      private var inner:TankWindowInner;
      
      private var rootContainer:Object3D;
      
      private var cameraContainer:Object3D;
      
      public var camera:GameCamera;
      
      private var timer:Timer;
      
      private var tank:Tank3D;
      
      private var rotationSpeed:Number;
      
      private var lastTime:int;
      
      private var loadedCounter:int = 0;
      
      private var holdMouseX:int;
      
      private var lastMouseX:int;
      
      private var prelastMouseX:int;
      
      private var rate:Number;
      
      private var startAngle:Number = -150;
      
      private var holdAngle:Number;
      
      private var slowdownTimer:Timer;
      
      private var resetRateInt:uint;
      
      private var autoRotationDelay:int = 10000;
      
      private var autoRotationTimer:Timer;
      
      public var overlay:Shape;
      
      private var firstAutoRotation:Boolean = true;
      
      private var first_resize:Boolean = true;
	  
	  private var dot : Number = Math.PI / 180;
	  
	  private var dot1:Number = dot * 0.001;
      
      public function TankPreview(garageBoxId:Long, rotationSpeed:Number = 5)
      {
         var box:Mesh = null;
         var material:TextureMaterial = null;
         this.overlay = new Shape();
         super();
         this.rotationSpeed = rotationSpeed;
         this.window = new TankWindow2(400,300);
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			addChild(this.window);
		 }
         this.rootContainer = new Object3D();
         this.tank = new Tank3D(null, null, null);
         this.rootContainer.addChild(this.tank);
		 initGarage();
         this.camera = new GameCamera();
         this.camera.view = new View(100, 100, false, 0, 1, 2);
         addChild(this.camera.view);
         addChild(this.overlay);
		 this.camera.view.visible = false;
         this.overlay.x = 0;
         this.overlay.y = 9;
         this.overlay.width = 1500;
         this.overlay.height = 1300;
         this.overlay.graphics.clear();
         this.cameraContainer = new Object3D();
         this.rootContainer.addChild(this.cameraContainer);
         this.cameraContainer.addChild(this.camera);
		 this.cameraContainer.z = 220;
         this.camera.z = -850;
         this.cameraContainer.rotationX = -115 * dot;
         this.cameraContainer.rotationZ = this.startAngle * dot;
         this.inner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			addChild(this.inner);
		 }
         this.inner.mouseEnabled = true;
         this.autoRotationTimer = new Timer(this.autoRotationDelay,1);
         this.autoRotationTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.start);
         this.timer = new Timer(50);
         this.slowdownTimer = new Timer(20,1000000);
         this.slowdownTimer.addEventListener(TimerEvent.TIMER,this.slowDown);
         this.inner.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         Main.stage.addEventListener(Event.ENTER_FRAME, this.onRender);
         this.start();
      }
	  
	  private function initGarage() : void
      {
         var obj:Object3D = null;
         var mesh:Mesh = null;
         var texture:BitmapData = null;
         var bytes:TankResource = ResourceUtil.getResource(ResourceType.MODEL,"garage_box_model") as TankResource;
         var treeMaterial:TextureMaterial = getTex(ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img1").bitmapData);
         var obj1m:TextureMaterial = getTex(ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img2").bitmapData);
         var obj2m:TextureMaterial = getTex1(ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img3").bitmapData,ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img3_a").bitmapData);
         var obj4m:TextureMaterial = getTex(ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img4").bitmapData);
         var obj5m:TextureMaterial = getTex(ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img5").bitmapData);
         var obj6m:TextureMaterial = getTex(ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img6").bitmapData);
         var obj7m:TextureMaterial = getTex(ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img7").bitmapData);
         var towerM:TextureMaterial = getTex(ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img8").bitmapData);
         for each(obj in bytes.objects)
         {
            mesh = obj as Mesh;
			//mesh.geometry.upload(Game.context);
			mesh.setMaterialToAllSurfaces(null);
			switch(obj.name)
			{
				case "tree1":
				case "tree2":
				case "tree3":
				case "tree4":
				case "tree5":
					mesh.setMaterialToAllSurfaces(treeMaterial);
					mesh.x = 70;
					this.rootContainer.addChild(mesh);
					break;
				case "girders":
					mesh.setMaterialToAllSurfaces(obj2m);
					mesh.x = 70;
					this.rootContainer.addChild(mesh);
					break;
				case "Tower":
					mesh.setMaterialToAllSurfaces(towerM);
					mesh.x = 70;
					this.rootContainer.addChild(mesh);
					break;
				case "bg":
					mesh.setMaterialToAllSurfaces(obj7m);
					mesh.x = 70;
					this.rootContainer.addChild(mesh);
					break;
				case "Object06":
					mesh.setMaterialToAllSurfaces(obj6m);
					mesh.x = 70;
					this.rootContainer.addChild(mesh);
					break;
				case "pandus_2":
					mesh.setMaterialToAllSurfaces(obj1m);
					mesh.x = 70;
					this.rootContainer.addChild(mesh);
					break;
				case "pandus_1":
					mesh.setMaterialToAllSurfaces(obj5m);
					mesh.x = 70;
					this.rootContainer.addChild(mesh);
					break;
				case "Object82":
					mesh.setMaterialToAllSurfaces(obj4m);
					mesh.x = 70;
					this.rootContainer.addChild(mesh);
			}
         }
		 tank.z = 130;
		 this.rootContainer.addChild(createSkyBox());
      }
	  
	  private function createSkyBox() : SkyBox
      {
         var skyBoxTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "cs_2").bitmapData;
		 var skyBox:SkyBox = new SkyBox(200000, null, null, null, null, null, null, 0.001);
		 skyBox.geometry.upload(Game.context);
		 var sides:Array = [SkyBox.RIGHT,SkyBox.BACK,SkyBox.LEFT,SkyBox.FRONT,SkyBox.TOP,SkyBox.BOTTOM];
		 for(var i:int = 0; i < sides.length; i++)
		 {
			var skyBoxTexture1:BitmapData = new BitmapData(1024, 1024);
			var re:Rectangle = skyBoxTexture.rect;
			re.x = i*1024;
			skyBoxTexture1.copyPixels(skyBoxTexture,re,new Point(0,0));
			var t:BitmapTextureResource = new BitmapTextureResource(skyBoxTexture1);
			t.upload(Game.context);
			var material:TextureMaterial = new TextureMaterial(t);
			skyBox.getSide(sides[i]).material = material;
		 }
		 skyBox.useShadow = false;
         return skyBox;
      }
	  
	  public function getTex(b:BitmapData) : TextureMaterial
      {
			var f:BitmapTextureResource = new BitmapTextureResource(b);
			f.upload(Game.context);
			var m:TextureMaterial = new TextureMaterial(f);
			m.alphaThreshold = 1;
			m.opaquePass = true;
			m.transparentPass = true;
			return m;
      }
	  
	  public function getTex1(b:BitmapData,b1:BitmapData) : TextureMaterial
      {
			var f:BitmapTextureResource = new BitmapTextureResource(b);
			f.upload(Game.context);
			var t:BitmapTextureResource = new BitmapTextureResource(b1);
			t.upload(Game.context);
			var m:TextureMaterial = new TextureMaterial(f,t);
			m.alphaThreshold = 1;
			m.opaquePass = true;
			m.transparentPass = true;
			return m;
      }
      
      public function hide() : void
      {
         var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
         if(bgService != null)
         {
            bgService.drawBg();
         }
		 this.camera.view.visible = false;
		 clear(rootContainer);
		 for each(var r:Resource in rootContainer.getResources(true))
		 {
			r.dispose();
		 }
		 Main.stage.removeEventListener(Event.ENTER_FRAME,this.onRender);
         this.stopAll();
         this.window = null;
         this.inner = null;
         this.rootContainer = null;
         this.cameraContainer = null;
         this.camera = null;
         this.timer = null;
         this.tank = null;
      }
	  
	  private function clear(container:Object3D) : void
      {
         while(container.numChildren > 0)
         {
            container.removeChildAt(0);
         }
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         if(this.autoRotationTimer.running)
         {
            this.autoRotationTimer.stop();
         }
         if(this.timer.running)
         {
            this.stop();
         }
         if(this.slowdownTimer.running)
         {
            this.slowdownTimer.stop();
         }
         this.resetRate();
         this.holdMouseX = Main.stage.mouseX;
         this.lastMouseX = this.holdMouseX;
         this.prelastMouseX = this.holdMouseX;
         this.holdAngle = this.cameraContainer.rotationZ;
         //Main.writeToConsole("TankPreview onMouseMove holdAngle: " + this.holdAngle.toString());
         Main.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         Main.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      private function onMouseMove(e:MouseEvent) : void
      {
         this.cameraContainer.rotationZ = this.holdAngle - (Main.stage.mouseX - this.holdMouseX) * 0.01;
         //this.camera.render();
         this.rate = (Main.stage.mouseX - this.prelastMouseX) * 0.5;
         this.prelastMouseX = this.lastMouseX;
         this.lastMouseX = Main.stage.mouseX;
         clearInterval(this.resetRateInt);
         this.resetRateInt = setInterval(this.resetRate,50);
      }
      
      private function resetRate() : void
      {
         this.rate = 0;
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         clearInterval(this.resetRateInt);
         Main.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         Main.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         if(Math.abs(this.rate) > 0)
         {
            this.slowdownTimer.reset();
            this.slowdownTimer.start();
         }
         else
         {
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
      }
      
      private function slowDown(e:TimerEvent) : void
      {
         this.cameraContainer.rotationZ = this.cameraContainer.rotationZ - this.rate * 0.01;
         //this.camera.render();
         this.rate = this.rate * Math.exp(-0.02);
         if(Math.abs(this.rate) < 0.1)
         {
            this.slowdownTimer.stop();
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
      }
      
      public function setHull(hull:String) : void
      {
         var hullPart:Tank3DPart = new Tank3DPart();
         hullPart.details = ResourceUtil.getResource(ResourceType.IMAGE,hull + "_details").bitmapData;
         hullPart.lightmap = ResourceUtil.getResource(ResourceType.IMAGE,hull + "_lightmap").bitmapData;
         hullPart.ob = ResourceUtil.getResource(ResourceType.MODEL, hull).om;
         hullPart.turretMountPoint = ResourceUtil.getResource(ResourceType.MODEL, hull).turretMount;
         this.tank.setHull(hullPart);
         if (this.loadedCounter < 3) this.loadedCounter++;
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running) this.start();
         }
      }
      
      public function setTurret(turret:String) : void
      {
         var turretPart:Tank3DPart = new Tank3DPart();
         turretPart.details = ResourceUtil.getResource(ResourceType.IMAGE,turret + "_details").bitmapData;
         turretPart.lightmap = ResourceUtil.getResource(ResourceType.IMAGE,turret + "_lightmap").bitmapData;
         turretPart.mesh = ResourceUtil.getResource(ResourceType.MODEL,turret).mesh;
         turretPart.turretMountPoint = ResourceUtil.getResource(ResourceType.MODEL,turret).turretMount;
         this.tank.setTurret(turretPart);
         if (this.loadedCounter < 3) this.loadedCounter++;
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running) this.start();
         }
      }
      
      public function setColorMap(map:ImageResouce) : void
      {
         this.tank.setColorMap(map);
         if (this.loadedCounter < 3) this.loadedCounter++;
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running) this.start();
         }
      }
      
      public function resize(width:Number, height:Number, i:int = 0, j:int = 0) : void
      {
		 var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
		 Main.stage.removeEventListener(Event.ENTER_FRAME, this.onRender);
		 this.camera.view.width = width - this.windowMargin * 2 - 2;
		 this.camera.view.height = height - this.windowMargin * 2 - 2;
		 this.camera.view.x = this.windowMargin;
		 this.camera.view.y = this.windowMargin;
		 this.camera.render(Game.stage3D);
         this.window.width = width;
         this.window.height = height;
         this.window.alpha = 1;
		 this.inner.width = width - 22;
         this.inner.height = height - 22;
         this.inner.x = this.windowMargin;
         this.inner.y = this.windowMargin;
         //if(Main.stage.stageWidth >= 800 && !this.first_resize)
		 //if(!this.first_resize)
         //{
            if(bgService != null)
            {
			   //Main.stage.removeEventListener(Event.ENTER_FRAME,this.onRender);
               //bgService.drawBg(new Rectangle(Math.round(int(Math.max(100, Main.stage.stageWidth)) / 3) + this.windowMargin, 71, this.inner.width, this.inner.height));
			   if (PanelModel(Main.osgi.getService(IPanel)).isInBattle)
			   {
				    bgService.drawBg(new Rectangle(0, 0, Main.stage.stageWidth, Main.stage.stageHeight));
			   }else{
					//bgService.drawBg(new Rectangle(Math.round(int(Math.max(100, Main.stage.stageWidth)) / 3) + this.windowMargin, 71, width - this.windowMargin * 2 - 2, height - this.windowMargin * 2 - 2));
					if (this.parent.parent != null)
					{
						bgService.drawBg(new Rectangle(Math.round(int(Math.max(100, Main.stage.stageWidth)) / 3) + this.windowMargin, 71, this.inner.width, this.inner.height));
					}
			   }
			   this.camera.view.visible = true;
			   //Main.stage.addEventListener(Event.ENTER_FRAME,this.onRender);
            }
         //}
		 this.camera.view.width = width - this.windowMargin * 2 - 2;
         this.camera.view.height = height - this.windowMargin * 2 - 2;
         this.camera.view.x = this.windowMargin;
         this.camera.view.y = this.windowMargin;
         this.camera.render(Game.stage3D);
		 Main.stage.addEventListener(Event.ENTER_FRAME,this.onRender);
         this.first_resize = false;
      }
      
      public function start(e:TimerEvent = null) : void
      {
         if(this.loadedCounter < 3)
         {
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
         else
         {
            this.firstAutoRotation = false;
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.reset();
            this.lastTime = getTimer();
            this.timer.start();
         }
      }
      
      public function onRender(e:Event) : void
      {
         this.camera.render(Game.stage3D);
      }
      
      public function stop() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public function stopAll() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.slowdownTimer.stop();
         this.slowdownTimer.removeEventListener(TimerEvent.TIMER,this.slowDown);
         this.autoRotationTimer.stop();
         this.slowdownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.start);
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         var time:int = this.lastTime;
         this.lastTime = getTimer();
         this.cameraContainer.rotationZ -= this.rotationSpeed * (this.lastTime - time) * dot1;
		 this.camera.render(Game.stage3D);
      }
   }
}
