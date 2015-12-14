#!/usr/local/bin/vmd -dispdev text

# Usage: vmd -dispdev text -e mkPEG.tcl -args number outputname
# Make PEG molecule with arbitrary number of monomers
# Author: Chen-Yu Li <cli56@illinois.edu>
# 2014/10/2

proc mkPEG { number outputname homepath } {
set argc 3
set argv {}
lappend argv $number
lappend argv $outputname

if {$argc != 3} {
    puts "Usage: vmd -dispdev text -e mkPEG.tcl -args number outputname"
    exit
}



set bondL 1.53
set PEGL  2.293
set Interval [expr $bondL + $PEGL]

set n [lindex $argv 0]
set allatompdb [file join $homepath mkPEG/PEG.pdb]
set outname [lindex $argv 1]

set Index   ""
set Name    ""
set Resname ""
set Resid   ""
set Xcoor   ""
set Ycoor   ""
set Zcoor   ""
set Segname ""

set inStream [open $allatompdb r]
foreach line [split [read $inStream] \n] {

    #ATOM
    set string1 [string range $line 0 3]

    #index 
    set string2 [string trim [string range $line 6 10]]
    set Index [lappend Index $string2]

    #name
    set string3 [string trim [string range $line 12 15]]
    set Name [lappend Name $string3]

    #resname
    set string4 [string trim [string range $line 17 20]]
    set Resname [lappend Resname $string4]

    #resid
    set string5 [string trim [string range $line 22 25]]
    set Resid [lappend Resid $string5]

    #x-coordinate
    set string6 [string trim [string range $line 30 37]]
    set Xcoor [lappend Xcoor $string6]

    #y-coordinate
    set string7 [string trim [string range $line 38 45]]
    set Ycoor [lappend Ycoor $string7]

    #z-coordinate
    set string8 [string trim [string range $line 46 53]]
    set Zcoor [lappend Zcoor $string8]

    #segname
    set string9 [string trim [string range $line 72 75]]
    set Segname [lappend Segname $string9]

}
close $inStream

set Index   [lreplace $Index 7 7] 
set Name    [lreplace $Name 7 7] 
set Resname [lreplace $Resname 7 7] 
set Resid   [lreplace $Resid 7 7] 
set Xcoor   [lreplace $Xcoor 7 7] 
set Ycoor   [lreplace $Ycoor 7 7] 
set Zcoor   [lreplace $Zcoor 7 7] 
set Segname [lreplace $Segname 7 7] 

set Index_n   ""
set Name_n    ""
set Resname_n ""
set Resid_n   ""
set Xcoor_n   ""
set Ycoor_n   ""
set Zcoor_n   ""
set Segname_n ""

if {$n >= 2} {

    for {set i 0} {$i < $n} {incr i} {    

        set Index_tmp ""
        for {set j 0} {$j < 7} {incr j} {
            set Index_tmp [lappend Index_tmp [expr [lindex $Index $j] + [expr 7 * $i]]]

        }
        set Index_n [list {*}$Index_n {*}$Index_tmp]

        set Name_n [list {*}$Name_n {*}$Name]
        set Resname_n [list {*}$Resname_n {*}$Resname]

        set Resid_tmp ""
        for {set j 0} {$j < 7} {incr j} {
            set Resid_tmp [lappend Resid_tmp [expr [lindex $Resid $j] + $i]]

        }
        set Resid_n [list {*}$Resid_n {*}$Resid_tmp]

        set Xcoor_tmp ""
        for {set j 0} {$j < 7} {incr j} {
            set Xcoor_tmp [lappend Xcoor_tmp [expr [lindex $Xcoor $j] + [expr $Interval * $i]]]

        }
        set Xcoor_n [list {*}$Xcoor_n {*}$Xcoor_tmp]

        set Ycoor_n [list {*}$Ycoor_n {*}$Ycoor]
        set Zcoor_n [list {*}$Zcoor_n {*}$Zcoor]
        set Segname_n [list {*}$Segname_n {*}$Segname]

    }

} 


set out [open ${outname}.pdb w]
foreach index $Index_n name $Name_n resname $Resname_n resid $Resid_n x $Xcoor_n y $Ycoor_n z $Zcoor_n seg $Segname_n {
   puts $out [format "ATOM  %5d  %-3s %4sP%4d    %8.3f%8.3f%8.3f  1.00  0.00     %4s" $index $name $resname $resid $x $y $z $seg] 
}
close $out

####################### psfgen #########################################


package require psfgen             ;# load psfgen
resetpsf                           ;# Destroys any previous attempts
psfcontext reset                   ;# Tosses out any previously declared topology files

set parDir [file normalize [file join $homepath "topology"]]
topology $parDir/top_all36_cgenff_PEGA.rtf ;# tells psfgen how atoms in a residue should be bound

set ID [mol new ${outname}.pdb]
set seg [lindex $Segname_n 0]

segment $seg {
        first HYD1
        last HYD2
        pdb ${outname}.pdb
}
coordpdb ${outname}.pdb

guesscoord ;# guess the coordinates of missing atoms
regenerate angles dihedrals ;# fixes problems with patching

writepdb ${outname}.pdb
writepsf ${outname}.psf

mol delete $ID


}


