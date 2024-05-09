shader_type canvas_item;

uniform vec2 scale_vertex = vec2(0.5, 0.5); // x and y scale

uniform float speed = 1.0;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}

void fragment(){
	COLOR.rgb = vec3(1.0);
}

void vertex() {
	//VERTEX *= scale_vertex;
	//VERTEX += vec2(10.0);
	//VERTEX = rotateUV(VERTEX, TEXTURE_PIXEL_SIZE, TIME * speed);
}


