package alternativa.service
{
   import alternativa.osgid.service.log.ILogService;
   
   public class DummyLogService implements ILogService
   {
       
      
      public function DummyLogService()
      {
         super();
      }
      
      public function log(level:int, message:String, exception:String = null) : void
      {
      }
   }
}
