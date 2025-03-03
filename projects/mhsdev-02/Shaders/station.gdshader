shader_type canvas_item;

uniform bool active = true;

void fragment() {
	// Called for every pixel the material is visible on.
	if (active && COLOR.a < 0.1) {
		COLOR = vec4(1, 1, 1, COLOR.a + 0.2);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
