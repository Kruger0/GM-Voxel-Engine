
show_debug_overlay(true)

#region buffer size test
//vertex_format_begin()
////vertex_format_add_position_3d()
////vertex_format_add_color()
////vertex_format_add_texcoord()
//vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord)
////vertex_format_add_normal()
//var _vform = vertex_format_end()


//vbuff_test = vertex_create_buffer()
//vertex_begin(vbuff_test, _vform)
////vertex_position_3d(_vbuff, 1, 1, 1)
////vertex_color(_vbuff, c_white, 1.0)
////vertex_texcoord(vbuff_test, 1, 1)
//vertex_float2(vbuff_test, 1, 1)
////vertex_normal(_vbuff, 1, 1, 1)
//vertex_end(vbuff_test)

////vertex_freeze(_vbuff)

//buff_test = buffer_create_from_vertex_buffer(vbuff_test, buffer_fixed, 1)

//show_message(buffer_get_size(buff_test))
#endregion

/*
color		04 bytes
texcoord	08 bytes
position	12 bytes
normal		12 bytes
---------------------
			36 bytes
			
12 - position 3D
12 - normal

*/


//====================================================================
#region Chunk building


#macro CHUNK_XLEN 16
#macro CHUNK_YLEN 16
#macro CHUNK_ZLEN 32
#macro CHUNK_BYTE_LEN 1
#macro WORLD_SEA_HEI 16
#macro NOISE_HEI_FACTOR 32

#macro GEN_WAIT		1.0
#macro MESH_WAIT	1.0


