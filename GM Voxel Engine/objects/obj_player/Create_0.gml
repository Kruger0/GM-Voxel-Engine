


z = WORLD_SEA_HEI*GRID+64
look_dir = 180;
look_pitch = 0;
spd = 2
cam_lock = false


mx = 0
my = 0
mx_prev = 0
my_prev = 0
selected_block = BLOCK_ID.SNOW

camera_movement = function() {

	var _xsense = 8
	var _ysense = 8
	var _win_w = window_get_width()
	var _win_h = window_get_height()

	if (mouse_check_button_pressed(mb_middle)) {
		cam_lock = !cam_lock
		window_set_cursor(cam_lock ? cr_none : cr_arrow)
	}

	if (cam_lock) {
	
		mx = window_mouse_get_x()
		my = window_mouse_get_y()
	
		var _win_midx = _win_w/2
		var _win_midy = _win_h/2
	
		if (point_distance(_win_midx, _win_midy, mx, my) > min(_win_w, _win_h)/3) {
			window_mouse_set(_win_midx, _win_midy)
			
			mx = _win_midx
			my = _win_midy
			mx_prev = _win_midx
			my_prev = _win_midy
			//return
		}
	
		look_dir	+= (mx - mx_prev)/_xsense
		look_pitch	+= (my - my_prev)/_ysense

		look_dir	= (look_dir mod 360)
		if (look_dir < 0) look_dir = 360
		look_pitch = clamp(look_pitch, -89, 89)
	
		mx_prev = mx 
		my_prev = my	
	
	} else {
	
	}

}

player_movement = function() {
	if (keyboard_check(ord("W"))) {
		x += dcos(look_dir)*spd;
		y -= dsin(look_dir)*spd;
	}

	if (keyboard_check(ord("S"))) {
		x -= dcos(look_dir)*spd;
		y += dsin(look_dir)*spd;
	}

	if (keyboard_check(ord("A"))) {
		x += dsin(look_dir)*spd;
		y += dcos(look_dir)*spd;
	}

	if (keyboard_check(ord("D"))) {
		x -= dsin(look_dir)*spd;
		y -= dcos(look_dir)*spd;
	}

	if (keyboard_check(vk_space)) {
		z += spd;
	}

	if (keyboard_check(vk_shift)) {
		z -= spd;
	}

	if (keyboard_check(vk_control)) {
		spd = 6;
	} else spd = 1.1;
}

block_selection = function() {
	var _len = array_length(global.block_data)
	
	var _scroll = mouse_wheel_down() - mouse_wheel_up()
	
	selected_block += _scroll
	selected_block = clamp(selected_block, 1, _len-1)
}
//====================================================================
#region Wireframe box

vbuff_wirebox = vertex_create_buffer()
vertex_begin(vbuff_wirebox, V_FORMAT_WIREBOX)
var _off = (GRID/2) + 0.05;

#region old
/*
// top
vertex_position_3d(vbuff_wirebox, -_off, -_off, _off)
vertex_position_3d(vbuff_wirebox, GRID+_off, -_off, _off)

vertex_position_3d(vbuff_wirebox, -_off, -_off, _off)
vertex_position_3d(vbuff_wirebox, -_off, GRID+_off, _off)

vertex_position_3d(vbuff_wirebox, -_off, GRID+_off, _off)
vertex_position_3d(vbuff_wirebox, GRID+_off, GRID+_off, _off)

vertex_position_3d(vbuff_wirebox, GRID+_off, -_off, _off)
vertex_position_3d(vbuff_wirebox, GRID+_off, GRID+_off, _off)

// bot
vertex_position_3d(vbuff_wirebox, -_off, -_off, -GRID-_off)
vertex_position_3d(vbuff_wirebox, GRID+_off, -_off, -GRID-_off)

vertex_position_3d(vbuff_wirebox, -_off, -_off, -GRID-_off)
vertex_position_3d(vbuff_wirebox, -_off, GRID+_off, -GRID-_off)

vertex_position_3d(vbuff_wirebox, -_off, GRID+_off, -GRID-_off)
vertex_position_3d(vbuff_wirebox, GRID+_off, GRID+_off, -GRID-_off)

vertex_position_3d(vbuff_wirebox, GRID+_off, -_off, -GRID-_off)
vertex_position_3d(vbuff_wirebox, GRID+_off, GRID+_off, -GRID-_off)

//sides
vertex_position_3d(vbuff_wirebox, -_off, -_off, _off)
vertex_position_3d(vbuff_wirebox, -_off, -_off, -GRID-_off)

vertex_position_3d(vbuff_wirebox, -_off, GRID+_off, _off)
vertex_position_3d(vbuff_wirebox, -_off, GRID+_off, -GRID-_off)

vertex_position_3d(vbuff_wirebox, GRID+_off, -_off, _off)
vertex_position_3d(vbuff_wirebox, GRID+_off, -_off, -GRID-_off)

vertex_position_3d(vbuff_wirebox, GRID+_off, GRID+_off, _off)
vertex_position_3d(vbuff_wirebox, GRID+_off, GRID+_off, -GRID-_off)
*/
#endregion

