package alternativa.tanks.materials 
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Renderer;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.A3DUtils;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.materials.ShaderProgram;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import utils.adobe.utils.AGALMiniAssembler;
	
	use namespace alternativa3d;
	
	public class LeftTrackMaterial extends Material
	{
		
		public var diffuseMap:TextureResource;
		
		public var distance:Number = 0;
		
		private var _vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		private var _fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		private var program:ShaderProgram;
		
		private var context:Context3D;
		
		public var alpha:Number = 0;
		
		public function LeftTrackMaterial(param1:BitmapData) 
		{
			super();
			var sa:BitmapTextureResource = new BitmapTextureResource(param1);
			sa.upload(Game.context);
			this.diffuseMap = sa;
			this.context = Game.context;
			program = new ShaderProgram(null, null);
			_vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, 
				"m44 vt0, va0, vc1\n" + 
				"mov vt1, va1\n" + 
				"sub vt1.x, vc0.x, va1.x\n" + 
				"mov v0, vt1\n" +
				"mov v1, va0\n" +
				"mov op, vt0\n"
			);
			_fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
				"mov ft1.x,v1.x\n" +
				"neg ft2.x,ft1.x\n" +
				"kil ft2.x\n" + 
				"tex ft0, v0, fs0 <2D, repeat, linear, miplinear>\n" + 
				"mov ft0.w, fc0.w\n" +
				"mov oc, ft0\n"
			);
		}
		
		override alternativa3d function fillResources(resources:Dictionary, resourceType:Class):void {
			super.fillResources(resources, resourceType);
			//текстура №1
			if (diffuseMap != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(diffuseMap)) as Class, resourceType)) {
				resources[diffuseMap] = true;
			}
			//шейдерная программа
			program.program = context.createProgram();
			program.program.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);
		}
		
		override alternativa3d function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, useShadow:Boolean, objectRenderPriority:int = -1):void {
			//получаем ссылку на объект через его сурфейсу
			var object:Object3D = surface.object;
			//буфер позиции
			var positionBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			//буфер uv-координат
			var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);
					  
			program.program = context.createProgram();
			program.program.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);
			 
			var drawUnit:DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);
			//для вершинного шейдера загружаем буфер позиции и uv-координат
			//при этом указываем их формат float3, float2
			drawUnit.setVertexBufferAt(0, positionBuffer, 0, "float3");
			drawUnit.setVertexBufferAt(1, uvBuffer, 3, "float2");
			//передаем матрицу проекции
			drawUnit.setVertexConstantsFromNumbers(0, distance, 0, 0, 1);
			drawUnit.setProjectionConstants(camera, 1, object.localToCameraTransform);
			 
			//устанавливаем текстуру №1
			drawUnit.setTextureAt(0, diffuseMap._texture);
			//добавляем сурфейс на отрисовку
			camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority:Renderer.OPAQUE);
		}
		
	}

}