include <library/Round-Anything/polyround.scad>
// translate([0,70,0])import("../stl/end_effector.stl", convexity=3);

$fn=50;
minInternalBoreD=5.8;
bearingReliefD=8;
bearingReliefL=0.65;
bearingD=10.3;
bearingL=2.7;
shamferL=1.6;
shamferD=13;
bearingHousingD=15;
bearingHousingL=12;
bearingPositionR=25;

plateThickness=5;

smallHoleRadialL=-13;
smallHoleD=3;

main();

module main() {
  difference() {
    union() {
      intersection(){
        topDownProfilePart();
        shapeBase();
      }
    }
    bearingHousingNegative();
  }
}

module topDownProfilePart() {
  topDownProfileBase=[
    [-bearingHousingL,  bearingPositionR+bearingHousingD/2, 0],
    [bearingHousingL,   bearingPositionR+bearingHousingD/2, 0],
    [bearingHousingL,   7,                                  18],
  ];
  topDownProfile=flatternArray([
    for(triIndex=[0:2])
    translateRadiiPoints(topDownProfileBase, [0,0], 120*-triIndex)
  ]);
  linear_extrude(height=bearingHousingD*2, convexity=10){
    difference(){
      polygon(polyRound(topDownProfile,30));
      circle(d=19);
      for(triIndex=[0:2])rotate([0,0,triIndex*120])translate([0,smallHoleRadialL,0])circle(d=smallHoleD,$fn=30);
    }
  }
}

module shapeBase() {
  union()for(triIndex=[0:2])rotate([0,0,triIndex*120])
  translate([-bearingHousingL*2,0,0])rotate([0,90,0])
  linear_extrude(height=bearingHousingL*4, convexity=10)
  polygon(polyRound(translateRadiiPoints([
    [0,0,0],
    [bearingPositionR+bearingHousingD/2,    0,                bearingHousingD/2],
    [bearingPositionR+bearingHousingD/2,    bearingHousingD,  bearingHousingD/2],
    [bearingPositionR-bearingHousingD/2,    bearingHousingD,  bearingHousingD/2],
    [bearingPositionR-bearingHousingD/2,    plateThickness,   bearingHousingD/2-plateThickness],
    [0,plateThickness,0],

  ],[0,0],90),30));
}


module bearingHousingNegative() {
  for(triIndex=[0:2])rotate([0,0,triIndex*120])
  translate([0,bearingPositionR,bearingHousingD/2]){
    rotate([0,90,0])for(mirrorIndex=[0:1])
    mirror([0,0,mirrorIndex]){
      translate([-shamferD/2+sqrt(2.5*2.5*2),0,0])rotate([0,0,45])translate([0,0,bearingHousingL-bearingL-shamferL+10])cube([5,5,20],center=true);
      rotate_extrude(angle = 360, convexity = 2)
      polygon(polyRound(translateRadiiPoints([
        [-0.01,0,0],
        [bearingHousingL+0.04,                              0,                    0],
        [bearingHousingL+0.04,                              shamferD/2,           0],
        [bearingHousingL-shamferL,                          bearingD/2,           0],
        [bearingHousingL-shamferL-bearingL,                 bearingD/2,           0],
        [bearingHousingL-shamferL-bearingL,                 bearingReliefD/2,     0],
        [bearingHousingL-shamferL-bearingL-bearingReliefL,  bearingReliefD/2,     0],
        [bearingHousingL-shamferL-bearingL-bearingReliefL,  minInternalBoreD/2,   0],
        [-0.01,                                             minInternalBoreD/2,   0],
      ],[0,0],90),30));
    }

  }
}