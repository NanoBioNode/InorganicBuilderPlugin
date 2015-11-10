# Usage: vmd -dispdev text -e mod_pdb.tcl -args inPdb topFile outPdb 
# Modify input pdb based on the input topology file
# Author: Chen-Yu Li <cli56@illinois.edu>
# 2015/11/1
#

proc mod_pdb { inPdb topFile outPdb } {
set argc 4
set argv {}
lappend argv $inPdb
lappend argv $topFile
lappend argv $outPdb

if {$argc != 4} {
    puts "vmd -dispdev text -e mkNAMD.tcl -args inPdb topFile outPdb "
    puts "inPdb: The pdb file containing the functional group."
    puts "topFile: The topology/parameter file from CGenFF."
    puts "outPdb: The name of the output pdb file."

    exit
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
mol new ${inPdb}

set all [atomselect top all]

$all set resname $resName
$all set segname F0

foreach ind [$all get index] {
    set sel [atomselect top "index $ind"]
    $sel set name [lindex $atomName $ind]
}

$all writepdb ${outPdb}.pdb
# this is a fake psf simply for processing using the same flow as built-in structs
$all writepsf ${outPdb}.psf

mol delete top

$all delete

}
