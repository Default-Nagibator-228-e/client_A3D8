package alternativa.tanks.models.effects.zone 
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.init.Main;
	import alternativa.math.Vector3;
	import alternativa.tanks.models.battlefield.BattlefieldModel;
	import alternativa.tanks.models.battlefield.IBattleField;
	import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
	import alternativa.tanks.sfx.SimplePlane;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author 
	 */
	public class Zone 
	{
		
		[Embed(source="arm.png")]
		private var a:Class;
		[Embed(source="cry.png")]
		private var c:Class;
		[Embed(source="dam.png")]
		private var d:Class;
		[Embed(source="hea.png")]
		private var h:Class;
		[Embed(source="nit.png")]
		private var n:Class;
		private var ar:TextureMaterial = new TextureMaterial(new BitmapTextureResource(new a().bitmapData));
		private var cr:TextureMaterial = new TextureMaterial(new BitmapTextureResource(new c().bitmapData));
		private var dr:TextureMaterial = new TextureMaterial(new BitmapTextureResource(new d().bitmapData));
		private var hr:TextureMaterial = new TextureMaterial(new BitmapTextureResource(new h().bitmapData));
		private var nr:TextureMaterial = new TextureMaterial(new BitmapTextureResource(new n().bitmapData));
		
		public function Zone() 
		{
			
		}
		
		public function ded(p:Vector3, t:String) :void
		{
			var f:Object3D = BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport._mapContainer;
			var ds:BitmapData = new a().bitmapData;
			var me:SimplePlane = new SimplePlane(ds.width*2,ds.height*2,1,1);
			me.x = p.x;
			me.y = p.y;
			me.z = p.z;
			me.setMaterialToAllSurfaces(t == "arm"?ar:t == "cry"?cr:t == "dam"?dr:t == "hea"?hr:nr);
			f.addChildAt(me,0);
		}
	}

}