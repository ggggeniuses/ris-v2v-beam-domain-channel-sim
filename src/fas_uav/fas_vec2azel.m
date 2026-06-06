function [az, el] = fas_vec2azel(v)
%FAS_VEC2AZEL Convert a Cartesian vector to azimuth/elevation angles.
az = atan2(v(2), v(1));
el = atan2(v(3), hypot(v(1), v(2)));
end
