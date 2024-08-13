Shader "Custom/mask00"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset] _MaskTex ("Mask Texture (RGB)", 2D) = "white" {}

        _RotateSpeed ("RotateSpeed", float) = 10.0

        _TestValue ("TestValue", float) = 0.5
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _MaskTex;
            float _RotateSpeed;
            float _TestValue;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv1 = v.uv1;
                o.uv2 = v.uv2;
                return o;
            }

            // 単純なマスクは可能だが、グラデーションの表現などはこれだとできないっぽい
            fixed4 frag (v2f i) : SV_Target
            {
                half timer = _Time.x;

                half angleCos = cos(timer * _RotateSpeed);
                half angleSin = sin(timer * _RotateSpeed);

                /*       |cosΘ -sinΘ|
                  R(Θ) = |sinΘ  cosΘ|  2次元回転行列の公式*/
                half2x2 rotateMatrix = half2x2(angleCos, -angleSin, angleSin, angleCos);

                //中心を指定
                half2 uv1 = i.uv1 - 0.5;
                //中心を起点にUVを回転させる
                i.uv1 = mul(uv1, rotateMatrix) + 0.5;

                // マスク用画像のピクセル色を計算
                fixed4 mask = tex2D(_MaskTex, i.uv2);
                // 引数の値が０以下なら描画しない　すなわちAlphaが0.5以下なら描画しない
                clip(mask.a - _TestValue);
                // メイン画像のピクセルの色を計算
                fixed4 col = tex2D(_MainTex, i.uv1);
                // メイン画像のマスク画像のピクセルの計算結果を掛け合わせる
                return col * mask;
            }
            ENDCG
        }
    }
}
