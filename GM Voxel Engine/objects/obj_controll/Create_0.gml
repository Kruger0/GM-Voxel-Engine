
instance_create_depth(0, 0, 0, obj_player)
instance_create_depth(0, 0, 0, obj_cam)
instance_create_depth(0, 0, 0, obj_worldgen)
instance_create_depth(0, 0, 0, obj_renderer)
instance_create_depth(0, 0, 0, obj_skybox)

draw_set_font(fnt_mc)


//Set AA as high as possible
aa = max(display_aa&2,display_aa&4,display_aa&8);
display_reset(aa,0);

// TODO fix texture padding before turn this on again

//gpu_set_tex_mip_bias(0)
//gpu_set_tex_mip_filter(tf_linear)
//gpu_set_tex_mip_enable(mip_on)


global.surface_page = -1
global.texture_page = -1
global.prim_type	= pr_trianglelist;
global.fx_ssao		= true;
global.fx_shadows	= false;

#macro MICROSECOND 12000
