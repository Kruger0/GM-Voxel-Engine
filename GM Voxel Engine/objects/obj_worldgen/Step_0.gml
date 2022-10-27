
step()

if (keyboard_check_pressed(vk_f8)) {
	global.prim_type = (global.prim_type == pr_trianglelist ? pr_linelist : pr_trianglelist)
}