

function chunk_get_block(_chunk_buffer, _x, _y, _z) {
	
	// Position out of bounds
	if ((_x >= CHUNK_XLEN) | (_y >= CHUNK_YLEN) | (_z >= CHUNK_ZLEN)) { return 0}
	if ((_x < 0) | (_y < 0) | (_z < 0)) { return 0 }
	
	// Read the buffer in three dimentions
	var _pos = (
	_x + 
	_y * CHUNK_XLEN + 
	_z * CHUNK_YLEN * CHUNK_ZLEN
	) * CHUNK_BYTE_LEN
	
	// Write the block id on the buffer
	
	//buffer_seek(_chunk_buffer, buffer_seek_start, _pos)
	//return buffer_read(_chunk_buffer, buffer_u8) 
	return buffer_peek(_chunk_buffer, _pos, buffer_u8)
}


function chunk_set_block(_chunk_buffer, _x, _y, _z, _block_id) {
	
	// Position out of bounds
	if ((_x >= CHUNK_XLEN) | (_y >= CHUNK_YLEN) | (_z >= CHUNK_ZLEN)) { return 0 }
	if ((_x < 0) | (_y < 0) | (_z < 0)) { return 0 }
	
	// Read the buffer in three dimentions
	var _pos = (
	_x + 
	_y * CHUNK_XLEN + 
	_z * CHUNK_YLEN * CHUNK_ZLEN
	) * CHUNK_BYTE_LEN
	
	// Write the block id on the buffer
	
	// Parece ter dado na mesma mas o poke é só uma funcao entao worth it
	
	//buffer_seek(_chunk_buffer, buffer_seek_start, _pos)
	//buffer_write(_chunk_buffer, buffer_u8, _block_id) 
	buffer_poke(_chunk_buffer, _pos, buffer_u8, _block_id)
}