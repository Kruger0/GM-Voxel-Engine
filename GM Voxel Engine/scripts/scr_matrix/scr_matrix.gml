
#macro MATRIX_DEFAULT matrix_build_identity()

function matrix_build_modify(x, y, z, xrot, yrot, zrot, xscal, yscal, zscal) {
	var m_t = matrix_build(x, y, z, 0, 0, 0, 1, 1, 1)
	var m_r = matrix_build(0, 0, 0, xrot, yrot, zrot, 1, 1, 1)
	var m_s = matrix_build(0, 0, 0, 0, 0, 0, xscal, yscal, zscal)
	
	var m_rs  = matrix_multiply(m_s, m_r)
	var m_trs = matrix_multiply(m_rs, m_t)
	
	return m_trs;
}