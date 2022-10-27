
if !(surface_exists(global.surface_page)) {
	global.surface_page = surface_create(256, 256)
	surface_set_target(global.surface_page)
		draw_clear_alpha(0, 0)
		draw_sprite(spr_texture, 0, 0, 0)
	surface_reset_target()
	
}

var _tex1 = sprite_get_texture(spr_texture, 0)
var _tex2 = surface_get_texture(global.surface_page)
global.texture_page = _tex1

