//============================================================
float4      _flags;
float4x4    _modelMatrix;
float4x4    _viewMatrix;
float4x4    _projectionMatrix;
float3      _cameraPosition;
float3      _lightPosition;
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
   float3 worldPosition     : POSITION;
   float4 color             : COLOR;
   float2 coord             : COORD;
   float3 cameraDirectionTs : CAMERA_DIRECTION_TS;
   float3 lightDirectionTs  : LIGHT_DIRECTION_TS;
};

//============================================================
VS_OUTPUT ProcessVertex( VS_INPUT input ) {
   VS_OUTPUT output;
   // 计算世界坐标
   float4 worldPosition = mul(input.position, _modelMatrix);
   float4 viewPosition = mul(worldPosition, _viewMatrix);
   float4 projectionPosition = mul(viewPosition, _projectionMatrix);
   // 计算切线转换矩阵
   float3 normalTs = mul(input.normal.xyz, (float3x3)_modelMatrix);
   float3 tangentTs = mul(input.binormal, (float3x3)_modelMatrix);
   float3 binormalTs = mul(input.tangent, (float3x3)_modelMatrix);
   normalTs = normalize(normalTs);
   tangentTs = normalize(tangentTs);
   binormalTs = normalize(binormalTs);
   float3x3 tangentMatrix = float3x3(normalTs, tangentTs, binormalTs);
   // 计算切线空间相机的方向
   float3 cameraDirectionWs = _cameraPosition - worldPosition.xyz;
   float3 cameraDirectionTs = mul(cameraDirectionWs, tangentMatrix);
   // 计算切线空间光的方向
   float3 lightDirectionWs = _lightPosition - worldPosition.xyz;
   float3 lightDirectionTs = mul(lightDirectionWs, tangentMatrix);
   // 输出结果
   output.position = projectionPosition;
   output.worldPosition = worldPosition.xyz;
   output.color = input.color;
   output.coord = input.coord;
   output.cameraDirectionTs = normalize(cameraDirectionTs);
   output.lightDirectionTs = normalize(lightDirectionTs);
   return output;
}

//============================================================
struct GS_PARTICLE_INPUT
{
   float3 worldPosition     : POSITION;
   float4 color             : COLOR;
   float2 coord             : COORD;
   float3 cameraDirectionTs : CAMERA_DIRECTION_TS;
   float3 lightDirectionTs  : LIGHT_DIRECTION_TS;
};

struct PS_PARTICLE_INPUT
{
   float3 worldPosition     : POSITION;
   float4 color             : COLOR;
   float2 coord             : COORD;
   float3 cameraDirectionTs : CAMERA_DIRECTION_TS;
   float3 lightDirectionTs  : LIGHT_DIRECTION_TS;
};

#define FIXED_VERTEX_RADIUS 5.0

//============================================================
[maxvertexcount(4)]
void ProcessGeometry(point GS_PARTICLE_INPUT input[1], inout TriangleStream<PS_PARTICLE_INPUT> stream){
   const float3 g_positions[4] = {
      float3( -1.0,  1.0, 0.0 ),
      float3(  1.0,  1.0, 0.0 ),
      float3( -1.0, -1.0, 0.0 ),
      float3(  1.0, -1.0, 0.0 ),
   };
   const float2 g_texcoords[4] = {
      float2( 0.0, 1.0 ), 
      float2( 1.0, 1.0 ),
      float2( 0.0, 0.0 ),
      float2( 1.0, 0.0 ),
   };
   PS_PARTICLE_INPUT output = (PS_PARTICLE_INPUT)0;

   // Emit two new triangles
   [unroll]
   for( int i=0; i<4; ++i ){
      float3 position = g_positions[i] * FIXED_VERTEX_RADIUS;
      // position = mul( position, (float3x3)g_mInvView ) + input[0].WSPos;
      // output.Pos = mul( float4( position, 1.0 ), g_mViewProjection );
      // Pass texture coordinates
      // output.Tex = g_texcoords[i];
      // Add vertex
      stream.Append( output );
   }
   stream.RestartStrip();
}

//============================================================
float4 ProcessPixel(VS_OUTPUT input) : SV_Target{
   return float4(1.0, 1.0, 1.0, 1.0);
   // 获得颜色
   /*float4 color = float4(1.0, 1.0, 1.0, 1.0);
   if(_flags.x == 1){
      return color;
   }
   color = _textureDiffuse.Sample(ModelTextureSampler, input.coord);
   if(color.a < 0.5){
      discard;
   }
   // 计算顶点色
   color = color * input.color * 0.8;
   // 计算法线
   float3 lightDirection = input.lightDirectionTs;
   lightDirection.y = -lightDirection.y;
   float3 normalTs = normalize(_textureNormal.Sample(ModelTextureSampler, input.coord) * 2 - 1);
   normalTs.x = - normalTs.x;
   float diffuseRate = saturate(dot(lightDirection, normalTs));
   color += diffuseRate * float4(0.4, 0.5, 0.6, 1.0) * 0.5;
   // 计算高光
   float3 reflectionTs = normalize(dot(input.cameraDirectionTs, normalTs) * normalTs * 2 - input.cameraDirectionTs);
   float powerRL = saturate(dot(reflectionTs, lightDirection));
   float4 specularColor = saturate(pow(powerRL, 10)) * float4(1.0, 0.5, 0.0, 1.0);
   color += specularColor;
   return color;*/
}

//============================================================
technique10 Render
{
   pass P0
   {
      // SetGeometryShader( NULL );
      SetVertexShader( CompileShader( vs_5_0, ProcessVertex() ) );
      // SetGeometryShader( CompileShader( gs_5_0, ProcessGeometry() ) );
      SetPixelShader( CompileShader( ps_5_0, ProcessPixel() ) );
   }
}