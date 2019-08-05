package alternativa.service
{
   import alternativa.protocold.factory.ICodecFactory;
   
   public interface IProtocolService
   {
       
      
      function get codecFactory() : ICodecFactory;
   }
}
