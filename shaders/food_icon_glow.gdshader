shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.5, 1.0);
uniform float glow_strength : hint_range(0.0, 10.0) = 2.0;
uniform float threshold : hint_range(0.0, 1.0) = 0.1;
uniform vec2 screen_size;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color;
	
	if (tex_color.a < threshold) {
		float sum = 0.0;
		
		for (int x = -1; x <= 1; x++) {
			for (int y = -1; y <= 1; y++) {
				vec2 offset = vec2(float(x), float(y)) * glow_strength / screen_size;
				vec4 neighbor = texture(TEXTURE, UV + offset);
				sum += neighbor.a;
			}
		}
		
		if (sum > 0.0) {
			COLOR = glow_color;
			COLOR.a = clamp(sum * 0.1, 0.0, 1.0);
		}
	}
}
