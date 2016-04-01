# Usage: vmd -dispdev text -e attach_exb.tcl -args funPdb subPdb subPsf AnchorAtomList AnchorAUList combineName parDir exbFile k x conFile topoFile
# Combine funPdb and subPdb, make psf file, extrabond file and constrain file
# Author: Chen-Yu Li <cli56@illinois.edu>
# 2015/11/2


proc attach_exb { funPdb subPdb subPsf anclist ancaulist combineName parDir exbFile k x conFile topoFile} {
set argc 12
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
lappend argv $topoFile
lappend argv $subPsf

if {$argc != 12} {
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


set bau_list {}
# Get total atom number in funPdb
set id [mol new [lindex $argv 0]]
set funA [atomselect top all]
set funAtomNum [$funA num]
set funsegnames [lsort -unique [$funA get segname]]
mol delete top
$funA delete


# Unify segname in subPdb
set id [mol new [lindex $argv 1]]
set all [atomselect top all]
#$all set segname S0
set subsegnames [lsort -unique [$all get segname]]
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
		 if {[lindex $line 10] == 1.10 || [lindex $line 9] == 1.10 } {
			lappend bau_list [expr [lindex $line 1] + $funAtomNum - 1]
#			lappend bau_list [expr [lindex $line 1] + $funAtomNum\
			 - [expr [llength $ancaulist]*2] - 1]
		 }
	}
}
close $p0
close $p1
close $out


# Get C - Au index

#tk_messageBox -icon error -message \
      "incoming Clist is: $anclist  ...   C's AuList is: $ancaulist ... Beta: $bau_list" \
      -type ok


# Get fun - sub index

foreach ancval $anclist ancauval $ancaulist {
    lappend fun_list $ancval
    lappend sub_list [expr $ancauval + $funAtomNum]
#    lappend bau_list [expr $ancauval + $funAtomNum - [expr [llength $ancaulist]*2]]
}

puts $fun_list
puts $sub_list

#tk_messageBox -icon error -message \
      "incoming Clist is: $fun_list  ...   C's AuList is: $sub_list ... Beta: $bau_list" \
      -type ok


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
	set fl [atomselect top "index $i0"]
	set sl [atomselect top "index $i1"]

    lappend fun_segname_list [$fl get segname]
    lappend fun_resid_list   [$fl get resid]
    lappend fun_name_list    [$fl get name]
    lappend sub_segname_list [$sl get segname]
    lappend sub_resid_list   [$sl get resid]
    lappend sub_name_list    [$sl get name]
    $fl delete
    $sl delete
}

# Save the coordinates of all the "used atoms" since their indices will be shifted after guessing.
# Coordinates and atom Type will be used to re-calculate the correct index.
set fselect [atomselect top "index $fun_list"]
set sselect [atomselect top "index $sub_list"]
set fcoord [$fselect get {x y z}]
set scoord [$sselect get {x y z}]
$fselect delete
$sselect delete

if {$bau_list != {}} {
  set bselect [atomselect top "index $bau_list"]
  set bcoord [$bselect get {x y z}]
  $bselect delete
}



####################### psfgen #########################################


package require psfgen             ;# load psfgen
resetpsf                           ;# Destroys any previous attempts
psfcontext reset                   ;# Tosses out any previously declared topology files

