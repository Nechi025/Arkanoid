// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BloquesVerV2"
{
	Properties
	{
		[HideInInspector] _VTInfoBlock( "VT( auto )", Vector ) = ( 0, 0, 0, 0 )
		_FlowMap("FlowMap", 2D) = "white" {}
		_ReguladorNormal("ReguladorNormal", Float) = 0.2
		_Texture("Texture", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_MEscala("MEscala", Range( 1 , 12)) = 2
		_MRango("MRango", Range( 0 , 1)) = 0.5
		_Regulador("Regulador", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "Amplify" = "True"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Regulador;
		uniform float _MEscala;
		uniform float _MRango;
		uniform sampler2D _Texture0;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _ReguladorNormal;
		uniform sampler2D _Texture;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime89 = _Time.y * sin( 1.0 );
			float simplePerlin2D94 = snoise( ( ase_vertex3Pos + ( mulTime89 * _Regulador ) ).xy*_MEscala );
			simplePerlin2D94 = simplePerlin2D94*0.5 + 0.5;
			float3 MovimientoOndas97 = ( ase_vertexNormal * simplePerlin2D94 * _MRango * 0.1 );
			v.vertex.xyz += MovimientoOndas97;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float mulTime49 = _Time.y * sin( 1.0 );
			float temp_output_1_0_g2 = ( mulTime49 * _ReguladorNormal );
			float2 temp_output_46_0 = ( i.uv_texcoord + ( (tex2D( _FlowMap, uv_FlowMap )).rg * ( ( temp_output_1_0_g2 - floor( ( temp_output_1_0_g2 + 0.5 ) ) ) * 2 ) ) );
			float2 temp_output_2_0_g5 = temp_output_46_0;
			float2 break6_g5 = temp_output_2_0_g5;
			float temp_output_25_0_g5 = ( pow( 5.0 , 3.0 ) * 0.1 );
			float2 appendResult8_g5 = (float2(( break6_g5.x + temp_output_25_0_g5 ) , break6_g5.y));
			float4 tex2DNode14_g5 = tex2D( _Texture0, temp_output_2_0_g5 );
			float temp_output_4_0_g5 = 3.0;
			float3 appendResult13_g5 = (float3(1.0 , 0.0 , ( ( tex2D( _Texture0, appendResult8_g5 ).g - tex2DNode14_g5.g ) * temp_output_4_0_g5 )));
			float2 appendResult9_g5 = (float2(break6_g5.x , ( break6_g5.y + temp_output_25_0_g5 )));
			float3 appendResult16_g5 = (float3(0.0 , 1.0 , ( ( tex2D( _Texture0, appendResult9_g5 ).g - tex2DNode14_g5.g ) * temp_output_4_0_g5 )));
			float3 normalizeResult22_g5 = normalize( cross( appendResult13_g5 , appendResult16_g5 ) );
			float3 Normal105 = normalizeResult22_g5;
			o.Normal = Normal105;
			float4 Textura104 = tex2D( _Texture, temp_output_46_0 );
			o.Albedo = Textura104.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;593;1562;398;2312.747;174.455;1.777696;True;False
Node;AmplifyShaderEditor.CommentaryNode;102;-1931.976,-233.1031;Inherit;False;1723.9;878.109;Comment;15;52;57;45;46;60;43;47;42;48;41;51;49;50;104;105;Texture Y Normal;0.1084906,1,0.3282264,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;103;-1679,695.4109;Inherit;False;1248.571;545.6566;Comment;13;99;89;101;88;100;91;92;94;96;90;95;93;97;Movimiento;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;50;-1891.609,416.7198;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;99;-1629,923.8979;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;49;-1718.288,421.7194;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1696.623,528.3787;Inherit;False;Property;_ReguladorNormal;ReguladorNormal;3;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1511.635,436.7183;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-1758.29,138.964;Inherit;True;Property;_FlowMap;FlowMap;0;0;Create;True;0;0;0;False;0;False;-1;73755df769e30e749badc69111ab3e86;73755df769e30e749badc69111ab3e86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;89;-1512.355,955.2652;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-1621.493,1035.264;Inherit;False;Property;_Regulador;Regulador;8;0;Create;True;0;0;0;False;0;False;0;0.3;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;42;-1448.783,150.2024;Inherit;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-1346.206,981.4579;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;88;-1462.653,807.6867;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;48;-1401.27,342.4639;Inherit;True;Sawtooth Wave;-1;;2;289adb816c3ac6d489f255fc3caf5016;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-1183.831,-122.153;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1214.907,158.375;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1446.863,1125.068;Inherit;False;Property;_MEscala;MEscala;6;0;Create;True;0;0;0;False;0;False;2;6.454518;1;12;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-1228.12,881.888;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1113.273,1006.125;Inherit;False;Property;_MRango;MRango;7;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;94;-1110.106,898.4615;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-990.8325,1089.512;Inherit;False;Constant;_01;0.1;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;92;-1042.552,745.4109;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-953.8887,-3.849241;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VirtualTextureObject;60;-949.8163,187.9515;Inherit;True;Property;_Texture0;Texture 0;5;0;Create;True;0;0;0;False;0;False;-1;None;d237034e1fac29d48883aa82c22e00f1;False;white;Auto;Unity5;0;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-810.3385,924.8504;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;45;-757.2711,-45.50554;Inherit;True;Property;_Texture;Texture;4;0;Create;True;0;0;0;False;0;False;-1;d237034e1fac29d48883aa82c22e00f1;d237034e1fac29d48883aa82c22e00f1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;57;-641.0812,196.252;Inherit;True;NormalCreate;1;;5;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;5;False;4;FLOAT;3;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-673.4295,919.678;Inherit;True;MovimientoOndas;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-407.3843,-21.30647;Inherit;False;Textura;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-385.8912,210.6918;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-3.916021,-14.63748;Inherit;False;104;Textura;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-115.8047,333.7366;Inherit;False;97;MovimientoOndas;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-13.55571,74.53026;Inherit;False;105;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;186.2621,-21.7128;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BloquesVerV2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;0;50;0
WireConnection;51;0;49;0
WireConnection;51;1;52;0
WireConnection;89;0;99;0
WireConnection;42;0;41;0
WireConnection;100;0;89;0
WireConnection;100;1;101;0
WireConnection;48;1;51;0
WireConnection;43;0;42;0
WireConnection;43;1;48;0
WireConnection;91;0;88;0
WireConnection;91;1;100;0
WireConnection;94;0;91;0
WireConnection;94;1;90;0
WireConnection;46;0;47;0
WireConnection;46;1;43;0
WireConnection;96;0;92;0
WireConnection;96;1;94;0
WireConnection;96;2;93;0
WireConnection;96;3;95;0
WireConnection;45;1;46;0
WireConnection;57;1;60;0
WireConnection;57;2;46;0
WireConnection;97;0;96;0
WireConnection;104;0;45;0
WireConnection;105;0;57;0
WireConnection;0;0;107;0
WireConnection;0;1;108;0
WireConnection;0;11;98;0
ASEEND*/
//CHKSM=8F1430C1D39B4B5296FCCFA297ABE5853E86DB1E