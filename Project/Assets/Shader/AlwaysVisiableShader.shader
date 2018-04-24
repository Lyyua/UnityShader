Shader "Unlit/AlwaysVisiableShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_SecondTex("second Texture", 2D) = "white" {}
		_RimColor("【边缘颜色】Rim Color", Color) = (0.17,0.36,0.81,0.0)
		_RimPower("【边缘颜色强度】Rim Power", Range(0.6,9.0)) = 1.0
		_LerpFactor("blend texture factor",Range(0,1)) = 0.5
	}
		SubShader
		{
			Tags{ "Queue" = "Transparent" }
			LOD 100

			Pass
		{
			Cull front
			ZWrite off
			ZTest off
			Blend One OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
			float3 normal : NORMAL;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			float4 vertex : SV_POSITION;
			float2 rim:TEXCOORD0;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;

		sampler2D _SecondTex;
		float4 _SecondTex_ST;

		float _LerpFactor;
		float4 _RimColor;
		float _RimPower;

		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			//法线方向
			float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
			//观察方向
			float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - mul(unity_ObjectToWorld, v.vertex).xyz));
			//边缘程度
			o.rim.x = 1.0 - saturate(dot(viewDirection, normalDirection));
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = lerp(tex2D(_MainTex, i.uv),tex2D(_SecondTex,i.uv),_LerpFactor);
			col.rgb =  col.rgb + _RimColor.rgb * pow(i.rim.x, _RimPower);
			return col;
		}
		ENDCG
	}


	Pass
	{
		CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
		// make fog work
	#pragma multi_compile_fog

	#include "UnityCG.cginc"

			struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;

		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			UNITY_TRANSFER_FOG(o,o.vertex);
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.uv);
			return col;
		}
			ENDCG
		}
		}
}
