Shader "Custom/slice01"
{
    Properties
    {
        _Color ("Color", Color) = (0, 0, 0, 0)

        _SliceSpace ("SliceSpace", Range(0, 30)) = 15
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            half4 _Color;
            half _SliceSpace;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 localPos : WORLD_POS;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                // unity_ObjectToWorld * v.vertex（頂点座標）＝ 頂点のワールド座標らしい
                // mul()で行列の乗算をやってくれている
                o.localPos = v.vertex.xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // apppdata_baseとは、UnityCG.cgincで定義されている以下のような構造体
            // これを使用することで、頂点シェーダーに渡す構造体をわざわざ自分で定義しなくてよくなる
            // こういうのよく使うだろうからこっちで用意しておいてあげるよ。ってことみたい
            //
            //　struct appdata_base 
            //　{
            //  　  float4 vertex : POSITION;
            //    　float3 normal : NORMAL;
            //    　float4 texcoord : TEXCOORD0;
            //    　UNITY_VERTEX_INPUT_INSTANCE_ID
            //　;

            fixed4 frag (v2f i) : SV_Target
            {
                clip(frac(i.localPos.y * _SliceSpace) - 0.5);
                return half4(_Color);
            }
            ENDCG
        }
    }
}
