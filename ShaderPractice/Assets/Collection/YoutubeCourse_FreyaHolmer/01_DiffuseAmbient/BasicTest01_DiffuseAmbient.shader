Shader "YoutubeCourse/BasicTest01_DiffuseAmbient"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
		/// Unity �� CG Program Code ������ �˸� 

		CGPROGRAM

		/// pragma �� ���� �ڵ����� �����Ϸ����� ������ �˷��ִ� ����
		/// Vertex shader �Լ��� vert ��� �Լ��� ���� 
		/// Fragment shader �Լ��� frag ��� �Լ��� ���� 
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		/// ���ؽ� ���̴� �Է°�
		/// ������� Mesh �� Render �Ѵ� �ϸ��� Mesh �� Vertex ���� input ���� 
		/// Rendering Pipeline ���� ��� �ܰ迡�� �Ѿ�� 
		struct VertexInput
		{
		/// ��ġ�� ( Semantic : POSITION )
		float4 vertex : POSITION;
		/// uv �� ( Semantic : TEXCOORD0 )
		float2 uv : TEXCOORD0;
		/// normal �� ( Semantic : NORMAL )
		float3 normal : NORMAL;
	};

	/// �����׸�Ʈ ���̴� �Է°� 
	struct FragmentInput
	{
		  float2 uv : TEXCOORD0;
		  float4 vertex : SV_POSITION;
		  float3 normal : TEXCOORD1;
	  };

	/// Vertex shader ���μ��� �Լ�
	/// ��������δ� fragment shader �� ������ vertex ��� 
	FragmentInput vert(VertexInput v)
	{
		FragmentInput o;

		/// Local Space(Model space) ������ Vertex Position �� ���� ��ǥ���� Clip Pos �� ��ȯ (World Transformation included)
		/// �� ���� �ܰ迡���� NDC ��ȯ ������ �ϵ����� ���� 2D ��ǥ�� ���� ��ǥ�� ��ȯ �˾Ƽ����� 
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		o.normal = v.normal;
		return o;
	}

	/// Fragment shader ���μ��� �Լ� 
	/// ��������δ� 2D Screen �� ����� ���� �ȼ��� ��ȯ��

	/// SV_Target �� semantic ���� , Color �� �ǹ��ϴ� �Ŷ�� �Ѵ� . (DX10 ���� COLOR �̾��µ� 11 ���� SV_Target �̶���)
	fixed4 frag(FragmentInput i) : SV_Target
	{
		/// ���� ���� �������� ���� 
		float lightDir = normalize(float3(1,1,0));
		/// Dot �������� ���� �������� ������ ��� �������� 
		/// max() �Լ��� Dot ���� - �� ������ ���̽��� 0 ���� Clamp ó�� 
		float light = max(0, dot(lightDir , i.normal));
		/// ȯ�汤 ����
		float3 ambient = float3(0.45, 0.6, 0.3);

		/// ȯ�汤�� + ������ . �⺻ ȯ�汤�̴ϱ� 
	  return fixed4(light + ambient, 0);
	}

		/// CG ���α׷� ���� �˸� 
		ENDCG
	}
	}
}
