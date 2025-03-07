shader_type canvas_item;

uniform float scalar;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec4 white = vec4(1.0, 1.0, 1.0, 0.0);
	
	// Called for every pixel the material is visible on.
	COLOR = original_color + (white * scalar);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
