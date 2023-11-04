// values for making smooth arcs
$fa = 2;
$fs = 0.25;

function inchesToMilliMeters(inches) = inches * 25.4;

number_of_holes = 2; // ** change this value for a different number of holes **
width = inchesToMilliMeters(2);
depth = inchesToMilliMeters(number_of_holes * 0.75);
height = inchesToMilliMeters(1/4);

hole_radius = inchesToMilliMeters(1/4) / 2;
groove_width = inchesToMilliMeters(1/8);
indent_hole_radius = inchesToMilliMeters(3/8) / 2;

module rounded_cube(size, r=0, center=false, $fn=20){
    translate([(center)?0:r, (center)?0:r, (center)?0:r])
    minkowski(){
        cube([size[0]-r*2, size[1]-r*2, size[2]-r*2], center=center);
        sphere(r, $fn=$fn);
    }
}

module rounded_corner_rect(size, center=false, r=1.5){
    x = size[0];
    y = size[1];
    z = size[2];
    translate([center?-(x/2-r):r, center?-(y/2-r):r, center?-(z/2):0]) {
        minkowski(){
            cube([x-2*r, y-2*r, z/2]);
            cylinder(r=r,h=z/2);
        }
    }
}

difference() {

    rounded_corner_rect(size=[width,depth,height], center=true, r=1);
    
    translate([width*-1/3,0,height*1/2]) {
        cube([width,depth*2,height], center=true);
    }
    
    for(i = [0:number_of_holes-1]) {
        offset = (depth-2*hole_radius*number_of_holes)/(2*number_of_holes);
        y = ((-depth/2) + (hole_radius)) + (depth/number_of_holes*i) + offset;
        translate([width*1/3,y,-height]) {

            cylinder(r=hole_radius,h=height*2);
            translate([0,0,height]) {
                cylinder(r=indent_hole_radius,h=height);
            }
            translate([0,-groove_width/2,0]) {
                cube([width,groove_width,height*2]);
            }
        }
    }
}