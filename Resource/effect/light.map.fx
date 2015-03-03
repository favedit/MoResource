//============================================================
struct VS_INPUT {
   float4 position : POSITION;
   float2 coord    : COORD;
   float4 color    : COLOR;
};

//------------------------------------------------------------
struct VS_OUTPUT {
   float4 position : SV_POSITION;
   float4 color    : COLOR;
};

//============================================================
VS_OUTPUT ProcessVertex( VS_INPUT input ) {
   VS_OUTPUT output;
   // 计算世界坐标
   float4 position = (float4)0;
   position.x = input.coord.x * 2.0 - 1.0;
   position.y = 1.0 - (input.coord.y * 2.0);
   position.z = 0;
   position.w = 1;
   // 输出结果
   output.position = position;
   output.color = input.color;
   return output;
}

//============================================================
float4 ProcessPixel(VS_OUTPUT input) : SV_Target{
   float4 color = (float4)1;
   color.xyz = input.color;
   return color;
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
