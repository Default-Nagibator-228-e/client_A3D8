package forms.cong
{
   import alternativa.init.Main;
   import alternativa.tanks.gui.AlertBugWindow;
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.osgid.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.service.IResourceService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.banner.IBanner;
   import assets.icons.GarageItemBackground;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import forms.TankWindowWithHeader;
   import utils.client.panel.model.bonus.BonusItem;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   public class CongratulationsWindowWithBanner extends Sprite
   {
       
      
      private var window:TankWindowWithHeader;
      
      private var inner:TankWindowInner;
      
      public var closeButton:DefaultButton;
      
      private var messageLabel:Label;
      
      private var windowSize:Point;
      
      private var windowWidth:int = 450;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const space:int = 8;
      
      private var bannerObject:ClientObject;
      
      private var bannerContainer:Sprite;
      
      private var bannerBmp:Bitmap;
      
      private var bannerURL:String;
      
      private var itemsContainer:Sprite;
      
      public function CongratulationsWindowWithBanner(message:String, items:Array, bannerObject:ClientObject)
      {
         var numColons:int = 0;
         var preview:Bitmap = null;
         var numLabel:Label = null;
         var modelRegister:IModelService = null;
         var bannerModel:IBanner = null;
         super();
		 if (message == null || items == null)
		 {
			return;
		 }
		 var bg:GarageItemBackground = new GarageItemBackground(GarageItemBackground.ENGINE_NORMAL);
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         var evenNumberItems:Boolean = (items.length & 1) == 0;
         if(items.length == 1)
         {
            numColons = 1;
         }
         else if(items.length < 5)
         {
            numColons = 2;
         }
         else
         {
            numColons = 3;
         }
         this.bannerContainer = new Sprite();
         this.itemsContainer = new Sprite();
         this.bannerBmp = new Bitmap();
		 try{
			this.bannerContainer.addChild(this.bannerBmp);
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,97";
		 }
		 try{
			this.windowWidth = bg.width + this.windowMargin * 2 + this.margin * 2 + (bg.width + this.space) * (numColons - 1);
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,103";
		 }
		 try{
			var resourceService:IResourceService = IResourceService(Main.osgi.getService(IResourceService));
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,109";
		 }
         this.messageLabel = new Label();
         this.messageLabel.wordWrap = true;
         this.messageLabel.multiline = true;
		 try{
			this.messageLabel.text = message;
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,121";
		 }
         this.messageLabel.size = 12;
         this.messageLabel.color = 5898034;
         this.messageLabel.x = this.windowMargin * 2;
         this.messageLabel.y = this.windowMargin * 2;
         this.messageLabel.width = this.windowWidth - this.windowMargin * 4;
		 try{
			var previewId:String = String(BonusItem(items[0]).resource) + "_m0_preview";
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,129";
		 }
		 try{
			var previewBd:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, previewId).bitmapData;
		 }catch (e:Error){
			return;
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,135";
		 }
		 try{
			this.windowSize = new Point(this.windowWidth,this.messageLabel.height + this.buttonSize.y + this.windowMargin * 3 + this.margin * 3);
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,141";
		 }
         this.window = TankWindowWithHeader.createWindow("ПОЗДРАВЛЯЕМ!");
         this.window.width = this.windowSize.x;
		 this.window.height = this.windowSize.y;
         addChild(this.window);
         this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         addChild(this.inner);
         this.inner.x = this.windowMargin;
         this.inner.y = this.windowMargin;
         this.inner.width = this.windowSize.x - this.windowMargin * 2;
         this.inner.height = this.windowSize.y - this.windowMargin - this.margin * 2 - this.buttonSize.y + 2;
         addChild(this.messageLabel);
         addChild(this.itemsContainer);
         for(var i:int = 0; i < items.length; i++)
         {
            bg = new GarageItemBackground(GarageItemBackground.ENGINE_NORMAL);
            this.itemsContainer.addChild(bg);
			try{
				previewId = String(BonusItem(items[i]).resource) + "_m0_preview";
			}catch (e:Error){
				var alert:AlertBugWindow = new AlertBugWindow();
				alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,163";
			}
			try{
				previewBd = previewId != null?ResourceUtil.getResource(ResourceType.IMAGE, previewId).bitmapData:null;
			}catch (e:Error){
				return;
				var alert:AlertBugWindow = new AlertBugWindow();
				alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,169" + "it: " + items[i] + " i: " + i;
			}
			try{
				preview = new Bitmap(previewBd);
			}catch (e:Error){
				var alert:AlertBugWindow = new AlertBugWindow();
				alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,175";
			}
            this.itemsContainer.addChild(preview);
            bg.x = (!evenNumberItems && i > items.length - numColons?bg.width + this.space >> 1:0) + int(i % numColons) * (bg.width + this.space);
            bg.y = (bg.height + this.space) * int(i / numColons);
            preview.x = bg.x + (bg.width - preview.width >> 1);
            preview.y = bg.y + (bg.height - preview.height >> 1);
            numLabel = new Label();
            this.itemsContainer.addChild(numLabel);
            numLabel.size = 16;
            numLabel.color = 5898034;
            numLabel.text = "×" + BonusItem(items[i]).count.toString();
            numLabel.x = bg.x + bg.width - numLabel.width - 15;
            numLabel.y = bg.y + bg.height - numLabel.height - 10;
         }
		 try{
			this.windowSize.y = this.windowSize.y + this.itemsContainer.height;
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,194";
		 }
         this.closeButton = new DefaultButton();
         addChild(this.closeButton);
		 try{
			this.closeButton.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,202";
		 }
         this.closeButton.y = this.windowSize.y - this.margin - this.buttonSize.y - 2;
		 try{
			this.placeItems();
		 }catch (e:Error){
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,209";
		 }
         addChild(this.bannerContainer);
         this.window.height = this.windowSize.y;
         this.window.width = this.windowSize.x;
         if(bannerObject != null)
         {
            this.bannerObject = bannerObject;
			try{
				modelRegister = Main.osgi.getService(IModelService) as IModelService;
			}catch (e:Error){
				var alert:AlertBugWindow = new AlertBugWindow();
				alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,221";
			}
			try{
				bannerModel = (modelRegister.getModelsByInterface(IBanner) as Vector.<IModel>)[0] as IBanner;
			}catch (e:Error){
				var alert:AlertBugWindow = new AlertBugWindow();
				alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,227";
			}
			try{
				this.bannerBd = bannerModel.getBannerBd(bannerObject);
			}catch (e:Error){
				var alert:AlertBugWindow = new AlertBugWindow();
				alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,233";
			}
			try{
				this.bannerURL = bannerModel.getBannerURL(bannerObject);
			}catch (e:Error){
				var alert:AlertBugWindow = new AlertBugWindow();
				alert.text = "Прызышла ашыбка: CongratulationsWindowWithBanner,239";
			}
            this.bannerContainer.addEventListener(MouseEvent.CLICK,this.onBannerClick);
            this.bannerContainer.buttonMode = true;
         }
      }
      
      private function placeItems() : void
      {
         this.messageLabel.width = this.windowWidth - this.windowMargin * 4;
         this.itemsContainer.y = this.messageLabel.y + this.messageLabel.height + this.windowMargin;
         this.itemsContainer.x = this.windowSize.x - this.itemsContainer.width >> 1;
         this.inner.width = this.windowSize.x - this.windowMargin * 2;
         this.inner.height = this.windowSize.y - this.windowMargin - this.margin * 2 - this.buttonSize.y + 2;
         this.closeButton.x = this.windowSize.x - this.buttonSize.x >> 1;
      }
      
      public function set bannerBd(value:BitmapData) : void
      {
         this.bannerBmp.bitmapData = value;
         this.windowSize.y = this.windowSize.y + this.bannerBmp.height + this.margin - 1;
         this.windowWidth = this.windowSize.x = Math.max(this.windowSize.x,this.bannerBmp.width + this.windowMargin * 2 + this.margin * 2);
         this.window.height = this.windowSize.y;
         this.window.width = this.windowSize.x;
         this.placeItems();
         this.bannerBmp.x = this.windowWidth - this.bannerBmp.width >> 1;
         this.bannerBmp.y = this.inner.y + this.inner.height - this.margin - this.bannerBmp.height - 1;
         this.closeButton.y = this.windowSize.y - this.margin - this.buttonSize.y - 2;
      }
      
      public function get banner() : Bitmap
      {
         return this.bannerBmp;
      }
      
      private function onBannerOver(e:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.HAND;
      }
      
      private function onBannerOut(e:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.ARROW;
      }
      
      private function onBannerClick(e:MouseEvent) : void
      {
         Main.writeVarsToConsoleChannel("BannerModel","onBannerClick");
         navigateToURL(new URLRequest(this.bannerURL),"_blank");
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var bannerModel:IBanner = (modelRegister.getModelsByInterface(IBanner) as Vector.<IModel>)[0] as IBanner;
         bannerModel.click(this.bannerObject);
      }
   }
}
