
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)

varying vec4 v_colour;
varying float v_hei;

void main() {
	vec4 pos = gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Position, 0);
	pos.w = 1.;
	
    gl_Position = gm_Matrices[MATRIX_PROJECTION] * pos;
    
	//v_color = vec4(exp((in_Position.z-.5)*vec3(2,1,.6)),1);
    v_colour = in_Colour;
	v_hei = in_Position.z;
}
