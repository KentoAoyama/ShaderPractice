
// ラスタライズについてわかりやすかった記事
// https://yttm-work.jp/shader/shader_0001.html#:~:text=%E2%96%A0-,%E3%83%A9%E3%82%B9%E3%82%BF%E3%83%A9%E3%82%A4%E3%82%BA,-%E3%83%A9%E3%82%B9%E3%82%BF%E3%83%A9%E3%82%A4%E3%82%BA

Shader "Custom/rasterize00" 
{
    SubShader 
    {
	    Pass
	    {
	        Tags { "RenderType"="Opaque" }
		
	        CGPROGRAM

	        #pragma vertex vert 
	        #pragma fragment frag

            #include "UnityCG.cginc"

	        struct v2f  
	        {
		        float4 pos : SV_POSITION;
				half4 color : COLOR0;
	        };

            v2f vert(appdata_full v) 
	        {
	            v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
                return o;
            }

            half4 frag(v2f i) : COLOR
	        {
		        return i.color;
            }
        
	    ENDCG
		}
    }
}