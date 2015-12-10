# Usage: vmd -dispdev text -e mkDNA.tcl -args numOfStrand numberOfNucleotide outputname seqFile
# Make ssDNA or dsDNA molecule with arbitrary length and sequence
# Author: Chen-Yu Li <cli56@illinois.edu>
# 2015/3/16

proc build_nt {numOfStrand template out numberOfNucleotide} {

    variable angle
    variable distance
    variable count

    set id [mol load pdb $template]
    set all [atomselect top all]
    $all moveby "0 0 [expr $count * $distance]"
    $all move [transaxis z [expr $count * $angle]]
    set sel1 [atomselect top "segname DS1"]
    $sel1 set resid [expr $count + 1]
    set sel2 [atomselect top "segname DS2"]
    $sel2 set resid [expr $numberOfNucleotide - $count]

    if {$numOfStrand == 1} {
        set sel [atomselect top "segname DS1"]
        $sel writepdb tmp.pdb
        $sel delete
    } else {
        $all writepdb tmp.pdb
    }

    $all delete
    $sel1 delete
    $sel2 delete
    mol delete $id
    set inStream [open tmp.pdb r]
    foreach line [split [read $inStream] \n] {

        if [string match [string range $line 0 3] "ATOM"] {
            puts $out $line
        }
    }
    close $inStream
    incr count
    return $count
}

proc mkDNA { numOfStrand numberOfNucleotide outputname homepath seqFileIn } {

    
    set argc 4
    set argv {}
    lappend argv $numOfStrand
    lappend argv $numberOfNucleotide
    lappend argv $outputname
    if {$seqFileIn != "Random"} {
    	lappend argv $seqFileIn
    	set argc 5
    }
    
    
    if {$argc != 4 && $argc != 5} {
        puts "Usage: vmd -dispdev text -e mkDNA.tcl -args numOfStrand numberOfNucleotide outputname seqFile"
        exit
    }
    
    
    set seq ""
    if {$argc == 5} {
    	lappend seqIn [lindex $argv 3]
        foreach line [split $seqIn ""] {
            lappend seq $line
        }
    } else {
        for {set i 1} {$i <= $numberOfNucleotide} {incr i} {
            lappend seq [expr int(floor(rand() * 4))]
        }
    }
    
    variable angle
    variable distance
    variable count
    set angle 34.3
    set distance  3.32
    set count 0
    
    set out [open build.pdb w]
    foreach nt $seq {
    
        switch -regexp $nt {
    
            [aA0] {build_nt $numOfStrand [file join $homepath mkDNA/AT.pdb] $out $numberOfNucleotide}
            [tT1] {build_nt $numOfStrand [file join $homepath mkDNA/TA.pdb] $out $numberOfNucleotide}
            [cC2] {build_nt $numOfStrand [file join $homepath mkDNA/CG.pdb] $out $numberOfNucleotide}
            [gG3] {build_nt $numOfStrand [file join $homepath mkDNA/GC.pdb] $out $numberOfNucleotide}
        }
    }
    
    close $out
    
    ## sort using the resid of DS2 in pdb
    set inStream [open build.pdb r]
    set out [open build_re.pdb w]
    foreach line [split [read $inStream] \n] {
    
        if {[string match [string range $line 72 75] "DS1 "]} {
            puts $out $line
        }
    }
    close $inStream
    for {set i 1} {$i <= $numberOfNucleotide} {incr i} {
        set inStream [open build.pdb r]
        foreach line [split [read $inStream] \n] {
    
            if {[regexp " $i " [string range $line 22 26]] && [string match [string range $line 72 75] "DS2 "]} {
                puts $out $line
            }
        }
        close $inStream
    }
    
    close $out
    
    set ie [mol new build_re.pdb]
    set all [atomselect top all]
    $all writepdb build_re_1.pdb
    $all delete
    mol delete $ie
    
    ####################### psfgen #########################################
    
    
    package require psfgen             ;# load psfgen
    resetpsf                           ;# Destroys any previous attempts
    psfcontext reset                   ;# Tosses out any previously declared topology files
    
    topology [file join $homepath mkDNA/top_all36_na_3S.rtf] ;# tells psfgen how atoms in a residue should be bound
    
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
        alias atom $bp "O5\*" O5'
        alias atom $bp "C5\*" C5'
        alias atom $bp "O4\*" O4'
        alias atom $bp "C4\*" C4'
        alias atom $bp "C3\*" C3'
        alias atom $bp "O3\*" O3'
        alias atom $bp "C2\*" C2'
        alias atom $bp "O2\*" O2'
        alias atom $bp "C1\*" C1'
        alias atom $bp  OP1   O1P
        alias atom $bp  OP2   O2P
    }
    alias atom THY C7 C5M
    
    
    set ID [mol new build_re_1.pdb]
    set prep_segnames [atomselect top all]
    $prep_segnames move [transaxis y -90]
    set finalres [lindex [$prep_segnames get residue] end]
    set final [atomselect top "name O3' and residue $finalres"]
    lassign [lindex [$final get {x y z}] 0] ocx ocy ocz 
    set ocx [expr $ocx*-1]
    set ocy [expr $ocy*-1]
    set ocz [expr $ocz*-1]
    $prep_segnames moveby "$ocx $ocy $ocz"
    $final delete
    
    
    set segnames [lsort -unique [$prep_segnames get segname]]
    
    foreach segname $segnames {
        set seg ${segname}
        set sel [atomselect top "segname $segname"]
    
        ## write out temporary pdb for psfgen to read
        set tmpPdb tmp.pdb
        $sel writepdb $tmpPdb
    
        segment $seg {
                first 5TER
                last 3TER
                pdb $tmpPdb
        }
        ## Now we patch the RNA molecule made by psfgen to make DNA
        ##     By default, psfgen makes DNA.
        
        foreach {patchSeg patchResId patchResName} [join [lsort -unique [$sel get {segname resid  resname}]]] {
                if {$patchResId == 1} {
                        patch DEO5 $patchSeg:$patchResId
                } else {
                        patch DEOX $patchSeg:$patchResId
                }
        
        }
        coordpdb $tmpPdb
        $sel delete
    }
    
    guesscoord ;# guess the coordinates of missing atoms
    regenerate angles dihedrals ;# fixes problems with patching
    
    writepdb ${outputname}.pdb
    writepsf ${outputname}.psf
    
    mol delete $ID
    $prep_segnames delete
    file delete -force "tmp.pdb"
    file delete -force "build.pdb"
    file delete -force "build_re.pdb"
    file delete -force "build_re_1.pdb"

}

