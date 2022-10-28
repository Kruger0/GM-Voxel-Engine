
#define TEX 16.0
#define NORMAL vec4(0.5, 0.5, 0.5, 0.5)

varying vec2 v_texcoord;
varying vec3 v_normal;
varying vec4 v_color;
varying float v_block;

varying vec3 v_world_pos;
varying vec3 v_cam_pos;

vec4 apply_fog(vec4 c, float s, float e, vec3 wp) {
	//vec4 fogc = vec4(vec3(135./255., 164./255., 255./255.), 1.0);
	vec4 fogc = vec4(vec3(77./255., 89./255., 201./255.), 1.0);
	float d = length(wp);
	float f = clamp((d - s) / (e - s), 0.0, 1.0);
	vec4 fc = mix(c,fogc,f);	
	return fc;
}

void main() {
	
	// flip the texture so the Y axis become negative
	vec2 uv = (fract(vec2(v_texcoord.x, v_texcoord.y*-1.0)) + mod(floor(v_block/vec2(1, TEX)), TEX))/TEX;
	
	// half pixel correction
	//uv.x -= 0.001 / 256.0;//= (uv.x + 0.5) / 2.0;
	//uv.y -= 0.001 / 256.0;//= (uv.y + 0.5) / 2.0;
	
	vec4 frag = texture2D(gm_BaseTexture, uv);
	
	// no transparency
	if (frag.a < 0.1) {
		discard;
	}
	
	// ssao
	frag.rgb *= v_color.rgb;
	
	// normals - fix that
	
	vec3 normal_col = ((v_normal*NORMAL.xyz)+1.0/2.0);
	
	frag.rgb *= dot(normal_col, NORMAL.zzz);
	//frag.rgb *= normal_col;
	
	
	frag = apply_fog(frag, 500.0, 800.0, v_world_pos);
	
    gl_FragColor = frag;
}
