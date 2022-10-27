
#define TEX 16.0
#define NORMAL vec4(0.5, 0.5, 0.5, 0.5)

varying vec2 v_texcoord;
varying vec3 v_normal;
varying vec4 v_color;
varying float v_block;

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
	
    gl_FragColor = frag;
}
