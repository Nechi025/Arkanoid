// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BloquesVerdes"
{
	Properties
	{
		_05("0.5", Float) = 0.5
		_2("2", Float) = 2
		_DFuerza("DFuerza", Range( 0 , 4)) = 0.6334673
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 uv_tex3coord;
		};

		uniform float _DFuerza;
		uniform float _05;
		uniform float _2;


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
			float3 ase_vertexNormal = v.normal.xyz;
			float3 Direccion10 = saturate( ( ( 1.0 - ase_vertexNormal ) * float3(0,1,1) ) );
			float2 temp_cast_1 = (0.5).xx;
			float2 center45_g1 = temp_cast_1;
			float2 delta6_g1 = ( v.texcoord.xyz.xy - center45_g1 );
			float angle10_g1 = ( length( delta6_g1 ) * _DFuerza );
			float x23_g1 = ( ( cos( angle10_g1 ) * delta6_g1.x ) - ( sin( angle10_g1 ) * delta6_g1.y ) );
			float2 break40_g1 = center45_g1;
			float mulTime27 = _Time.y * 0.1;
			float2 temp_cast_2 = (mulTime27).xx;
			float2 break41_g1 = temp_cast_2;
			float y35_g1 = ( ( sin( angle10_g1 ) * delta6_g1.x ) + ( cos( angle10_g1 ) * delta6_g1.y ) );
			float2 appendResult44_g1 = (float2(( x23_g1 + break40_g1.x + break41_g1.x ) , ( break40_g1.y + break41_g1.y + y35_g1 )));
			float simplePerlin3D18 = snoise( float3( appendResult44_g1 ,  0.0 )*5.0 );
			simplePerlin3D18 = simplePerlin3D18*0.5 + 0.5;
			float3 temp_cast_4 = (_05).xxx;
			float3 CantidadNormal24 = ( ase_vertexNormal * ( Direccion10 * ( simplePerlin3D18 * ( 1.0 - length( ( ( v.texcoord.xyz - temp_cast_4 ) * _2 ) ) ) ) ) );
			float3 temp_output_25_0 = CantidadNormal24;
			v.vertex.xyz += temp_output_25_0;
			v.vertex.w = 1;
			v.normal = temp_output_25_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3 Direccion10 = saturate( ( ( 1.0 - ase_vertexNormal ) * float3(0,1,1) ) );
			float2 temp_cast_1 = (0.5).xx;
			float2 center45_g1 = temp_cast_1;
			float2 delta6_g1 = ( i.uv_tex3coord.xy - center45_g1 );
			float angle10_g1 = ( length( delta6_g1 ) * _DFuerza );
			float x23_g1 = ( ( cos( angle10_g1 ) * delta6_g1.x ) - ( sin( angle10_g1 ) * delta6_g1.y ) );
			float2 break40_g1 = center45_g1;
			float mulTime27 = _Time.y * 0.1;
			float2 temp_cast_2 = (mulTime27).xx;
			float2 break41_g1 = temp_cast_2;
			float y35_g1 = ( ( sin( angle10_g1 ) * delta6_g1.x ) + ( cos( angle10_g1 ) * delta6_g1.y ) );
			float2 appendResult44_g1 = (float2(( x23_g1 + break40_g1.x + break41_g1.x ) , ( break40_g1.y + break41_g1.y + y35_g1 )));
			float simplePerlin3D18 = snoise( float3( appendResult44_g1 ,  0.0 )*5.0 );
			simplePerlin3D18 = simplePerlin3D18*0.5 + 0.5;
			float3 temp_cast_4 = (_05).xxx;
			float3 CantidadNormal24 = ( ase_vertexNormal * ( Direccion10 * ( simplePerlin3D18 * ( 1.0 - length( ( ( i.uv_tex3coord - temp_cast_4 ) * _2 ) ) ) ) ) );
			float3 temp_output_25_0 = CantidadNormal24;
			o.Normal = temp_output_25_0;
			float4 color28 = IsGammaSpace() ? float4(0,0.3490566,0.1373868,0) : float4(0,0.09992068,0.01683507,0);
			float4 color29 = IsGammaSpace() ? float4(0.04870415,1,0,0) : float4(0.003820365,1,0,0);
			float4 lerpResult30 = lerp( color28 , color29 , simplePerlin3D18);
			o.Albedo = lerpResult30.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xyz = customInputData.uv_tex3coord;
				o.customPack1.xyz = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_tex3coord = IN.customPack1.xyz;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;518;1562;473;2010.425;156.6283;1.530645;False;False
Node;AmplifyShaderEditor.CommentaryNode;2;-2298.4,50.6;Inherit;False;1312.236;710.6876;Normal;18;21;23;24;19;22;20;17;18;33;16;27;15;35;34;14;13;12;11;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;-2271.45,-420.8899;Inherit;False;994;383;Comment;6;4;5;6;9;10;31;Direccion;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;12;-2246.496,427.5996;Inherit;False;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;31;-2247.108,-378.9951;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-2218.395,639.4996;Inherit;False;Property;_05;0.5;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-2026.606,-275.4819;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2058.395,655.4996;Inherit;False;Property;_2;2;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-2042.395,511.4996;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;5;-2031.45,-196.8899;Inherit;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;0;False;0;False;0,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1855.45,-228.8899;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1898.394,511.4996;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2269.615,209.3005;Inherit;False;Property;_DFuerza;DFuerza;2;0;Create;True;0;0;0;False;0;False;0.6334673;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-2170.568,320.8826;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2058.516,91.60828;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;16;-1770.394,511.4996;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;9;-1598.104,-305.8288;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;33;-1959.38,303.6243;Inherit;False;Twirl;-1;;1;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1674.394,287.4998;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1471.45,-308.8899;Inherit;False;Direccion;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1610.394,511.4996;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1419.591,424.2101;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1394.113,343.6688;Inherit;False;10;Direccion;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1199.292,400.0589;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;21;-1516.796,113.3059;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1323.277,140.8108;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1173.69,119.042;Inherit;False;CantidadNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;28;-875.1765,291.4298;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0,0.3490566,0.1373868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-880,464;Inherit;False;Constant;_Color1;Color 1;2;0;Create;True;0;0;0;False;0;False;0.04870415,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;25;-309.5827,270.7823;Inherit;False;24;CantidadNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;30;-597.7632,346.0067;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BloquesVerdes;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;31;0
WireConnection;14;0;12;0
WireConnection;14;1;11;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;16;0;15;0
WireConnection;9;0;6;0
WireConnection;33;1;12;0
WireConnection;33;2;35;0
WireConnection;33;3;34;0
WireConnection;33;4;27;0
WireConnection;18;0;33;0
WireConnection;10;0;9;0
WireConnection;17;0;16;0
WireConnection;20;0;18;0
WireConnection;20;1;17;0
WireConnection;22;0;19;0
WireConnection;22;1;20;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;24;0;23;0
WireConnection;30;0;28;0
WireConnection;30;1;29;0
WireConnection;30;2;18;0
WireConnection;0;0;30;0
WireConnection;0;1;25;0
WireConnection;0;11;25;0
WireConnection;0;12;25;0
ASEEND*/
//CHKSM=860D9672C2E8023FF14E3C2B2CBC71D9A1164C10