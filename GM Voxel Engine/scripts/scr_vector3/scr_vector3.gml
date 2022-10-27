
display_reset(8, false);
gpu_set_tex_mip_bias(0)
gpu_set_tex_mip_filter(tf_linear)
gpu_set_tex_mip_enable(mip_on)
//gpu_set_texfilter(false)

function Vector3(x, y, z) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    
    static Sub = function(val) {
        return new Vector3(self.x - val.x, self.y - val.y, self.z - val.z);
    };
    
    static Cross = function(val) {
        return new Vector3(self.y * val.z - val.y * self.z, self.z * val.x - val.z * self.x, self.x * val.y - val.x * self.y);
    };
    
    static Magnitude = function() {
        return point_distance_3d(0, 0, 0, self.x, self.y, self.z);
    };
    
    static Normalize = function() {
        var mag = self.Magnitude();
        return new Vector3(self.x / mag, self.y / mag, self.z / mag);
    };
}