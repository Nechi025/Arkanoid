// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Trail"
{
	Properties
	{
		_Fuerza("Fuerza", Range( 0 , 1)) = 0.03618285
		_Color0("Color 0", Color) = (1,0.7921582,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _Fuerza;
		uniform float4 _Color0;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord1 = i.uv_texcoord * float2( 1,0.1 ) + float2( 0,0.2 );
			float mulTime3 = _Time.y * -1.0;
			float2 appendResult6 = (float2(( mulTime3 + i.uv_texcoord.x ) , i.uv_texcoord.y));
			float simplePerlin2D7 = snoise( appendResult6*2.0 );
			float NoiseTrail13 = ( simplePerlin2D7 * pow( i.uv_texcoord.x , 5.0 ) * _Fuerza );
			float TrailEnding37 = ( 1.0 - pow( i.uv_texcoord.x , 0.2 ) );
			float temp_output_42_0 = ( pow( sin( ( ( uv_TexCoord1.y + NoiseTrail13 ) * 6.28318548202515 ) ) , 800.0 ) * TrailEnding37 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor28 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( 1.0 - temp_output_42_0 ) + ase_grabScreenPosNorm ).xy);
			float4 TrailFinal39 = ( ( temp_output_42_0 * _Color0 ) + screenColor28 );
			o.Emission = TrailFinal39.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;724;1478;267;1491.499;627.1272;1.788362;True;False
Node;AmplifyShaderEditor.CommentaryNode;14;-2432,224;Inherit;False;1234;502;TrailBody;9;8;6;5;3;4;11;10;7;13;TrailBody;0.8773585,0.8161327,0.3931559,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;4;-2384,352;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;3;-2368,272;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-2160,272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-2032,272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;7;-1888.207,266.8428;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;10;-1792,496;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1920,608;Inherit;False;Property;_Fuerza;Fuerza;1;0;Create;True;0;0;0;False;0;False;0.03618285;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1552,272;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1424,272;Inherit;True;NoiseTrail;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;43;-1904,-640;Inherit;False;2286.957;830.6738;Trail;17;1;12;16;2;15;17;19;21;27;20;28;25;26;29;40;42;39;Trail;0.9528302,0.767329,0.5348434,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;38;-2576,-112;Inherit;False;626;209;TrailEnding;4;31;33;37;45;TrailEnding;0.3301887,0.3224012,0.3224012,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1888,-368;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.1;False;1;FLOAT2;0,0.2;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;31;-2576,-64;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;12;-1840,-240;Inherit;False;13;NoiseTrail;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-1632,-352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;16;-1600,-240;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;33;-2399,-62;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1472,-336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;-2268,-59;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-2128,-64;Inherit;False;TrailEnding;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;17;-1328,-368;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-1088,-369.8863;Inherit;False;37;TrailEnding;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;19;-1152,-592;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;800;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-951.5826,-592.0942;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;25;-896,-272;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;26;-944,-32;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-688,-224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;21;-727.483,-436.2448;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;1,0.7921582,0,0;1,0.7921582,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;28;-512,-272;Inherit;False;Global;_GrabScreen0;Grab Screen 0;3;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-480,-496;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-176,-400;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;160,-400;Inherit;True;TrailFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-656,288;Inherit;False;39;TrailFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;24;-487.5823,245.2277;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Trail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;4;1
WireConnection;6;0;5;0
WireConnection;6;1;4;2
WireConnection;7;0;6;0
WireConnection;10;0;4;1
WireConnection;8;0;7;0
WireConnection;8;1;10;0
WireConnection;8;2;11;0
WireConnection;13;0;8;0
WireConnection;2;0;1;2
WireConnection;2;1;12;0
WireConnection;33;0;31;1
WireConnection;15;0;2;0
WireConnection;15;1;16;0
WireConnection;45;0;33;0
WireConnection;37;0;45;0
WireConnection;17;0;15;0
WireConnection;19;0;17;0
WireConnection;42;0;19;0
WireConnection;42;1;40;0
WireConnection;25;0;42;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;28;0;27;0
WireConnection;20;0;42;0
WireConnection;20;1;21;0
WireConnection;29;0;20;0
WireConnection;29;1;28;0
WireConnection;39;0;29;0
WireConnection;24;2;41;0
ASEEND*/
//CHKSM=D46A29A1827F34B6FC60DA69FC110C421D966DD4