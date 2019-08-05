package alternativa.tanks.config
{
   import alternativa.proplib.PropLibRegistry;
   import utils.TaskSequence;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="complete",type="flash.events.Event")]
   public class Config extends EventDispatcher
   {
       
      
      public var xml:XML;
                  
      public var propLibRegistry:PropLibRegistry;
      
      private var taskSequence:TaskSequence;
      
      public function Config()
      {
         super();
      }
      
      public function load(mapId:String) : void
      {
         this.taskSequence = new TaskSequence();
         this.taskSequence.addTask(new PropLibsLoader(this,mapId + ".tara"));
         this.taskSequence.addTask(new TanksMap(this,mapId));
         this.taskSequence.addEventListener(Event.COMPLETE,this.onSequenceComplete);
         this.taskSequence.run();
      }
      
      private function onSequenceComplete(event:Event) : void
      {
         this.taskSequence = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
