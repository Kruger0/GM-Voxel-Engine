
attribute vec3 in_Position;

uniform vec3 u_cursor_pos;

void main() {
	vec3 pos_offset = vec3(8.0, 8.0, -8.0);
	
	mat4 proj_mat	= gm_Matrices[MATRIX_PROJECTION];
	mat4 view_mat	= gm_Matrices[MATRIX_VIEW];
	mat4 world_mat	= gm_Matrices[MATRIX_WORLD];
	
	// position
	world_mat[3][0] = 0.0; //x
	world_mat[3][1] = 0.0; //y
	world_mat[3][2] = 0.0; //z
	world_mat[3][3] = 1.0;

	// scaling
	world_mat[0][0] = 1.0; //x
	world_mat[1][1] = 1.0; //y
	world_mat[2][2] = 1.0; //z
	world_mat[3][3] = 1.0;
	
	mat4 world_view_mat			= view_mat * world_mat;	
	mat4 world_view_proj_mat	= proj_mat * world_view_mat;
	
	vec4 world_space_pos		= vec4((in_Position + u_cursor_pos + pos_offset), 1.0);
	
    gl_Position = world_view_proj_mat * world_space_pos;
}
