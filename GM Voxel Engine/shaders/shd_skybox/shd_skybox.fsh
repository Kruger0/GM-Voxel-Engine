
varying vec4 v_colour;
varying float v_hei;


void main() {
	vec4 col = v_colour;
	vec3 col_top = vec3(135./255., 164./255., 255./255.);
	vec3 col_bot = vec3(77./255., 89./255., 201./255.);
	
	float smooth = 16.0;
	
	float hei = smoothstep(-smooth, smooth, v_hei/16.0);
	col.rgb = mix(col_bot, col_top, hei);
    gl_FragColor = col;
}
