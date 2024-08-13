Shader "Custom/fragment01"
{
    Properties
    {
        //ここに書いたものがInspectorに表示される
        _Color("MainColor",Color) = (0,0,0,0)
    }

    SubShader 
    {
        //MaterialのRenderQueueは生成後に自分で変更できちゃうので、これをやっている意味は謎
        Tags 
        { 
            "Queue" = "Transparent"
        }

        Pass
        {
            //不当明度を利用するときに必要 文字通り、1 - フラグメントシェーダーのAlpha値　という意味
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            //変数の宣言　Propertiesで定義した名前と一致させる
            half4 _Color;

            struct v2f 
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata_base v) 
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag(v2f i) : SV_TARGET 
            {
                //RGBAにそれぞれのプロパティを当てはめてみる
                return half4(_Color);
            }
            ENDCG
        }
    }
}
