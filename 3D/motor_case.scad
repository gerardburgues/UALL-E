MOTOR_CASE_THICKNESS = 3;

MOTOR_HEIGHT = 15;
MOTOR_WIDTH  = 20;
MOTOR_LENGTH = 27;

REDUCTION_HEIGHT = 20;
REDUCTION_WIDHT  = 20;
REDUCTION_LENGTH = 19;

PLATE_LENGHT = 210;
PLATE_WIDTH  = MOTOR_WIDTH + 15;

union() {
    rotate([0, 0, 180])
    translate([-REDUCTION_LENGTH, 0, 0])
    union() {
        motor();
        reduction();
    }
//    plate();
//
//    translate([PLATE_LENGHT-MOTOR_LENGTH-REDUCTION_LENGTH, 0, 0])
//    union() {
//        motor();
//        reduction();
//    }
}

module motor() {
    difference() {
        intersection() { // Case
            rotate([0, 90, 0])
            cylinder(MOTOR_LENGTH, d=MOTOR_WIDTH + (MOTOR_CASE_THICKNESS*2), center=true);
            cube([MOTOR_LENGTH, 26, 21.29], center=true);
        };
        intersection() { // Motor
            rotate([0, 90, 0])
            cylinder(MOTOR_LENGTH, d=MOTOR_WIDTH, center=true);
            cube([MOTOR_LENGTH, MOTOR_WIDTH, MOTOR_HEIGHT], center=true);
        };
    };
}

module plate() {
    translate([-MOTOR_LENGTH/2, -(MOTOR_WIDTH+15)/2, (MOTOR_HEIGHT+MOTOR_CASE_THICKNESS)/2+3/2])
    cube([PLATE_LENGHT, PLATE_WIDTH, 2.5]);
}

module reduction() {
    translate([REDUCTION_LENGTH/2 + MOTOR_LENGTH/2, 0, 0])
    difference() {
        // Case
        rotate([0, 90, 0])
        cylinder(REDUCTION_LENGTH, d=MOTOR_WIDTH + (MOTOR_CASE_THICKNESS*2), center=true);
        // Reduction
        intersection() {
            rotate([0, 90, 0])
            cylinder(REDUCTION_LENGTH, d=MOTOR_WIDTH, center=true);
        };
    };
}