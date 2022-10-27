

cam_fov += keyboard_check(vk_numpad8) - keyboard_check(vk_numpad7)
cam_fov = clamp(cam_fov, 1, 179)