// bot
vertex_position_3d(vbuff_wirebox, -_off, -_off, -_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, -_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, -_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, -_off)
vertex_position_3d(vbuff_wirebox, +_off, +_off, -_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, -_off)

// top
vertex_position_3d(vbuff_wirebox, -_off, -_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, +_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, +_off)

// west
vertex_position_3d(vbuff_wirebox, -_off, -_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, +_off)
vertex_position_3d(vbuff_wirebox, -_off, -_off, -_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, -_off)
vertex_position_3d(vbuff_wirebox, -_off, -_off, -_off)

// east
vertex_position_3d(vbuff_wirebox, -_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, -_off)
vertex_position_3d(vbuff_wirebox, +_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, +_off, -_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, -_off)

// south
vertex_position_3d(vbuff_wirebox, +_off, -_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, -_off)
vertex_position_3d(vbuff_wirebox, +_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, +_off, +_off, -_off)
vertex_position_3d(vbuff_wirebox, +_off, -_off, -_off)

// east
vertex_position_3d(vbuff_wirebox, -_off, -_off, +_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, -_off, -_off, -_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, +_off)
vertex_position_3d(vbuff_wirebox, -_off, +_off, -_off)
vertex_position_3d(vbuff_wirebox, -_off, -_off, -_off)

vertex_end(vbuff_wirebox)
vertex_freeze(vbuff_wirebox)

#endregion
//====================================================================


raycast = {
	x : other.x,
	y : other.y,
	z : other.z,
	
	hit : BLOCK_ID.AIR,
	
	// Place here
	cx : 0,
	cy : 0,
	cz : 0,
	
	// Break here
	sx : 0,
	sy : 0,
	sz : 0,

	vbuff_wirebox : other.vbuff_wirebox,
	u_pos : shader_get_uniform(shd_cursor_render, "u_cursor_pos"),	
	
	step : function() {		
		
		// Update struct data
		x = other.x
		y = other.y
		z = other.z
		
		dx = other.look_dir
		dy = other.look_pitch
		
		selected_block = other.selected_block

		// Input
		var _lb = mouse_check_button_pressed(mb_left)
		var _rb = mouse_check_button_pressed(mb_right)			
		
		var _x = (x)
		var _y = (y)
		var _z = (z + GRID) //??? nao sei mas funciona

		// View directions
		var _dx,_dy,_dz;
		_dx = +dcos(dx)*dcos(dy);
		_dy = -dsin(dx)*dcos(dy);
		_dz = -dsin(dy);
		
		// Raycasting - method inspired by XorDev		
		hit = false;
		var _ray_len = GRID * 1
		var _step_size = 4
		
		for (var i = 0; i < _ray_len; i++) {
			
			// Step size			
			_x += _dx * _step_size;
			_y += _dy * _step_size;
			_z += _dz * _step_size;
			
			
			// Break block here
			sx = ((_x))  //GRID
			sy = ((_y))  //GRID
			sz = ((_z))  //GRID			
			
			hit = world_get_block(sx, sy, sz)
			if (hit) break;

			// Place block here
			cx = sx;
			cy = sy;
			cz = sz;
		}
	
		// Break block
		if (_lb) {
			world_set_block(sx, sy, sz, BLOCK_ID.AIR);
			audio_play_sound(snd_break_block, 1, false);
		}
		
		// Place block
		if (_rb && hit && (i > 3 - _dz)) {
			world_set_block(cx, cy, cz, selected_block)
			audio_play_sound(snd_place_block, 1, false);
		}	
	},
	
	draw : function() {
		if !(hit) return;
		shader_set(shd_cursor_render)
		gpu_set_cullmode(cull_noculling)
		shader_set_uniform_f(u_pos, 
			floor(sx / GRID) * GRID,
			floor(sy / GRID) * GRID, 
			floor(sz / GRID) * GRID)
		vertex_submit(vbuff_wirebox, global.prim_type, -1)
		gpu_set_cullmode(cull_counterclockwise)
		shader_reset()
	},	
}


