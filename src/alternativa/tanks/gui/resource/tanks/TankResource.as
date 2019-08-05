package alternativa.tanks.gui.resource.tanks
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Mesh;
   import flash.geom.Vector3D;
   
   public class TankResource
   {
       
      
      private var mesh1:Mesh;
      
      public var next:Object;
      
      public var id:String;
      
      public var muzzles:Vector.<Vector3D>;
      
      public var flagMount:Vector3D;
      
      public var turretMount:Vector3D;
      
      public var objects:Vector.<Object3D>;
	  
	  public var om:Vector.<Mesh> = new Vector.<Mesh>();
      
      public function TankResource(mesh2:Mesh, id:String, objects:Vector.<Object3D> = null, next:Object = null, muzzles:Vector.<Vector3D> = null, flagMount:Vector3D = null, turretMount:Vector3D = null)
      {
         super();
         mesh1 = mesh2;
		 if (mesh1 != null) mesh1.geometry.upload(Game.context);
         this.id = id;
         this.next = next;
         this.muzzles = muzzles;
         this.flagMount = flagMount;
         this.turretMount = turretMount;
         this.objects = objects;
		 if (objects == null) return;
		 for each(var obt:* in objects)
		 {
			if (obt is Mesh && obt == null) continue;
			var ggd:Mesh = Mesh(Mesh(obt).clone());
			ggd.geometry.upload(Game.context);
			om.push(ggd);
		 }
      }
	  
	  public function get mesh() : Mesh
	  {
		return mesh1.clone() as Mesh;
	  }
   }
}
