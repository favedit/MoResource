//============================================================
float4x4    _modelMatrix;
float4x4    _viewMatrix;
float4x4    _projectionMatrix;
Texture2D   _textureDiffuse;
Texture2D   _textureNormal;
Texture2D   _textureHeight;
Texture2D   _textureSpecular;
Texture2D   _textureSpecularLevel;

SamplerState ModelTextureSampler {
   Filter = MIN_MAG_MIP_LINEAR;
   AddressU = Wrap;
   AddressV = Wrap;
};

//============================================================
struct VS_IN {
   float4 position : POSITION;
   float2 coord    : COORD;
   float4 normal   : NORMAL;
   float3 binormal : BINORMAL;
   float3 tangent  : TANGENT;
};

//------------------------------------------------------------
struct PS_IN {
   float4 position : SV_POSITION;
   float2 coord    : COORD;
};

//============================================================
PS_IN ProcessVertex( VS_IN input ) {
   PS_IN output = (PS_IN)0;
   // 计算世界坐标
   float4 worldPosition = mul(input.position, _modelMatrix);
   float4 viewPosition = mul(worldPosition, _viewMatrix);
   float4 projectionPosition = mul(viewPosition, _projectionMatrix);
   // 输出结果
   output.position = projectionPosition;
   output.coord = input.coord;
   return output;
}

//============================================================
float4 ProcessPixel( PS_IN input ) : SV_Target {
   float4 color = float4(1.0, 1.0, 1.0, 1.0);
   color = _textureDiffuse.Sample(ModelTextureSampler, input.coord);
   return color;
}

//============================================================
technique10 Render
{
   pass P0
   {
      SetVertexShader( CompileShader( vs_5_0, ProcessVertex() ) );
      SetGeometryShader( NULL );
      SetPixelShader( CompileShader( ps_5_0, ProcessPixel() ) );
   }
}