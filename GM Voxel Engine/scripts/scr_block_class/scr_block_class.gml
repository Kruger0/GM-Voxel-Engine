#macro GRID 16

function block(_name, _ftop, _fsou, _feas, _fnor, _fwes, _fbot, _opaque) constructor {
	name	= _name
	f_top	= _ftop
	f_sou	= _fsou
	f_eas	= _feas
	f_nor	= _fnor
	f_wes	= _fwes
	f_bot	= _fbot
	opaque	= true
}

enum BLOCK_ID {
	AIR,	
	GRASSDIRT,
	DIRT,
	STONE,
	COBBLESTONE,
	WOOD,
	LEAF,
	GRASS,
	BEDROCK,
	GLASS,
	BRICK,
	SNOW,
	SNOWDIRT,
	SAND,
	WOODPLANK,
}

global.block_data = [
			 // Name			// Faces			// Opaque
	new block("Air",			00, 00, 00, 00, 00, 00,	1),
	new block("Grass dirt",		00, 01, 01, 01, 01, 02,	1),
	new block("Dirt",			02, 02, 02, 02, 02, 02,	1),
	new block("Stone",			03, 03, 03, 03, 03, 03,	1),
	new block("Cobblestone",	04, 04, 04, 04, 04, 04,	1),
	new block("Wood",			06, 05, 05, 05, 05, 06,	1),
	new block("Leaf",			07, 07, 07, 07, 07, 07,	1),
	new block("Grass",			11, 11, 11, 11, 11, 11,	1),
	new block("Bedrock",		12, 12, 12, 12, 12, 12,	1),
	new block("Glass",			09, 09, 09, 09, 09, 09,	0),
	new block("Brick",			13, 13, 13, 13, 13, 13,	0),
	new block("Snow",			14, 14, 14, 14, 14, 14,	0),
	new block("Snow dirt",		14, 15, 15, 15, 15, 02,	0),
	new block("Sand",			08, 08, 08, 08, 08, 08,	0),
	new block("Woodplank",		21, 21, 21, 21, 21, 21,	0),
]



