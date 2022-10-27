function vec2(_x = 0, _y = _x) constructor {
    x = _x;
    y = _y;
}

function vec3(_x = 0, _y = 0, _z = 0) : vec2(_x, _y) constructor {
    z = _z;
}

function vec4(_x = 0, _y = 0, _z = 0, _w = 0) : vec3(_x, _y, _z) constructor {
    w = _w;
}