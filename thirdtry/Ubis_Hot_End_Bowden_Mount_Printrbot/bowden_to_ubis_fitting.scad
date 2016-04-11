// Bowden conversion for Ubis Hot End
// Tim Deagan 6/2013
//--------------------------------------------------

//Ubis hot end model dimensions
// http://www.thingiverse.com/thing:103189

fudge = .05;

head_w = 15.93;
head_h = 40.26;
head_inner_w = 11.68;
head_top_h = 3.81;
head_top_taper= 1.52;
head_inner_h = 1.91;
head_bottom_taper=0.76;
head_bot_h = 32.26;
heater_w = 12.75;
heater_h = 22.86;
nozzle_w = 12.75;
nozzle_h = 10.92;
entry_cone_h = 3.81;
thru_hole = 3.47;

//------------------------------------

// distance of mounting screw holes from center
dia = 49;		

// general bracket dimensions
ext_x = 25;
ext_y = 65;
ext_z = 9.75;

//(pneufit) SPC-06-01 Pneumatic Push to Connect Fitting. 
// This fitting uses a British Standard Pipe Taper Thread R1/8". 
// Tap size is 8.4mm for this thread, but I'm 'self' tapping 
// with the thread itself into the plastic. 
// I'm using 9.45mm for the base and 9.15 for the tip (it tapers.) 
fitting_length= 7;
fitting_base_width = 9.45;
fitting_tip_width = 9.15;


height = head_h-head_bot_h+2;

six_32_hole = 3.5;
m4hole = 4.2;

spacer = 2;

$fn=100;

// UBIS Model (uncomment to check dimensions)
// translate([0,0,-nozzle_h-heater_h-head_bot_h+2]) Ubis();

difference(){

	//BASE
	union(){
		// FLAT BASE
		translate([-ext_x/2,-ext_y/2,0])
			cube([ext_x,ext_y,ext_z]);
		// RISER CONE
		#translate([0,0,ext_z]) 
			cylinder(r1=ext_x/2,r2=(fitting_base_width +8)/2, h=fitting_length+spacer+(height-ext_z));
	}

	
	//MOUNT HOLES
	#union(){
		// PNEUFIT THREAD
		translate([0,0,height+spacer]) 
			cylinder(fitting_length + .2,fitting_tip_width/2,fitting_base_width/2);
		// TAPER To PASSAGE
		translate([0,0,height]) 
			cylinder(h=spacer,r1=(head_w/2) + .5+ fudge,r2=fitting_tip_width/2);
		// UBIS
		translate([0,0,-1]) 
			cylinder(h=height+1,r=(head_w/2) +.5 + fudge);
		// SCREW HOLES
		translate([0,-dia/2,-1]) cylinder(ext_z+2,m4hole/2,m4hole/2); 
		translate([0,dia/2,-1]) cylinder(ext_z+2,m4hole/2,m4hole/2);
		// MOUNT HOLES
		translate([-(ext_x/2)-fudge,-(head_inner_w+six_32_hole)/2,head_bottom_taper+1.5+(six_32_hole/2) ]) rotate([0,90,0])
			cylinder(r=six_32_hole/2,h= ext_x + (fudge*2) );
		translate([-(ext_x/2)-fudge,(head_inner_w+six_32_hole)/2,head_bottom_taper+1.5+(six_32_hole/2) ]) rotate([0,90,0])
			cylinder(r=six_32_hole/2,h= ext_x + (fudge*2) );
	}

}


//==================================================
// Ubis model
//--------------------------------------------------

module Ubis(){

	union(){
		// HEAD
		translate([0,0,nozzle_h+heater_h]) head();
		
		// HEATER
		translate([0,0,nozzle_h]) heater();
		
		// NOZZLE
		translate([0,0,0]) nozzle();
	}
}

module head(){
	difference() {
		color("tan") 
		union(){
		 	cylinder (r=head_w/2, h=head_bot_h);
			translate([0,0,head_bot_h]) 
				cylinder (r1=head_w/2, r2=head_inner_w/2, h=head_bottom_taper);
			translate([0,0,head_bot_h+head_bottom_taper])  
				cylinder (r=head_inner_w/2, h=head_inner_h);
			translate([0,0,head_bot_h+head_bottom_taper+ head_inner_h]) 
				cylinder (r1=head_inner_w/2,r2=head_w/2, h=head_top_taper);
			translate([0,0,head_bot_h+head_bottom_taper+ head_inner_h+head_top_taper]) 
				cylinder (r=head_w/2, h=head_top_h);
		}
		translate([0,0,-fudge]) cylinder(r=thru_hole, h=head_h + fudge);
		 translate([0,0,head_h-entry_cone_h])		
			cylinder(r1=thru_hole, r2= thru_hole*1.5, h= entry_cone_h + fudge);
	}
}

module heater(){
	color("red") cylinder(r=heater_w/2,h=heater_h);
}

module nozzle(){
	color("gold") translate([0,0,nozzle_h/2])
		cylinder(r=nozzle_w/2,h=nozzle_h/2);
	color("gold") cylinder(r1=nozzle_w/8,r2=nozzle_w/2,h=nozzle_h/2);
}
