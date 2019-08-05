package utils.client.warfare.models.common.longterm
{
   import utils.client.models.ClientObject;
   import alternativa.typesd.Long;
   
   public interface ILongTermBonusModelBase
   {
       
      
      function effectStart(param1:ClientObject, param2:Long, param3:int) : void;
      
      function effectStop(param1:ClientObject, param2:Long) : void;
   }
}
