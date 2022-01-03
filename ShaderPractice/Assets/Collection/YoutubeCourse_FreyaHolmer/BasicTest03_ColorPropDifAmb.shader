Shader "YoutubeCourse/BasicTest03_ColorPropDifAmb"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
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

	float4 _Color;

	FragmentInput vert(VertexInput v)
	{
		FragmentInput o;

		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		o.normal = v.normal;
		return o;
	}

	fixed4 frag(FragmentInput i) : SV_Target
	{
		/// #include "UnityLightingCommon.cginc" 선언하면 
		/// UnityLightingCommon.cginc 에 접근해서 가져올수 있음
		float3 lightDir = _WorldSpaceLightPos0;
		float4 lightColor = _LightColor0;

		/// Diffuse 
		float4 diffuse = max(0, dot(i.normal, lightDir)) * lightColor;

		/// Ambient
		float4 ambient = float4(0.15, 0.15, 0.3, 0);

		/// Calculate FinalColor
		float4 finalColor = _Color * (diffuse + ambient);

		return finalColor;
	}

		/// CG 프로그램 끝을 알림 
		ENDCG
	}
	}
}
