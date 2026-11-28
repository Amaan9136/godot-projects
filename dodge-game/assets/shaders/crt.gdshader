shader_type canvas_item;

void fragment() {
	float scanline = step(0.5, fract(FRAGCOORD.y / 4.0));
	float vignette = smoothstep(0.4, 0.75, length(UV - vec2(0.5)));
	COLOR = vec4(0.0, 0.0, 0.0, scanline * 0.08 + vignette * 0.4);
}
