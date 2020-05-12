Shader "Jayce/BasicTexture"
{
	Properties 
	{
		// 텍스쳐 하나 받음 
		_MainTex("MainTex", 2D) = "white" {}
	}

	SubShader 
	{
		Tags
		{
			"RenderType"="Opaque"
		}

		Pass
		{
		// NVDIA 서 개발한 CGPROGRAM 을 사용함 . 
		// 위까진 유니티의 ShaderLab 인거고 , 여기서부터는 directX , openGL 이랑 다 호환되는 코드들이 오는 
		// cg 프로그램 사용 . 
		CGPROGRAM

		// vertex 쉐이더 함수 이름을 vert 로
#pragma vertex vert
		// fragment 쉐이더 함수 이름을 frag 로 
#pragma fragment frag

#include "UnityCG.cginc"

		struct AppData
		{
			// w 가 있는 float4 를 position 에 선언하는 이유는 NDC 변환을 위해서 동차 좌표계에서 쓸 
			// w 도 넘겨줘야하기때문 . 이 정점 쉐이더가 파이프라인에서 넘겨줘야 다음놈도 그걸가지고 작업가능 
			float4 pos : POSITION;
			float2 uv : TEXCOORD01;
		};
	
		struct v2f
		{
			float4 pos : POSITION;
			float2 uv : TEXCOORD01;
		};

		sampler2D _MainTex; // properties 에서 선언해놓은 메인텍스 가져오기 . shader lab 과 별개로 CGPROGRAM 에서 사용하기 위해 선언. 이름 동일하게해야함. 

		v2f vert(AppData i)
		{
			v2f r;
			// 로컬 좌표계로 들어온 input position 값을 절단 좌표계의 좌표값으로 바꿔줌 
			// 즉 투영 행렬이 적용된 값. 이후에 전용 하드웨어에서 NDC 변환을 진행함. 
			// w 값은 거기서 쓰임 . 
			r.pos = UnityObjectToClipPos(i.pos);
			r.uv = i.uv;
			return r;
		}

		fixed4 frag(v2f i) : SV_TARGET // SV : SystemTarget 의 줄임 
		{
			return tex2D(_MainTex, i.uv);
		}

		ENDCG
		}
	}
}