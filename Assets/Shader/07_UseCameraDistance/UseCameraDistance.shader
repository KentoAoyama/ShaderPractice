Shader "Custom/UseCameraDistance"
{
    Properties
    {
        [NoScaleOffset] _NearTex ("NearTexture", 2D) = "white" {}
        [NoScaleOffset] _FarTex ("FarTexture", 2D) = "white" {}

        _TestValue ("TestValue", float) = 0.05
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

        //不当明度を利用するときに必要 文字通り、1 - フラグメントシェーダーのAlpha値　という意味
        Blend SrcAlpha OneMinusSrcAlpha
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _NearTex;
            sampler2D _FarTex;
            float _TestValue;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : WORLD_POS;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 nearCol = tex2D(_NearTex, i.uv);
                float4 farCol = tex2D(_FarTex, i.uv);

                float cameraToObjectLength = length(_WorldSpaceCameraPos - i.worldPos);

                fixed4 col = fixed4(lerp(nearCol, farCol, cameraToObjectLength * _TestValue));

                clip(col);

                return col;
            }
            ENDCG
        }
    }
}
