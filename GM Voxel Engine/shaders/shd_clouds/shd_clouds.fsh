
varying vec2 v_coord;
uniform float u_time;

void main() {
	vec2 scroll = vec2(0.01, 1.0) * (u_time*0.5);
	vec4 frag = texture2D(gm_BaseTexture, v_coord+scroll);
	

	frag.a *= .8;
	
	frag.rgb = vec3(1.0);
	
	if (frag.a < 0.1) {
		discard;
	}
	
	
    gl_FragColor = frag;
}
