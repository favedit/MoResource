//============================================================
// 纹理列表
Texture2D   _textureColor;

SamplerState ModelTextureSampler {
   Filter = MIN_MAG_LINEAR_MIP_POINT;
   AddressU = Clamp;
   AddressV = Clamp;
};

//============================================================
struct VS_INPUT {
   float4 position : POSITION;
   float2 coord    : COORD;
};

//------------------------------------------------------------
struct VS_OUTPUT {
   float4 position : SV_POSITION;
   float2 coord    : COORD;
};

//============================================================
VS_OUTPUT ProcessVertex( VS_INPUT input ) {
   VS_OUTPUT output;
   // 输出结果
   output.position = input.position;
   output.coord.x = input.coord.x;
   output.coord.y = 1 - input.coord.y;
   return output;
}

float2 ConstPixelCoord[8] = {
   {-1, -1}, { 0, -1}, { 1, -1},
   {-1,  0},           { 1,  0},
   {-1,  1}, { 0,  1}, { 1,  1},
};

//============================================================
float4 ProcessPixel(VS_OUTPUT input) : SV_Target{
   float alpha = 0.99;
   // 获得当前点颜色
   float4 textureColor = _textureColor.Sample(ModelTextureSampler, input.coord);
   // 获得平均颜色
   float4 color = (float4)0;
   float count = 0;
   for(int n = 0; n < 8; n++){
      float2 coordPosition = input.coord + ConstPixelCoord[n] / 1024.0f;
      float4 colorQuery = _textureColor.Sample(ModelTextureSampler, coordPosition);
      if(colorQuery.w > alpha){
         color += colorQuery;
         count++;
      }
   }
   // 颜色混合
   if(textureColor.w > alpha){
      color = textureColor;
   }else{
      if(count > 0){
         color = color / count;
         color.w = 1.0;
      }else{
         color.w = 0.0;
      }
   }
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
