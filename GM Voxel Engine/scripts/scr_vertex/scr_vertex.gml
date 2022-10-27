
//====================================================================
#region Vertex formats

vertex_format_begin()			
vertex_format_add_position_3d()	
vertex_format_add_normal()		
global.v_format_block = vertex_format_end()
#macro V_FORMAT_BLOCK global.v_format_block

vertex_format_begin()			
vertex_format_add_position_3d()	
vertex_format_add_color()		
global.v_format_sky = vertex_format_end()
#macro V_FORMAT_SKY global.v_format_sky

vertex_format_begin()			
vertex_format_add_position_3d()		
global.v_format_wirebox = vertex_format_end()
#macro V_FORMAT_WIREBOX global.v_format_wirebox

#endregion
//====================================================================


function vertex_create_face(_vbuff, _p1, _p2, _p3, _p4, _cols, _alpha, _wid, _hei) {
	static _texsize = 16
	var _tex_w = _wid
	var _tex_h = _hei
	
	// 1st triangle
	vertex_position_3d(_vbuff, _p1.x, _p1.y, _p1.z)
	vertex_texcoord(_vbuff, 0, 0)
	vertex_color(_vbuff, _cols[0], _alpha)
	
	vertex_position_3d(_vbuff, _p2.x, _p2.y, _p2.z)
	vertex_texcoord(_vbuff, _tex_w, 0)
	vertex_color(_vbuff, _cols[1], _alpha)
	
	vertex_position_3d(_vbuff, _p3.x, _p3.y, _p3.z)
	vertex_texcoord(_vbuff, _tex_w, _tex_h)
	vertex_color(_vbuff, _cols[2], _alpha)
	
	// 2st triangle
	vertex_position_3d(_vbuff, _p1.x, _p1.y, _p1.z)
	vertex_texcoord(_vbuff, 0, 0)
	vertex_color(_vbuff, _cols[0], _alpha)
	
	vertex_position_3d(_vbuff, _p3.x, _p3.y, _p3.z)
	vertex_texcoord(_vbuff, _tex_w, _tex_h)
	vertex_color(_vbuff, _cols[2], _alpha)
	
	vertex_position_3d(_vbuff, _p4.x, _p4.y, _p4.z)
	vertex_texcoord(_vbuff, 0, _tex_h)
	vertex_color(_vbuff, _cols[3], _alpha)
}
	
function vertex_create_cube(_vbuff, _pos_from, _pos_to, _cols, _alpha, _wid, _hei) {
// top
vertex_create_face(_vbuff, 
	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
	new vec3(_pos_to.x,		_pos_from.y,	_pos_from.z),
	new vec3(_pos_to.x,		_pos_to.y,		_pos_from.z),
	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
	_cols[0], _alpha, _wid, _hei)
	
// bottom
vertex_create_face(_vbuff, 
	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
	new vec3(_pos_to.x,		_pos_from.y,	_pos_to.z),
	new vec3(_pos_to.x,		_pos_to.y,		_pos_to.z),
	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
	_cols[1], _alpha, _wid, _hei)
	
// north
vertex_create_face(_vbuff, 
	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
	_cols[2], _alpha, _wid, _hei)
	
// south
vertex_create_face(_vbuff, 
	new vec3(_pos_to.x,	_pos_from.y,		_pos_from.z),
	new vec3(_pos_to.x,	_pos_to.y,			_pos_from.z),
	new vec3(_pos_to.x,	_pos_to.y,			_pos_to.z),
	new vec3(_pos_to.x,	_pos_from.y,		_pos_to.z),
	_cols[3], _alpha, _wid, _hei)
	
// west
vertex_create_face(_vbuff, 
	new vec3(_pos_from.x,	_pos_to.y,		_pos_from.z),
	new vec3(_pos_to.x,		_pos_to.y,		_pos_from.z),
	new vec3(_pos_to.x,		_pos_to.y,		_pos_to.z),
	new vec3(_pos_from.x,	_pos_to.y,		_pos_to.z),
	_cols[4], _alpha, _wid, _hei)
	
// east
vertex_create_face(_vbuff, 
	new vec3(_pos_from.x,	_pos_from.y,	_pos_from.z),
	new vec3(_pos_to.x,		_pos_from.y,	_pos_from.z),
	new vec3(_pos_to.x,		_pos_from.y,	_pos_to.z),
	new vec3(_pos_from.x,	_pos_from.y,	_pos_to.z),
	_cols[5], _alpha, _wid, _hei)
}

