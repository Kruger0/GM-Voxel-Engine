
/*
			EasyPerlin for GMS2
			Made by Krug
			
			Generate more noise sprites here!
			http://kitfox.com/projects/perlinNoiseMaker/
*/

// Setup
var _spr		= spr_perlin;
var _spr_frame	= 0 // If you sprite has multiple frames for different noise types, change it here

var _spr_w		= sprite_get_width(_spr);
var _spr_h      = sprite_get_height(_spr);
var _per_surf   = surface_create(_spr_w, _spr_h);
var _temp_buff  = buffer_create(_spr_w * _spr_h * 4, buffer_fixed, 1);

global._perlin_cache		= {};
global._perlin_cache.w		= _spr_w;
global._perlin_cache.h		= _spr_h;
global._perlin_cache.buff	= buffer_create(_spr_w * _spr_h, buffer_fast, 1);

// Copy noise sprite to the surface, then to the temp buffer
surface_set_target(_per_surf);
draw_sprite(_spr, _spr_frame, 0, 0);
surface_reset_target();
buffer_get_surface(_temp_buff, _per_surf, 0);

// Copy temp buffer to the main buffer
for (var _i = 0; _i < _spr_w * _spr_h; _i++) {
    var _r = _i * 4;
    var _val = buffer_peek(_temp_buff, _r, buffer_u8);
    buffer_poke(global._perlin_cache.buff, _i, buffer_u8, _val);
}

// Cemory cleanup
surface_free(_per_surf);
buffer_delete(_temp_buff);


///@ Returns a perlin noise value in a 2D coordinate system
function perlin_get(_x, _y = 0) {
    var _data = global._perlin_cache;
    var _xx = floor(abs(_x)) mod _data.w;
    var _yy = floor(abs(_y)) mod _data.h;
	
	_xx = (_x < 0 ? _data.w - _xx-1 : _xx)
	_yy = (_y < 0 ? _data.h - _yy-1 : _yy)

    var _pos = _xx + (_yy * (_data.w))
    return 0.5 - buffer_peek(_data.buff, _pos, buffer_u8)/255;
}