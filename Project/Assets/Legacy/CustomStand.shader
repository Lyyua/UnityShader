// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CustomStand" {
   Properties {
      _Color ("Color", Color) = (1, 1, 1, 0.5) 
	  _MainTex ("Albedo (RGB)", 2D) = "white" {}
      // user-specified RGBA color including opacity
   }
   SubShader {
      Tags { "Queue" = "Transparent" } 
         // draw after all opaque geometry has been drawn
      Pass { 
         ZWrite Off // don't occlude other objects
         Blend SrcAlpha OneMinusSrcAlpha // standard alpha blending
 
         CGPROGRAM 
 
         #pragma vertex vert  
         #pragma fragment frag 
 
         #include "UnityCG.cginc"
 
         uniform float4 _Color; // define shader property for shaders
		 sampler2D _MainTex;
		 float4 _MainTex_ST;

         struct vertexInput {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float3 normal : TEXCOORD;
            float3 viewDir : TEXCOORD1;
			float2 uv : TEXCOORD2;
         };
 
         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;
 
            float4x4 modelMatrix = unity_ObjectToWorld;
            float4x4 modelMatrixInverse = unity_WorldToObject; 
 
            output.normal = normalize(
               mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
            output.viewDir = normalize(_WorldSpaceCameraPos 
               - mul(modelMatrix, input.vertex).xyz);
 
            output.pos = UnityObjectToClipPos(input.vertex);
			output.uv =input.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR
         {
            float3 normalDirection = normalize(input.normal);
            float3 viewDirection = normalize(input.viewDir);
			float4 tex = tex2D(_MainTex, input.uv.xy);
			float3 col = tex;
			float newOpacity = min(1.0, _Color.a / abs(dot(viewDirection, normalDirection)));
            return float4(col, newOpacity);
         }
 
         ENDCG
      }
   }
   FallBack "Diffuse"
}