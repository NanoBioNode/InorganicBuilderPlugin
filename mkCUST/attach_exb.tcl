# Usage: vmd -dispdev text -e attach_exb.tcl -args funPdb subPdb AnchorAtomList AnchorAUList combineName parDir exbFile k x conFile
# Combine funPdb and subPdb, make psf file, extrabond file and constrain file
# Author: Chen-Yu Li <cli56@illinois.edu>
# 2015/11/2


proc attach_exb { funPdb subPdb anclist ancaulist combineName parDir exbFile k x conFile } {
set argc 10
set argv {}
lappend argv $funPdb
lappend argv $subPdb
lappend argv "noIndexFile"
lappend argv $combineName
lappend argv $parDir
lappend argv $exbFile
lappend argv $k
lappend argv $x
lappend argv $conFile

if {$argc != 10} {
    puts "Usage: vmd -dispdev text -e attach_exb.tcl -args funPdb subPdb indexFile combineName parDir exbFile k x conFile"
    puts "funPdb: The pdb file containing all the functional molecules."
    puts "subPdb: The pdb file containing the substrate."
    puts "indexFile: Column 0 = anchor atoms of functional molecules, Column 1 = surface attoms to connect.\
     Connections are defined row-respectively"
    puts "combineName: The prefix of the output psf and pdb"
    puts "parDir: The path to the directory containing all the parameter and topology files"
    puts "exbFile: The name of the extrabond file"
    puts "k: The spring constant"
    puts "x: The equilibrium distance of the spring"
    puts "conFile: The name of the constraint file"

    exit
}



# Get total atom number in funPdb
set id [mol new [lindex $argv 0]]
set funA [atomselect top all]
set funAtomNum [$funA num]
mol delete top
$funA delete
set id2 [mol new [lindex $argv 1]]
set allSet2 [atomselect top "not resname AU"]
set nonAUNum [$allSet2 num]
mol delete $id2
$allSet2 delete


# Unify segname in subPdb
set id [mol new [lindex $argv 1]]
set all [atomselect top all]
$all set segname S0
$all writepdb tmp.pdb
mol delete top
$all delete


# Combine funPdb and subPdb
set p0 [open [lindex $argv 0] r]
set p1 [open "tmp.pdb" r]
set out [open "combine.pdb" w]
while {[gets $p0 line] >= 0} {
    if {[lindex $line 0] == "ATOM"} { puts $out $line }
}
while {[gets $p1 line] >= 0} {
    if {[lindex $line 0] == "ATOM"} {
		 puts $out $line
		 if {[lindex $line 10] != 0} {
			lappend bau_list [expr [lindex $line 1] + $funAtomNum + $nonAUNum - [llength $ancaulist]-1]
		 }
	}
}
close $p0
close $p1
close $out


# Get fun - sub index

foreach ancval $anclist ancauval $ancaulist {
    lappend fun_list $ancval
    lappend sub_list [expr $ancauval + $funAtomNum + $nonAUNum]
    lappend bau_list [expr $ancauval + $funAtomNum + $nonAUNum - [llength $ancaulist]]
}

puts $fun_list
puts $sub_list


# Finalize the pdb for psfgen
set id [mol new combine.pdb]
set all [atomselect top all]
$all writepdb combine_reindex.pdb
mol delete top
file delete -force "combine.pdb"
$all delete


# Get information for later use
set id [mol new combine_reindex.pdb]
set all [atomselect top all]
set segnames [lsort -unique [$all get segname]]
$all delete
set fun_segname_list ""
set fun_resid_list ""
set fun_name_list ""
set sub_segname_list ""
set sub_resid_list ""
set sub_name_list ""
foreach i0 $fun_list i1 $sub_list {
	set fsl [atomselect top "index $i0"]
	set frl [atomselect top "index $i0"]
	set fnl [atomselect top "index $i0"]
	set ssl [atomselect top "index $i1"]
	set srl [atomselect top "index $i1"]
	set snl [atomselect top "index $i1"]
    lappend fun_segname_list [$fsl get segname]
    lappend fun_resid_list   [$frl get resid]
    lappend fun_name_list    [$fnl get name]
    lappend sub_segname_list [$ssl get segname]
    lappend sub_resid_list   [$srl get resid]
    lappend sub_name_list    [$snl get name]
    $fsl delete
    $frl delete
    $fnl delete
    $ssl delete
    $srl delete
    $snl delete
}


####################### psfgen #########################################


package require psfgen             ;# load psfgen
resetpsf                           ;# Destroys any previous attempts
psfcontext reset                   ;# Tosses out any previously declared topology files

# Add topology files
set parDir [file normalize [file join [lindex $argv 4] "topology"]]
set topFiles [exec ls {*}[glob -nocomplain $parDir/*.top]]
set topFiles [list {*}$topFiles {*}[exec ls {*}[glob -nocomplain $parDir/*.str]]]
set topFiles [list {*}$topFiles {*}[exec ls {*}[glob -nocomplain $parDir/*.rtf]]]

foreach top $topFiles {
   topology $top
}


foreach seg $segnames {
    set sel [atomselect $id "segname $seg"]
    set tmpPdb tmp.pdb
    $sel writepdb $tmpPdb

    segment $seg {
            first none
            last none
            pdb $tmpPdb
    }
    coordpdb $tmpPdb
    $sel delete

}

guesscoord ;# guess the coordinates of missing atoms
regenerate angles dihedrals ;# fixes problems with patching

writepdb setBetas.pdb
writepsf [lindex $argv 3].psf
set betas [mol new setBetas.pdb]
set betasel [atomselect $betas "index $bau_list"]
set betaful [atomselect $betas all]
$betasel set beta 1.1
$betaful writepdb [lindex $argv 3].pdb

mol delete $id
mol delete $betas
$betasel delete
$betaful delete
file delete -force "setBetas.pdb"
file delete -force "tmp.pdb"
mol delete top

####################### make extrabond file #########################################

mol new [lindex $argv 3].psf
mol addfile [lindex $argv 3].pdb

set k [lindex $argv 6]
set x [lindex $argv 7]

set out [open [lindex $argv 5] w]

foreach fun_seg $fun_segname_list fun_res $fun_resid_list fun_name $fun_name_list sub_seg $sub_segname_list sub_res $sub_resid_list sub_name $sub_name_list {
    set i0sel [atomselect top "segname $fun_seg and resid $fun_res and name $fun_name"]
    set i1sel [atomselect top "segname $sub_seg and resid $sub_res and name $sub_name"]
    set i0 [$i0sel get index]
    set i1 [$i1sel get index]

    puts $out "bond\t$i0\t$i1\t$k\t$x"
    $i0sel delete
    $i1sel delete

}
close $out


####################### make constrain file #########################################

set all [atomselect top all]

$all set beta 0
$all set occupancy 0

set sub [atomselect top "segname S0"]

$sub set beta 20
$sub set occupancy 20

$all writepdb [lindex $argv 8]

$all delete

}