# alias
# Here's for nucleics
foreach suff {"" 3 5} {
    pdbalias residue DA$suff ADE
    pdbalias residue DT$suff THY
    pdbalias residue DC$suff CYT
    pdbalias residue DG$suff GUA
    pdbalias residue A$suff ADE
    pdbalias residue T$suff THY
    pdbalias residue C$suff CYT
    pdbalias residue G$suff GUA
}
foreach bp { GUA CYT ADE THY URA } {
    pdbalias atom $bp "O5\*" O5'
    pdbalias atom $bp "C5\*" C5'
    pdbalias atom $bp "O4\*" O4'
    pdbalias atom $bp "C4\*" C4'
    pdbalias atom $bp "C3\*" C3'
    pdbalias atom $bp "O3\*" O3'
    pdbalias atom $bp "C2\*" C2'
    pdbalias atom $bp "O2\*" O2'
    pdbalias atom $bp "C1\*" C1'
    pdbalias atom $bp  OP1   O1P
    pdbalias atom $bp  OP2   O2P
}
pdbalias atom THY C7 C5M
# protein
pdbalias residue HIS HSE
pdbalias atom ILE CD1 CD
pdbalias atom SER HG HG1
# Heme aliases
pdbalias residue HEM HEME
pdbalias atom HEME "N A" NA
pdbalias atom HEME "N B" NB
pdbalias atom HEME "N C" NC
pdbalias atom HEME "N D" ND
# Water aliases
pdbalias residue HOH TIP3
pdbalias atom TIP3 O OH2
pdbalias atom TIP3 OW OH2
# Ion aliases    
pdbalias residue K POT
pdbalias atom POT K POT
pdbalias residue ICL CLA
pdbalias atom ICL CL CLA
pdbalias residue NA SOD
pdbalias atom SOD NA SOD
pdbalias residue CA CAL
pdbalias atom CAL CA CAL
# Else
pdbalias atom ATP C1* C1'
pdbalias atom ATP C2* C2'
pdbalias atom ATP C3* C3'
pdbalias atom ATP C4* C4'
pdbalias atom ATP C5* C5'
pdbalias atom ATP O2* O2'
pdbalias atom ATP O3* O3'
pdbalias atom ATP O4* O4'
pdbalias atom ATP O5* O5'



# Add topology files
set parDir [file normalize [file join [lindex $argv 4] "topology"]]
set topFiles [exec ls {*}[glob -nocomplain $parDir/*.top]]
set topFiles [list {*}$topFiles {*}[exec ls {*}[glob -nocomplain $parDir/*.str]]]
set topFiles [list {*}$topFiles {*}[exec ls {*}[glob -nocomplain $parDir/*.rtf]]]
#set topFiles [list {*}$topFiles {*}[exec ls {*}[glob -nocomplain $topoFile]]]

foreach top $topFiles {
   topology $top
}


foreach seg $funsegnames {
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

readpsf  $subPsf
coordpdb $subPdb

guesscoord ;# guess the coordinates of missing atoms
regenerate angles dihedrals ;# fixes problems with patching

writepdb setBetas.pdb
writepsf [lindex $argv 3].psf
set betas [mol new setBetas.pdb]

# Regenerate the "used atom" list in case of new guessed atoms appearing
set bau_list {}
set fun_list {}
set sub_list {}
if {[info exists bcoord]} {
	foreach batom $bcoord {
		set xval [lindex $batom 0]
		set yval [lindex $batom 1]
		set zval [lindex $batom 2]
	#	set typeval [lindex $batom 3]
	#	set sel [atomselect top "x=$xval and y=$yval and z=$zval and type $typeval"]
		set sel [atomselect top "x=$xval and y=$yval and z=$zval"]
		set bindex [$sel get index]
		lappend bau_list $bindex
		$sel delete
	}
}
foreach fatom $fcoord {
	set xval [lindex $fatom 0]
	set yval [lindex $fatom 1]
	set zval [lindex $fatom 2]
#	set typeval [lindex $batom 3]
#	set sel [atomselect top "x=$xval and y=$yval and z=$zval and type $typeval"]
	set sel [atomselect top "x=$xval and y=$yval and z=$zval"]
	set findex [$sel get index]
	lappend bau_list $findex
	lappend fun_list $findex
	$sel delete
}
foreach satom $scoord {
	set xval [lindex $satom 0]
	set yval [lindex $satom 1]
	set zval [lindex $satom 2]
#	set typeval [lindex $batom 3]
#	set sel [atomselect top "x=$xval and y=$yval and z=$zval and type $typeval"]
	set sel [atomselect top "x=$xval and y=$yval and z=$zval"]
	set sindex [$sel get index]
	lappend bau_list $sindex
	lappend sub_list $sindex
	$sel delete
}

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
#$all set occupancy 0

set sub [atomselect top "segname U0"]

$sub set beta 20
#$sub set occupancy 20

$all writepdb [lindex $argv 8]

$all delete
$sub delete
mol delete top
file delete -force "combine_reindex.pdb"
}
