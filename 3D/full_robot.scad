thickness = 5;

box_length = 300 + thickness*2;
box_width  = 200 + thickness*2;
box_height = 150 + thickness*2;


// body
translate([0,0,81])
union() {
    import("lattice_cointaner.stl");

    rotate(90)
    translate([13, -155, -13])
    import("motors.stl");

    rotate([90, 90, 0])
    translate([13, 155, 0])
    import("motor.stl");

    rotate([-90, -90, 0])
    translate([-13, 155, box_width])
    import("motor.stl");

    scale([0.5, 0.5, 0.5])
    translate([box_length*2 + box_width, box_width/4, 0])
    rotate(90)
    import("lattice_cointaner.stl");

    scale([1.5, 1.5, 1.5])
    rotate([90,0,-90])
    translate([22, -19, -142])
    import("tracks.stl");

    scale([1.5, 1.5, 1.5])
    rotate([90,0,90])
    translate([162, -19, 64])
    import("tracks.stl");
    
    scale([1.5, 1.5, 1.5])
    rotate([0,0,90])
    translate([70, -45, 50])
    import("palav2-2.stl");
    
    scale([1.5, 1.5, 1.5])
    rotate([0,0,90])
    translate([70, -45, 50])
    import("soporte_servos.stl");
}

translate([-190, 180/2 + box_width/2, 0])
rotate([0, 0, -90])
import("shovel.stl");