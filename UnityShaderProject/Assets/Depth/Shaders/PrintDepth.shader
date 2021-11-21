﻿Shader "Kaima/Depth/PrintDepth"
{
	SubShader
	{
		ZTest Always Cull Off ZWrite Off

		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				#if UNITY_UV_STARTS_AT_TOP //处于DX,渲染到纹理,开启抗锯齿
				if (_MainTex_TexelSize.y < 0)
					o.uv.y = 1 - v.uv.y;
				#endif

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				float linear01Depth = Linear01Depth(depth);
				return linear01Depth;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
