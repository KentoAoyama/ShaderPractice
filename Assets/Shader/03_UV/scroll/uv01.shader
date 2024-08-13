Shader "Custom/uv01"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (0, 0, 0, 0)
        _SliceSpace ("SliceSpace", Range(0, 30)) = 15 
        _ScrollSpeed ("ScrollSpeed", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            half4 _Color;
            half _SliceSpace;
            float _ScrollSpeed;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 localPos : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                // 描画する頂点にローカル座標を指定
                // メッシュの違いによってスクロールの仕方に差異が出るが、理由は謎
                o.localPos = v.vertex.xyz;
                o.uv = v.uv + _Time * _ScrollSpeed;
                // 3D空間における座標は2D(スクリーン)においてこの位置になるという変換を関数を使って行っている
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // 頂点の色を計算・指定
                fixed4 col = tex2D(_MainTex, i.uv);
                // 各頂点のY軸のローカル座標にそれぞれ15を乗算して、frac()で小数のみ取り出す
                // そこから-0.5して、clip()で0を下回ったら描画しないように
                clip(frac(i.localPos.y * _SliceSpace) - 0.5);
                // 計算した色とプロパティで設定した色を乗算する
                return half4(col * _Color);
            }
            ENDCG
        }
    }
}
