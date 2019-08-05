package alternativa.osgid.service.storage
{
   import flash.net.SharedObject;
   
   public interface IStorageService
   {
       
      
      function getStorage() : SharedObject;
   }
}
