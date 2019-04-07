use <MCAD/involute_gears.scad>

gear_thick = 13.8;
hub_thick = gear_thick + 16;
main_d = 60;
ext_d = 166;
washer_d = 25;
border_h = 16;
border_w = 2;
plate_h = 5;

inside_hole_d = 12;

mc = 0.1;
grow = 1.04;
$fn = 100;

module wheel_gear() {
    gear(circular_pitch=400, 
         pressure_angle=20,
         gear_thickness=gear_thick,
         rim_thickness=gear_thick,
         hub_thickness=hub_thick,
         hub_diameter=main_d,
         number_of_teeth=40,
         bore_diameter=inside_hole_d*grow);
}

module pulley_half() {
    cylinder(h=1, d=main_d);
    translate([0, 0, 1])
        cylinder(h=2.8, d1=main_d, d2=45);
    translate([0, 0, 2.8+1])
        cylinder(h=1.2, d=45);
}

module pulley() {
    difference() {
        union() {
            pulley_half();
            translate([0, 0, 10])
                rotate([180, 0, 0])
                    pulley_half();
        }
        translate([0, 0, -mc/2])
            cylinder(h=10+mc, d=inside_hole_d*grow);
    }
}

module plate() {
    difference() {
        cylinder(h=plate_h, d=ext_d);
        translate([0, 0, -mc/2])
            cylinder(h=plate_h+mc, d=inside_hole_d*grow);
    }
}

module border() {
    difference() {
        cylinder(h=border_h, d=ext_d);
        translate([0, 0, -mc/2])
            cylinder(h=border_h+mc, d=ext_d-border_w);
    }
}

module washer_placement() {
    cylinder(h=4, d=washer_d*grow);
}

module wheel() {
    difference() {
        union() {
            border();
            translate([0, 0, -plate_h])
                plate();
            wheel_gear();
            translate([0, 0, hub_thick])
                pulley();
        }
        translate([0, 0, -plate_h-mc])
            washer_placement();
    }
}

//pulley();
wheel();
