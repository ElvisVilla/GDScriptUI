shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest_mipmap;
uniform float lod: hint_range(0.0, 5) = 1.0;
uniform float opacity: hint_range(0.0, 1.0) = 1.0;

void fragment(){
    vec4 color = textureLod(screen_texture, SCREEN_UV, lod);
    COLOR = vec4(color.rgb, color.a * opacity);
}