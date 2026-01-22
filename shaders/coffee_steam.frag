#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uTime;
uniform float uIntensity;

out vec4 fragColor;

// Simplex 2D noise
vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187, 0.366025403784439,
                       -0.577350269189626, 0.024390243902439);
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod(i, 289.0);
    vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
                   + i.x + vec3(0.0, i1.x, 1.0));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
                           dot(x12.zw,x12.zw)), 0.0);
    m = m*m;
    m = m*m;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    for(int i = 0; i < 6; i++) {
        value += amplitude * snoise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    
    return value;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    
    // Invert Y so bottom is origin (0,0 at bottom, 1,0 at top)
    float height = 1.0 - uv.y;
    float centerX = uv.x;
    
    // Temperature-based physics parameters
    float speed = 0.3 + (uIntensity * 0.4);           // Faster rise for hotter
    float turbulence = 0.2 + (uIntensity * 0.5);      // More chaos for hotter
    float density = 0.6 + (uIntensity * 0.4);         // Denser for hotter
    float brightness = 0.85 + (uIntensity * 0.15);    // Slightly brighter for hotter
    
    // Time-based upward movement (bottom to top)
    float timeOffset = uTime * speed;
    
    // Distance from bottom (steam origin)
    float distanceFromOrigin = height;
    
    // Cone-like expansion: wider as it rises
    float coneWidth = 0.15 + (distanceFromOrigin * 0.6);
    
    // Distance from center horizontal axis
    float distFromCenter = abs(centerX - 0.5);
    
    // Cone boundary with soft falloff
    float coneMask = smoothstep(coneWidth, coneWidth * 0.6, distFromCenter);
    
    // Steam accelerates near cup, then slows down
    float velocityProfile = mix(1.5, 0.6, smoothstep(0.0, 0.7, distanceFromOrigin));
    
    // Create rising steam with multiple noise layers
    vec2 steamCoord1 = vec2(
        centerX * 2.5 + fbm(vec2(height * 0.5, timeOffset * 0.3)) * 0.3,
        height * 3.0 + timeOffset * velocityProfile
    );
    
    vec2 steamCoord2 = vec2(
        centerX * 3.5 + fbm(vec2(height * 0.8, timeOffset * 0.5)) * 0.4,
        height * 4.0 + timeOffset * velocityProfile * 1.2
    );
    
    vec2 steamCoord3 = vec2(
        centerX * 4.0 + fbm(vec2(height * 1.2, timeOffset * 0.7)) * 0.5,
        height * 5.0 + timeOffset * velocityProfile * 0.9
    );
    
    // Multi-scale turbulence
    float noise1 = fbm(steamCoord1) * 0.5;
    float noise2 = fbm(steamCoord2) * 0.3;
    float noise3 = fbm(steamCoord3) * 0.2;
    
    float combinedNoise = (noise1 + noise2 + noise3) * turbulence;
    
    // Horizontal drift increases with height
    float drift = sin(height * 4.0 + timeOffset * 2.0) * (0.05 + distanceFromOrigin * 0.15);
    float driftNoise = fbm(vec2(centerX + drift, height * 2.0 + timeOffset)) * 0.4;
    
    // Combine all noise
    float steamDensity = combinedNoise + driftNoise;
    steamDensity = smoothstep(-0.3, 0.7, steamDensity);
    
    // Apply cone mask
    steamDensity *= coneMask;
    
    // Fade out at top (smooth, no clipping)
    float topFade = smoothstep(1.0, 0.6, distanceFromOrigin);
    steamDensity *= topFade;
    
    // Stronger at bottom (emission point)
    float bottomEmission = smoothstep(0.15, 0.0, distanceFromOrigin) * 0.5;
    steamDensity += bottomEmission * density;
    
    // Apply density control
    steamDensity *= density;
    
    // Diffusion: steam becomes more transparent as it rises
    float diffusion = mix(1.0, 0.3, smoothstep(0.0, 0.8, distanceFromOrigin));
    
    // Calculate final alpha
    float alpha = steamDensity * diffusion * 0.6;
    alpha = clamp(alpha, 0.0, 1.0);
    alpha = smoothstep(0.0, 0.5, alpha);
    
    // Hard cutoff for very low alpha
    if (alpha < 0.015) {
        alpha = 0.0;
    }
    
    // Steam color with temperature-based brightness
    vec3 steamColor = vec3(0.92, 0.94, 0.98) * brightness;
    
    // Premultiplied alpha
    fragColor = vec4(steamColor * alpha, alpha);
}
