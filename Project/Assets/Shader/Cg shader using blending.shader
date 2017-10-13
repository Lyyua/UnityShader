// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//第一遍使用正面剔除，首先渲染背面（内部）。
//第二次通过使用背面剔除（与Cull Back）来渲染前面（外面）。这对于凸网格（没有凹痕的闭合网格，例如球体或立方体）是完美的，并且通常是其他网格的良好近似。

Shader "Cg shader using blending" {
	SubShader{
	Tags{ "Queue" = "Transparent" }
		// draw after all opaque geometry has been drawn
	Pass{

		Cull Front // first pass renders only back faces  //正面过滤 处理看不到的那一面
				   // (the "inside")
		
		ZWrite Off // don't write to depth buffer   取消深度写入 透明物体不应该挡住后面的不透明物体
				   // in order not to occlude other objects
					// 但是会出现不透明物体无法挡住透明物体 所以需要 Tags{ "Queue" = "Transparent" }
					// Tags{ "Queue" = "Transparent" }  的意义是，渲染所有不透明物体之前，渲染使用当前subshader的物体

		Blend SrcAlpha OneMinusSrcAlpha // use alpha blending 使用透明度混合

		CGPROGRAM

		#pragma vertex vert 
		#pragma fragment frag

		float4 vert(float4 vertexPos : POSITION) : SV_POSITION
		{
			return UnityObjectToClipPos(vertexPos);
		}

		float4 frag(void) : COLOR
		{
			return float4(0.0, 1.0, 0.0, 0.3);
			// the fourth component (alpha) is important: 
			// this is semitransparent green
		}

		ENDCG
	}

	Pass{
		Cull Back // second pass renders only front faces  背面过滤，处理正面
				  // (the "outside")

		ZWrite Off // don't write to depth buffer 
				   // in order not to occlude other objects
		
		Blend SrcAlpha OneMinusSrcAlpha // use alpha blending

		CGPROGRAM

		#pragma vertex vert 
		#pragma fragment frag

		float4 vert(float4 vertexPos : POSITION) : SV_POSITION
		{
			return UnityObjectToClipPos(vertexPos);
		}

		float4 frag(void) : COLOR
		{
			return float4(0.0, 1.0, 0.0, 0.3);
			// the fourth component (alpha) is important: 
			// this is semitransparent green
		}

		ENDCG
	}
  }
}