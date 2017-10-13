// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Cg shader with two passes using discard" {
	SubShader{

	// 第一遍渲染计算 过滤正面，渲染背面
	Pass{

		Cull Front // cull only front faces 三角形正面过滤

		CGPROGRAM

	#pragma vertex vert  
	#pragma fragment frag 

	struct vertexInput {
		float4 vertex : POSITION;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 posInObjectCoords : TEXCOORD0;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		output.pos = UnityObjectToClipPos(input.vertex);
		output.posInObjectCoords = input.vertex;

		return output;
	}

	float4 frag(vertexOutput input) : COLOR
	{
		if (input.posInObjectCoords.y > 0.0)
		{
			discard; // drop the fragment if y coordinate > 0
		}
		return float4(1.0, 0.0, 0.0, 1.0); // red
	}

		ENDCG
	}

	// 第二遍渲染计算 背面过滤，只处理正面
	Pass{
		Cull Back // cull only back faces 三角形背面过滤

		CGPROGRAM

	#pragma vertex vert  
	#pragma fragment frag 

	struct vertexInput {
		float4 vertex : POSITION;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 posInObjectCoords : TEXCOORD0;  
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		output.pos = UnityObjectToClipPos(input.vertex);
		output.posInObjectCoords = input.vertex;

		return output;
	}

	float4 frag(vertexOutput input) : COLOR
	{
		if (input.posInObjectCoords.y > 0.0)
		{
			discard; // drop the fragment if y coordinate > 0
		}
		return float4(0.0, 1.0, 0.0, 1.0); // green
	}

		ENDCG
	}
	}
}