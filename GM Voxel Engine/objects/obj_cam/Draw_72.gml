//draw_clear(#73D7FF)

//====================================================================
#region Camera setup

var _look_dir	= obj_player.look_dir
var _look_pitch = obj_player.look_pitch

cam_from.x = obj_player.x
cam_from.y = obj_player.y
cam_from.z = obj_player.z

cam_to.x = cam_from.x + dcos(_look_dir) * dcos(_look_pitch)
cam_to.y = cam_from.y - dsin(_look_dir) * dcos(_look_pitch)
cam_to.z = cam_from.z - dsin(_look_pitch)

var _view_mat = matrix_build_lookat(
	cam_from.x, 
	cam_from.y, 
	cam_from.z, 
	cam_to.x,	
	cam_to.y,	
	cam_to.z, 
	0, 0, -1)	

var _win_w = window_get_width()
var _win_h = window_get_height()
var _proj_mat = matrix_build_projection_perspective_fov(cam_fov, _win_w/_win_h, 1, 32000);

camera_set_view_mat(cam, _view_mat)
camera_set_proj_mat(cam, _proj_mat)

camera_apply(cam)

#endregion
//====================================================================
