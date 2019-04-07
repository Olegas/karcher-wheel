use <MCAD/involute_gears.scad>

gear_thick = 13.8;

inside_hole_d = 12;

mc = 0.1;
$fn = 100;

module wheel() {
    difference() {
        translate([0, 0, -gear_thick/2])
            gear(circular_pitch=410, 
                 gear_thickness=gear_thick,
                 rim_thickness=gear_thick,
                 number_of_teeth=40,
                 clearance=0.3);
        cylinder(h=gear_thick+mc, d=inside_hole_d, center=true);
    }
}

wheel();