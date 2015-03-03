//============================================================
float4      _ids;
float4x4    _modelMatrix;
float4x4    _viewMatrix;
float4x4    _projectionMatrix;
float3      _cameraPosition;
float3      _lightPosition;
float3      _lightDirection;
Texture2D   _textureDiffuse;
Texture2D   _textureAlpha;
Texture2D   _textureNormal;
Texture2D   _textureHeight;
Texture2D   _textureSpecular;
Texture2D   _textureSpecularLevel;
Texture2D   _textureEnvironment;

SamplerState ModelTextureSampler {
   Filter = MIN_MAG_MIP_LINEAR;
   AddressU = Wrap;
   AddressV = Wrap;
};

//============================================================
struct VS_INPUT {
   float4 position : POSITION;
   float4 color    : COLOR;
   float2 coord    : COORD;
   float4 normal   : NORMAL;
   float3 binormal : BINORMAL;
   float3 tangent  : TANGENT;
};

//------------------------------------------------------------
struct VS_OUTPUT {
   float4 position          : SV_POSITION;
};

//============================================================
VS_OUTPUT ProcessVertex( VS_INPUT input ) {
   VS_OUTPUT output;
   // 计算世界坐标
   float4 worldPosition = mul(input.position, _modelMatrix);
   float4 viewPosition = mul(worldPosition, _viewMatrix);
   float4 projectionPosition = mul(viewPosition, _projectionMatrix);
   // 输出结果
   output.position = projectionPosition;
   return output;
}

//============================================================
float4 ProcessPixel(VS_OUTPUT input) : SV_TARGET{
   return float4(1.0, 1.0, 1.0, 1.0);
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
