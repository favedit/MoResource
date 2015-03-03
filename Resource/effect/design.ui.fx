//============================================================
float4      _flags;
float4      _status;
float4x4    _modelMatrix;
float4x4    _viewMatrix;
float4x4    _projectionMatrix;
float4      _ambientColor;
float4      _diffuseColor;
float4      _specularColor;
float3      _cameraPosition;
float3      _lightPosition;
float3      _lightDirection;

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
   float4 position           : SV_POSITION;
   float4 projectionPosition : PROJECTION_POSITION;
   float3 worldPosition      : POSITION;
   float4 color              : COLOR;
   float2 coord              : COORD;
   float3 normalWs           : NORMAL;
   float3 cameraDirectionWs  : CAMERA_DIRECTION_WS;
   float3 lightDirectionWs   : LIGHT_DIRECTION_WS;
};

//============================================================
VS_OUTPUT ProcessVertex( VS_INPUT input ) {
   VS_OUTPUT output;
   // 计算世界坐标
   float4 worldPosition = mul(input.position, _modelMatrix);
   float4 viewPosition = mul(worldPosition, _viewMatrix);
   float4 projectionPosition = mul(viewPosition, _projectionMatrix);
   // 计算切线转换矩阵
   float3 normalWs = normalize(mul(input.normal.xyz, (float3x3)_modelMatrix));
   // 输出结果
   output.position = projectionPosition;
   output.projectionPosition = projectionPosition;
   output.worldPosition = worldPosition.xyz;
   output.color = input.color;
   output.coord = input.coord;
   output.normalWs = normalWs;
   output.cameraDirectionWs = normalize(_cameraPosition - worldPosition.xyz);
   output.lightDirectionWs = normalize(_lightPosition - worldPosition.xyz);
   return output;
}

//------------------------------------------------------------
struct PS_INPUT {
   uint   primitiveId        : SV_PrimitiveID;
   float4 projectionPosition : PROJECTION_POSITION;
   float3 worldPosition      : POSITION;
   float4 color              : COLOR;
   float2 coord              : COORD;
   float3 normalWs           : NORMAL;
   float3 cameraDirectionWs  : CAMERA_DIRECTION_WS;
   float3 lightDirectionWs   : LIGHT_DIRECTION_WS;
};

//------------------------------------------------------------
struct PS_OUTPUT {
   int4   flags     : SV_TARGET0;
   float4 color     : SV_TARGET1;
};
//============================================================
PS_OUTPUT ProcessPixel(PS_INPUT input) : SV_TARGET{
   PS_OUTPUT output = (PS_OUTPUT)0;
   // 获得颜色，检查透明度
   float4 colorDiffuse = _ambientColor;
   // 计算顶点色
   float4 color = colorDiffuse * 0.3;
   // 计算法线
   float3 normalWs = normalize(input.normalWs);
   float3 lightDirectionWs = normalize(input.lightDirectionWs);
   float diffuseRate = saturate(dot(normalWs, lightDirectionWs));
   color += colorDiffuse * diffuseRate * 0.5;
   if(_status.x == 1){
      color *= 3;
   }
   // 设置结果
   output.flags = _flags;
   output.color = color;
   return output;
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
