package alternativa.debug
{
   import alternativa.init.Main;
   import alternativa.osgid.service.locale.ILocaleService;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import controls.base.DefaultButtonBase;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldAutoSize;
   
   public class ServerMessageWindow extends Sprite
   {
      [Embed(source="1.png")]
      private static const IconImage:Class;
      
      private static const iconImage:BitmapData = new IconImage().bitmapData;
      
      private var _refreshButton:DefaultButtonBase;
      
      private var _supportLink:LabelBase;
      
      private var window:TankWindow;
      
      private var description:Label;
      
      private var field:TankWindowInner;
      
      private var icon:Bitmap;
      
      private var SUPPORT_URL:String;
	  
	  public var closeButton:DefaultButtonBase;
      
      public function ServerMessageWindow()
      {
         var _loc5_:Number = NaN;
         super();
         var _loc2_:Number = 300;
         var _loc3_:Number = 12;
         var _loc4_:Number = 10;
         _loc5_ = -2;
         var _loc6_:Number = 47;
         var _loc7_:Number = 33;
         var _loc8_:Number = 100;
         this.icon = new Bitmap(iconImage);
         this.icon.x = 23;
         this.icon.y = 23;
		 closeButton = new DefaultButtonBase();
		 closeButton.label = "Ок";
         this.description = new LabelBase();
         this.description.autoSize = TextFieldAutoSize.LEFT;
         this.description.x = 23;
         this.description.y = this.icon.y + this.icon.height + 23;
         this.description.selectable = true;
         if(this.description.y + this.description.height > this.icon.y + this.icon.height)
         {
            _loc6_ = _loc6_ + (this.description.y + this.description.height - this.icon.y - this.icon.height);
         }
         this.window = new TankWindow(_loc2_,_loc3_ + _loc6_ + _loc4_ + _loc7_ + _loc4_ + _loc5_ + _loc7_ + _loc3_);
         this.field = new TankWindowInner(_loc2_ - _loc3_ * 2,_loc6_,TankWindowInner.GREEN);
         this.field.x = _loc3_;
         this.field.y = _loc3_;
         addChild(this.window);
         this.window.addChild(this.field);
         this.window.addChild(this.icon);
         this.window.addChild(this.description);
		 this.closeButton.x = this.width / 2 - this.closeButton.width / 2;
		 this.closeButton.y = this.field.height + this.field.y + ((this.height - this.field.height - this.field.y) / 2 - this.closeButton.height / 2);
		 this.window.addChild(this.closeButton);
         this.redraw();
		 Main.stage.addEventListener(Event.RESIZE, redraw);
		 this.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
      }
      
      private function reposition(e:Event = null) : void
      {
		 this.window.x = Main.stage.stageWidth - this.window.width >> 1;
         this.window.y = Main.stage.stageHeight - this.window.height >> 1;
      }
	  
	  private function onCloseClick(param1:MouseEvent) : void
      {
         Main.debug.hideServerMessageWindow();
      }
      
      private function onSupportClick(param1:TextEvent) : void
      {
         navigateToURL(new URLRequest(this.SUPPORT_URL),"_blank");
      }
      
      public function redraw(e:Event = null) : void
      {
         this.field.width = 30 + this.description.width;
		 this.field.height = Math.max(this.icon.height,this.description.height) + 60;
         this.window.width = this.field.width + 24;
         this.window.height = this.field.height + 50;
		 icon.x = this.window.width - icon.width >> 1;
         //if(this.description.height < this.icon.height)
         //{
            this.description.y = this.icon.y + this.icon.height + 23 / 2;
         //}
		 this.closeButton.x = this.width / 2 - this.closeButton.width / 2;
		 this.closeButton.y = this.field.height - 4 + this.field.y + ((this.height - this.field.height - this.field.y) / 2 - this.closeButton.height / 2);
         this.reposition();
      }
      
      public function set text(param1:String) : void
      {
		 this.description.text = param1;
         this.redraw();
      }
      
      public function setSupportUrl(param1:String) : void
      {
         this.SUPPORT_URL = param1;
      }
   }
}
