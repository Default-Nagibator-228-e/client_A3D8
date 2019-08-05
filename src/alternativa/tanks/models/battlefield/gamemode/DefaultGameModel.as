package alternativa.tanks.models.battlefield.gamemode
{
   import alternativa.engine3d.lights.AmbientLight;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.shadows.DirectionalLightShadow;
   import alternativa.tanks.models.battlefield.BattleView3D;
   import flash.display.BitmapData;
   
   public class DefaultGameModel implements IGameMode
   {
       
      
      public function DefaultGameModel()
      {
         super();
      }
      
      public function applyChanges(viewport:BattleView3D) : void
      {
         var ambient:AmbientLight = new AmbientLight(0x8bccfa);//0x8bccfa
		 ambient.intensity = 0.6;
		 viewport.rootContainer.addChild(ambient);
		 BattleView3D.dirLight.intensity = 1.2;
		 BattleView3D.dirLight.z = 125;
		 BattleView3D.dirLight.x = 100;
		 BattleView3D.dirLight.y = 100;
		 BattleView3D.dirLight.lookAt(0, 0, 0);
		 viewport.rootContainer.addChild(BattleView3D.dirLight);
		 BattleView3D.shadow.biasMultiplier = 0.996;//0.993;
		 //BattleView3D.dirLight.shadow = BattleView3D.shadow;
      }
      
      public function applyColorchangesToSkybox(skybox:BitmapData) : BitmapData
      {
         return skybox;
      }
   }
}
