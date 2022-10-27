
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Normal;                    // (x, y, none)

varying vec2 v_coord;


void main() {
	vec4 pos = gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Position, 1);
	pos.w = 1.;
	
    gl_Position = gm_Matrices[MATRIX_PROJECTION] * pos;
	
    
    v_coord = in_Normal.xy;
}
