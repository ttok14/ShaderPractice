﻿Shader "Jayce/Specular"
{
	Properties 
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Brightness("Brightness", float) = 1
		_Ambient("Ambient", float) = 0
		_Wideness("Wideness", float) = 1
	}

	SubShader 
	{
		Tags
		{
			"RenderType"="Opaque"
			"LightMode"="ForwardBase"
		}

		Pass
		{
		CGPROGRAM

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
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
		float _Brightness;
		float _Wideness;
		float _Ambient;

		v2f vert(AppData i)
		{
			v2f r;
			r.pos = UnityObjectToClipPos(i.pos);
			r.uv = i.uv;
			r.normal = UnityObjectToWorldNormal(i.normal);
			return r;
		}

		fixed4 frag(v2f i) : SV_TARGET
		{
			float3 normal = normalize(i.normal);
			float3 reflectionDir = reflect(-_WorldSpaceLightPos0.xyz, normal);

			float diffuseTerm = max(0.0, dot(normal, _WorldSpaceLightPos0.xyz));
			float specularTerm = max(_Ambient, pow(dot(normal, reflectionDir), _Wideness) * _Brightness);

			return tex2D(_MainTex, i.uv) * (_LightColor0 * (specularTerm  + diffuseTerm));
		}

		ENDCG
		}
	}
}