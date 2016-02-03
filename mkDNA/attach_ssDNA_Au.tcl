# Usage: vmd -dispdev text -e attach_ssDNA_Au.tcl -args ssDNAPDB goldPDB indexFile outputname 
# Attach ssDNA to gold
# Author: Chen-Yu Li <cli56@illinois.edu>
# 2014/12/22


proc attach_ssDNA_Au { dnaPDB goldPDB olist aulist outputname homePath} {
set argc 5
set argv {}
lappend argv $dnaPDB
lappend argv $goldPDB
lappend argv "noIndexFile"
lappend argv $outputname




if {$argc != 5} {
    puts "Usage: vmd -dispdev text -e attach_ssDNA_Au.tcl -args ssDNAPDB goldPDB indexFile outputname"
    exit
}

# Get total ssDNA atom number
set id [mol new [lindex $argv 0]]
set allSet [atomselect top all]
set ssDNAAtomNum [$allSet num]
mol delete top
$allSet delete


# Combine ssDNA and Au pdb
set p0 [open [lindex $argv 0] r]
set p1 [open [lindex $argv 1] r]
set out [open "tmp.pdb" w]
while {[gets $p0 line] > 0} {
    if {[lindex $line 0] == "ATOM"} { puts $out $line }
}
while {[gets $p1 line] > 0} {
    if {[lindex $line 0] == "ATOM"} {
		 puts $out $line
		 if {[lindex $line 10] == 1.10} {
			lappend bau_list [expr [lindex $line 1] + $ssDNAAtomNum - [llength $aulist]-1]
		 }
	}
}
close $p0
close $p1
close $out

# Get O - Au index

#tk_messageBox -icon error -message \
      "incoming olist is: $olist  ...   O's AuList is: $aulist" \
      -type ok

foreach oval $olist auval $aulist {
    lappend o_list $oval
    lappend au_list [expr $auval + $ssDNAAtomNum]
    lappend bau_list [expr $auval + $ssDNAAtomNum - [llength $aulist]]
}

puts $o_list
puts $au_list


#tk_messageBox -icon error -message \
      "outgoing Olist is: $o_list  ...   O's AuList is: $au_list" \
      -type ok

# Finalize the pdb for psfgen
set id [mol new tmp.pdb]
set all [atomselect top all]
set segnames [lsort -unique [$all get segname]]

# Correct Au name and resid
set AU [atomselect top "resname AU4 AU"]
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

set o_segname_list ""
set au_segname_list ""
set o_resid_list ""
set au_resid_list ""
foreach oIndex $o_list auIndex $au_list {

	
    set oInTop [atomselect top "index $oIndex"]
    set auInTop [atomselect top "index $auIndex"]
    set oresTop [atomselect top "index $oIndex"]
    set auresTop [atomselect top "index $auIndex"]    
	
    lappend o_segname_list [$oInTop get segname]
    lappend au_segname_list [$auInTop get segname]
    lappend o_resid_list [$oresTop get resid]
    lappend au_resid_list [$auresTop get resid]
    
    $oInTop delete
    $auInTop delete
    $oresTop delete
    $auresTop delete
}

puts $o_segname_list
puts $au_segname_list
puts $o_resid_list
puts $au_resid_list
file delete -force "tmp.pdb"



####################### psfgen #########################################


package require psfgen             ;# load psfgen
resetpsf                           ;# Destroys any previous attempts
psfcontext reset                   ;# Tosses out any previously declared topology files

#topology [file join $homePath mkDNA/top_all36_na_3S.rtf] ;# tells psfgen how atoms in a residue should be bound
#topology [file join $homePath mkDNA/toppar_fcc_metals_2010.str]

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
					first 5TER
					last 3S
					pdb $tmpPdb
			}
			foreach {patchSeg patchResId patchResName} [join [lsort -unique [$sel get {segname resid  resname}]]] {
					if {$patchResId == 1} {
							patch DEO5 $patchSeg:$patchResId
					} else {
							patch DEOX $patchSeg:$patchResId
					}
			
			}
			coordpdb $tmpPdb
		}
		$sel delete
}
foreach o_segname $o_segname_list o_resid $o_resid_list au_segname $au_segname_list au_resid $au_resid_list {

    patch 3SAU $o_segname:$o_resid $au_segname:$au_resid

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
