Shader "Jayce/DiffuseLight"
{
	Properties 
	{
		_MainTex("MainTex", 2D) = "white" {}
	}

	SubShader 
	{
		Tags
		{
			"RenderType"="Opaque"

			// 씬에 첫번째 라이트만을 연산에 사용하겠다라는 의미 . 추가적으로 다른 라이트도 쓰려면 
			// ForwardAdd 참고 
			"LightMode"="ForwardBase"
		}

		Pass
		{
		CGPROGRAM

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
		
		// 라이팅 연산 관련 file 
#include "UnityLightingCommon.cginc"

		struct AppData
		{
			float4 pos : POSITION;
			float2 uv : TEXCOORD01;
			float3 normal : NORMAL;
		};
	
		struct v2f
		{
			float4 pos : POSITION;
			float2 uv : TEXCOORD01;
			float3 normal : NORMAL;
		};

		sampler2D _MainTex; 

		v2f vert(AppData i)
		{
			v2f r;
			r.pos = UnityObjectToClipPos(i.pos);
			r.uv = i.uv;
			// 버텍스의 로컬 normal 을 World 좌표계의 normal 로 변환함.
			r.normal = UnityObjectToWorldNormal(i.normal);
			return r;
		}

		fixed4 frag(v2f i) : SV_TARGET
		{
			// normalize 해줘야함 . 
			float3 normal = normalize(i.normal);
			// 최소값이 음수가 되지않도록 max 사용 
			// dot 으로 버텍스가 바라보는 방향인 normal 과 
			// _WorldSpaceLightPos0 로 directional light 인 경우 direction 값을 가져옴 . 
			// 즉 _WorldSpaceLightPos0 에는 라이트 타입따라 값이 다름 . directional light 는 
			// 위치성분의미가없기때문에 _WorldSpaceLightPos0 에 direction 이 들어감 . 
			float intensity = max(0.0, dot(normal, _WorldSpaceLightPos0.xyz));

			// 텍스쳐 * 강도 * 색상 = 최종색상
			return tex2D(_MainTex, i.uv) * intensity * _LightColor0;
		}

		ENDCG
		}
	}
}