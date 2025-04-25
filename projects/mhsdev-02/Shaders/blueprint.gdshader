shader_type canvas_item;

uniform float alpha = 0.17;
uniform float red = 0;
uniform float green = 0;
uniform float blue = 0;
uniform float brightness_multi = 3.0;

void fragment() {
	// Called for every pixel the material is visible on.
	float brightness = (COLOR.r+COLOR.g+COLOR.b)/(3.0*brightness_multi);
	COLOR = vec4(brightness+red/brightness,brightness+green/brightness,brightness+blue/brightness,COLOR.a*alpha);

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
