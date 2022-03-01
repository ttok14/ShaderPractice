Shader "YoutubeCourse/BasicTest06_Shoreline"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		_Gloss("Gloss", float) = 1
		_MainTex("MainTex", 2D) = "" {} 
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
	sampler2D _MainTex;

	/// Shader Global Variable ���� .
	///	=> CPU �������� ��������� �ϴ� �� 
	uniform float3 _MousePos;

	FragmentInput vert(VertexInput v)
	{
		FragmentInput o;

		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		o.normal = v.normal;
		o.worldPos = mul(unity_ObjectToWorld, v.vertex);
		return o;
	}

	float3 Posterize(float step, float v)
	{
		return round(v * step) / step;
	}

	float4 frag(FragmentInput i) : SV_Target
	{
		return sin(i.uv.x * 40);

		i.normal = normalize(i.normal);
		float3 lightDir = _WorldSpaceLightPos0;
		float4 lightColor = _LightColor0;
		/// Diffuse 
		float4 diffuse = max(0, dot(i.normal, lightDir)) * _Color;
		/// Ambient
		float4 ambient = float4(0.15, 0.15, 0.3, 0);
		float3 camPos = _WorldSpaceCameraPos;
		float3 dirView = normalize(camPos - i.worldPos);
		float3 reflectDir = reflect(dirView, i.normal);
		float specular = max(0, dot(reflectDir, -lightDir));
		specular = Posterize(7,  pow(specular, _Gloss));

		/// ���� �߿��Ѱ� .
		///		- fragment �� WorldPosition �� Mouse Hit Pos �� �Ÿ��� ���ؼ�
		///			�ش� fragment �� glow �� ��� 
		float dist = distance(_MousePos, i.worldPos);

		/// saturate => clamp ( 0 , 1 , value ) �� . 
		///		�� 0.5 - dist �̱� ������ Mouse Pos �� ����� fragment �ϼ��� ���� Ŀ��
		///				=> �������� ��� �ϱ� ���� ( + �������� )
		float glow = saturate(0.5 - dist);
		// return dist;

		float4 finalColor = specular * lightColor + diffuse + glow; /// glow �� + �ؼ� ���� 

		return float4(finalColor.xyz,0);
	}

		/// CG ���α׷� ���� �˸� 
		ENDCG
		}
	}
}
