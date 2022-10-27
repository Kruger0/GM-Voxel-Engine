function calculate_normals(_vbuff) {
	var _buffer = buffer_create_from_vertex_buffer(_vbuff, buffer_fixed, 1)

	for (var _i = 0; _i < buffer_get_size(_buffer); _i += 32 * 3) {	// Format size * triangle
		
		// Get position data of each triangle
		var _x1 = buffer_peek(_buffer, _i + 00, buffer_f32)
		var _y1 = buffer_peek(_buffer, _i + 04, buffer_f32)
		var _z1 = buffer_peek(_buffer, _i + 08, buffer_f32)
		
		var _x2 = buffer_peek(_buffer, _i + 32, buffer_f32)
		var _y2 = buffer_peek(_buffer, _i + 36, buffer_f32)
		var _z2 = buffer_peek(_buffer, _i + 40, buffer_f32)
		
		var _x3 = buffer_peek(_buffer, _i + 64, buffer_f32)
		var _y3 = buffer_peek(_buffer, _i + 68, buffer_f32)
		var _z3 = buffer_peek(_buffer, _i + 72, buffer_f32)
		
		// Calculate normals
		var _v1 = new Vector3(_x1, _y1, _z1)
		var _v2 = new Vector3(_x1, _y1, _z1)
		var _v3 = new Vector3(_x2, _y2, _z2)
		
		var _e1 = _v2.Sub(_v1)
		var _e2 = _v3.Sub(_v2)
		
		var _normal = _e1.Cross(_e2).Normalize();
		
		
		// Rewrite the buffer
		buffer_poke(_buffer, _i + 00+20, buffer_f32, _normal.x)
		buffer_poke(_buffer, _i + 04+20, buffer_f32, _normal.x)
		buffer_poke(_buffer, _i + 08+20, buffer_f32, _normal.x)

		buffer_poke(_buffer, _i + 32+20, buffer_f32, _normal.x)
		buffer_poke(_buffer, _i + 36+20, buffer_f32, _normal.x)
		buffer_poke(_buffer, _i + 40+20, buffer_f32, _normal.x)

		buffer_poke(_buffer, _i + 64+20, buffer_f32, _normal.x)
		buffer_poke(_buffer, _i + 68+20, buffer_f32, _normal.x)
		buffer_poke(_buffer, _i + 72+20, buffer_f32, _normal.x)
	}
	
	var _normalized_buffer = vertex_create_buffer_from_buffer(_buffer, V_FORMAT_BLOCK)
	
	buffer_delete(_vbuff)
	buffer_delete(_buffer)
	
	return _normalized_buffer;
}