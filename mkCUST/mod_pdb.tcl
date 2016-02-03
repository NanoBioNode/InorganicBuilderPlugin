# Usage: vmd -dispdev text -e mod_pdb.tcl -args inPdb topFile outPdb 
# Modify input pdb based on the input topology file
# Author: Chen-Yu Li <cli56@illinois.edu>
# 2015/11/1
#

proc mod_pdb { inPdb topFile outPdb csD} {
set argc 5
set argv {}
lappend argv $inPdb
lappend argv $topFile
lappend argv $outPdb
lappend argv $csD

if {$argc != 5} {
    puts "vmd -dispdev text -e mkNAMD.tcl -args inPdb topFile outPdb "
    puts "inPdb: The pdb file containing the functional group."
    puts "topFile: The topology/parameter file from CGenFF."
    puts "outPdb: The name of the output pdb file."

    exit
}

# orient the incoming molecule along x-axis [1,0,0]
set molsel [mol new ${inPdb}]

# move anchor to 0 0 0
set as [atomselect $molsel all]
set b [atomselect $molsel "index $csD"]
set bx [expr [$b get x]*-1]
set by [expr [$b get y]*-1]
set bz [expr [$b get z]*-1]
set M "$bx $by $bz"
$as moveby $M

# find avg vector direction from 0 0 0
proc lavg L {expr ([join $L +])/[llength $L].}
set xa [lavg [ $as get x ]]
set ya [lavg [ $as get y ]]
set za [lavg [ $as get z ]]
#graphics $molsel cylinder "0 0 0" "$xa $ya $za" radius 1

set vec1 [vecnorm "$xa $ya $za"]
set vec2 [vecnorm {1 0 0}]

# compute the angle and axis of rotation
set rotvec [veccross $vec1 $vec2]
set sine   [veclength $rotvec]
set cosine [vecdot $vec1 $vec2]
set angle [expr atan2($sine,$cosine)]

# return the rotation matrix and rotate the molecule
set ts [trans center "0 0 0" axis $rotvec $angle rad]
$as move $ts

set all1 [atomselect top all]
$as delete
$b delete

if {[lindex [split $topFile "."] end] == "str"} {
	
$all1 writepdb inPdb_temp.pdb
mol delete top
$all1 delete
	
} else {

# Using a CHARMM file instead of CGenFF so just quit from mod_pdb	
$all1 writepdb ${outPdb}.pdb
# this is a fake psf simply for processing using the same flow as built-in structs
$all1 writepsf ${outPdb}.psf
$all1 delete
mol delete top
return

}


# get resname and atom name from topology file
set top [open $topFile r]
set resName ""
set atomName ""
while {[gets $top line] >= 0} {
    if {[lindex $line 0] == "RESI"} { 
        set resName [lindex $line 1]
    }

    if {[lindex $line 0] == "ATOM"} { 
        lappend atomName [lindex $line 1]
    }
}
close $top


# correct functional group pdb
mol new inPdb_temp.pdb

set all [atomselect top all]

$all set resname $resName
$all set segname F0

foreach ind [$all get index] {
    set sel [atomselect top "index $ind"]
    $sel set name [lindex $atomName $ind]
    $sel delete
}

$all writepdb ${outPdb}.pdb
# this is a fake psf simply for processing using the same flow as built-in structs
$all writepsf ${outPdb}.psf

mol delete top

$all delete
file delete -force inPdb_temp.pdb
}
