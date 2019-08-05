package alternativa.service
{
   import alternativa.protocold.factory.ICodecFactory;
   
   public class ProtocolService implements IProtocolService
   {
       
      
      private var _codecFactory:ICodecFactory;
      
      public function ProtocolService(codecFactory:ICodecFactory)
      {
         super();
         this._codecFactory = codecFactory;
      }
      
      public function get codecFactory() : ICodecFactory
      {
         return this._codecFactory;
      }
   }
}