function chunk_build(_x, _y) constructor {
	
	// Chunk world position - stored in orders of 16
	chunk_x = _x
	chunk_y = _y

	#region Chunk data generation

	generated		= false;
	chunk_gen_x		= 0
	chunk_gen_y		= 0
	chunk_gen_z		= 0
		
	chunk_size		= (CHUNK_XLEN * CHUNK_YLEN * CHUNK_ZLEN) * 4
	chunk_buffer	= buffer_create(chunk_size, buffer_fast, 1)	
	//buffer_fill(chunk_buffer, 1, buffer_u8, BLOCK_ID.AIR, chunk_size)
	density		= 0.0; // 0 -> nothing | 4098 -> full
	#endregion
	
	#region Chunk model generation
	
	// Block model
	mesh			= undefined;
	mesh_load		= undefined;
	builded			= false;
	updated			= false;
	chunk_load_x	= 0
	chunk_load_y	= 0
	chunk_load_z	= 0
	
	// Billboard model
	vb_bb			= undefined;
	vb_bb_load		= undefined;
	
	// Transparent model - water, glass
	mesh_alpha		= undefined
	mesh_alpha_load	= undefined
	#endregion
	
	
	static generate_terrain = function() {
		var _timer = get_timer();
		for (; chunk_gen_x < CHUNK_XLEN; chunk_gen_x++) {
			for (; chunk_gen_y < CHUNK_YLEN; chunk_gen_y++) {
				
				//var _chk_x = (chunk_x < 0 ? GRID - chunk_x : chunk_x)
				//var _chk_y = (chunk_y < 0 ? GRID - chunk_y : chunk_y)
				
				var _perlin_x = chunk_gen_x + (chunk_x)// - !(chunk_x < 0))
				var _perlin_y = chunk_gen_y + (chunk_y)// - !(chunk_y < 0))
				
				_perlin_x += (chunk_x < 0)*1
				_perlin_y += (chunk_y < 0)*1
				
				//_perlin_x = (chunk_x < 0 ? GRID - _perlin_x-1 : _perlin_x)
				//_perlin_y = (chunk_y < 0 ? GRID - _perlin_y-1 : _perlin_y)
				
				//show_debug_message(_perlin_x)
				
				
				var _hei = ceil(perlin_get(_perlin_x, _perlin_y)*NOISE_HEI_FACTOR)+WORLD_SEA_HEI
				var _dirt_hei = irandom_range(3, 5)
				//var _bedrock_hei = irandom_range(0, 3);
				
				for (; chunk_gen_z < CHUNK_ZLEN; chunk_gen_z++) {
					
					// Default block
					var _block = BLOCK_ID.AIR
					var _gen_z = chunk_gen_z
					
					// Terrain
					if (_gen_z > _hei-24 && _gen_z < _hei-12 && false) {
						_block = BLOCK_ID.AIR
					} else if (_gen_z < _hei-_dirt_hei) {
						_block = BLOCK_ID.STONE
					} else if (_gen_z < _hei) {
						_block = BLOCK_ID.DIRT
					} else if(_gen_z == _hei) {
						_block = (_hei > CHUNK_ZLEN*0.6 ? BLOCK_ID.STONE: (_hei > WORLD_SEA_HEI-4 ? BLOCK_ID.GRASSDIRT : BLOCK_ID.SAND))
					}
										
					// Bedrock - kind of a useless conditional :P
					//if (_gen_z <= _bedrock_hei) {
					//	_block = BLOCK_ID.BEDROCK
					//}
					
					// World ceil
					//if (_gen_z == CHUNK_ZLEN-1) {
					//	_block = BLOCK_ID.GLASS
					//}
					
					// Grass
					//if (_gen_z == _hei + 1 && random(100) < 5) {
					//	_block = BLOCK_ID.GRASS
					//}
										
					if (_block != BLOCK_ID.AIR) {
						chunk_set_block(chunk_buffer, chunk_gen_x, chunk_gen_y, chunk_gen_z, _block)
						density++;
					}				
					
					// Break the loop if take too long
					if (get_timer() - _timer >= MICROSECOND/GEN_WAIT){
						//show_debug_message("Creating chunk data - " + string(ceil((chunk_gen_x/CHUNK_XLEN)*100)) + "%")
						return 0				
					}
				}
				chunk_gen_z = 0;
			}
			chunk_gen_y = 0;
		}	
		
		// Reset gen positions
		chunk_gen_x = 0;		
		chunk_gen_y = 0;
		chunk_gen_z = 0;
		
		// Confirm the generation
		generated = true;
	}
	
	static build_mesh = function() {
		if (generated) {			
			// Inicia o vbuffer de load
			if (mesh_load == undefined) {
				mesh_load = vertex_create_buffer()
				vertex_begin(mesh_load, V_FORMAT_BLOCK)
			}			
			
			var _timer = get_timer();
			
			// Default values - used during the loop
			// This seems weird
			// Change to binary logic latter
			var _ao_level = [1.00, 0.75, 0.50, 0.0]
			var _ssao = new vec4()
			var _air = BLOCK_ID.AIR;
			//var _grass = BLOCK_ID.GRASS;
			
			// Air chunk - no need to render meshes - Legacy from 3D chunk method
			if (density == 0) {
				chunk_load_x = CHUNK_XLEN
				chunk_load_y = CHUNK_YLEN
				chunk_load_z = CHUNK_ZLEN
			}
			
			#region pre-loop var declaration
			
			var i, j, k;
			var _x, _y, _z
			
			var _face;
			
			var _block_top
			var _block_sou
			var _block_eas
			var _block_nor
			var _block_wes
			var _block_bot
			
			var _block_1_1
			var _block_1_2
			var _block_1_3
			var _block_1_4
			var _block_1_5
			var _block_1_6
			var _block_1_7
			var _block_1_8
			var _block_2_1
			var _block_2_3
			var _block_2_6
			var _block_2_8
			var _block_3_1
			var _block_3_2
			var _block_3_3
			var _block_3_4
			var _block_3_5
			var _block_3_6
			var _block_3_7
			var _block_3_8
			
			var _block_here
			var _block_data			
			
			#endregion
					
			for (; chunk_load_x < CHUNK_XLEN; chunk_load_x++) {
				i = chunk_load_x
				for (; chunk_load_y < CHUNK_YLEN; chunk_load_y++) {
					j = chunk_load_y
					for (; chunk_load_z < CHUNK_ZLEN; chunk_load_z++) {					
						k = chunk_load_z						
						
						_block_here = chunk_get_block(chunk_buffer, i, j, k);	
						
						// Block coordinates
						_x = (i*GRID)+chunk_x*CHUNK_XLEN
						_y = (j*GRID)+chunk_y*CHUNK_YLEN
						_z = (k*GRID)
						
						// Air block - no meshes to render
						if (_block_here == _air) {
							//// Create a water face - needs own VBO
							//if ((_z/GRID) = WORLD_SEA_HEI-6) {
							//	// 1rs triangle
							//	vertex_add_point(mesh_load, _x,		_y,		_z,		63, 4,  1.0)
							//	vertex_add_point(mesh_load, _x,		_y+GRID,_z,		63, 4,  1.0)
							//	vertex_add_point(mesh_load, _x+GRID,_y,		_z,		63, 4,  1.0)
																						   	
							//	// 2nd triangle											   	 
							//	vertex_add_point(mesh_load, _x,		_y+GRID,_z,		63, 4,  1.0)
							//	vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z,		63, 4,  1.0)
							//	vertex_add_point(mesh_load, _x+GRID,_y,		_z,		63, 4,  1.0)
							//}
							continue;
						}
						
						// needs ow VBO too :(
						//if (_block_here == _grass) {							
						//	vertex_add_point(mesh_load, _x,		_y,		_z,		11, 3,  1.0)
						//	vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z,		11, 3,  1.0)
						//	vertex_add_point(mesh_load, _x,		_y,		_z-GRID,11, 3,  1.0)										   	 	 	 
						//	vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z,		11, 3,  1.0)
						//	vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z-GRID,11, 3,  1.0)
						//	vertex_add_point(mesh_load, _x,		_y,		_z-GRID,11, 3,  1.0)							
						//	continue;
						//}
						
						// Check for air blocks
						// Add opaque verification
						_block_top = chunk_get_block(chunk_buffer, i, j, k+1) == _air
						_block_sou = chunk_get_block(chunk_buffer, i+1, j, k) == _air
						_block_eas = chunk_get_block(chunk_buffer, i, j+1, k) == _air
						_block_nor = chunk_get_block(chunk_buffer, i-1, j, k) == _air						
						_block_wes = chunk_get_block(chunk_buffer, i, j-1, k) == _air							
						_block_bot = chunk_get_block(chunk_buffer, i, j, k-1) == _air
						
						
						// No air blocks nearby - no faces to render						
						if !(_block_top|
							 _block_sou|
							 _block_eas|
							 _block_nor|
							 _block_wes|
							 _block_bot) {
							continue;
						}
						
						
						_block_data = global.block_data[_block_here]
						
						//====================================================================
						#region Get neighbors for SSAO		
								
						// 1st layer
						_block_1_1 = chunk_get_block(chunk_buffer,	i-1,	j-1,	k+1) != _air
						_block_1_2 = chunk_get_block(chunk_buffer,	i-1,	j,		k+1) != _air
						_block_1_3 = chunk_get_block(chunk_buffer,	i-1,	j+1,	k+1) != _air
																								  
						_block_1_4 = chunk_get_block(chunk_buffer,	i,		j-1,	k+1) != _air
						_block_1_5 = chunk_get_block(chunk_buffer,	i,		j+1,	k+1) != _air
																								  
						_block_1_6 = chunk_get_block(chunk_buffer,	i+1,	j-1,	k+1) != _air
						_block_1_7 = chunk_get_block(chunk_buffer,	i+1,	j,		k+1) != _air
						_block_1_8 = chunk_get_block(chunk_buffer,	i+1,	j+1,	k+1) != _air
						
						// 2nd layer
						_block_2_1 = chunk_get_block(chunk_buffer,	i-1,	j-1,	k) != _air

						_block_2_3 = chunk_get_block(chunk_buffer,	i-1,	j+1,	k) != _air

						
						_block_2_6 = chunk_get_block(chunk_buffer,	i+1,	j-1,	k) != _air
						
						_block_2_8 = chunk_get_block(chunk_buffer,	i+1,	j+1,	k) != _air
						
						// 3rd layer
						
						_block_3_1 = chunk_get_block(chunk_buffer,	i-1,	j-1,	k-1) != _air
						_block_3_2 = chunk_get_block(chunk_buffer,	i-1,	j,		k-1) != _air
						_block_3_3 = chunk_get_block(chunk_buffer,	i-1,	j+1,	k-1) != _air
							
						_block_3_4 = chunk_get_block(chunk_buffer,	i,		j-1,	k-1) != _air
						_block_3_5 = chunk_get_block(chunk_buffer,	i,		j+1,	k-1) != _air
							
						_block_3_6 = chunk_get_block(chunk_buffer,	i+1,	j-1,	k-1) != _air
						_block_3_7 = chunk_get_block(chunk_buffer,	i+1,	j,		k-1) != _air
						_block_3_8 = chunk_get_block(chunk_buffer,	i+1,	j+1,	k-1) != _air
						
						#endregion
						//====================================================================
						
						
						//====================================================================
						#region Face creation
													
							
							
							//====================================================================
							#region Top
														
							if (_block_top) {
								_face = _block_data.f_top
								//====================================================================
								#region SSAO				
								
								// Default values
								_ssao.x = _ao_level[0]
								_ssao.y = _ao_level[0]
								_ssao.z = _ao_level[0]
								_ssao.w = _ao_level[0]
								
								// Corner 1
								if (_block_1_2 && _block_1_4) {
									_ssao.x = _ao_level[3]
								}
								else								
								if (_block_1_1 && _block_1_2) || (_block_1_1 && _block_1_4) {
									_ssao.x = _ao_level[2]
								} 
								else								
								if (_block_1_1 || _block_1_2 || _block_1_4) {
									_ssao.x = _ao_level[1]
								}	
								

								// Corner 2
								if (_block_1_2 && _block_1_5) {
									_ssao.y = _ao_level[3]
								}
								else								
								if (_block_1_3 && _block_1_2) || (_block_1_3 && _block_1_5) {
									_ssao.y = _ao_level[2]
								} 
								else								
								if (_block_1_2 || _block_1_3 || _block_1_5) {
									_ssao.y = _ao_level[1]
								}	
								

								// Corner 3
								if (_block_1_4 && _block_1_7) {
									_ssao.z = _ao_level[3]
								}
								else								
								if (_block_1_6 && _block_1_4) || (_block_1_6 && _block_1_7) {
									_ssao.z = _ao_level[2]
								} 
								else								
								if (_block_1_4 || _block_1_6 || _block_1_7) {
									_ssao.z = _ao_level[1]
								}
								

								// Corner 4
								if (_block_1_5 && _block_1_7) {
									_ssao.w = _ao_level[3]
								}
								else								
								if (_block_1_8 && _block_1_5) || (_block_1_8 && _block_1_7) {
									_ssao.w = _ao_level[2]
								} 
								else								
								if (_block_1_5 || _block_1_7 || _block_1_8) {
									_ssao.w = _ao_level[1]
								}
								
								#endregion
								//====================================================================								
															
								// 1rs triangle
								vertex_add_point(mesh_load, _x,		_y,		_z,		_face, 4,  _ssao.x)
								vertex_add_point(mesh_load, _x,		_y+GRID,_z,		_face, 4,  _ssao.y)
								vertex_add_point(mesh_load, _x+GRID,_y,		_z,		_face, 4,  _ssao.z)
																						   	
								// 2nd triangle											   	 
								vertex_add_point(mesh_load, _x,		_y+GRID,_z,		_face, 4,  _ssao.y)
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z,		_face, 4,  _ssao.w)
								vertex_add_point(mesh_load, _x+GRID,_y,		_z,		_face, 4,  _ssao.z)
							}
							
							#endregion
							//====================================================================
							
							//====================================================================
							#region South													
							
							if (_block_sou) {
								_face = _block_data.f_sou
								//====================================================================
								#region SSAO
								
								// Default values
								_ssao.x = _ao_level[0]
								_ssao.y = _ao_level[0]
								_ssao.z = _ao_level[0]
								_ssao.w = _ao_level[0]
								
								// Corner 1
								if (_block_2_6 && _block_1_7) {
									_ssao.x = _ao_level[3]
								}
								else								
								if (_block_1_6 && _block_2_6) || (_block_1_6 && _block_1_7) {
									_ssao.x = _ao_level[2]
								} 
								else								
								if (_block_1_6 || _block_1_7 || _block_2_6) {
									_ssao.x = _ao_level[1]
								}	
								

								// Corner 2
								if (_block_1_7 && _block_2_8) {
									_ssao.y = _ao_level[3]
								}
								else								
								if (_block_1_8 && _block_1_7) || (_block_1_8 && _block_2_8) {
									_ssao.y = _ao_level[2]
								} 
								else								
								if (_block_1_7 || _block_1_8 || _block_2_8) {
									_ssao.y = _ao_level[1]
								}	
								

								// Corner 3
								if (_block_2_6 && _block_3_7) {
									_ssao.z = _ao_level[3]
								}
								else								
								if (_block_3_6 && _block_2_6) || (_block_3_6 && _block_3_7) {
									_ssao.z = _ao_level[2]
								} 
								else								
								if (_block_2_6 || _block_3_6 || _block_3_7) {
									_ssao.z = _ao_level[1]
								}
								

								// Corner 4
								if (_block_2_8 && _block_3_7) {
									_ssao.w = _ao_level[3]
								}
								else								
								if (_block_3_8 && _block_2_8) || (_block_3_8 && _block_3_7) {
									_ssao.w = _ao_level[2]
								} 
								else								
								if (_block_2_8 || _block_3_7 || _block_3_8) {
									_ssao.w = _ao_level[1]
								}
								
								#endregion
								//====================================================================
								
								vertex_add_point(mesh_load, _x+GRID,_y,		_z,		_face, 0,  _ssao.x)
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z,		_face, 0,  _ssao.y)
								vertex_add_point(mesh_load, _x+GRID,_y,		_z-GRID,_face, 0,  _ssao.z)
																						   		 
								// 2nd triangle											   	 	 
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z,		_face, 0,  _ssao.y)
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z-GRID,_face, 0,  _ssao.w)
								vertex_add_point(mesh_load, _x+GRID,_y,		_z-GRID,_face, 0,  _ssao.z)
							}
							
							#endregion
							//====================================================================
							
							//====================================================================
							#region East
							
							if (_block_eas) {
								_face = _block_data.f_eas
								//====================================================================
								#region SSAO
								
								// Default values
								_ssao.x = _ao_level[0]
								_ssao.y = _ao_level[0]
								_ssao.z = _ao_level[0]
								_ssao.w = _ao_level[0]
								
								// Corner 1
								if (_block_1_5 && _block_2_8) {
									_ssao.x = _ao_level[3]
								}
								else								
								if (_block_1_8 && _block_1_5) || (_block_1_8 && _block_2_8) {
									_ssao.x = _ao_level[2]
								} 
								else								
								if (_block_1_5 || _block_1_8 || _block_2_8) {
									_ssao.x = _ao_level[1]
								}	
								

								// Corner 2
								if (_block_1_5 && _block_2_3) {
									_ssao.y = _ao_level[3]
								}
								else								
								if (_block_1_3 && _block_1_5) || (_block_1_3 && _block_2_3) {
									_ssao.y = _ao_level[2]
								} 
								else								
								if (_block_1_3 || _block_1_5 || _block_2_3) {
									_ssao.y = _ao_level[1]
								}	
								

								// Corner 3
								if (_block_2_8 && _block_3_5) {
									_ssao.z = _ao_level[3]
								}
								else								
								if (_block_3_8 && _block_2_8) || (_block_3_8 && _block_3_5) {
									_ssao.z = _ao_level[2]
								} 
								else								
								if (_block_2_8 || _block_3_8 || _block_3_5) {
									_ssao.z = _ao_level[1]
								}
								

								// Corner 4
								if (_block_2_3 && _block_3_5) {
									_ssao.w = _ao_level[3]
								}
								else								
								if (_block_3_3 && _block_2_3) || (_block_3_3 && _block_3_5) {
									_ssao.w = _ao_level[2]
								} 
								else								
								if (_block_2_3 || _block_3_3 || _block_3_5) {
									_ssao.w = _ao_level[1]
								}
								
								#endregion
								//====================================================================								
								
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z,		_face, 2,  _ssao.x)
								vertex_add_point(mesh_load, _x,		_y+GRID,_z,		_face, 2,  _ssao.y)
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z-GRID,_face, 2,  _ssao.z)
																						   		 
								// 2nd triangle											   	 	 
								vertex_add_point(mesh_load, _x,		_y+GRID,_z,		_face, 2,  _ssao.y)
								vertex_add_point(mesh_load, _x,		_y+GRID,_z-GRID,_face, 2,  _ssao.w)
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z-GRID,_face, 2,  _ssao.z)
							}
							
							#endregion
							//====================================================================
							
							//====================================================================
							#region North
							
							if (_block_nor) {
								_face = _block_data.f_nor
								//====================================================================
								#region SSAO
								
								// Default values
								_ssao.x = _ao_level[0]
								_ssao.y = _ao_level[0]
								_ssao.z = _ao_level[0]
								_ssao.w = _ao_level[0]
								
								// Corner 1
								if (_block_2_1 && _block_1_2) {
									_ssao.x = _ao_level[3]
								}
								else								
								if (_block_1_1 && _block_2_1) || (_block_1_1 && _block_1_2) {
									_ssao.x = _ao_level[2]
								} 
								else								
								if (_block_1_1 || _block_1_2 || _block_2_1) {
									_ssao.x = _ao_level[1]
								}	
								

								// Corner 2
								if (_block_1_2 && _block_2_3) {
									_ssao.y = _ao_level[3]
								}
								else								
								if (_block_1_3 && _block_1_2) || (_block_1_3 && _block_2_3) {
									_ssao.y = _ao_level[2]
								} 
								else								
								if (_block_1_2 || _block_1_3 || _block_2_3) {
									_ssao.y = _ao_level[1]
								}	
								

								// Corner 3
								if (_block_2_1 && _block_3_2) {
									_ssao.z = _ao_level[3]
								}
								else								
								if (_block_3_1 && _block_3_2) || (_block_3_1 && _block_2_1) {
									_ssao.z = _ao_level[2]
								} 
								else								
								if (_block_2_1 || _block_3_1 || _block_3_2) {
									_ssao.z = _ao_level[1]
								}
								

								// Corner 4
								if (_block_2_3 && _block_3_2) {
									_ssao.w = _ao_level[3]
								}
								else								
								if (_block_3_3 && _block_2_3) || (_block_3_3 && _block_3_2) {
									_ssao.w = _ao_level[2]
								} 
								else								
								if (_block_2_3 || _block_3_2 || _block_3_3) {
									_ssao.w = _ao_level[1]
								}
								
								#endregion
								//====================================================================
								
								vertex_add_point(mesh_load, _x,		_y+GRID,_z,		_face, 1,  _ssao.y)
								vertex_add_point(mesh_load, _x,		_y,		_z,		_face, 1,  _ssao.x)
								vertex_add_point(mesh_load, _x,		_y+GRID,_z-GRID,_face, 1,  _ssao.w)
																						   		 
								// 2nd triangle											   	 	 
								vertex_add_point(mesh_load, _x,		_y,		_z,		_face, 1,  _ssao.x)
								vertex_add_point(mesh_load, _x,		_y,		_z-GRID,_face, 1,  _ssao.z)
								vertex_add_point(mesh_load, _x,		_y+GRID,_z-GRID,_face, 1,  _ssao.w)
							}
							
							#endregion
							//====================================================================							
							
							//====================================================================
							#region West
							
							if (_block_wes) {
								_face = _block_data.f_wes
								//====================================================================
								#region SSAO
								
								// Default values
								_ssao.x = _ao_level[0]
								_ssao.y = _ao_level[0]
								_ssao.z = _ao_level[0]
								_ssao.w = _ao_level[0]
								
								// Corner 1
								if (_block_1_4 && _block_2_6) {
									_ssao.y = _ao_level[3]
								}
								else								
								if (_block_1_6 && _block_1_4) || (_block_1_6 && _block_2_6) {
									_ssao.y = _ao_level[2]
								} 
								else								
								if (_block_1_4 || _block_1_6 || _block_2_6) {
									_ssao.y = _ao_level[1]
								}	
								

								// Corner 2
								if (_block_1_4 && _block_2_1) {
									_ssao.x = _ao_level[3]
								}
								else								
								if (_block_1_1 && _block_1_4) || (_block_1_1 && _block_2_1) {
									_ssao.x = _ao_level[2]
								} 
								else								
								if (_block_1_1 || _block_1_4 || _block_2_1) {
									_ssao.x = _ao_level[1]
								}	
								

								// Corner 3
								if (_block_2_6 && _block_3_4) {
									_ssao.w = _ao_level[3]
								}
								else								
								if (_block_3_6 && _block_2_6) || (_block_3_6 && _block_3_4) {
									_ssao.w = _ao_level[2]
								} 
								else								
								if (_block_2_6 || _block_3_6 || _block_3_4) {
									_ssao.w = _ao_level[1]
								}
								

								// Corner 4
								if (_block_2_1 && _block_3_4) {
									_ssao.z = _ao_level[3]
								}
								else								
								if (_block_3_1 && _block_2_1) || (_block_3_1 && _block_3_4) {
									_ssao.z = _ao_level[2]
								} 
								else								
								if (_block_2_1 || _block_3_1 || _block_3_4) {
									_ssao.z = _ao_level[1]
								}
								
								#endregion
								//====================================================================
								
								vertex_add_point(mesh_load, _x,		_y,		_z,		_face, 3,  _ssao.x)
								vertex_add_point(mesh_load, _x+GRID,_y,		_z,		_face, 3,  _ssao.y)
								vertex_add_point(mesh_load, _x,		_y,		_z-GRID,_face, 3,  _ssao.z)
																						   		 	 
								// 2nd triangle											   	 	 	 
								vertex_add_point(mesh_load, _x+GRID,_y,		_z,		_face, 3,  _ssao.y)
								vertex_add_point(mesh_load, _x+GRID,_y,		_z-GRID,_face, 3,  _ssao.w)
								vertex_add_point(mesh_load, _x,		_y,		_z-GRID,_face, 3,  _ssao.z)
							}
							
							#endregion
							//====================================================================
							
							//====================================================================
							#region Bottom
							
							if (_block_bot) {
								_face = _block_data.f_bot
								//====================================================================
								#region SSAO				
								
								// Default values
								_ssao.x = _ao_level[0]
								_ssao.y = _ao_level[0]
								_ssao.z = _ao_level[0]
								_ssao.w = _ao_level[0]
								
								// Corner 1
								if (_block_3_2 && _block_3_4) {
									_ssao.x = _ao_level[3]
								}
								else								
								if (_block_3_1 && _block_3_2) || (_block_3_1 && _block_3_4) {
									_ssao.x = _ao_level[2]
								} 
								else								
								if (_block_3_1 || _block_3_2 || _block_3_4) {
									_ssao.x = _ao_level[1]
								}	
								

								// Corner 2
								if (_block_3_2 && _block_3_5) {
									_ssao.y = _ao_level[3]
								}
								else								
								if (_block_3_3 && _block_3_2) || (_block_3_3 && _block_3_5) {
									_ssao.y = _ao_level[2]
								} 
								else								
								if (_block_3_2 || _block_3_3 || _block_3_5) {
									_ssao.y = _ao_level[1]
								}	
								

								// Corner 3
								if (_block_3_4 && _block_3_7) {
									_ssao.z = _ao_level[3]
								}
								else								
								if (_block_3_6 && _block_3_4) || (_block_3_6 && _block_3_7) {
									_ssao.z = _ao_level[2]
								} 
								else								
								if (_block_3_4 || _block_3_6 || _block_3_7) {
									_ssao.z = _ao_level[1]
								}
								

								// Corner 4
								if (_block_3_5 && _block_3_7) {
									_ssao.w = _ao_level[3]
								}
								else								
								if (_block_3_8 && _block_3_5) || (_block_3_8 && _block_3_7) {
									_ssao.w = _ao_level[2]
								} 
								else								
								if (_block_3_5 || _block_3_7 || _block_3_8) {
									_ssao.w = _ao_level[1]
								}
								
								#endregion
								//====================================================================
								
								vertex_add_point(mesh_load, _x,		_y+GRID,_z-GRID,_face, 5,  _ssao.y)
								vertex_add_point(mesh_load, _x,		_y,		_z-GRID,_face, 5,  _ssao.x)
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z-GRID,_face, 5,  _ssao.w)
																						   		 
								// 2nd triangle											   	 	 
								vertex_add_point(mesh_load, _x,		_y,		_z-GRID,_face, 5,  _ssao.x)
								vertex_add_point(mesh_load, _x+GRID,_y,		_z-GRID,_face, 5,  _ssao.z)
								vertex_add_point(mesh_load, _x+GRID,_y+GRID,_z-GRID,_face, 5,  _ssao.w)
							}
							
							#endregion
							//====================================================================
							
						#endregion
						//====================================================================
						
						// Break the loop if take too long
						if (get_timer() - _timer >= MICROSECOND/MESH_WAIT) {
							//show_debug_message("Creating chunk mesh - " + string(ceil((chunk_load_x/CHUNK_XLEN)*100)) + "%")
							return 0
						}

					}
					chunk_load_z = 0
				}
				chunk_load_y = 0
			}
			
			// Reset the indexes
			chunk_load_x = 0
			chunk_load_y = 0
			chunk_load_z = 0	
					
			vertex_end(mesh_load)
			if (vertex_get_number(mesh_load)) {
				vertex_freeze(mesh_load)
			}			
			
			if (mesh != undefined) {
				vertex_delete_buffer(mesh)
			}
			
			mesh		= mesh_load
			mesh_load	= undefined
			builded		= true;
			updated		= true
		}
	}
	
	static build_mesh_bb = function() {
		
	},
	
	static build_mesh_alpha = function() {
		
	},
	
	static step = function() {
		if (generated) {
			// If mesh not builded OR not updated
			if (!builded || !updated) {
				build_mesh()
			}
		} else {
			// Data not generated yet
			generate_terrain()
			//show_debug_message("Chunk generatet at " + string(chunk_x) + ", " + string(chunk_y))
		}
	},

	static draw = function() {
		if (builded && density > 0.0) {
			vertex_submit(mesh, global.prim_type, global.texture_page)
		}		
	},
}


