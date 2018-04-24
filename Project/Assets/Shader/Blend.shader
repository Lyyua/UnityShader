Shader "Unlit/Blend"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_SecondTex("Second Texture", 2D) = "white" {}
		_CharacterPosition("character position ",vector) = (0,0,0,0)
		_Circleradius("circleradius",float) = 10
		_RingSize("ring size",float) = 5
		_Tint("mask color",Color) = (0,0,0,0)
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" }
			LOD 100

			Pass
			{
				Cull off
				ZWrite off
				ZTest off
				//Blend SrcAlpha One
				//Blend SrcAlpha OneMinusSrcAlpha
				//Blend Zero OneMinusSrcAlpha
				Blend One OneMinusSrcAlpha
				//Blend One One
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
				float4 vertex : SV_POSITION;
				float dist : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _SecondTex;
			float4 _SecondTex_ST;

			vector _CharacterPosition;
			float	_Circleradius;
			float	_RingSize;
			float4	_Tint;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.dist = distance(worldPos,_CharacterPosition);
				//o.vertex.y += sin(worldPos.x + _Time.w);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

			if (i.dist < _Circleradius)
			{
				//col = tex2D(_SecondTex, i.uv);
				col = 0;
				//col = (1, 1, 1, 0.1);
			}
			else if (i.dist > _Circleradius && i.dist < _Circleradius + _RingSize)
			{
				float distoffset = i.dist - _Circleradius;
				//col = lerp(tex2D(_SecondTex, i.uv), tex2D(_MainTex, i.uv),distoffset / _RingSize);  //纹理插值混合
				fixed4 tempCol = tex2D(_MainTex, i.uv);
				//col = lerp(tempCol,(tempCol.x, tempCol.y, tempCol.z,1),distoffset / _RingSize); 
				//col = (tempCol.x, tempCol.y, tempCol.z, distoffset / _RingSize);
				col = tempCol * distoffset / _RingSize; //过渡系数
				//col = (1,1,1, distoffset / _RingSize);
			}
			else
			{
				col = tex2D(_MainTex, i.uv);
				//col = (0,0,0,1);
				//col = _Tint;
			}

			return col;
		}
		ENDCG
	}
		}
}
