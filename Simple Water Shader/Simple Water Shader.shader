Shader "z3y/Simple Water Shader"
{
    Properties
    {
        _Color ("Tint", Color) = (0.5,0.5,0.5,1)
        _Glossiness ("Smoothness", Range(0,1)) = 1
        _Metallic ("Metallic", Range(0,1)) = 1
        [Header(Wave 1)]
        _Normal1 ("Normal", 2D) = "bump" {}
        _Normal1Str ("Strength", Range(0.001,1)) = 0.1
        _Normal1Spd ("Speed", Range(-1,1)) = 0.05
        [Header(Wave 2)]
        _Normal2 ("Normal", 2D) = "bump" {}
        _Normal2Str ("Strength", Range(0.001,1)) = 0.1
        _Normal2Spd ("Speed", Range(-1,1)) = -0.05

    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Cull Back

        CGPROGRAM
        #pragma surface surf Standard noshadow exclude_path:deferred alpha
        #pragma target 3.0

        sampler2D _Normal1;
        sampler2D _Normal2;
        
        struct Input
        {
            float2 uv_Normal1;
            float2 uv_Normal2;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        uniform float _Normal1Str;
        uniform float _Normal2Str;
        uniform float _Normal1Spd;
        uniform float _Normal2Spd;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = _Color.rgb;
            o.Metallic = _Metallic;
            o.Alpha = _Color.a;
            o.Smoothness = _Glossiness;
            fixed4 n1 = tex2D(_Normal1, (IN.uv_Normal1 + ((_Time.y*_Normal1Spd)/10)));
            fixed4 n2 = tex2D(_Normal2, (IN.uv_Normal2 + ((_Time.y*_Normal2Spd)/10)));
            o.Normal = BlendNormals(BlendNormals(UnpackNormal (n1) / _Normal1Str, UnpackNormal(n1) / _Normal1Str),BlendNormals(UnpackNormal (n2) / _Normal2Str, UnpackNormal(n2) / _Normal2Str));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
