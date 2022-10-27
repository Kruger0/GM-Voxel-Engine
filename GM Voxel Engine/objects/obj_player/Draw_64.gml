
//====================================================================
#region Debug renderer

var n = 1
var sep = 20
var xx = 16

draw_sprite(spr_crosshair, 0, display_get_gui_width()/2, display_get_gui_height()/2)
draw_sprite_stretched_ext(spr_pixel, 0, 0, 0, 200, sep*26, c_black, 0.6)

draw_text(xx, sep*n++, "Debug info")
n++
draw_text(xx, sep*n++, "Fps:  " + string(fps))
draw_text(xx, sep*n++, "Fps real:  " + string(fps_real))
draw_text(xx, sep*n++, "Look dir:  " + string(look_dir))
draw_text(xx, sep*n++, "Look pitch:  " +string(look_pitch))
draw_text(xx, sep*n++, "FOV:  " +string(obj_cam.cam_fov))
n++
draw_text(xx, sep*n++, "X:  " + string(x))
draw_text(xx, sep*n++, "Y:  " + string(y))
draw_text(xx, sep*n++, "Z:  " + string(z))
n++
draw_text(xx, sep*n++, "X block:  " + string(x/GRID))
draw_text(xx, sep*n++, "Y block:  " + string(y/GRID))
draw_text(xx, sep*n++, "Z block:  " + string(z/GRID))
n++
draw_text(xx, sep*n++, "Cam lock  " + string(cam_lock))

var _facing = ""
if (look_dir == clamp(look_dir, 0-45, 0+45))		{_facing = "South"}
if (look_dir == clamp(look_dir, 360-45, 360+45))	{_facing = "South"}
if (look_dir == clamp(look_dir, 90-45, 90+45))		{_facing = "West"}
if (look_dir == clamp(look_dir, 180-45, 180+45))	{_facing = "North"}
if (look_dir == clamp(look_dir, 270-45, 270+45))	{_facing = "East"}
draw_text(xx, sep*n++, "Facing:  " + _facing)
n++
draw_text(xx, sep*n++, "Chunks:  " + string(array_length(variable_struct_get_names(global.world_chunks))))
draw_text(xx, sep*n++, "Chunk X:  " + string(obj_worldgen.px))
draw_text(xx, sep*n++, "Chunk Y:  " + string(obj_worldgen.py))
n++
//draw_text(xx, sep*n++, "Chunk density:  " + string(world_get_chunk(x, y).density))
draw_text(xx, sep*n++, "Block ID here:  " + string(raycast.hit))
draw_text(xx, sep*n++, "Block selected:  " + string(global.block_data[selected_block].name))
#endregion
//====================================================================