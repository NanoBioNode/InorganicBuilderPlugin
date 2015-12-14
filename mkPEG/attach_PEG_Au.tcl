# Usage: vmd -dispdev text -e attach_PEG_Au.tcl -args pegPDB goldPDB indexFile outputname 
# Attach PEG to gold
# Author: Chen-Yu Li <cli56@illinois.edu>
# 2014/12/22





proc attach_PEG_Au { pegPDB goldPDB clist aulist outputname homePath} {
set argc 5
set argv {}
lappend argv $pegPDB
lappend argv $goldPDB
lappend argv "noIndexFile"
lappend argv $outputname


if {$argc != 5} {
    puts "Usage: vmd -dispdev text -e attach_PEG_Au.tcl -args pegPDB goldPDB indexFile outputname"
    exit
}

# Get total PEG atom number
set id [mol new [lindex $argv 0]]
set allSet [atomselect top all]
set pegAtomNum [$allSet num]
mol delete $id
$allSet delete
set id2 [mol new [lindex $argv 1]]
set allSet2 [atomselect top "not resname AU4"]
set nonAUNum [$allSet2 num]
mol delete $id2
$allSet2 delete

# Combine PEG and Au pdb
set p0 [open [lindex $argv 0] r]
set p1 [open [lindex $argv 1] r]
set out [open "tmp.pdb" w]
while {[gets $p0 line] > 0} {
    if {[lindex $line 0] == "ATOM"} { puts $out $line }
}
while {[gets $p1 line] > 0} {
    if {[lindex $line 0] == "ATOM"} {
		 puts $out $line
		 if {[lindex $line 10] != 0} {
			lappend bau_list [expr [lindex $line 1] + $pegAtomNum + $nonAUNum - [llength $aulist]-1]
		 }
	}
}
close $p0
close $p1
close $out

# Get C - Au index

#tk_messageBox -icon error -message \
      "incoming Clist is: $clist  ...   C's AuList is: $aulist" \
      -type ok


foreach cval $clist auval $aulist {
    lappend c_list $cval
    lappend au_list [expr $auval + $pegAtomNum + $nonAUNum]
    lappend bau_list [expr $auval + $pegAtomNum + $nonAUNum - [llength $aulist]]
}
puts $c_list
puts $au_list

#tk_messageBox -icon error -message \
      "outcoming Clist is: $c_list  ...   C's AuList is: $au_list" \
      -type ok

# Finalize the pdb for psfgen
set id [mol new tmp.pdb]
set all [atomselect top all]
set segnames [lsort -unique [$all get segname]]

# Correct Au name and resid
set AU [atomselect top "resname AU4"]
$AU set resname AU
$AU set name AU
set AU_n [$AU num]
set AU_index [$AU get index]
$AU delete
set count 1
set counte 0
foreach i $AU_index {
	if {[expr $count % 10000] == 0} {
		incr counte
		set count 1
		lappend segnames "U$counte"
	}
    set AU_m [atomselect top "resname AU and index $i"]
    $AU_m set resid [expr $count]
    $AU_m set segname "U$counte"
    incr count
    $AU_m delete
}

$all writepdb tmp_reindex.pdb
mol delete top
$all delete


set id [mol new tmp_reindex.pdb]

set c_segname_list ""
set au_segname_list ""
set c_resid_list ""
set au_resid_list ""
foreach cIndex $c_list auIndex $au_list {
	
	
    set cInTop [atomselect top "index $cIndex"]
    set auInTop [atomselect top "index $auIndex"]
    set cresTop [atomselect top "index $cIndex"]
    set auresTop [atomselect top "index $auIndex"]
	
    lappend c_segname_list [$cInTop get segname]
    lappend au_segname_list [$auInTop get segname]
    lappend c_resid_list [$cresTop get resid]
    lappend au_resid_list [$auresTop get resid]
    
    $cInTop delete
    $auInTop delete
    $cresTop delete
    $auresTop delete
}

puts $c_segname_list
puts $au_segname_list
puts $c_resid_list
puts $au_resid_list
file delete -force "tmp.pdb"



####################### psfgen #########################################


package require psfgen             ;# load psfgen
resetpsf                           ;# Destroys any previous attempts
psfcontext reset                   ;# Tosses out any previously declared topology files

#topology [file join $homePath mkPEG/top_all36_cgenff_PEGA.rtf] ;# tells psfgen how atoms in a residue should be bound
#topology [file join $homePath mkPEG/toppar_fcc_metals_2010.str]

set parDir [file normalize [file join $homePath "topology"]]
set topFiles [exec ls {*}[glob -nocomplain $parDir/*.top]]
set topFiles [list {*}$topFiles {*}[exec ls {*}[glob -nocomplain $parDir/*.str]]]
set topFiles [list {*}$topFiles {*}[exec ls {*}[glob -nocomplain $parDir/*.rtf]]]

foreach top $topFiles {
   topology $top
}

foreach seg $segnames {

		set founder 0
		set sel [atomselect $id "segname $seg"]
		set tmpPdb tmp.pdb
		$sel writepdb $tmpPdb
		for {set i 0} { $i <= $counte } { incr i } {
			if {$seg == "U$i"} {

				segment $seg {
						first none
						last none
						pdb $tmpPdb
				}
				coordpdb $tmpPdb
				set founder 1
				break
			}
		}

		if { $founder == 0 } {
			segment $seg {
					first HYD1
					last none
					pdb $tmpPdb
			}
			coordpdb $tmpPdb
		}
		$sel delete
}
foreach c_segname $c_segname_list c_resid $c_resid_list au_segname $au_segname_list au_resid $au_resid_list {

    patch PEGA $c_segname:$c_resid $au_segname:$au_resid

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
}
