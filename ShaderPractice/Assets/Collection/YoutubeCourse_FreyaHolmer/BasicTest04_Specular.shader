Shader "YoutubeCourse/BasicTest04_Specular"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		_Gloss("Gloss", float) = 1
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

		  /// texcoord1 �ø�ƽ�� ���������
		/// �����δ� world Position �� �Ѱ��ֱ� ���� ����
		  float3 worldPos :TEXCOORD2;
	  };

	float4 _Color;
	float _Gloss;

	FragmentInput vert(VertexInput v)
	{
		FragmentInput o;

		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		o.normal = v.normal;
		o.worldPos = mul(unity_ObjectToWorld, v.vertex);
		return o;
	}

	float4 frag(FragmentInput i) : SV_Target
	{
		// *** fragment �� input ���� ���������� �߰��� interpolate �� ���̹Ƿ� 
		// Vertex Shader ���� normal �� normalize �Ͽ� ���´ٰ� �Ͽ��� 
		// ũ�Ⱑ 1 �� ����ȭ�� vector �� �ƴҼ��� �ֱ⿡ normalize �����Ѵ� *** //
		i.normal = normalize(i.normal);

		/// #include "UnityLightingCommon.cginc" �����ϸ� 
		/// UnityLightingCommon.cginc �� �����ؼ� �����ü� ����
		float3 lightDir = _WorldSpaceLightPos0;
		float4 lightColor = _LightColor0;

		/// Diffuse 
		float4 diffuse = max(0, dot(i.normal, lightDir)) * _Color;

		/// Ambient
		float4 ambient = float4(0.15, 0.15, 0.3, 0);

		float3 camPos = _WorldSpaceCameraPos;
		float3 dirView = normalize(camPos - i.worldPos);

		/// CG Document �����ϸ� �� . 
		/// �ݻ� ���� �����ִ� �Լ� 
		float3 reflectDir = reflect(dirView, i.normal);

		/// Specular 
		float specular = max(0, dot(reflectDir, -lightDir));

		/// �߿��Ѱ� . ���� ���� ( Pow ) ���� 
		specular = pow(specular, _Gloss);

		float4 finalColor = specular * lightColor + diffuse;

		return float4(finalColor.xyz,0);

		/// (����) Scene Light �� ������� �׳� ī�޶� �ٶ󺸴� �鸸 Specular ����Ʈ ����
		// float specularLightRegardless = pow( max(0, dot( dirView, i.normal)) , _Gloss );
		// return float4(specularLightRegardless, specularLightRegardless, specularLightRegardless, 0);
	}

		/// CG ���α׷� ���� �˸� 
		ENDCG
	}
	}
}
