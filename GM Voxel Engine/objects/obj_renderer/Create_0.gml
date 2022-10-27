
//// init screen render (only call this once). This will work to the rest of the game.
//ppfx_application_render_init();

//// create post-processing system id to be used by the other functions
//ppfx_id = ppfx_create();

//// create simple profile with all effects
//ppfx_profile = ppfx_profile_create("Game", [
//	new pp_fxaa(true, 2),
//	new pp_vignette(true, 1, 0.5, 0.2, 1.2, c_black),
//	new pp_chromaber(true, 2, 0, true),
//	//new pp_brightness(true, 1.1),
//	//new pp_tone_mapping(true, 2),
//	//new pp_dithering(true, 0, 0.4, 0),
//	//new pp_bloom(true, 3, 0.7),
//	//new pp_depth_of_field(true, , , , , , true),
//	new pp_saturation(true, 1.1),
//	//new pp_sunshafts(true),
//	//new pp_lift_gamma_gain(true)
//	//new pp_sunshafts(true, [0, 0], , 0.9, 10)
//]);

//// load profile
//ppfx_profile_load(ppfx_id, ppfx_profile);
