package utils.client.warfare.models.effects.firstaid
{
   import utils.client.models.ClientObject;
   import alternativa.typesd.Long;
   
   public interface IFirstAidModelBase
   {
       
      
      function activated(param1:ClientObject, param2:Long) : void;
   }
}
