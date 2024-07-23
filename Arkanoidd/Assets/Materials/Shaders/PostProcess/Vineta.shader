// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vineta"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Ancho("Ancho", Range( 0 , 1)) = 1
		_Altura("Altura", Range( 0 , 1)) = 1
		_Y("Y", Range( 0 , 1)) = 0.5
		_X("X", Range( 0 , 1)) = 0.5
		_Radio("Radio", Range( 0 , 2)) = 1.605796
		_0001("0.001", Float) = 1
		_Degrade("Degrade", Range( 0 , 2)) = 1.394032
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Radio;
			uniform float _Degrade;
			uniform float _0001;
			uniform float _X;
			uniform float _Y;
			uniform float _Ancho;
			uniform float _Altura;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 color23 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float temp_output_18_0 = ( _Radio - _Degrade );
				float4 appendResult10 = (float4(_X , _Y , 0.0 , 0.0));
				float4 appendResult11 = (float4(_Ancho , _Altura , 0.0 , 0.0));
				float smoothstepResult17 = smoothstep( ( temp_output_18_0 + ( _Degrade + _0001 ) ) , temp_output_18_0 , distance( ( ( ( float4( i.uv.xy, 0.0 , 0.0 ) - appendResult10 ) / appendResult11 ) + appendResult10 ) , appendResult10 ));
				float4 lerpResult22 = lerp( tex2D( _MainTex, uv_MainTex ) , color23 , smoothstepResult17);
				

				finalColor = lerpResult22;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;724;1478;267;1204.712;58.29007;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-2032,224;Inherit;False;Property;_Y;Y;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2032,144;Inherit;False;Property;_X;X;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;-1696,144;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1840,-192;Inherit;False;Property;_Ancho;Ancho;0;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;12;-1760,16;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1840,-96;Inherit;False;Property;_Altura;Altura;1;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1504,-176;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-1504,64;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-880,432;Inherit;False;Property;_0001;0.001;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-992,272;Inherit;False;Property;_Radio;Radio;4;0;Create;True;0;0;0;False;0;False;1.605796;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-992,352;Inherit;False;Property;_Degrade;Degrade;6;0;Create;True;0;0;0;False;0;False;1.394032;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1280,16;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-688,272;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1120,80;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-688,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-496,320;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-583.4879,-70.80608;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;16;-960,160;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-400,-176;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;17;-324.3956,175.956;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-529,27;Inherit;False;Constant;_Color0;Color 0;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;-10.30444,-24.76381;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;335.5614,-10.41318;Float;False;True;-1;2;ASEMaterialInspector;0;2;Vineta;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;10;0;6;0
WireConnection;10;1;5;0
WireConnection;11;0;3;0
WireConnection;11;1;4;0
WireConnection;13;0;12;0
WireConnection;13;1;10;0
WireConnection;14;0;13;0
WireConnection;14;1;11;0
WireConnection;18;0;7;0
WireConnection;18;1;9;0
WireConnection;15;0;14;0
WireConnection;15;1;10;0
WireConnection;19;0;9;0
WireConnection;19;1;8;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;16;0;15;0
WireConnection;16;1;10;0
WireConnection;2;0;1;0
WireConnection;17;0;16;0
WireConnection;17;1;20;0
WireConnection;17;2;18;0
WireConnection;22;0;2;0
WireConnection;22;1;23;0
WireConnection;22;2;17;0
WireConnection;0;0;22;0
ASEEND*/
//CHKSM=D3442354321CB6E09DBEFF13777E98669FEECDDB