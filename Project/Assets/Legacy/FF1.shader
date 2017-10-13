Shader "Custom/FF1" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Ambient("Ambient",Color) =(1,1,1,1)
		_Specular("Specular",Color) = (1,1,1,1)
		_Shininess("Shininess",Range(0,8))=4
		_Emission("Emission",Color) = (1,1,1,1)
	}	
	SubShader
	{
			pass
			{
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
			}			
	}
	FallBack "Diffuse"
}