global.world_chunks = {};
update_queue	= ds_queue_create()


gen_radius		= 16*GRID;	// chunk data
mesh_radius		= 8*GRID;	// chunk model
render_radius	= 4*GRID;	// chunk submit

px = 0.0;
py = 0.0;

///@ desc create the chunk structure close to the player
world_chunk_create = function() {
	var _kx, _ky;
	var _wx, _wy;
	var _cx, _cy;
	var _key;
	var _chunk;
	
	for (_cy = -gen_radius; _cy <= gen_radius; _cy += GRID) {
		_wy = py+_cy;
		_ky = string(_wy);
		for (_cx = -gen_radius; _cx <= gen_radius; _cx += GRID) {
				
			// point inside sphere				
			if (_cx*_cx + _cy*_cy <= mesh_radius*mesh_radius) {
				_wx = px+_cx;
				_kx = string(_wx);
				_key = _kx+"/"+_ky;
					
				_chunk = variable_struct_get(global.world_chunks, _key);
				// se nao existe uma chunk naquela coordenada, cria uma
				if (_chunk == undefined) {
					global.world_chunks[$ _key] = new chunk_build(_wx, _wy);
				}
			}
		}
	}		
}


///@ desc run the step method for every chunk in the radius
world_chunk_step = function() {
	var _kx, _ky;
	var _wx, _wy;
	var _cx, _cy;
	var _key;
	var _chunk;
	var _dist;
	var _chunks = [[],[]];
	var _grid_pos = 0;
		
	for (_cy = -mesh_radius; _cy <= mesh_radius; _cy += GRID) {
		_wy = py+_cy;
		_ky = string(_wy);
		for (_cx = -mesh_radius; _cx <= mesh_radius; _cx += GRID) {
				
			// point inside sphere
			if (_cx*_cx + _cy*_cy <= mesh_radius*mesh_radius) {
				_wx = px+_cx;
				_kx = string(_wx);
				_key = _kx+"/"+_ky;
					
				_chunk = variable_struct_get(global.world_chunks, _key)
				if (_chunk != undefined) {
					// run chunk step funcion if not builded nor updated
					if (!_chunk.builded || !_chunk.updated) {
						_dist = point_distance(
							// from
							_chunk.chunk_x+8, 
							_chunk.chunk_y+8, 
							// to
							obj_player.x/GRID, 
							obj_player.y/GRID)
						array_push(_chunks[0], _key)
						array_push(_chunks[1], _dist)
					}
				}
			}
		}		
	}
	
	_key = "";
	_dist = 9999;
	
	// sort for the closest chunk
	for(var i = 0, n = array_length(_chunks[0]); i < n; i++) {
		if(_chunks[1][i] <= _dist) {
			_key = _chunks[0][i]
			_dist = _chunks[1][i]
		}
	}

	if(_key != ""){ 
		global.world_chunks[$ _key].step()
	}	
	
	
}

