/*
Reinvention of Alexander Ameye's code, see https://ameye.dev/notes/rendering-outlines/
*/
shader_type spatial;

render_mode unshaded, cull_front;
/*
Constants
*/
const float DELTA = 0.0001f;
/*
Uniforms
*/
uniform int extrusion_direction : hint_enum("Vertex Position", "Normal Vector", "Vertex Color");
uniform vec4 outline_color : source_color = vec4(1.0);
uniform float outline_width : hint_range(0, 1) = 0.2f;
uniform float outline_softness : hint_range(0, 1) = 0.0f;
uniform float outline_power = 1.0f;

void vertex() {
	switch(extrusion_direction) {
		case 0:
			// Move vertex along normalized vertex position in local space
			VERTEX += normalize(VERTEX) * outline_width;
			break;
		case 1:
			// Move vertex along normal vector in local space
			VERTEX += normalize(NORMAL) * outline_width;
			break;
		case 2:
			// Move vertex along (smooth) normal vector in local space
			VERTEX += normalize(CUSTOM0.xyz) * outline_width;
			break;
		default:
			break;
	}
}

void fragment() {
}
