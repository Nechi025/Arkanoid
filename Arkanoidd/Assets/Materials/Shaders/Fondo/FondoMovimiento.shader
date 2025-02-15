// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FondoMovimiento"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime32 = _Time.y * sin( 1.0 );
			float2 temp_cast_0 = (( length( ( i.uv_texcoord - float2( 0.5,0.5 ) ) ) + ( mulTime32 * 0.06 ) )).xx;
			o.Albedo = ( tex2D( _TextureSample0, temp_cast_0 ) - float4( 0.3018868,0.3018868,0.3018868,0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;755;1562;236;4086.874;644.1178;3.939384;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-1508.34,29.13118;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;38;-1289.068,288.2341;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-1272.628,52.78899;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-1138.347,293.542;Inherit;False;1;0;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1262.571,371.2395;Inherit;False;Constant;_Regulator;Regulator-;1;0;Create;True;0;0;0;False;0;False;0.06;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;33;-1092.422,38.87267;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-968.0043,310.0603;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-838.4366,146.0287;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;44;-1511.409,-1197.065;Inherit;False;1036.249;902.2247;Comment;10;14;21;22;18;41;27;7;26;20;13;Old Panner;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1;-606.8347,133.9664;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;dfdf42d72bc5f334c9825bcbdc6a96ab;dfdf42d72bc5f334c9825bcbdc6a96ab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;26;-1416.96,-546.9243;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-931.6228,-889.7557;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;22;-1259.124,-696.3289;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.13;False;1;FLOAT;10;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1474.996,-1160.443;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1484.155,-826.8807;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;18;-1269.501,-974.6252;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;14;-1435.008,-1026.877;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-730.421,-882.3439;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;21;-1452.124,-678.329;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;0.1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;7;-1074.419,-1143.176;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.13;False;1;FLOAT;10;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-218.447,121.0598;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3018868,0.3018868,0.3018868,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-9,91;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;FondoMovimiento;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;35;0
WireConnection;32;0;38;0
WireConnection;33;0;36;0
WireConnection;39;0;32;0
WireConnection;39;1;40;0
WireConnection;37;0;33;0
WireConnection;37;1;39;0
WireConnection;1;1;37;0
WireConnection;27;0;7;0
WireConnection;27;1;22;0
WireConnection;22;0;20;0
WireConnection;22;2;21;0
WireConnection;22;1;26;4
WireConnection;41;0;27;0
WireConnection;7;0;13;0
WireConnection;7;2;14;0
WireConnection;7;1;18;0
WireConnection;29;0;1;0
WireConnection;0;0;29;0
ASEEND*/
//CHKSM=A89D26C00557B8CAE397DF2D22B66F7DF3149836