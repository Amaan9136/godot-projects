shader_type canvas_item;

uniform float radius = 1.0;
uniform float brightness = 0.7;

void fragment() {
	vec3 total = vec3(0.0);
	for (int x = -2; x <= 2; x++) {
		for (int y = -2; y <= 2; y++) {
			total += texture(TEXTURE, UV + vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE * radius).rgb;
		}
	}
	COLOR = vec4(total / 25.0 * brightness, 1.0);
}
