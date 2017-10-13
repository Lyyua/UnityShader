Shader "Custom/FF2" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Ambient("Ambient",Color) =(1,1,1,1)
		_Specular("Specular",Color) = (1,1,1,1)
		_Shininess("Shininess",Range(0,8))=4
		_Emission("Emission",Color) = (1,1,1,1)
		_MainTex("MainTex",2D) ="white"{}
		_SecondTex("Second",2D) ="white"{}
		_ConstantColor("ConstantColor",Color) = (1,1,1,0.3)
	}	
	SubShader
	{
			pass
			{
				//渲染顺序
				Tags { "Queue" = "Transparent" }
				Blend SrcAlpha OneMinusSrcAlpha
				Material
				{
					DIFFUSE[_Color]			//漫反射
					Ambient[_Ambient]		//环境光	
					SPECULAR[_Specular]		//高光颜色
					Shininess[_Shininess]	//高光聚集度
					Emission[_Emission]  //自发光
				}
				Lighting on	//光照打开
				SeparateSpecular on  //高光反射打开
				//第一张贴图
				SetTexture[_MainTex]
				{
					//primary Material中计算的基础光照属性
					//纹理信息*光照信息
					Combine texture * primary double
				}
				//第二张贴图
				SetTexture[_SecondTex]
				{
					//取设置的灰度系数
					ConstantColor[_ConstantColor]
					//previous 之前得出的光照属性  
					Combine texture * previous double, texture*constant  //取纹理灰度系数
				}
			}			
	}
	FallBack "Diffuse"
}
