
cam			= view_camera[0]
cam_fov		= 90
cam_from	= new vec3() 
cam_to		= new vec3() 

scale = {
	cam	: 4.0,
	win	: 4.0,
	gui	: 4.0,
	app : 4.0,
}

scale_fac = 6
base_w = 1920/scale_fac
base_h = 1080/scale_fac

camera_set_view_size(cam,			base_w*scale.cam,	base_h*scale.cam)
window_set_size(					base_w*scale.win,	base_h*scale.win)
display_set_gui_size(				base_w*scale.gui,	base_h*scale.gui)
surface_resize(application_surface, base_w*scale.app,	base_h*scale.app)

cam_aps = camera_get_view_width(cam)/camera_get_view_height(cam);

gpu_set_ztestenable(true)
gpu_set_zwriteenable(true)

gpu_set_alphatestenable(true)
gpu_set_alphatestref(0.5)

gpu_set_cullmode(cull_counterclockwise)


