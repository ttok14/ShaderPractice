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

	/// Fragment shader ���μ��� �Լ� 
	/// ��������δ� 2D Screen �� ����� ���� �ȼ��� ��ȯ��

	/// SV_Target �� semantic ���� , Color �� �ǹ��ϴ� �Ŷ�� �Ѵ� . (DX10 ���� COLOR �̾��µ� 11 ���� SV_Target �̶���)
	fixed4 frag(FragmentInput i) : SV_Target
	{
		/// ���� ������ Direction Light �� �������� ���� 
		/// https ://docs.unity3d.com/Manual/SL-UnityShaderVariables.html ����
		float lightDir = _WorldSpaceLightPos0;
		float light = max(0, dot(lightDir , i.normal));

		/// ������ Light �� Color �� ���� 
	  return fixed4((_LightColor0* light).xyz, 0);
	}

		/// CG ���α׷� ���� �˸� 
		ENDCG
	}
	}
}
