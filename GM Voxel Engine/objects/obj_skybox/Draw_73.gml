

gpu_set_cullmode(cull_noculling)
gpu_set_tex_repeat(true)

shader_set(shd_clouds)
var _time = shader_get_uniform(shd_clouds, "u_time");
shader_set_uniform_f(_time, current_time/100000)
vertex_submit(vbuff_clouds, pr_trianglelist, tex_clouds)
shader_reset()

gpu_set_cullmode(cull_counterclockwise)
gpu_set_tex_repeat(false)