use <MCAD/involute_gears.scad>

gear_thick = 13.8;
hub_thick = gear_thick + 16;
main_d = 60;
ext_d = 170;
washer_d = 25;
border_h = 16*1.2;
border_w = 0.4*4;
plate_h = 4;

inside_hole_d = 12;

pulley_screw_d = 3;
pulley_inside_d = 45;

mc = 0.1;
grow = 1.04;
$fn = 100;

module repeat_round(n, offset=0) {
    for(i=[1:n]) {
        rotate([0, 0, offset+360/n*i])
            children();
    }
}

module screw_hole(h) {
    translate([0, 0, h-3+mc])
        cylinder(h=3, d1=3, d2=6);
    cylinder(h=h+mc, d=3);
}

module wheel_gear() {
    difference() {
        gear(circular_pitch=400, 
             pressure_angle=20,
             gear_thickness=gear_thick,
             rim_thickness=gear_thick,
             hub_thickness=hub_thick,
             hub_diameter=main_d,
             number_of_teeth=40,
             bore_diameter=inside_hole_d*grow);
        repeat_round(4) {
            translate([0, main_d/2 + 6, -mc/2]) {
                screw_hole(gear_thick);
            }
        }        
    }
    /*
    difference() {
        translate([0, 0, -plate_h])
            cylinder(h=plate_h, d=washer_d*1.5);
        translate([0, 0, -plate_h-mc/2])
            washer_placement();
    }
    */
}

module pulley_half() {
    cylinder(h=1, d=main_d);
    translate([0, 0, 1])
        cylinder(h=2.8, d1=main_d, d2=pulley_inside_d);
    translate([0, 0, 2.8+1])
        cylinder(h=1.2, d=pulley_inside_d);
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
        repeat_round(4)
            translate([0, pulley_inside_d/4, -mc/2])
                screw_hole(10);
    }
}

module plate() {
    difference() {
        cylinder(h=plate_h, d=ext_d);
        translate([0, 0, -mc/2])
            cylinder(h=plate_h+mc, d=main_d*grow);
        repeat_round(4, offset=16)
            translate([0, main_d/2 + 6, -mc/2])
                cylinder(h=plate_h+mc, d=3);        
    }
}

module border() {
    n_enforce = 12;
    repeat_round(n_enforce)
        translate([(main_d*grow)/2, 0, 0])
            cube([ext_d/2-(main_d*grow)/2, border_w, border_h/2]);
    difference() {
        cylinder(h=border_h/2, d=ext_d/2+6);
        translate([0, 0, -mc/2])
            cylinder(h=border_h/2+mc, d=ext_d/2+6-border_w*2);
    }
    difference() {
        cylinder(h=border_h/2, d=ext_d*3/4+6);
        translate([0, 0, -mc/2])
            cylinder(h=border_h/2+mc, d=ext_d*3/4+6-border_w*2);
    }
    difference() {
        cylinder(h=border_h, d=ext_d);
        translate([0, 0, -mc/2])
            cylinder(h=border_h+mc, d=ext_d-border_w*2);
    }
}

module washer_placement() {
    cylinder(h=4+mc, d=washer_d*grow);
}

module wheel(base=true, gear=true, reduce_weight=true) {

    reducer_hole_d=23;

    if (base) {
        difference() {
            union() {
                translate([0, 0, -border_h/2])
                    border();
                translate([0, 0, -plate_h])
                    plate();
                if (reduce_weight) {
                    repeat_round(12)
                        translate([0, (ext_d*3/4+3)/2, -border_h/2])
                            cylinder(h=border_h/2, d=reducer_hole_d+border_w*2);
                }
            }
            if (reduce_weight) {
                repeat_round(12)
                    translate([0, (ext_d*3/4+3)/2, -border_h/2-mc/2])
                        cylinder(h=border_h+mc, d=reducer_hole_d);
            }
        }
    }
    if (gear) {
        rotate([0, 0, 16])
            wheel_gear();
        translate([0, 0, hub_thick])
            pulley();        
    }
}

//border();
//pulley();
wheel();
//wheel_gear();



