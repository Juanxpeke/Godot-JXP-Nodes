shader_type spatial;

/*
Cull front-faces.
You can skip the light function by setting render_mode to unshaded.
*/
render_mode cull_front, unshaded;

/*
Uniforms
*/
uniform vec4 outline_color : source_color = vec4(1.0);
uniform float outline_width = 2.0;

void vertex() {
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);

	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;

	clip_position.xy += offset;

	POSITION = clip_position;
}

void fragment() {
	ALBEDO = outline_color.rgb;

	if (outline_color.a < 1.0) {
		ALPHA = outline_color.a;
	}
}

/*
void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}
*/
