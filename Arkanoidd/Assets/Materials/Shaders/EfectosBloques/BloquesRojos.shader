// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BloquesRojos"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Fuego2("Fuego2", Color) = (1,0.5791131,0,0)
		_Fuego1("Fuego1", Color) = (1,0,0.04940271,0)
		_Brillo("Brillo", Range( 0 , 5)) = 3
		_ColorLadrillo("ColorLadrillo", Color) = (0.2641509,0.09815716,0.06603773,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _ColorLadrillo;
		uniform float _Brillo;
		uniform float4 _Fuego1;
		uniform float4 _Fuego2;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TextureSample0 = v.texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode7 = tex2Dlod( _TextureSample0, float4( uv_TextureSample0, 0, 0.0) );
			float4 appendResult21 = (float4(10.0 , tex2DNode7.g , 0.0 , tex2DNode7.r));
			float3 Normal24 = UnpackNormal( appendResult21 );
			float3 temp_output_29_0 = Normal24;
			v.normal = temp_output_29_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode7 = tex2D( _TextureSample0, uv_TextureSample0 );
			float4 appendResult21 = (float4(10.0 , tex2DNode7.g , 0.0 , tex2DNode7.r));
			float3 Normal24 = UnpackNormal( appendResult21 );
			float3 temp_output_29_0 = Normal24;
			o.Normal = temp_output_29_0;
			float grayscale8 = Luminance(tex2DNode7.rgb);
			float4 Albedo26 = ( grayscale8 * _ColorLadrillo );
			o.Albedo = Albedo26.rgb;
			float mulTime6 = _Time.y * 0.1;
			float cos3 = cos( sin( mulTime6 ) );
			float sin3 = sin( sin( mulTime6 ) );
			float2 rotator3 = mul( i.uv_texcoord - float2( 0,0 ) , float2x2( cos3 , -sin3 , sin3 , cos3 )) + float2( 0,0 );
			float2 panner2 = ( 1.0 * _Time.y * float2( 0.1,0.1 ) + rotator3);
			float simplePerlin3D1 = snoise( float3( panner2 ,  0.0 )*5.0 );
			simplePerlin3D1 = simplePerlin3D1*0.5 + 0.5;
			float4 lerpResult35 = lerp( _Fuego1 , _Fuego2 , simplePerlin3D1);
			float4 Emmision25 = ( ( pow( ( 1.0 - grayscale8 ) , 50.0 ) * _Brillo * simplePerlin3D1 ) * lerpResult35 );
			o.Emission = Emmision25.rgb;
			o.Metallic = temp_output_29_0.x;
			o.Smoothness = temp_output_29_0.x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;438;1562;553;1066.601;12.20836;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;27;-2576,-352;Inherit;False;2075.044;1204.974;Comment;24;24;25;26;10;15;23;12;35;17;21;22;13;33;1;34;11;9;2;8;3;7;5;4;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2320,592;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2256,464;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;5;-2160,592;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-2528,160;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;ecbb6c538c508f949a3e1921172148a7;ecbb6c538c508f949a3e1921172148a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;3;-2032,480;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;8;-2114.902,156.1;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;2;-1840,480;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;9;-1760,208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2400,0;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1632,432;Inherit;False;Property;_Brillo;Brillo;3;0;Create;True;0;0;0;False;0;False;3;3;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-1360,640;Inherit;False;Property;_Fuego2;Fuego2;1;0;Create;True;0;0;0;False;0;False;1,0.5791131,0,0;1,0.5791131,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-1600,507;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;11;-1600,208;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-1312,464;Inherit;False;Property;_Fuego1;Fuego1;2;0;Create;True;0;0;0;False;0;False;1,0,0.04940271,0;1,0,0.04940271,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;21;-2192,-112;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;35;-1100,628;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.5283019;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1248,256;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-1976,-44;Inherit;False;Property;_ColorLadrillo;ColorLadrillo;4;0;Create;True;0;0;0;False;0;False;0.2641509,0.09815716,0.06603773,0;0.1792453,0.1792453,0.1792453,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-976,400;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;23;-1936,-288;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1696,-16;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;2,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1472,-16;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1648,-288;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-735,412;Inherit;False;Emmision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-270.4999,19.70001;Inherit;False;24;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-280,125;Inherit;False;25;Emmision;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-215,-63;Inherit;False;26;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BloquesRojos;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;6;0
WireConnection;3;0;4;0
WireConnection;3;2;5;0
WireConnection;8;0;7;0
WireConnection;2;0;3;0
WireConnection;9;0;8;0
WireConnection;1;0;2;0
WireConnection;11;0;9;0
WireConnection;21;0;22;0
WireConnection;21;1;7;2
WireConnection;21;3;7;1
WireConnection;35;0;33;0
WireConnection;35;1;34;0
WireConnection;35;2;1;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;12;2;1;0
WireConnection;15;0;12;0
WireConnection;15;1;35;0
WireConnection;23;0;21;0
WireConnection;10;0;8;0
WireConnection;10;1;17;0
WireConnection;26;0;10;0
WireConnection;24;0;23;0
WireConnection;25;0;15;0
WireConnection;0;0;28;0
WireConnection;0;1;29;0
WireConnection;0;2;30;0
WireConnection;0;3;29;0
WireConnection;0;4;29;0
WireConnection;0;12;29;0
ASEEND*/
//CHKSM=DF094AB4601134B191F38A4C4ED6A141A8569430