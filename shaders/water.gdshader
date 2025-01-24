shader_type canvas_item;

uniform float time : hint_range(0.0, 100.0) = 0.0; // For animation
uniform float speed : hint_range(0.0, 5.0) = 1.0; // Ripple speed
uniform float frequency : hint_range(0.0, 10.0) = 5.0; // Wave frequency
uniform float amplitude : hint_range(0.0, 1.0) = 0.05; // Wave height
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV; // Use the screen texture's UV coordinates

    // Create a ripple distortion
    float wave = sin(uv.y * frequency + time * speed) * amplitude;
    uv.x += wave;

    // Sample the screen texture with distorted UV
    COLOR = texture(SCREEN_TEXTURE, uv);
}
