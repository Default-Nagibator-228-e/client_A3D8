package alternativa.service
{
   import alternativa.osgid.service.log.ILogService;
   
   public class Logger implements ILogService
   {
       
      
      public function Logger()
      {
         super();
      }
      
      public static function log(logLevel:int, message:String, exception:String = null) : void
      {
      }
      
      public function log(logLevel:int, message:String, exception:String = null) : void
      {
      }
   }
}
