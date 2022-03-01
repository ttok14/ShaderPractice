// Simplified Additive Particle shader. Differences from regular Additive Particle one:
// - no Tint color
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "FogTest/FogTest_Custom" {
	Properties{
		_MainTex("Particle Texture", 2D) = "white" {}
	}

		SubShader{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			Cull Off Lighting Off ZWrite Off
			Blend SrcAlpha One

			 Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

					struct appdata
					{
						float4 vertex : POSITION;
						float2 uv : TEXCOORD0;
						float4 color : COLOR;
					};

					struct v2f
					{
						float2 uv : TEXCOORD0;
						UNITY_FOG_COORDS(1)
						float4 vertex : SV_POSITION;
						float4 color : COLOR;
					};

					sampler2D _MainTex;
					float4 _MainTex_ST;

					v2f vert(appdata v)
					{
						v2f o;
						o.vertex = UnityObjectToClipPos(v.vertex);
						o.uv = TRANSFORM_TEX(v.uv, _MainTex);
						o.color = v.color;
						UNITY_TRANSFER_FOG(o,o.vertex);
						return o;
					}

					float4 frag(v2f i) : SV_Target
					{
						/* Fog 직접 구현 */
						// [참고 : https://github.com/TwoTailsGames/Unity-Built-in-Shaders/blob/master/CGIncludes/UnityCG.cginc] 
						// 매크로 UNITY_APPLY_FOG 참고하면 내부적으로 다음 식 사용
								// UNITY_FOG_LERP_COLOR(col,fogCol,fogFac) 
									// col.rgb = lerp((fogCol).rgb, (col).rgb, saturate(fogFac))
						//float4 col = tex2D(_MainTex, i.uv);
						//float4 result = lerp(col, unity_FogColor, saturate(1 - i.fogCoord.x));
						//result *= i.color;
						//return result;

						/* Fog Macro 로 구현 */
						float4 col = tex2D(_MainTex, i.uv) * i.color;
						UNITY_APPLY_FOG(i.fogCoord, col);
						return col;
				}
			ENDCG
		}
	}
}

/* Fog Macro 로 구현 */

/*  */