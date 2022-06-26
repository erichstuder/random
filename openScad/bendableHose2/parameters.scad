wall_thickness = 2.5;

rod_diameter = 3.9;

pipe_innerDiameter = 20;
pipe_outterDiameter = pipe_innerDiameter + 2*wall_thickness;

// for a pentagon
// This is the difference between inner an outter radius.
connector_offset = pipe_outterDiameter/2 * (1 - cos(36));
