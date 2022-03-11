Shader "Unlit/SeeThroughCircle"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
		{
		Tags
		{
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
		}

		LOD 100

		// �� Circle �� �þ� ������ ��Ÿ���� �뵵�̱� ������ ZWrite Write �� �ʿ䰡 ����. 
		// (Pixel ���� �뵵 �ƴ�) 
		ZWrite OFF
		Blend SrcAlpha OneMinusSrcAlpha
		ZTest OFf

		Stencil
		{
			Ref 1
			Comp always
			Pass replace
		}

		Pass
		{
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
				float4 texColor = tex2D(_MainTex, i.uv);
				//if (texColor.a <= 0)
				//	discard;
				clip(texColor.a - 0.5);
				float4 col = texColor * i.color;
				return col;
			}
			ENDCG
		}
	}
}
