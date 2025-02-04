shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
	float brightness = (COLOR.r+COLOR.g+COLOR.b)/8.0;
	COLOR = vec4(brightness+0.446, brightness+0.17, brightness+0.074, COLOR.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
