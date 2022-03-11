Shader "Unlit/SeeThroughWall"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_SeeThroughTex("SeeThroughTex",2D) = "white" {}
	}
		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
				"RenderType" = "Transparent"
			}
			LOD 100

			Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha

				Stencil
				{
					Ref 1
					// Ref 값 Masking 함 . 지금은 1 이라 있으나 없으나 같음.
					// 하지만 예로 Ref 가 255 고 ReadMask 가 3 이라면
					// Ref 가 1111 1111 인데 Mask 의 값은 0011 이므로 1111 1111 의 오른쪽 비트 2개
					// 11 만을 Read 해서 Operation 수행
					ReadMask 1
					Comp NotEqual
					Pass Keep
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float4 color : COLOR;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 color : COLOR;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					o.color = v.color;
					return o;
				}

				float4 frag(v2f i) : SV_Target
				{
					float4 col = tex2D(_MainTex, i.uv) * i.color;
					return col;
				}
				ENDCG
			}

			Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha
				//Blend SrcAlpha OneMinusDstColor

				Stencil
				{
					Ref 1
					Comp Equal
					Pass Keep
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float4 color : COLOR;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 color : COLOR;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					o.color = v.color;
					return o;
				}

				float4 frag(v2f i) : SV_Target
				{
					float4 col = tex2D(_MainTex, i.uv) * i.color;
					col.a -= 0.2;
					clip(col.a - 0.1);
					return col;
				}
				ENDCG
			}
	}
}
