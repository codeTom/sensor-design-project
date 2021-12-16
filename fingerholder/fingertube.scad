$fn=100;

//larger cylinder diameter
//slightly larger holes for diodes
//

length = 30;
width = 25;
depth = 15;
end_to_diodes = 10;


module diode_tube(angle, radius)
{
    rotate([angle, 0, 0])
        cylinder(r=radius, h=20);
}

rotate([180,0,0])
{
    difference()
    {
        cube([length,width,depth]);
        translate([0,width/2.0,0])rotate([0,90,0]) cylinder(r=9, h=length-5, $fn=100);
        translate([length-5-end_to_diodes,width/2-3,5])diode_tube(45, 5.85/2.0);
        translate([length-5-end_to_diodes,width/2+3,5])diode_tube(-45, 5.85/2.0);
    }
}