function vertex_add_point(_vbuff, _x, _y, _z, _block, _normal, _ssao) {
	vertex_position_3d(_vbuff, _x, _y, _z)
	vertex_normal(_vbuff, _block, _normal, _ssao)
}

function vertex_add_point_b(_vbuff, _x, _y, _z, _color, _alpha) {
	vertex_position_3d(_vbuff, _x, _y, _z)
	vertex_color(_vbuff, _color, _alpha)
}

function buffer_add_face(_vbuff, _p1, _p2, _p3, _p4, _texcoord, _normals) {
	
	// 1st triangle
	vertex_position_3d(_vbuff, _p1.x, _p1.y, _p1.z)
	vertex_texcoord(_vbuff, _texcoord.x, _texcoord.y)
	vertex_normal(_vbuff, _normals.x, _normals.x, _normals.x)
	
	vertex_position_3d(_vbuff, _p2.x, _p2.y, _p2.z)
	vertex_texcoord(_vbuff, _texcoord.z, _texcoord.y)
	vertex_normal(_vbuff, _normals.y, _normals.y, _normals.y)
	
	vertex_position_3d(_vbuff, _p3.x, _p3.y, _p3.z)
	vertex_texcoord(_vbuff, _texcoord.x, _texcoord.w)
	vertex_normal(_vbuff, _normals.z, _normals.z, _normals.z)
	
	// 2st triangle
	vertex_position_3d(_vbuff, _p2.x, _p2.y, _p2.z)
	vertex_texcoord(_vbuff, _texcoord.z, _texcoord.y)
	vertex_normal(_vbuff, _normals.y, _normals.y, _normals.y)
	
	vertex_position_3d(_vbuff, _p4.x, _p4.y, _p4.z)
	vertex_texcoord(_vbuff, _texcoord.z, _texcoord.w)
	vertex_normal(_vbuff, _normals.w, _normals.w, _normals.w)
	
	vertex_position_3d(_vbuff, _p3.x, _p3.y, _p3.z)
	vertex_texcoord(_vbuff, _texcoord.x, _texcoord.w)
	vertex_normal(_vbuff, _normals.z, _normals.z, _normals.z)
}

