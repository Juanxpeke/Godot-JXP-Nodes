#pragma disable_preprocessor
/**
 * Reinvention of Alexander Ameye's code. See https://ameye.dev/notes/rendering-outlines/
 * 
 * This shader renders an extruded version of the original mesh behind it. The way the mesh is
 * extruded depends on the extrusion direction and the space in which this transform is applied.
 */
shader_type spatial;

render_mode unshaded, cull_front;
// Constants
const float DELTA = 0.0001;
// Uniforms
/**
 * Color of the outline. Alpha channel is not used.
 */
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
/**
 * Width of the outline. Measured in pixels when extruding in clip space, measured in distance units when extruding in local space.
 */
uniform float outline_width : hint_range(0, 64) = 4.0;
/**
 * Defines the direction in which the extrusion will occur.
 * [b]Vertex Position:[/b] Uses the vertex's local position as the extrusion direction.
 * [b]Normal:[/b] Uses the vertex's local normal as the extrusion direction. 
 * [b]Custom-Authored Normal:[/b] Uses the built-in [code]CUSTOM0[/code] value as the extrusion direction. This mode requires that smoothed normals have been precomputed and stored in [code]CUSTOM0[/code] beforehand. You can use the static class [b]JXP_NormalSmoother[/b], included in this plugin, to generate and store them.
 */
uniform int extrusion_direction : hint_enum("Vertex Position", "Normal", "Custom-Authored Normal") = 2;
/**
 * Defines how the extrusion step is performed.
 * [b]Local Space:[/b] Extrusion affects the vertex's local position.
 * [b]Clip Space:[/b] The vertex's local position remains unchanged; instead, the clip-space position is extruded.
 * [b]Better Clip Space:[/b] An improved version of the clip-space method. Works better in all cases, especially on objects like cubes.
 */
uniform int extrusion_space : hint_enum("Local Space", "Clip Space", "Better Clip Space") = 2;
/**
 * If [code]true[/code], the width of the outline will be maintained regardless of the camera distance. Only works with clip space extrusion.
 */
uniform bool depth_scale = true;

void extrude_in_local_space(
		in vec3 direction,
		in vec3 local_position,
		in mat4 modelview,
		in mat4 projection,
		inout vec4 clip_position_reference) {
	vec3 offset = direction * outline_width;
	vec4 clip_position = projection * (modelview * vec4(local_position + offset, 1.0));
	clip_position_reference = clip_position;
}

void extrude_in_clip_space(
		in vec3 direction,
		in vec3 local_position,
		in mat4 modelview,
		in mat4 projection,
		in vec2 viewport_size,
		inout vec4 clip_position_reference) {
	vec4 clip_position = projection * (modelview * vec4(local_position, 1.0));
	vec3 clip_normal = mat3(projection) * (mat3(modelview) * direction);
	
	vec2 offset = normalize(clip_normal.xy) / viewport_size * outline_width * 2.0; 
	clip_position.xy += offset * (depth_scale ? clip_position.w : 1.0);
	
	clip_position_reference = clip_position;
}

void extrude_in_better_clip_space(
		in vec3 direction,
		in vec3 local_position,
		in mat4 modelview,
		in mat4 projection,
		in vec2 viewport_size,
		inout vec4 clip_position_reference) {
	vec4 clip_position = projection * (modelview * vec4(local_position, 1.0));
	vec3 clip_normal = mat3(projection) * (mat3(modelview) * direction);
	
	float aspect_ratio = viewport_size.x / viewport_size.y;
	clip_normal.x = clip_normal.x * aspect_ratio;
	clip_normal = normalize(clip_normal);
	clip_normal.x = clip_normal.x / aspect_ratio;
	
	clip_position.xy += clip_normal.xy * outline_width * aspect_ratio * 2.0 / length(viewport_size) * (depth_scale ? clip_position.w : 1.0);
	
	clip_position_reference = clip_position;
}

void vertex() {
	vec3 direction;
	
	switch(extrusion_direction) {
		case 0:
			// Move along normalized vertex position in local space
			direction = normalize(VERTEX);
			break;
		case 1:
			// Move along normal vector in local space
			direction = normalize(NORMAL);
			break;
		case 2:
			// Move along (smooth) normal vector in local space
			direction = normalize(CUSTOM0.xyz);
			break;
	}
	
	switch(extrusion_space) {
		case 0:
			extrude_in_local_space(direction, VERTEX, MODELVIEW_MATRIX, PROJECTION_MATRIX, POSITION);
			break;
		case 1:
			extrude_in_clip_space(direction, VERTEX, MODELVIEW_MATRIX, PROJECTION_MATRIX, VIEWPORT_SIZE, POSITION);
			break;
		case 2:
			extrude_in_better_clip_space(direction, VERTEX, MODELVIEW_MATRIX, PROJECTION_MATRIX, VIEWPORT_SIZE, POSITION);
			break;
	}
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
