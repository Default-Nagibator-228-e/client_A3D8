package alternativa.protocold.factory
{
   import alternativa.protocold.codec.ICodec;
   import alternativa.protocold.codec.complex.ArrayCodec;
   import alternativa.protocold.codec.complex.StringCodec;
   import alternativa.protocold.codec.primitive.BooleanCodec;
   import alternativa.protocold.codec.primitive.ByteCodec;
   import alternativa.protocold.codec.primitive.DoubleCodec;
   import alternativa.protocold.codec.primitive.FloatCodec;
   import alternativa.protocold.codec.primitive.IntegerCodec;
   import alternativa.protocold.codec.primitive.LongCodec;
   import alternativa.protocold.codec.primitive.ShortCodec;
   import alternativa.protocold.type.Byte;
   import alternativa.protocold.type.Float;
   import alternativa.protocold.type.Short;
   import alternativa.typesd.Long;
   import flash.utils.Dictionary;
   
   public class CodecFactory implements ICodecFactory
   {
       
      
      private var codecs:Dictionary;
      
      private var notnullArrayCodecs:Dictionary;
      
      private var nullArrayCodecs:Dictionary;
      
      public function CodecFactory()
      {
         super();
         this.codecs = new Dictionary();
         this.notnullArrayCodecs = new Dictionary();
         this.nullArrayCodecs = new Dictionary();
         this.registerCodec(int,new IntegerCodec());
         this.registerCodec(Short,new ShortCodec());
         this.registerCodec(Byte,new ByteCodec());
         this.registerCodec(Number,new DoubleCodec());
         this.registerCodec(Float,new FloatCodec());
         this.registerCodec(Boolean,new BooleanCodec());
         this.registerCodec(Long,new LongCodec());
         this.registerCodec(String,new StringCodec());
      }
      
      public function registerCodec(targetClass:Class, codec:ICodec) : void
      {
         this.codecs[targetClass] = codec;
      }
      
      public function unregisterCodec(targetClass:Class) : void
      {
         this.codecs[targetClass] = null;
      }
      
      public function getCodec(targetClass:Class) : ICodec
      {
         return this.codecs[targetClass];
      }
      
      public function getArrayCodec(targetClass:Class, elementnotnull:Boolean = true, depth:int = 1) : ICodec
      {
         var codec:ArrayCodec = null;
         var dict:Dictionary = null;
         if(elementnotnull)
         {
            dict = this.notnullArrayCodecs;
         }
         else
         {
            dict = this.nullArrayCodecs;
         }
         if(dict[targetClass] == null)
         {
            dict[targetClass] = new Dictionary(false);
         }
         if(dict[targetClass][depth] == null)
         {
            codec = new ArrayCodec(targetClass,this.getCodec(targetClass),elementnotnull,depth);
            dict[targetClass][depth] = codec;
         }
         else
         {
            codec = dict[targetClass][depth];
         }
         return codec;
      }
   }
}
