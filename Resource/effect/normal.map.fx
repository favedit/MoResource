//============================================================
float4x4 _modelMatrix;
float4x4 _viewMatrix;
float4x4 _projectionMatrix;

//============================================================
struct VS_INPUT {
   float4 position : POSITION;
   float2 coord    : COORD;
   float4 normal   : NORMAL;
};

//------------------------------------------------------------
struct VS_OUTPUT {
   float4 position : SV_POSITION;
   float4 normal   : NORMAL;
};

//============================================================
VS_OUTPUT ProcessVertex( VS_INPUT input ) {
   VS_OUTPUT output;
   // 计算世界坐标
   float4 position = (float4)0;
   position.x = input.coord.x * 2.0 - 1.0;
   position.y = 1.0 - (input.coord.y * 2.0);
   if(input.position.x >= 0){
      position.z = -0.5;
   }else{
      position.z = 0;
   }
   position.w = 1;
   // 输出结果
   output.position = position;
   output.normal = input.normal;
   return output;
}

//============================================================
float4 ProcessPixel(VS_OUTPUT input) : SV_Target{
   float4 normal = (float4)0;
   normal.xy = input.normal.xy * 0.5 + 0.5;
   normal.z = input.normal.z;
   normal.w = 1.0;
   return normal;
}

//============================================================
technique10 Render
{
   pass P0
   {
      SetVertexShader( CompileShader( vs_5_0, ProcessVertex() ) );
      SetPixelShader( CompileShader( ps_5_0, ProcessPixel() ) );
   }
}
