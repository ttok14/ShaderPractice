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

		  /// texcoord1 시맨틱을 사용하지만
		/// 실제로는 world Position 을 넘겨주기 위한 변수
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

	float MyLerp(float a, float b, float t)
	{
		return a + (b - a) * t; // i.e. (t * b) + (1.0 -t  ) * a;
	}

	/// Value 인 v 를 이용해서 from to 인 a, b 사이에 매개변수 t 값을 구함
	float MyInvLerp(float a, float b, float v)
	{
		return (v - a) / (b - a);
	}

	float Posterize(float step, float t)
	{
		return round(t * step) / step;
	}

	float4 frag(FragmentInput i) : SV_Target
	{
		// return round(i.uv.x * 5) / 5 * round(i.uv.y * 5) / 5;
	//	return Posterize(8, i.uv.x); // Posterize(8, i.uv.x * i.uv.y);
		//return MyInvLerp(0.1 , 0.6, i.uv.y);

		// *** fragment 의 input 값은 파이프라인 중간에 interpolate 된 값이므로 
		// Vertex Shader 에서 normal 을 normalize 하여 보냈다고 하여도 
		// 크기가 1 인 정규화된 vector 가 아닐수가 있기에 normalize 진행한다 *** //
		i.normal = normalize(i.normal);

		/// #include "UnityLightingCommon.cginc" 선언하면 
		/// UnityLightingCommon.cginc 에 접근해서 가져올수 있음
		float3 lightDir = _WorldSpaceLightPos0;
		float4 lightColor = _LightColor0;

		/// Diffuse 
		float4 diffuse = max(0, dot(i.normal, lightDir)) * _Color;

		/// Ambient
		float4 ambient = float4(0.15, 0.15, 0.3, 0);

		float3 camPos = _WorldSpaceCameraPos;
		float3 dirView = normalize(camPos - i.worldPos);

		/// CG Document 참고하면 됨 . 
		/// 반사 벡터 구해주는 함수 
		float3 reflectDir = reflect(dirView, i.normal);

		/// Specular 
		float specular = max(0, dot(reflectDir, -lightDir));

		/// 중요한거 . 제곱 연산 ( Pow ) 적용 
		specular = Posterize(7,  pow(specular, _Gloss));

		float4 finalColor = specular * lightColor + diffuse;

		return float4(finalColor.xyz,0);

		/// (응용) Scene Light 랑 상관없이 그냥 카메라가 바라보는 면만 Specular 라이트 적용
		// float specularLightRegardless = pow( max(0, dot( dirView, i.normal)) , _Gloss );
		// return float4(specularLightRegardless, specularLightRegardless, specularLightRegardless, 0);
	}

		/// CG 프로그램 끝을 알림 
		ENDCG
		}
	}
}
