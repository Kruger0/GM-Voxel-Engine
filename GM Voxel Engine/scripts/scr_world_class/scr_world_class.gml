

function world_get_chunk(_x, _y) {
	// Find the chunk in this position
	var _kx = ((_x - _x mod (GRID*CHUNK_XLEN))/GRID) - GRID * (_x < 0)
	var _ky = ((_y - _y mod (GRID*CHUNK_YLEN))/GRID) - GRID * (_y < 0)

	var _key = string(_kx)+"/"+string(_ky);
	var _chunk = variable_struct_get(global.world_chunks, _key)
	if (_chunk == undefined) {
		show_debug_message("Chunk at " + _key + " not found")
		return -1;
	} else {
		return _chunk;
	}
}


function world_get_block(_x, _y, _z) {
	
	var _chunk = world_get_chunk(_x, _y)
	
	// Find the block in the chunk
	var _bx = abs(_x div GRID) mod CHUNK_XLEN
	var _by = abs(_y div GRID) mod CHUNK_YLEN
	var _bz = floor(_z/GRID)
	
	// Negative number weird math
	_bx = (_x < 0 ? GRID - _bx-1 : _bx)
	_by = (_y < 0 ? GRID - _by-1 : _by)
	_bz = clamp(_bz, 0, CHUNK_ZLEN)
	
	var _block = chunk_get_block(_chunk.chunk_buffer, _bx, _by, _bz)
	
	return _block;
}


function world_set_block(_x, _y, _z, _block) {
	
	var _chunk = world_get_chunk(_x, _y)
	
	// Find the block in the chunk
	var _bx = abs(_x div GRID) mod CHUNK_XLEN
	var _by = abs(_y div GRID) mod CHUNK_YLEN
	var _bz = floor(_z/GRID)
	
	_bx = (_x < 0 ? GRID - _bx-1 : _bx)
	_by = (_y < 0 ? GRID - _by-1 : _by)
	_bz = clamp(_bz, 0, CHUNK_ZLEN)
	
	chunk_set_block(_chunk.chunk_buffer, _bx, _by, _bz, _block)
	
	// flag the chunk to be updated
	_chunk.updated = false
}

