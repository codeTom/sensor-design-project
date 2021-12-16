include <arduino.scad>

$fn = 20;

//is this in inches? What is wrong with this person?
//Dimensions
materialThickness = 3.0;
standoffs = 6.0;

//Inside Box Dimensions
spaceBetweenParts = .1*25.4;
padding = .02*25.4;
width = 57;
height = 65;
tall= 24;

//Overhang
overhang=.12 * 25.4;

insideBottomHoles = [
    //Arduino Holes
    //too close to the edge now, overlaps with slot
    [1.5, 1.34*25.4 + .1*25.4 + .1*25.4-35, .6*25.4-5],
    [1.5, 1.34*25.4 + .1*25.4 + 1.995*25.4-35, .54*25.4-5],
    [1.5, 1.34*25.4 + .1*25.4 + .7*25.4-35, 2.6*25.4-5],
    [1.5, 1.34*25.4 + .1*25.4 + 1.795*25.4-35, 2.6*25.4-5],
];

insideTopHoles = [
  [42, 28.25, 36.5-14, 65]
];

panelCutouts = [
    //these are way too small
    //Power
    [1.34*25.4 + .1*25.4 + 1.63*25.4 -35-0.5, .12*25.4,10,14],
    
    //USB
    [1.34*25.4 + .1*25.4 + .4*25.4 -35-2.5,.12*25.4,15,14]    
];

panelHoles = [
];


projection(cut=true){
    //bottom
    difference(){
            group(){
                //Make Bottom
                translate(
                    [
                        (width+(materialThickness+overhang+padding)*2)/2,
                        (height+(materialThickness+overhang+padding)*2)/2,
                         0
                    ]){
                    roundedRect(
                        [
                            width + (materialThickness+overhang+padding)*2,
                            height + (materialThickness+overhang+padding)*2,
                            materialThickness
                        ], overhang /2);                        
                }
                
                //Make Top
                
                translate(
                    [
                        (width + (materialThickness + overhang + padding) * 2 + spaceBetweenParts) + (width+(materialThickness+overhang+padding)*2)/2,
                        (height+(materialThickness+overhang+padding)*2)/2,
                         0
                    ]){
                    roundedRect(
                        [
                            width + (materialThickness+overhang+padding)*2,
                            height + (materialThickness+overhang+padding)*2,
                            materialThickness
                        ], overhang /2);                        
                }
                
            }

            group(){
                //Cut Homes In Top
                translate(
                    [
                        (width + (materialThickness + overhang + padding) * 2 + spaceBetweenParts) +
                        overhang+materialThickness+padding, 
                        overhang+materialThickness+padding
                    ]
                ) {
                    for(hole = insideTopHoles){
                        translate([hole[1], hole[2]]) roundedRect([hole[0], hole[3], materialThickness], 3);
                    }
                    
                    translate([width/4, -padding -materialThickness]) 
                        cube([width/2, materialThickness, materialThickness]);
                    translate([width/4, +padding + height])
                        cube([width/2, materialThickness, materialThickness]);                    
                    
                    translate([-padding -materialThickness, height/4]) 
                        cube([materialThickness, height/2, materialThickness]);
                    translate([padding + width, height/4]) 
                        cube([materialThickness, height/2, materialThickness]);                    
                }
translate([81.3,3,0])  
rotate([0,0,-90])
difference()
{
  cube([5,5,materialThickness]);
  roundedRect([5,5,materialThickness], 2.4);
}

translate([133.6,3,0])  
rotate([0,0,180])
difference()
{
  cube([5,5,materialThickness]);
  roundedRect([5,5,materialThickness], 2.4);
}
                
                //Cut Holes In Bottom
                translate(
                    [
                        overhang+materialThickness+padding, 
                        overhang+materialThickness+padding
                    ]
                ){
                    for(hole = insideBottomHoles){
                        translate([hole[1], hole[2]]) cylinder(h=materialThickness, r1=hole[0], r2=hole[0]);
                    }
                    //translate([width/4, -padding -materialThickness]) 
                    //    cube([width/2, materialThickness, materialThickness]);
                    translate([width/4, +padding +height])
                        cube([width/2, materialThickness, materialThickness]);                    
                    
                    translate([-padding -materialThickness, height/4]) 
                        cube([materialThickness, height/2, materialThickness]);
                    translate([padding + width, height/4]) 
                        cube([materialThickness, height/2, materialThickness]);                 
                }
            }
        }
}