///@ desc run the draw method for every chunk in the radius
world_chunk_render = function() {
	var _kx, _ky	
	var _wx, _wy;
	var _cx, _cy;
	var _key;
	var _chunk;
	
	for (_cy = -render_radius; _cy <= render_radius; _cy += GRID) {
		_wy = py+_cy
		_ky = string(_wy)
		for (_cx = -render_radius; _cx <= render_radius; _cx += GRID) {				
				
			// point inside sphere
			if (_cx*_cx + _cy*_cy <= mesh_radius*mesh_radius) {
				_wx = px+_cx
				_kx = string(_wx)
				_key = _kx+"/"+_ky;
					
				_chunk = variable_struct_get(global.world_chunks, _key)
				if (_chunk != undefined) {
					_chunk.draw()
				}
			}
		}
	}		
}


step = function() {
	// Get player position in chunk format
	var _px = obj_player.x
	var _py = obj_player.y
	
	px = ((_px - _px mod (GRID*CHUNK_XLEN))/GRID) - GRID * (_px < 0)
	py = ((_py - _py mod (GRID*CHUNK_YLEN))/GRID) - GRID * (_py < 0)	
	

	// Run the world methods (data and mesh creation)	
	world_chunk_create()
	world_chunk_step()
}

draw = function() {
	
	shader_set(shd_block_render)
	var _time = shader_get_uniform(shd_block_render, "u_time")
	shader_set_uniform_f(_time, current_time/1000)	

	world_chunk_render()
	
	shader_reset()
}


