Shader "Custom/uv00"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _RotateSpeed ("RotateSpeed", float) = 1.0
        _CenterValue ("CenterValue", float) = 0.5
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
                float2 uv : TEXCOORD0; //１番目のUV座標という意味らしい
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _RotateSpeed;
            float _CenterValue;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half _timer = _Time.x;

                half angleCos = cos(_timer * _RotateSpeed);
                half angleSin = sin(_timer * _RotateSpeed);

                /*       |cosΘ -sinΘ|
                  R(Θ) = |sinΘ  cosΘ|  2次元回転行列の公式*/
                half2x2 rotateMatrix = half2x2(angleCos, -angleSin, angleSin, angleCos);

                //中心を指定
                half2 uv = i.uv - _CenterValue;
                //中心を起点にUVを回転させる
                i.uv = mul(uv, rotateMatrix) + _CenterValue;

                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
