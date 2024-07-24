// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BloquesRosa"
{
	Properties
	{
		[Header(Pattern)][SingleLineTexture][Space(8)]_TexturaBase("TexturaBase", 2D) = "white" {}
		_XY("XY", Vector) = (1,1,0,0)
		[HDR]_ColorPatron("ColorPatron", Color) = (1,0,0.6920795,0)
		_PVelocidad("PVelocidad", Range( 0 , 4)) = 0.5
		[Header(Fresnel)][Space(8)]_FFuerza("FFuerza", Range( 0 , 10)) = 5
		_FIntensidad("FIntensidad", Range( 0 , 4)) = 1
		[HDR]_FColor("FColor", Color) = (1.320752,0,2.670157,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit alpha:fade keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
			INTERNAL_DATA
		};

		uniform float4 _ColorPatron;
		uniform sampler2D _TexturaBase;
		uniform float2 _XY;
		uniform float _PVelocidad;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float4 _FColor;
		uniform float _FIntensidad;
		uniform float _FFuerza;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_20_0 = ( _Time.y * _PVelocidad * 0.1 );
			float2 temp_cast_0 = (temp_output_20_0).xx;
			float2 uv_TexCoord23 = i.uv_texcoord * _XY + temp_cast_0;
			float2 temp_cast_1 = (-temp_output_20_0).xx;
			float2 uv_TexCoord24 = i.uv_texcoord * _XY + temp_cast_1;
			float4 ColorBase29 = ( _ColorPatron * ( ( 1.0 - tex2D( _TexturaBase, uv_TexCoord23 ) ) + ( 1.0 - tex2D( _TexturaBase, uv_TexCoord24 ).b ) ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 screenColor46 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_screenPosNorm.xy);
			float4 DistorsionFinal49 = screenColor46;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float fresnelNdotV54 = dot( ase_vertex3Pos, ase_worldlightDir );
			float fresnelNode54 = ( 0.0 + _FIntensidad * pow( 1.0 - fresnelNdotV54, _FFuerza ) );
			float4 ColorFresnel58 = ( _FColor * fresnelNode54 );
			o.Emission = ( ColorBase29 + DistorsionFinal49 + ColorFresnel58 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;552;1562;439;2690.309;664.2779;1.056756;True;False
Node;AmplifyShaderEditor.CommentaryNode;34;-2079.236,-115.2556;Inherit;False;1722.262;462.2007;ColorPatron;16;26;29;28;27;63;64;25;22;23;24;33;16;20;31;17;19;Pattern;1,0,0.7673602,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;19;-1931.041,58.9594;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2029.235,121.8461;Inherit;False;Property;_PVelocidad;PVelocidad;3;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1904.645,191.3468;Inherit;False;Constant;_01_;0.1_;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1744.123,103.2931;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;16;-1746.617,-20.01143;Inherit;False;Property;_XY;XY;1;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;33;-1738.987,215.2269;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1545.589,148.7732;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1556.358,-32.41908;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;59;-2049,-624.4389;Inherit;False;996.8203;438.8207;ColorFresnel;7;56;54;53;57;55;58;83;Fresnel;0.5660391,0,0.6603774,1;0;0
Node;AmplifyShaderEditor.SamplerNode;25;-1354.032,126.7478;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;22;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-1345.909,-60.76881;Inherit;True;Property;_TexturaBase;TexturaBase;0;2;[Header];[SingleLineTexture];Create;True;1;Pattern;0;0;False;1;Space(8);False;-1;cac74a5e70ef5074581401e226647b9c;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-1998.999,-302.918;Inherit;False;Property;_FFuerza;FFuerza;7;1;[Header];Create;True;1;Fresnel;0;0;False;1;Space(8);False;5;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;-1030.292,202.1478;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1997.746,-371.206;Inherit;False;Property;_FIntensidad;FIntensidad;8;0;Create;True;0;0;0;False;0;False;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-2081.898,426.2583;Inherit;False;1768.23;546.3673;Distorsion;13;38;45;48;39;41;40;36;35;44;47;46;49;66;Distortion;0.1226415,0.1226415,0.1226415,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;63;-1041.549,113.2631;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;83;-1950.016,-534.3151;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;54;-1728.372,-405.9679;Inherit;False;Standard;WorldNormal;LightDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-862.3905,101.084;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;56;-1706.297,-574.4388;Inherit;False;Property;_FColor;FColor;9;1;[HDR];Create;True;0;0;0;False;0;False;1.320752,0,2.670157,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;47;-998.6726,476.2583;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-912.7224,-70.46455;Inherit;False;Property;_ColorPatron;ColorPatron;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0.6920795,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;46;-699.683,587.9737;Inherit;False;Global;_GrabScreen0;Grab Screen 0;10;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1468.449,-494.0389;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-691.1219,40.53437;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-570.327,35.60402;Inherit;False;ColorBase;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1228.378,-510.6568;Inherit;False;ColorFresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-537.6688,587.2534;Inherit;True;DistorsionFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-298.5169,136.1348;Inherit;False;58;ColorFresnel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-312.1386,64.59638;Inherit;False;49;DistorsionFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-297.9669,0.3588995;Inherit;False;29;ColorBase;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-1777.83,766.3255;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;66;-1563.523,653.5427;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1376.444,855.8951;Inherit;False;Property;_DHeight;DHeight;6;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-102.0023,45.22898;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1660.331,856.6252;Inherit;False;Property;_DEscala;DEscala;5;0;Create;True;0;0;0;False;0;False;4;4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1823.531,518.7257;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-1787.584,652.7172;Inherit;False;Constant;_05;0.5;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2031.898,767.976;Inherit;False;Property;_DVelocidad;DVelocidad;4;1;[Header];Create;True;1;Distortion;0;0;False;1;Space(8);False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-809.8021,593.537;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;-1354.597,634.217;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;44;-1092.115,637.0619;Inherit;True;Normal From Height;-1;;2;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;59,3;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;BloquesRosa;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;19;0
WireConnection;20;1;17;0
WireConnection;20;2;31;0
WireConnection;33;0;20;0
WireConnection;24;0;16;0
WireConnection;24;1;33;0
WireConnection;23;0;16;0
WireConnection;23;1;20;0
WireConnection;25;1;24;0
WireConnection;22;1;23;0
WireConnection;64;0;25;3
WireConnection;63;0;22;0
WireConnection;54;0;83;0
WireConnection;54;2;55;0
WireConnection;54;3;53;0
WireConnection;26;0;63;0
WireConnection;26;1;64;0
WireConnection;46;0;47;0
WireConnection;57;0;56;0
WireConnection;57;1;54;0
WireConnection;28;0;27;0
WireConnection;28;1;26;0
WireConnection;29;0;28;0
WireConnection;58;0;57;0
WireConnection;49;0;46;0
WireConnection;36;0;35;0
WireConnection;66;0;41;0
WireConnection;66;2;40;0
WireConnection;66;1;36;0
WireConnection;52;0;30;0
WireConnection;52;1;51;0
WireConnection;52;2;60;0
WireConnection;38;0;66;0
WireConnection;38;1;39;0
WireConnection;44;20;38;0
WireConnection;44;110;45;0
WireConnection;0;2;52;0
ASEEND*/
//CHKSM=EEE16B121073A0D297BACDF8E096700EE21C940A