#endregion
//====================================================================
/*


//*,,*,,,,*,*,,,*,,,,*,*,,,,**,*,,,,**,***,,,,*,,,,,,,*,,,,*,*,,,,,*,*,,**,,*,*,*,*,,*,,,,,,*,@@((((((((&@@@@@%,,*,,*,*,**,,*,,*,*,,*,*,,,****,**,**,,,*,*,*,*,*,,*,*,,*,,**
//.............,...,.,...,,..,.....,......,.................,.,.....,..,.........,..........(@&//////////(@@@@@@@%...............,......,..,..........,..,....,,....,.......
//......,.....,..........................,...................,..,.......,....,....,.,.,....&@%/////////////@@@@@@@@@,...,......,.....,,...,.....,....,...............,.,....
//......,..........................,...,...,,..,.,.................,,..,.........,,.....,.@@&///////////////@@@@@@@@@@.......,.,.....,..........................,.,...,....,
//..............................................,......,......,.,........,.,.,....,......&@@////////#(((%(///@@@@@@@@@@(............,,..........,.,...,......,.,............
//.......................,.....................,..,.....,...,,..........,/#%%#((((((((((#@@%////////#(((((((%/@@@@@@@@@@&.,.......,,,..,.....,.............................,
//......................./@@@@@@@@@@@@@@@@@@@@@@&/.........,.,/%#(((((((((((((((((((((((#@@/((///////#(((((((((@@@@@@@@@@&........,...,,.......,,....,..,,.........,........
//........,.............,@@@/////&@@@@@@@@@@@@@@@@@@@#../%((((((((((((((((((((((((((((((((((((((((#%/#(((((((((#@@@@@@@@@@#..,....,....,.......,...............,..,.........
//......................*@@(/////////&@@@@@@@@@@@@@@@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((&@@@@@@@@@@...............,.,...,...........................
//....................../@@/////////////#@@@@@@@@@@@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@/..,.......,.......,..........,,..,......,,...,..
//......................,@@/////////////////&@@@@@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((&@@@@@&#((((#..................................,....,......
//.......................&@(/////////%(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((#/............,.......................,....,.
//........................@@///////////(&(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((%......................,,,...........,,...
//.........................@@////////(#(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((%........,.......,...........,.,.......,
//..........................@@#////%((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((#................................,....
//...........................#@@/(#((((((((((((((((((((((((((((((((((((((((((((((((((((((##((((((((((((((((((((((((((((((((((((((((((((((..........,........................
//.............................@%(((((((((((((((((((((((((((((((((((((((((((((((((((((((#//#(((((((((((((((((((((((((((((((((((((((((((((#*.................................
//............................/(((((((((((((((((((((((((%(((((((((((((((((((((((((((((((%////%(((((((((((((((((((((((((((((((((((((((((((((#,...............................
//...........................#(((((((((((((((((((((((((((#(((((((((((((((((((((((((((((((//////%((((((((((((((((((((((((((((((((((((((((((((((#.............................
//..........................%(((((((((((((((((((((((((((%#(((((((((((((((((((((((((((((%#%#//////%(((((((((((((%(((((((((((((((((((((((((((((((((##/**//*...................
//.........................%((((((((((((((((((((((((((%///%((((((((((((((((((((((((((((#////////////%(((((((((((#((((((((%((((((((((((((((((((((((((((%.....................
//........................#(((((((((((((((((((((((((#////(#%((((((((((((((((((((((((((%////////////////%((((((((%(((((((%(((((((((((((((((((#((((((%&&......................
//.......................*((((((((((((((((((((((((#(///%(#&#(((((((((((((((((((((((((((//////#%%%#/////////(%(((#((((((#(((((((((((((((((((((&((#&&&&*%#....................
//.......................%(((((((((((((((((((((((%///%//////(((((((((((((((((((((((((%*#@&&@%*.  *%@@&///////////%((((%(((((((((((((((((((((((&&&&&&&&/.....................
//......................*((((((((((((((((((((((%/////////////(((((((((((((((((((((((#&&&, ..........  *@(////////((((#(((((((((((((((((((((((((&&&&&&%......................
//......................*(((((((((((((((((((((#////////////////%(((((((((((((((#((((&&& ...........%####%@%*//////%(#((((((((((((((((((((((((((%&&&&&,......................
//.......................#((((((((((((((((((%/////////#@&&&&&&&&&&(((((((((((((&&((&&&# ......... /#######&&@//////%((((((((((((((((((((((((((((&&&&& ......................
//........................*((((((((((((((((%///////#@#  ...... &&&&&%((((((((((&&&&&&&( ......... (###(..##@&&&&&#(((((((((((((((((((((((((((((((&&&( ......................
//..........................#(((((((((((((#///////& ..... ,%##%*(&&&&&&#((((((#&&&&&&&# .........    ##..(#@&&&&&&#((((((((((((((((((((((((((((((&&& .......................
//...........................#%((((((((((%///////( ..... (#######&&&&&&&&&%(((%&&&&&&&&............%#(////(@@&&&&#(((((((((((((((((((((((((((((((#& ........................
//...........................#((#%((((((((//////%,...... (####..,#&&&&&&&&&&&&&&&&&&&&&& ..........,#(////&&&&&&&((((((((((((((((((((((((((((((((#,.........................
//......................... %((((((##((((%//////@* .......%###/../&&&&&&&&&&&&&&&&&&&&&&% ...........%///&&&&&&&(((((((((((((((((((((((((((((((((#,.........................
//.........................*(((((((((((%((%////&&% ......  ,##/////&&&&&&&&&&&&&&&&&&&&&&&%. ......  /&&&&&&&&&((((((((((((((((((((((((((((((((((#,.........................
//........................ %((((((((((((((%&/%&&&@, ...... .%#////(&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&/%((((((((((((((((((((((((((((((((((#..........................
//......................../(((((((((((((((((##&&&&@* ....... ,%(/%#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&///%@((((((((((((((((((&(((((((((((((((#..........................
//........................%(((((((((((((((((&(/%&&&&%. ........  &&&&&&&&&&#////////////////////////(////////@@@(((((((((((((&@@@%((((((((((((@@%...........................
//.......................,((((((((((((((((((&&///%&&&&&&&&&&&&&&&&&&&&&/////////////////////////////////////%@@@#(((((((((&@@@@@@((((((((((&@@@%............................
//.......................((((((((((((((((((&&&&/////%&&&&&&&&&&&&&&&//////#%////////////////////////////////@@@@@((((((#@@@@@@@@@(((((((#@@@@@#.............................
//.......................%(((((((((((((((((&&&&/////////&&&&&&&&%//////////////////////////////////////////(@@@@@&((((@@@@@@@@@@&(((((@@@@@@@*..............................
//.......................##(((((((((((((((%&&&&&///////////////////////////////////////////////////////////@@@@@@@#(%@@@@@@@@@@@#((&@@@@@@@@................................
//......................*&@(((((((((((((@@&&&&&&%//////////////////////////////////////////////////////////@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@%.................................
//......................(@@@%(((((((((@@@@&&&&&&&%////////////////////////////////////////////////////////(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,..................................
//..................... #@@@@&((((((&@@@@&&&&&&&&&&///////////////////////////////////////////////////////#@@@@@@@@@@@@@@@@@@@@@@@@@@@@& ...................................
//..................... %@@@@@@&((#@@@@@@&&&&&&&&&&&&///////////////////////////(#(/(/////////////////////&@@@@@@@@@@@@@@@@@@@@@@@@@@@,.....................................
//..................... %@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&//////////////////////////////////////////////////@@@@@@@@@@@@@@@@@@@@@@@@@@( ......................................
//..................... %@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&//////////////////////////////////////////###(@@@@@@@@@@@@@@@@@@@@@@@@& ........................................
//......................#@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&#///////////////////////////////(&#((((((@@@@@@@@@@@@&,..@@@@@@@...................,,,.,,,.,,,.,,,..,,..,,.
//......................#@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&%&&@%(//////////////////*&#############@@@@@@@@/  ......@@@@( ...................,,..,,..,,,..,,..,,..,,.
//......................*@@@@@%,@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&(. ...... ##%/////////(&/(##############@@@&#########%#.. @& ......................,...,...,,.,,,..,,..,,.
//.......................@@@@@  &@@@@@@&&&&&&&&&&&&&. &&%%&&&*  ....... ,%%%%&((#((##((#(%*%##############(#################,.......................,,..,,..,,,.,,...,,..,,.
//...................... @@@@,...@@@@@@&&&&&&&&&&& ....   ....... ./&%%%#%%%%%%(#((((((((#*%################################........................,............,,..,,.....
//.......................(@@@ ...*@@@@@&&&&&&&&% ........  *%%####%%%%%%%%%%%%%%((((((#(#/*&###############################%............................,....,...,,..,,.....
//....................... &@& ....,@@@@&&&&&&, ....... @#(##############%%%%%%#%((((((((%/*&###############################% .........................................,.....
//........................ &% ..... %@@&&&# ..........&@(###############%%%%%%%%&/(###((%**&###############################(............................... .........., ....
//....................................   ........... %*################%%%%%%%%%%(/////(%**%###############################.................................... ....... ,*..
//.................................................. ///###############%%%%%%%%%#&//////(/*###############################* ........................... ... ... ....**,*****
//................................................... #*%#############%%%%%%%%%%%%/////////(############################, ........................................**********
//    ............................................... */(#(###########%%%%%%#%%#//(//////(//#############%%%%%%%%%%%%%%##%* ............................... ... ,***********
//...................................................  #*%###########%%%%&%&#////#///////%/*%#########%%%%%%%%%%%&,.%#%( /%(#%/  ...................... ... ... .*********/*
//............................................ .....    #*%##########%%%@&&&/////////////(/*########%%%%%%%&#(######%(.,%#%/.%#(#%,  .......................... .*******///*
//                      . ................             . (*%########%%%&&&&(//////////////%*/%#####%%&%###################.,%#&,*%###%*...,....., ..... ...***////**********
//                                                     *%#*%########%*#&&&&////////////////(*&###%##########################%/.###/.*%#(#%,..,..... ... ***,**///***********
//                                                  #####((#######(%,,&&&&&///////////////%*%####&###############################./%#(..###(#(....  .,* *****///////********
//........ .............. .                       %(#####*%#######*,,*&&&&&(/////////////#*%########%#############################%*.(#%..,%###%,. .,*************/*//******
//...... ......  .. ..  ........                 &#####%*%#####(%,,,,(&&&&&&#////////(&&(*%##########(%##############################*.*#%..*##(#, ,**************/////////*
//                                              .#(%##%*(######*,,,,,/&&&&&&&&&&&&&&&&&(*%###############&###########################(%..%#/.(###%...***************///////(
//                                              ##&###(*%(###%,,,,,,,*&&&&&&&&&&&&&&&&/*%###################%(########################((..%#*.%(##%/*(/(/***********///////(
//                                              %%###%*%(###*,,,,,,,,,&&&&&&&&&&&&&&&/*#######################%###%#####################*..%#,.%###%((((((//****************
//                                             *&((#%*(####,,,,,,,,,,,,(&&&&&&&&&&(,/*(##########################&%#####################%..,#%.,#(##((/********************(

