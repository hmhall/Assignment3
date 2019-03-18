// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SimplexNoise"{
    Properties{
        _FadeEffect("Fade Effect", Float)=0
    }
    SubShader{
    
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }
        ZWrite Off
         Blend SrcAlpha OneMinusSrcAlpha
         
         
        
        Pass{
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            uniform float _FadeEffect;
            
            struct v2f{
                float4 position : SV_POSITION;  
            };
            
            v2f vert(float4 v:POSITION) : SV_POSITION {
                v2f o;
                o.position = UnityObjectToClipPos (v);
                return o;
            }
            
            float4 mod289(float4 x) {
                return x - floor(x * (1.0 / 289.0)) * 289.0; 
            }

            float mod289(float x) {
                return x - floor(x * (1.0 / 289.0)) * 289.0; 
            }

            float4 permute(float4 x) {
                return mod289(((x*34.0)+1.0)*x);
            }

            float permute(float x) {
                return mod289(((x*34.0)+1.0)*x);
            }

            float4 taylorInvSqrt(float4 r)
            {
              return 1.79284291400159 - 0.85373472095314 * r;
            }

            float taylorInvSqrt(float r)
            {
              return 1.79284291400159 - 0.85373472095314 * r;
            }

            float4 grad4(float j, float4 ip){
              const float4 ones = float4(1.0, 1.0, 1.0, -1.0);
              float4 p,s;

              p.xyz = floor( ((float3(j,j,j) * ip.xyz)-floor(float3(j,j,j) * ip.xyz)) * 7.0) * ip.z - 1.0;
              p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
              s = float4((p<float4(0.0,0.0,0.0,0.0)));
              p.xyz = p.xyz + (s.xyz*2.0 - 1.0) * s.www; 

              return p;
            }
                        
            // (sqrt(5) - 1)/4 = F4, used once below
            #define F4 0.309016994374947451

            float snoise(float4 v, out float4 gradient){
              const float4  C = float4( 0.138196601125011,  // (5 - sqrt(5))/20  G4
                                    0.276393202250021,  // 2 * G4
                                    0.414589803375032,  // 3 * G4
                                   -0.447213595499958); // -1 + 4 * G4

            // First corner
              float4 i  = floor(v + dot(v, float4(F4,F4,F4,F4)) );
              float4 x0 = v -   i + dot(i, C.xxxx);

            // Other corners

            // Rank sorting originally contributed by Bill Licea-Kane, AMD (formerly ATI)
              float4 i0;
              float3 isX = step( x0.yzw, x0.xxx );
              float3 isYZ = step( x0.zww, x0.yyz );
            //  i0.x = dot( isX, vec3( 1.0 ) );
              i0.x = isX.x + isX.y + isX.z;
              i0.yzw = 1.0 - isX;
            //  i0.y += dot( isYZ.xy, vec2( 1.0 ) );
              i0.y += isYZ.x + isYZ.y;
              i0.zw += 1.0 - isYZ.xy;
              i0.z += isYZ.z;
              i0.w += 1.0 - isYZ.z;

              // i0 now contains the unique values 0,1,2,3 in each channel
              float4 i3 = clamp( i0, 0.0, 1.0 );
              float4 i2 = clamp( i0-1.0, 0.0, 1.0 );
              float4 i1 = clamp( i0-2.0, 0.0, 1.0 );

              //  x0 = x0 - 0.0 + 0.0 * C.xxxx
              //  x1 = x0 - i1  + 1.0 * C.xxxx
              //  x2 = x0 - i2  + 2.0 * C.xxxx
              //  x3 = x0 - i3  + 3.0 * C.xxxx
              //  x4 = x0 - 1.0 + 4.0 * C.xxxx
              float4 x1 = x0 - i1 + C.xxxx;
              float4 x2 = x0 - i2 + C.yyyy;
              float4 x3 = x0 - i3 + C.zzzz;
              float4 x4 = x0 + C.wwww;

            // Permutations
              i = mod289(i); 
              float j0 = permute( permute( permute( permute(i.w) + i.z) + i.y) + i.x);
              float4 j1 = permute( permute( permute( permute (
                         i.w + float4(i1.w, i2.w, i3.w, 1.0 ))
                       + i.z + float4(i1.z, i2.z, i3.z, 1.0 ))
                       + i.y + float4(i1.y, i2.y, i3.y, 1.0 ))
                       + i.x + float4(i1.x, i2.x, i3.x, 1.0 ));

            // Gradients: 7x7x6 points over a cube, mapped onto a 4-cross polytope
            // 7*7*6 = 294, which is close to the ring size 17*17 = 289.
              float4 ip = float4(1.0/294.0, 1.0/49.0, 1.0/7.0, 0.0) ;

              float4 p0 = grad4(j0,   ip);
              float4 p1 = grad4(j1.x, ip);
              float4 p2 = grad4(j1.y, ip);
              float4 p3 = grad4(j1.z, ip);
              float4 p4 = grad4(j1.w, ip);

            // Normalise gradients
              float4 norm = taylorInvSqrt(float4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
              p0 *= norm.x;
              p1 *= norm.y;
              p2 *= norm.z;
              p3 *= norm.w;
              p4 *= taylorInvSqrt(dot(p4,p4));

            // Mix contributions from the five corners
              float3 m0 = max(0.6 - float3(dot(x0,x0), dot(x1,x1), dot(x2,x2)), 0.0);
              float2 m1 = max(0.6 - float2(dot(x3,x3), dot(x4,x4)            ), 0.0);
              float3 m02 = m0 * m0;
              float2 m12 = m1 * m1;
              float3 m04 = m02 * m02;
              float2 m14 = m12 * m12;
              float3 pdotx0 = float3(dot(p0,x0), dot(p1,x1), dot(p2,x2));
              float2 pdotx1 = float2(dot(p3,x3), dot(p4,x4));

              // Determine noise gradient;
              float3 temp0 = m02 * m0 * pdotx0;
              float2 temp1 = m12 * m1 * pdotx1;
              gradient = -8.0 * (temp0.x * x0 + temp0.y * x1 + temp0.z * x2 + temp1.x * x3 + temp1.y * x4);
              gradient += m04.x * p0 + m04 .y * p1 + m04.z * p2 + m14.x * p3 + m14.y * p4;
              gradient *= 49.0;

              return 49.0 * ( dot(m02*m02, float3( dot( p0, x0 ), dot( p1, x1 ), dot( p2, x2 )))
                            + dot(m12*m12, float2( dot( p3, x3 ), dot( p4, x4 ) ) ) ) ;

           }
            
            fixed4 frag(v2f i) : SV_Target {
                float2 uv = (i.position.xy - _ScreenParams.xy * 0.5)/min(_ScreenParams.x, _ScreenParams.y);
                uv *= 10.0;
                
                fixed4 grad;
                
                float col = (snoise(float4(uv, float2(_Time.y*0.5, _Time.y*0.5)), grad) * 0.5) + 0.5;
                
                grad = (grad * float4(0.5,0.5,0.5,0.5)) + float4(0.5,0.5,0.5,0.5);  
                grad.a=_FadeEffect;
                return grad;
            }
            ENDCG
        }
    }
}