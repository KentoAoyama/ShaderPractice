Shader "Custom/DrawStripe00"
{
    Properties
    {
        _StripeColor1 ("StripeColor1", Color) = (1, 0, 0, 0)
        _StripeColor2 ("StripeColor2", Color) = (0, 1, 0, 0)

        _SliceSpace ("SliceSpace", Range(0, 1)) = 0.5
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

            half4 _StripeColor1;
            half4 _StripeColor2;
            half _SliceSpace;
            float _ScrollSpeed;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                // UVをスクロール
                o.uv = v.uv + _Time.x * _ScrollSpeed;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 補完値を計算する。帰ってくるのは０か１のみ
                // step関数はstep(t, x)という形で使用し、xの値がtよりも小さい場合には0、大きい場合には1を返す
                half interpolation = step(frac(i.uv.y * 15), _SliceSpace);
                // 帰ってきた値（０か１）によって色を選ぶ
                half4 color = lerp(_StripeColor1, _StripeColor2, interpolation);
                return color;
            }
            ENDCG
        }
    }
}
