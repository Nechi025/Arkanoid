// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ElectricOrb"
{
	Properties
	{
		[Header(Pattern)][SingleLineTexture][Space(8)]_TexturaBase("TexturaBase", 2D) = "white" {}
		_XY("XY", Vector) = (1,1,0,0)
		[HDR]_ColorPatron("ColorPatron", Color) = (1,0.88261,0.3647059,0)
		_PVelocidad("PVelocidad", Range( 0 , 4)) = 0.5
		[Header(Displacement)][Space(8)]_MVelocidad("MVelocidad", Range( 0 , 1)) = 0.5
		_MEscala("MEscala", Range( 1 , 12)) = 2
		_MRango("MRango", Range( 0 , 1)) = 0.5
		[Header(Distortion)][Space(8)]_DVelocidad("DVelocidad", Range( 0 , 1)) = 0.2
		_DEscala("DEscala", Range( 0 , 10)) = 4
		_DFuerza("DFuerza", Range( 0 , 4)) = 4
		_DHeight("DHeight", Range( 0 , 1)) = 1
		[Header(Fresnel)][Space(8)]_FFuerza("FFuerza", Range( 0 , 10)) = 5
		_FIntensidad("FIntensidad", Range( 0 , 4)) = 1
		[HDR]_FColor("FColor", Color) = (2,0.8070782,0.5968586,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _MVelocidad;
		uniform float _MEscala;
		uniform float _MRango;
		uniform float4 _ColorPatron;
		uniform sampler2D _TexturaBase;
		uniform float2 _XY;
		uniform float _PVelocidad;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _DFuerza;
		uniform float _DVelocidad;
		uniform float _DEscala;
		uniform float _DHeight;
		uniform float4 _FColor;
		uniform float _FIntensidad;
		uniform float _FFuerza;


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


		float3 PerturbNormal107_g2( float3 surf_pos, float3 surf_norm, float height, float scale )
		{
			// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
			float3 vSigmaS = ddx( surf_pos );
			float3 vSigmaT = ddy( surf_pos );
			float3 vN = surf_norm;
			float3 vR1 = cross( vSigmaT , vN );
			float3 vR2 = cross( vN , vSigmaS );
			float fDet = dot( vSigmaS , vR1 );
			float dBs = ddx( height );
			float dBt = ddy( height );
			float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
			return normalize ( abs( fDet ) * vN - vSurfGrad );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime3 = _Time.y * _MVelocidad;
			float simplePerlin2D6 = snoise( ( ase_vertex3Pos + mulTime3 ).xy*_MEscala );
			simplePerlin2D6 = simplePerlin2D6*0.5 + 0.5;
			float3 MovimientoOndas14 = ( ase_vertexNormal * simplePerlin2D6 * _MRango * 0.1 );
			v.vertex.xyz += MovimientoOndas14;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float temp_output_20_0 = ( _Time.y * _PVelocidad * 0.1 );
			float2 temp_cast_0 = (temp_output_20_0).xx;
			float2 uv_TexCoord23 = i.uv_texcoord * _XY + temp_cast_0;
			float2 temp_cast_1 = (-temp_output_20_0).xx;
			float2 uv_TexCoord24 = i.uv_texcoord * _XY + temp_cast_1;
			float4 ColorBase29 = ( _ColorPatron * ( tex2D( _TexturaBase, uv_TexCoord23 ).b + tex2D( _TexturaBase, uv_TexCoord24 ).b ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 ase_worldPos = i.worldPos;
			float3 surf_pos107_g2 = ase_worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 surf_norm107_g2 = ase_worldNormal;
			float2 temp_cast_2 = (0.5).xx;
			float2 center45_g1 = temp_cast_2;
			float2 delta6_g1 = ( i.uv_texcoord - center45_g1 );
			float angle10_g1 = ( length( delta6_g1 ) * _DFuerza );
			float x23_g1 = ( ( cos( angle10_g1 ) * delta6_g1.x ) - ( sin( angle10_g1 ) * delta6_g1.y ) );
			float2 break40_g1 = center45_g1;
			float mulTime36 = _Time.y * _DVelocidad;
			float2 temp_cast_3 = (mulTime36).xx;
			float2 break41_g1 = temp_cast_3;
			float y35_g1 = ( ( sin( angle10_g1 ) * delta6_g1.x ) + ( cos( angle10_g1 ) * delta6_g1.y ) );
			float2 appendResult44_g1 = (float2(( x23_g1 + break40_g1.x + break41_g1.x ) , ( break40_g1.y + break41_g1.y + y35_g1 )));
			float simplePerlin2D38 = snoise( appendResult44_g1*_DEscala );
			simplePerlin2D38 = simplePerlin2D38*0.5 + 0.5;
			float height107_g2 = simplePerlin2D38;
			float scale107_g2 = _DHeight;
			float3 localPerturbNormal107_g2 = PerturbNormal107_g2( surf_pos107_g2 , surf_norm107_g2 , height107_g2 , scale107_g2 );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g2 = mul( ase_worldToTangent, localPerturbNormal107_g2);
			float4 screenColor46 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_screenPosNorm + float4( worldToTangentDir42_g2 , 0.0 ) ).xy);
			float4 DistorsionFinal49 = screenColor46;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV54 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode54 = ( 0.0 + _FIntensidad * pow( 1.0 - fresnelNdotV54, _FFuerza ) );
			float4 ColorFresnel58 = ( _FColor * fresnelNode54 );
			o.Emission = ( ColorBase29 + DistorsionFinal49 + ColorFresnel58 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
0;724;1478;267;2336.949;-430.2311;1.206831;True;False
Node;AmplifyShaderEditor.CommentaryNode;34;-2079.236,-115.2556;Inherit;False;1613.101;476.564;ColorPatron;14;19;17;31;20;16;23;24;22;25;33;26;27;28;29;Pattern;0.9171562,0.9433962,0.4850481,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-2081.898,426.2583;Inherit;False;1768.23;546.3673;Distorsion;14;38;45;48;39;37;41;43;40;36;35;44;47;46;49;Distortion;0.5566038,0.5566038,0.5566038,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2029.235,121.8461;Inherit;False;Property;_PVelocidad;PVelocidad;3;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;19;-1931.041,58.9594;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1904.645,191.3468;Inherit;False;Constant;_01_;0.1_;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2031.898,767.976;Inherit;False;Property;_DVelocidad;DVelocidad;7;1;[Header];Create;True;1;Distortion;0;0;False;1;Space(8);False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1880.53,696.0178;Inherit;False;Property;_DFuerza;DFuerza;9;0;Create;True;0;0;0;False;0;False;4;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-1777.83,766.3255;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1755.431,628.3256;Inherit;False;Constant;_05;0.5;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1823.531,518.7257;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1744.123,103.2931;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;16;-1746.617,-20.01143;Inherit;False;Property;_XY;XY;1;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;33;-1738.987,215.2269;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;37;-1571.431,637.1504;Inherit;False;Twirl;-1;;1;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;13;-2091.105,-670.6138;Inherit;False;1296.915;491.7744;Movimiento;11;9;8;11;10;6;7;5;4;3;1;14;Displacement;0.6603774,0.5949627,0.5949627,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1660.331,856.6252;Inherit;False;Property;_DEscala;DEscala;8;0;Create;True;0;0;0;False;0;False;4;4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;-1359.031,635.3257;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-2041.104,-414.7864;Inherit;False;Property;_MVelocidad;MVelocidad;4;1;[Header];Create;True;1;Displacement;0;0;False;1;Space(8);False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1544.358,-32.41908;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1545.589,148.7732;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;59;-761.8225,-624.4389;Inherit;False;996.8203;438.8207;ColorFresnel;6;56;54;53;57;55;58;Fresnel;1,0.5205798,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1376.444,855.8951;Inherit;False;Property;_DHeight;DHeight;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;47;-998.6726,476.2583;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;44;-1092.115,640.1102;Inherit;True;Normal From Height;-1;;2;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;4;-1797.279,-558.338;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-710.5697,-371.206;Inherit;False;Property;_FIntensidad;FIntensidad;12;0;Create;True;0;0;0;False;0;False;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-1345.909,-60.76881;Inherit;True;Property;_TexturaBase;TexturaBase;0;2;[Header];[SingleLineTexture];Create;True;1;Pattern;0;0;False;1;Space(8);False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-711.8226,-302.918;Inherit;False;Property;_FFuerza;FFuerza;11;1;[Header];Create;True;1;Fresnel;0;0;False;1;Space(8);False;5;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;3;-1785.667,-409.5082;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-1345.909,124.7171;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;22;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-1767.724,-319.7896;Inherit;False;Property;_MEscala;MEscala;5;0;Create;True;0;0;0;False;0;False;2;4;1;12;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;-419.1205,-574.4388;Inherit;False;Property;_FColor;FColor;13;1;[HDR];Create;True;0;0;0;False;0;False;2,0.8070782,0.5968586,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-1032.529,-65.25557;Inherit;False;Property;_ColorPatron;ColorPatron;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0.88261,0.3647059,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;54;-441.1954,-405.9679;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1597.782,-492.8958;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-809.8021,593.537;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1034.994,107.3083;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;-1444.732,-467.5633;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;11;-1377.178,-620.6138;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-810.9285,45.74335;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1447.899,-359.9;Inherit;False;Property;_MRango;MRango;6;0;Create;True;0;0;0;False;0;False;0.5;4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-181.273,-494.0389;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1325.458,-276.5131;Inherit;False;Constant;_01;0.1;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;46;-699.683,587.9737;Inherit;False;Global;_GrabScreen0;Grab Screen 0;10;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;11.99811,-496.3569;Inherit;False;ColorFresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-690.1336,40.813;Inherit;False;ColorBase;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1144.964,-441.1743;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-537.6688,587.2534;Inherit;False;DistorsionFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-282.8013,68.78742;Inherit;False;49;DistorsionFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-297.9669,0.3588995;Inherit;False;29;ColorBase;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-298.5169,136.1348;Inherit;False;58;ColorFresnel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1008.055,-446.3467;Inherit;False;MovimientoOndas;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-97.6577,45.22898;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-209.8983,261.6771;Inherit;False;14;MovimientoOndas;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;59,3;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ElectricOrb;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;35;0
WireConnection;20;0;19;0
WireConnection;20;1;17;0
WireConnection;20;2;31;0
WireConnection;33;0;20;0
WireConnection;37;1;41;0
WireConnection;37;2;40;0
WireConnection;37;3;43;0
WireConnection;37;4;36;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;23;0;16;0
WireConnection;23;1;20;0
WireConnection;24;0;16;0
WireConnection;24;1;33;0
WireConnection;44;20;38;0
WireConnection;44;110;45;0
WireConnection;22;1;23;0
WireConnection;3;0;1;0
WireConnection;25;1;24;0
WireConnection;54;2;55;0
WireConnection;54;3;53;0
WireConnection;5;0;4;0
WireConnection;5;1;3;0
WireConnection;48;0;47;0
WireConnection;48;1;44;40
WireConnection;26;0;22;3
WireConnection;26;1;25;3
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;28;0;27;0
WireConnection;28;1;26;0
WireConnection;57;0;56;0
WireConnection;57;1;54;0
WireConnection;46;0;48;0
WireConnection;58;0;57;0
WireConnection;29;0;28;0
WireConnection;9;0;11;0
WireConnection;9;1;6;0
WireConnection;9;2;8;0
WireConnection;9;3;10;0
WireConnection;49;0;46;0
WireConnection;14;0;9;0
WireConnection;52;0;30;0
WireConnection;52;1;51;0
WireConnection;52;2;60;0
WireConnection;0;2;52;0
WireConnection;0;11;15;0
ASEEND*/
//CHKSM=56EEE3E12DD43D66BF72E64EEDF7AB33170C710F