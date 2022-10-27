


attribute vec3 in_Position;  // (x, y, z)
attribute vec3 in_Normal;    // (block, normal, ssao)


varying vec2 v_texcoord;
varying vec3 v_normal;
varying vec4 v_color;
varying float v_block;


uniform float u_time;

void main() {
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);	
	
    vec3 normals[6];
	
	// north/south
	normals[0] = vec3(-1,0,0);
	normals[1] = vec3(+1,0,0);
	
	// west/east
	normals[2] = vec3(0,+1,0);
	normals[3] = vec3(0,-1,0);
	
	// top/bottom
	normals[4] = vec3(0,0,+1);
	normals[5] = vec3(0,0,-1);
	
	
	vec3 norm = normals[int(in_Normal.y)];
	
	// top/bottom face
	vec2 coords = vec2(in_Position.x*norm[2], in_Position.y);;	
	
	// north/south face
	if (norm.x != 0.0) {
		coords = vec2(in_Position.y*norm[0], in_Position.z);
	}
	
	// west/east face
	if (norm.y != 0.0) {
		coords = vec2(in_Position.x*norm[1], in_Position.z);
	}
	
	
	v_texcoord = coords/16.0;
	v_normal = norm;
	//v_color = vec4(pow(in_Normal.zzz,vec3(1.8,1.8,1.0)),1.0);
	v_color = in_Normal.zzzz;
	v_block = in_Normal.x;
	
}
