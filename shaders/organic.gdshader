shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;

uniform vec3 base_color = vec3(0.20, 0.205, 0.215);
uniform float seed_offset = 0.0;
uniform float displacement = 0.8;

varying vec3 world_pos;

float warp(vec3 p) {
    return sin(p.x * 1.7 + seed_offset) * 0.45
        + sin(p.y * 2.1 + p.z * 0.7 + seed_offset * 2.0) * 0.30
        + sin(p.z * 2.9 - p.x * 0.5 + seed_offset * 0.3) * 0.25;
}

void vertex() {
    float w = warp(VERTEX * 0.18);
    VERTEX += NORMAL * w * displacement;
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    float bands = 0.5 + 0.5 * sin(world_pos.y * 0.23 + sin(world_pos.x * 0.11));
    ALBEDO = base_color * (0.75 + bands * 0.25);
    ROUGHNESS = 0.72;
    METALLIC = 0.0;
}
