

var _sky_hei = 256*GRID
var _sky_col_top = c_aqua
var _sky_col_bot = c_ltgray

vbuff_sky = vertex_create_buffer()
vertex_begin(vbuff_sky, V_FORMAT_SKY)

//====================================================================
#region Skybox mesh

// top
vertex_add_point_b(vbuff_sky, -_sky_hei, -_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)

vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)


// bottom
vertex_add_point_b(vbuff_sky, -_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, -_sky_hei, _sky_col_bot, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)

vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, -_sky_hei, _sky_col_bot, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, +_sky_hei, -_sky_hei, _sky_col_bot, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)


// north
vertex_add_point_b(vbuff_sky, -_sky_hei, -_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)

vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, -_sky_hei, _sky_col_bot, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)


// south
vertex_add_point_b(vbuff_sky, +_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)

vertex_add_point_b(vbuff_sky, +_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, +_sky_hei, -_sky_hei, _sky_col_bot, 1)


// west
vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, -_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)

vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, -_sky_hei, -_sky_hei, _sky_col_bot, 1)


// east
vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, -_sky_hei, _sky_col_bot, 1)

vertex_add_point_b(vbuff_sky, +_sky_hei, +_sky_hei, +_sky_hei, _sky_col_top, 1)
vertex_add_point_b(vbuff_sky, +_sky_hei, +_sky_hei, -_sky_hei, _sky_col_bot, 1)
vertex_add_point_b(vbuff_sky, -_sky_hei, +_sky_hei, -_sky_hei, _sky_col_bot, 1)

#endregion
//====================================================================

vertex_end(vbuff_sky)
vertex_freeze(vbuff_sky)





var _clouds_hei = 128*GRID
var _clouds_size = 1/4;

vbuff_clouds = vertex_create_buffer()
tex_clouds = sprite_get_texture(spr_clouds, 0)

vertex_begin(vbuff_clouds, V_FORMAT_BLOCK)
//====================================================================
#region Clouds mesh

for (var i = 0; i < GRID*2; i += 2) {
	vertex_add_point(vbuff_clouds, -_sky_hei, -_sky_hei, +_clouds_hei-i, 0, 0, 0)
	vertex_add_point(vbuff_clouds, +_sky_hei, -_sky_hei, +_clouds_hei-i, _clouds_size, 0, 0)
	vertex_add_point(vbuff_clouds, -_sky_hei, +_sky_hei, +_clouds_hei-i, 0, _clouds_size, 0)

	vertex_add_point(vbuff_clouds, +_sky_hei, -_sky_hei, +_clouds_hei-i, _clouds_size, 0, 0)
	vertex_add_point(vbuff_clouds, +_sky_hei, +_sky_hei, +_clouds_hei-i, _clouds_size, _clouds_size, 0)
	vertex_add_point(vbuff_clouds, -_sky_hei, +_sky_hei, +_clouds_hei-i, 0, _clouds_size, 0)
}


#endregion
//====================================================================

vertex_end(vbuff_clouds)
vertex_freeze(vbuff_clouds)