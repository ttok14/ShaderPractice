Shader "YoutubeCourse/BasicTest02_UnityLight"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"
		#include "UnityLightingCommon.cginc"

		struct VertexInput
		{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : NORMAL;
	};

	struct FragmentInput
	{
		  float2 uv : TEXCOORD0;
		  float4 vertex : SV_POSITION;
		  float3 normal : TEXCOORD1;
	  };

	FragmentInput vert(VertexInput v)
	{
		FragmentInput o;

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
		/// 빛의 방향은 Direction Light 의 방향으로 설정 
		/// https ://docs.unity3d.com/Manual/SL-UnityShaderVariables.html 참고
		float lightDir = _WorldSpaceLightPos0;
		float light = max(0, dot(lightDir , i.normal));

		/// 색상은 Light 의 Color 로 설정 
	  return fixed4((_LightColor0* light).xyz, 0);
	}

		/// CG 프로그램 끝을 알림 
		ENDCG
	}
	}
}
