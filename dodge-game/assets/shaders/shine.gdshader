shader_type canvas_item;

void fragment() {
	float band = smoothstep(0.12, 0.0, abs(fract(SCREEN_UV.x * 0.6 + SCREEN_UV.y - TIME * 0.35) - 0.5));
	COLOR.rgb = mix(COLOR.rgb, vec3(1.0, 0.95, 0.6), band * 0.8);
}
