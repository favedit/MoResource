//============================================================
Texture2D _textureFlags;
Texture2D _textureColor;
Texture2D _textureColorUi;
Texture2D _texturePosition;
Texture2D _textureNormal;
Texture2D _textureSelected;

SamplerState ModelTextureSampler {
   Filter = MIN_MAG_MIP_LINEAR;
   AddressU = Wrap;
   AddressV = Wrap;
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
   VS_OUTPUT output = (VS_OUTPUT)0;
   // 输出结果
   output.position = input.position;
   output.coord = input.coord;
   return output;
}

float2 ConstPixelCoord[9] = {
   {-1, -1}, { 0, -1}, { 1, -1},
   {-1,  0}, { 0,  0}, { 1,  0},
   {-1,  1}, { 0,  1}, { 1,  1},
};

//============================================================
float4 ProcessPixel(VS_OUTPUT input) : SV_Target{
   // 获得颜色
   float4 color = _textureColor.Sample(ModelTextureSampler, input.coord);
   // 获得UI颜色
   float4 colorUi = _textureColorUi.Sample(ModelTextureSampler, input.coord);
   // 边线测试
   float colorTotal = 0;
   float4 selectedData = _textureSelected.Sample(ModelTextureSampler, input.coord);
   for(int n = 0; n < 9; n++){
      float2 coordPosition = input.coord + ConstPixelCoord[n] / 2048.0f;
      float4 selectedDataAvg = _textureSelected.Sample(ModelTextureSampler, coordPosition);
      if(selectedData.w != selectedDataAvg.w){
         colorTotal += 1;
      }
   }
   colorTotal = colorTotal / 9;
   // 设置输出颜色
   float4 result = float4(1.0, 1.0, 1.0, 1.0);
   if(colorUi.a > 0){
      result = colorUi;
   }else{
      result = color += float4(109.0 / 255.0, 153.0 / 255.0, 215.0 / 255.0, 1) * colorTotal;
   }
   // 获得颜色
   return result;
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
