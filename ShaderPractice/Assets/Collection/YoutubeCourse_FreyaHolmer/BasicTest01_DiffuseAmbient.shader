Shader "YoutubeCourse/BasicTest01_DiffuseAmbient"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
		/// Unity 의 CG Program Code 시작을 알림 

		CGPROGRAM

		/// pragma 는 실제 코딩전에 컴파일러에게 뭔가를 알려주는 역할
		/// Vertex shader 함수는 vert 라는 함수로 지정 
		/// Fragment shader 함수는 frag 라는 함수로 지정 
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		/// 버텍스 쉐이더 입력값
		/// 예를들어 Mesh 를 Render 한다 하면은 Mesh 의 Vertex 들이 input 값임 
		/// Rendering Pipeline 에서 어느 단계에서 넘어옴 
		struct VertexInput
		{
		/// 위치값 ( Semantic : POSITION )
		float4 vertex : POSITION;
		/// uv 값 ( Semantic : TEXCOORD0 )
		float2 uv : TEXCOORD0;
		/// normal 값 ( Semantic : NORMAL )
		float3 normal : NORMAL;
	};

	/// 프래그먼트 쉐이더 입력값 
	struct FragmentInput
	{
		  float2 uv : TEXCOORD0;
		  float4 vertex : SV_POSITION;
		  float3 normal : TEXCOORD1;
	  };

	/// Vertex shader 프로세싱 함수
	/// 결과값으로는 fragment shader 에 전달할 vertex 계산 
	FragmentInput vert(VertexInput v)
	{
		FragmentInput o;

		/// Local Space(Model space) 기준인 Vertex Position 을 투영 좌표계인 Clip Pos 로 변환 (World Transformation included)
		/// 이 다음 단계에서는 NDC 변환 등으로 하드웨어에서 최종 2D 좌표를 위한 좌표로 변환 알아서해줌 
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		o.normal = v.normal;
		return o;
	}

	/// Fragment shader 프로세싱 함수 
	/// 결과값으로는 2D Screen 에 출력할 최종 픽셀을 반환함

	/// SV_Target 은 semantic 으로 , Color 를 의미하는 거라고 한다 . (DX10 에선 COLOR 이었는데 11 부터 SV_Target 이라함)
	fixed4 frag(FragmentInput i) : SV_Target
	{
		/// 빛의 방향 고정으로 설정 
		float lightDir = normalize(float3(1,1,0));
		/// Dot 연산으로 빛을 직빵으로 받으면 밝게 나오게함 
		/// max() 함수로 Dot 에서 - 가 나오는 케이스에 0 으로 Clamp 처리 
		float light = max(0, dot(lightDir , i.normal));
		/// 환경광 적용
		float3 ambient = float3(0.45, 0.6, 0.3);

		/// 환경광은 + 연산임 . 기본 환경광이니까 
	  return fixed4(light + ambient, 0);
	}

		/// CG 프로그램 끝을 알림 
		ENDCG
	}
	}
}
