package alternativa.osgid.service.dump.dumper
{
   public interface IDumper
   {
       
      
      function dump(param1:Vector.<String>) : String;
      
      function get dumperName() : String;
   }
}
