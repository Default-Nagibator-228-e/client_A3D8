package alternativa.tanks
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Resource;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Surface;
   import alternativa.engine3d.resources.BitmapTextureResource;
   import alternativa.init.Main;
   import alternativa.tanks.materials.AnimatedPaintMaterial;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import utils.ByteArrayMap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   import alternativa.tanks.gui.resource.images.MultiframeResourceData;
   
   public class Tank3D extends Object3D
   {
      
      private static var defaultColormap:BitmapData;
       
      
      private var hull:Tank3DPart;
      
      private var turret:Tank3DPart;
      
      private var colormap:BitmapData;
      
      private var animatedColormap:Boolean;
      
      private var multiframeData:MultiframeResourceData;
      
      public function Tank3D(hull:Tank3DPart, turret:Tank3DPart, colormap:ImageResouce)
      {
         super();
         this.setHull(hull);
         this.setTurret(turret);
         this.setColorMap(colormap);
      }
      
      private function getDefaultColormap() : BitmapData
      {
         if(defaultColormap == null)
         {
            defaultColormap = new BitmapData(1,1,false,6710886);
         }
         return defaultColormap;
      }
      
      public function setColorMap(colormap:ImageResouce) : void
      {
         this.colormap = colormap != null?colormap.bitmapData as BitmapData:this.getDefaultColormap();
         if(this.hull != null)
         {
            this.hull.animatedPaint = colormap != null?Boolean(colormap.animatedMaterial):Boolean(false);
         }
         if(this.turret != null)
         {
            this.turret.animatedPaint = colormap != null?Boolean(colormap.animatedMaterial):Boolean(false);
         }
         this.animatedColormap = colormap != null?Boolean(colormap.animatedMaterial):Boolean(false);
         this.multiframeData = colormap != null?colormap.multiframeData:null;
         this.updatePartTextureh(this.hull);
         this.updatePartTexturet(this.turret);
      }
      
      public function setHull(value:Tank3DPart) : void
      {
         if(this.hull != null)
         {
            for each(var d1:Mesh in this.hull.ob)
			 {
				 removeChild(d1);
			 }
         }
         if(value == null)
         {
            return;
         }
         this.hull = value;
		 for each(var d:Mesh in this.hull.ob)
		 {
			 addChild(d);
			 d.setMaterialToAllSurfaces(null);
			 d.geometry.calculateNormals();
			 d.geometry.calculateTangents(0);
			 d.calculateBoundBox();
			 d.x = 0;
			 d.y = 0;
			 d.z = 0;
		 }
         this.updatePartTextureh(this.hull);
         this.updateMountPoint();
      }
      
      public function setTurret(value:Tank3DPart) : void
      {
         if(this.turret != null)
         {
            removeChild(this.turret.mesh);
         }
         if(value == null)
         {
            return;
         }
         this.turret = value;
         addChild(this.turret.mesh);
         this.updatePartTexturet(this.turret);
         this.updateMountPoint();
      }
      
      private function updatePartTextureh(part:Tank3DPart) : void
      {
         if(part == null || this.colormap == null)
         {
            return;
         }
         var shape:Shape = new Shape();
         shape.graphics.beginBitmapFill(this.colormap);
         shape.graphics.drawRect(0,0,part.lightmap.width,part.lightmap.height);
         var texture:BitmapData = new BitmapData(part.lightmap.width,part.lightmap.height,false,0);
         texture.draw(shape);
         texture.draw(part.lightmap,null,null,BlendMode.HARDLIGHT);
         texture.draw(part.details);
		for each(var d:Mesh in part.ob)
		{
			if(this.animatedColormap)
			{
				d.setMaterialToAllSurfaces(new AnimatedPaintMaterial(this.colormap,part.lightmap,part.details,this.colormap.width / this.multiframeData.widthFrame,this.colormap.height / this.multiframeData.heigthFrame,this.multiframeData.fps,this.multiframeData.numFrames,1));
			}
			else
			{
				for each(var d2:Surface in d._surfaces)
				 {
					 var s:BitmapTextureResource = new BitmapTextureResource(texture);
					 s.upload(Game.stage3D.context3D);
					 var ms:TextureMaterial = new TextureMaterial(s);
					 d2.material = ms;
				 }
			}
			for each(var r:Resource in d.getResources(true))
			{
				r.upload(Game.context);
			}
		}
      }
	  
	  private function updatePartTexturet(part:Tank3DPart) : void
      {
         if(part == null || this.colormap == null)
         {
            return;
         }
         var shape:Shape = new Shape();
         shape.graphics.beginBitmapFill(this.colormap);
         shape.graphics.drawRect(0,0,part.lightmap.width,part.lightmap.height);
         var texture:BitmapData = new BitmapData(part.lightmap.width,part.lightmap.height,false,0);
         texture.draw(shape);
         texture.draw(part.lightmap,null,null,BlendMode.HARDLIGHT);
         texture.draw(part.details);
		if(this.animatedColormap)
		{
			part.mesh.setMaterialToAllSurfaces(new AnimatedPaintMaterial(this.colormap,part.lightmap,part.details,this.colormap.width / this.multiframeData.widthFrame,this.colormap.height / this.multiframeData.heigthFrame,this.multiframeData.fps,this.multiframeData.numFrames,1));
		}
		else
		{
			var ms:TextureMaterial = new TextureMaterial(new BitmapTextureResource(texture));
			ms.alphaThreshold = 1;
			part.mesh.setMaterialToAllSurfaces(ms);
		}
		for each(var r:Resource in part.mesh.getResources(true))
		{
			r.upload(Game.context);
		}
      }
      
      private function updateMountPoint() : void
      {
         if(this.hull == null || this.turret == null)
         {
            return;
         }
         this.turret.mesh.x = this.hull.turretMountPoint.x;
         this.turret.mesh.y = this.hull.turretMountPoint.y;
         this.turret.mesh.z = this.hull.turretMountPoint.z;
      }
   }
}
