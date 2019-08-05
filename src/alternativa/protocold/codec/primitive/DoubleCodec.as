package alternativa.protocold.codec.primitive
{
   import alternativa.protocold.codec.AbstractCodec;
   import alternativa.protocold.codec.NullMap;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class DoubleCodec extends AbstractCodec
   {
       
      
      public function DoubleCodec()
      {
         super();
         nullValue = Number.NEGATIVE_INFINITY;
      }
      
      override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         return reader.readDouble();
      }
      
      override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean) : void
      {
         dest.writeDouble(Number(object));
      }
   }
}