//====================================================================
#region Old buffers

//====================================================================
#region Vertex building - wood

//tex_wood = sprite_get_texture(spr_wood, 0)
//vbuff_ground = vertex_create_buffer()

//vertex_begin(vbuff_ground, V_FORMAT)
//var _pos_from	= new vec3(-grid/2, -grid/2, 0)
//var _pos_to		= new vec3(grid/2, grid/2, 48)
//var _cols

//_cols[0] = [ #FF0000, #FF0000, #FF0000, #FF0000]
//_cols[1] = [ #00FF00, #00FF00, #00FF00, #00FF00]
//_cols[2] = [ #0000FF, #0000FF, #0000FF, #0000FF]

//_cols[3] = [ #FF7777, #FF7777, #FF7777, #FF7777]
//_cols[4] = [ #77FF77, #77FF77, #77FF77, #77FF77]
//_cols[5] = [ #7777FF, #7777FF, #7777FF, #7777FF]

////_cols[9] = [ #DEB887, #8B4513, #8B4513, #220202]
//_cols[9] = [c_gray, c_gray, c_white, c_white]


//// top
//vertex_create_face(vbuff_ground, 
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
//	new vec3(_pos_to.x,		_pos_from.y,	_pos_from.z),
//	new vec3(_pos_to.x,		_pos_to.y,		_pos_from.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
//	_cols[9], 1, 48/grid, 48/grid)
	
//// bottom
//vertex_create_face(vbuff_ground, 
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
//	new vec3(_pos_to.x,		_pos_from.y,	_pos_to.z),
//	new vec3(_pos_to.x,		_pos_to.y,		_pos_to.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
//	AC_WHITE, 1, 48/grid, 48/grid)
	
//// north
//vertex_create_face(vbuff_ground, 
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
//	_cols[9], 1, 16/grid, 48/grid)
	
//// south
//vertex_create_face(vbuff_ground, 
//	new vec3(_pos_to.x,	_pos_from.y,		_pos_from.z),
//	new vec3(_pos_to.x,	_pos_to.y,			_pos_from.z),
//	new vec3(_pos_to.x,	_pos_to.y,			_pos_to.z),
//	new vec3(_pos_to.x,	_pos_from.y,		_pos_to.z),
//	_cols[9], 1, 16/grid, 48/grid)
	
//// west
//vertex_create_face(vbuff_ground, 
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
//	new vec3(_pos_to.x,		_pos_to.y,		_pos_from.z),
//	new vec3(_pos_to.x,		_pos_to.y,		_pos_to.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
//	_cols[9], 1, 16/grid, 48/grid)
	
//// east
//vertex_create_face(vbuff_ground, 
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
//	new vec3(_pos_to.x,		_pos_from.y,	_pos_from.z),
//	new vec3(_pos_to.x,		_pos_from.y,	_pos_to.z),
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
//	_cols[9], 1, 16/grid, 48/grid)
		
