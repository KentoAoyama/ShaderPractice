Shader "Custom/slice00"
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
                // ３D->２D（スクリーン）に座標変換された頂点座標を格納する
                float4 pos : SV_POSITION;
                // こちらにはワールド座標を格納する
                float3 worldPos : WORLD_POS;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                // unity_ObjectToWorld * v.vertex（頂点座標）＝ 頂点のワールド座標らしい
                // mul()で行列の乗算をやってくれている
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 各頂点のワールド座標（Y軸）にそれぞれ15をかけてfrac()で小数だけ取り出す
                // そこから-0.5して、clip()に渡すことで０以下の頂点を描画しないようになっているらしい
                clip(frac(i.worldPos.y * _SliceSpace) - 0.5);
                // RGBAにプロパティを当てはめる
                return half4(_Color);
            }
            ENDCG
        }
    }
}