//Make Short Case Sides
     
    projection() translate([0, (height+(materialThickness+overhang+padding)*2) + spaceBetweenParts]){
        difference(){
            cube([width + (padding + materialThickness) * 2, tall + materialThickness*2, materialThickness]);
            group(){
                cube([padding+materialThickness+width/4, materialThickness,materialThickness]);
                translate([padding+materialThickness+(width/4)*3, 0]) cube([padding+materialThickness+width/4, materialThickness,materialThickness]);
                translate([0, materialThickness + tall]){
                    cube([padding+materialThickness+width/4, materialThickness,materialThickness]);
                    translate([padding+materialThickness+(width/4)*3, 0]) cube([padding+materialThickness+width/4, materialThickness,materialThickness]);
                }
                
                translate([0,materialThickness]){
                    cube([materialThickness, tall/4, materialThickness]);
                    translate([0,tall/4*3]) cube([materialThickness, tall/4, materialThickness]);
                }
                
                translate([padding*2+materialThickness+width,materialThickness+tall/4]){
                    
                    cube([materialThickness, tall/2, materialThickness]);
                }
                
                //Put cutouts and holes in panel...
                translate(
                        [
                            materialThickness + padding, 
                            materialThickness + standoffs
                        ]
                    ){
                    for(cutout = panelCutouts){                        
                        translate([cutout[0], cutout[1]])
                            cube(
                                [
                                    cutout[2],
                                    cutout[3],
                                    materialThickness
                                ]
                            );
                    }
                    
                    
                    for(hole = panelHoles){
                        translate([hole[0], hole[1]])
                            cylinder(h=materialThickness, r1=hole[2], r2=hole[2]);                        
                    }
                }
            }
        }
    }
    
    
    projection() translate([spaceBetweenParts + padding*2 + materialThickness*2 + width, (height+(materialThickness+overhang+padding)*2) + spaceBetweenParts]){
        difference(){
            cube([width + (padding + materialThickness) * 2, tall + materialThickness*2, materialThickness]);
            group(){
                cube([padding+materialThickness+width/4, materialThickness,materialThickness]);
                translate([padding+materialThickness+(width/4)*3, 0]) cube([padding+materialThickness+width/4, materialThickness,materialThickness]);
                translate([0, materialThickness + tall]){
                    cube([padding+materialThickness+width/4, materialThickness,materialThickness]);
                    translate([padding+materialThickness+(width/4)*3, 0]) cube([padding+materialThickness+width/4, materialThickness,materialThickness]);
                }
                
                translate([0,materialThickness]){
                    cube([materialThickness, tall/4, materialThickness]);
                    translate([0,tall/4*3]) cube([materialThickness, tall/4, materialThickness]);
                }
                
                translate([padding*2+materialThickness+width,materialThickness+tall/4]){
                    
                    cube([materialThickness, tall/2, materialThickness]);
                }
            }
        }
    }
    
    //Make Long Sides
        projection() translate([(width+(materialThickness+overhang+padding)*2 + spaceBetweenParts)*2, 0]){
        difference(){
            cube([tall + materialThickness*2, height + (padding + materialThickness) * 2, , materialThickness]);
            group(){
                cube([materialThickness, padding+materialThickness+height/4, materialThickness]);
                translate([0, padding+materialThickness+(height/4)*3])
                    cube(
                        [
                            materialThickness,
                            padding+materialThickness+height/4, 
                            materialThickness
                        ]
                    );
                translate([materialThickness + tall, 0]){
                    cube(
                        [                            
                            materialThickness,
                            padding+materialThickness+height/4, 
                            materialThickness
                        ]
                    );
                    translate([0, padding+materialThickness+(height/4)*3]) 
                        cube(
                            [
                                materialThickness,
                                padding+materialThickness+height/4, 
                                materialThickness
                            ]
                        );
                }
                
                translate([materialThickness, 0]){
                    cube(
                        [
                            tall/4, 
                            materialThickness, 
                            materialThickness
                        ]
                    );
                    
                    translate([tall/4*3, 0]) 
                        cube([tall/4, materialThickness, materialThickness]);
                }
                
                //translate([materialThickness+tall/4, padding*2+materialThickness+height]){
                    
                //    cube([tall/2, materialThickness, materialThickness]);
                //}
            }
        }
    }
    
    
    projection() translate([(width+(materialThickness+overhang+padding)*2 + spaceBetweenParts)*2 + spaceBetweenParts + tall + materialThickness*2, 0]){
        difference(){
            cube([tall + materialThickness*2, height + (padding + materialThickness) * 2, , materialThickness]);
            group(){
                cube([materialThickness, padding+materialThickness+height/4, materialThickness]);
                translate([0, padding+materialThickness+(height/4)*3])
                    cube(
                        [
                            materialThickness,
                            padding+materialThickness+height/4, 
                            materialThickness
                        ]
                    );
                translate([materialThickness + tall, 0]){
                    cube(
                        [                            
                            materialThickness,
                            padding+materialThickness+height/4, 
                            materialThickness
                        ]
                    );
                    translate([0, padding+materialThickness+(height/4)*3]) 
                        cube(
                            [
                                materialThickness,
                                padding+materialThickness+height/4, 
                                materialThickness
                            ]
                        );
                }
                
                translate([materialThickness, 0]){
                    //cube(
                    //    [
                    //        tall/4, 
                    //        materialThickness, 
                    //        materialThickness
                    //    ]
                    //);
                    
                   // translate([tall/4*3, 0]) 
                    //    cube([tall/4, materialThickness, materialThickness]);
                }
                
                translate([materialThickness+tall/4, padding*2+materialThickness+height]){
                    
                    cube([tall/2, materialThickness, materialThickness]);
                }
            }
        }
    }
    

// radius - radius of corners
module roundedRect(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];

	linear_extrude(height=z)
	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0])
		circle(r=radius);
	
		translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius/2), (y/2)-(radius/2), 0])
		circle(r=radius);
	}
}

translate([8,2,0]) arduino();