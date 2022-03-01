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

		  /// texcoord1 시맨틱을 사용하지만
		/// 실제로는 world Position 을 넘겨주기 위한 변수
		  float3 worldPos :TEXCOORD2;
	  };

	float4 _Color;
	float _Gloss;
	sampler2D _MainTex;

	/// Shader Global Variable 선언 .
	///	=> CPU 레벨에서 설정해줘야 하는 값 
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

		/// 가장 중요한거 .
		///		- fragment 의 WorldPosition 과 Mouse Hit Pos 의 거리를 구해서
		///			해당 fragment 의 glow 를 계산 
		float dist = distance(_MousePos, i.worldPos);

		/// saturate => clamp ( 0 , 1 , value ) 임 . 
		///		즉 0.5 - dist 이기 때문에 Mouse Pos 에 가까운 fragment 일수록 값이 커짐
		///				=> 가까울수록 밝게 하기 위해 ( + 연산으로 )
		float glow = saturate(0.5 - dist);
		// return dist;

		float4 finalColor = specular * lightColor + diffuse + glow; /// glow 를 + 해서 적용 

		return float4(finalColor.xyz,0);
	}

		/// CG 프로그램 끝을 알림 
		ENDCG
		}
	}
}
