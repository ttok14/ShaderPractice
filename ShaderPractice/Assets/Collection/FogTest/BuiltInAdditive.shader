// Simplified Additive Particle shader. Differences from regular Additive Particle one:
// - no Tint color
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "FogTest/BuiltIn_Additive" {
	Properties{
		_MainTex("Particle Texture", 2D) = "white" {}
	}

		Category{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			Blend SrcAlpha One
			Cull Off Lighting Off ZWrite Off 
			
			// Fog 활성화 
			Fog { Color(0,0,0,0) }
			// Fog 비활성화
			// Fog { Mode Off }

			BindChannels {
				Bind "Color", color
				Bind "Vertex", vertex
				Bind "TexCoord", texcoord
			}

			SubShader {
				Pass {
					SetTexture[_MainTex] {
						combine texture * primary
					}
				}
			}
	}
}