function buffer_add_cube(_vbuff, _x, _y, _z, _cube_id) {

	var _alpha		= 1.0
	var _texcoord	= new vec4(0, 0, 0, 0)
	var _texsize	= new vec2(
		(1/sprite_get_width(spr_blocks)*GRID), 
		(1/sprite_get_height(spr_blocks)*GRID)
	)
	
	var _face_id_f  = true
	var _face_id	= 2*_face_id_f
	
	_texcoord.x = _face_id * _texsize.x
	_texcoord.y = _cube_id * _texsize.y
	_texcoord.z = _texcoord.x + _texsize.x
	_texcoord.w = _texcoord.y + _texsize.y
	
	//====================================================================
	#region Top
		
		buffer_add_face(_vbuff, 
			new vec3(_x,		_y,			_z),
			new vec3(_x,		_y+GRID,	_z),
			new vec3(_x+GRID,	_y,			_z),
			new vec3(_x+GRID,	_y+GRID,	_z),
			
			_texcoord, new vec3(-1.0, 0, 0)
		);
	
	#endregion
	//====================================================================

	//====================================================================
	#region South
	
		_texcoord.x += _texsize.x
		_texcoord.z += _texsize.x
		
		buffer_add_face(_vbuff, 
			new vec3(_x+GRID,	_y,			_z),
			new vec3(_x+GRID,	_y+GRID,	_z),
			new vec3(_x+GRID,	_y,			_z-GRID),
			new vec3(_x+GRID,	_y+GRID,	_z-GRID),
			
			_texcoord, new vec3(-0.8, 0, 0)
		);
	
	#endregion
	//====================================================================

	//====================================================================
	#region East
	
		_texcoord.x += _texsize.x
		_texcoord.z += _texsize.x
		
		buffer_add_face(_vbuff, 
			new vec3(_x+GRID,	_y+GRID,	_z),
			new vec3(_x,		_y+GRID,	_z),
			new vec3(_x+GRID,	_y+GRID,	_z-GRID),
			new vec3(_x,		_y+GRID,	_z-GRID),
			
			_texcoord, new vec3(-0.5, 0, 0)
		);
	
	#endregion
	//====================================================================

	//====================================================================
	#region North
		
		_texcoord.x += _texsize.x*2
		//_texcoord.z += _texsize.x
		
		buffer_add_face(_vbuff, 
			new vec3(_x,		_y,		_z),
			new vec3(_x,		_y+GRID,_z),
			new vec3(_x,		_y,		_z-GRID),
			new vec3(_x,		_y+GRID,_z-GRID),
			
			_texcoord, new vec3(-0.8, 0, 0)
		);
	
	#endregion
	//====================================================================

	//====================================================================
	#region West
	
		//_texcoord.x -= _texsize.x
		_texcoord.z += _texsize.x*2
		
		buffer_add_face(_vbuff, 
			new vec3(_x,		_y,		_z),
			new vec3(_x+GRID,	_y,		_z),
			new vec3(_x,		_y,		_z-GRID),
			new vec3(_x+GRID,	_y,		_z-GRID),
			
			_texcoord, new vec3(-0.5, 0, 0)
		);
	
	#endregion
	//====================================================================
	
	//====================================================================
	#region Bottom

		_texcoord.x += _texsize.x
		_texcoord.z += _texsize.x
		
		buffer_add_face(_vbuff, 
			new vec3(_x,		_y,			_z-GRID),
			new vec3(_x,		_y+GRID,	_z-GRID),
			new vec3(_x+GRID,	_y,			_z-GRID),
			new vec3(_x+GRID,	_y+GRID,	_z-GRID),
			
			_texcoord, new vec3(-0.4, 0, 0)
		);
	
	#endregion
	//====================================================================
}

function buffer_add_billboard(_vbuff, _x, _y, _z, _cube_id) {
	
	var _texcoord	= new vec4(0, 0, 0, 0)
	var _texsize	= new vec2(
		(1/sprite_get_width(spr_blocks)*GRID), 
		(1/sprite_get_height(spr_blocks)*GRID)
	)
	
	var _face_id_f  = true
	var _face_id	= 2*_face_id_f
	
	_texcoord.x = _face_id * _texsize.x
	_texcoord.y = _cube_id * _texsize.y
	_texcoord.z = _texcoord.x + _texsize.x
	_texcoord.w = _texcoord.y + _texsize.y
	
	// 1rt plane
	buffer_add_face(_vbuff, 
		new vec3(_x,		_y,			_z+GRID),
		new vec3(_x+GRID,	_y+GRID,	_z+GRID),
		new vec3(_x,		_y,			_z),
		new vec3(_x+GRID,	_y+GRID,	_z),
			_texcoord, new vec3(-0.8, 0, 0)	
	);
	
	// 2nd plane
	buffer_add_face(_vbuff, 
		new vec3(_x+GRID,	_y,			_z+GRID),
		new vec3(_x,		_y+GRID,	_z+GRID),
		new vec3(_x+GRID,	_y,			_z),
		new vec3(_x,		_y+GRID,	_z),
			_texcoord, new vec3(-0.8, 0, 0)		
	);
}

















