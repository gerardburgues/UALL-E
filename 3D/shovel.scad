_wall_strength = 2.5;
_bottom_strength = 3.5;

_width = 180;
_blade_length = 20;
_sieve_length = 130;
_sieve_strain = 5;
_sieve_grid_width = 1;
_sieve_edge_length = 0;
_sieve_edge_height = 0;
_grooves_approx_width = 10;
_grooves_depth=0;
_grooves_distance=1.5;
_blade_edge_length = 20;
_wall_height = 70;
_wall_cut = 50;
_rounding = 15;



_grooves_number=floor(_width/_grooves_approx_width);
_grooves_width = (_width-2*_wall_strength-(_grooves_number-1)*_grooves_distance)/_grooves_number;
_sieve_holes_xpane = floor(_width / _sieve_strain);
_sieve_holes_ypane = floor(_sieve_length / _sieve_strain);
_sieve_hole_width = (_width-2*_wall_strength-(_sieve_holes_xpane-1)*_sieve_grid_width)/_sieve_holes_xpane;
_sieve_hole_length = (_sieve_length-2*_wall_strength-(_sieve_holes_ypane-1)*_sieve_grid_width)/_sieve_holes_ypane;





// Slot for mounting the handle
_slot_height = 40;
_slot_width = 26;
_slot_depth = 3;
_slot_claw_width = 3;
_slot_claw_depth = 3;
_slot_top_height = 1.5;
_slot_top_prism_depth = 6;
_slot_top_prism_height = 10.4;

blade();
translate([0,_blade_length,0]) sieve();
translate([0,_blade_length+_sieve_length,0]) slot();
wall();


                
                
module slot(){
    w_prism=(_width-2*_rounding-_slot_width)/2;
    translate([_width-_rounding,0,_wall_height]) 
        rotate([0,90,90]) 
            prism(_wall_height,w_prism,_slot_depth+_slot_claw_depth); 
    translate([_rounding,0,0]) 
        rotate([0,270,270]) 
            prism(_wall_height,w_prism,_slot_depth+_slot_claw_depth); 
    translate([_rounding+w_prism,0,0]) 
        union(){
            difference() {
                cube(size=[_slot_width,_slot_depth+_slot_claw_depth,_wall_height]);  
                cube(size=[_slot_width,_slot_depth,_slot_height]); 
                translate([_slot_claw_width,_slot_claw_depth,0]) 
                    cube(size=[_slot_width-2*_slot_claw_width,_slot_claw_depth,_slot_height]);    
            }
            translate([0,0,_slot_height-_slot_top_height]) 
                cube(size=[_slot_width,_slot_depth+_slot_claw_depth,_slot_top_height]);
            translate([0,_slot_top_prism_depth,_slot_height-_slot_top_height]) 
                rotate([180,0,0]) 
                    prism(_slot_width,_slot_top_prism_depth,_slot_top_prism_height);
        }
}
module wall(){
    l=_blade_length+_sieve_length;
    difference(){
        linear_extrude(height=_wall_height)
        difference() {
            rsquare(_width,l,_rounding,true,true,false,false);
            offset(delta=-_wall_strength) rsquare(_width,l,_rounding,true,true,false,false);
            square(size=[_width,_blade_edge_length]);
        }
        translate([0,_blade_edge_length+_wall_cut,_wall_height+_bottom_strength]) rotate([180,0,0]) prism(_width,_wall_cut,_wall_height);
    }
}
module blade() {
    prism(_width,_blade_edge_length,_bottom_strength);
    difference() {
        translate([0,_blade_edge_length,0])cube(size=[_width,_blade_length-_blade_edge_length,_bottom_strength]);
        for(i=[0:1:_grooves_number-1]) {
            translate([_wall_strength+i*(_grooves_width+_grooves_distance),_blade_edge_length,_bottom_strength-_grooves_depth])
            cube(size=[_grooves_width,_blade_length,_grooves_depth]);
        }
    }
    translate([0,_blade_length-_sieve_edge_length,0]) prism(_width,_sieve_edge_length,_bottom_strength+_sieve_edge_height);
}
module sieve() {
    linear_extrude(height=_bottom_strength)
    union() {
        difference() {
            rsquare(_width,_sieve_length,_rounding,true,true,false,false);
            offset(delta=-_wall_strength) rsquare(_width,_sieve_length,_rounding,true,true,false,false);
        }
        difference() {
            rsquare(_width,_sieve_length,_rounding,true,true,false,false);
            for(i=[0:1:_sieve_holes_xpane-1]) {
                for(j=[0:1:_sieve_holes_ypane-1]){
                    translate([_wall_strength+i*(_sieve_hole_width+_sieve_grid_width),
                               _wall_strength+j*(_sieve_hole_length+_sieve_grid_width),
                               0]) 
                        square(size=[_sieve_hole_width,_sieve_hole_length]);
                }
            }
        }
    }
}
module rsquare(w,l,rounding,r_nw=true,r_ne=true,r_sw=true,r_se=true) {
        translate([rounding,rounding,0])
        minkowski(){
            square(size=[w-2*rounding,l-2*rounding]);
            circle(r=rounding, $fn=100);
        }
        if(r_nw==false) {translate([0,l-rounding,0]) square(rounding);}
        if(r_ne==false) {translate([w-rounding,l-rounding,0]) square(rounding);}
        if(r_sw==false) {translate([0,0,0]) square(rounding);}
        if(r_se==false) {translate([w-rounding,0,0]) square(rounding);}
}
module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}