shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;

uniform vec3 base_color = vec3(0.34, 0.35, 0.36);
uniform float roughness_value : hint_range(0.0, 1.0) = 0.88;
uniform float grain_scale : hint_range(0.02, 2.0) = 0.28;
uniform float contrast : hint_range(0.0, 1.0) = 0.22;

varying vec3 world_pos;

float hash31(vec3 p) {
    p = fract(p * 0.1031);
    p += dot(p, p.yzx + 33.33);
    return fract((p.x + p.y) * p.z);
}

float value_noise(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float n000 = hash31(i + vec3(0.0, 0.0, 0.0));
    float n100 = hash31(i + vec3(1.0, 0.0, 0.0));
    float n010 = hash31(i + vec3(0.0, 1.0, 0.0));
    float n110 = hash31(i + vec3(1.0, 1.0, 0.0));
    float n001 = hash31(i + vec3(0.0, 0.0, 1.0));
    float n101 = hash31(i + vec3(1.0, 0.0, 1.0));
    float n011 = hash31(i + vec3(0.0, 1.0, 1.0));
    float n111 = hash31(i + vec3(1.0, 1.0, 1.0));
    float nx00 = mix(n000, n100, f.x);
    float nx10 = mix(n010, n110, f.x);
    float nx01 = mix(n001, n101, f.x);
    float nx11 = mix(n011, n111, f.x);
    float nxy0 = mix(nx00, nx10, f.y);
    float nxy1 = mix(nx01, nx11, f.y);
    return mix(nxy0, nxy1, f.z);
}

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    float n1 = value_noise(world_pos * grain_scale);
    float n2 = value_noise(world_pos * grain_scale * 4.7 + vec3(9.2, 1.7, 4.1));
    float pores = smoothstep(0.76, 0.94, n2);
    float shade = 0.88 + (n1 - 0.5) * contrast;
    vec3 c = base_color * shade - vec3(pores * 0.055);
    ALBEDO = c;
    ROUGHNESS = clamp(roughness_value + (n2 - 0.5) * 0.10, 0.0, 1.0);
    METALLIC = 0.0;
}
