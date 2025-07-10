shader_type canvas_item;

uniform bool glow_enabled = true;
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0); // Yellow
uniform float glow_size = 25.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float base_alpha = tex_color.a;

    // Start with default: just the original texture
    vec4 final_color = tex_color;

    if (glow_enabled) {
        float outline_alpha = 0.0;
        int samples = 16;
        for (int i = 0; i < samples; i++) {
            float angle = 6.283185 * float(i) / float(samples);
            vec2 offset = vec2(cos(angle), sin(angle)) * glow_size * TEXTURE_PIXEL_SIZE;
            outline_alpha += texture(TEXTURE, UV + offset).a;
        }
        outline_alpha /= float(samples);

        // If current pixel is transparent but surrounded by visible pixels
        if (base_alpha < 0.05 && outline_alpha > 0.05) {
            final_color = glow_color;
            final_color.a = outline_alpha;
        }
    }

    COLOR = final_color;
}
