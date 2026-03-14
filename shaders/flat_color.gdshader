shader_type canvas_item;
global uniform vec3 fg_color;

void fragment() {
	COLOR = vec4(fg_color, COLOR.a);
	// Called for every pixel the material is visible on.
}