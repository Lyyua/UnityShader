Shader "Custom/vf" {
	SubShader {
		pass
		{
			CGPROGRAM
	 		#pragma vertex vert  //声明顶点函数	名为vert
	 		#pragma fragment frag  //声明片元函数 名为frag
	 		// 语义：	 in 输入 out 输出   float2类型  objPos 变量名  : POSITION 当前位置  : COLOR 当前颜色
			
			//顶点处理器的输入数据是处于模型空间的顶点数据（位置、法向量），输出的是投影坐标和光照颜色；片段处理器要将光照颜色做为输入，问题是片段处理器怎么知道光照颜色值的存放位置。
			//在高级语言中，是因为提供了数据存放的内存位置，CG语言不支持指针机制，且图形硬件处理过程中，数据通常暂存在寄存器中，CG通过语义绑定机制，指定数据存放的位置，将输入输出数据和寄存器做一个映射关系。根据输入语义，图形处理器从某个寄存器取数据，然后再将处理好的数据，根据输出语义，放到指定寄存器。
			//根据图形流水线可以确定，POSITION在输入时代表传入的顶点位置，输出时POSITION代表处理后顶点处理后要反馈给硬件光栅器的裁剪空间位置。虽然两个语义都命名为POSITION,但却对应这图形流水线上不同的寄存器。

	 		void vert(in float2 objPos : POSITION,out float4 pos : POSITION,out float4 col : COLOR)
	 		{
	 			pos = float4(objPos,0,1); //屏幕空间位置objPos
	 			col = pos; 
	 		}
			//片元
	 		void frag(inout float4 col : COLOR)
	 		{
	 			//col = float4(0,1,0,1);
	 		}
	 		ENDCG
		}
	}
}