//vertex_end(vbuff_ground)
//vertex_freeze(vbuff_ground)

#endregion
//====================================================================


//====================================================================
#region Vertex building - leafes

//vbuff_leafes = vertex_create_buffer()

//vertex_begin(vbuff_leafes, V_FORMAT)
//var _pos_from	= new vec3(-grid/2, -grid/2, 0)
//var _pos_to		= new vec3(grid/2, grid/2, 48)
////var _cols = [c_lime, c_green, c_green, #002200]
//var _cols = [c_dkgray, c_dkgray, c_white, c_white]


//// top
//vertex_create_face(vbuff_leafes, 
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
//	new vec3(_pos_to.x,		_pos_from.y,	_pos_from.z),
//	new vec3(_pos_to.x,		_pos_to.y,		_pos_from.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
//	[c_dkgray, c_dkgray, c_dkgray, c_dkgray], 1, 48/grid, 48/grid)
	
//// bottom
//vertex_create_face(vbuff_leafes, 
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
//	new vec3(_pos_to.x,		_pos_from.y,	_pos_to.z),
//	new vec3(_pos_to.x,		_pos_to.y,		_pos_to.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
//	AC_WHITE, 1, 48/grid, 48/grid)
	
//// north
//vertex_create_face(vbuff_leafes, 
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
//	_cols, 1, 48/grid, 48/grid)
	
//// south
//vertex_create_face(vbuff_leafes, 
//	new vec3(_pos_to.x,	_pos_from.y,		_pos_from.z),
//	new vec3(_pos_to.x,	_pos_to.y,			_pos_from.z),
//	new vec3(_pos_to.x,	_pos_to.y,			_pos_to.z),
//	new vec3(_pos_to.x,	_pos_from.y,		_pos_to.z),
//	_cols, 1, 48/grid, 48/grid)
	
//// west
//vertex_create_face(vbuff_leafes, 
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
//	new vec3(_pos_to.x,		_pos_to.y,		_pos_from.z),
//	new vec3(_pos_to.x,		_pos_to.y,		_pos_to.z),
//	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
//	_cols, 1, 48/grid, 48/grid)
	
//// east
//vertex_create_face(vbuff_leafes, 
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
//	new vec3(_pos_to.x,		_pos_from.y,	_pos_from.z),
//	new vec3(_pos_to.x,		_pos_from.y,	_pos_to.z),
//	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
//	_cols, 1, 48/grid, 48/grid)
		
//vertex_end(vbuff_leafes)
//vertex_freeze(vbuff_leafes)

#endregion
//====================================================================


//====================================================================
#region Vertex building - floor

//var _wid = 1024
//var _len = 1024

//tex_grass = sprite_get_texture(spr_grass, 0)
//grass_uvs	= sprite_get_uvs(spr_grass, 0)
//vbuff_floor = vertex_create_buffer()

//vertex_begin(vbuff_floor, V_FORMAT)
//vertex_create_face(vbuff_floor,
//	new vec3(	_wid,		_len,	0),
//	new vec3(	-_wid,		_len,	0),
//	new vec3(	-_wid,		-_len,	0),
//	new vec3(	_wid,		-_len,	0),
//	[c_gray, c_gray, c_gray, c_gray], 1, _wid/grid, _len/grid)

//vertex_end(vbuff_floor)
//vertex_freeze(vbuff_floor)

#endregion
//====================================================================

#endregion
//====================================================================



//perlin_test = function() {
//	static index_x = 0
//	static index_y = 0
	
//	var _left	= (keyboard_check_pressed(vk_left))
//	var _right	= (keyboard_check_pressed(vk_right))
//	var _up		= (keyboard_check_pressed(vk_up))
//	var _down	= (keyboard_check_pressed(vk_down))
	
//	index_x += (_right - _left)
//	index_y += (_down - _up)
	
//	var _perlin = perlin_get(index_x, index_y)
	
//	//show_debug_message(string(_perlin) + " at coords " + string(index_x) + " - " + string(index_y))
//}