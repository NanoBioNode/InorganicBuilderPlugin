#***************************************************************************
#cr                                                                       
#cr            (C) Copyright 1995-2014 The Board of Trustees of the           
#cr                        University of Illinois                       
#cr                         All Rights Reserved                        
#cr                                                                   
#***************************************************************************/
#
# Inorganic structure building tools
#
# Original Inorganic Builder v0.1 Author:  Robert Brunner
#
#
# Surface-Structure Builder Author: AbderRahman N. Sobh
#
#
# PEG Generator, PEG Attachment Scripts Author: Chen-Yu Li
# DNA Generator, DNA Attachment Scripts Author: Chen-Yu Li
# NAMD File Generator Script: Chen-Yu Li

package provide inorganicbuilder 0.1

namespace eval ::drawenv:: {
  namespace export draw
  namespace export recolor
  namespace export changeMaterial
  namespace export deleteObj
  namespace export molExists
}

proc ::drawenv::draw { molid objs color { material none } } {
  if { ![molExists $molid] } {
    return -1
  }
  
  set colorId [ graphics $molid color $color ]
  if { [string equal $material "none"] } {
    # Use two commands in here, so if later we want to turn the material
    # on, we can just use a graphics replace command
    set materialId [ list [graphics $molid materials on ] \
                          [graphics $molid materials off ] ]
                          
  } else {
    set materialId [ list [graphics $molid materials on] \
                          [graphics $molid material $material] ]
  }
  set commandId {}
  foreach obj $objs {
    set commandStr [concat "graphics" $molid $obj]
    lappend commandId [ eval $commandStr ]
  }
  return [list $molid $colorId $materialId $commandId]
}

proc ::drawenv::recolor { obj color } {
  set molid [lindex $obj 0]
  set colid [lindex $obj 1]
  
  if { ![molExists $molid] } {
    return -1
  }
  
  graphics $molid replace $colid
  graphics $molid color $color
}

proc ::drawenv::changeMaterial { obj material } {
  set molid [lindex $obj 0]
  set matid [lindex $obj 2]
  
  if { ![molExists $molid] } {
    return -1
  }
  
  graphics $molid replace [lindex $matid 1]
  if { [string equal $material "none"] } {
    graphics $molid materials off
  } else {
    graphics $molid material $material
  }
}

proc ::drawenv::deleteObj { obj } {
  set molid [lindex $obj 0]
  set objid [lindex $obj 3]
  
  if { ![molExists $molid] } {
    return -1
  }
  
  foreach graphobj $objid {
    graphics $molid delete $graphobj
  }
}

proc ::drawenv::molExists { molid } {
  if { [lsearch -exact -integer [molinfo list] $molid] == -1 } {
    return 0
  } else {
    return 1
  }
}

namespace eval ::inorganicBuilder:: {
  namespace export initMaterials
  namespace export addMaterial
  namespace export getMaterialNames
  namespace export getMaterialUnitCell
  namespace export getMaterialTopologyFile
  namespace export getMaterialHexSymmetry
  namespace export getMaterialParFile
  namespace export newMaterialBox
  namespace export newMaterialHexagonalBox
  namespace export defineMaterialBox
  namespace export printBox
  namespace export setVMDPeriodicBox
  namespace export getCellBasisVectors
  namespace export newBlock
  namespace export printBlock
  namespace export drawBlock
  namespace export storeBlock
  namespace export newStruct
  namespace export printStruct
  namespace export drawStruct
  namespace export buildBox
  namespace export buildBonds
  namespace export buildAnglesDihedrals
  namespace export buildSpecificBonds
  namespace export setAtomTypes
  namespace export findShell
  namespace export printBondStats
  namespace export mergeMoleculesResegment
  namespace export inorganicBuilder_mainwin
  namespace export w
  namespace export molmenuaux



  variable materialList
  variable materialPath [file join $env(INORGANICBUILDERDIR) materials]
  variable homePath $env(INORGANICBUILDERDIR)
  variable surfingPath [lindex [glob [file join $env(INORGANICBUILDERDIR) ../../../../surf_*] ] 0]
#  variable surfingPath [file join $env(INORGANICBUILDERDIR) ../../../../lib/surf/]
  variable compvacuumPath [file join $env(INORGANICBUILDERDIR) compvacuum]
  variable guiStateVers 1.0
  variable guiState
  array set guiState {
    stateVersion $guiStateVers
    origX 0
    origY 0
    origZ 0
    boxX 1
    boxY 1
    boxZ 1
    hexD 1
    hexBox 0
    boxX2 1
    boxY2 1
    boxZ2 1
    boxZ3 1
    hexD2 1
    boxX2R 90
    boxY2R 90
    boxZ2R 90
    boxX2Rh 90
    boxY2Rh 90
    boxZ2Rh 60
    lenboxX 1
    lenboxY 1
    lenboxZ 1
    sspVecs ""
    sboxmol "-1"
    structBox "-1"
    drawstyle ""
    drawcolor "blue"
    limitxyz ""
    awframe ""
    saltName "NaCl"
    cation "SOD"
    anion "CLA"
    saltConc "0.15"
    buildHollow 0
    buildInside 0
    adjcharge 0
    periodicA 1
    periodicB 1
    periodicC 1
    buildAngles 0
    buildDihedrals 0
    getSurfacePrevID -1
    setPreviewMode -1
    systemBuilt 0
    buildPreviewMode {}
    filename_index_glob 0
    answer "yes"
    namdhandle "namd2"
    addDNALength ""
    addDNASEQ "Random"
    addDNATypes ""
    addDNAStrand "1"
    addPEGLength ""
    addPEGTypes ""
    addSurfTypes ""
    all_struct ""
    atomsBeforeAU 0
    DNATypes ""
    PEGTypes ""
    mmod 1.5
    StructHexBox 0
    StructSurfPeriodx 0
    StructSurfPeriody 0
    StructSurfPeriodz 0
    addMoleculeOrientX ""
    addMoleculeOrientY ""
    addMoleculeOrientZ ""
    addCustomSurfDetail ""
    addCustomStructDetail ""
    snm2 0
    setDensitySpacing 0
    setDensityVal 0
    setNAMDtemp 300
    setNAMDdiel 80
    setNAMDpress 5
    setNAMDminimStep 1200
    setNAMDsimStep 48000
    setNAMDIMD "yes"
    setVMDSelSurf ""
    structedFile "CombinedStructSurf"
    simFile "sim0"
    structureIndex 0
    structureX -1
    structureY -1
    structureZ 0
    surfacearea {}
    temp_surfacearea {}
    previous_surfacearea {}
    previous_densearea {}
    previous_SurfDetail ""
    previous_tempsurf ""
    dens_printer ""
    c_list ""
    o_list ""    
    cau_list ""
    oau_list ""
    global_useddense {}
    densearea {}
    blocklist {}
    structlist {}
    structListID ""
    dxlist {}
    selectionlist {}
    selectionlist_structs {}
    structed_molid "none"
    getSurfMol "none"
    currentMol "none"
    currentMol1 "none"
    currentMol2 "none"
    linemols {}
    bondCutoff 1.0
    gridSz 1
    gridRad 6
    thickness 10
    shellFile "shell"
    interiorFile "interior"
    mergedFile "merged"
    geomView {}
    geomMol -1
    loadResult 1
    addGenericInclude 0
    addDXFile {}
    relabelBonds 0
    saveParams 0
  }
  trace add variable [namespace current]::guiState(currentMol) write \
    ::inorganicBuilder::molmenuaux
  trace add variable [namespace current]::guiState(currentMol1) write \
    ::inorganicBuilder::mol1menuaux
  trace add variable [namespace current]::guiState(currentMol2) write \
    ::inorganicBuilder::mol2menuaux

  variable w
}

proc ::inorganicBuilder::molmenuaux {mol index op} {
  return [molmenuauxint $mol $index $op "currentMol" "molMenuText"]
}

proc ::inorganicBuilder::mol1menuaux {mol index op} {
  return [molmenuauxint $mol $index $op "currentMol1" "mol1MenuText"]
}

proc ::inorganicBuilder::mol2menuaux {mol index op} {
  return [molmenuauxint $mol $index $op "currentMol2" "mol2MenuText"]
}

proc ::inorganicBuilder::molmenuauxint {mol index op currentMol molMenuText } {
  #Accessory proc for the trace on currentMol
  variable guiState
  if { ! [catch { molinfo $guiState($currentMol) get name } name ] } {
    set guiState($molMenuText) "$guiState($currentMol): $name"
  } else { set guiState($molMenuText) "$guiState($currentMol)" }
}

proc ::inorganicBuilder::inorganicBuilder_mainwin {} {
  variable w
  
  #De-minimize if the window is already running
  if { [winfo exists .inorganicBuilder] } {
    wm deiconify $w
    puts "Deiconifying!!!\007"
    return
  }
  
  set ns [namespace current]
  initMaterials
  
  set w [toplevel ".inorganicBuilder"]
#  puts "InorganicBuilder)w is $w"
  wm title $w "InorganicBuilder"
  wm resizable $w yes yes
  
  set row 0

  #Add a menubar
  frame $w.menubar -relief raised -bd 2
  grid  $w.menubar -padx 1 -column 0 -row $row -sticky ew

  menubutton $w.menubar.file -text "File" -underline 0 \
    -menu $w.menubar.file.menu -pady 5
  $w.menubar.file config -width 4
  pack $w.menubar.file -side left

  menubutton $w.menubar.task -text "Task" -underline 0 \
    -menu $w.menubar.task.menu -pady 5
  $w.menubar.task config -width 4
  pack $w.menubar.task -side left

  menubutton $w.menubar.material -text "Material" -underline 0 \
    -menu $w.menubar.material.menu -pady 5
  $w.menubar.material config -width 8
  pack $w.menubar.material -side left

  menubutton $w.menubar.help -text "Help" -underline 0 \
    -menu $w.menubar.help.menu -pady 5
  $w.menubar.help config -width 6
  pack $w.menubar.help -side right

  ## File menu
  menu $w.menubar.file.menu -tearoff no
  $w.menubar.file.menu add command -label "Open" \
    -command "set fname \[tk_getOpenFile -defaultextension \".ibs\" \]; \
              ${ns}::guiLoadState \$fname;"
  $w.menubar.file.menu add command -label "Save as" \
    -command "set fname \[tk_getSaveFile -defaultextension \".ibs\" \]; \
              ${ns}::guiSaveState \$fname;"

  ## Task menu
  menu $w.menubar.task.menu -tearoff no
  set tasklist [list \
    [list "Build device" "${ns}::guiBuildDeviceWin"] \
    [list "Add bonds" "${ns}::guiBuildBondsWin"] \
    [list "Find surface atoms" "${ns}::guiFindSurfaceAtomsWin"] \
    [list "Solvate box" "${ns}::guiSolvateBoxWin"] \
    [list "Build Surface Structures" "${ns}::guiBuildSurfaceStructsWin"]
  ]
  set ntasks [llength $tasklist]
  foreach task $tasklist {
    foreach {tlabel tcommand} $task {}
    $w.menubar.task.menu add command -label $tlabel \
      -command $tcommand
  }


  ## Material menu
  menu $w.menubar.material.menu -tearoff no
  $w.menubar.material.menu add command -label "New Material" \
    -command \
    "${ns}::guiEditMaterialWin $w.menubar.material.menu.materials"
  $w.menubar.material.menu add cascade -label "View Material" \
    -menu $w.menubar.material.menu.materials
  menu $w.menubar.material.menu.materials -tearoff no
  guiBuildMaterialMenu $w.menubar.material.menu.materials

  ## help menu
  menu $w.menubar.help.menu -tearoff no
  $w.menubar.help.menu add command -label "About" \
    -command {tk_messageBox -type ok -title "About InorganicBuilder" \
              -message "A tool for building structures of inorganic materials."}
  $w.menubar.help.menu add command -label "Help..." \
    -command "vmd_open_url [string trimright [vmdinfo www] /]/plugins/inorganicbuilder"

  # Bind the start window to the map action, so that whenever we 
  # open/reopen the window, we return to the Start window, rather than
  # returning to where we left off. This is bound to the menubar rather
  # than the top window, because the top window generates Map events
  # for each child, and we don't want to be called multiple times
  bind $w.menubar <Map> "${ns}::guiStartWin"
  
  #$w.menubar.task.menu invoke 0
}

proc ::inorganicBuilder::guiStartWin {} {
  variable guiState
  variable w
  
  set ns [namespace current]
  set guiState(curWin) ${ns}::guiStartWin
  
  foreach child [winfo children $w] {
    if { ![string equal "$child" "${w}.menubar"] } {
      destroy $child
    }
  }

  frame $w.body1
  set row 0
  grid [button $w.body1.click1 -text "Click here" \
          -command "${ns}::guiBuildDeviceWin"] \
    -row $row -column 0 -padx {4 0}
  grid [label $w.body1.label1 \
          -text " or select \"Task:Build device\" to build a new device model" ] \
    -row $row -column 1 -sticky w -padx {0 4} -pady 5
  incr row 2
  
  grid [button $w.body1.click2 -text "Click here" \
          -command "set fname \[tk_getOpenFile -defaultextension \".ibs\" \]; \
                    ${ns}::guiLoadState \$fname;"] \
    -row $row -column 0 -padx {4 0}
  grid [label $w.body1.label2 \
          -text " or select \"File:Open\" to load an existing model" ] \
    -row $row -column 1 -sticky w -padx {0 4} -pady 5
  incr row 2

  grid [button $w.body1.click3 -text "Click here" \
          -command "${ns}::guiBuildBondsWin"] \
    -row $row -column 0 -padx {4 0}
  grid [label $w.body1.label3 \
          -text " or select \"Task:Add bonds\" to add bonds to a structure" ] \
    -row $row -column 1 -sticky w -padx {0 4} -pady 5
  incr row 2
  
  grid [button $w.body1.click4 -text "Click here" \
          -command "${ns}::guiBuildSurfaceStructsWin"] \
    -row $row -column 0 -padx {4 0}
  grid [label $w.body1.label4 \
          -text " or select \"Task:Build Surface Structures\" to add new structures to a surface" ] \
    -row $row -column 1 -sticky w -padx {0 4} -pady 5
  incr row 2


  pack $w.menubar -anchor nw -fill x
  pack $w.body1 -anchor nw -fill x
}



proc ::inorganicBuilder::guiBuildDeviceWin {} {
  variable guiState
  variable w
  
  set ns [namespace current]
  set guiState(curWin) ${ns}::guiBuildDeviceWin
  
  foreach child [winfo children $w] {
    if { ![string equal "$child" "${w}.menubar"] } {
      destroy $child
    }
  }

  frame $w.body1
  set row 0
  grid columnconfigure $w.body1 { 0 2 3 } -weight 0
  grid columnconfigure $w.body1 1 -weight 1
  
  grid [label $w.body1.materiallabel -text "Material" ] \
    -row $row -column 0 -sticky w
  grid [menubutton $w.body1.materialmenub \
    -menu $w.body1.materialmenub.menu -relief raised -pady 5] \
    -row $row -column 1 -sticky ew
  menu $w.body1.materialmenub.menu -tearoff no
    
#  $w.body.materialmenub config -width 15
  set matlist [lsort -index 1 [ getMaterialNames ]]

  if { ![info exists guiState(material)] } {
    set guiState(material) [lindex $matlist 0 0 ]
  }
  
  set i 0
  foreach mat $matlist {
    foreach { shortname longname } $mat {}
    $w.body1.materialmenub.menu add command -label $longname \
      -command "$w.body1.materialmenub configure -text \"$longname\"; \
                ${ns}::guiUpdateMaterial $shortname; ${ns}::guiCreateBox"
    if { [string equal $guiState(material) $shortname] } {
        $w.body1.materialmenub.menu invoke $i
    }
    incr i
  }
  
  grid [label $w.body1.hexlabel -text "Hex box:"] -row $row -column 2 \
    -sticky w
  grid [checkbutton $w.body1.hex -variable ${ns}::guiState(hexBox) \
    -command "${ns}::guiBuildDeviceWin" ] \
    -row $row -column 3 -sticky w
    
  grid [label $w.body1.pbxlabel -text "Periodic box:"] -row $row -column 4 \
    -sticky w
  grid [checkbutton $w.body1.pbx \
    -variable ${ns}::guiState(mmod) \
    -command "${ns}::guiBuildDeviceWin" ] \
    -row $row -column 5 -sticky w
    
  if { ![ getMaterialHexSymmetry $guiState(material)] } {
    $w.body1.hex configure -state disabled
  } else {
    $w.body1.hex configure -state normal
  }
  bind $w.body1.hex <FocusOut> ${ns}::guiCreateBox
  incr row
  
  frame $w.body2
  set row 0
  
  grid columnconfigure $w.body2 { 0 2 4 } -weight 0
  grid columnconfigure $w.body2 { 1 3 5 } -weight 1
  
  grid [label $w.body2.origlabel -text "Origin:"] \
    -row $row -column 0 -columnspan 6 -sticky w
  incr row
  
  grid [label $w.body2.xoriglabel -text "X:"] \
    -row $row -column 0 -sticky e
  grid [entry $w.body2.xorig -width 5 -textvariable ${ns}::guiState(origX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  bind $w.body2.xorig <FocusOut> ${ns}::guiCreateBox
  grid [label $w.body2.yoriglabel -text "Y:"] -row $row -column 2 -sticky e
  grid [entry $w.body2.yorig -width 5 -textvariable ${ns}::guiState(origY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 3 -sticky ew -padx 4
  bind $w.body2.yorig <FocusOut> ${ns}::guiCreateBox
  grid [label $w.body2.zoriglabel -text "Z:"] -row $row -column 4 -sticky w
  grid [entry $w.body2.zorig -width 5 -textvariable ${ns}::guiState(origZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 5 -sticky ew -padx 4
  bind $w.body2.zorig <FocusOut> ${ns}::guiCreateBox
  incr row

  if { $guiState(hexBox) } {
    grid [label $w.body2.hexlabel -text "Hex box dimensions:"] \
      -row $row -column 0 -columnspan 6 -sticky w
    incr row
  
    grid [label $w.body2.hexrlabel -text "D:" ] \
      -row $row -column 0 -sticky e
    grid [entry $w.body2.hexr -width 5 -textvariable ${ns}::guiState(hexD) \
            -validate all \
            -vcmd "${ns}::guiRequirePInt %W %P %V" \
            -invcmd "${ns}::guiUnitCellErr %W" \
          ] \
      -row $row -column 1 -sticky ew
    bind $w.body2.hexr <FocusOut> ${ns}::guiCreateBox
    grid [label $w.body2.hexrnotelabel -text "(inside diameter)" ] \
      -row $row -column 2 -columnspan 4 -sticky w
    incr row
    
    grid [label $w.body2.zboxlabel -text "Z:"] \
      -row $row -column 0 -sticky e
    grid [entry $w.body2.zbox -width 5 -textvariable ${ns}::guiState(boxZ) \
            -validate all \
            -vcmd "${ns}::guiRequirePInt %W %P %V" \
            -invcmd "${ns}::guiUnitCellErr %W" \
          ] \
      -row $row -column 1 -sticky ew
    bind $w.body2.zbox <FocusOut> ${ns}::guiCreateBox
    grid [label $w.body2.hexhnotelabel -text "(height)" ] \
      -row $row -column 2 -columnspan 4 -sticky w
    incr row
  } else {
    grid [label $w.body2.boxdimlabel -text "Box dimension:"] \
      -row $row -column 0 -columnspan 6 -sticky w
    incr row
  
    grid [label $w.body2.xboxlabel -text "X:"] \
      -row $row -column 0 -sticky e
    grid [entry $w.body2.xbox -width 5 -textvariable ${ns}::guiState(boxX) \
            -validate all \
            -vcmd "${ns}::guiRequirePInt %W %P %V" \
            -invcmd "${ns}::guiUnitCellErr %W" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    bind $w.body2.xbox <FocusOut> ${ns}::guiCreateBox
    
    grid [label $w.body2.yboxlabel -text "Y:"] -row $row -column 2 -sticky e
    grid [entry $w.body2.ybox -width 5 -textvariable ${ns}::guiState(boxY) \
            -validate all \
            -vcmd "${ns}::guiRequirePInt %W %P %V" \
            -invcmd "${ns}::guiUnitCellErr %W" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    bind $w.body2.ybox <FocusOut> ${ns}::guiCreateBox
    grid [label $w.body2.zboxlabel -text "Z:"] -row $row -column 4 -sticky e
    grid [entry $w.body2.zbox -width 5 -textvariable ${ns}::guiState(boxZ) \
            -validate all \
            -vcmd "${ns}::guiRequirePInt %W %P %V" \
            -invcmd "${ns}::guiUnitCellErr %W" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    bind $w.body2.zbox <FocusOut> ${ns}::guiCreateBox
    incr row
  }
  
  grid [label $w.body2.basislabel -text "Basis vectors:"] \
    -row $row -column 0 -columnspan 6 -sticky w
  incr row
  
  grid [label $w.body2.axlabel -text "A X:"] \
    -row $row -column 0 -sticky e
  grid [label $w.body2.ax -width 10 -anchor nw -textvariable ${ns}::guiState(boxAX)] \
    -row $row -column 1 -sticky w
  grid [label $w.body2.aylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [label $w.body2.ay -width 10 -anchor nw -textvariable ${ns}::guiState(boxAY)] \
    -row $row -column 3 -sticky w
  grid [label $w.body2.azlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [label $w.body2.az -width 10 -anchor nw -textvariable ${ns}::guiState(boxAZ)] \
    -row $row -column 5 -sticky w
  incr row

  grid [label $w.body2.bxlabel -text "B X:"] \
    -row $row -column 0 -sticky e
  grid [label $w.body2.bx -width 10 -anchor nw -textvariable ${ns}::guiState(boxBX)] \
    -row $row -column 1 -sticky ew
  grid [label $w.body2.bylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [label $w.body2.by -width 10 -anchor nw -textvariable ${ns}::guiState(boxBY)] \
    -row $row -column 3 -sticky ew
  grid [label $w.body2.bzlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [label $w.body2.bz -width 10 -anchor nw -textvariable ${ns}::guiState(boxBZ)] \
    -row $row -column 5 -sticky ew
  incr row

  grid [label $w.body2.cxlabel -text "C X:"] \
    -row $row -column 0 -sticky e
  grid [label $w.body2.cx -width 10 -anchor nw -textvariable ${ns}::guiState(boxCX)] \
    -row $row -column 1 -sticky ew
  grid [label $w.body2.cylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [label $w.body2.cy -width 10 -anchor nw -textvariable ${ns}::guiState(boxCY)] \
    -row $row -column 3 -sticky ew
  grid [label $w.body2.czlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [label $w.body2.cz -width 10 -anchor nw -textvariable ${ns}::guiState(boxCZ)] \
    -row $row -column 5 -sticky ew
  incr row
  
  frame $w.body2a
  grid columnconfigure $w.body2a { 0 } -weight 0
  grid columnconfigure $w.body2a { 1 } -weight 1
  set row 0
  grid [label $w.body2a.adjqlabel -text "Make total charge an integer:"] \
    -row $row -column 0 -sticky w
  grid [checkbutton $w.body2a.adjq -variable ${ns}::guiState(adjcharge)] \
    -row $row -column 1 -sticky w
  incr row

  guiCreateBox

  frame $w.minmax
  set row 0
  
  grid columnconfigure $w.minmax { 0 2 } -weight 0
  grid columnconfigure $w.minmax { 1 3 } -weight 1

  grid [label $w.minmax.minmaxlabel -text "Structure Min/Max:"] \
    -row $row -column 0 -columnspan 4 -sticky w
  incr row
  
  grid [label $w.minmax.xminlabel -text "X Min:"] \
    -row $row -column 0 -sticky e
  grid [label $w.minmax.xmin -width 10 -anchor nw \
    -textvariable ${ns}::guiState(boxXmin)] \
    -row $row -column 1 -sticky ew
  grid [label $w.minmax.xmaxlabel -text "Max:"] \
    -row $row -column 2 -sticky e
  grid [label $w.minmax.xmax -width 10 -anchor nw \
    -textvariable ${ns}::guiState(boxXmax)] \
    -row $row -column 3 -sticky ew
  incr row  

  grid [label $w.minmax.yminlabel -text "Y Min:"] \
    -row $row -column 0 -sticky e
  grid [label $w.minmax.ymin -width 10 -anchor nw \
    -textvariable ${ns}::guiState(boxYmin)] \
    -row $row -column 1 -sticky ew
  grid [label $w.minmax.ymaxlabel -text "Max:"] \
    -row $row -column 2 -sticky e
  grid [label $w.minmax.ymax -width 10 -anchor nw \
    -textvariable ${ns}::guiState(boxYmax)] \
    -row $row -column 3 -sticky ew
  incr row  

  grid [label $w.minmax.zminlabel -text "Z Min:"] \
    -row $row -column 0 -sticky e
  grid [label $w.minmax.zmin -width 10 -anchor nw \
    -textvariable ${ns}::guiState(boxZmin)] \
    -row $row -column 1 -sticky ew
  grid [label $w.minmax.zmaxlabel -text "Max:"] \
    -row $row -column 2 -sticky e
  grid [label $w.minmax.zmax -width 10 -anchor nw \
    -textvariable ${ns}::guiState(boxZmax)] \
    -row $row -column 3 -sticky ew
  incr row  

  frame $w.body3
  set row 0
  
#  grid [button $w.body3.drawbox -text "Draw Box" \
#          -command "${ns}::guiDrawBoxButton"] \
#    -row $row -column 0 -columnspan 3
#  incr row
    
  grid [label $w.body3.outputnamelabel -text "Output file (.pdb,.psf):" ] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.outputname \
    -textvariable ${ns}::guiState(fname) ] \
    -row $row -column 1 -columnspan 2 -sticky ew -padx 4
  incr row
  
  grid [label $w.body3.saveparlabel \
    -text "Save par file (if available):"] \
    -row $row -column 0 -sticky w
  grid [checkbutton $w.body3.savepar -variable ${ns}::guiState(saveParams)] \
    -row $row -column 1 -columnspan 2 -sticky w
  incr row
  if { [ string equal [getMaterialParFile $guiState(material)] "" ] } {
    set guiState(saveParams) 0
    $w.body3.savepar configure -state disabled
  } else {
    $w.body3.savepar configure -state normal
  }

  grid [label $w.body3.blockslabel -text "Excluded blocks:" ] \
    -row $row -column 0 -sticky w
  grid [button $w.body3.addblocks -text "Add exclusion" \
          -command "${ns}::guiCreateBox; ${ns}::guiAddBlockWin"] \
    -row $row -column 1
  grid [button $w.body3.remove -text "Remove exclusion" \
        -command "${ns}::guiRemoveBlock $w.blocks.btab.list; ${ns}::guiBuildDeviceWin" \
       ]\
      -row $row -column 2
  incr row

  frame $w.blocks
  set row 0
  grid columnconfigure $w.blocks 0 -weight 1
  if { [info exists guiState(blocklist)] } {
    set blocklist $guiState(blocklist)
  } else {
    set blocklist {}
  }
  if { [info exists guiState(selectionlist)] } {
    set blocklist [concat $blocklist $guiState(selectionlist)]
  }
  frame $w.blocks.btab -borderwidth 3 -relief raised

  listbox $w.blocks.btab.list -relief raised -borderwidth 2 \
    -height 3 -yscrollcommand "$w.blocks.btab.scroll set" 
  scrollbar $w.blocks.btab.scroll -command "$w.blocks.btab.list yview"
  if { [llength $blocklist] == 0 } {
    $w.body3.remove configure -state disabled 
    $w.blocks.btab.list insert end "No blocks defined"
  } else {
    $w.body3.remove configure -state normal

    $w.blocks.btab.list delete 0 end
    set i 0
    foreach block $blocklist {
      set blocktype [getBlockType $block]
      $w.blocks.btab.list insert end \
        [format "%3d %12s %12s" $i [getBlockName $block] [getBlockType $block] ]
      incr i
    }
  }
  pack $w.blocks.btab.scroll -side right -fill y
  pack $w.blocks.btab.list -side left -fill both -expand 1
  pack $w.blocks.btab -fill both -expand 1
    
  frame $w.buttons
  set row 0

  grid [button $w.buttons.doit -text "Build device" \
          -command "set ${ns}::guiState(buildHollow) 0; ${ns}::guiCreateBox; ${ns}::guiBuildStructure" ] \
    -row $row -column 0
  grid [button $w.buttons.doit2 -text "Build Hollow" \
          -command "set ${ns}::guiState(buildHollow) 1; ${ns}::guiCreateBox; ${ns}::guiBuildStructure" ] \
    -row $row -column 1
  grid [button $w.buttons.clear -text "Clear device" \
          -command "${ns}::guiClearDevice" ] -row $row -column 2
  grid [button $w.buttons.cancel -text "Cancel" \
          -command "wm withdraw $w" ] -row $row -column 3


  if { $guiState(mmod) != 1.5 } {
	  $w.buttons.doit2 configure -state disabled
  } else {
	  $w.buttons.doit2 configure -state normal
  }


  pack $w.menubar -anchor nw -fill x
  pack $w.body1 -anchor nw -fill x
  pack $w.body2 -anchor nw -fill x
  pack $w.body2a -anchor nw -fill x
  pack $w.minmax -anchor nw -fill x
  pack $w.body3 -anchor nw -fill x
  pack $w.blocks -anchor nw -fill both -expand 1
  pack $w.buttons -anchor sw -fill x
}




proc ::inorganicBuilder::guiViewMaterialWin { menuwin name } {
  variable guiState
  
  set ns [namespace current]
  set guiState(curWin) "${ns}::guiViewMaterialWin $menuwin $name"

  return [guiViewEditMaterialWin $menuwin $name true]
}

proc ::inorganicBuilder::guiEditMaterialWin { menuwin } {
  variable guiState 
  
  set ns [namespace current]
  set guiState(curWin) "${ns}::guiEditMaterialWin $menuwin"
  
  return [guiViewEditMaterialWin $menuwin "" false]
}

proc ::inorganicBuilder::guiViewEditMaterialWin { menuwin shortname viewonly } {
  variable guiState
  variable w
  
  if {$viewonly} {
    set guiState(newMatShortName) $shortname
    set guiState(newMatLongName) [getMaterialLongName $shortname]
    set guiState(newMatUCName) [getMaterialUnitCellFile $shortname]
    set guiState(newMatTopName) [getMaterialTopologyFile $shortname]

    set uc [getMaterialUnitCell $shortname]
    foreach { a b c } $uc {}
    foreach { x y z } $a {}
    set guiState(newMatAX) $x
    set guiState(newMatAY) $y
    set guiState(newMatAZ) $z
    foreach { x y z } $b {}
    set guiState(newMatBX) $x
    set guiState(newMatBY) $y
    set guiState(newMatBZ) $z
    foreach { x y z } $c {}
    set guiState(newMatCX) $x
    set guiState(newMatCY) $y
    set guiState(newMatCZ) $z

    set guiState(newMatCutoff) [getMaterialCutoff $shortname]
    set guiState(newMatHex) [getMaterialHexSymmetry $shortname]
  } else {
    set guiState(newMatShortName) "NewMaterial"
    set guiState(newMatLongName) "New Material"
    set guiState(newMatUCName) ""
    set guiState(newMatTopName) ""

    set guiState(newMatAX) 0
    set guiState(newMatAY) 0
    set guiState(newMatAZ) 0
    set guiState(newMatBX) 0
    set guiState(newMatBY) 0
    set guiState(newMatBZ) 0
    set guiState(newMatCX) 0
    set guiState(newMatCY) 0
    set guiState(newMatCZ) 0

    set guiState(newMatCutoff) 0
    set guiState(newMatHex) 0
  }
  set guiState(newMatParams) [list newMatParams \
                                newMatShortName newMatLongName \
                                newMatUCName newMatTopName \
                                newMatAX newMatAY newMatAZ \
                                newMatBX newMatBY newMatBZ \
                                newMatCX newMatCY newMatCZ \
                                newMatCutoff newMatHex]

#  puts "InorganicBuilder)Building periodic bonds"
  set ns [namespace current]
  foreach child [winfo children $w] {
    if { ![string equal "$child" "${w}.menubar"] } {
      destroy $child
    }
  }
  
  frame $w.name
  set row 0
  grid columnconfigure $w.name 1 -weight 1

  grid [label $w.name.longlabel -text "Name:"] \
    -sticky e -row $row -column 0
  grid [entry $w.name.longval -textvariable ${ns}::guiState(newMatLongName) ] \
    -padx 4 -sticky ew -row $row -column 1 -columnspan 3
  incr row

  grid [label $w.name.shortlabel -text "Short name:"] \
    -sticky e -row $row -column 0
  grid [entry $w.name.shortval \
    -textvariable ${ns}::guiState(newMatShortName) ] \
    -padx 4 -sticky ew -row $row -column 1 -columnspan 3
  incr row
  
  grid [label $w.name.uclabel -text "Unit cell PDB:"] \
    -sticky e -row $row -column 0
  grid [entry $w.name.ucname -textvariable ${ns}::guiState(newMatUCName) ] \
    -padx 4 -sticky ew -row $row -column 1 -columnspan 2
  if { $viewonly } {
    grid [button $w.name.ucbutton -text "Save" \
            -command "set tempfile \[tk_getSaveFile -defaultextension .pdb\]; \
                      if \{!\[string equal \$tempfile \"\"\]\} \{ \
                        file copy -force -- \
                          $${ns}::guiState(newMatUCName) \$tempfile; \
                     \};" \
         ] \
      -row $row -column 3 -sticky e
  } else {
    grid [button $w.name.ucbutton -text "Browse" \
            -command "set tempfile \[tk_getOpenFile -defaultextension .pdb\]; \
                      if \{!\[string equal \$tempfile \"\"\]\} \{ \
                        set ${ns}::guiState(newMatUCName) \$tempfile; \
                     \};" \
         ] \
      -row $row -column 3 -sticky e
  }
  incr row
  
  grid [label $w.name.toplabel -text "Topology file:"] \
    -sticky e -row $row -column 0
  grid [entry $w.name.topname -textvariable ${ns}::guiState(newMatTopName) ] \
    -padx 4 -sticky ew -row $row -column 1
    
  if { $viewonly } {
    grid [button $w.name.topbutton -text "Save" \
            -command "set tempfile \[tk_getSaveFile -defaultextension .top\]; \
                      if \{!\[string equal \$tempfile \"\"\]\} \{ \
                        file copy -force -- \
                          $${ns}::guiState(newMatTopName) \$tempfile; \
                     \};" \
         ] \
      -row $row -column 3 -sticky e
  } else {
    grid [button $w.name.topbutton -text "Browse" \
            -command "set tempfile \[tk_getOpenFile -defaultextension .top\]; \
                      if \{!\[string equal \$tempfile \"\"\]\} \{ \
                        set ${ns}::guiState(newMatTopName) \$tempfile; \
                     \};" \
         ] \
      -row $row -column 3 -sticky e
  }  
  incr row
  pack $w.name -anchor nw -fill x

  grid [label $w.name.cutofflabel -text "Cutoff:"] \
    -sticky e -row $row -column 0
  grid [entry $w.name.cutoffval -textvariable ${ns}::guiState(newMatCutoff) \
          -validate all \
          -vcmd "${ns}::guiRequireDouble %W %P %V" \
       ] \
    -padx 4 -sticky ew -row $row -column 1
    
  incr row
  
  grid [label $w.name.hexlabel -text "Hex symmetry:"] \
    -sticky e -row $row -column 0
  grid [checkbutton $w.name.hexval -variable ${ns}::guiState(newMatHex)] \
    -padx 4 -sticky ew -row $row -column 1
    
  incr row
  
  frame $w.basis
  set row 0
  grid columnconfigure $w.basis { 0 2 4 } -weight 0
  grid columnconfigure $w.basis { 1 3 5 } -weight 1

  grid [label $w.basis.basislabel -text "Basis vectors:"] \
    -row $row -column 0 -columnspan 6 -sticky w
  incr row

  grid [label $w.basis.axlabel -text "A X:"] \
    -row $row -column 0 -sticky e
  grid [entry $w.basis.ax -width 5 -textvariable ${ns}::guiState(newMatAX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  grid [label $w.basis.aylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [entry $w.basis.ay -width 5 -textvariable ${ns}::guiState(newMatAY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 3 -sticky ew -padx 4
  grid [label $w.basis.azlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [entry $w.basis.az -width 5 -textvariable ${ns}::guiState(newMatAZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 5 -sticky ew -padx 4
  incr row

  grid [label $w.basis.bxlabel -text "B X:"] \
    -row $row -column 0 -sticky e
  grid [entry $w.basis.bx -width 5 -textvariable ${ns}::guiState(newMatBX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  grid [label $w.basis.bylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [entry $w.basis.by -width 5 -textvariable ${ns}::guiState(newMatBY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 3 -sticky ew -padx 4
  grid [label $w.basis.bzlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [entry $w.basis.bz -width 5 -textvariable ${ns}::guiState(newMatBZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 5 -sticky ew -padx 4
  incr row

  grid [label $w.basis.cxlabel -text "C X:"] \
    -row $row -column 0 -sticky e
  grid [entry $w.basis.cx -width 5 -textvariable ${ns}::guiState(newMatCX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  grid [label $w.basis.cylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [entry $w.basis.cy -width 5 -textvariable ${ns}::guiState(newMatCY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 3 -sticky ew -padx 4
  grid [label $w.basis.czlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [entry $w.basis.cz -width 5 -textvariable ${ns}::guiState(newMatCZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 5 -sticky ew -padx 4
  incr row
  pack $w.basis -anchor nw -fill x
 
  frame $w.buttons
  set row 0
  if { $viewonly } {
    grid [button $w.buttons.doit -text "Save a copy" \
            -command "set fname \[ tk_getSaveFile -defaultextension \".ibm\" \]; ${ns}::guiSaveMaterial \$fname" ] \
      -row $row -column 0
  } else {
    grid [button $w.buttons.cancel -text "Cancel" \
            -command "wm withdraw $w" ] -row $row -column 0
    grid [button $w.buttons.load -text "Load Material" \
            -command "set fname \[tk_getOpenFile -defaultextension \".ibm\" \]; ${ns}::guiLoadMaterial \$fname" ] \
      -row $row -column 1
    grid [button $w.buttons.doit -text "Add to library" \
            -command "${ns}::guiAddMaterial $menuwin" ] \
      -row $row -column 2
  }
  pack $w.buttons -anchor nw -fill x
  
  if { $viewonly } {
    $w.name.longval configure -state readonly
    $w.name.shortval configure -state readonly
    $w.name.ucname configure -state readonly
    $w.name.topname configure -state readonly
    $w.name.cutoffval configure -state readonly
    $w.name.hexval configure -state disabled
    $w.basis.ax configure -state readonly
    $w.basis.ay configure -state readonly
    $w.basis.az configure -state readonly
    $w.basis.bx configure -state readonly
    $w.basis.by configure -state readonly
    $w.basis.bz configure -state readonly
    $w.basis.cx configure -state readonly
    $w.basis.cy configure -state readonly
    $w.basis.cz configure -state readonly
  }
}

proc ::inorganicBuilder::guiBuildBondsWin {} {
  variable guiState
  variable w
  
#  puts "InorganicBuilder)Finding specific bonds"
  set ns [namespace current]
  set guiState(curWin) ${ns}::guiBondsWin
  
  foreach child [winfo children $w] {
    if { ![string equal "$child" "${w}.menubar"] } {
      destroy $child
    }
  }

  frame $w.body31
  set row 0
  
  grid [button $w.body31.explain -text "Explain bond options" \
            -command "tk_messageBox -default ok \
            -detail \
      \"You can either add bonds that \
      wrap around the sides of the periodic box using VMD's bond search \
      heuristic, or specify bonds to add by atom type. In either case \
      you may choose to keep the bonds already in the file. However, \
      even if you choose to keep existing bonds, angle and dihedral \
      bonds due to the way VMD handles PSF files will be lost. They may \
      be regenerated by selecting the appropriate options below.\"  \
      -parent $w -title \"Bond options\" -icon info  -type ok " ] \
    -row $row -column 0 -sticky w

#  grid [message $w.body31.explain -text "You can either add bonds that \
#    wrap around the sides of the periodic box using VMD's bond search \
#    heuristic, or specify bonds to add by atom type. In either case \
#    you may choose to keep the bonds already in the file. However, \
#    even if you choose to keep existing bonds, angle and dihedral \
#    bonds due to the way VMD handles PSF files will be lost. They may \
#    be regenerated by selecting the appropriate options below." \
#    -aspect 650 ] \
#    -row $row -column 0 -sticky w
  incr row
  
  if { ![info exist guiState(addBondsHow)] } {
    set guiState(addBondsHow) addperiodictofile
  }
  
  grid [radiobutton $w.body31.addbondsfile \
          -variable ${ns}::guiState(addBondsHow) -value addperiodictofile \
          -command ${ns}::guiSetBuildBondsControls \
          -text "Keep existing bonds, add bonds that wrap around the periodic box" \
          -anchor w] \
    -row $row -column 0 -sticky w
  incr row
  
  grid [radiobutton $w.body31.addbondsvmd \
          -variable ${ns}::guiState(addBondsHow) -value addperiodictovmd \
          -command ${ns}::guiSetBuildBondsControls \
          -text "Let VMD generate internal bonds, add bonds that wrap around\
          the periodic box" -anchor w] \
    -row $row -column 0 -sticky w
  incr row
  
  grid [radiobutton $w.body31.addspecificbonds \
          -variable ${ns}::guiState(addBondsHow) -value addspecifiedtofile \
          -command ${ns}::guiSetBuildBondsControls \
          -text "Keep existing bonds, specify bonds to add by atom type" \
          -anchor w] \
    -row $row -column 0 -sticky w
  incr row

  grid [radiobutton $w.body31.specifybonds \
          -variable ${ns}::guiState(addBondsHow) -value buildspecified \
          -command ${ns}::guiSetBuildBondsControls \
          -text "Ignore existing bonds, build only specified bonds" \
          -anchor w] \
    -row $row -column 0 -sticky w
  incr row

  guiDrawMolFileFrame $ns $w.body "Molecule" "psffile" "pdbfile"
  guiDrawBasisFrame $ns $w.body2

  frame $w.body3
  set row 0
#  grid columnconfigure $w.body3 0 -weight 0
#  grid columnconfigure $w.body3 1 -weight 1
#  grid columnconfigure $w.body3 2 -weight 0
#  grid columnconfigure $w.body3 3 -weight 1
  
#  grid [label $w.body3.cutofflabel -text "Bond cutoff (for periodic bonds):"] \
#    -row $row -column 0 -sticky w
#  grid [entry $w.body3.cutoff -width 5 \
#    -textvariable ${ns}::guiState(bondCutoff) \
#            -validate all \
#            -vcmd "${ns}::guiRequireDouble %W %P %V" \
#          ] \
#    -row $row -column 1 -sticky w
#  incr row

  grid [label $w.body3.periodicinabel -text "Periodic in" ] \
    -row $row -column 0 -sticky w

  frame $w.body3.cb
  label $w.body3.cb.perlabela -text "A:"
  checkbutton $w.body3.cb.periodica -variable ${ns}::guiState(periodicA)
  label $w.body3.cb.perlabelb -text "B:"
  checkbutton $w.body3.cb.periodicb -variable ${ns}::guiState(periodicB)
  label $w.body3.cb.perlabelc -text "C:"
  checkbutton $w.body3.cb.periodicc -variable ${ns}::guiState(periodicC)
  pack $w.body3.cb.perlabela $w.body3.cb.periodica \
       $w.body3.cb.perlabelb $w.body3.cb.periodicb \
       $w.body3.cb.perlabelc $w.body3.cb.periodicc -side left -anchor nw
       
  grid $w.body3.cb -row $row -column 1 -columnspan 6 -sticky ew
  incr row
  
  frame $w.body3.bbuttons
  label $w.body3.bbuttons.hexlabel -text "Transform to hex:"
  checkbutton $w.body3.bbuttons.hex -variable ${ns}::guiState(hexBox)
 
  label $w.body3.bbuttons.angleslabel -text "Build angles:"
  checkbutton $w.body3.bbuttons.angles \
    -variable ${ns}::guiState(buildAngles) \
    -command "${ns}::guiProcessAngleCheckbox"

  label $w.body3.bbuttons.dihedralslabel -text "Dihedrals:"
  checkbutton $w.body3.bbuttons.dihedrals \
    -variable ${ns}::guiState(buildDihedrals)

  label $w.body3.bbuttons.relabelbondslabel \
    -text "Includes bond count in type:"
  checkbutton $w.body3.bbuttons.relabelbonds \
    -variable ${ns}::guiState(relabelBonds)
    
  pack $w.body3.bbuttons.hexlabel $w.body3.bbuttons.hex -side left -anchor nw
  pack $w.body3.bbuttons.angleslabel $w.body3.bbuttons.angles -side left -anchor nw
  pack $w.body3.bbuttons.dihedralslabel $w.body3.bbuttons.dihedrals -side left -anchor nw
  pack $w.body3.bbuttons.relabelbondslabel $w.body3.bbuttons.relabelbonds -side left -anchor nw
  grid $w.body3.bbuttons -row $row -column 0 -columnspan 7 -sticky ew
  incr row
  
  grid [label $w.body3.outputnamelabel -text "Output file (.pdb,.psf):" ] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.outputname \
    -textvariable ${ns}::guiState(fname) ] \
    -row $row -column 1 -columnspan 5 -sticky ew -padx 4
  
  grid [label $w.body3.loadresultlabel -text "Load result:"] \
    -row $row -column 6 -sticky e
  grid [checkbutton $w.body3.loadresult \
    -variable ${ns}::guiState(loadResult) ]\
    -row $row -column 7 -sticky ew
  incr row
  
  frame $w.body4
  grid columnconfigure $w.body4 {0 1 2} -weight 1
  grid [label $w.body4.blockslabel -text "Specified bonds:" ] \
    -row $row -column 0 -sticky w
  grid [frame $w.body4.addbuttons] -row $row -column 1 -sticky w
  
  grid [button $w.body4.addbuttons.addbonds -text "Add bond" \
          -command "${ns}::guiAddBondWin"] \
    -row 0 -column 0
  grid [button $w.body4.addbuttons.remove -text "Remove" \
        -command "${ns}::guiRemoveBond $w.bonds.btab.list" ]\
      -row 0 -column 1
  incr row

  frame $w.bonds
  set row 0
  if { [info exists guiState(bondlist)] } {
    set bondlist $guiState(bondlist)
  } else {
    set bondlist {}
  }
  if { [llength $bondlist] == 0 } {
    grid [label $w.bonds.nobonds -text "No bonds"] \
    -row $row -column 0
    incr row
    $w.body4.addbuttons.remove configure -state disabled
  } else {
    $w.body4.addbuttons.remove configure -state normal
    grid [frame $w.bonds.btab -borderwidth 3 -relief raised] \
      -row $row -column 0 -sticky ew
    incr row
    listbox $w.bonds.btab.list -relief raised -width 30 -borderwidth 2 \
      -yscrollcommand "$w.bonds.btab.scroll set"
    pack $w.bonds.btab.list -side left
    scrollbar $w.bonds.btab.scroll -command "$w.bonds.btab.list yview"
    pack $w.bonds.btab.scroll -side right -fill y
    
    set i 0
    foreach bond $bondlist {
      $w.bonds.btab.list insert end \
        [format "%3d %10s %10s %15.3f" $i [lindex $bond 0] [lindex $bond 1] \
                                    [lindex $bond 2] ]
      incr i
    }
  }  
  frame $w.buttons
  set row 0
  grid [button $w.buttons.doit -text "Find Bonds" \
          -command "${ns}::guiBuildBonds" \
       ] \
    -row $row -column 0
  grid [button $w.buttons.cancel -text "Cancel" \
          -command "wm withdraw $w" ] -row $row -column 5

    
  pack $w.body31 -anchor nw -fill x
  pack $w.menubar -anchor nw -fill x
  pack $w.body -anchor nw -fill x
  pack $w.body2 -anchor nw -fill x
  pack $w.body3 -anchor nw -fill x
  pack $w.body4 -anchor nw -fill x
  pack $w.bonds -anchor nw -fill x
  pack $w.buttons -anchor nw -fill x
  guiProcessAngleCheckbox
  guiSetBuildBondsControls
}

proc ::inorganicBuilder::guiSetBuildBondsControls {} {
  variable guiState
  variable w
  
  if { [ string equal $guiState(addBondsHow) "addperiodictofile" ] \
        || [ string equal $guiState(addBondsHow) "addperiodictovmd" ] } {
 #   $w.body3.cutoff configure -state normal
    $w.body4.addbuttons.addbonds configure -state disabled
    $w.body4.addbuttons.remove configure -state disabled
    if { [winfo exists $w.bonds.btab.list ] } {
      $w.bonds.btab.list configure -state disabled
    }
#    if { [winfo exists $w.bonds.btab.scroll ] } {
#      $w.bonds.btab.scroll configure -state disabled
#    }
  } else {
#    $w.body3.cutoff configure -state disabled
    $w.body4.addbuttons.addbonds configure -state normal
      $w.body4.addbuttons.remove configure -state disabled
    if { [info exists guiState(bondlist)] } {
      set bondlist $guiState(bondlist)
    } else {
      set bondlist {}
    }
    if { [llength $bondlist] > 0 } {
      $w.body4.addbuttons.remove configure -state normal
    }
    if { [winfo exists $w.bonds.btab.list ] } {
      $w.bonds.btab.list configure -state normal
    }
#    if { [winfo exists $w.bonds.btab.scroll ] } {
#      $w.bonds.btab.scroll configure -state normal
#    }
  }
}


proc ::inorganicBuilder::guiProcessAngleCheckbox {} {
  variable guiState
  variable w
  if { $guiState(buildAngles) } {
    $w.body3.bbuttons.dihedrals configure -state normal
  } else {
    set guiState(buildDihedrals) 0
    $w.body3.bbuttons.dihedrals configure -state disabled
  }
}

proc ::inorganicBuilder::guiFindSurfaceAtomsWin {} {
  variable guiState
  variable w
  
#  puts "InorganicBuilder)Finding surface"
  set ns [namespace current]
  set guiState(curWin) ${ns}::FindSurfaceAtomsWin

  foreach child [winfo children $w] {
    if { ![string equal "$child" "${w}.menubar"] } {
      destroy $child
    }
  }
  guiDrawMolFileFrame $ns $w.body "Molecule" "psffile" "pdbfile"
  guiDrawBasisFrame $ns $w.body2  

  frame $w.body3
  set row 0
  grid columnconfigure $w.body3 0 -weight 0
  grid columnconfigure $w.body3 1 -weight 1
  
  grid [label $w.body3.gridszlabel -text "Grid spacing:"] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.gridsz -width 5 -textvariable ${ns}::guiState(gridSz) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky w
  incr row
  
  grid [label $w.body3.gridradiuslabel -text "Radius:"] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.gridradius -width 5 \
    -textvariable ${ns}::guiState(gridRad) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky w
  incr row
  
  grid [label $w.body3.thicknesslabel -text "Shell thickness:"] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.thickness -width 5 -textvariable \
    ${ns}::guiState(thickness) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky w
  incr row

  grid [label $w.body3.shellfilelabel -text "Surface (.pdb,.psf):"] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.shellfile -width 5 -textvariable \
    ${ns}::guiState(shellFile)] \
    -row $row -column 1 -sticky ew -padx 4
  incr row

  grid [label $w.body3.intfilelabel -text "Interior (.pdb,.psf):"] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.intfile -width 5 -textvariable \
    ${ns}::guiState(interiorFile)] \
    -row $row -column 1 -sticky ew -padx 4
  incr row

  frame $w.buttons
  set row 0
  grid [button $w.buttons.doit -text "Find Shell" \
          -command "${ns}::guiFindShell" ] \
    -row $row -column 0
  grid [button $w.buttons.cancel -text "Cancel" \
          -command "wm withdraw $w" ] -row $row -column 5
    
  pack $w.menubar -anchor nw -fill x
  pack $w.body -anchor nw -fill x
  pack $w.body2 -anchor nw -fill x
  pack $w.body3 -anchor nw -fill x
  pack $w.buttons -anchor nw -fill x
}

proc ::inorganicBuilder::guiMergeSurfInteriorWin {} {
  variable guiState
  variable w
  
#  puts "InorganicBuilder)Merging molecules"
  set ns [namespace current]
  set guiState(curWin) ${ns}::guiMergeSurfInteriorWin

  foreach child [winfo children $w] {
    if { ![string equal "$child" "${w}.menubar"] } {
      destroy $child
    }
  }

  guiDrawMolFileFrame $ns $w.body "Surface molecule:" "psffile1" "pdbfile1"
  guiDrawMolFileFrame $ns $w.body2 "Interior molecule:" "psffile2" "pdbfile2"

  frame $w.body3
  set row 0
  grid columnconfigure $w.body3 0 -weight 0
  grid columnconfigure $w.body3 1 -weight 1
  
  grid [label $w.body3.materiallabel -text "Material" ] \
    -row $row -column 0 -sticky w
  grid [menubutton $w.body3.materialmenub \
    -menu $w.body3.materialmenub.menu -relief raised -pady 5] \
    -row $row -column 1 -sticky ew
  menu $w.body3.materialmenub.menu -tearoff no
    
#  $w.body.materialmenub config -width 15
  set matlist [lsort -index 1 [ getMaterialNames ]]
  if { ![info exists guiState(material)] } {
    set guiState(material) [lindex $matlist 0 0 ]
  }
  
  set i 0
  foreach mat $matlist {
    foreach { shortname longname } $mat {}
    $w.body3.materialmenub.menu add command -label $longname \
      -command "$w.body3.materialmenub configure -text \"$longname\"; \
                ${ns}::guiUpdateMaterial $shortname"
    if { [string equal $guiState(material) $shortname]} {
        $w.body3.materialmenub.menu invoke $i
    }
    incr i
  }
  incr row

#  puts "InorganicBuilder)Built menu"
  
  grid [label $w.body3.mergedfilelabel -text "Merged file (.pdb,.psf):"] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.mergedfile -width 5 -textvariable \
    ${ns}::guiState(mergedFile)] \
    -row $row -column 1 -sticky ew
  incr row

  frame $w.buttons
  set row 0
  grid [button $w.buttons.doit -text "Merge" \
          -command "${ns}::guiMergeSurfInterior" ] \
    -row $row -column 0
  grid [button $w.buttons.cancel -text "Cancel" \
          -command "wm withdraw $w" ] -row $row -column 5
    
  pack $w.menubar -anchor nw -fill x
  pack $w.body -anchor nw -fill x
  pack $w.body2 -anchor nw -fill x
  pack $w.body3 -anchor nw -fill x
  pack $w.buttons -anchor nw -fill x
}

proc ::inorganicBuilder::guiSolvateBoxWin {} {
  variable guiState
  variable w
  
#  puts "InorganicBuilder)Solvating structure"
  set ns [namespace current]
  set guiState(curWin) ${ns}::guiSolvateBoxWin

  foreach child [winfo children $w] {
  if { ![string equal "$child" "${w}.menubar"] } {
      destroy $child
    }
  }

  guiDrawMolFileFrame $ns $w.body "Molecule" "psffile" "pdbfile"
  guiDrawBasisFrame $ns $w.body2

  frame $w.body3
  set row 0
  grid columnconfigure $w.body3 1 -weight 1
  
  grid [label $w.body3.mergedfilelabel -text "Solvated file (.pdb,.psf):"] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.mergedfile -width 5 -textvariable \
    ${ns}::guiState(solvatedFile)] \
    -row $row -column 1 -sticky ew -padx 4
  incr row
  
  grid [label $w.body3.hexlabel -text "Transform to hex on completion:"] -row $row -column 0 -sticky w
  grid [checkbutton $w.body3.hex -variable ${ns}::guiState(hexBox) ]\
    -row $row -column 1 -sticky ew
  incr row

  frame $w.buttons
  set row 0
  grid [button $w.buttons.doit -text "Solvate Box" \
          -command "${ns}::guiSolvateBox" ] \
    -row $row -column 0
  grid [button $w.buttons.cancel -text "Cancel" \
          -command "wm withdraw $w" ] -row $row -column 5
    
  pack $w.menubar -anchor nw -fill x
  pack $w.body -anchor nw -fill x
  pack $w.body2 -anchor nw -fill x
  pack $w.body3 -anchor nw -fill x
  pack $w.buttons -anchor nw -fill x
}


# *** ADDED ***
proc ::inorganicBuilder::guiBuildSurfaceStructsWin {} {
  variable guiState
  variable w

  set ns [namespace current]
  set guiState(curWin) ${ns}::BuildSurfaceStructsWin

# populate from preset box dim  
  if {($guiState(boxX2) && $guiState(boxY2) && $guiState(boxZ2)) \
  && ($guiState(boxX2) == 1) && ([info exists guiState(boxAX)])} {
	  set guiState(boxX2) $guiState(boxAX)
	  set guiState(boxY2) $guiState(boxBY)
	  set guiState(boxZ2) $guiState(boxCZ)
	  if { $guiState(mmod) == 1 } {
		  set guiState(StructSurfPeriodx) 1
		  set guiState(StructSurfPeriody) 1
		  set guiState(StructSurfPeriodz) 1
	  }
	  ${ns}::structBoxMolecule 
  }

# populate from preset hex box dim
  if {($guiState(boxZ3) && $guiState(hexD2)) \
  && ($guiState(boxZ3) == 1) && ([info exists guiState(boxCZ)])} {
	  set guiState(boxZ3) $guiState(boxCZ)
	  set guiState(hexD2) $guiState(boxAX)
	  if { $guiState(hexBox) } {
		  set guiState(StructHexBox) 1
	  }
	  ${ns}::structBoxMolecule 
  }
  
  
  foreach child [winfo children $w] {
    if { ![string equal "$child" "${w}.menubar"] } {
      destroy $child
    }
  }
  guiDrawMolFileFrame $ns $w.body "Surface-Only Molecule" "psffileA" "pdbfileA"


  frame $w.body3
  set row 0
  grid columnconfigure $w.body3 0 -weight 0
  grid columnconfigure $w.body3 1 -weight 1			  


  grid [label $w.body3.outputnamelabel -text "Output file (.pdb,.psf):"] \
    -row $row -column 0 -sticky w
  grid [entry $w.body3.outputname -width 5 -textvariable ${ns}::guiState(structedFile)] \
    -row $row -column 1 -sticky ew -padx 4
  grid [button $w.body3.getcdev -text "Reset Device" \
          -command "${ns}::clearStructs; \
          set ${ns}::guiState(psffileA) \"\"; \
          set ${ns}::guiState(pdbfileA) \"\"; \
          ${ns}::guiBuildSurfaceStructsWin" ] \
    -row $row -column 2
  incr row


  grid [button $w.body3.getsa0 -text "Get Surface Atom Types:" \
          -command "${ns}::getSurfaceAtomTypes" ] \
    -row $row -column 0
  grid [entry $w.body3.selectsas -width 20 \
    -textvariable ${ns}::guiState(addSurfTypes)] \
    -row $row -column 1 -columnspan 4 -sticky ew -padx 4       
  grid [button $w.body3.getsa1 -text "Draw Surface Atoms" \
          -command "${ns}::getSurfaceAtoms" ] \
    -row $row -column 2

  incr row
  

  grid [label $w.body3.structslabel -text "Structures:" ] \
    -row $row -column 0 -sticky w
  grid [button $w.body3.addstructs -text "Add Structure" \
          -command "${ns}::guiAddStructWin"] \
    -row $row -column 1
  grid [button $w.body3.remove -text "Remove Structure" \
        -command "${ns}::guiRemoveStruct $w.structs.btab.list 1; ${ns}::guiBuildSurfaceStructsWin" \
       ]\
      -row $row -column 2
  incr row

  frame $w.structs
  set row 0
  grid columnconfigure $w.structs 0 -weight 1
  if { [info exists guiState(structlist)] } {
    set structlist $guiState(structlist)
  } else {
    set structlist {}
  }
  if { [info exists guiState(selectionlist_structs)] } {
    set structlist [concat $structlist $guiState(selectionlist_structs)]
  }
  frame $w.structs.btab -borderwidth 3 -relief raised

  listbox $w.structs.btab.list -relief raised -borderwidth 2 \
    -height 3 -yscrollcommand "$w.structs.btab.scroll set" 
  scrollbar $w.structs.btab.scroll -command "$w.structs.btab.list yview"

  if { [llength $guiState(surfacearea)] == 0 } {
	  $w.body3.addstructs configure -state disabled
	  set structlist {}	  
	  set guiState(structlist) {}
  } else {
	  $w.body3.addstructs configure -state normal
  }
  if { [llength $structlist] == 0 } {
    $w.body3.remove configure -state disabled 
    $w.structs.btab.list insert end "No structures defined"
  } else {
    $w.body3.remove configure -state normal

    $w.structs.btab.list delete 0 end
    set i 0
    foreach struct $structlist {
      set structtype [getStructType $struct]
      $w.structs.btab.list insert end \
        [format "%3d %12s %12s" $i [getStructName $struct] [getStructType $struct] ]
      incr i
    }
  }
  pack $w.structs.btab.scroll -side right -fill y
  pack $w.structs.btab.list -side left -fill both -expand 1
  pack $w.structs.btab -fill both -expand 1


  labelframe $w.periodic -text "Periodic Settings of Surface with Structures" -padx 2 -pady 4
  set row 0

  grid [label $w.periodic.pbxlabel -text "Build Periodic in:"] -row $row -column 0 \
    -sticky w
  grid [checkbutton $w.periodic.pbx -text "X" \
    -variable ${ns}::guiState(StructSurfPeriodx)\
    -command "${ns}::structBoxMolecule"] \
    -row $row -column 1 -sticky w

  grid [checkbutton $w.periodic.pby -text "Y"\
    -variable ${ns}::guiState(StructSurfPeriody)\
    -command "${ns}::structBoxMolecule"] \
    -row $row -column 2 -sticky w

  grid [checkbutton $w.periodic.pbz -text "Z"\
    -variable ${ns}::guiState(StructSurfPeriodz)\
    -command "${ns}::structBoxMolecule"] \
    -row $row -column 3 -sticky w

  incr row

  grid [label $w.periodic.hexlabel -text "Hex box:"] -row $row -column 0 \
    -sticky w
  grid [checkbutton $w.periodic.hpbx \
    -variable ${ns}::guiState(StructHexBox)\
    -command "${ns}::guiBuildSurfaceStructsWin; ${ns}::structBoxMolecule"] \
    -row $row -column 1 -sticky w
  incr row

  if { $guiState(StructHexBox) } {
    grid [label $w.periodic.hexdimlabel -text "Hex box dimensions (Angstrom):"] \
      -row $row -column 0 -columnspan 6 -sticky w
    incr row
  
    grid [label $w.periodic.hexrlabel -text "D:" ] \
      -row $row -column 0 -sticky e
    grid [entry $w.periodic.hexr -width 5 -textvariable ${ns}::guiState(hexD2) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew
    bind $w.periodic.hexr <FocusOut> ${ns}::structBoxMolecule
    grid [label $w.periodic.hexrnotelabel -text "(inside diameter)" ] \
      -row $row -column 2 -columnspan 4 -sticky w
    incr row
    
    grid [label $w.periodic.zboxlabel -text "Z:"] \
      -row $row -column 0 -sticky e
    grid [entry $w.periodic.zbox -width 5 -textvariable ${ns}::guiState(boxZ3) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew
    bind $w.periodic.zbox <FocusOut> ${ns}::structBoxMolecule
    grid [label $w.periodic.hexhnotelabel -text "(height)" ] \
      -row $row -column 2 -columnspan 4 -sticky w
    incr row
    
# ~rot menu
    grid [label $w.periodic.boxdimlabel2h -text "Hex Periodic Directions (Degrees):"] \
      -row $row -column 0 -columnspan 6 -sticky w
    incr row
    
    grid [label $w.periodic.xboxlabel2h -text "Alpha:"] \
      -row $row -column 0 -sticky e
    grid [entry $w.periodic.xbox2h -width 5 -textvariable ${ns}::guiState(boxX2Rh) \
            -validate all \
            -vcmd "${ns}::guiRequireAngle %W %P %V" \
            -invcmd "${ns}::guiUnitAngErr %W" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    bind $w.periodic.xbox2h <FocusOut> ${ns}::structBoxMolecule 
      
    grid [label $w.periodic.yboxlabel2h -text "Beta:"] -row $row -column 2 -sticky e
    grid [entry $w.periodic.ybox2h -width 5 -textvariable ${ns}::guiState(boxY2Rh) \
            -validate all \
            -vcmd "${ns}::guiRequireAngle %W %P %V" \
            -invcmd "${ns}::guiUnitAngErr %W" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    bind $w.periodic.ybox2h <FocusOut> ${ns}::structBoxMolecule 
    grid [label $w.periodic.zboxlabel2h -text "Gamma:"] -row $row -column 4 -sticky e
    grid [entry $w.periodic.zbox2h -width 5 -textvariable ${ns}::guiState(boxZ2Rh) \
            -validate all \
            -vcmd "${ns}::guiRequireAngle %W %P %V" \
            -invcmd "${ns}::guiUnitAngErr %W" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    bind $w.periodic.zbox2h <FocusOut> ${ns}::structBoxMolecule 
    incr row
# ~rot menu

    
  } else {
    grid [label $w.periodic.boxdimlabel -text "Box dimensions (Angstrom):"] \
      -row $row -column 0 -columnspan 6 -sticky w
    incr row
    
    grid [label $w.periodic.xboxlabel -text "X:"] \
      -row $row -column 0 -sticky e
    grid [entry $w.periodic.xbox -width 5 -textvariable ${ns}::guiState(boxX2) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    bind $w.periodic.xbox <FocusOut> ${ns}::structBoxMolecule 
      
    grid [label $w.periodic.yboxlabel -text "Y:"] -row $row -column 2 -sticky e
    grid [entry $w.periodic.ybox -width 5 -textvariable ${ns}::guiState(boxY2) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    bind $w.periodic.ybox <FocusOut> ${ns}::structBoxMolecule 
    grid [label $w.periodic.zboxlabel -text "Z:"] -row $row -column 4 -sticky e
    grid [entry $w.periodic.zbox -width 5 -textvariable ${ns}::guiState(boxZ2) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    bind $w.periodic.zbox <FocusOut> ${ns}::structBoxMolecule 
    incr row
# ~rot menu
    grid [label $w.periodic.boxdimlabel2 -text "Periodic Directions (Degrees):"] \
      -row $row -column 0 -columnspan 6 -sticky w
    incr row
    
    grid [label $w.periodic.xboxlabel2 -text "Alpha:"] \
      -row $row -column 0 -sticky e
    grid [entry $w.periodic.xbox2 -width 5 -textvariable ${ns}::guiState(boxX2R) \
            -validate all \
            -vcmd "${ns}::guiRequireAngle %W %P %V" \
            -invcmd "${ns}::guiUnitAngErr %W" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    bind $w.periodic.xbox2 <FocusOut> ${ns}::structBoxMolecule 
      
    grid [label $w.periodic.yboxlabel2 -text "Beta:"] -row $row -column 2 -sticky e
    grid [entry $w.periodic.ybox2 -width 5 -textvariable ${ns}::guiState(boxY2R) \
            -validate all \
            -vcmd "${ns}::guiRequireAngle %W %P %V" \
            -invcmd "${ns}::guiUnitAngErr %W" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    bind $w.periodic.ybox2 <FocusOut> ${ns}::structBoxMolecule 
    grid [label $w.periodic.zboxlabel2 -text "Gamma:"] -row $row -column 4 -sticky e
    grid [entry $w.periodic.zbox2 -width 5 -textvariable ${ns}::guiState(boxZ2R) \
            -validate all \
            -vcmd "${ns}::guiRequireAngle %W %P %V" \
            -invcmd "${ns}::guiUnitAngErr %W" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    bind $w.periodic.zbox2 <FocusOut> ${ns}::structBoxMolecule 
    incr row
# ~rot menu

  }


###


  frame $w.buttons
  set row 0

  grid [button $w.buttons.doit -text "Build Structures" \
          -command "${ns}::guiBuildStructs; ${ns}::guiBuildSurfaceStructsWin" ] \
    -row $row -column 0
  grid [button $w.buttons.doitnamd -text "Run NAMD" \
          -command "${ns}::guiRunNAMD" ] \
    -row $row -column 5
  grid [button $w.buttons.cancel -text "Cancel" \
          -command "wm withdraw $w" ] -row $row -column 6

  if { [llength $structlist] == 0 } {
    $w.buttons.doit configure -state disabled
  } else {
    $w.buttons.doit configure -state normal
  }

  if { $guiState(systemBuilt) == 0 } {
    $w.buttons.doitnamd configure -state disabled
  } else {
    $w.buttons.doitnamd configure -state normal
  }

  set guiState(structListID) $w.structs.btab.list
    
  pack $w.menubar -anchor nw -fill x
  pack $w.body -anchor nw -fill x
  pack $w.body3 -anchor nw -fill x
  pack $w.structs -anchor nw -fill both -expand 1
  pack $w.periodic -anchor nw -fill x
  pack $w.buttons -anchor nw -fill x
}


proc ::inorganicBuilder::guiDrawBoxButton {} {
  guiCreateBox
}

proc ::inorganicBuilder::guiDrawBox {} {
  variable guiState
  if { $guiState(geomMol) != -1 } {
    mol delete $guiState(geomMol)
  }
  set guiState(geomMol) [mol new]
  mol rename $guiState(geomMol) \
    "[getBoxMaterial $guiState(currentBox)]$guiState(geomMol)"
  set guiState(geomView) {}
  
  if { $guiState(hexBox) } {
    lappend guiState(geomView) [drawHexBox $guiState(currentBox) \
                                  $guiState(geomMol) ]
  } else {
    lappend guiState(geomView) [drawBox $guiState(currentBox) \
                                  $guiState(geomMol) ]
  }
  
  if { [info exists guiState(blocklist)] } {
    foreach block $guiState(blocklist) {
      lappend guiState(geomView) [drawBlock $block $guiState(geomMol) ]
    }
  }
  ::inorganicBuilder::setVMDPeriodicBox $guiState(currentBox) $guiState(geomMol)
  display resetview
  
  return
}

proc ::inorganicBuilder::guiAddBlockWin {} {
  variable guiState
  
  if { [winfo exists .ibaddblock] } {
    destroy .ibaddblock
  }
  set aw [toplevel ".ibaddblock"]
  wm title $aw "Add Block"
  wm resizable $aw yes yes
  grab set ".ibaddblock"
  set ns [namespace current]

  frame $aw.type
  set row 0
  grid [label $aw.type.label -text "Block type:" ] \
    -row $row -column 0 -sticky w
  grid [menubutton $aw.type.menub \
    -menu $aw.type.menub.menu -relief raised] \
    -row $row -column 1 -columnspan 5 -sticky ew -ipady 2
  menu $aw.type.menub.menu -tearoff no
    
  $aw.type.menub config -width 20
  set typelist { {pp Paralellepiped} {cylinder Cylinder} \
                 {sphere Sphere} {cone Cone} {th Tetrahedron} \
                 {selection "VMD Selection" } {dxfile "DX File" }}
  if { ![info exists guiState(addBlockType)] } {
    set guiState(addBlockType) [lindex $typelist 1 0]
  }
  foreach typ $typelist {
    foreach { shortname longname } $typ {}
    $aw.type.menub.menu add command -label $longname \
      -command "$aw.type.menub configure -text \"$longname\"; \
                set ${ns}::guiState(addBlockType) $shortname; \
                ${ns}::guiAddBlockParams $aw.params"
    if { [string equal $shortname $guiState(addBlockType)] } {
      $aw.type.menub configure -text $longname
    }
  }
  incr row
  
  frame $aw.buttons
  set row 0

  grid [button $aw.buttons.add -text Add \
    -command "${ns}::guiStoreBlock; destroy $aw"] \
    -row $row -column 0
  grid [button $aw.buttons.cancel -text Cancel -command "destroy $aw"] \
    -row $row -column 1
  
  guiAddBlockParams $aw.params
  guiRepackAdd
}

# *** ADDED ***
proc ::inorganicBuilder::guiAddStructWin {} {
  variable guiState
  
  if { [winfo exists .ibaddstruct] } {
    destroy .ibaddstruct
  }
  set aw [toplevel ".ibaddstruct"]
  wm title $aw "Add Structure"
  wm resizable $aw yes yes
  grab set ".ibaddstruct"
  set ns [namespace current]

  frame $aw.type
  set row 0
  grid [label $aw.type.label -text "Structure type:" ] \
    -row $row -column 0 -sticky w
  grid [menubutton $aw.type.menub \
    -menu $aw.type.menub.menu -relief raised] \
    -row $row -column 1 -columnspan 5 -sticky ew -ipady 2
  menu $aw.type.menub.menu -tearoff no
    
  $aw.type.menub config -width 20
  set typelist { {custom "Custom Structure Selection"} {peg "Polyethylene Glycol"} {dna "DNA"}}
  
  if { ![info exists guiState(addStructType)] } {
    set guiState(addStructType) [lindex $typelist 1 0]
  }
  foreach typ $typelist {
    foreach { shortname longname } $typ {}
    $aw.type.menub.menu add command -label $longname \
      -command "$aw.type.menub configure -text \"$longname\"; \
                set ${ns}::guiState(addStructType) $shortname; \
                ${ns}::guiAddStructParams $aw.params"
    if { [string equal $shortname $guiState(addStructType)] } {
      $aw.type.menub configure -text $longname
    }
  }
  incr row
  
  set row [guiDrawDensityFrame $ns $aw.body $row]

  if { [string equal "$guiState(setPreviewMode)" "-1"] } { 
	  set mode 1
  } else {
	  set mode 0
  }
  
  frame $aw.buttons
  
  set guiState(awframe) $aw
  grid [button $aw.buttons.add -text Add \
    -command "${ns}::guiHighlightStruct $mode; \
     ${ns}::guiStoreStruct;"] \
    -row $row -column 0
  grid [button $aw.buttons.cancel -text Cancel -command "destroy $aw"] \
    -row $row -column 1
 
  guiAddStructParams $aw.params
  guiRepackStructAdd
}



proc ::inorganicBuilder::guiSelectLoadedMolWin { psffile pdbfile \
                                                 { fileflag "-all" } } {
  variable guiState

  if { ![string equal "$guiState(getSurfacePrevID)" "-1"] } {
    mol delete $guiState(getSurfacePrevID)
    set guiState(getSurfacePrevID) -1
  }
  if { ![string equal "$guiState(setPreviewMode)" "-1"] } {
    mol delete $guiState(getSurfacePrevID)
    set guiState(getSurfacePrevID) -1
  }

  
  if { [winfo exists .ibseelctmol] } {
    destroy .ibselectmol
  }
  set aw [toplevel ".ibselectmol"]
  wm title $aw "Select molecule"
  wm resizable $aw yes yes
  grab set ".ibselectmol"
  set ns [namespace current]

  frame $aw.type
  set row 0
  grid [label $aw.type.label -text "Molecule:" ] \
    -row $row -column 0 -sticky w
  grid [menubutton $aw.type.menub \
    -menu $aw.type.menub.menu -relief raised -width 20 ] \
    -row $row -column 1 -columnspan 5 -sticky ew -ipady 2

  set guiState(molMenuName) [menu $aw.type.menub.menu -tearoff no]
  guiFillMolMenu $fileflag
  set def_label [$aw.type.menub.menu entrycget 0 -label]
  #puts "InorganicBuilder)Label is $def_label"
  #$aw.type.menub configure -text "$def_label"
  incr row 2
  
  frame $aw.buttons
  set row 0
  grid [button $aw.buttons.add -text Select \
    -command "${ns}::guiStoreMol $psffile $pdbfile; \
			destroy $aw"] \
    -row $row -column 0
  grid [button $aw.buttons.cancel -text Cancel -command "destroy $aw"] \
    -row $row -column 1
  
  guiRepackSelectMol

}


# *** ADDED ***
proc ::inorganicBuilder::guiDrawDensityFrame { ns win row } {
  frame $win
  incr row

  set squared [format %c 178]
  grid [label ${win}dens -text "Density per nm$squared: "] \
    -row $row -column 0 -sticky w
  grid [entry ${win}densval -width 4 \
    -textvariable ${ns}::guiState(setDensityVal)] \
    -row $row -column 0 -columnspan 4 -sticky e -padx 4
  incr row

  grid [label ${win}dens1 -text "Exclusion Radius (nm) for Attachment Sites: "] \
    -row $row -column 0 -sticky w
  grid [entry ${win}densval1 -width 4 \
    -textvariable ${ns}::guiState(setDensitySpacing)] \
    -row $row -column 0 -columnspan 4 -sticky e -padx 4
  incr row

  grid [label ${win}selsa -text "VMD Selection for Attachment Site:"] \
    -row $row -column 0 -sticky w
  grid [entry ${win}selsaval -width 20 \
    -textvariable ${ns}::guiState(setVMDSelSurf)] \
    -row $row -column 0 -columnspan 4 -sticky e -padx 4
  incr row    
  return $row
}


# *** ADDED ***
proc ::inorganicBuilder::guiDrawNAMDFrame { ns win row } {

  labelframe $win -text "System Parameters" -padx 2 -pady 4
  incr row

  
  grid [label ${win}temp -text "Temperature (K): "] \
    -row $row -column 0 -sticky w
  grid [entry ${win}tempval -width 4 \
    -textvariable ${ns}::guiState(setNAMDtemp)] \
    -row $row -column 0 -columnspan 3 -sticky e -padx 4
  incr row

  grid [label ${win}diel -text "Dielectric Constant of System: "] \
    -row $row -column 0 -sticky w
  grid [entry ${win}dielval -width 4 \
    -textvariable ${ns}::guiState(setNAMDdiel)] \
    -row $row -column 0 -columnspan 3 -sticky e -padx 4
  incr row

  grid [label ${win}press -text "Langevin Damping Constant (Pressure): "] \
    -row $row -column 0 -sticky w
  grid [entry ${win}pressval -width 4 \
    -textvariable ${ns}::guiState(setNAMDpress)] \
    -row $row -column 0 -columnspan 3 -sticky e -padx 4
  incr row

  return $row
}


proc ::inorganicBuilder::guiDrawMolFileFrame { ns win label psfkey pdbkey } {
  frame $win
  set row 0
  grid columnconfigure $win { 0 2 } -weight 0
  grid columnconfigure $win 1 -weight 1

  grid [label $win.label -text $label] \
    -row $row -column 0 -columnspan 1 -sticky w

  grid [button $win.selloaded -text "Select loaded molecule" \
    -command "${ns}::guiSelectLoadedMolWin $psfkey $pdbkey" ] \
    -row $row -column 1 -columnspan 2 -sticky e
  incr row
    
  grid [label $win.psflabel -text "PSF: "] \
    -row $row -column 0 -sticky w
  grid [entry $win.psfpath -width 30 \
        -textvariable ${ns}::guiState($psfkey)] \
    -row $row -column 1 -sticky ew
  grid [button $win.psfbutton -text "Browse" \
         -command "set tempfile \[tk_getOpenFile -defaultextension .psf \]; \
                   if \{!\[string equal \$tempfile \"\"\]\} \{ \
                     set ${ns}::guiState($psfkey) \$tempfile; \
                   \};" \
        ] -row $row -column 2 -sticky e
  incr row
  
  grid [label $win.pdblabel -text "PDB: "] \
    -row $row -column 0 -sticky w
  grid [entry $win.pdbpath -width 30 \
          -textvariable ${ns}::guiState($pdbkey)] \
    -row $row -column 1 -sticky ew
  grid [button $win.pdbbutton -text "Browse" \
         -command "set tempfile \[tk_getOpenFile -defaultextension .pdb \]; \
                   if \{!\[string equal \$tempfile \"\"\]\} \{ \
                     set ${ns}::guiState($pdbkey) \$tempfile \
                   \};" \
        ] -row $row -column 2 -sticky e
  incr row
}

proc ::inorganicBuilder::guiDrawBasisFrame { ns win } {
  frame $win
  set row 0
  grid columnconfigure $win { 0 2 4 } -weight 0
  grid columnconfigure $win { 1 3 5 } -weight 1

  grid [label $win.origlabel -text "Origin:"] \
    -row $row -column 0 -columnspan 6 -sticky w
  incr row
  
  grid [label $win.xoriglabel -text "X:"] \
    -row $row -column 0 -sticky e
  grid [entry $win.xorig -width 5 -textvariable ${ns}::guiState(origX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  grid [label $win.yoriglabel -text "Y:"] -row $row -column 2 -sticky e
  grid [entry $win.yorig -width 5 -textvariable ${ns}::guiState(origY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 3 -sticky ew -padx 4
  grid [label $win.zoriglabel -text "Z:"] -row $row -column 4 -sticky e
  grid [entry $win.zorig -width 5 -textvariable ${ns}::guiState(origZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 5 -sticky ew -padx 4
  incr row

  grid [label $win.basislabel -text "Basis vectors:"] \
    -row $row -column 0 -columnspan 4 -sticky w
  grid [button $win.getbasis -text "Get Basis from PDB" \
    -command "${ns}::guiFindBasisFromPDB" ] \
    -row $row -column 4 -columnspan 2 -sticky e
  incr row

  grid [label $win.axlabel -text "A X:"] \
    -row $row -column 0 -sticky e
  grid [entry $win.ax -width 5 -textvariable ${ns}::guiState(boxAX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  grid [label $win.aylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [entry $win.ay -width 5 -textvariable ${ns}::guiState(boxAY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 3 -sticky ew -padx 4
  grid [label $win.azlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [entry $win.az -width 5 -textvariable ${ns}::guiState(boxAZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 5 -sticky ew -padx 4
  incr row

  grid [label $win.bxlabel -text "B X:"] \
    -row $row -column 0 -sticky e
  grid [entry $win.bx -width 5 -textvariable ${ns}::guiState(boxBX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  grid [label $win.bylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [entry $win.by -width 5 -textvariable ${ns}::guiState(boxBY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 3 -sticky ew -padx 4
  grid [label $win.bzlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [entry $win.bz -width 5 -textvariable ${ns}::guiState(boxBZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 5 -sticky ew -padx 4
  incr row

  grid [label $win.cxlabel -text "C X:"] \
    -row $row -column 0 -sticky e
  grid [entry $win.cx -width 5 -textvariable ${ns}::guiState(boxCX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  grid [label $win.cylabel -text "Y:"] -row $row -column 2 -sticky e
  grid [entry $win.cy -width 5 -textvariable ${ns}::guiState(boxCY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 3 -sticky ew -padx 4
  grid [label $win.czlabel -text "Z:"] -row $row -column 4 -sticky e
  grid [entry $win.cz -width 5 -textvariable ${ns}::guiState(boxCZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 5 -sticky ew -padx 4
  incr row
  return
}


proc ::inorganicBuilder::guiFindBasisFromPDB { } {
  variable guiState

  if {![info exists guiState(pdbfile)] 
      || [string equal $guiState(pdbfile) ""] } {
    tk_messageBox -icon error -message \
      "Specify a PDB file first before attempting to find the cell basis." \
      -type ok  
    return;
  }
  if { [catch {set molid \
          [mol new $guiState(pdbfile) autobonds off filebonds off waitfor all] \
              } ] } {
    tk_messageBox -icon error -message \
      "Error reading PDB file. Check path and try again." \
      -type ok
    return
  }
  
  if {[catch {set basis [findBasisVectors $molid]} ] } {
    tk_messageBox -icon error -message \
      "Could not obtain basis vectors from that file." \
      -type ok
    return
  }
  
  foreach { o a b c } $basis {}
  foreach { guiState(origX) guiState(origY) guiState(origZ) } $o {}
  foreach { guiState(boxAX) guiState(boxAY) guiState(boxAZ) } $a {}
  foreach { guiState(boxBX) guiState(boxBY) guiState(boxBZ) } $b {}
  foreach { guiState(boxCX) guiState(boxCY) guiState(boxCZ) } $c {}

  mol delete $molid
}

proc ::inorganicBuilder::guiRepackSelectMol { } {
  set aw ".ibselectmol"
  grid $aw.type -row 0
  grid $aw.buttons -row 2
#  puts "InorganicBuilder)Repacking select mol"
}

proc ::inorganicBuilder::guiAddBlockParams { f } {
  variable guiState
  set ns [namespace current]
  
  if { [winfo exists $f] } {
    destroy $f
  }
  
  set elemlist { addOrigX addOrigY addOrigZ \
               addSideAX addSideAY addSideAZ \
               addSideBX addSideBY addSideBZ \
               addSideCX addSideCY addSideCZ \
               addRadius }

  foreach elemname $elemlist {
    if {![info exists guiState($elemname)] 
        || ![string is double -strict $guiState($elemname) ]} {
      set guiState($elemname) 0
    }
  }
  
  frame $f
  set row 0
  set guiState(addBlockName) \
    "Block [expr [llength $guiState(blocklist)] + [llength $guiState(selectionlist)]]"
  grid [label $f.namelabel -text "Block name:" ] \
    -row $row -column 0 -sticky w
  grid [entry $f.name -width 5 \
    -textvariable ${ns}::guiState(addBlockName)] \
    -row $row -column 1 -columnspan 5 -sticky ew -padx 4
  incr row
  
  set type $guiState(addBlockType)
  if { [string equal $type "pp"] } {
    grid [label $f.xoriglabel -text "Origin X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 5 \
      -textvariable ${ns}::guiState(addOrigX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.yoriglabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.yorig -width 5 \
      -textvariable ${ns}::guiState(addOrigY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.zoriglabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.zorig -width 5 \
      -textvariable ${ns}::guiState(addOrigZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.sideaxlabel -text "Side A X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.sideax -width 5 \
      -textvariable ${ns}::guiState(addSideAX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.sideaylabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.sideay -width 5 \
      -textvariable ${ns}::guiState(addSideAY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.sideazlabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.sideaz -width 5 \
      -textvariable ${ns}::guiState(addSideAZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.sidebxlabel -text "Side B X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.sidebx -width 5 \
      -textvariable ${ns}::guiState(addSideBX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.sidebylabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.sideby -width 5 \
      -textvariable ${ns}::guiState(addSideBY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.sidebzlabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.sidebz -width 5 \
      -textvariable ${ns}::guiState(addSideBZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.sidecxlabel -text "Side C X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.sidecx -width 5 \
      -textvariable ${ns}::guiState(addSideCX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.sidecylabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.sidecy -width 5 \
      -textvariable ${ns}::guiState(addSideCY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.sideczlabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.sidecz -width 5 \
      -textvariable ${ns}::guiState(addSideCZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
  } elseif { [string equal $type "cylinder"] } {
    grid [label $f.xoriglabel -text "Bottom center X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 5 \
      -textvariable ${ns}::guiState(addOrigX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.yoriglabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.yorig -width 5 \
      -textvariable ${ns}::guiState(addOrigY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.zoriglabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.zorig -width 5 \
      -textvariable ${ns}::guiState(addOrigZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.sideaxlabel -text "Top center X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.sideax -width 5 \
      -textvariable ${ns}::guiState(addSideAX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.sideaylabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.sideay -width 5 \
      -textvariable ${ns}::guiState(addSideAY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.sideazlabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.sideaz -width 5 \
      -textvariable ${ns}::guiState(addSideAZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.radiuslabel -text "Radius:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.radius -width 5 \
      -textvariable ${ns}::guiState(addRadius) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    incr row
    
  } elseif { [string equal $type "sphere"] } {
    grid [label $f.xoriglabel -text "Center X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 5 \
      -textvariable ${ns}::guiState(addOrigX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.yoriglabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.yorig -width 5 \
      -textvariable ${ns}::guiState(addOrigY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.zoriglabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.zorig -width 5 \
      -textvariable ${ns}::guiState(addOrigZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.radiuslabel -text "Radius:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.radius -width 5 \
      -textvariable ${ns}::guiState(addRadius) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    incr row
    
  } elseif { [string equal $type "cone"] } {
    grid [label $f.xoriglabel -text "Base X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 5 \
      -textvariable ${ns}::guiState(addOrigX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.yoriglabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.yorig -width 5 \
      -textvariable ${ns}::guiState(addOrigY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.zoriglabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.zorig -width 5 \
      -textvariable ${ns}::guiState(addOrigZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row

    grid [label $f.sideaxlabel -text "Apex X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.sideax -width 5 \
      -textvariable ${ns}::guiState(addSideAX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.sideaylabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.sideay -width 5 \
      -textvariable ${ns}::guiState(addSideAY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.sideazlabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.sideaz -width 5 \
      -textvariable ${ns}::guiState(addSideAZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.radiuslabel -text "Radius:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.radius -width 5 \
      -textvariable ${ns}::guiState(addRadius) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    incr row
    
  } elseif { [string equal $type "th"] } {
    grid [label $f.xoriglabel -text "Corner X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 5 \
      -textvariable ${ns}::guiState(addOrigX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.yoriglabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.yorig -width 5 \
      -textvariable ${ns}::guiState(addOrigY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.zoriglabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.zorig -width 5 \
      -textvariable ${ns}::guiState(addOrigZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    grid [label $f.sideaxlabel -text "Side A X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.sideax -width 5 \
      -textvariable ${ns}::guiState(addSideAX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.sideaylabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.sideay -width 5 \
      -textvariable ${ns}::guiState(addSideAY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.sideazlabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.sideaz -width 5 \
      -textvariable ${ns}::guiState(addSideAZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.sidebxlabel -text "Side B X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.sidebx -width 5 \
      -textvariable ${ns}::guiState(addSideBX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.sidebylabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.sideby -width 5 \
      -textvariable ${ns}::guiState(addSideBY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.sidebzlabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.sidebz -width 5 \
      -textvariable ${ns}::guiState(addSideBZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
    
    grid [label $f.sidecxlabel -text "Side C X:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.sidecx -width 5 \
      -textvariable ${ns}::guiState(addSideCX) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 1 -sticky ew -padx 4
    grid [label $f.sidecylabel -text " Y:"] -row $row -column 2 -sticky w
    grid [entry $f.sidecy -width 5 \
      -textvariable ${ns}::guiState(addSideCY) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 3 -sticky ew -padx 4
    grid [label $f.sideczlabel -text " Z:"] -row $row -column 4 -sticky w
    grid [entry $f.sidecz -width 5 \
      -textvariable ${ns}::guiState(addSideCZ) \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
      -row $row -column 5 -sticky ew -padx 4
    incr row
  } elseif { [string equal $type "selection"] } {
    grid [label $f.xoriglabel -text "VMD Selection:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 20 \
      -textvariable ${ns}::guiState(addSelection)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4
    incr row
    
  } elseif { [string equal $type "dxfile"] } {
    grid [label $f.xoriglabel -text "DX File:"] \
      -row $row -column 0 -sticky w

    grid [button $f.xorig -width 20 -text "Browse" \
            -command "set tempfile \[tk_getOpenFile -defaultextension .dx\]; \
                      if \{!\[string equal \$tempfile \"\"\]\} \{ \
                        set ${ns}::guiState(addDXFiletemp) \$tempfile; \
                     \};" \
         ] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4
    incr row    
    grid [entry $f.xorigg -width 20 \
      -textvariable ${ns}::guiState(addDXFiletemp)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4
    incr row    
        
  }


  grid [label $f.menulabel -text "Include/Exclude:"] \
    -row $row -column 0 -sticky w
  grid [menubutton $f.menub \
    -menu $f.menub.menu -relief raised] \
    -row $row -column 1 -columnspan 5 -sticky ew -padx 4
    
  menu $f.menub.menu -tearoff no
  $f.menub config -width 20
  
  $f.menub.menu add command -label Exclude \
    -command "$f.menub configure -text Exclude; \
              set ${ns}::guiState(addGenericInclude) 0;"
  $f.menub.menu add command -label "Include only" \
    -command "$f.menub configure -text \"Include only\"; \
              set ${ns}::guiState(addGenericInclude) 1;"
  if { $guiState(addGenericInclude) } {
    $f.menub configure -text "Include only"
  } else {
    $f.menub configure -text "Exclude"
  }
       
  incr row    
  
  guiRepackAdd
}

# *** ADDED ***

proc ::inorganicBuilder::guiAddStructParams { f } {
  variable guiState
  set ns [namespace current]
  set psfkey_struct "psffile_struct"
  set pdbkey_struct "pdbfile_struct"
  set guiState(addPEGTypes) $guiState(PEGTypes)
  set guiState(addDNATypes) $guiState(DNATypes)
  
  if { [winfo exists $f] } {
    destroy $f
  }
  
  set elemlist { addPEGLength addDNALength addCustomSurfDetail addCustomStructDetail addMoleculeOrientX\
  addMoleculeOrientY addMoleculeOrientZ }

  foreach elemname $elemlist {
    if {![info exists guiState($elemname)] 
        || ![string is double -strict $guiState($elemname) ]} {
      set guiState($elemname) 0
    }
  }
  if { $guiState(addPEGLength) == "" || $guiState(addPEGLength) == "1" || $guiState(addPEGLength) == "0" } {
    set guiState(addPEGLength) 2
  }
  if { $guiState(addDNALength) == "" || $guiState(addDNALength) == "1" || $guiState(addDNALength) == "0" } {
    set guiState(addDNALength) 10
  }
  
  
  frame $f
  set row 0
  set guiState(addStructName) \
    "Struct [expr [llength $guiState(structlist)] + [llength $guiState(selectionlist_structs)]]"
  grid [label $f.namelabel -text "Structure name:" ] \
    -row $row -column 0 -sticky w
  grid [entry $f.name -width 5 \
    -textvariable ${ns}::guiState(addStructName)] \
    -row $row -column 1 -columnspan 5 -sticky ew -padx 4
  incr row


  grid [label $f.sda -text "Flip Structure Direction:"] \
    -row $row -column 0 -sticky w
  grid [label $f.sd -text ""] \
    -row $row -column 2 -sticky w
  grid [radiobutton $f.sd.sd1 \
	    -variable ${ns}::guiState(buildInside) -value "1" \
	    -text "Yes" \
	    -anchor e] \
    -row $row -column 3 -sticky ew -padx 4
  grid [radiobutton $f.sd.sd2 \
	    -variable ${ns}::guiState(buildInside) -value "0" \
	    -text "No" \
	    -anchor e] \
    -row $row -column 4 -sticky ew -padx 4
  incr row


  
  set type $guiState(addStructType)
  if { [string equal $type "peg"] } {
    grid [label $f.xoriglabel -text "PEG Chain Length:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 20 \
      -textvariable ${ns}::guiState(addPEGLength)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4       
    incr row


    grid [label $f.pegslabel -text "Available Atom Types for PEG are: $guiState(PEGTypes)"] \
      -row $row -column 0 -sticky w
    incr row 

    grid [label $f.selectslabel -text "Atom Type Selections (i.e. AU H C):"] \
      -row $row -column 0 -sticky w
    grid [entry $f.selects -width 20 \
      -textvariable ${ns}::guiState(addPEGTypes)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4       
    incr row

    
  } elseif { [string equal $type "dna"] } {
	  
	  	  
    grid [label $f.xstrandlabela -text "Strand Type:"] \
      -row $row -column 0 -sticky w
    grid [label $f.xstrandlabel -text ""] \
      -row $row -column 2 -sticky w
    grid [radiobutton $f.xstrandlabel.strand1 \
          -variable ${ns}::guiState(addDNAStrand) -value "1" \
          -text "Single" \
          -anchor e] \
      -row $row -column 3 -sticky ew -padx 4
    grid [radiobutton $f.xstrandlabel.strand2 \
          -variable ${ns}::guiState(addDNAStrand) -value "2" \
          -text "Double" \
          -anchor e] \
      -row $row -column 4 -sticky ew -padx 4
    incr row

    grid [label $f.xoriglabel -text "DNA Nucleotide Number:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 20 \
      -textvariable ${ns}::guiState(addDNALength)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4       
    incr row

    grid [label $f.xoriglabelb -text "DNA Sequence (i.e. 'ATCG...'):"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorigb -width 20 \
      -textvariable ${ns}::guiState(addDNASEQ)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4       
    incr row

    grid [label $f.dnaslabel -text "Available Atom Types for DNA are: $guiState(DNATypes)"] \
      -row $row -column 0 -sticky w
    incr row 

    grid [label $f.selectslabel -text "Atom Type Selections (i.e. AU H C):"] \
      -row $row -column 0 -sticky w
    grid [entry $f.selects -width 20 \
      -textvariable ${ns}::guiState(addDNATypes)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4       
    incr row

    
  } elseif { [string equal $type "custom"] } {


    grid [label $f.psflabel -text "PSF: "] \
      -row $row -column 0 -sticky w
    grid [entry $f.psfpath -width 30 \
          -textvariable ${ns}::guiState($psfkey_struct)] \
      -row $row -column 1 -sticky ew
    grid [button $f.psfbutton -text "Browse" \
           -command "set tempfile \[tk_getOpenFile -defaultextension .psf \]; \
                     if \{!\[string equal \$tempfile \"\"\]\} \{ \
                       set ${ns}::guiState($psfkey_struct) \$tempfile; \
                     \};" \
          ] -row $row -column 2 -sticky e
    incr row
	  
    grid [label $f.pdblabel -text "PDB: "] \
      -row $row -column 0 -sticky w
    grid [entry $f.pdbpath -width 30 \
            -textvariable ${ns}::guiState($pdbkey_struct)] \
      -row $row -column 1 -sticky ew
    grid [button $f.pdbbutton -text "Browse" \
           -command "set tempfile \[tk_getOpenFile -defaultextension .pdb \]; \
                     if \{!\[string equal \$tempfile \"\"\]\} \{ \
                       set ${ns}::guiState($pdbkey_struct) \$tempfile \
	                   \};" \
          ] -row $row -column 2 -sticky e
    incr row

    grid [label $f.xoriglabel -text "Surface Atom Selection:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig -width 20 \
      -textvariable ${ns}::guiState(addCustomSurfDetail)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4       
    incr row
    
    grid [label $f.xoriglabel2 -text "Structure-Tail Atom Selection:"] \
      -row $row -column 0 -sticky w
    grid [entry $f.xorig2 -width 20 \
      -textvariable ${ns}::guiState(addCustomStructDetail)] \
      -row $row -column 1 -columnspan 4 -sticky ew -padx 4       
    incr row
  }
    
  
  guiRepackStructAdd
}



proc ::inorganicBuilder::guiRepackAdd { } {
  set aw ".ibaddblock"
  grid $aw.type -row 0
  grid $aw.params -row 1
  grid $aw.buttons -row 2
}

# *** ADDED ***
proc ::inorganicBuilder::guiRepackStructAdd { } {
  set aw ".ibaddstruct"
  grid $aw.type -row 0
  grid $aw.params -row 1
  grid $aw.body -row 4
  grid $aw.buttons -row 9
}

# *** ADDED ***
proc ::inorganicBuilder::guiRepackRunNAMD { } {
  set aw ".ibrunnamd"
  grid $aw.type -row 0
  grid $aw.body -row 5
  grid $aw.buttons0 -row 9
  grid $aw.buttons -row 15
}

proc ::inorganicBuilder::guiAddBondWin {} {
  variable guiState
  
  if { [winfo exists .ibaddbond] } {
    destroy .ibaddbond
  }
  set aw [toplevel ".ibaddbond"]
  wm title $aw "Add Bond"
  wm resizable $aw yes yes
  grab set ".ibaddbond"
  set ns [namespace current]

  # Load specified molecule to get atom type list
  if { [string equal $guiState(psffile) ""] \
       || [string equal $guiState(pdbfile) ""] } {
    tk_messageBox -icon info -message \
      "Please specify a molecule before adding bond specifications." \
    -type ok
    destroy $aw
    return
  }

  set molid [mol new]
  if { [catch \
         {mol addfile $guiState(psffile) type psf autobonds off waitfor all} \
       ] } {
    tk_messageBox -icon error -message \
      "There was a problem processing $guiState(psffile). Please specify a \
       valid PSF file" \
    -type ok
    mol delete $molid
    destroy $aw
    return
  }
  if { [catch \
         {mol addfile $guiState(pdbfile) type pdb autobonds off waitfor all} \
       ] } {
    tk_messageBox -icon error -message \
      "There was a problem processing $guiState(pdbfile). Please specify a \
       valid PDB file" \
    -type ok
    mol delete $molid
    destroy $aw
    return
  }

  set select [atomselect top all]
  set typelist [lsort -unique [$select get type] ]
  $select delete
  mol delete $molid
  
  set row 0
  grid [label $aw.atom1label -text "Atom 1:" ] \
    -row $row -column 0 -sticky w
  grid [menubutton $aw.menub1 -menu $aw.menub1.menu -relief raised] \
    -row $row -column 1 -sticky ew -padx 4 -ipady 4
  incr row

  grid [label $aw.atom2label -text "Atom 2:" ] \
    -row $row -column 0 -sticky w
  grid [menubutton $aw.menub2 -menu $aw.menub2.menu -relief raised] \
    -row $row -column 1 -sticky ew -padx 4 -ipady 4
  incr row
  
  grid [label $aw.cutofflabel -text "Bond length:" ] \
    -row $row -column 0 -sticky w
  grid [entry $aw.cutoff -width 5 -textvariable ${ns}::guiState(bondcutoff)  \
            -validate all \
            -vcmd "${ns}::guiRequireDouble %W %P %V" \
          ] \
    -row $row -column 1 -sticky ew -padx 4
  incr row
    
  grid [button $aw.add -text Add \
    -command "${ns}::guiStoreBond; destroy $aw"] \
    -row $row -column 0 -padx 4
  grid [button $aw.cancel -text Cancel -command "destroy $aw"] \
    -row $row -column 1 -padx 4
  menu $aw.menub1.menu -tearoff no
  $aw.menub1 config -width 20

  menu $aw.menub2.menu -tearoff no
  $aw.menub2 config -width 20

  set ntypes [llength $typelist]
  for {set i 0} { $i < $ntypes } { incr i } {
    set thistype [lindex $typelist $i]
    
    $aw.menub1.menu add command -label $thistype \
      -command "$aw.menub1 configure -text $thistype; \
                set ${ns}::guiState(bondAtom1) $thistype"
    $aw.menub2.menu add command -label $thistype \
      -command "$aw.menub2 configure -text $thistype; \
                set ${ns}::guiState(bondAtom2) $thistype"
  }

  set guiState(bondAtom1) [lindex $typelist 0]
  $aw.menub1 configure -text [lindex $typelist 0]
  set guiState(bondAtom2) [lindex $typelist 0]
  $aw.menub2 configure -text [lindex $typelist 0]
}

proc ::inorganicBuilder::guiCreateBox { } {
  variable guiState
  
  if { ![info exists guiState(material)] } {
    set matlist [lsort -index 1 [ getMaterialNames ]]
    set guiState(material) [lindex $matlist 0 0 ]
  }
  set material $guiState(material)
  
  set ox 0
  if { [info exists guiState(origX) ]
       && [string is double -strict $guiState(origX)] } {
    set ox $guiState(origX)
  }
  set oy 0
  if { [info exists guiState(origY) ]
       && [string is double -strict $guiState(origY)] } {
    set oy $guiState(origY)
  }
  set oz 0
  if { [info exists guiState(origZ) ]
       && [string is double -strict $guiState(origZ)] } {
    set oz $guiState(origZ)
  }
  
  set o [list $ox $oy $oz]

  if { $guiState(hexBox) } {
    set diam 1
    if { [info exists guiState(hexD) ] 
         && [string is integer -strict $guiState(hexD)]
         && [expr $guiState(hexD) > 0] } {
      set diam $guiState(hexD)
    }
    set height 1
    if { [info exists guiState(boxZ) ] 
         && [string is integer -strict $guiState(boxZ)]
         && [expr $guiState(boxZ) > 0] } {
      set height $guiState(boxZ)
    }
    set guiState(currentBox) [ newMaterialHexagonalBox \
                               $material $o $diam $height $guiState(adjcharge)]
  } else {
    set bx 1
    if { [info exists guiState(boxX) ] 
         && [string is integer -strict $guiState(boxX)]
         && [expr $guiState(boxX) > 0] } {
      set bx $guiState(boxX)
    }
    set by 1
    if { [info exists guiState(boxY) ] 
         && [string is integer -strict $guiState(boxY)]
         && [expr $guiState(boxY) > 0] } {
      set by $guiState(boxY)
    }
    set bz 1
    if { [info exists guiState(boxZ) ] 
         && [string is integer -strict $guiState(boxZ)]
         && [expr $guiState(boxZ) > 0] } {
      set bz $guiState(boxZ)
    }
    set boxsize [list $bx $by $bz]
    set guiState(currentBox) [ newMaterialBox $material $o $boxsize \
                                 $guiState(adjcharge)]
  }

  set basis [::inorganicBuilder::getCellBasisVectors $guiState(currentBox)]
  set guiState(boxAX) [lindex $basis 0 0]
  set guiState(boxAY) [lindex $basis 0 1]
  set guiState(boxAZ) [lindex $basis 0 2]
  set guiState(boxBX) [lindex $basis 1 0]
  set guiState(boxBY) [lindex $basis 1 1]
  set guiState(boxBZ) [lindex $basis 1 2]
  set guiState(boxCX) [lindex $basis 2 0]
  set guiState(boxCY) [lindex $basis 2 1]
  set guiState(boxCZ) [lindex $basis 2 2]
  set guiState(boxOX) [lindex $basis 3 0]
  set guiState(boxOY) [lindex $basis 3 1]
  set guiState(boxOZ) [lindex $basis 3 2]
  set guiState(bondCutoff) [::inorganicBuilder::getBondCutoff \
                              $guiState(currentBox)]
                              
  set vertlist [getVertices $guiState(currentBox)]
  foreach { x y z } [lindex $vertlist 0] {}
  set guiState(boxXmin) $x
  set guiState(boxXmax) $x
  set guiState(boxYmin) $y
  set guiState(boxYmax) $y
  set guiState(boxZmin) $z
  set guiState(boxZmax) $z
  foreach vert $vertlist {
    foreach { x y z } $vert {}
    if {$x < $guiState(boxXmin)} {
      set guiState(boxXmin) $x
    }
    if {$x > $guiState(boxXmax)} {
      set guiState(boxXmax) $x
    }
    if {$y < $guiState(boxYmin)} {
      set guiState(boxYmin) $y
    }
    if {$y > $guiState(boxYmax)} {
      set guiState(boxYmax) $y
    }
    if {$z < $guiState(boxZmin)} {
      set guiState(boxZmin) $z
    }
    if {$z > $guiState(boxZmax)} {
      set guiState(boxZmax) $z
    }
  }
  guiDrawBox
  return
}









proc ::inorganicBuilder::guiStoreBlock { } {
  variable guiState
#  puts "InorganicBuilder)Storing block"

  set btype $guiState(addBlockType)
  set bname $guiState(addBlockName)
  if { [string equal $btype "pp"] } {
    set o [list $guiState(addOrigX) $guiState(addOrigY) $guiState(addOrigZ)]
    set a [list $guiState(addSideAX) $guiState(addSideAY) $guiState(addSideAZ)]
    set b [list $guiState(addSideBX) $guiState(addSideBY) $guiState(addSideBZ)]
    set c [list $guiState(addSideCX) $guiState(addSideCY) $guiState(addSideCZ)]
    set myblock [ newBlock $btype $bname [list $a $b $c $o]]
  } elseif { [string equal $btype "cylinder"] } {
    set o [list $guiState(addOrigX) $guiState(addOrigY) $guiState(addOrigZ)]
    set a [list [expr $guiState(addSideAX) - $guiState(addOrigX)] \
                [expr $guiState(addSideAY) - $guiState(addOrigY)] \
                [expr $guiState(addSideAZ) - $guiState(addOrigZ)] ]
    set r $guiState(addRadius)
    set myblock [ newBlock $btype $bname [list $o $a $r]]
  } elseif { [string equal $btype "sphere"] } {
    set o [list $guiState(addOrigX) $guiState(addOrigY) $guiState(addOrigZ)]
    set r $guiState(addRadius)
    set myblock [ newBlock $btype $bname [list $o $r]]
  } elseif {[string equal $btype "cone"] } {
    set o [list $guiState(addOrigX) $guiState(addOrigY) $guiState(addOrigZ)]
    set a [list [expr $guiState(addSideAX) - $guiState(addOrigX)] \
                [expr $guiState(addSideAY) - $guiState(addOrigY)] \
                [expr $guiState(addSideAZ) - $guiState(addOrigZ)] ]
    set r $guiState(addRadius)
    set myblock [ newBlock $btype $bname [list $o $a $r]]
  } elseif {[string equal $btype "th"] } {
    set o [list $guiState(addOrigX) $guiState(addOrigY) $guiState(addOrigZ)]
    set a [list $guiState(addSideAX) $guiState(addSideAY) $guiState(addSideAZ)]
    set b [list $guiState(addSideBX) $guiState(addSideBY) $guiState(addSideBZ)]
    set c [list $guiState(addSideCX) $guiState(addSideCY) $guiState(addSideCZ)]
    set myblock [ newBlock $btype $bname [list [list $a $b $c] $o]]
  } elseif {[string equal $btype "selection"] } {
    set params [list $guiState(addSelection) $guiState(addGenericInclude) ]
    set myblock [ newBlock $btype $bname $params]
  } elseif {[string equal $btype "dxfile"] } {
    set params [list $guiState(addDXFile) $guiState(addGenericInclude) ]
    set myblock [ newBlock $btype $bname $params]
  }
#  drawBlock $myblock
  if {[string equal $btype "selection"]} {
    lappend guiState(selectionlist) $myblock
  } elseif {[string equal $btype "dxfile"]} {
    lappend guiState(selectionlist) $myblock
    set dxmolid [mol new $guiState(addDXFiletemp)]
    mol rename $dxmolid "DXFile$dxmolid"
    lappend guiState(dxlist) $dxmolid
    lappend guiState(addDXFile) $guiState(addDXFiletemp) 
  } else {
    lappend guiState(blocklist) $myblock
  }
  guiBuildDeviceWin
  guiCreateBox
  return
}

# *** ADDED ***
proc ::inorganicBuilder::guiStoreStruct { } {
  variable guiState

  if { $guiState(dens_printer) == "" } {
      return
  }

  set btype $guiState(addStructType)
  set bname $guiState(addStructName)
  set useddense $guiState(dens_printer)
  
  if {[string equal $btype "peg"] } {
    set params [list $guiState(addPEGLength) "placeholder" $useddense]
    set mystruct [ newStruct $btype $bname $params]
  } elseif {[string equal $btype "dna"] } {
    set params [list $guiState(addDNALength) "placeholder" $useddense]
    set mystruct [ newStruct $btype $bname $params]
  } elseif {[string equal $btype "custom"] } {
    set params [list $guiState(addCustomSurfDetail) $guiState(addCustomStructDetail) $useddense]
    set mystruct [ newStruct $btype $bname $params]
  }

  lappend guiState(structlist) $mystruct
  lappend guiState(buildPreviewMode) $guiState(setPreviewMode)
  set guiState(setPreviewMode) -1

  destroy $guiState(awframe)
  guiBuildSurfaceStructsWin
 
  return
}

# *** ADDED ***
proc Kcomb { x y } { set x }
# *** ADDED ***
proc ShuffleList { list } {
    set n [llength $list]
    if {n >= 1} {
        while { $n>0 } {
            set j [expr {int(rand()*$n)}]
            lappend slist [lindex $list $j]
            set list [lreplace [Kcomb $list [set list {}]] $j $j]
            incr n -1
	    }
	    return $slist
    }
}
# *** ADDED ***
proc intersect_list args {
    set res {}
      foreach element [lindex $args 0] {
		  set found 1
		  foreach list [lrange $args 1 end] {
			  if {[lsearch -exact $list $element] < 0} {
				  set found 0; break
			  }
		  }
		  if {$found} {lappend res $element}
	  }
	  set res
	  return $res
  }

# *** ADDED ***
proc subtract_list args {
    set res {}
      foreach element [lindex $args 0] {
		  set found 1
		  foreach list [lrange $args 1 end] {
			  if {[lsearch -exact $list $element] < 0} {
				  set found 0; break
			  }
		  }
		  if {!$found} {lappend res $element}
	  }
	  set res
	  return $res
  }

# *** ADDED ***
proc ::inorganicBuilder::guiHighlightStruct {mode} {
  variable guiState
  variable homePath

#  display update off

  if { $guiState(addStructType) == "dna" } {

       source [file normalize [file join $homePath "mkDNA" "mkDNA.tcl"]]
       set pegname DNA$guiState(addDNALength)


       mkDNA $guiState(addDNAStrand) $guiState(addDNALength) $pegname $homePath $guiState(addDNASEQ)
       set guiState(pdbfile_struct) $pegname.pdb
       set guiState(psffile_struct) $pegname.psf

       set molid $guiState(currentMol)
       if { ![string equal $guiState(setVMDSelSurf) ""] } {
		   set vsurf_atomsel [atomselect $molid $guiState(setVMDSelSurf)]
           set usurf_atomsel [atomselect $molid [concat "index" $guiState(surfacearea)\
           "and beta == 0"]]
           
           set vsurface_area [ $vsurf_atomsel get index ]
           set usurface_area [ $usurf_atomsel get index ]
           set dsurface_area [ intersect_list $vsurface_area $usurface_area ]
           
           $vsurf_atomsel delete
           $usurf_atomsel delete

           set dsurface_area [subtract_list $dsurface_area $guiState(global_useddense)]

		   } else {
			 set dsurf_atomsel [atomselect $molid [concat "index" $guiState(surfacearea)\
			 "and beta == 0"]]
			 set dsurface_area [ $dsurf_atomsel get index ]
			 $dsurf_atomsel delete
             set dsurface_area [subtract_list $dsurface_area $guiState(global_useddense)]
		   }


# Filter out for only requested element types (DNA)
       if { $dsurface_area == "" } {
         tk_messageBox -icon error -message \
           "No valid construction atoms in current selection" \
           -type ok  
           set guiState(dens_printer) ""
         return;
       }
       set dsa_index 0
       set dsa_sel [atomselect $molid [concat "index" $dsurface_area]]
       foreach dsaname [$dsa_sel get name] {
           set dsa_name [lindex [split $dsaname {[1,2,3,4,5,6,7,8,9]}] 0]

           if { [intersect_list $guiState(addDNATypes) $dsa_name] == "" } {
             set dsurface_area [lreplace $dsurface_area $dsa_index $dsa_index]
             incr dsa_index -1
           }
           incr dsa_index 1
	   }
	   $dsa_sel delete
	  

  } elseif { $guiState(addStructType) == "peg" } {
     
       source [file normalize [file join $homePath "mkPEG" "mkPEG.tcl"]]
       set pegname PEG$guiState(addPEGLength)
       
       mkPEG $guiState(addPEGLength) $pegname $homePath
       set guiState(pdbfile_struct) $pegname.pdb
       set guiState(psffile_struct) $pegname.psf

       set molid $guiState(currentMol)
       if { ![string equal $guiState(setVMDSelSurf) ""] } {
		   set vsurf_atomsel [atomselect $molid $guiState(setVMDSelSurf)]
           set usurf_atomsel [atomselect $molid [concat "index" $guiState(surfacearea)\
           "and beta == 0"]]
           
           set vsurface_area [ $vsurf_atomsel get index ]
           set usurface_area [ $usurf_atomsel get index ]
           set dsurface_area [ intersect_list $vsurface_area $usurface_area ]
           
           $vsurf_atomsel delete
           $usurf_atomsel delete

           set dsurface_area [subtract_list $dsurface_area $guiState(global_useddense)]
		   } else {
			 set dsurf_atomsel [atomselect $molid [concat "index" $guiState(surfacearea)\
			 "and beta == 0"]]
			 set dsurface_area [ $dsurf_atomsel get index ]
			 $dsurf_atomsel delete
             set dsurface_area [subtract_list $dsurface_area $guiState(global_useddense)]
		   }


# Filter out for only requested element types (PEG)
       if { $dsurface_area == "" } {
         tk_messageBox -icon error -message \
           "No valid construction atoms in current selection" \
           -type ok  
           set guiState(dens_printer) ""
         return;
       }
       set dsa_index 0
       set dsa_sel [atomselect $molid [concat "index" $dsurface_area]]
       foreach dsaname [$dsa_sel get name] {
           set dsa_name [lindex [split $dsaname {[1,2,3,4,5,6,7,8,9]}] 0]
 
           if { [intersect_list $guiState(addPEGTypes) $dsa_name] == "" } {
             set dsurface_area [lreplace $dsurface_area $dsa_index $dsa_index]
             incr dsa_index -1
           }
           incr dsa_index 1
	   }
	   $dsa_sel delete


  }

  if { $guiState(addStructType) != "custom" } {

  # choose a starting, valid placement point by shuffling the surface area points. 

       if { $dsurface_area == "" } {		   
         tk_messageBox -icon error -message \
           "No valid construction atoms in current selection" \
           -type ok  
         set guiState(dens_printer) ""
         return;
       }
       

       set ssurface_area [ShuffleList $dsurface_area]         
       set ssurface_area [lindex $ssurface_area 0]
       set guiState(addCustomSurfDetail) $ssurface_area

       set guiState(temp_surfacearea) $dsurface_area
       ::inorganicBuilder::DensityPDBGen $ssurface_area
       if {$guiState(answer) == "no"} {
		   set guiState(densearea) ""
	   }

       if { $guiState(densearea) == "" } {
		 if { $guiState(answer) != "no" } {
         tk_messageBox -icon error -message \
           "No valid construction atoms in current selection" \
           -type ok  
         }
         set guiState(dens_printer) ""
         return;
       }
       

       if { [string equal "$mode" "1"] } {
         if { $guiState(previous_densearea) != "" } {
         set guiState(densearea) $guiState(previous_densearea)
         set guiState(addCustomSurfDetail) $guiState(previous_SurfDetail)
         set guiState(temp_surfacearea) $guiState(previous_tempsurf) 
         set guiState(previous_densearea) {}
         }
         ::inorganicBuilder::AlignDense
         set dens_printer [lsort -dictionary $guiState(densearea)]
         set guiState(dens_printer) $dens_printer
         set guiState(global_useddense) $dens_printer
         foreach built_structure $guiState(structlist) {
           set guiState(global_useddense) [concat $guiState(global_useddense) [lindex [lindex $built_structure 2] 2]]
		 }

       }

  # guiState(densearea) has the list of atoms that are found relating to density      
       set dens_printer [lsort -dictionary $guiState(densearea)]

    }


  
  if {![info exists guiState(pdbfile_struct)] 
      || [string equal $guiState(pdbfile_struct) ""] } {
    tk_messageBox -icon error -message \
      "You must at least specify a PDB file to add." \
      -type ok  
    return;
  }
  if { [catch {set struct_catch \
          [mol new $guiState(pdbfile_struct) autobonds off filebonds off waitfor all] \
              } ] } {
    tk_messageBox -icon error -message \
      "Error reading PDB file. Check path and try again." \
      -type ok
    return
  }

  mol delete $struct_catch

#Build the structure requested and visually place it on the surface (not attached yet)
  if { [string equal "$mode" "1"] } {		  
	    mol delete $guiState(setPreviewMode)
	    set structmolid [mol new $guiState(pdbfile_struct)]
	    set guiState(setPreviewMode) $structmolid
	  }

  
  #align selected atoms
  set molid $guiState(currentMol)

  set guiState(structMol) $structmolid
  set guiState(PreviewMode) $structmolid

  mol top $guiState(getSurfMol)
  display resetview
  display update on
  mol top $molid

  return
}

# *** ADDED ***
proc ::inorganicBuilder::DensityPDBGen { start_atom } {
  variable guiState
  
  set molid $guiState(currentMol)
  set placement_index {}
  set usable_surface $guiState(temp_surfacearea)

 

  # fairly quick shuffle, so do it a couple extra times for better randomization
  set usable_surface [ShuffleList $usable_surface]
  set usable_surface [ShuffleList $usable_surface]
  set usable_surface [ShuffleList $usable_surface]

  set max_count_dens -1
  set read_dex 0


  if {$guiState(setDensityVal) == ""} {
	  set guiState(setDensityVal) 0
  }
  if {$guiState(setDensitySpacing) == ""} {
	  set guiState(setDensitySpacing) 0
  }


  set spacer [expr $guiState(setDensitySpacing) * 10]
  if {$spacer != 0} {
#	  build the data structure which will speed up list exclusions
		array unset spacer_usable_surface
		array set spacer_usable_surface {}
		foreach k $usable_surface {
			set spacer_usable_surface($k) $k
		}

  }
  
  set read_surface_area [atomselect $molid all]
  set surfacearea_nm2 [expr [measure sasa 1.44 $read_surface_area] * 0.01]
  $read_surface_area delete

  set max_count_dens [expr $guiState(setDensityVal) * $surfacearea_nm2]
  set guiState(snm2) $surfacearea_nm2
  set imcd [expr int($max_count_dens)]

# Select viable atoms as long as there are more atoms to place which are valid  
  while { ($start_atom != "") && ([llength $placement_index] != $imcd) && ($usable_surface != "") } {

      if { ($spacer != 0) } {
		set rad_sel [atomselect $molid "within $spacer of index $start_atom"]
        set radius_surf [$rad_sel get index]

        if { [llength $radius_surf] > 1} {
			foreach k $radius_surf {
		        if { [info exists spacer_usable_surface($k)] } {
					unset spacer_usable_surface($k)
				}
			}
		}
		
        $rad_sel delete

      # set next_usable_start $usable_surface
        if { [array size spacer_usable_surface] != 0 } {
          set pop [array startsearch spacer_usable_surface]
          set start_atom [array nextelement spacer_usable_surface $pop]
          array donesearch spacer_usable_surface $pop
          unset spacer_usable_surface($start_atom)			
          lappend placement_index $start_atom
          
  		} else { set start_atom "" }

      } else {
      
      # set next_usable_start $usable_surface
        if { $usable_surface != "" } {
          set start_atom [lindex $usable_surface 0]
          set usable_surface [lreplace $usable_surface 0 0]         
          lappend placement_index $start_atom
		} else { set start_atom "" }
	  }

  }

  set guiState(densearea) $placement_index  
  set catoms [llength $guiState(densearea)]
  set rdensity [expr $catoms / $guiState(snm2)]
  
  if {$imcd != [llength $guiState(densearea)]} {
		
		set guiState(answer) [tk_messageBox -icon info -message \
             "Due to the constraints set only $catoms/$imcd structures can be placed, giving a reduced density of $rdensity. Would you like to continue?" \
             -type yesno]
  } else {
		set guiState(answer) [tk_messageBox -icon info -message \
             "$catoms/$imcd structures can be placed, giving a density of $rdensity. Would you like to continue?" \
             -type yesno]
  }
  

  array unset spacer_usable_surface
  return
}



# *** ADDED ***
proc ::inorganicBuilder::AlignDense { } {
  variable guiState
  variable homePath
  variable surfingPath
  global M_PI  

  mol delete $guiState(linemols)
  
  set molid $guiState(currentMol)
  set densearea $guiState(densearea)
  set structnames {}
  set draw_status {}

  # Part 1, generate triangles as a mesh around the atoms on the surface

  set save_the_axes [axes location]
  axes location off

  set surfacemol $guiState(currentMol)
  foreach moll [molinfo list] {
    lappend draw_status [molinfo $moll get drawn]
    if {$moll != $surfacemol} {
      mol off $moll
    } elseif {$moll == $surfacemol} {
      mol on $moll
    }
  }
  
  # turn off the representations of the atoms too
  for {set i 0} {$i < 2} {incr i} {
    mol showrep $surfacemol $i off
  }


  set identityvpts {
   {{1.000000 0.000000 0.000000 0.000000}
   {0.000000 1.000000 0.000000 0.000000}
   {0.000000 0.000000 1.000000 0.000000}
   {0.000000 0.000000 0.000000 1.000000}}
   {{1.000000 0.000000 0.000000 0.000000}
   {0.000000 1.000000 0.000000 0.000000}
   {0.000000 0.000000 1.000000 0.000000}
   {0.000000 0.000000 0.000000 1.000000}}
   {{1.000000 0.000000 0.000000 0.000000}
   {0.000000 1.000000 0.000000 0.000000}
   {0.000000 0.000000 1.000000 0.000000}
   {0.000000 0.000000 0.000000 1.000000}}
   {{1.000000 0.000000 0.000000 0.000000}
   {0.000000 1.000000 0.000000 0.000000}
   {0.000000 0.000000 1.000000 0.000000}
   {0.000000 0.000000 0.000000 1.000000}}
  }

  set saveView [molinfo $molid get {center_matrix rotate_matrix scale_matrix global_matrix}]
  display update on
  molinfo $molid set {center_matrix rotate_matrix scale_matrix global_matrix} $identityvpts
  render STL "temp_mesh_qs.stl"
  molinfo $molid set {center_matrix rotate_matrix scale_matrix global_matrix} $saveView
  display update off
  axes location $save_the_axes

  # restore the draw statuses
  foreach moll [molinfo list] dstat $draw_status {
    if {$dstat == 1} {
      mol on $moll
    }
  }

  for {set i 0} {$i < 2} {incr i} {
    mol showrep $surfacemol $i on
  }



  set stl_in [open "temp_mesh_qs.stl" r]
  fconfigure $stl_in -buffering line
  gets $stl_in data_input

  set vertices_normals {}
  set avg_verts 0
  set extx_p 0
  set extx_n 0
  set exty_p 0
  set exty_n 0
  set extz_p 0
  set extz_n 0
  
  array unset vertclouds
  array set vertclouds {}
  set vertcloud_keys {}



  while {$data_input != ""} {
    gets $stl_in data_input

    if { ([lindex $data_input 0] != "vertex") } {
      set check_unique -1
    } else {
      gets $stl_in data_input2
      gets $stl_in data_input3
      set check_unique 0
    }
  


    if {$check_unique == 0} {
      set vtx1 "[lindex $data_input 1] [lindex $data_input 2] [lindex $data_input 3]"
      set vtx2 "[lindex $data_input2 1] [lindex $data_input2 2] [lindex $data_input2 3]"
      set vtx3 "[lindex $data_input3 1] [lindex $data_input3 2] [lindex $data_input3 3]"     
      
# compute normal and add to normals list
      set cvtx1 [expr ([lindex $vtx1 0] + [lindex $vtx2 0] + [lindex $vtx3 0])/double(3) ]
      set cvtx2 [expr ([lindex $vtx1 1] + [lindex $vtx2 1] + [lindex $vtx3 1])/double(3) ]
      set cvtx3 [expr ([lindex $vtx1 2] + [lindex $vtx2 2] + [lindex $vtx3 2])/double(3) ]

      set data_line "$cvtx1 $cvtx2 $cvtx3 {$vtx1} {$vtx2} {$vtx3}"
      lappend vertices_normals $data_line
      
      if { $avg_verts == 50 } {
		  
	# save the vert normals + a key
        set sstring "${extx_p}_${extx_n}_${exty_p}_${exty_n}_${extz_p}_${extz_n}"
        set vertclouds($sstring) $vertices_normals
        lappend vertcloud_keys $sstring
        set avg_verts 0
        set extx_p 0
        set extx_n 0
        set exty_p 0
        set exty_n 0
        set extz_p 0
        set extz_n 0
        set vertices_normals {}
        
        
      } 
# Somewhat optimized choice of 50 vertice chunks, but this can be optimized further with a definitive test case!
      if { $avg_verts != 50 } {
        incr avg_verts
        if { $cvtx1 >= $extx_p } {
          set extx_p $cvtx1
        } elseif { $cvtx1 <= $extx_n } {       
          set extx_n $cvtx1
        }
        
        if { $cvtx2 >= $exty_p } {
          set exty_p $cvtx2
        } elseif { $cvtx2 <= $exty_n } {       
          set exty_n $cvtx2
        }

        if { $cvtx3 >= $extz_p } {
          set extz_p $cvtx3
        } elseif { $cvtx3 <= $extz_n } {       
          set extz_n $cvtx3
        }

      }          
    }
  }

# wrap up last set of inputs read
	# save the vert normals + a key		
  set sstring "${extx_p}_${extx_n}_${exty_p}_${exty_n}_${extz_p}_${extz_n}"
  set vertclouds($sstring) $vertices_normals
  lappend vertcloud_keys $sstring
  set vertices_normals {}

# iffy sort ahoy, not sure if this does anything
  set vertcloud_keys [lsort $vertcloud_keys]
  
  close $stl_in


  # Part 2, create and align PDBs for each atom found

  # Generate valid character list
  set string_c_list {}
#  for {set i 128} {$i < 160} {incr i} {
#      lappend string_c_list $i
#  }
#  for {set i 162} {$i < 173} {incr i} {
#      lappend string_c_list $i
#  }
#  for {set i 174} {$i < 256} {incr i} {
#      lappend string_c_list $i
#  }
##  for {set i 48} {$i < 57} {incr i} {
##      lappend string_c_list $i
##  }
  for {set i 65} {$i <= 90} {incr i} {
      lappend string_c_list $i
  }
##  for {set i 97} {$i < 122} {incr i} {
##      lappend string_c_list $i
##  }

  # Also, create the index file for "Attach PEG to Gold" script at this stage.

  set atoms_red 0  

  set countb 0
  set t1 0
  set t2 0
  set tdiff 0
  set catoms [llength $densearea]
  array unset vecnormas
  array set vecnormas {}		 
  
  foreach atom $densearea {

    puts "$countb / $catoms placements made. Last placement took: $tdiff microseconds"
    set tdiff [expr $t2 - $t1]
    set countb [expr $countb + 1]
    set t1 [clock microseconds]	 


  # Generate a unique segname
  #if { [expr [expr $guiState(structureIndex) + 1]%126 ] == 0 } {}
    if { [expr [expr $guiState(structureIndex)]%26 ] == 0 } {
		incr guiState(structureY)
		set guiState(structureZ) 0
    }
  #if { [expr [expr $guiState(structureIndex) + 1]%15876 ] == 0 } {}
    if { [expr [expr $guiState(structureIndex)]%676 ] == 0 } {
		incr guiState(structureX)
		set guiState(structureY) 0
    }

  # set first symbols
      
    set j1z [format %c [lindex $string_c_list $guiState(structureZ)]]

  # set second symbols
    if { ($guiState(structureY) != -1) } {
      set j1y [format %c [lindex $string_c_list $guiState(structureY)]]
    } else {
      set j1y " "
    }

  # set third symbols

    if { $guiState(structureX) != -1 } {
      set j1x [format %c [lindex $string_c_list $guiState(structureX)]]
    } else {
      set j1x " "
	}


    set pegseg "${j1x}${j1y}${j1z}"

    incr guiState(structureIndex)
    incr guiState(structureZ)

    if { $guiState(addStructType) == "dna" } {
      set pegnam DNA$guiState(addDNALength)_$guiState(structureIndex)
    } elseif { $guiState(addStructType) == "peg" } {
      set pegnam PEG$guiState(addPEGLength)_$guiState(structureIndex)
    }
    file copy -force $guiState(pdbfile_struct) $pegnam.pdb
    file copy -force $guiState(psffile_struct) $pegnam.psf
    set current_pdbfile_struct $pegnam.pdb
#    set guiState(pdbfile_struct) $pegname.pdb

#################################################################################
######################## Redo the PDB File with the custom segname ##############
#################################################################################

  # Open the pdb to extract the atom records.

    set out [open ${pegnam}_mod.pdb w]
    set in [open ${pegnam}.pdb r]

    foreach line [split [read $in] \n] {
      set string0 [string range $line 0 3]
  # Just write any line that isn't an atom record.
      if {![string match $string0 "ATOM"]} {
        puts $out $line
        continue
      }

  # Get the segment name.
      set segNaming $pegseg
    
  # Generate the new pdb line.
      set temp0 [string range $line 0 71]
      set temp1 [string range $line 76 end]

      if {$guiState(addDNAStrand) == "2"} {
        set old_seggy [string range $line 72 74]
        if {$old_seggy == "DS1"} {
          set segNaming "${segNaming}1"
        } elseif {$old_seggy == "DS2"} {
          set segNaming "${segNaming}2"
        }
      }

  # Write the new pdb line.

      puts $out ${temp0}${segNaming}${temp1}

    }
    close $in
    close $out
    file delete -force ${pegnam}.pdb
    file rename -force ${pegnam}_mod.pdb ${pegnam}.pdb


#################################################################################
######################## Redo the PSF File with the custom segname ##############
#################################################################################

  # Open the pdb to extract the atom records.
    set out2 [open ${pegnam}_mod.psf w]
    set in2 [open ${pegnam}.psf r]


    set record 0
    set n 0
    set num 1

    foreach line [split [read $in2] \n] {
        # If we have finished with the atom records, just write the line.

      if {$n >= $num} {
        puts $out2 $line
        continue
      }

      if {!$record} {
        # Check if we have started the atom records.
        if {[string match "*NATOM" $line]} {
          set record 1
          set numIndex [expr [string last "!" $line]-1]
          set num [string trim [string range $line 0 $numIndex]]
        }

        # Write the line.
        puts $out2 $line
      } else {
        incr n

        
        set segNameNew $pegseg
        set temp0 [string range $line 0 8]
        set temp1 [string range $line 13 end]

          # Write the new line.
        puts $out2 ${temp0}${segNameNew}${temp1}
      }
    }
    close $in2
    close $out2
    file delete -force ${pegnam}.psf
    file rename -force ${pegnam}_mod.psf ${pegnam}.psf

###########
	  
    set structmolid [mol new $current_pdbfile_struct]
    mol addfile ${pegnam}.psf $structmolid
#  set guiState(structMol) $structmolid
   
    set surf_indexed [atomselect $molid "index $atom"]
  
	# determine and save the anchors for each of the attachments
	# DNA
    if { $guiState(addStructType) == "dna" } {

      set structO [atomselect $structmolid all]
      set finalresO [lindex [$structO get residue] end]
      set finalO [atomselect $structmolid "name O3' and residue $finalresO"]
      set guiState(addCustomStructDetail) [lindex [$finalO get index] 0]
      $finalO delete
      $structO delete

      lappend guiState(oau_list) $atom

	# PEG
    } elseif { $guiState(addStructType) == "peg" } {

      set structC [atomselect $structmolid all]		
      set finalresC [lindex [$structC get residue] end]
      set finalC [atomselect $structmolid "name C2 and residue $finalresC"]
      set finalH [atomselect $structmolid "name H23 and residue $finalresC"]
      set guiState(addCustomStructDetail) [$finalH get index]
      $finalC delete
      $finalH delete
      $structC delete

      lappend guiState(cau_list) $atom

    }


    set struct_indexed [atomselect $structmolid "index $guiState(addCustomStructDetail)"]
    set struct_full [atomselect $structmolid all]
    set surf_full [atomselect $molid all]

    set surf_num [$surf_full num]

    incr atoms_red
    
    set M [measure fit $struct_indexed $surf_indexed]

    $struct_full move $M

  
  #orientation around selected atom point
    set anchor_coord [lindex [$struct_indexed get {x y z}] 0]

  # compare the placement atom to the closest vertex in vertices_normals
    set atom_x [lindex $anchor_coord 0]
    set atom_y [lindex $anchor_coord 1]
    set atom_z [lindex $anchor_coord 2]
    set last_diff 100000000000000000000000
    
    
    
  # find the closest cloud and then set vertices_normals to that list
    set chosen_key {}
    foreach ckey $vertcloud_keys {
		lassign [split $ckey "_"] cvexp cvexn cveyp cveyn cvezp cvezn

	#if atom is in the cloud
        if { ($atom_x <= $cvexp && $atom_x >= $cvexn) && ($atom_y <= $cveyp && $atom_y >= $cveyn) && ($atom_z <= $cvezp && $atom_z >= $cvezn) } {
          lappend chosen_key $ckey
        }
		
    }

    set vertices_normals {}
    foreach ckey2 $chosen_key {
      set vertices_normals [concat $vertices_normals $vertclouds($ckey2)]
    }

    set vertexLines {}
    set vertexIndex 0

    foreach vertex_normal $vertices_normals {

      set vertex_x [lindex $vertex_normal 0]
      set vertex_y [lindex $vertex_normal 1]
      set vertex_z [lindex $vertex_normal 2]
      
      set vtx1 [lindex $vertex_normal 3]
      set vtx2 [lindex $vertex_normal 4]
      set vtx3 [lindex $vertex_normal 5]
      
      

      set string_check [string is alpha $vertex_x]
      set skipcheck 0
      set difx [expr abs($vertex_x - $atom_x)]
      set dify [expr abs($vertex_y - $atom_y)]
      set difz [expr abs($vertex_z - $atom_z)]
      set vol_radius [expr 1.44 * 5]


	# skip calculating perpendicular if the vertex isn't even that close
      if { ($difx >= $vol_radius) || ($dify >= $vol_radius) || ($difz >= $vol_radius) } {
        set skipcheck 1
      } else {
		  
        set vertex_string "${vertex_x}_${vertex_y}_${vertex_z}"
       
        if { [info exists vecnormas($vertex_string)] } {
			lassign $vecnormas($vertex_string) normal_x normal_y normal_z
        } else {
          set veca "[expr [lindex $vtx2 0] - [lindex $vtx1 0]] [expr [lindex $vtx2 1] - [lindex $vtx1 1]] [expr [lindex $vtx2 2] - [lindex $vtx1 2]]"
          set vecb "[expr [lindex $vtx3 0] - [lindex $vtx1 0]] [expr [lindex $vtx3 1] - [lindex $vtx1 1]] [expr [lindex $vtx3 2] - [lindex $vtx1 2]]"
          set vc [veccross $veca $vecb]
          if { $vc != "0 0 0" } {
            set vecview [vecsub $vc $vtx1]
            if { $guiState(buildInside) == "1" } {
				if { [vecdot $vc $vecview] < 0 } {
					set vc [vecscale -1 $vc]
				}
			} else {
				if { [vecdot $vc $vecview] > 0 } {
					set vc [vecscale -1 $vc]
				}
			}
			
            set vecnorma [vecnorm $vc]
            set normal_x [lindex $vecnorma 0]
            set normal_y [lindex $vecnorma 1]
            set normal_z [lindex $vecnorma 2]
            set vecnormas($vertex_string) "$normal_x $normal_y $normal_z"
          } else {
          # pop the 0 vertex
            set vertices_normals [lreplace $vertices_normals $vertexIndex $vertexIndex]
            incr vertexIndex -1
            set skipcheck 1
          }
        }
      }
      incr vertexIndex 1

      if { $string_check == 1 } {
        set savevx 0
        set savevy 0
        set savevz 0
        set savenx 0
        set saveny 0
        set savenz 0
        set angley 0
        set anglez 0
      }

      
      if { ($string_check != 1) && ($skipcheck != 1) } {
      
        set curr_diff [expr sqrt($difx + $dify + $difz) ]
      
# NOTE: assuming for now PEG is aligned on a "clean" 1,0,0 direction

        if { $curr_diff < $last_diff } {
          if { (!(($normal_y == 0) && ($normal_x == 0))) } {
            set vecyxa [vecnorm "$normal_x $normal_y 0"]
            set vecyxb "1 0 0"
            set anglez [expr [expr {atan2([veclength [veccross $vecyxa $vecyxb]],[vecdot $vecyxa $vecyxb])}]*180/$M_PI]
            if { ($normal_y < 0) } {
              set anglez [expr -1*$anglez]
            }
          } else {
            set anglez 0
          }			
          if { (!(($normal_z == 0) && ($normal_x == 0))) } {
            set veczxa [vecnorm "$normal_x $normal_y $normal_z"]
            set sina [expr sin($anglez*$M_PI/double(180))]
            set cosa [expr cos($anglez*$M_PI/double(180))]
            set veczxb [vecnorm "$cosa $sina 0"]
            set angley [expr [expr {atan2([veclength [veccross $veczxa $veczxb]],[vecdot $veczxa $veczxb])}]*180/$M_PI]
            if { ($normal_z > 0) } {
              set angley [expr -1*$angley]
            }
          } else {
            set angley 0
          }			
          if { (!(($normal_z == 0) && ($normal_y == 0))) } {
		  # shouldn't do anything, angle will be 0 always
            set anglex 0
          }

          set last_diff $curr_diff
          set orientX $anglex
          set orientY $angley
          set orientZ $anglez
        }
      }
    }

    
  # rotate
    if { $guiState(addStructType) == "peg" } {
      $struct_full move [trans center $anchor_coord axis y 180]
    }
    $struct_full move [trans center $anchor_coord axis x $orientX]
    $struct_full move [trans center $anchor_coord axis y $orientY]
    $struct_full move [trans center $anchor_coord axis z $orientZ]


    set fullglobname [string replace $guiState(filename_index_glob)_$guiState(pdbfile_struct) end-3 end]
    lappend structnames $fullglobname
    incr guiState(filename_index_glob) 1
    resetpsf
    
    $struct_full writepdb $fullglobname.pdb
    $struct_full writepsf $fullglobname.psf

    mol delete $structmolid
    file delete -force ${pegnam}.pdb
    file delete -force ${pegnam}.psf
    
    set t2 [clock microseconds]
    
    $surf_indexed delete
    $surf_full delete
    $struct_indexed delete
    $struct_full delete
  }
  


  # Part 2.5, merge files

  resetpsf
  

  foreach structurename $structnames {

    readpsf $structurename.psf
    coordpdb $structurename.pdb
    file delete -force $structurename.psf
    file delete -force $structurename.pdb
  }

  writepsf [lindex $structnames 0]_all.psf
  writepdb [lindex $structnames 0]_all.pdb
 
  set guiState(pdbfile_struct) [lindex $structnames 0]_all.pdb
  set guiState(psffile_struct) [lindex $structnames 0]_all.psf
  lappend guiState(all_struct) [lindex $structnames 0]

  set final_density [expr $countb / $guiState(snm2)]
  tk_messageBox -icon info -message \
             "Succeeded in placement of $countb / $catoms structures for a density of $final_density" \
             -type ok  


}




proc ::inorganicBuilder::guiRemoveBlock { listid } {
  variable guiState
  set deletelist [lsort -integer -decreasing [$listid curselection]]

# returns a value of '0' to delete the first item.
  set popval [lindex $guiState(dxlist) $deletelist]
  mol delete $popval
  set guiState(dxlist) [lreplace $guiState(dxlist) $deletelist $deletelist]
  set guiState(addDXFile) [lreplace $guiState(addDXFile) $deletelist $deletelist]
  
  set blocklistlength [llength $guiState(blocklist)]
  foreach bnum $deletelist {
    if { $bnum >= $blocklistlength } {
      set bnum [expr $bnum - $blocklistlength]
      set blist $guiState(selectionlist)
      set myblock [lindex $blist $bnum]
      set guiState(selectionlist) [lreplace $blist $bnum $bnum]
    } else {
      set blist $guiState(blocklist)
      set myblock [lindex $blist $bnum]
      set guiState(blocklist) [lreplace $blist $bnum $bnum]
    }
  }
  guiCreateBox
  return
}



# *** ADDED ***
proc ::inorganicBuilder::guiRemoveStruct { listid deleteType } {
  variable guiState

  set deletelist [lsort -integer -decreasing [$listid curselection]]
  if { $deleteType == 0 } {
	  set deletelist "0"
  }
# deletelist is the discrete integer value of the array element, i.e. single element
# returns a value of '0' to delete the first item.

  set guiState(all_struct) [lreplace $guiState(all_struct) $deletelist $deletelist]

# set the o_list, oau_list, c_list, cau_lists accordingly to account for removed struct
  set structs_counted 0
  set molecules_counted 0
  set moldel_start 0
  set moldel_end 0

  foreach built_structure $guiState(structlist) {	
	  
   set write1 [lindex $built_structure 0]
   set write2 [llength [lindex [lindex $built_structure 2] 2]]
   set pre_mol_count $molecules_counted
   incr molecules_counted $write2

   if { $structs_counted == $deletelist } {
	   set moldel_start $pre_mol_count
	   set moldel_end [expr $molecules_counted - 1]
	   break
   }
   incr structs_counted
  }

  
  if {[lindex [lindex $guiState(structlist) $deletelist] 0] == "dna"} {

    set guiState(oau_list) [lreplace $guiState(oau_list) $moldel_start $moldel_end]

  } elseif {[lindex [lindex $guiState(structlist) $deletelist] 0] == "peg"} {

    set guiState(cau_list) [lreplace $guiState(cau_list) $moldel_start $moldel_end]
    
  }

# remove the struct from the structlist  

  set popval [lindex $guiState(buildPreviewMode) $deletelist]
  mol delete $popval
  set guiState(buildPreviewMode) [lreplace $guiState(buildPreviewMode) $deletelist $deletelist]
  
  
  set structlistlength [llength $guiState(structlist)]
  foreach bnum $deletelist {
    if { $bnum >= $structlistlength } {
      set bnum [expr $bnum - $structlistlength]
      set blist $guiState(selectionlist_structs)
      set mystruct [lindex $blist $bnum]
      set guiState(selectionlist_structs) [lreplace $blist $bnum $bnum]
    } else {
      set blist $guiState(structlist)
      set mystruct [lindex $blist $bnum]
      set guiState(structlist) [lreplace $blist $bnum $bnum]
    }
  }

# reset the atom's placed to exclude the removed struct now
  set guiState(global_useddense) {}
  foreach built_structure $guiState(structlist) {	
    set guiState(global_useddense) [concat $guiState(global_useddense) [lindex [lindex $built_structure 2] 2]]
  }

  return
}




proc ::inorganicBuilder::guiStoreBond { } {
  variable guiState
#  puts "InorganicBuilder)Storing bond"
  lappend guiState(bondlist) \
    [list $guiState(bondAtom1) $guiState(bondAtom2) $guiState(bondcutoff)]
  guiBuildBondsWin
  return
}

proc ::inorganicBuilder::guiRemoveBond { listid } {
  variable guiState
#  puts "InorganicBuilder)Removing bond"
  set deletelist [lsort -integer -decreasing [$listid curselection]]
  
  foreach bnum $deletelist {
    set blist $guiState(bondlist)
    set myblock [lindex $blist $bnum]
    set guiState(bondlist) [lreplace $blist $bnum $bnum]
  }
  guiBuildBondsWin
  return
}

proc ::inorganicBuilder::guiStoreMol { psffile pdbfile } {
  variable guiState
#  puts "InorganicBuilder)Storing molecule"
  if {  [llength $guiState(surfacearea)] != 0  } {
    set guiState(surfacearea) {}
    if { $guiState(curWin) == "::inorganicBuilder::BuildSurfaceStructsWin" } {
      guiBuildSurfaceStructsWin
    }
  }
  
  set mymol $guiState(currentMol)
  set filetypes [lindex [molinfo $mymol get filetype] 0]
  set filenames [lindex [molinfo $mymol get filename] 0]
  
  set indx [lsearch $filetypes "psf"]
  if { $indx != -1 } {
    set guiState($psffile) [lindex $filenames $indx]
  } else {
    set guiState($psffile) ""
  }
  set indx [lsearch $filetypes "pdb"]
  if { $indx != -1 } {
    set guiState($pdbfile) [lindex $filenames $indx]
  } else {
    set guiState($pdbfile) ""
  }
}

proc ::inorganicBuilder::guiUpdateMaterial { shortname } {
  variable guiState
  variable w
  
  set oldState $guiState(hexBox)
  
  set guiState(material) $shortname
  set guiState(fname) $shortname

  if { [ string equal [getMaterialParFile $guiState(material)] "" ] } {
    set guiState(saveParams) 0
    set parstate disabled
  } else {
    set parstate normal
  }
  if { [winfo exists $w.body3.savepar] } {
    $w.body3.savepar configure -state $parstate
  }
  
  if { ![getMaterialHexSymmetry $shortname] } {
    set guiState(hexBox) 0
    set checkstate disabled
  } else {
    set checkstate normal
  }
  if { [winfo exists $w.body1.hex] } {
    $w.body1.hex configure -state $checkstate
  }

  if { $oldState != $guiState(hexBox) } {
    guiBuildDeviceWin
  }
  return
}

proc ::inorganicBuilder::guiBuildStructure { } {
  variable guiState
#  puts "InorganicBuilder)Building structure"
  
  set blist [concat $guiState(blocklist) $guiState(selectionlist)]
  set fname $guiState(fname)
  foreach block $blist {
#    puts "InorganicBuilder)Storing $block"
    storeBlock guiState(currentBox) $block
  }
  buildBox $guiState(currentBox) $fname
  ::inorganicBuilder::setVMDPeriodicBox $guiState(currentBox)
  if { $guiState(saveParams) } {
    set parfname [getMaterialParFile $guiState(material)]
    if { ![string equal parfname ""] } {
      file copy -force $parfname $fname.inp
    }
  }
  tk_messageBox -icon info -message \
    "Model building complete." \
    -type ok  
  
  return
}


# *** ADDED ***
proc ::inorganicBuilder::getSurfaceAtoms { } {

  variable guiState
  set ns [namespace current]
  
  display update on  

  if { [string equal "$guiState(getSurfacePrevID)" "-1"] } {
    set molid [mol new]
    set guiState(getSurfacePrevID) $molid
  } elseif { ![string equal "$guiState(getSurfacePrevID)" "-1"] } {
    mol delete $guiState(getSurfacePrevID)
    set molid [mol new]
    set guiState(getSurfacePrevID) $molid
  }
    
  if { ![string equal $guiState(psffileA) ""] } {
    mol addfile $guiState(psffileA) type psf autobonds off filebonds off waitfor all $molid
    mol rename $molid \
    "GetSurfaceAtoms"
  }
  if { ![string equal $guiState(pdbfileA) ""] } {
    mol addfile $guiState(pdbfileA) type pdb autobonds off filebonds off waitfor all $molid
    mol rename $molid \
    "GetSurfaceAtoms"
  } else {
	return
  }
  set guiState(currentMol) $molid
  set guiState(getSurfMol) $molid

  set STypeList ""
  foreach SType $guiState(addSurfTypes) {
	  set STypeList "$STypeList \"$SType.*\""
  }
  set allsel [atomselect $molid "name $STypeList"] 

  
  set aminmax [measure minmax $allsel]
  set rs [measure surface $allsel 1.5 2.88 1.44 ] 
  $allsel delete

# Graphically display a highlighted region where Surface Area atoms have been found.
  if {$rs == ""} { return }
  
  set surface_area [atomselect $molid "(index $rs) and (name $STypeList)"]
  set guiState(surfacearea) {}
  set guiState(surfacearea) [concat $guiState(surfacearea) [$surface_area get index]]

  set guiState(DNATypes) {}
  set guiState(PEGTypes) {}


  set sa_names {}
  foreach saname [$surface_area get name] {
    lappend sa_names [lindex [split $saname {[1,2,3,4,5,6,7,8,9]}] 0]
  }

  set unique_sa_names [lsort -unique $sa_names]

  foreach entryname $unique_sa_names {
  # if valid connector for PEG found, lappend guiState(PEGTypes)
    if { $entryname == "AU" } {
        lappend guiState(DNATypes) $entryname
        lappend guiState(PEGTypes) $entryname
    }
  }

  mol addrep $molid
  mol modselect 1 $molid "index $rs"

  mol modcolor 1 $molid resname
  mol colupdate 1 $molid 1 
  mol scaleminmax $molid 1 auto 
  mol modstyle 1 $molid Licorice

  mol addrep $molid
  mol modselect 2 $molid "name $STypeList"
  mol modcolor 2 $molid name
  mol modmaterial 2 $molid Transparent
  mol colupdate 2 $molid 1 
  mol modstyle 2 $molid QuickSurf 2 2.6 1 high

  puts "Surface Atoms Available for Construction: [$surface_area get index]"

  puts "Surface Atom Types Available for Construction: $unique_sa_names"
  tk_messageBox -icon info -message \
    "Surface Atom Types Available for Construction: $unique_sa_names" \

  $surface_area delete
  display resetview     

  # Populate the periodic values at the limits of the system from PDB
  set x0 [lindex [lindex $aminmax 0] 0]
  set x1 [lindex [lindex $aminmax 1] 0]
  set y0 [lindex [lindex $aminmax 0] 1]
  set y1 [lindex [lindex $aminmax 1] 1]
  set z0 [lindex [lindex $aminmax 0] 2]
  set z1 [lindex [lindex $aminmax 1] 2]

  if {($guiState(boxX2) && $guiState(boxY2) && $guiState(boxZ2)) \
  && ($guiState(boxX2) == 1)} {
	  set guiState(boxX2) [expr round(sqrt(($x1-$x0)**2))]
	  set guiState(boxY2) [expr round(sqrt(($y1-$y0)**2))]
	  set guiState(boxZ2) [expr round(sqrt(($z1-$z0)**2))]
	  lassign [molinfo $molid get {alpha beta gamma}] \
	  guiState(boxX2R) guiState(boxY2R) guiState(boxZ2R)
	  ${ns}::structBoxMolecule 
  }
  if {($guiState(boxZ3) && $guiState(hexD2)) \
  && ($guiState(boxZ3) == 1)} {
	  set guiState(boxZ3) [expr round(sqrt(($z1-$z0)**2))]
	  set guiState(hexD2) [expr round(sqrt(($x1-$x0)**2))]
	  lassign [molinfo $molid get {alpha beta gamma}] \
	  guiState(boxX2Rh) guiState(boxY2Rh) guiState(boxZ2Rh)
	  ${ns}::structBoxMolecule 
  }

 
  guiBuildSurfaceStructsWin
  return
}

# *** ADDED ***
proc ::inorganicBuilder::getSurfaceAtomTypes { } {

  variable guiState
  set ns [namespace current]
  
  if { [string equal "$guiState(getSurfacePrevID)" "-1"] } {
    set molid [mol new]
    set guiState(getSurfacePrevID) $molid
  } elseif { ![string equal "$guiState(getSurfacePrevID)" "-1"] } {
    mol delete $guiState(getSurfacePrevID)
    set molid [mol new]
    set guiState(getSurfacePrevID) $molid
  }
    
  if { ![string equal $guiState(psffileA) ""] } {
    mol addfile $guiState(psffileA) type psf autobonds off filebonds off waitfor all $molid
    mol rename $molid \
    "GetSurfaceAtomTypes"
  }
  if { ![string equal $guiState(pdbfileA) ""] } {
    mol addfile $guiState(pdbfileA) type pdb autobonds off filebonds off waitfor all $molid
    mol rename $molid \
    "GetSurfaceAtomTypes"
  } else {
	return
  }

  set allsel [atomselect $molid all] 

  set rs [measure surface $allsel 1.5 2.88 1.44 ] 
  $allsel delete

# Graphically display a highlighted region where Surface Area atoms have been found.
  if {$rs == ""} { return }
  
  set surface_area [atomselect $molid "index $rs"]

  set sa_names {}
  foreach saname [$surface_area get name] {
    lappend sa_names [lindex [split $saname {[1,2,3,4,5,6,7,8,9]}] 0]
  }

  set unique_sa_names [lsort -unique $sa_names]
  set guiState(addSurfTypes) $unique_sa_names

  mol delete $molid

  guiBuildSurfaceStructsWin
  return
}



# *** ADDED ***
proc ::inorganicBuilder::guiBuildStructs {} {
  variable guiState

  set molid $guiState(currentMol)
  set structmolid $guiState(structMol)

  ::inorganicBuilder::buildStructs $molid
  

  tk_messageBox -icon info -message \
    "System built." \
    -type ok  
  set guiState(systemBuilt) 1
  file delete -force "tmp_reindex.pdb"
  
  # Save the newly built file into the temporary variables for AutoIonize and Solvate
  # This feature might not do anything on Windows systems. (User will have to enter the name)
  file copy -force "$guiState(structedFile).psf" "tmpA.psf"
  file copy -force "$guiState(structedFile).pdb" "tmpA.pdb"  
  catch {autoionize -psf $guiState(structedFile).psf -pdb $guiState(structedFile).pdb -sc 0.15 -cation $guiState(cation) -anion $guiState(anion) -o $guiState(structedFile)}
  file delete -force $guiState(structedFile).psf
  file delete -force $guiState(structedFile).pdb
  file rename -force "tmpA.psf" "$guiState(structedFile).psf"
  file rename -force "tmpA.pdb" "$guiState(structedFile).pdb"
  
  mol delete top
  
}



# *** ADDED ***

proc ::inorganicBuilder::guiRunNAMD {} {
  variable guiState

  # Grab the needed values
  set xmin [expr -1*abs($guiState(boxX2) / 2)]
  set xmax [expr abs($guiState(boxX2) / 2)]
  set ymin [expr -1*abs($guiState(boxY2) / 2)]
  set ymax [expr abs($guiState(boxY2) / 2)]
  set zmin [expr -1*abs($guiState(boxZ2) / 2)]
  set zmax [expr abs($guiState(boxZ2) / 2)]

  
  if { [winfo exists .ibrunnamd] } {
    destroy .ibrunnamd
  }
  set aw [toplevel ".ibrunnamd"]
  wm title $aw "Run NAMD"
  wm resizable $aw yes yes
#  grab set ".ibrunnamd"
  set ns [namespace current]

  frame $aw.type
  set row 0

  incr row
 
  set row [guiDrawNAMDFrame $ns $aw.body $row]
  
  
  labelframe $aw.buttons0 -text "Solvate Options" -padx 2 -pady 4

  label $aw.buttons0.neutlabela -text "Neutralize and set "
  tk_optionMenu $aw.buttons0.saltname guiState(saltName) NaCl KCl CsCl MgCl2 CaCl2 ZnCl2
  label $aw.buttons0.neutlabelb -text "concentration to "
  entry $aw.buttons0.neutentry -width 8 -textvariable ${ns}::guiState(saltConc)
  label $aw.buttons0.neutlabel2 -text "mol/L"
  
  grid $aw.buttons0.neutlabela -row $row -column 0 -columnspan 3 -sticky ew
  grid $aw.buttons0.saltname -row $row -column 3 -columnspan 1 -sticky ew  
  grid $aw.buttons0.neutlabelb -row $row -column 4 -columnspan 6 -sticky w
  grid $aw.buttons0.neutentry -row $row -column 10 -columnspan 2 -sticky w
  grid $aw.buttons0.neutlabel2 -row $row -column 12 -columnspan 2 -sticky w

  

  incr row
  if { $guiState(StructHexBox) } {
    grid [button $aw.buttons0.sol0 -text "Auto Solvate System" \
      -command "${ns}::autoSolver"] \
      -row $row -column 3 -columnspan 1 -sticky ew
  } else {
    grid [button $aw.buttons0.sol1 -text "Auto Solvate System" \
      -command "solvate $guiState(structedFile).psf $guiState(structedFile).pdb \
       -minmax {{$xmin $ymin $zmin} {$xmax $ymax $zmax}} -o $guiState(structedFile); "] \
      -row $row -column 3 -columnspan 1 -sticky ew	  
  }

  grid [button $aw.buttons0.ion -text "Auto Add Ions" \
    -command "${ns}::saltION; \
     autoionize -psf $guiState(structedFile).psf -pdb $guiState(structedFile).pdb \
    -sc $guiState(saltConc) -cation $guiState(cation) -anion $guiState(anion) \
    -o $guiState(structedFile) "] \
    -row $row -column 4 -columnspan 1 -sticky ew
  incr row

  grid [button $aw.buttons0.sol2 -text "Full Solvate Menu" \
    -command "solvategui"] \
    -row $row -column 3 -columnspan 1 -sticky w
  grid [button $aw.buttons0.ion2 -text "Full Ion Menu" \
    -command "autoigui"] \
    -row $row -column 4 -columnspan 1 -sticky w
  incr row

  labelframe $aw.buttons -text "Simulation Options" -padx 2 -pady 4
  grid [label $aw.buttons.outputnamelabel -text "Simulation Filename:" ] \
    -row $row -column 0 -sticky ew -padx 4
  grid [entry $aw.buttons.outputname -width 5 -textvariable ${ns}::guiState(simFile)] \
    -row $row -column 1 -sticky ew -padx 4
  incr row

  grid [label $aw.buttons.outputnamelabelb -text "NAMD Executable:" ] \
    -row $row -column 0 -sticky ew -padx 4
  grid [entry $aw.buttons.outputnameb -width 5 -textvariable ${ns}::guiState(namdhandle)] \
    -row $row -column 1 -sticky ew -padx 4
  incr row


  grid [label $aw.buttons.imd -text "Display Interactive MD?" ] \
    -row $row -column 0 -sticky ew -padx 4
  grid [radiobutton $aw.buttons.imda \
	    -variable ${ns}::guiState(setNAMDIMD) -value "yes" \
	    -text "Yes" \
	    -anchor e] \
    -row $row -column 1 -sticky w -padx 4
  grid [radiobutton $aw.buttons.imdb \
	    -variable ${ns}::guiState(setNAMDIMD) -value "No" \
	    -text "No" \
	    -anchor e] \
    -row $row -column 1 -sticky e -padx 4
  incr row



  grid [label $aw.buttons.ms -text "Minimize Steps: "] \
    -row $row -column 0 -sticky w
  grid [entry $aw.buttons.msval -width 5 \
    -textvariable ${ns}::guiState(setNAMDminimStep) \
    -validate focusout \
    -vcmd "${ns}::guiRequireStepSize %W %P %V" \
    -invcmd "${ns}::guiStepSizeErr %W" \
		] \
    -row $row -column 0 -sticky e -padx 4


    
  grid [label $aw.buttons.ss -text "Simulate Steps: "] \
    -row $row -column 1 -sticky w
  grid [entry $aw.buttons.ssval -width 6 \
    -textvariable ${ns}::guiState(setNAMDsimStep) \
    -validate focusout \
    -vcmd "${ns}::guiRequireStepSize %W %P %V" \
    -invcmd "${ns}::guiStepSizeErr %W" \
		] \
    -row $row -column 1 -sticky e -padx 4
  incr row

  
  grid [button $aw.buttons.add -text "Create Minimization" \
    -command "${ns}::RunNAMD 0; destroy $aw"] \
    -row $row -column 0
  grid [button $aw.buttons.con -text "Continue Simulation" \
    -command "${ns}::RunNAMD 1; destroy $aw"] \
    -row $row -column 1
  grid [button $aw.buttons.cancel -text Cancel -command "destroy $aw"] \
    -row $row -column 2

  guiRepackRunNAMD  
  
}

# *** ADDED ***
# Note, I tried running this directly as a button -command and could not get it working.
# It was the same exact line of code...
proc ::inorganicBuilder::autoSolver { } {
	variable guiState
	inorganicBuilder::solvateBox $guiState(structBox) \
    [list $guiState(structedFile).psf $guiState(structedFile).pdb] \
    $guiState(structedFile)
    file delete -force $guiState(structedFile).0.pdb
    file delete -force $guiState(structedFile).1.pdb
    file delete -force $guiState(structedFile).1.psf
    file delete -force $guiState(structedFile).1.log
    mol new $guiState(structedFile).psf waitfor all
    mol addfile $guiState(structedFile).pdb waitfor all
}

# *** ADDED ***

proc ::inorganicBuilder::saltION { } {
	variable guiState
	switch $guiState(saltName) {
		NaCl {
			set guiState(cation) "SOD"
			set guiState(anion) "CLA"
		}
		KCl {
			set guiState(cation) "POT"
			set guiState(anion) "CLA"
		}
		CaCl {
			set guiState(cation) "CAL"
			set guiState(anion) "CLA"
		}
		MgCl2 {
			set guiState(cation) "MG"
			set guiState(anion) "CLA"
		}
		CaCl2 {
			set guiState(cation) "CAL2"
			set guiState(anion) "CLA"
		}
		ZnCl2 {
			set guiState(cation) "ZN2"
			set guiState(anion) "CLA"
		}
	}
	return
}

# *** ADDED ***

proc ::inorganicBuilder::RunNAMD { type } {
  variable guiState
  variable homePath



#  set dimFactor 2
  set dimFactor 1
  set the_pwd [pwd]
  set parDirpre [file normalize [file join $homePath topology]]

  set namdFile $guiState(structedFile).namd.conf

# mkNAMD.tcl -args psf pdb outDir parDirpre dimFactor namdFile Temperature Dielectric Damping MinimizationSteps SimulationSteps
  source [file normalize [file join $homePath "mkNAMD" "mkNAMD.tcl"]]
  
#  mkNAMD $guiState(structedFile).psf $guiState(structedFile).pdb $outDir $parDirpre
# 			$dimFactor $homePath $sim_file_name $temperature $dielectric $damping
#			$stepstoMinimize $stepstoSimulate $OnOffIMD $PeriodicVecInfo
#  set save_top [molinfo top get id]

#  mol top $save_top


# Deposit the latest files used for running NAMD as a single folder in the CWD
  set time1 [clock clicks]
  set namdpackdir "NAMDFiles_$guiState(simFile)"
  set namdpackpath [file normalize $namdpackdir]
  set namdfilepath [file normalize $namdFile]
  set parDir [file normalize [file join $namdpackpath topology]]
  set pdbpath [file normalize [file join $namdpackpath $guiState(structedFile).pdb]]
  set psfpath [file normalize [file join $namdpackpath $guiState(structedFile).psf]]
  
  if {[file exists $namdpackpath]} {
    if {[file exists [lindex [glob -directory $namdpackpath -nocomplain $guiState(simFile).*] 0] ] && ($type == 0) } {
      tk_messageBox -icon error -message \
        "The simulation file $guiState(simFile) already exists, cannot create a new minimization file using this filename." \
        -type ok
      return
    }	  
    file delete -force $namdfilepath
  } else {
    file mkdir $namdpackdir
    set pdbpath_copy [file normalize $guiState(structedFile).pdb]
    set psfpath_copy [file normalize $guiState(structedFile).psf]

#  set readmepath [file normalize $readmeFile]
    file copy -force $parDirpre $namdpackpath
    file copy -force $pdbpath_copy $namdpackpath
    file copy -force $psfpath_copy $namdpackpath
  }

#  file copy --force $readmepath $namdpackpath
  # build and copy the NAMD file with appropriate pathing
  mkNAMD $guiState(structedFile).psf $guiState(structedFile).pdb $namdpackpath $parDir\
   $dimFactor $namdFile $guiState(simFile) $guiState(setNAMDtemp) $guiState(setNAMDdiel)\
    $guiState(setNAMDpress) $guiState(setNAMDminimStep) $guiState(setNAMDsimStep)\
     $guiState(setNAMDIMD) $guiState(sspVecs)

  file copy -force $namdfilepath $namdpackpath

  set alpha [catch {exec $guiState(namdhandle) $namdFile &}]
  if {$alpha != 0} {
    tk_messageBox -icon error -message \
      "The NAMD executable was not able to be run using the specified global handle '$guiState(namdhandle)'." \
      -type ok  
  } else {
	  if {$guiState(setNAMDIMD) == "yes"} {
	    imdmenu_tk
	  }
  }

  
}



# *** ADDED ***
proc ::inorganicBuilder::clearStructs {} {
  variable guiState
  if { $guiState(structListID) != "" } {
    while { [llength $guiState(buildPreviewMode)] != 0 } {
		 guiRemoveStruct $guiState(structListID) 0
		 }
  }
  if { ![string equal "$guiState(getSurfacePrevID)" "-1"] } {
    mol delete $guiState(getSurfacePrevID)
  }
  
  resetpsf
  puts "Temporary data cleared from Inorganic Builder: Build Surface Structures"
  set guiState(surfacearea) {}
  set guiState(temp_surfacearea) {}
  set guiState(previous_surfacearea) {}
  set guiState(previous_densearea) {}
  set guiState(previous_SurfDetail) ""
  set guiState(previous_tempsurf) ""
  set guiState(dens_printer) ""
  set guiState(c_list) ""
  set guiState(o_list) ""
  set guiState(cau_list) ""
  set guiState(oau_list) ""
  set guiState(global_useddense) {}
  set guiState(densearea) {}

  set guiState(getSurfacePrevID) -1
  set guiState(setPreviewMode) -1
  set guiState(systemBuilt) 0
  set guiState(buildPreviewMode) {}
  set guiState(filename_index_glob) 0
  set guiState(addDNALength) ""
  set guiState(addDNASEQ) "Random"
  set guiState(addDNATypes) ""
  set guiState(addDNAStrand) "1"
  set guiState(addPEGLength) ""
  set guiState(addPEGTypes) ""
  set guiState(addSurfTypes) ""
  set guiState(all_struct) ""
  set guiState(DNATypes) ""
  set guiState(PEGTypes) ""

  set guiState(addMoleculeOrientX) ""
  set guiState(addMoleculeOrientY) ""
  set guiState(addMoleculeOrientZ) ""
  set guiState(addCustomSurfDetail) ""
  set guiState(addCustomStructDetail) ""
  set guiState(setDensitySpacing) 0
  set guiState(setDensityVal) 0
  set guiState(setVMDSelSurf) ""

  set guiState(structureIndex) 0
  set guiState(structureX) -1
  set guiState(structureY) -1
  set guiState(structureZ) 0
  set guiState(structlist) {}
  set guiState(selectionlist_structs) {}
  set guiState(getSurfMol) "none"
  set guiState(currentMol) "none"
  set guiState(currentMol1) "none"
  set guiState(currentMol2) "none"

  set guiState(boxX2) 1
  set guiState(boxY2) 1
  set guiState(boxZ2) 1
  set guiState(boxZ3) 1
  set guiState(hexD2) 1
  set guiState(boxX2R) 90
  set guiState(boxY2R) 90
  set guiState(boxZ2R) 90
  set guiState(boxX2Rh) 90
  set guiState(boxY2Rh) 90
  set guiState(boxZ2Rh) 60
  set guiState(lenboxX) 1
  set guiState(lenboxY) 1
  set guiState(lenboxZ) 1
  set guiState(sspVecs) ""
  set guiState(saltName) "NaCl"
  set guiState(cation) "SOD"
  set guiState(anion) "CLA"
  set guiState(saltConc) "0.15"
    
}


proc ::inorganicBuilder::guiClearDevice { } {
  variable guiState

  set guiState(structlist) {}
  set guiState(blocklist) {}
  set guiState(selectionlist) {}
  set guiState(selectionlist_structs) {}
  set guiState(boxX) 1
  set guiState(boxY) 1
  set guiState(boxZ) 1
  set guiState(hexD) 1
  guiCreateBox
  after idle "eval $guiState(curWin)"
  return
}

proc ::inorganicBuilder::guiBuildBonds { } {
  variable guiState
  
  set periodicIn [list $guiState(periodicA) $guiState(periodicB) \
                       $guiState(periodicC)]
  
  if { [string equal $guiState(addBondsHow) "addperiodictovmd"] } {
    guiBuildPeriodicBonds vmd $periodicIn
  } elseif { [string equal $guiState(addBondsHow) "addperiodictofile"] } {
    guiBuildPeriodicBonds file $periodicIn
  } elseif { [string equal $guiState(addBondsHow) "addspecifiedtofile"] } {
    guiBuildSpecifiedBonds file $periodicIn
  } else {
    guiBuildSpecifiedBonds none $periodicIn
  }
  tk_messageBox -icon info -message \
    "Bond building complete." \
    -type ok  
  
}

proc ::inorganicBuilder::guiBuildPeriodicBonds { addhow periodicIn } {
  variable guiState
  
  set orig [list $guiState(origX) $guiState(origY) $guiState(origZ)]
  set a [list $guiState(boxAX) $guiState(boxAY) $guiState(boxAZ)]
  set b [list $guiState(boxBX) $guiState(boxBY) $guiState(boxBZ)]
  set c [list $guiState(boxCX) $guiState(boxCY) $guiState(boxCZ)]
  
  if { $guiState(hexBox) } {
    set mybox [ ::inorganicBuilder::defineMaterialHexagonalBox \
      $orig [list $a $b $c] $guiState(bondCutoff) ]
  } else {
    set mybox [ ::inorganicBuilder::defineMaterialBox \
      $orig [list $a $b $c] $guiState(bondCutoff) ]
  }

  if { [string equal $addhow "file"] } {
    set fbonds on
  } else {
    set fbonds off
  }

  set molid [mol new]
  if { ![string equal $guiState(psffile) ""] } {
    mol addfile $guiState(psffile) type psf filebonds $fbonds autobonds off waitfor all
  }
  if { ![string equal $guiState(pdbfile) ""] } {
    mol addfile $guiState(pdbfile) type pdb filebonds $fbonds autobonds off waitfor all
  }
  set guiState(currentBox) $mybox
  ::inorganicBuilder::setVMDPeriodicBox $mybox

  if {![string equal $addhow "file"] } {
    # Make sure everything is in the unit cell
    # If this is a hex box, transform to hex
    if { $guiState(hexBox) } {
      transformCoordsToHex $mybox $molid
    } else {
      transformCoordsToBox $mybox $molid
    }
    mol bondsrecalc $molid
  }
  set guiState(currentMol) $molid
  
  ::inorganicBuilder::buildBonds $guiState(currentBox) $guiState(relabelBonds) \
    $periodicIn $guiState(currentMol)
  
  set fname $guiState(fname)
  set mymol [atomselect $guiState(currentMol) all]
  
  if { $guiState(buildAngles) } {
    set fname0 ${fname}-prebond
    $mymol writepsf $fname0.psf
    $mymol writepdb $fname0.pdb
    ::inorganicBuilder::buildAnglesDihedrals $fname0 $fname \
      $guiState(buildDihedrals)
  } else {
    $mymol writepdb ${fname}.pdb
    $mymol writepsf ${fname}.psf
  }
  # Reload the molecule with angles, if generated
  if {$guiState(loadResult)} {
    mol new [file normalize ${fname}.psf] type psf autobonds off waitfor all
    mol addfile [file normalize ${fname}.pdb] type pdb autobonds off waitfor all
    ::inorganicBuilder::setVMDPeriodicBox $mybox
  }
  $mymol delete
  mol delete $guiState(currentMol)
  
  return
}

#proc ::inorganicBuilder::vmd_init_struct_trace {structure index op} {
  #Accessory proc for traces on the mol menu
#  guiFillMolMenu
#  guiFillMol1Menu
#  guiFillMol2Menu
#}

proc ::inorganicBuilder::guiFillMolMenu { filetype } {
  if {[string equal $filetype "-psf"] } {
    return [guiFillMolMenuInt "molMenuName" "currentMol" -psf ]
  } else {
    return [guiFillMolMenuInt "molMenuName" "currentMol" -all ]
  }
}

proc ::inorganicBuilder::guiFillMolMenuInt { molMenuName currentMol \
                                             filetypes } {
  #Proc to get all the current molecules for a menu
  #For now, shamelessly ripped off from the NAMDEnergy plugin
  #which in turn ripped it off from the PME plugin
  variable guiState
  
#  puts "InorganicBuilder)Processing $molMenuName $guiState($molMenuName)"
  set name $guiState($molMenuName)
  if { ![winfo exists $name] } {
    return
  }
#  puts "InorganicBuilder)name parent is [winfo parent $name]"
  
  if { [$name index end] != 0 } {
    $name delete 0 end
  }

  set molList ""
#  puts "InorganicBuilder)Processing $molMenuName"
  foreach mm [molinfo list] {
    if { [molinfo $mm get numatoms] > 0 } {
      # if we're building the PSF molecule menu, and the molecule doesn't
      # contain a PSF file, don't include it in the list
      if { [string equal $filetypes "-psf" ] } {
#        puts "InorganicBuilder)Filling PSF menu"
        set filetypes [lindex [ molinfo $mm get filetype ] 0]
#        puts "InorganicBuilder)$mm has $filetypes"
        if { [ lsearch $filetypes "psf" ] == -1} {
          continue
        }
      }
      lappend molList $mm
      $name add command \
        -command "[winfo parent $name] configure \
                  -text \"$mm [ lindex [molinfo $mm get name] 0 ]\"; \
                  set [namespace current]::guiState($currentMol) $mm" \
        -label "$mm [molinfo $mm get name]"
    }
  }
  #set if any non-Graphics molecule is loaded
  if {[lsearch -exact $molList $guiState($currentMol)] == -1} {
    if {[lsearch -exact $molList [molinfo top]] != -1} {
      set guiState($currentMol) [molinfo top]
      set usableMolLoaded 1
    } else {
      set guiState($currentMol) "none"
      set usableMolLoaded  0
    }
  }
#  puts "InorganicBuilder)$molMenuName:molList is $molList [llength $molList]"
  if {[llength $molList] == 0} {
    $name add command \
      -command "set [namespace current]::guiState($currentMol) none; \
        [winfo parent $name] configure -text \"None loaded\"; \
        puts \"Invoking none\";" \
      -label "None loaded"
#    puts "InorganicBuilder)Configuring [winfo parent $name]"
    [winfo parent $name] configure -text "None loaded"
  }
  
  $name invoke 0
  
#  puts "InorganicBuilder)Done processing $molMenuName"
}




proc ::inorganicBuilder::guiFindShell {} {
  variable guiState
  
  set orig [list $guiState(origX) $guiState(origY) $guiState(origZ)]
  set a [list $guiState(boxAX) $guiState(boxAY) $guiState(boxAZ)]
  set b [list $guiState(boxBX) $guiState(boxBY) $guiState(boxBZ)]
  set c [list $guiState(boxCX) $guiState(boxCY) $guiState(boxCZ)]
  
  set molid [mol new]
  if { ![string equal $guiState(psffile) ""] } {
    mol addfile $guiState(psffile) type psf autobonds off filebonds off waitfor all
  }
  if { ![string equal $guiState(pdbfile) ""] } {
    mol addfile $guiState(pdbfile) type pdb autobonds off filebonds off waitfor all
  }
  set guiState(currentMol) $molid

  set mybox [ ::inorganicBuilder::defineMaterialBox \
    $orig [list $a $b $c] $guiState(bondCutoff) ]
  set guiState(currentBox) $mybox
  ::inorganicBuilder::setVMDPeriodicBox $mybox
  
  set shellatoms [::inorganicBuilder::findShell $mybox $molid \
                  $guiState(gridSz) $guiState(gridRad) $guiState(thickness)]
                  
  set num_shell [llength $shellatoms]
#  puts "InorganicBuilder)Found $num_shell atoms in shell" 
  if { $num_shell > 0 } {
    set shell_sel [atomselect $molid [concat "index" $shellatoms]]
    $shell_sel writepsf $guiState(shellFile).psf
    $shell_sel writepdb $guiState(shellFile).pdb
    $shell_sel delete
  }
  
  set num_tot [lindex [ molinfo $molid get numatoms] 0]
  set num_int [expr $num_tot - $num_shell]
  
#  puts "InorganicBuilder)Found $num_int atoms in interior" 
  if { $num_int > 0 } {
    if { $num_shell == 0 } {
      set sel_string "all"
    } else {
      set sel_string [concat "not index" $shellatoms]
    }
    set int_sel [atomselect $molid $sel_string]
    $int_sel writepsf $guiState(interiorFile).psf
    $int_sel writepdb $guiState(interiorFile).pdb
    $int_sel delete
  }
  mol delete $molid
  tk_messageBox -icon info -message \
    "Interior and surface atoms separated and saved." \
    -type ok  
  
}

proc ::inorganicBuilder::guiSolvateBox {} {
  variable guiState
  
  set orig [list $guiState(origX) $guiState(origY) $guiState(origZ)]
  set a [list $guiState(boxAX) $guiState(boxAY) $guiState(boxAZ)]
  set b [list $guiState(boxBX) $guiState(boxBY) $guiState(boxBZ)]
  set c [list $guiState(boxCX) $guiState(boxCY) $guiState(boxCZ)]

  if ($guiState(hexBox)) {
    set mybox [ ::inorganicBuilder::defineMaterialHexagonalBox \
      $orig [list $a $b $c] $guiState(bondCutoff) ]
  } else {
    set mybox [ ::inorganicBuilder::defineMaterialBox \
      $orig [list $a $b $c] $guiState(bondCutoff) ]
  }
  set guiState(currentBox) $mybox
  ::inorganicBuilder::setVMDPeriodicBox $mybox
  
  set molid $guiState(currentMol)
  ::inorganicBuilder::solvateBox $mybox \
    [list $guiState(psffile) $guiState(pdbfile)] $guiState(solvatedFile)
  tk_messageBox -icon info -message \
    "System solvated." \
    -type ok  
  
}

proc ::inorganicBuilder::guiMergeSurfInterior {} {
  variable guiState
  
  set mol1id [mol new]
  if { ![string equal $guiState(psffile1) ""] } {
    mol addfile $guiState(psffile1) type psf autobonds off filebonds off waitfor all
  }
  if { ![string equal $guiState(pdbfile1) ""] } {
    mol addfile $guiState(pdbfile1) type pdb autobonds off filebonds off waitfor all
  }
  
  set mol2id [mol new]
  if { ![string equal $guiState(psffile2) ""] } {
    mol addfile $guiState(psffile2) type psf autobonds off filebonds off waitfor all
  }
  if { ![string equal $guiState(pdbfile2) ""] } {
    mol addfile $guiState(pdbfile2) type pdb autobonds off filebonds off waitfor all
  }
  
  set topfile [getMaterialTopologyFile $guiState(material)]
  
  return [mergeMoleculesResegment $topfile \
          $mol1id $mol2id $guiState(mergedFile)]
          
  mol delete $mol1id
  mol delete $mol2id
}

proc ::inorganicBuilder::guiBuildSpecifiedBonds { addhow periodicIn} {
  variable guiState
  
  set orig [list $guiState(origX) $guiState(origY) $guiState(origZ)]
  set a [list $guiState(boxAX) $guiState(boxAY) $guiState(boxAZ)]
  set b [list $guiState(boxBX) $guiState(boxBY) $guiState(boxBZ)]
  set c [list $guiState(boxCX) $guiState(boxCY) $guiState(boxCZ)]
  
  if { $guiState(hexBox) } {
    set mybox [ ::inorganicBuilder::defineMaterialHexagonalBox \
      $orig [list $a $b $c] $guiState(bondCutoff) ]
  } else {
    set mybox [ ::inorganicBuilder::defineMaterialBox \
      $orig [list $a $b $c] $guiState(bondCutoff) ]
  }
  if { [string equal $addhow "file"] } {
    set fbonds on
  } else {
    set fbonds off
  }

  set molid [mol new]
  if { ![string equal $guiState(psffile) ""] } {
    mol addfile $guiState(psffile) type psf autobonds off filebonds $fbonds waitfor all
  }
  if { ![string equal $guiState(pdbfile) ""] } {
    mol addfile $guiState(pdbfile) type pdb autobonds off filebonds $fbonds waitfor all
  }
  set guiState(currentMol) $molid
  
  set guiState(currentBox) $mybox
  
  set molid $guiState(currentMol)
  ::inorganicBuilder::buildSpecificBonds $mybox $guiState(bondlist) \
    $periodicIn $molid
  # Rename atom types
  if { $guiState(relabelBonds)  } {
    setAtomTypes $molid
  }
  
  set fname $guiState(fname)
  set mymol [atomselect $guiState(currentMol) all]
  
  if { $guiState(buildAngles) } {
    set fname0 ${fname}-prebond
    $mymol writepsf $fname0.psf
    $mymol writepdb $fname0.pdb
    ::inorganicBuilder::buildAnglesDihedrals $fname0 $fname \
      $guiState(buildDihedrals)
  } else {
    $mymol writepdb ${fname}.pdb
    $mymol writepsf ${fname}.psf
  }
  # Reload the molecule with angles, if generated
  if {$guiState(loadResult)} {
    mol new [file normalize ${fname}.psf] type psf autobonds off waitfor all
    mol addfile [file normalize ${fname}.pdb] type pdb autobonds off waitfor all
    ::inorganicBuilder::setVMDPeriodicBox $mybox
  }
  $mymol delete
  mol delete $guiState(currentMol)
  return
}

proc ::inorganicBuilder::guiRequireDouble { w newval valtype } {
  set err 0
  if { [string equal $newval ""] || [string equal $newval "."] \
       || [string equal $newval "-"] } {
    if {[string equal $valtype "key"]}  {
      set err 1
    } else {
      $w delete 0 end
      $w insert 0 0
    }
  } elseif { [string is double -strict $newval] } {
    set err 1
  }
  after idle \
    "$w config -validate all"
  return $err
}

proc ::inorganicBuilder::guiRequirePInt { w newval valtype } {
  set err 0
  if { [string equal $newval ""] } {
    if {[string equal $valtype "key"]}  {
      set err 1
    } else {
      $w delete 0 end
      $w insert 0 1
    }
  } elseif { [string is integer -strict $newval] && [expr $newval > 0] } {
    set err 1
  }
  after idle \
    "$w config -validate all"
  return $err
}

proc ::inorganicBuilder::guiRequireAngle { w newval valtype } {
  set err 0
  if { [string equal $newval ""] } {
    if {[string equal $valtype "key"]}  {
      set err 1
    } else {
      $w delete 0 end
      $w insert 0 90
    }
  } elseif { [string is double -strict $newval] } {
    set err 1
  }
  after idle \
    "$w config -validate all"
  return $err
}




#*** ADDED ***
proc ::inorganicBuilder::guiRequireStepSize { w newval valtype } {
  set err 0
  if { [string equal $newval ""] } {
    if {[string equal $valtype "key"]}  {
      set err 1
    } else {
      $w delete 0 end
      $w insert 0 12
    }
    
  } elseif { [string is true [expr [expr $newval/12.0] == [expr $newval/12]]] && [expr $newval > 0] } {
    set err 1
  }
  after idle \
    "$w config -validate focusout"
  return $err
}


proc ::inorganicBuilder::guiUnitCellErr { w } {
  tk_messageBox -icon error -message \
    "The box size must be an integer multiple of the unit cell size, so only a positive integer is valid here." \
    -type ok
  after idle "$w config -validate all"
}

# *** ADDED ***
proc ::inorganicBuilder::guiUnitAngErr { w } {
  tk_messageBox -icon error -message \
    "(A,B,G) must be integers greater than 0." \
    -type ok
  after idle "$w config -validate focusout"
}

# *** ADDED ***
proc ::inorganicBuilder::guiStepSizeErr { w } {
  tk_messageBox -icon error -message \
    "The steps to run for must be a multiple of the NAMD StepsPerCycle, which is 12." \
    -type ok
  after idle "$w config -validate focusout"
}

proc ::inorganicBuilder::guiBuildMaterialMenu { mname } {
  set matlist [lsort -index 1 [ getMaterialNames ]]
  $mname delete 0 end
  foreach mat $matlist {
    foreach { shortname longname } $mat {}
    $mname add command -label $longname \
      -command "::inorganicBuilder::guiViewMaterialWin $mname $shortname"
  }
}

proc ::inorganicBuilder::guiSaveMaterial { fname } {
  variable guiState


  set matvars $guiState(newMatParams)
  foreach vname $matvars {
    set matState($vname) $guiState($vname)
  }
  set chan [open $fname "w"]
  puts $chan [array get matState]
  close $chan
  return
}

proc ::inorganicBuilder::guiLoadMaterial { fname } {
  variable guiState

  set chan [open $fname]
  set matdat [read $chan]
  close $chan
  
  array set matState $matdat
  
  set matvars $matState(newMatParams)
  foreach vname $matvars {
    set guiState($vname) $matState($vname)
  }
  return
}

proc ::inorganicBuilder::guiAddMaterial { menuwin } {
  variable guiState
  variable materialList

  set new_shortname $guiState(newMatShortName)
  set new_longname $guiState(newMatLongName)

  set matlist [lsort -index 1 [ getMaterialNames ]]
  foreach mat $matlist {
    foreach { shortname longname } $mat {}
    if { [string equal $shortname $new_shortname] } {
      tk_messageBox -icon error -message \
        "The short name \"$shortname\" is already in use. Please specify a different name and try again." \
        -type ok  
      return
    }
    if { [string equal $longname $new_longname] } {
      tk_messageBox -icon error -message \
        "The long name \"$longname\" is already in use. Please specify a different name and try again." \
        -type ok  
      return
    }
  }
  
  set new_parfile $guiState(newMatTopName)

  set new_basis [list \
                [list \
                  $guiState(newMatAX) $guiState(newMatAY) $guiState(newMatAZ)] \
                [list \
                  $guiState(newMatBX) $guiState(newMatBY) $guiState(newMatBZ)] \
                [list \
                  $guiState(newMatCX) $guiState(newMatCY) $guiState(newMatCZ)] \
              ] 

#  puts "New basis $new_basis"

#  puts "addMaterial materialList \
              $new_shortname \
              $new_longname \
              $new_basis \
              $guiState(newMatUCName) \
              $guiState(newMatTopName) \
              $new_parfile \
              $guiState(newMatCutoff) \
              $guiState(newMatHex)"

  addMaterial materialList \
              $new_shortname \
              $new_longname \
              $new_basis \
              $guiState(newMatUCName) \
              $guiState(newMatTopName) \
              $new_parfile \
              $guiState(newMatCutoff) \
              $guiState(newMatHex)

  tk_messageBox -icon info -message \
    "The material \"$new_longname\" has been added to the material library. Remember that the Unit Cell PDB file and Topology files must be in the specified location to build a structure using this material." \
    -type ok  
  guiBuildMaterialMenu $menuwin

  return
}

proc ::inorganicBuilder::guiSaveState { fname } {
  variable guiState
  variable materialList
  
  set guiState(materialList) $materialList
  set chan [open $fname "w"]
#  puts $chan "INORGANICBUILDER"
  puts $chan [array get guiState]
  close $chan
  
  return  
}

proc ::inorganicBuilder::guiLoadState { fname } {
  variable guiState
  variable materialList

  # Delete any existing box
  if { $guiState(geomMol) != -1 } {
    mol delete $guiState(geomMol)
  }
  
  set chan [open $fname]
  set state_dat [read $chan]
  close $chan
  
  array set newState $state_dat
  
  set stateVars [array names newState]
  foreach vname $stateVars {
    set guiState($vname) $newState($vname)
  }
  set materialList $guiState(materialList)
  # Already deleted the old geomMol. The one saved in the state is invalid,
  # so mark it disabled
  set guiState(geomMol) -1
  guiCreateBox
  after idle "eval $guiState(curWin)"
  return
}

proc ::inorganicBuilder::newMaterialList { } {
  return {}
}

proc ::inorganicBuilder::addMaterial { listName materialName longName \
                                       basis pdb top parfile cutoff {hex 0} } {
  upvar $listName materialList
  array set materials $materialList
  
  set newMaterial [ list $materialName $longName $basis $pdb $top \
                         $cutoff $hex $parfile]
  set materials($materialName) $newMaterial
  set materialList [array get materials]
  return
}

proc ::inorganicBuilder::getMaterialNames {} {
  variable materialList
  
  set namelist {}
  foreach { shortName material } $materialList {
    lappend namelist [ list $shortName [lindex $material 1]]
  }
  return $namelist
}

proc ::inorganicBuilder::getMaterialLongName { materialName } {
  variable materialList
  
  array set materials $materialList
  set material $materials($materialName)
  return [lindex $material 1]
}

proc ::inorganicBuilder::getMaterialLongName { materialName } {
  variable materialList
  
  array set materials $materialList
  set material $materials($materialName)
  return [lindex $material 1]
}

proc ::inorganicBuilder::getMaterialUnitCell { materialName } {
  variable materialList
  
  array set materials $materialList
  set material $materials($materialName)
  return [lindex $material 2]
}

proc ::inorganicBuilder::getMaterialUnitCellFile { materialName } {
  variable materialList
  array set materials $materialList
  set material $materials($materialName)
  return [lindex $material 3]
}

proc ::inorganicBuilder::getMaterialTopologyFile { materialName } {
  variable materialList
  array set materials $materialList
  set material $materials($materialName)
  return [lindex $material 4]
}

proc ::inorganicBuilder::getMaterialCutoff { materialName } {
  variable materialList
  array set materials $materialList
  set material $materials($materialName)
  return [lindex $material 5]
}

proc ::inorganicBuilder::getMaterialHexSymmetry { materialName } {
  variable materialList
  
  array set materials $materialList
  set material $materials($materialName)
  return [lindex $material 6]
}

proc ::inorganicBuilder::getMaterialParFile { materialName } {
  variable materialList
  
  array set materials $materialList
  set material $materials($materialName)
  return [lindex $material 7]
}

proc ::inorganicBuilder::defineMaterialBox { center basis cutoff } {
  set box(type) "pp"
  defineBoxInternal box $center $basis $cutoff
  return [array get box]
}

proc ::inorganicBuilder::defineMaterialHexagonalBox { center \
                                                      basis cutoff } {
  set diam 1
  set height 1
  set box(type) "hex"
  set box(hexcenter) $center
  set box(hexdiam) $diam
  set box(hexheight) $height
  set box(hexodiam) [expr $diam/sqrt(3.)]

#  set uc_box [getMaterialUnitCell $material]
#  set uc_center [vecscale 0.5 [vecadd [lindex $uc_box 0] [lindex $uc_box 1]]]
#  set boxdiam $diam
#  set boxdim [ list $boxdiam $boxdiam $height]

  # Build the box
  defineBoxInternal box $center $basis $cutoff
#  puts "InorganicBuilder)box(basisa)=$box(basisa)"
#  puts "InorganicBuilder)box(basisb)=$box(basisb)"
  # Determine whether the basis vectors are separarted by 60 or 120 degrees
  # so we can find the vertices
  set ba $box(basisa)
  set bb $box(basisb)
  set costheta [expr [vecdot $ba $bb ] / \
                  ( [veclength $ba] * [veclength $bb] ) ]
#  puts "InorganicBuilder)costheta=$costheta"
  if { $costheta > 0 } {
    set ba $box(basisb)
    set bb [vecinvert $box(basisa)]
  }
  set onethirddiam [expr $diam/3.]
  set b0 [vecscale $onethirddiam [vecsub $ba $bb]]
  set b1 [vecscale $onethirddiam [vecadd [vecscale 2. $ba ] $bb]]
#  puts "InorganicBuilder)b0=$b0 b1=$b1 dot=[vecdot $b0 $b1] l0=[veclength $b0] l1=[veclength $b1]"
  if { [vecdot $b0 $b1] < 0 } {
    # We need to calculate p1
    set b2 $b1
    set b1 [vecadd $b0 $b2]
  } else {
    set b2 [vecsub $b1 $b0]
  }
  set b3 [vecinvert $b0]
  set b4 [vecinvert $b1]
  set b5 [vecinvert $b2]
  set box(hexverts) [list $b0 $b1 $b2 $b3 $b4 $b5]

  # calculate neighbor image vectors
  for {set i 0} { $i < 6 } { incr i } {
    set ni [expr ($i + 1) % 6]
    lappend box(hexneighbors) [vecadd [lindex $box(hexverts) $i] \
                              [lindex $box(hexverts) $ni]]
  }          
  
  #Compute face planes, so we can transform to hex coordinates efficiently
  set topvert [findHexVertices box]
  set dz [vecscale $box(hexheight) $box(basisc)]
  foreach vert $topvert {
    lappend botvert [vecadd $vert $dz]
  }

  set topcenter [vecsub $box(hexcenter) [vecscale 0.5 $dz]]
  for { set i 0 } { $i < 6 } { incr i } {
    set nxt [ expr ($i + 1) % 6 ]
    set p00 [lindex $topvert $i]
    set p01 [lindex $topvert $nxt]
    set p10 [lindex $botvert $i]
    
    lappend box(hexradial) [ find_plane $topcenter $p00 $p10 $p01]
    lappend box(hextranslate) \
      [vecsub [vecscale 2 $topcenter] [ vecadd $p00 $p01] ]
    lappend box(hexfaces) [ find_plane $p00 $p10 $p01 $topcenter]
  }

  return [array get box]
}

proc ::inorganicBuilder::defineBoxInternal { boxname center basis cutoff } {
  upvar $boxname box
  
  set box(material) "none"
  set box(cutoff) $cutoff
  
  set a [lindex $basis 0]
  set b [lindex $basis 1]
  set c [lindex $basis 2]

  set box(basisa) $a
  set box(basisb) $b
  set box(basisc) $c
  
  set box(la) [ veclength $box(basisa) ]
  set box(lb) [ veclength $box(basisb) ]
  set box(lc) [ veclength $box(basisc) ]
  
  set box(na) 1
  set box(nb) 1
  set box(nc) 1

  set boxcorner [vecadd $a $b $c]
  set box(origin) [vecsub $center [vecscale 0.5 $boxcorner]]
  set box(ox) [lindex $box(origin) 0]
  set box(oy) [lindex $box(origin) 1]
  set box(oz) [lindex $box(origin) 2]
#  puts "InorganicBuilder)origin=$box(origin)"
  
  set box(da) $box(la)
  set box(db) $box(lb)
  set box(dc) $box(lc)
  
  set box(cross_ab) [veccross $a $b]
  set box(cross_ac) [veccross $a $c]
  set box(cross_bc) [veccross $b $c]

  # Normalize cross products so they point toward the inside from the origin
  if { [vecdot $box(cross_ab) $c] < 0 } {
    set box(cross_ab) [vecinvert $box(cross_ab)]
  }
  if { [vecdot $box(cross_ac) $b] < 0 } {
    set box(cross_ac) [vecinvert $box(cross_ac)]
  }
  if { [vecdot $box(cross_bc) $a] < 0 } {
    set box(cross_bc) [vecinvert $box(cross_bc)]
  }

  set basis_mat { { ? ? ? } { ? ? ? } { ? ? ? } }
  for { set i 0 } { $i < 3 } { incr i } {
    lset basis_mat [list $i 0] [lindex $box(basisa) $i]
    lset basis_mat [list $i 1] [lindex $box(basisb) $i]
    lset basis_mat [list $i 2] [lindex $box(basisc) $i]
  }
  set box(transform_mat) [ Inverse3 $basis_mat ]
  set box(excludelist) {}

  return
}

proc ::inorganicBuilder::newMaterialBox { material center boxsize \
                                         { adjcharges false } } {
  set box(type) "pp"
  newBoxInternal box $material $center $boxsize $adjcharges
  return [array get box]
}

proc ::inorganicBuilder::newMaterialHexagonalBox { material center \
                                                   diam height \
                                                   { adjcharges false } } {
  set box(type) "hex"
  set box(hexcenter) $center
  set box(hexdiam) $diam
  set box(hexheight) $height
  set box(hexodiam) [expr $diam/sqrt(3.)]

  set uc_box [getMaterialUnitCell $material]
  set uc_center [vecscale 0.5 [vecadd [lindex $uc_box 0] [lindex $uc_box 1]]]
  set boxdiam $diam
  set boxdim [ list $boxdiam $boxdiam $height]

  # Build the box
  newBoxInternal box $material $center $boxdim $adjcharges
#  puts "InorganicBuilder)box(basisa)=$box(basisa)"
#  puts "InorganicBuilder)box(basisb)=$box(basisb)"
  # Determine whether the basis vectors are separarted by 60 or 120 degrees
  # so we can find the vertices
  set ba $box(basisa)
  set bb $box(basisb)
  set costheta [expr [vecdot $ba $bb ] / \
                  ( [veclength $ba] * [veclength $bb] ) ]
#  puts "InorganicBuilder)costheta=$costheta"
  if { $costheta > 0 } {
    set ba $box(basisb)
    set bb [vecinvert $box(basisa)]
  }
  set onethirddiam [expr $boxdiam/3.]
  set b0 [vecscale $onethirddiam [vecsub $ba $bb]]
  set b1 [vecscale $onethirddiam [vecadd [vecscale 2. $ba ] $bb]]
#  puts "InorganicBuilder)b0=$b0 b1=$b1 dot=[vecdot $b0 $b1] l0=[veclength $b0] l1=[veclength $b1]"
  if { [vecdot $b0 $b1] < 0 } {
    # We need to calculate p1
    set b2 $b1
    set b1 [vecadd $b0 $b2]
  } else {
    set b2 [vecsub $b1 $b0]
  }
  set b3 [vecinvert $b0]
  set b4 [vecinvert $b1]
  set b5 [vecinvert $b2]
  set box(hexverts) [list $b0 $b1 $b2 $b3 $b4 $b5]

  # calculate neighbor image vectors
  for {set i 0} { $i < 6 } { incr i } {
    set ni [expr ($i + 1) % 6]
    lappend box(hexneighbors) [vecadd [lindex $box(hexverts) $i] \
                              [lindex $box(hexverts) $ni]]
  }          
  
  #Compute face planes, so we can transform to hex coordinates efficiently
  set topvert [findHexVertices box]
  set dz [vecscale $box(hexheight) $box(basisc)]
  foreach vert $topvert {
    lappend botvert [vecadd $vert $dz]
  }

  set topcenter [vecsub $box(hexcenter) [vecscale 0.5 $dz]]
  for { set i 0 } { $i < 6 } { incr i } {
    set nxt [ expr ($i + 1) % 6 ]
    set p00 [lindex $topvert $i]
    set p01 [lindex $topvert $nxt]
    set p10 [lindex $botvert $i]
    
    lappend box(hexradial) [ find_plane $topcenter $p00 $p10 $p01]
    lappend box(hextranslate) \
      [vecsub [vecscale 2 $topcenter] [ vecadd $p00 $p01] ]
    lappend box(hexfaces) [ find_plane $p00 $p10 $p01 $topcenter]
  }

  return [array get box]
}

proc ::inorganicBuilder::newBoxInternal { boxname material center \
                                          boxsize adjcharges } {
  variable materialList
  upvar $boxname box
  
  array set materials $materialList 
  set box(material) $materials($material)
  foreach { materialName longName basis pdb top cutoff hex parfname } \
          $box(material) {}
  set box(pdb) $pdb
  set box(top) $top
  set box(cutoff) $cutoff
  set box(adjcharges) $adjcharges
  
  set a [lindex $basis 0]
  set b [lindex $basis 1]
  set c [lindex $basis 2]

  set box(basisa) $a
  set box(basisb) $b
  set box(basisc) $c
  
  set box(la) [ veclength $box(basisa) ]
  set box(lb) [ veclength $box(basisb) ]
  set box(lc) [ veclength $box(basisc) ]
  
  set box(na) [lindex $boxsize 0]
  set box(nb) [lindex $boxsize 1]
  set box(nc) [lindex $boxsize 2]

#  puts "InorganicBuilder)box(na)=$box(na) a=$a"
  set boxcorner [vecadd [vecscale $box(na) $a] [vecscale $box(nb) $b] \
                        [vecscale $box(nc) $c]]
  set box(origin) [vecsub $center [vecscale 0.5 $boxcorner]]
  set box(ox) [lindex $box(origin) 0]
  set box(oy) [lindex $box(origin) 1]
  set box(oz) [lindex $box(origin) 2]
  
  set box(da) [expr $box(la) * $box(na)]
  set box(db) [expr $box(lb) * $box(nb)]
  set box(dc) [expr $box(lc) * $box(nc)]
  
  set box(cross_ab) [veccross $a $b]
  set box(cross_ac) [veccross $a $c]
  set box(cross_bc) [veccross $b $c]

  # Normalize cross products so they point toward the inside from the origin
  if { [vecdot $box(cross_ab) $c] < 0 } {
    set box(cross_ab) [vecinvert $box(cross_ab)]
  }
  if { [vecdot $box(cross_ac) $b] < 0 } {
    set box(cross_ac) [vecinvert $box(cross_ac)]
  }
  if { [vecdot $box(cross_bc) $a] < 0 } {
    set box(cross_bc) [vecinvert $box(cross_bc)]
  }

  set basis_mat { { ? ? ? } { ? ? ? } { ? ? ? } }
  for { set i 0 } { $i < 3 } { incr i } {
    lset basis_mat [list $i 0] [lindex $box(basisa) $i]
    lset basis_mat [list $i 1] [lindex $box(basisb) $i]
    lset basis_mat [list $i 2] [lindex $box(basisc) $i]
  }
  set box(transform_mat) [ Inverse3 $basis_mat ]
  set box(excludelist) {}

  return
}

proc ::inorganicBuilder::getBoxMaterial { boxlist } {
  array set box $boxlist
  return [lindex $box(material) 0]
}

proc ::inorganicBuilder::printBox { boxlist } {
  array set box $boxlist
  
  puts "InorganicBuilder)inorganicBuilder::boxsize ($box(na),$box(nb),$box(nc))"
  puts "InorganicBuilder)inorganicBuilder::origin ($box(ox),$box(oy),$box(oz))"
  for { set k 0 } { $k < $box(nc) } { incr k } {
    set zz [lindex $box(state) $k ]
    for { set j 0 } { $j < $box(nb) } { incr j } {
      set yy [lindex $zz $j ]
      puts "InorganicBuilder)inorganicBuilder::excludelist($j,$k) $yy"
    }
    puts "InorganicBuilder)-------------------------------------------"
  }
  puts "InorganicBuilder)inorganicBuilder::excludelist $box(excludelist)"
}

# *** MODIFIED, THEREFORE ***
# *** ADDED ***
proc ::inorganicBuilder::setVMDPeriodicBox { boxlist {molid top}} {
  variable guiState
  
  if { $guiState(mmod) != 1 } {
       set guiState(mmod) 1.5
  } else {
	  	  
    array set box $boxlist
    set a [ expr $box(na) * [veclength $box(basisa)] * $guiState(mmod)]
    set b [ expr $box(nb) * [veclength $box(basisb)] * $guiState(mmod)]
    set c [ expr $box(nc) * [veclength $box(basisc)] * $guiState(mmod)]
  
    set anorm [vecnorm $box(basisa)]
    set bnorm [vecnorm $box(basisb)]
    set cnorm [vecnorm $box(basisc)]
  
    set rad2deg 57.2957795131
    set alpha [expr acos([vecdot $bnorm $cnorm]) * $rad2deg]
    set beta [expr acos([vecdot $cnorm $anorm]) * $rad2deg]
    set gamma [expr acos([vecdot $anorm $bnorm]) * $rad2deg]
    
    set guiState(boxX2R) $alpha
    set guiState(boxY2R) $beta
    set guiState(boxZ2R) $gamma
    set guiState(boxX2Rh) $alpha
    set guiState(boxY2Rh) $beta
    set guiState(boxZ2Rh) $gamma
  
    molinfo $molid set {a b c alpha beta gamma} \
      [list $a $b $c $alpha $beta $gamma]
   
  }
  return
}

# *** ADDED ***
proc ::inorganicBuilder::setVMDPeriodPDB { molid pdbfilename } {
  variable guiState

  # Get the length to move in each direction for periodicity (max length in that direction)
  set a [format "%9.3f" $guiState(lenboxX)]
  set b [format "%9.3f" $guiState(lenboxY)]
  set c [format "%9.3f" $guiState(lenboxZ)]

  # Allocate the rotations
  if { $guiState(StructHexBox) } {
	  set alpha [format "%7.2f" $guiState(boxX2Rh)]
	  set beta  [format "%7.2f" $guiState(boxY2Rh)]
	  set gamma [format "%7.2f" $guiState(boxZ2Rh)]
  } else {
	  set alpha [format "%7.2f" $guiState(boxX2R)]
	  set beta  [format "%7.2f" $guiState(boxY2R)]
	  set gamma [format "%7.2f" $guiState(boxZ2R)]
  }


  # Remove space if not periodic
  if { $guiState(StructSurfPeriodx) != 1 } {
      set a [format "%9.3f" "0.000"]
      set $guiState(boxX2) 1
  }
  if { $guiState(StructSurfPeriody) != 1 } {
	  set b [format "%9.3f" "0.000"]
      set $guiState(boxY2) 1
  }
  if { $guiState(StructSurfPeriodz) != 1 } {
	  set c [format "%9.3f" "0.000"]
      set $guiState(boxZ2) 1
  }


  molinfo $molid set {a b c alpha beta gamma} \
    [list $a $b $c $alpha $beta $gamma]

  set cryst "$a$b$c$alpha$beta$gamma"
  set p0 [open $pdbfilename r]
  set out [open "tmp_period.pdb" w]
  gets $p0 line
  while { ![string equal [lindex $line 0] "ATOM"] } {
	  if { ![string equal [lindex $line 0] "CRYST1"] } {
		puts $out $line
	  }
		gets $p0 line
  }
  puts $out "CRYST1$cryst P 1           1"  
  puts $out $line
  while {[gets $p0 line] > 0} {
    puts $out $line
  }
  close $p0
  close $out
  file delete -force $pdbfilename
  file rename -force "tmp_period.pdb" $pdbfilename

  display resetview     
  return
}

# *** ADDED ***
proc ::inorganicBuilder::structBoxMolecule { } {

  variable guiState
  global M_PI


  # Delete any existing boxes
  mol delete $guiState(sboxmol)

  # Draw the new box
  set guiState(sboxmol) [mol new]
  draw materials off

  # If the hex box has not been modified before, use default values
  if { $guiState(StructHexBox) } {
	  set angleX $guiState(boxX2Rh)
	  set angleY $guiState(boxY2Rh)
	  set angleZ $guiState(boxZ2Rh)
  } else {
	  set angleX $guiState(boxX2R)
	  set angleY $guiState(boxY2R)
	  set angleZ $guiState(boxZ2R)
  }
  
  # Watch out for 0 values becoming blanks apparently
  if { $angleX == "" } {
	  set angleX 90
  }
  if { $angleY == "" } {
	  set angleY 90
  }
  if { $angleZ == "" } {
	  set angleZ 90
  }

  set guiState(drawcolor) "yellow"
  set guiState(drawstyle) "style solid"

  set o [list $guiState(origX) $guiState(origY) $guiState(origZ)]
  
  if {$guiState(StructHexBox)} {
	set unitD [expr ( $guiState(hexD2) / 7.595)]
	set unitZ3 [expr ( $guiState(boxZ3) / 2.902)]


    set thisHexBox [ newMaterialHexagonalBox \
                               "Si3N4" $o $unitD $unitZ3 0]
    set guiState(structBox) $thisHexBox
    drawHexBox $thisHexBox $guiState(sboxmol)        
    set vertlist [getVertices $thisHexBox]

    
	
  } else {
	set unitX [expr ( $guiState(boxX2) / 4.0782)]
	set unitY [expr ( $guiState(boxY2) / 4.0782)]
	set unitZ [expr ( $guiState(boxZ2) / 4.0782)]
    set boxsize [list $unitX $unitY $unitZ]
    set thisSquareBox [ newMaterialBox "Au" $o $boxsize 0]
    set guiState(structBox) $thisSquareBox
    drawBox $thisSquareBox $guiState(sboxmol)      
    set vertlist [getVertices $thisSquareBox]

  }
    
    foreach { x y z } [lindex $vertlist 0] {}
    set boxXmin $x
    set boxXmax $x
    set boxYmin $y
    set boxYmax $y
    set boxYmax2 $y
    set boxZmin $z
    set boxZmax $z
    foreach vert $vertlist {
      foreach { x y z } $vert {}
      if {$x < $boxXmin} {
        set boxXmin $x
      }
      if {$x > $boxXmax} {
        set boxXmax $x
      }
      if {$y < $boxYmin} {
        set boxYmin $y
      }
      if {$y > $boxYmax} {
        set boxYmax2 $boxYmax
        set boxYmax $y
      }
      if {$z < $boxZmin} {
        set boxZmin $z
      }
      if {$z > $boxZmax} {
        set boxZmax $z
      }
    }


    set sixrot [expr 60 * $M_PI/180]
    set guiState(lenboxX) [expr sqrt(($boxXmax-$boxXmin)**2)]

    if {$guiState(StructHexBox)} {
		set guiState(lenboxY) [expr sqrt(($boxYmax2-$boxYmin)**2)/sin($sixrot)]
	} else {
		set guiState(lenboxY) [expr sqrt(($boxYmax-$boxYmin)**2)]
	}
	
    set guiState(lenboxZ) [expr sqrt(($boxZmax-$boxZmin)**2)]

  #Convert to Rotations to Radians

    set xrot [expr $angleX * $M_PI/180]
    set yrot [expr $angleY * $M_PI/180]
    set zrot [expr $angleZ * $M_PI/180]


  # Build definition vectors
    set xvec "$guiState(lenboxX) 0 0"

    set yvec "[expr cos($zrot) * $guiState(lenboxY)] \
			  [expr sin($zrot) * $guiState(lenboxY)] 0"

    set zvec ""
    set z1 [expr cos($yrot)]

    if { [expr sin($zrot)] >= 0 } {
		set z2 [expr (cos($xrot) - cos($yrot)*cos($zrot)) / sin($zrot)]		
	} else {
		set z2 0
		set zvec "0 0 0"
	}
	
    set z31 [expr (1.0 - $z1*$z1 - $z2*$z2)]
    if { ($z31 >= 0)  && ($zvec != "0 0 0") } {
		set z3 [expr sqrt($z31)]
		set zvec " [expr $z1 * $guiState(lenboxZ)] [expr $z2 * $guiState(lenboxZ)] \
			   [expr $z3 * $guiState(lenboxZ)]"    
	} else {
		set z3 0
		set zvec "0 0 0"    
	}

    # round all of the vectors to a more appropriate 2 decimal places
    set xvec [lreplace $xvec 0 0 [format "%.2f" [lindex $xvec 0]]]
    set yvec [lreplace $yvec 0 0 [format "%.2f" [lindex $yvec 0]]]
    set yvec [lreplace $yvec 1 1 [format "%.2f" [lindex $yvec 1]]]
    set zvec [lreplace $zvec 0 0 [format "%.2f" [lindex $zvec 0]]]
    set zvec [lreplace $zvec 1 1 [format "%.2f" [lindex $zvec 1]]]
    set zvec [lreplace $zvec 2 2 [format "%.2f" [lindex $zvec 2]]]
  
    set guiState(sspVecs) "{$xvec} {$yvec} {$zvec} {$o}" 

	# drawing for hex
    if {$guiState(StructHexBox)} {
      if {$guiState(StructSurfPeriodx) != 0} {
        set guiState(drawcolor) "red"
        set guiState(drawstyle) "style dashed"

        set o [ list [expr $guiState(origX) + [lindex $xvec 0]] \
        [expr $guiState(origY) + [lindex $xvec 1]] \
        [expr $guiState(origZ) + [lindex $xvec 2]] ]
        set thisDashHexBox [ newMaterialHexagonalBox \
                                 "Si3N4" $o $unitD $unitZ3 0]
        drawHexBox $thisDashHexBox $guiState(sboxmol)
      }
      if {$guiState(StructSurfPeriody) != 0} {
        set guiState(drawcolor) "green"
        set guiState(drawstyle) "style dashed"
  	
        set o [ list [expr $guiState(origX) + [lindex $yvec 0]] \
        [expr $guiState(origY) + [lindex $yvec 1]] \
        [expr $guiState(origZ) + [lindex $yvec 2]] ]
        set thisDashHexBox [ newMaterialHexagonalBox \
                                 "Si3N4" $o $unitD $unitZ3 0]
        drawHexBox $thisDashHexBox $guiState(sboxmol)
      }
      if {$guiState(StructSurfPeriodz) != 0} {
        set guiState(drawcolor) "blue"
        set guiState(drawstyle) "style dashed"
  	
        set o [ list [expr $guiState(origX) + [lindex $zvec 0]] \
        [expr $guiState(origY) + [lindex $zvec 1]] \
        [expr $guiState(origZ) + [lindex $zvec 2]] ]
        set thisDashHexBox [ newMaterialHexagonalBox \
                                 "Si3N4" $o $unitD $unitZ3 0]
        drawHexBox $thisDashHexBox $guiState(sboxmol)
      }
	# drawing for normal box
    } else {
      if {$guiState(StructSurfPeriodx) != 0} {
        set guiState(drawcolor) "red"
        set guiState(drawstyle) "style dashed"
  
        set o [ list [expr $guiState(origX) + [lindex $xvec 0]] \
        [expr $guiState(origY) + [lindex $xvec 1]] \
        [expr $guiState(origZ) + [lindex $xvec 2]] ]
        set thisDashBox [ newMaterialBox \
                                 "Au" $o $boxsize 0]
        drawBox $thisDashBox $guiState(sboxmol)
      }
      if {$guiState(StructSurfPeriody) != 0} {
        set guiState(drawcolor) "green"
        set guiState(drawstyle) "style dashed"
  	
        set o [ list [expr $guiState(origX) + [lindex $yvec 0]] \
        [expr $guiState(origY) + [lindex $yvec 1]] \
        [expr $guiState(origZ) + [lindex $yvec 2]] ]
        set thisDashBox [ newMaterialBox \
                                 "Au" $o $boxsize 0]
        drawBox $thisDashBox $guiState(sboxmol)
      }
      if {$guiState(StructSurfPeriodz) != 0} {
        set guiState(drawcolor) "blue"
        set guiState(drawstyle) "style dashed"
  	
        set o [ list [expr $guiState(origX) + [lindex $zvec 0]] \
        [expr $guiState(origY) + [lindex $zvec 1]] \
        [expr $guiState(origZ) + [lindex $zvec 2]] ]
        set thisDashBox [ newMaterialBox \
                                 "Au" $o $boxsize 0]
        drawBox $thisDashBox $guiState(sboxmol)
      }  
    }
    
  display resetview

  return
}


proc ::inorganicBuilder::getCellBasisVectors { boxlist } {
  array set box $boxlist
  set a [vecscale $box(na) $box(basisa)]
  set b [vecscale $box(nb) $box(basisb)]
  set c [vecscale $box(nc) $box(basisc)]
  set o [vecadd $box(origin) [vecscale 0.5 [vecadd $a $b $c]]]
  set basis [ list $a $b $c $o]
  return $basis
}

proc ::inorganicBuilder::getBondCutoff { boxlist } {
  array set box $boxlist
  
  return $box(cutoff)
}

proc ::inorganicBuilder::getVertices { boxlist } {
  array set box $boxlist
  
  if {[string equal $box(type) "hex"]} {
    # findHexVertices returns corners of top face
    set vertlist [findHexVertices box]
    set newvertlist {}
    set basiscvec [vecscale $box(hexheight) $box(basisc)]
    foreach vert $vertlist {
      lappend newvertlist [vecadd $vert $basiscvec]
    }
    set vertlist [concat $vertlist $newvertlist]
  } else {
    set vertlist [list [getRealCoord box {0 0 0} ] ]
    lappend vertlist [getRealCoord box [list 0 0 $box(nc)] ]
    lappend vertlist [getRealCoord box [list 0 $box(nb) 0] ]
    lappend vertlist [getRealCoord box [list 0 $box(nb) $box(nc)] ]
    lappend vertlist [getRealCoord box [list $box(na) 0 0] ]
    lappend vertlist [getRealCoord box [list $box(na) 0 $box(nc)] ]
    lappend vertlist [getRealCoord box [list $box(na) $box(nb) 0] ]
    lappend vertlist [getRealCoord box [list $box(na) $box(nb) $box(nc)] ]
  }
  return $vertlist
}


# *** MODIFIED, THEREFORE ***
# *** ADDED ***
proc ::inorganicBuilder::draw_simple_box { layer orig a b c } {
  variable guiState
  
  if {$layer == $guiState(sboxmol) } {
	  set drcolor $guiState(drawcolor)
	  set drstyle $guiState(drawstyle)
  } else {
	  set drcolor "blue"
	  set drstyle "style solid"
  }
  
#  puts "InorganicBuilder)draw simple box $layer $orig $a $b $c"
  set oa [vecadd $orig $a]
  set ob [vecadd $orig $b]
  set ab [vecadd $oa $b]
  set oc [vecadd $orig $c]
  set ac [vecadd $oa $c]
  set bc [vecadd $ob $c]
  set abc [vecadd $ab $c]
  set w 3
#  puts "InorganicBuilder)$oa=$orig $oa $ob $oc"
  
  set obj {}
#  graphics $layer line $orig $oa
#  graphics $layer line $oa $ab
#  graphics $layer line $ab $ob
#  graphics $layer line $ob $orig
  lappend obj [list line $orig $oa width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $oa $ab width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $ab $ob width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $ob $orig width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  
#  graphics $layer line $orig $oc
#  graphics $layer line $oa $ac
#  graphics $layer line $ab $abc
#  graphics $layer line $ob $bc
  lappend obj [list line $orig $oc width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $oa $ac width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $ab $abc width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $ob $bc width $w [lindex $drstyle 0] [lindex $drstyle 1]]

#  graphics $layer line $oc $ac
#  graphics $layer line $ac $abc
#  graphics $layer line $abc $bc
#  graphics $layer line $bc $oc
  lappend obj [list line $oc $ac width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $ac $abc width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $abc $bc width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  lappend obj [list line $bc $oc width $w [lindex $drstyle 0] [lindex $drstyle 1]]
  set drawobj [::drawenv::draw $layer $obj $drcolor "Opaque" ]
  return $drawobj
}

proc ::inorganicBuilder::draw_simple_solid_box { layer orig a b c } {
  set oa [vecadd $orig $a]
  set ob [vecadd $orig $b]
  set ab [vecadd $oa $b]
  set oc [vecadd $orig $c]
  set ac [vecadd $oa $c]
  set bc [vecadd $ob $c]
  set abc [vecadd $ab $c]
  
  set obj {}
#  graphics $layer triangle $orig $oa $ob
#  graphics $layer triangle $oa $ab $ob
  lappend obj [list triangle $orig $oa $ob]
  lappend obj [list triangle $oa $ab $ob]

#  graphics $layer triangle $orig $oa $oc
#  graphics $layer triangle $oa $ac $oc
  lappend obj [list triangle $orig $oa $oc]
  lappend obj [list triangle $oa $ac $oc]

#  graphics $layer triangle $orig $oc $ob
#  graphics $layer triangle $oc $bc $ob
  lappend obj [list triangle $orig $oc $ob]
  lappend obj [list triangle $oc $bc $ob]
  
#  graphics $layer triangle $oc $ac $bc
#  graphics $layer triangle $bc $abc $ac
  lappend obj [list triangle $oc $ac $bc]
  lappend obj [list triangle $bc $abc $ac]

#  graphics $layer triangle $ob $ab $bc
#  graphics $layer triangle $ab $abc $bc
  lappend obj [list triangle $ob $ab $bc]
  lappend obj [list triangle $ab $abc $bc]
  
#  graphics $layer triangle $oa $ab $ac
#  graphics $layer triangle $ac $abc $ab
  lappend obj [list triangle $oa $ab $ac]
  lappend obj [list triangle $ac $abc $ab]

  set drawobj [::drawenv::draw $layer $obj "red" "Opaque" ]
  return $drawobj
}

proc ::inorganicBuilder::drawBox { boxlist molid } {
  array set box $boxlist
  
  set orig [ getRealCoord box { 0 0 0 } ]
  set a [ vecsub [getRealCoord box [list $box(na) 0 0]] $orig ]
  set b [ vecsub [getRealCoord box [list 0 $box(nb) 0]] $orig ]
  set c [ vecsub [getRealCoord box [list 0 0 $box(nc)]] $orig ]
  set ret [draw_simple_box $molid $orig $a $b $c]
#  puts "InorganicBuilder)DrawBox $orig $a $b $c"

  return $ret
}

# *** MODIFIED, THEREFORE ***
# *** ADDED ***
proc ::inorganicBuilder::drawHexBox { boxlist molid } {
  variable guiState
  array set box $boxlist

  if {$molid == $guiState(sboxmol) } {
	  set drcolor $guiState(drawcolor)
	  set drstyle $guiState(drawstyle)
  } else {
	  set drcolor "blue"
	  set drstyle "style solid"
  }


  set vert0 [findHexVertices box]
  set zscaled [ vecscale $box(hexheight) $box(basisc)]
  foreach vert $vert0 {
    lappend vert1 [ vecadd $vert $zscaled ]
  }
  set p00 [lindex $vert0 5]
  set p01 [lindex $vert1 5]
  set obj {}
  for {set i 0} { $i < 6 } { incr i } {
    set p10 [lindex $vert0 $i]
    set p11 [lindex $vert1 $i]
    lappend obj [list line $p00 $p10 [lindex $drstyle 0] [lindex $drstyle 1]]
    lappend obj [list line $p00 $p01 [lindex $drstyle 0] [lindex $drstyle 1]]
    lappend obj [list line $p01 $p11 [lindex $drstyle 0] [lindex $drstyle 1]]
    set p00 $p10
    set p01 $p11
  }

  set drawobj [::drawenv::draw $molid $obj $drcolor "Opaque" ]
  return $drawobj
}

proc ::inorganicBuilder::newBlock { type name params } {
  switch $type {
    "pp" {
#      puts "InorganicBuilder)New parallelopiped $params"
      foreach {a b c o} $params {}
      set inv_tmat {{? ? ?} {? ? ?} {? ? ?}}
      for {set i 0} {$i < 3} {incr i} {
        lset inv_tmat [list $i 0] [lindex $a $i]
        lset inv_tmat [list $i 1] [lindex $b $i]
        lset inv_tmat [list $i 2] [lindex $c $i]
      }
      lappend params [Inverse3 $inv_tmat]
    }
    "sphere" {
#      puts "InorganicBuilder)New sphere $params"
      set r [lindex $params 1]
      lappend params [expr $r*$r]
    }
    "cylinder" {
#      puts "InorganicBuilder)New cylinder $params"
      foreach {o a r} $params {}
      set l [veclength $a]
      set u [vecnorm $a]
      lappend params [expr $r * $r ] $l $u
    }
    "th" {
#      puts "InorganicBuilder)New tetrahedron $params"
      foreach {a b c o} $params {}
      set inv_tmat {{? ? ?} {? ? ?} {? ? ?}}
      for {set i 0} {$i < 3} {incr i} {
        lset inv_tmat [list $i 0] [lindex $a $i]
        lset inv_tmat [list $i 1] [lindex $b $i]
        lset inv_tmat [list $i 2] [lindex $c $i]
      }
      lappend params [Inverse3 $inv_tmat]
    }
    "cone" {
#      puts "InorganicBuilder)New cone $params"
      foreach {o a r} $params {}
      set l [veclength $a]
      set u [vecnorm $a]
      lappend params [expr $r * $r] $l $u
    }
    "selection" {
#      puts "InorganicBuilder)New VMD selection"
    }
    "dxfile" {
#      puts "InorganicBuilder)New DX File"
    }
    default {
      puts "InorganicBuilder)Unknown block type"
    }
  }
#  puts "InorganicBuilder)params [list $type {} $params]"
  return [list $type {} $params $name]
}

# *** ADDED ***
proc ::inorganicBuilder::newStruct { type name params } {
  switch $type {
    "peg" {
#     Perform any functions here and re-store in params
      set surfAtomSel [lindex $params 0]
      set placeholder [lindex $params 1]
      set placeAtomSel [lindex $params 2]
    }
    "dna" {
#     Perform any functions here and re-store in params
      set surfAtomSel [lindex $params 0]
      set placeholder [lindex $params 1]
      set placeAtomSel [lindex $params 2]
    }
    "custom" {
      set customSurfAtomSel [lindex $params 0]
      set customStructAtomSel [lindex $params 1]
      set placeAtomSel [lindex $params 2]
    }
    default {
      puts "InorganicBuilder)Unknown block type"
    }
  }
  return [list $type {} $params $name]
}



proc ::inorganicBuilder::printBlock { block } {
  foreach {type bb params name} $block {}
  puts "InorganicBuilder)Printing block type <$type>"
  switch $type {
    "pp" {
      foreach {a b c o t} $params {}
      puts "InorganicBuilder)A=$a"
      puts "InorganicBuilder)B=$b"
      puts "InorganicBuilder)C=$c"
      puts "InorganicBuilder)O=$o"
      puts "InorganicBuilder)T=$t"
    }
    "sphere" {
      foreach {c r rsq} $params {}
      puts "InorganicBuilder)C=$c"
      puts "InorganicBuilder)R=$r"
      puts "InorganicBuilder)R^2=$rsq"
    }
    "cylinder" {
      foreach {o a r rsq l u} $params {}
      puts "InorganicBuilder)O=$o"
      puts "InorganicBuilder)A=$a"
      puts "InorganicBuilder)R=$r"
      puts "InorganicBuilder)R^2=$rsq"
      puts "InorganicBuilder)L=$l"
      puts "InorganicBuilder)U=$u"
    }
    "th" {
      foreach {a b c o t} $params {}
      puts "InorganicBuilder)A=$a"
      puts "InorganicBuilder)B=$b"
      puts "InorganicBuilder)C=$c"
      puts "InorganicBuilder)O=$o"
      puts "InorganicBuilder)T=$t"
    }
    "cone" {
      foreach {o a r l u} $params {}
      puts "InorganicBuilder)O=$o"
      puts "InorganicBuilder)A=$a"
      puts "InorganicBuilder)R=$r"
      puts "InorganicBuilder)L=$l"
      puts "InorganicBuilder)U=$u"
    }
    "selection" {
      foreach { sel include } $params {}
      puts "InorganicBuilder)Sel=$sel"
      puts "InorganicBuilder)Included=$include"
    }
    "dxfile" {
      foreach { DX incDX } $params {}
      puts "InorganicBuilder)DX=$DX"
      puts "InorganicBuilder)IncludedDX=$incDX"
    }
    default {
      puts "InorganicBuilder)Unknown type"
    }
  }
}

proc ::inorganicBuilder::drawBlock { block molid } {
  variable guiState
  foreach {type bb params name} $block {}
#  puts "InorganicBuilder)Drawing block type <$type> <$params>"
  switch $type {
    "pp" {
      set a [lindex $params 0]
      set b [lindex $params 1]
      set c [lindex $params 2]
      set o [lindex $params 3]
      set ret [draw_simple_solid_box $molid $o $a $b $c]
    }
    "sphere" {
      set o [lindex $params 0]
      set r [lindex $params 1]
      set ret [::drawenv::draw $molid [list [list \
        sphere $o radius $r resolution 20]] "red" "Opaque"]
    }
    "cylinder" {
      set o [lindex $params 0]
      set a [lindex $params 1]
      set r [lindex $params 2]
      set ret [::drawenv::draw $molid [list [list \
        cylinder $o [vecadd $o $a] radius $r resolution 20 filled yes]] \
        "red" "Opaque"]
    }
    "th" {
      set a [lindex $params 0]
      set b [lindex $params 1]
      set c [lindex $params 2]
      set o [lindex $params 3]
      set oa [vecadd $o $a]
      set ob [vecadd $o $b]
      set oc [vecadd $o $c]
      
      set obj {}
      lappend obj [list triangle $o $oa $ob]
      lappend obj [triangle $o $oa $oc]
      lappend obj [triangle $o $ob $oc]
      lappend obj [triangle $oa $ob $oc]
      set ret [::drawenv::draw $molid $obj "red" "Opaque"]
      
    }
    "cone" {
      set o [lindex $params 0]
      set a [lindex $params 1]
      set r [lindex $params 2]
#      puts "InorganicBuilder)cone:   [list cone $o [vecadd $o $a] radius $r resolution 20]"
      set ret [::drawenv::draw $molid [list [list \
        cone $o [vecadd $o $a] radius $r resolution 20]] "red" "Opaque"]
    }
    "selection" {
      puts "InorganicBuilder)Can't draw selections"
      set ret -1
    }
    "dxfile" {
      puts "InorganicBuilder)A DX File was used"
      set ret -1
    }
    default {
      puts "InorganicBuilder)Can't draw that block"
      set ret -1
    }
  }
  return $ret
}





proc ::inorganicBuilder::getBlockType { block } {
  return [lindex $block 0]
}

proc ::inorganicBuilder::getBlockName { block } {
  return [lindex $block 3]
}

proc ::inorganicBuilder::getBlockParams { block } {
  return [lindex $block 2]
}


# *** ADDED ***
proc ::inorganicBuilder::getStructType { struct } {
  return [lindex $struct 0]
}
# *** ADDED ***
proc ::inorganicBuilder::getStructName { struct } {
  return [lindex $struct 3]
}
# *** ADDED ***
proc ::inorganicBuilder::getStructParams { struct } {
  return [lindex $struct 2]
}


proc ::inorganicBuilder::storeBlock { boxname block } {
  upvar $boxname boxlist
  array set box $boxlist
  
  # Add the bounding box to the block
  lset block 1 [computeBlockBoundingBox box $block]
  
  # Store the block
  set blockindex [expr [llength [lappend box(excludelist) $block ]] - 1 ]

  # Transform the box back into a list
  set boxlist [array get box]
  return
}


# Return a bounding box for the shape in cell-coordinates
proc ::inorganicBuilder::getBlockBoundingBox { block } {
  return [lindex $block 1]
}

proc ::inorganicBuilder::computeBlockBoundingBox { boxname block } {
  upvar $boxname box
 
  foreach {type bb params name} $block {}
  set xmax $box(na)
  set ymax $box(nb)
  set zmax $box(nc)
  
  # No bounding-box code for hext transformations yet, so we have to scan
  # the entire space
  if { [string equal $box(type) "hex"] } {
    set ret [ list [list 0 0 0] [list $xmax $ymax $zmax] ]
    return $ret
  }
 
  switch $type {
    "pp" {
      foreach {a b c o tmat } $params {}
      set cellcoords {}
      lappend cellcoords [getCellCoord box $o]
      set x [vecadd $o $a]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $x $b]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $x $c]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $o $b]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $x $c]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $o $c]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $x $a]
      lappend cellcoords [getCellCoord box $x]

      set ret [findMinMaxCoords $cellcoords $xmax $ymax $zmax]
    }
    "sphere" {
      set o [ lindex $params 0 ]
      foreach { ox oy oz } $o {}
      set r [ lindex $params 1 ]
      set x0 [expr $ox - $r]
      set y0 [expr $oy - $r]
      set z0 [expr $oz - $r]
      set x1 [expr $ox + $r]
      set y1 [expr $oy + $r]
      set z1 [expr $oz + $r]
      set cellcoords {}

      set dx [list $r $r $r]
      set x [vecsub $o $dx]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $o $dx]
      lappend cellcoords [getCellCoord box $x]

      set dx [list [expr -$r] $r $r]
      set x [vecsub $o $dx]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $o $dx]
      lappend cellcoords [getCellCoord box $x]

      set dx [list $r [expr -$r] $r]
      set x [vecsub $o $dx]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $o $dx]
      lappend cellcoords [getCellCoord box $x]

      set dx [list $r $r [expr -$r]]
      set x [vecsub $o $dx]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $o $dx]
      lappend cellcoords [getCellCoord box $x]

      set ret [findMinMaxCoords $cellcoords $xmax $ymax $zmax]
    }
    "th" {
      foreach {a b c o tmat } $params {}
      set cellcoords {}
      lappend cellcoords [getCellCoord box $o]
      set x [vecadd $o $a]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $o $b]
      lappend cellcoords [getCellCoord box $x]
      set x [vecadd $o $c]
      lappend cellcoords [getCellCoord box $x]

      set ret [findMinMaxCoords $cellcoords $xmax $ymax $zmax]
#      puts "InorganicBuilder)ret is $ret xmax=$xmax,$ymax,$zmax"
    }
    default {
      set ret [ list [list 0 0 0] [list $xmax $ymax $zmax] ]
    }
  }  

  return $ret
}

proc ::inorganicBuilder::findMinMaxCoords { cellcoords xmax ymax zmax } {
  set x0 $xmax
  set y0 $ymax
  set z0 $zmax
  set x1 0
  set y1 0
  set z1 0
     
  foreach xx $cellcoords {
    foreach { x y z } $xx {}
    if {$x < $x0} {set x0 $x}
    if {$x > $x1} {set x1 $x}
    if {$y < $y0} {set y0 $y}
    if {$y > $y1} {set y1 $y}
    if {$z < $z0} {set z0 $z}
    if {$z > $z1} {set z1 $z}
  }
     
  set x0 [expr int(floor($x0))]
  set x1 [expr int(ceil($x1))]
  set y0 [expr int(floor($y0))]
  set y1 [expr int(ceil($y1))]
  set z0 [expr int(floor($z0))]
  set z1 [expr int(ceil($z1))]

  if {$x0 < 0} {set x0 0}
  if {$x1 > $xmax} {set x1 $xmax}

  if {$y0 < 0} {set y0 0}
  if {$y1 > $ymax} {set y1 $ymax}

  if {$z0 < 0} {set z0 0}
  if {$z1 > $zmax} {set z1 $zmax}

  return [list [list $x0 $y0 $z0] [list $x1 $y1 $z1]]
}

proc ::inorganicBuilder::getCellCoord { boxname realcoord } {
  upvar $boxname box
  
  return [ transformCoords $box(origin) $box(transform_mat) $realcoord]
}

proc ::inorganicBuilder::transformCoords { origin tmat realcoord } {
  set d [ vecsub $realcoord $origin ]
  set a [ vecdot $d [lindex $tmat 0] ]
  set b [ vecdot $d [lindex $tmat 1] ]
  set c [ vecdot $d [lindex $tmat 2] ]
  
  return [ list $a $b $c ]
}

proc ::inorganicBuilder::getRealCoord { boxname cellcoord } {
  upvar $boxname box

  foreach {ci cj ck} $cellcoord {}
#  puts "InorganicBuilder)getRealCoord $ci/$cj/$ck $box(basisa) $box(basisb) $box(basisc)"
  set loc [ vecadd [ vecscale $ci $box(basisa) ] \
    [ vecscale $cj $box(basisb) ] [ vecscale $ck $box(basisc) ] \
    $box(origin) ]
#  puts "InorganicBuilder)Returning $loc"
  return $loc
}

proc ::inorganicBuilder::Inverse3 {matrix} {
    if {[llength $matrix] != 3 ||
        [llength [lindex $matrix 0]] != 3 ||
        [llength [lindex $matrix 1]] != 3 ||
        [llength [lindex $matrix 2]] != 3} {
        error "wrong sized matrix"
    }
    set inv {{? ? ?} {? ? ?} {? ? ?}}

    # Get adjoint matrix : transpose of cofactor matrix
    for {set i 0} {$i < 3} {incr i} {
        for {set j 0} {$j < 3} {incr j} {
            lset inv $i $j [_Cofactor3 $matrix $i $j]
        }
    }
    # Now divide by the determinant
    set det [expr {double([lindex $matrix 0 0]   * [lindex $inv 0 0]
                   + [lindex $matrix 0 1] * [lindex $inv 1 0]
                   + [lindex $matrix 0 2] * [lindex $inv 2 0])}]
    if {$det == 0} {
        error "non-invertable matrix"
    }

    for {set i 0} {$i < 3} {incr i} {
        for {set j 0} {$j < 3} {incr j} {
            lset inv $i $j [expr {[lindex $inv $i $j] / $det}]
        }
    }
    return $inv
}
 
proc ::inorganicBuilder::_Cofactor3 {matrix i j} {
    array set COLS {0 {1 2} 1 {0 2} 2 {0 1}}
    foreach {row1 row2} $COLS($j) break
    foreach {col1 col2} $COLS($i) break

    set a [lindex $matrix $row1 $col1]
    set b [lindex $matrix $row1 $col2]
    set c [lindex $matrix $row2 $col1]
    set d [lindex $matrix $row2 $col2]

    set det [expr {$a*$d - $b*$c}]
    if {($i+$j) & 1} { set det [expr {-$det}]}
    return $det
}

proc ::inorganicBuilder::transformRealToHex { boxname realcoord } {
  upvar $boxname box
  
  set coord [concat $realcoord 1]
  set result $realcoord
  for { set i 0 } { $i < 6 } { incr i } {
    set nxt [ expr ($i + 1) % 6 ]
    
    if { [vecdot [lindex $box(hexradial) $i] $coord] >= 0 \
         && [vecdot [lindex $box(hexradial) $nxt] $coord] < 0 \
         && [vecdot [lindex $box(hexfaces) $i] $coord ] < 0 } {
       set result [ vecadd $realcoord [lindex $box(hextranslate) $i]]
       break
    }
  }
  return $result

  set coord [vecsub $realcoord $box(hexcenter)]
  set imax 0
  set dotmax [vecdot $coord [lindex $box(hexverts) 0]]
  for {set i 1} { $i < 6 } { incr i } {
    set dot [vecdot $coord [lindex $box(hexverts) $i]]
    if { $dot > $dotmax } {
      set imax $i
      set dotmax $dot
    }
  }
#  puts "InorganicBuilder)hexfaces($imax)=$box(hexfaces)"
  set faceplane [lindex $box(hexfaces) $imax]
#  puts "InorganicBuilder)faceplane $faceplane -- [lrange $faceplane 0 2] -- $coord"
  set facedist [vecdot [lrange $faceplane 0 2] $coord]
  set facedist [expr $facedist + [lindex $faceplane 3]]
  if { $facedist < 0 } {
    set newcoord [vecsub $realcoord [lindex $box(hexneighbors) $imax]]
  } else {
    set newcoord $realcoord
  }
  return $newcoord
}

proc ::inorganicBuilder::checkPointInside { boxname exclusion pos } {
  upvar $boxname box
  if { [string equal $box(type) "hex"] } {
    set oldpos $pos
    set pos [transformRealToHex $boxname $pos]
#    puts "InorganicBuilder)Testing $pos [vecsub $oldpos $pos]"
  }
  foreach {type bb params name} $exclusion {}
  switch $type {
    "pp" {
      foreach {a b c o tmat} $params {}
      set tpos [transformCoords $o $tmat $pos]
      foreach { x y z } $tpos {}
      if {$x>=0 && $x<=1 && $y>=0 && $y<=1 && $z>=0 && $z<=1} {
        return 1
      } else {
        return 0
      }
    }
    "th" {
      foreach {a b c o tmat} $params {}
      set tpos [transformCoords $o $tmat $pos]
      foreach { x y z } $tpos {}
      if { $x>=0 && $y>=0 && $z>=0 && [expr $x+$y+$z] <= 1 } {
        return 1
      } else {
        return 0
      }
    }
    "sphere" {
       foreach {o r rsq} $params {}
       if { [veclength2 [vecsub $pos $o]] <= $rsq } {
         return 1
       } else {
         return 0
       }
    }
    "cylinder" {
      foreach {o a r rsq l u} $params {}
      set x [vecsub $pos $o]
      set h [vecdot $x $u]
      if { $h > $l || $h < 0} {
        return 0
      }
      set rx [ vecsub $x [vecscale $h $u]]
      if { [veclength2 $rx] <= $rsq } {
        return 1
      } else {
        return 0
      }
    }
    "cone" {
      foreach {o a r rsq l u} $params {}
      set x [vecsub $pos $o]
      set h [vecdot  $x $u]
      if { $h > $l || $h < 0} {
        return 0
      }
      set rx [ vecsub $x [vecscale $h $u]]
      set rmax [expr $r * (1.0 - $h/$l)]
      if { [veclength $rx] <= $rmax } {
        return 1
      } else {
        return 0
      }
    }
    "selection" { 
      return 0
    }
    "dxfile" { 
      return 0
    }
    "default" {
      puts "InorganicBuilder)Unknown type:$type params:$params"
      return -1
    }
  }
  return -1
}

# *** MODIFIED, THEREFORE ***
# *** ADDED ***
proc ::inorganicBuilder::buildBox { boxlist outfile } {
  variable guiState
  
  array set box $boxlist
  
  set unitcellfile $box(pdb)
  set unitcelltopfile $box(top)
  set cutoff $box(cutoff)
  
  set xmin $box(ox)
  set ymin $box(oy)
  set zmin $box(oz)
  
  set nx $box(na)
  set ny $box(nb)
  set nz $box(nc)
  
  mol new [file normalize $unitcellfile] type pdb autobonds off filebonds off waitfor all
  set molid [molinfo top]
  mol off $molid
  set uc [atomselect top all]
  set ucnames [$uc get {index name resname resid }]
#  puts "InorganicBuilder)Unit Cell names: $ucnames"
  # Store data indexed by resname
  foreach element $ucnames {
    foreach {index name resname resid } $element {
#      puts "InorganicBuilder)index=$index name=$name resname=$resname"
      lappend atomsbyresid($resid) [list $index $name $resname]
    }
  }
  set ucresids [array names atomsbyresid]
#  puts "InorganicBuilder)resids are $ucresids"
  
  set psfcon [psfcontext create]
  psfcontext eval $psfcon {
    topology $unitcelltopfile
    set seglist {}
    # Pre-calculate the segment list and coordinate lists, so we can
    # just add the ones we need
    set n 0
    set prefix "U"
    set curresid 0
    # Create new replica
    set seg_coords {}
    if { [string equal $box(type) "hex"] } {
      set isHex 1
    } else {
      set isHex 0
    }
    for { set i 0 } { $i < $nx } { incr i } {
      for { set j 0 } { $j < $ny } { incr j } {
        set movex [expr $xmin + $i * [lindex $box(basisa) 0] \
          + $j * [lindex $box(basisb) 0] ]
        set movey [expr $ymin + $i * [lindex $box(basisa) 1] \
          + $j * [lindex $box(basisb) 1] ]
        set movez [expr $zmin + $i * [lindex $box(basisa) 2] \
          + $j * [lindex $box(basisb) 2] ]
        for { set k 0 } { $k < $nz } { incr k } {
          set vec [list $movex $movey $movez]
          $uc moveby $vec
          set allpos [$uc get {index x y z}]
          foreach atom $allpos {
            foreach {index x y z} $atom {
              set pos($index) [list $x $y $z]
            }
          }
          foreach resid $ucresids {
            set res_coords {}
            set res_delete {}
            array unset track_resd
            array set track_resd {}
            set track_count 0
            
            foreach atom $atomsbyresid($resid) {
              foreach { id name resname} $atom {}
              set addme 1
              if {$guiState(addGenericInclude) == 1} {
				  set addme 0
			  }
              foreach exclusion $box(excludelist) {
                if { [string equal [getBlockType $exclusion] "selection"] } {
				  set addme 1
                  continue
                }
                if { [string equal [getBlockType $exclusion] "dxfile"] } {
				  set addme 1
                  continue
                }
                if { $isHex } {
                  if { $guiState(addGenericInclude) == 0 } {
                    if { [ checkPointInside box $exclusion $pos($id) ] != 0 } {
                      set addme 0
                      break
                    }
                  } elseif { $guiState(addGenericInclude) == 1 } {
                    if { [ checkPointInside box $exclusion $pos($id) ] != 0 } {
                      set addme 1
                      break
                    }
                  }
                } else {
                  set bb [getBlockBoundingBox $exclusion]
                  foreach { min max } $bb {}
                  foreach { imin jmin kmin } $min {}
                  foreach { imax jmax kmax } $max {}
                  if { $i >= $imin && $i < $imax
                      && $j >= $jmin && $j < $jmax
                      && $k >= $kmin && $k < $kmax } {

                    if { $guiState(addGenericInclude) == 0 } {
                      if { [ checkPointInside box $exclusion $pos($id) ] != 0 } {
                        set addme 0
                        break
                      }
                    } elseif { $guiState(addGenericInclude) == 1 } {
                      if { [ checkPointInside box $exclusion $pos($id) ] != 0 } {
                        set addme 1
                        break
                      }					
                    }
                  }
                }
              }
              if { $addme } {
                lappend res_coords [list $name $pos($id) $resname ]
                if { [info exists track_resd($name)] } {
                  set includeIndex $track_resd($name)                  					
                  set res_delete [lreplace $res_delete $includeIndex $includeIndex {}]
                  unset track_resd($name)
                }
              } else {
				set track_resd($name) $track_count
                incr track_count
                lappend res_delete $name

              }
            }
            concat {*}$res_delete
            puts "InorganicBuilder)Storing res CUR:$curresid NAME:$resname COOR:[llength $res_coords] DEL:[llength $res_delete]"
            if { [ llength $res_coords ] > 0 } {
              lappend seg_coords [list $curresid $resname $res_coords \
                $res_delete] 
              incr curresid
              # If the number of residues to be added would roll over the PDB
              # residue id counter, increment the segment counter and reset
              # the res id to zero
              if { $curresid > 9999 } {
                set nstr [string toupper [format "%x" $n]]
                set segid ${prefix}$nstr
                buildSegment $segid $seg_coords
                incr n
                set curresid 0
                set seg_coords {}
              }
            }
          }
          $uc moveby [vecinvert $vec]
          set movex [expr $movex + [lindex $box(basisc) 0]]
          set movey [expr $movey + [lindex $box(basisc) 1]]
          set movez [expr $movez + [lindex $box(basisc) 2]]
        }
      }
    }
    # if there are molecules in the last segment, build it
    if { [ llength $seg_coords ] != 0 } {
      set nstr [string toupper [format "%x" $n]]
      set segid ${prefix}$nstr
      buildSegment $segid $seg_coords
    }

    # write out oversized box
    writepdb $outfile.pdb
    writepsf $outfile.psf
  }
  psfcontext delete $psfcon
  # Delete unit cell
  mol delete top
  
  # Read in the generated box to transform to hex and apply selections
  set molid [mol new [file normalize $outfile.psf] \
    type psf autobonds off filebonds off waitfor all]
  mol addfile [file normalize $outfile.pdb] type pdb autobonds off filebonds off waitfor all
 
  if { $isHex } {
    transformCoordsToHex $boxlist $molid
  }

  # Update periodic box, so it gets stored in the PDB file
  ::inorganicBuilder::setVMDPeriodicBox $boxlist $molid
  
  # Apply DXFile exclusions
  set dxstring ""
  set countdx 0
  foreach exclusion $box(excludelist) {
    if { [getBlockType $exclusion] != "dxfile" } {
      continue
    }
    set params [getBlockParams $exclusion]
    foreach { DX incDX } $params {}
    if { $dxstring != "" } {
      set dxstring "$dxstring and "
    }
    mol addfile [lindex $guiState(addDXFile) $countdx]
    set volDX "vol$countdx > 0"
    set countdx [expr $countdx+1]
    if { $incDX } {
      set dxstring "$dxstring ($volDX)"
    } else {
      set dxstring "$dxstring not($volDX)"
    }
  }
  
  # Apply selection and output
  if { [string equal $dxstring ""] } {
    set dxstring "all"
  }

  
  # Apply selection exclusions
  if { [string equal $dxstring "all"] } {
    set selstring ""
  } else {
    set selstring $dxstring
  }
  
  foreach exclusion $box(excludelist) {
    if { [getBlockType $exclusion] != "selection" } {
      continue
    }
    set params [getBlockParams $exclusion]
    foreach { sel include } $params {}
    if { $selstring != "" } {
      set selstring "$selstring and "
    }
    if { $include } {
      set selstring "$selstring ($sel)"
    } else {
      set selstring "$selstring not($sel)"
    }
  }
  # Apply selection and output
  if { [string equal $selstring ""] } {
    set selstring "all"
  }

# if Hollow build is requested, reselect using the hollow shell of the final shape. 2 atoms thick!
# in order to place structures on the inside, use rsH2 only
  if { $guiState(buildHollow) == 1 } {
    set HollowSel [atomselect $molid all] 
    set rsH [measure surface $HollowSel 1.5 2.88 1.44 ] 
    $HollowSel delete
    set secondLayer [atomselect $molid "all and not index $rsH"]
    if { [$secondLayer get index] != "" } {
      set rsH2 [measure surface $secondLayer 1.5 2.88 1.44 ] 
      set selstring [concat $selstring " and index $rsH $rsH2"]
      $secondLayer delete
    }
    
  }

  
#  puts "InorganicBuilder)Selection is $selstring"
  set select [atomselect $molid $selstring]

  # Scale charges to the nearest integer
  if { $box(adjcharges) } {
    set numsel [$select num]
    if {$numsel != 0} {
      set totq [measure sumweights $select weight charge]
      set chargeadj [expr (round($totq)-$totq)/(1.0 * $numsel)]
      if {$chargeadj != 1} {
        set charges [$select get charge]
        set imax [llength $charges]
        for {set i 0} { $i < $imax } {incr i} {
          lset charges $i [expr [lindex $charges $i] + $chargeadj]
        }
        $select set charge $charges
      }
    }
    # Write out files, then read them back in again to apply an exact 
    # correction to a single atom
    $select writepsf $outfile.1.psf
    $select writepdb $outfile.1.pdb
    $select delete
    mol delete $molid
    set molid [mol new $outfile.1.psf type psf autobonds off waitfor all]
    mol addfile $outfile.1.pdb type pdb autobonds off waitfor all
    file delete $outfile.1.psf
    file delete $outfile.1.pdb
    set select [atomselect $molid all]
    set numsel [$select num]
    if {$numsel != 0} {
      set totq [measure sumweights $select weight charge]
      set chargeadj [expr round($totq)-$totq ]
      set firstatom [atomselect $molid "index 0"]
      set oldcharge [lindex [$firstatom get charge] 0]
      set charge [expr $oldcharge + $chargeadj]
      puts "Oldcharge $oldcharge $charge"
      $firstatom set charge $charge
      $firstatom delete
    }
  }
#  set totq [measure sumweights $select weight charge]
#  puts "New Charge is $totq"
  
  $select writepsf $outfile.psf
  $select writepdb $outfile.pdb
  $select delete     
  mol delete $molid
  mol new [file normalize $outfile.psf] type psf autobonds off waitfor all
  mol addfile [file normalize $outfile.pdb] \
    type pdb autobonds off filebonds off waitfor all
}

proc inorganicBuilder::buildSegment { segid seg_coords } {
  # Build the segment previously computed
  segment $segid {
    auto none
    first NONE
    last NONE
#    puts "InorganicBuilder)seg_count [llength $seg_coords]"
    foreach seg_coord  $seg_coords {
      set curresid [lindex $seg_coord 0]
      set resname [lindex $seg_coord 1]
      #puts "InorganicBuilder)segid $segid curresid $curresid resname $resname"
      residue $curresid $resname
    }
  }
  foreach seg_coord  $seg_coords {
    foreach { curresid resname coord_list delete_list } $seg_coord {} 
#    puts "InorganicBuilder)seg $segid coords=[llength $coord_list] delete=[llength $delete_list]"
#    puts "InorganicBuilder)Residues in $segid:$curresid [ llength $coord_list ]"
    foreach coor $coord_list {
#      puts "InorganicBuilder)Writing coord $segid $curresid $coor"
      coord $segid $curresid [lindex $coor 0] [lindex $coor 1]
    }
#    puts "InorganicBuilder)Deleting $segid:curresid [ llength $delete_list ]"
    foreach atom_to_del $delete_list {
      delatom $segid $curresid $atom_to_del
    }
  }
}
  
proc ::inorganicBuilder::buildBonds { boxlist setTypes periodicIn { molid top }} {
  if { [string equal $molid "top"] } {
    set molid [molinfo top]
  }
  # puts "InorganicBuilder)molid is $molid"
  mol off $molid
  
  # Make sure everything is in the unit cell
  transformCoordsToBox $boxlist $molid
  
  array set box $boxlist
  # Tell VMD to calculate internal bonds
  #
  #mol bondsrecalc $molid
  
  # Add edge bonds
  # puts "InorganicBuilder)Adding periodic bonds cutoff $box(cutoff)"
  buildPeriodicBonds box $periodicIn $molid

  # Rename atom types
  if { $setTypes } {
    setAtomTypes $molid
  }
  
  # If this is a hex box, transform to hex
  if { [string equal $box(type) "hex"] } {
    transformCoordsToHex $boxlist $molid
  }
 
  mol on $molid
}

proc ::inorganicBuilder::buildAnglesDihedrals { ifprefix ofprefix \
                                                dihedrals } {
  # Start psfgen again using the new PSF file, to generate
  # the angles and bonds
  
  set psfcon [psfcontext create]
  psfcontext eval $psfcon {
    readpsf $ifprefix.psf
    coordpdb $ifprefix.pdb
    if { $dihedrals } {
      regenerate angles dihedrals
    } else {
      regenerate angles
    }
    writepdb $ofprefix.pdb
    writepsf $ofprefix.psf
  }
  psfcontext delete $psfcon
}

proc ::inorganicBuilder::buildPeriodicBonds { boxname periodicIn molid } {
  upvar $boxname box
  
  foreach { periodicX periodicY periodicZ } $periodicIn {}
  if { !$periodicX && !$periodicY & !$periodicZ } {
    puts "InorganicBuilder) No periodic boundaries specified"
    return
  }
  # Make sure everything is properly wrapped into the unit cell
  
  # Find the cutoff table to emulate VMDs heuristic: 0.6*R1*R2
  set allatoms [atomselect $molid all]
  set types [$allatoms get {type radius}]
  set types [lsort -unique $types]
  set cutoff 0
  foreach type1 $types {
    foreach { t1 r1 } $type1 {}
    foreach type2 $types {
      foreach { t2 r2 } $type2 {}
      set r2 [lindex $type2 1]
      set cval [expr 0.6 * ($r1 + $r2)]
      if { $cval > $cutoff } {
        set cutoff $cval
      }
      set typecutoffsq($t1,$t2) [expr $cval * $cval]
    }
  }
  $allatoms delete
  
  # Need to find the slices of the box that are the cutoff distance
  # away from the AB face, the AC face, and the BC face.
  set a $box(basisa)
  set b $box(basisb)
  set c $box(basisc)
  set o $box(origin)
  
  set cross_ab $box(cross_ab)
  set cross_ac $box(cross_ac)
  set cross_bc $box(cross_bc)
  
  # Normalize cross products so they have length=cutoff
  set cross_ab [vecscale $cutoff [vecnorm $cross_ab]]
  set cross_ac [vecscale $cutoff [vecnorm $cross_ac]]
  set cross_bc [vecscale $cutoff [vecnorm $cross_bc]]
  
  # Find 6 slice planes
  set p1 [vecadd $o $cross_bc]
  set p2 [vecadd $p1 $b]
  set p3 [vecadd $p1 $c]
  set imin_plane [ find_plane $p1 $p2 $p3 $o]
  
  set corner [vecadd $o [vecscale $box(na) $a]]
  set p1 [vecsub  $corner $cross_bc]
  set p2 [vecadd $p1 $b]
  set p3 [vecadd $p1 $c]
  set imax_plane [ find_plane $p1 $p2 $p3 $corner]

  set p1 [vecadd $o $cross_ac]
  set p2 [vecadd $p1 $a]
  set p3 [vecadd $p1 $c]
  set jmin_plane [ find_plane $p1 $p2 $p3 $o]

  set corner [vecadd $o [vecscale $box(nb) $b]]
  set p1 [vecsub $corner $cross_ac]
  set p2 [vecadd $p1 $a]
  set p3 [vecadd $p1 $c]
  set jmax_plane [ find_plane $p1 $p2 $p3 $corner]
  
  set p1 [vecadd $o $cross_ab]
  set p2 [vecadd $p1 $a]
  set p3 [vecadd $p1 $b]
  set kmin_plane [ find_plane $p1 $p2 $p3 $o]

  set corner [vecadd $o [vecscale $box(nc) $c]]
  set p1 [vecsub $corner $cross_ab]
  set p2 [vecadd $p1 $a]
  set p3 [vecadd $p1 $b]
  set kmax_plane [ find_plane $p1 $p2 $p3 $corner]
  
  # Determine the cutoff cell by finding the intersections of the three
  # planes
  set ca_mat [list [lrange $imin_plane 0 2 ] \
                   [lrange $jmin_plane 0 2 ] \
                   [lrange $kmin_plane 0 2 ] ]

  set ca_inv [Inverse3 $ca_mat]
  set ca_d [list [ lindex $imin_plane 3] \
                 [ lindex $jmin_plane 3] \
                 [ lindex $kmin_plane 3] ]
  set cutoff_coord [vecinvert [list [vecdot [lindex $ca_inv 0] $ca_d] \
                                    [vecdot [lindex $ca_inv 1] $ca_d] \
                                    [vecdot [lindex $ca_inv 2] $ca_d] ]]
  # Now convert to "cell coordinates" to find the size of the box in basis
  # vec units
  set cutoff_cell [ getCellCoord box $cutoff_coord ]
  # Round cutoff cell components up to integer multiples of box size
  foreach { ci cj ck } $cutoff_cell {}
  set ni [expr int($box(na)/$ci)]
  set nj [expr int($box(nb)/$cj)]
  set nk [expr int($box(nc)/$ck)]
  set cutoff_cell [list [expr double($box(na))/$ni] \
                        [expr double($box(nb))/$nj] \
                        [expr double($box(nc))/$nk] ]
                        
  # Select each face of the block and put into cells
  processSelection box cell $cutoff_cell $imin_plane $molid
  processSelection box cell $cutoff_cell $imax_plane $molid
  processSelection box cell $cutoff_cell $jmin_plane $molid
  processSelection box cell $cutoff_cell $jmax_plane $molid
  processSelection box cell $cutoff_cell $kmin_plane $molid
  processSelection box cell $cutoff_cell $kmax_plane $molid
  
  # filter out duplicates in the neighbor lists
  set celllist [array names cell]
  foreach cellidx $celllist {
    set cell($cellidx) [lsort -integer -unique -index 0 $cell($cellidx)]
  }
  
  #puts [array get cell]
  # Scan cells on the zero edges
  # Need to determine whether its more efficient to use this lookup
  # table or to loop through the inidicies. Initially only some pairs
  # were used, but not the algorithm uses all neighbors, so a loop may
  # well be cheaper
  set neighborlist { {-1 -1 -1} {-1 -1  0} {-1 -1  1} \
                     {-1  0 -1} {-1  0  0} {-1  0  1} \
                     {-1  1 -1} {-1  1  0} {-1  1  1} \
                     { 0 -1 -1} { 0 -1  0} { 0 -1  1} \
                     { 0  0 -1} { 0  0  1} \
                     { 0  1 -1} { 0  1  0} { 0  1  1} \
                     { 1 -1 -1} { 1 -1  0} { 1 -1  1} \
                     { 1  0 -1} { 1  0  0} { 1  0  1} \
                     { 1  1 -1} { 1  1  0} { 1  1  1} }
  set rsq [ expr $cutoff * $cutoff ]
  if { $periodicX } {
#    puts "InorganicBuilder)Checking ix $ni $nj $nk"
    set ix 0
    for { set iy 0 } { $iy < $nj } { incr iy } {
      for { set iz 0 } { $iz < $nk } { incr iz } {
        if { ![info exists cell($ix,$iy,$iz)] } {
          continue
        }
        foreach neighbor $neighborlist {
          foreach { xinc yinc zinc } $neighbor {}
          set nix [expr $ix + $xinc]
          set niy [expr $iy + $yinc]
          set niz [expr $iz + $zinc]
          if { $nix >= 0 && $niy >= 0 && $niz >= 0 } {
            continue
          }
          if { $nix < 0 } {
            incr nix $ni 
            set wrap [ vecscale $box(na) $a ]
          } else {
            set wrap { 0 0 0 }
          }
  
          if { $niy < 0 } {
            if { $periodicY } {
              incr niy $nj 
              set wrap [ vecadd $wrap [vecscale $box(nb) $b ]]
            } else {
              continue
            }
          }
          if { $niz < 0 } { 
            if { $periodicZ } {
              incr niz $nk 
              set wrap [ vecadd $wrap [vecscale $box(nc) $c ]]
            } else {
              continue
            }
          }
          if { ![ info exists cell($nix,$niy,$niz) ] } {
            continue
          }
          foreach {xwrap ywrap zwrap} $wrap {}
          foreach atom $cell($ix,$iy,$iz) {
            foreach { index coord type } $atom {}
            foreach { xc yc zc } $coord {}
            set newbondlist {}
            foreach neighbor_atom $cell($nix,$niy,$niz) {
              foreach { nindex ncoord ntype } $neighbor_atom {}
              foreach { nxc nyc nzc } $ncoord {}
              set delx [ expr $xc - $nxc + $xwrap]
              set dely [ expr $yc - $nyc + $ywrap]
              set delz [ expr $zc - $nzc + $zwrap]
              set currsq [ expr $delx*$delx + $dely*$dely + $delz*$delz ]
              if { $currsq < $rsq } {
                if { $currsq < $typecutoffsq($type,$ntype) } {
                  lappend newbondlist $nindex
                }
              }
            }
            if { [llength $newbondlist] > 0 } {
              lappend bondlist($index) $newbondlist
              # Also store the reciprocal bond
              foreach bond $newbondlist {
                lappend bondlist($bond) $index
              }
            }
          }
        }
      }
    }
  }
  if { $periodicY } {
#    puts "InorganicBuilder)Checking iy"
    set iy 0
    for { set ix 1 } { $ix < $ni } { incr ix } {
      for { set iz 0 } { $iz < $nk } { incr iz } {
        if { ![info exists cell($ix,$iy,$iz)] } {
          continue
        }
        foreach neighbor $neighborlist {
          foreach { xinc yinc zinc } $neighbor {}
          set nix [expr $ix + $xinc]
          set niy [expr $iy + $yinc]
          set niz [expr $iz + $zinc]
          if { $nix >= 0 && $niy >= 0 && $niz >= 0 } {
            continue
          }
          if { $niy < 0 } { 
            incr niy $nj 
            set wrap [ vecscale $box(nb) $b ]
          } else {
            set wrap { 0 0 0 }
          }
          if { $nix < 0 } {
            if { $periodicX } {
              incr nix $ni 
              set wrap [vecadd $wrap [ vecscale $box(na) $a ]]
            } else {
              continue
            }
          }
          if { $niz < 0 } { 
            if { $periodicZ } {
              incr niz $nk 
              set wrap [ vecadd $wrap [vecscale $box(nc) $c ]]
            } else {
              continue
            }
          }
          if { ![ info exists cell($nix,$niy,$niz) ] } {
            continue
          }
          foreach {xwrap ywrap zwrap} $wrap {}
          foreach atom $cell($ix,$iy,$iz) {
            foreach { index coord type } $atom {}
            foreach { xc yc zc } $coord {}
            if { ![info exists xc] } {
              puts "atom is -$atom-"
            }
            set newbondlist {}
            foreach neighbor_atom $cell($nix,$niy,$niz) {
              foreach { nindex ncoord ntype } $neighbor_atom {}
              foreach { nxc nyc nzc } $ncoord {}
              set delx [ expr $xc - $nxc + $xwrap]
              set dely [ expr $yc - $nyc + $ywrap]
              set delz [ expr $zc - $nzc + $zwrap]
              set currsq [ expr $delx*$delx + $dely*$dely + $delz*$delz ]
              if { $currsq < $rsq } {
                if { $currsq < $typecutoffsq($type,$ntype) } {
                  lappend newbondlist $nindex
                }
              }
            }
            if { [ llength $newbondlist ] > 0 } {
              lappend bondlist($index) $newbondlist
              # Also store the reciprocal bond
              foreach bond $newbondlist {
                lappend bondlist($bond) $index
              }
            }
          }
        }
      }
    }
  }
  if { $periodicZ } {
#    puts "InorganicBuilder)Checking iz"
    set iz 0
    for { set ix 1 } { $ix < $ni } { incr ix } {
      for { set iy 1 } { $iy < $nj } { incr iy } {
        if { ![info exists cell($ix,$iy,$iz)] } {
          continue
        }
        foreach neighbor $neighborlist {
          foreach { xinc yinc zinc } $neighbor {}
          set nix [expr $ix + $xinc]
          set niy [expr $iy + $yinc]
          set niz [expr $iz + $zinc]
          if { $nix >= 0 && $niy >= 0 && $niz >= 0 } {
            continue
          }
          if { $niz < 0 } { 
            incr niz $nk 
            set wrap [ vecscale $box(nc) $c ]
          } else {
            set wrap { 0 0 0 }
          }
          if { $nix < 0 } { 
            if { $periodicX } {
              incr nix $ni 
              set wrap [ vecadd $wrap [vecscale $box(na) $a ]]
            } else {
              continue
            }
          }
          if { $niy < 0 } { 
            if { $periodicY } {
              incr niy $nj 
              set wrap [ vecadd $wrap [vecscale $box(nb) $b ]]
            } else {
              continue
            }
          }
          if { ![ info exists cell($nix,$niy,$niz) ] } {
            continue
          }
          foreach {xwrap ywrap zwrap} $wrap {}
          foreach atom $cell($ix,$iy,$iz) {
            foreach { index coord type } $atom {}
            foreach { xc yc zc } $coord {}
            set newbondlist {}
            foreach neighbor_atom $cell($nix,$niy,$niz) {
              foreach { nindex ncoord ntype } $neighbor_atom {}
              foreach { nxc nyc nzc } $ncoord {}
              set delx [ expr $xc - $nxc + $xwrap]
              set dely [ expr $yc - $nyc + $ywrap]
              set delz [ expr $zc - $nzc + $zwrap]
              set currsq [ expr $delx*$delx + $dely*$dely + $delz*$delz ]
              if { $currsq < $rsq } {
                if { $currsq < $typecutoffsq($type,$ntype) } {
                  lappend newbondlist $nindex
                }
              }
            }
            if { [ llength $newbondlist ] > 0 } {
              lappend bondlist($index) $newbondlist
              # Also store the reciprocal bond
              foreach bond $newbondlist {
                lappend bondlist($bond) $index
              }
            }
          }
        }
      }
    }
  }
  
#  puts "InorganicBuilder)Resetting bonds"
  set indexlist [array names bondlist]
  set imax [llength $indexlist]
#  puts "InorganicBuilder)Getting $imax atoms"
  if { [llength $indexlist] > 0 } {
    set allatoms [ atomselect $molid "index $indexlist" ]
#    puts "InorganicBuilder)Selected all atoms"
    set oldbonds [ $allatoms getbonds ]
    set indices [ $allatoms get index]
#    puts "InorganicBuilder)Got bonds"
    for {set i 0} { $i < $imax } { incr i } {
      set index [lindex $indices $i]
      set oldbondlist [lindex $oldbonds $i]
      #puts "InorganicBuilder)I=$i index=$index oldbondlist=$oldbondlist new=$bondlist($index)"
      set fullbondlist [lsort -unique -integer \
                [concat $oldbondlist [join $bondlist($index)] ]]
      set bondlist($index) {}
      lset oldbonds $i $fullbondlist
    }
    $allatoms setbonds $oldbonds
    $allatoms delete
  }
}

proc ::inorganicBuilder::buildSpecificBonds { boxlist bondtypelist \
                                              periodicIn \
                                              {molid top} } {
  foreach { periodicX periodicY periodicZ } $periodicIn {}

  array set box $boxlist
  if { [string equal $molid "top"] } {
    set molid [molinfo top]
  }
    
  # Find out which atom pairs we need to keep, and also the max cutoff
  # for pairlist purposes
#  puts "InorganicBuilder)Finding bond types $bondtypelist"
  set maxcutoff 0
  foreach bondtype $bondtypelist {
    lappend atomtypelist [lindex $bondtype 0]
    lappend atomtypelist [lindex $bondtype 1]
    set cutoff [lindex $bondtype 2]
    if { $maxcutoff < $cutoff } {
      set maxcutoff $cutoff
    }
  }
  set atomtypelist [ lsort -unique $atomtypelist ]
#  puts "InorganicBuilder)Atoms: $atomtypelist"
  # make it a little bigger, to protect against rounding errors
  set maxcutoff [expr 1.01 * $maxcutoff]
  
#  puts "InorganicBuilder)Computing cell size $maxcutoff"
  # Need to find the slices of the box that are the cutoff distance
  # away from the AB face, the AC face, and the BC face.
  set a $box(basisa)
  set b $box(basisb)
  set c $box(basisc)
  set o $box(origin)
  
  set cross_ab $box(cross_ab)
  set cross_ac $box(cross_ac)
  set cross_bc $box(cross_bc)
  
  # Normalize cross products so they have length=cutoff
  set cross_ab [vecscale $maxcutoff [vecnorm $cross_ab]]
  set cross_ac [vecscale $maxcutoff [vecnorm $cross_ac]]
  set cross_bc [vecscale $maxcutoff [vecnorm $cross_bc]]
  
  # Find 6 slice planes
  set p1 [vecadd $o $cross_bc]
  set p2 [vecadd $p1 $b]
  set p3 [vecadd $p1 $c]
#  puts "InorganicBuilder)imin $p1:$p2:$p3"
  set imin_plane [ find_plane $p1 $p2 $p3 $o]
  
  set p1 [vecadd $o $cross_ac]
  set p2 [vecadd $p1 $a]
  set p3 [vecadd $p1 $c]
#  puts "InorganicBuilder)jmin $p1:$p2:$p3"
  set jmin_plane [ find_plane $p1 $p2 $p3 $o]

  set p1 [vecadd $o $cross_ab]
  set p2 [vecadd $p1 $a]
  set p3 [vecadd $p1 $b]
#  puts "InorganicBuilder)kmin $p1:$p2:$p3"
  set kmin_plane [ find_plane $p1 $p2 $p3 $o]

  # Determine the cutoff cell by finding the intersections of the three
  # planes
  set ca_mat [list [lrange $imin_plane 0 2 ] \
                   [lrange $jmin_plane 0 2 ] \
                   [lrange $kmin_plane 0 2 ] ]

  set ca_inv [Inverse3 $ca_mat]
  set ca_d [list [ lindex $imin_plane 3] \
                 [ lindex $jmin_plane 3] \
                 [ lindex $kmin_plane 3] ]
  set cutoff_coord [vecinvert [list [vecdot [lindex $ca_inv 0] $ca_d] \
                                    [vecdot [lindex $ca_inv 1] $ca_d] \
                                    [vecdot [lindex $ca_inv 2] $ca_d] ]]
#  puts "InorganicBuilder)Cutoff_coord is $cutoff_coord --- $o"
  # Now convert to "cell coordinates" to find the size of the box in basis
  # vec units
  set cutoff_cell [ getCellCoord box $cutoff_coord ]
  # Round cutoff cell components up to integer multiples of box size
#  puts "InorganicBuilder)cutoff_cell is $cutoff_cell"
  foreach { ci cj ck } $cutoff_cell {}
  set ni [expr int($box(na)/$ci)]
  set nj [expr int($box(nb)/$cj)]
  set nk [expr int($box(nc)/$ck)]
  set di [expr double($box(na))/$ni]
  set dj [expr double($box(nb))/$nj]
  set dk [expr double($box(nc))/$nk]
#  puts "InorganicBuilder)Box is $ni,$nj,$nk, size $di,$dj,$dk"

  # Init cell array with atom types
  for {set i 0} { $i < [llength $atomtypelist] } { incr i } {
    set atomtype [lindex $atomtypelist $i]
    set atomtypeidx($atomtype) $i
  }
#  puts "InorganicBuilder)atomtypeidx is [array get atomtypeidx]"
  
  # build cell decomposition
  # For periodic, wrap the atoms into the correct box. For non-periodic,
  # it must be rounding error, just shift them back into the closest cell
  for {set typeidx 0} { $typeidx < [llength $atomtypelist] } { incr typeidx } {
    set atomtype [lindex $atomtypelist $typeidx]
#    puts "InorganicBuilder)building cells for $atomtype"
    set atomsel [atomselect $molid "type $atomtype"]
#    puts "InorganicBuilder)Found [$atomsel num]"
    set atoms [$atomsel get { index x y z }]
    foreach atom $atoms {
      foreach { index x y z } $atom {}
      set cell_coord [ getCellCoord box [list $x $y $z]]
      foreach { ci cj ck } $cell_coord {}
      # Wrap coordinates back into the box (only takes care of 1-away
      # images, should be modified for all images
      # SHOULD CHANGE TO USE FMOD?
      if { $ci < 0 } {
        if { $periodicX } {
          set ci [expr $ci + $box(na)]
          set wrapped_a 1 
        } else {
          set ci 0
          set wrapped_a 0
        }
      } elseif { $ci > $box(na) } {
        if { $periodicX } {
          set ci [expr $ci - $box(na)]
          set wrapped_a -1
        } else {
          set ci [expr $box(na) - 0.1]
          set wrapped_a 0
        }
      } else {
        set wrapped_a 0
      }
      if { $cj < 0 } { 
        if { $periodicY } {
          set cj [expr $cj + $box(nb)]
          set wrapped_b 1
        } else {
          set cj 0
          set wrapped_b 0
        }
      } elseif { $cj > $box(nb) } { 
        if { $periodicY } {
          set cj [expr $cj - $box(nb)]
          set wrapped_b -1
        } else {
          set cj [expr $box(nb) - 0.01 ]
          set wrapped_b 0
        }
      } else {
        set wrapped_b 0
      }
      if { $ck < 0 } {
        if { $periodicZ } {
          set ck [expr $ck + $box(nc)]
          set wrapped_c 1
        } else {
          set ck 0
          set wrapped_c 0
        }
      } elseif { $ck > $box(nc) } {
        if { $periodicZ } {
          set ck [expr $ck - $box(nc)]
          set wrapped_c -1
        } else {
          set ck [expr $box(nc) - 0.01]
          set wrapped_c 0
        }
      } else {
        set wrapped_c 0
      }
      
      set new_x [list $x $y $z]
      set move_vec { 0 0 0 }
      if {$wrapped_a} {
        set wrapped_a [expr $wrapped_a * $box(na)]
        set move_vec [vecadd $move_vec [vecscale $wrapped_a $box(basisa)]]
      }
      if {$wrapped_b} {
        set wrapped_b [expr $wrapped_b * $box(nb)]
        set move_vec [vecadd $move_vec [vecscale $wrapped_b $box(basisb)]]
      }
      if {$wrapped_c} {
        set wrapped_c [expr $wrapped_c * $box(nc)]
        set move_vec [vecadd $move_vec [vecscale $wrapped_c $box(basisc)]]
      }
      if {$wrapped_a || $wrapped_b || $wrapped_c} {
        set new_x [vecadd $new_x $move_vec]
#        puts "InorganicBuilder)Wrapping index $index $cell_coord to $ci,$cj,$ck $x,$y,$z"
#        puts "InorganicBuilder)new cell_coord $ci $cj $ck"
#        puts "InorganicBuilder)Re-wrapped to [getCellCoord box $new_x]"
      }
      set i [expr int(floor($ci/$di))]
      set j [expr int(floor($cj/$dj))]
      set k [expr int(floor($ck/$dk))]
      lappend cellfortype($typeidx,$i,$j,$k) [list $index $new_x]
    }
    $atomsel delete
  }
#  puts "InorganicBuilder)Found [llength [array names cellfortype]] cells"
  
  # filter out duplicates in the neighbor lists
  #set celllist [array names cell]
  #foreach cellidx $celllist {
  #  set cell($cellidx) [lsort -integer -unique -index 0 $cell($cellidx)]
  #}
  
  # Scan cells on the zero edges
  # Need to determine whether its more efficient to use this lookup
  # table or to loop through the indicies at eval time. Initially only
  # some pairs were used, but not the algorithm uses all neighbors, 
  # so a loop may well be cheaper
  for { set i -1 } { $i <= 1 } { incr i } {
    for { set j -1 } { $j <= 1 } { incr j } {
      for { set k -1 } { $k <= 1 } { incr k } {
        if { $ni == 1 && $i != 0 || $ni == 2 && $i == -1 \
             || $nj == 1 && $j != 0 || $nj == 2 && $j == -1 \
             || $nk == 1 && $k != 0 || $nk == 2 && $k == -1  } {
          continue
        }
        lappend neighborlist [ list $i $j $k ]
      }
    }
  }

  foreach bondtype $bondtypelist {
    foreach { bondtype1 bondtype2 cutoff } $bondtype {}
#    puts "InorganicBuilder)Scanning bonds of type $bondtype1-$bondtype2 cutoff $cutoff"
    set rsq [ expr $cutoff * $cutoff ]
    set bondidx1 $atomtypeidx($bondtype1)
    set bondidx2 $atomtypeidx($bondtype2)
    if { $bondidx1 == $bondidx2 } {
      set sametype 1
    } else {
      set sametype 0
    }
    for { set ix 0 } {$ix < $ni } { incr ix } {
      for { set iy 0 } { $iy < $nj } { incr iy } {
        for { set iz 0 } { $iz < $nk } { incr iz } {
          if { ![info exists cellfortype($bondidx1,$ix,$iy,$iz)] } {
            continue
          }
          foreach neighbor $neighborlist {
            foreach { xinc yinc zinc } $neighbor {}
            set nix [expr $ix + $xinc]
            set niy [expr $iy + $yinc]
            set niz [expr $iz + $zinc]
            if { $nix < 0 } {
              if { ! $periodicX } {
                continue
              }
              incr nix $ni 
              set wrap [ vecscale $box(na) $a ]
            } elseif { $nix >= $ni } {
              if { ! $periodicX } {
                continue
              }
              incr nix -$ni
              set wrap [ vecscale -$box(na) $a ]
            } else {
              set wrap { 0 0 0 }
            }

            if { $niy < 0 } { 
              if { ! $periodicY } {
                continue
              }
              incr niy $nj 
              set wrap [ vecadd $wrap [vecscale $box(nb) $b ]]
            } elseif { $niy >= $nj } {
              if { ! $periodicY } {
                continue
              }
              incr niy -$nj
              set wrap [ vecsub $wrap [vecscale $box(nb) $b ]]
            }
            if { $niz < 0 } { 
              if { ! $periodicZ } {
                continue
              }
              incr niz $nk 
              set wrap [ vecadd $wrap [vecscale $box(nc) $c ]]
            } elseif { $niz >= $nk } {
              if { ! $periodicZ } {
                continue
              }
              incr niz -$nk
              set wrap [ vecsub $wrap [vecscale $box(nc) $c ]]
            }
            if { ![info exists cellfortype($bondidx2,$nix,$niy,$niz)] } {
              continue
            }
            foreach {xwrap ywrap zwrap} $wrap {}
            foreach atom $cellfortype($bondidx1,$ix,$iy,$iz) {
              foreach { index coord } $atom {}
              foreach { xc yc zc } $coord {}
              set newbondlist {}
              foreach neighbor_atom $cellfortype($bondidx2,$nix,$niy,$niz) {
                foreach { nindex ncoord } $neighbor_atom {}
#               if { $index == 7357 && $nindex == 6774 \
#                  || $index == 6774 && $nindex == 7357 } {
#                    puts "InorganicBuilder)index $index $nindex"
#                   puts "InorganicBuilder)coord $xc $yc $zc $nxc $nyc $nzc $xwrap $ywrap $zwrap"
#                    set printme 1
#                } else {
#                  set printme 0
#                }
                # Don't make a bond with myself, or any atoms with smaller
                # index (since that would make the bond both ways
                if { $sametype && $index >= $nindex } {
                  continue
                }
                #puts "InorganicBuilder)Considering bond $index $nindex"
                foreach { nxc nyc nzc } $ncoord {}
                set delx [ expr $xc - $nxc + $xwrap]
                set dely [ expr $yc - $nyc + $ywrap]
                set delz [ expr $zc - $nzc + $zwrap]
                if { [ expr $delx*$delx + $dely*$dely + $delz*$delz ] < $rsq } {
#                 if {$printme} {
#                    puts "InorganicBuilder)Adding bond $index $nindex"
#                  }
                  lappend newbondlist $nindex
                }
              }
              if { [llength $newbondlist] > 0 } {
                lappend bondlist($index) $newbondlist
                # Also store the reciprocal bond
                foreach bond $newbondlist {
                  lappend bondlist($bond) $index
                }
              }
            }
          }
        }
      }
    }
  }

#  puts "InorganicBuilder)Resetting bonds"
  set indexlist [array names bondlist]
  set imax [llength $indexlist]
#  puts "InorganicBuilder)Getting $imax atoms"
  if { [llength $indexlist] > 0 } {
    set allatoms [ atomselect $molid "index $indexlist" ]
#    puts "InorganicBuilder)Selected all atoms"
    set oldbonds [ $allatoms getbonds ]
    set indices [ $allatoms get index]
#    puts "InorganicBuilder)Got bonds"
    for {set i 0} { $i < $imax } { incr i } {
      set index [lindex $indices $i]
      set oldbondlist [lindex $oldbonds $i]
      #puts "InorganicBuilder)I=$i index=$index oldbondlist=$oldbondlist new=$bondlist($index)"
      set fullbondlist [lsort -unique -integer \
                [concat $oldbondlist [join $bondlist($index)] ]]
      set bondlist($index) {}
      lset oldbonds $i $fullbondlist
    }
    $allatoms setbonds $oldbonds
    $allatoms delete
  }
}

proc ::inorganicBuilder::find_plane { p1 p2 p3 corner } {
  foreach { x1 y1 z1 } $p1 {}
  foreach { x2 y2 z2 } $p2 {}
  foreach { x3 y3 z3 } $p3 {}
  
  set a [expr $y1*($z2-$z3) + $y2*($z3-$z1) + $y3*($z1-$z2)]
  set b [expr $z1*($x2-$x3) + $z2*($x3-$x1) + $z3*($x1-$x2)]
  set c [expr $x1*($y2-$y3) + $x2*($y3-$y1) + $x3*($y1-$y2)]
  set d [expr -$x1*($y2*$z3-$y3*$z2) - $x2*($y3*$z1-$y1*$z3) \
              - $x3*($y1*$z2-$y2*$z1)] 
  
  foreach { x y z } $corner {}
  
  if { [expr $a*$x + $b*$y + $c*$z + $d] < 0 } {
    set plane [list [expr -$a] [expr -$b] [expr -$c] [expr -$d]]
  } else {
    set plane [list $a $b $c $d]
  }
  return $plane
}

proc ::inorganicBuilder::processSelection { box_name cellmap_name \
  cutoff_cell selection_plane molid} {
  
  upvar $box_name box
  upvar $cellmap_name cell
  
  foreach { ap bp cp dp } $selection_plane {}
  foreach { di dj dk } $cutoff_cell {}

  set face [atomselect $molid "$ap*x + $bp*y + $cp*z + $dp > 0"]
  foreach atom [ $face get { index x y z type } ] {
    foreach { index x y z type } $atom {}
    set cell_coord [ getCellCoord box [list $x $y $z]]
    foreach { ci cj ck } $cell_coord {}
    # Take care of rounding errors when atoms are exactly on edges
    if { $ci < 0 } { set ci 0 }
    if { $ci > $box(na) } { set ci [expr $box(na) - 0.01]}
    if { $cj < 0 } { set cj 0 }
    if { $cj > $box(nb) } { set cj [expr $box(nb) - 0.01]}
    if { $ck < 0 } { set ck 0 }
    if { $ck > $box(nc) } { set ck [expr $box(nc) - 0.01]}
    
    set i [expr int(floor($ci/$di))]
    set j [expr int(floor($cj/$dj))]
    set k [expr int(floor($ck/$dk))]
#    puts "InorganicBuilder)Storing [list $index [list $x $y $z]] in $i $j $k"
    lappend cell($i,$j,$k) [list $index [list $x $y $z] $type]
  }
  $face delete
}

proc ::inorganicBuilder::setAtomTypes { molid } {
#  puts "InorganicBuilder)Setting atom types"
  set allatoms [atomselect $molid all]
  set atominfo [$allatoms get { element numbonds }]
  foreach atom $atominfo {
    foreach { element numbonds } $atom {}
    lappend atomtypelist "[string toupper $element]_$numbonds"
  }
  if { [info exists atomtypelist] } {
    $allatoms set type $atomtypelist
  }
  $allatoms delete
  return
}

proc ::inorganicBuilder::findHexVertices { boxname } {  
  upvar $boxname box
  
  # calculate vertices
  set hexcenter $box(hexcenter)
  set b0 [lindex $box(hexverts) 0]
  set b1 [lindex $box(hexverts) 1]
  set b2 [lindex $box(hexverts) 2]
  set height2 [vecscale [expr 0.5 * $box(hexheight)] $box(basisc)]
  set p0 [vecsub [vecadd $hexcenter $b0] $height2]
  set p1 [vecsub [vecadd $hexcenter $b1] $height2]
  set p2 [vecsub [vecadd $hexcenter $b2] $height2]
  set p3 [vecsub [vecsub $hexcenter $b0] $height2]
  set p4 [vecsub [vecsub $hexcenter $b1] $height2]
  set p5 [vecsub [vecsub $hexcenter $b2] $height2]
  
  return [ list $p0 $p1 $p2 $p3 $p4 $p5 ]
}

proc ::inorganicBuilder::transformCoordsToHex { boxlist {molid top} } {
  if { [string equal $molid "top"] } {
    set molid [molinfo top]
  }
  mol off $molid
  
  transformCoordsToBox $boxlist $molid
  array set box $boxlist

  for { set i 0 } { $i < 6 } { incr i } {
    set nxt [ expr ($i + 1) % 6 ]
    transformPiece box [lindex $box(hexradial) $i] \
                   [lindex $box(hexradial) $nxt] \
                   [lindex $box(hexfaces) $i] \
                   [lindex $box(hextranslate) $i]
  }

  mol on $molid
}

proc ::inorganicBuilder::transformCoordsToBox { boxlist {molid top} } {
  array set box $boxlist
  if { [string equal $molid "top"] } {
    set molid [molinfo top]
  }
  mol off $molid
  
  set allatoms [atomselect $molid all]
  
  set coords [$allatoms get { x y z }]
#  puts "InorganicBuilder)Got [llength $coords] coords"
  set newcoords {}
  foreach elem $coords {
    set newelem [ getCellCoord box $elem ]
    set c [ lindex $newelem 0]
    set tc [expr fmod($c,$box(na)) ]
    if { $tc < 0 } {
      set tc [expr $tc + $box(na) ]
    }
    lset newelem 0 $tc
    
    set c [ lindex $newelem 1]
    set tc [expr fmod($c,$box(nb)) ]
    if { $tc < 0 } {
      set tc [expr $tc + $box(nb) ]
    }
    lset newelem 1 $tc
    
    set c [ lindex $newelem 2]
    set tc [expr fmod($c,$box(nc)) ]
    if { $tc < 0 } {
      set tc [expr $tc + $box(nc) ]
    }
    lset newelem 2 $tc
    lappend newcoords [getRealCoord box $newelem]
  }
#  puts "InorganicBuilder)Resetting coords"
  $allatoms set {x y z} $newcoords
  
  mol on $molid
  return
}

proc ::inorganicBuilder::transformPiece { boxname p0 p1 p2 shift } {
  upvar $boxname box
  
  foreach { a0 b0 c0 d0 } $p0 {}
  foreach { a1 b1 c1 d1 } $p1 {}
  foreach { a2 b2 c2 d2 } $p2 {}
  
  # make a selection
  set atoms [atomselect top "$a0*x+$b0*y+$c0*z+$d0 >= 0 \
    and $a1*x+$b1*y+$c1*z+$d1 < 0 and $a2*x+$b2*y+$c2*z+$d2 < 0"  ]
  set atomcount [$atoms num]
  if { $atomcount > 0 } {
    $atoms moveby $shift
  }
  $atoms delete
  return $atomcount
}


proc ::inorganicBuilder::initMaterials {} {
  variable materialList
  variable materialPath
  
#  puts "InorganicBuilder)Building materials lib"
  set materialList [::inorganicBuilder::newMaterialList ]
  
  set a { 4.978 0 0}
  set b { 0 4.978 0}
  set c { 0 0 6.948}
  set basis [list $a $b $c ]
  set cutoff 1.7
  set pdbname [ file join $materialPath sio2.pdb]
  set topname [ file join $materialPath sio2.top]
  set parfilename [ file join $materialPath sio2.inp]

  ::inorganicBuilder::addMaterial materialList "SiO2" "Silicon Dioxide" \
    $basis $pdbname $topname $parfilename $cutoff
    
  set a { 7.595 0.0 0.0}
  set b [vecscale 7.595 [list 0.5 [expr sqrt(3)/2] 0.0 ]]
  set c { 0.0 0.0 2.902 }
  set basis [list $a $b $c]
  set cutoff 1.8
  set pdbname [ file join $materialPath si3n4.pdb]
  set topname [ file join $materialPath si3n4.top]
  set parfilename [ file join $materialPath si3n4.inp]
 
  ::inorganicBuilder::addMaterial materialList "Si3N4" "Silicon Nitride" \
    $basis $pdbname $topname $parfilename $cutoff 1
    
  set a { 4.2522 -2.455 0 }
  set b { 0 4.910 0 }
  set c { 0 0 5.402 }
  set basis [list $a $b $c]
  set cutoff 1.8
  set pdbname [ file join $materialPath quartz_alpha.pdb]
  set topname [ file join $materialPath quartz_alpha.top]
  set parfilename ""

  ::inorganicBuilder::addMaterial materialList "Quartz-alpha" "Quartz-alpha" \
    $basis $pdbname $topname $parfilename $cutoff
    
  set a { 1.228 -2.127 0 }
  set b { 1.228  2.127 0 }
  set c { 0 0 6.696 }
  set basis [list $a $b $c]
  set cutoff 1.5
  set pdbname [ file join $materialPath graphite.pdb]
  set topname [ file join $materialPath graphite.top]
  set parfilename ""

  ::inorganicBuilder::addMaterial materialList "Graphite" "Graphite" \
    $basis $pdbname $topname $parfilename $cutoff 1

  set a { 4.0782 0 0 }
  set b { 0 4.0782 0 }
  set c { 0 0 4.0782 }
  set basis [list $a $b $c]
  set cutoff 2.9
  set pdbname [ file join $materialPath au.pdb]
  set topname [ file join $materialPath au.top]
  set parfilename ""

  ::inorganicBuilder::addMaterial materialList "Au" "Gold" \
    $basis $pdbname $topname $parfilename $cutoff

  set a { 5.4309 0 0 }
  set b { 0 5.4309 0 }
  set c { 0 0 5.4309 }
  set basis [list $a $b $c]
  set cutoff 2.9
  set pdbname [ file join $materialPath si.pdb]
  set topname [ file join $materialPath si.top]
  set parfilename ""

  ::inorganicBuilder::addMaterial materialList "Si" "Silicon" \
    $basis $pdbname $topname $parfilename $cutoff

  set a { 57.30659 -0.09852 -0.000172 }
  set b { 0 57.30659 0.100011 }
  set c { 0 0 58.173357 }
  set basis [list $a $b $c]
  set cutoff 1.8
  set pdbname [ file join $materialPath asio2.pdb]
  set topname [ file join $materialPath asio2.top]
  set parfilename [ file join $materialPath asio2.inp]

  ::inorganicBuilder::addMaterial materialList "ASiO2" \
    "Amorphous Silicon Dioxide" \
    $basis $pdbname $topname $parfilename $cutoff
}

proc ::inorganicBuilder::dumpCoordinates { boxname molid outfname } {
  array set box $boxname
  #upvar $boxname box
  
  set outf [open $outfname w]
  
  puts $outf "$box(origin)"
  puts $outf "[vecscale $box(na) $box(basisa)]"
  puts $outf "[vecscale $box(nb) $box(basisb)]"
  puts $outf "[vecscale $box(nc) $box(basisc)]"
  
  set allatoms [atomselect $molid all]
  puts $outf "[$allatoms num]"
  
  foreach atom [$allatoms get {index x y z}] {
    puts $outf "$atom"
  }
  $allatoms delete
  
  close $outf
}

proc ::inorganicBuilder::findShell { boxname molid gridsz radius dist } {
  set sel [atomselect $molid all]
  set results [measure surface $sel $gridsz $radius $dist] 
  
  return $results
}

# *** ADDED ***
proc ::inorganicBuilder::buildStructs { molid } {
  
  variable guiState
  variable homePath
  display update off  
  # add the structures
  set dens_printer [lsort -dictionary $guiState(densearea)]
  set surfdex "all"
  #  set surfdex "not index $dens_printer"
  
  # combine PDB files for surface/structure into one piece
  resetpsf        
  set Surf [atomselect $molid "$surfdex"]
  $Surf writepdb Surf.pdb
  $Surf writepsf Surf.psf
  $Surf delete

  # Patch the connections for PEG/DNA to gold

  source [file normalize [file join $homePath "mkPEG" "attach_PEG_Au.tcl"  ]]
  source [file normalize [file join $homePath "mkDNA" "attach_ssDNA_Au.tcl"]]
  
  resetpsf
  foreach entry $guiState(all_struct) {
    readpsf ${entry}_all.psf
    coordpdb ${entry}_all.pdb
  }



  if { $guiState(addStructType) == "dna" } {
    writepsf All_DNA.psf
    writepdb All_DNA.pdb
    set guiState(o_list) ""
    set tempAll [mol new All_DNA.pdb]
    set golist [atomselect $tempAll all]
    set segnameList [lsort -unique [$golist get segname]]
    $golist delete
    foreach segna $segnameList {

      set structO [atomselect $tempAll "segname $segna"]
      set finalresO [lindex [$structO get residue] end]
      set finalO [atomselect $tempAll "name O3' and residue $finalresO and segname $segna"]
      set o_to_add [$finalO get index]
      if { $o_to_add != "" } {
        lappend guiState(o_list) $o_to_add
      }
      $structO delete
      $finalO delete
		
	}

   
    attach_ssDNA_Au All_DNA.pdb Surf.pdb $guiState(o_list) $guiState(oau_list) $guiState(structedFile) $homePath
    file delete -force "tmp.pdb"
    file delete -force "Surf.pdb"
    file delete -force "Surf.psf"
    file delete -force "All_DNA.pdb"
    file delete -force "All_DNA.psf"
  } elseif { $guiState(addStructType) == "peg" } {
    writepsf All_PEG.psf
    writepdb All_PEG.pdb

    set guiState(c_list) ""
    set tempAll [mol new All_PEG.pdb]
    set colist [atomselect $tempAll all]
    set segnameList [lsort -unique [$colist get segname]]
    $colist delete
    foreach segna $segnameList {

      set structC [atomselect $tempAll "segname $segna"]
      set finalresC [lindex [$structC get residue] end]
      set finalC [atomselect $tempAll "name C2 and residue $finalresC and segname $segna"]
      set c_to_add [$finalC get index]
      if { $c_to_add != "" } {
        lappend guiState(c_list) $c_to_add
      }
      $structC delete
      $finalC delete
		
	}

    attach_PEG_Au All_PEG.pdb Surf.pdb $guiState(c_list) $guiState(cau_list) $guiState(structedFile) $homePath
    file delete -force "tmp.pdb"
    file delete -force "Surf.pdb"
    file delete -force "Surf.psf"
    file delete -force "All_PEG.pdb"
    file delete -force "All_PEG.psf"
  }


  set molid [mol new "$guiState(structedFile).pdb"]
  set guiState(structed_molid) $molid
  mol addfile "$guiState(structedFile).psf"
  mol delete $tempAll

  ::inorganicBuilder::setVMDPeriodPDB $molid "$guiState(structedFile).pdb"


  display resetview
  display update on


}





proc ::inorganicBuilder::printBondStats {} {
  for { set i 0 } { $i < 12 } {incr i } {
    set sel [atomselect top "numbonds $i"]
    puts "InorganicBuilder)$i bonds: [$sel num]"
    $sel delete
  }
}

proc ::inorganicBuilder::mergeMoleculesResegment { topfile mol1 mol2 outfile } {
  set m1sel [atomselect $mol1 "all"]
  set m2sel [atomselect $mol2 "all"]
  
  # Get atom types for the residues by building a dummy segment with
  # one of each residue type and then reading back the atoms
  set resnamelist [concat [$m1sel get resname] \
                          [$m2sel get resname]]

  set resnamelist [lsort -unique $resnamelist]

  set psfcon [psfcontext create]
  psfcontext eval $psfcon {
  
  foreach top $topfile {
    topology $top
  }
  set resid 0
  segment DMY {
    auto none
    first NONE
    last NONE
    foreach resname $resnamelist {
      residue $resid $resname
      incr resid
    }
  }
  for {set i 0} { $i < $resid} { incr i } {
    set resname [ segment residue DMY $i ]
    set atomlist [ segment atoms DMY $i ]
    set resatoms($resname,allatomtypes) $atomlist
    foreach atomtype $atomlist {
      set resatoms($resname,$atomtype) -1
    }
#    puts "InorganicBuilder)Res($i) $resname: $atomlist"
  }
  resetpsf
  # Now sort through each atom in each selection, and generate lists of 
  # resnames, atoms to add, and atoms to delete. This is very much like
  # the unit-cell building code above.
  foreach sel [list $m1sel $m2sel ] {
    set ucnames [$sel get {index name resname resid}]
    #  puts "InorganicBuilder)Unit Cell names: $ucnames"
    # Store data indexed by resname
    array unset atomsbyresid
    foreach element $ucnames {
      foreach {index name resname resid} $element {
#       puts "InorganicBuilder)index=$index name=$name resname=$resname x=$x,%y,$z"
        lappend atomsbyresid($resid) [list $index $name $resname]
      }
    }
    set ucresids [array names atomsbyresid]
#    puts "InorganicBuilder)resids are $ucresids"

    set seglist {}
    # Pre-calculate the segment list and coordinate lists, so we can
    # just add the ones we need
    set n 0
    if {[string equal $sel $m1sel]} {
      set prefix "A"
    } else {
      set prefix "B"
    }
    set curresid 0
    set seg_coords {}
    array unset pos
    set allpos [$sel get {index x y z}]
    foreach atom $allpos {
      foreach {index x y z} $atom {
        set pos($index) [list $x $y $z]
      }
    }
    foreach resid $ucresids {
      set res_coords {}
      set res_delete {}
      set resname ""
      foreach atom $atomsbyresid($resid) {
        foreach { id name resname} $atom {}
        set resatoms($resname,$name) $id
      } 
#      puts "InorganicBuilder)seg $prefix $n resid $curresid"
      foreach atomtype $resatoms($resname,allatomtypes) {
        set id $resatoms($resname,$atomtype)
        if { $id != -1 } {
          lappend res_coords [list $atomtype $pos($id) $resname ]
#          puts "InorganicBuilder)Setting $resname $atomtype $name $pos($id) $resname"
        } else {
          lappend res_delete $atomtype
#          puts "InorganicBuilder)Deleting $resname $atomtype"
        }
        set resatoms($resname,$atomtype) -1
      }
#     puts "InorganicBuilder)Storing res CUR:$curresid NAME:$resname COOR:[llength $res_coords] DEL:[llength $res_delete]"
      if { [ llength $res_coords ] > 0 } {
        lappend seg_coords [list $curresid $resname $res_coords $res_delete] 
        incr curresid
        # If the number of residues to be added would roll over the PDB
        # residue id counter, increment the segment counter and reset
        # the res id to zero
        if { $curresid > 9999 } {
          set nstr [string toupper [format "%x" $n]]
          set segid ${prefix}$nstr
          buildSegment $segid $seg_coords
          incr n
          set curresid 0
          set seg_coords {}
        }
      }
    }
    # if there are molecules in the last segment, build it
    if { [ llength $seg_coords ] != 0 } {
      set nstr [string toupper [format "%x" $n]]
      set segid ${prefix}$nstr
      buildSegment $segid $seg_coords
    }
  }
  writepdb $outfile.pdb
  writepsf $outfile.psf
  }
  
  psfcontext delete $psfcon
  $m1sel delete
  $m2sel delete
#  mol delete $mol1
#  mol delete $mol2
  return
}

# *** MODIFIED, THEREFORE ***
# *** ADDED ***
proc ::inorganicBuilder::solvateBox { boxlist infiles outfile} {
  variable guiState
  array set box $boxlist
  foreach {psffile pdbfile} $infiles {}

#  puts "InorganicBuilder)Transforming coordinates"
  set inpmol [mol new [file normalize $psffile] type psf autobonds off waitfor all]
  mol addfile [file normalize $pdbfile] type pdb autobonds off waitfor all
  transformCoordsToBox [array get box] $inpmol
  set allatoms [atomselect $inpmol all]
  $allatoms writepdb $outfile.0.pdb
  $allatoms delete
  mol delete $inpmol

#  puts "InorganicBuilder)Finding box corners"
  # Find the min/max corners of the real box
  set c [ getRealCoord box [list 0 0 0] ]
  set min $c
  set max $c
  
  findSolvateMinMax min max [ getRealCoord box [list $box(na) 0 0]]
  findSolvateMinMax min max [ getRealCoord box [list 0 $box(nb) 0]]
  findSolvateMinMax min max [ getRealCoord box [list 0 0 $box(nc)]]
  findSolvateMinMax min max [ getRealCoord box [list $box(na) $box(nb) 0]]
  findSolvateMinMax min max [ getRealCoord box [list $box(na) 0 $box(nc)]]
  findSolvateMinMax min max [ getRealCoord box [list 0 $box(nb) $box(nc)]]
  findSolvateMinMax min max [ getRealCoord box \
                              [list $box(na) $box(nb) $box(nc)]]
#  puts "InorganicBuilder)Box corners $min --- $max"
  
  # Solvate the box
#  puts "InorganicBuilder)Calling solvate"
  solvate $psffile $outfile.0.pdb -o $outfile.1 -minmax [list $min $max]
  set solv_mol [molinfo top]
  
  # Figure out which oxygens are outside of the box, and then trim them off
  # along with their attached hydrogens
  # puts "InorganicBuilder)Loading result"
  # set solv_mol [ mol new $outfile.1.psf type psf autobonds off waitfor all]
  # mol addfile $outfile.1.pdb type pdb autobonds off
  
  # Get all the water oxygen molecules
#  puts "InorganicBuilder)Getting Oxygens"
  set oxygens [atomselect $solv_mol "name OH2"]
  set oh2list [$oxygens get { index x y z } ]
  
  # Find which oxygens to delete
  set del_list {}
  foreach oh2 $oh2list {
    foreach { indx x y z } $oh2 {}
    set cellcoord [ getCellCoord box [list $x $y $z] ]
    foreach { i j k } $cellcoord {}
    if { $i < 0 || $i >= $box(na) || $j < 0 || $j >= $box(nb) \
         || $k < 0 || $k >= $box(nc) } {
      lappend del_list $indx
    }
  }
  # Find the hydrogens bonded with those oxygens, and delete them too
  if { [llength $del_list] > 0 } {
    set o_del_sel [ atomselect $solv_mol "index $del_list"]
    set h_indices [ $o_del_sel getbonds ]
    foreach bondlist $h_indices {
      foreach indx $bondlist {
        lappend del_list $indx
      }
    }
  
    # Only keep the non-deleted atoms
    # WARNING: I think this is going to produce an incomplete PSF file.
    # Probably need to copy what the solvate code to get a proper box
    set keep_sel [atomselect $solv_mol "not index $del_list"]
    #  puts "InorganicBuilder)Keeping [ $keep_sel num ] atoms"
  } else {
    set keep_sel [atomselect $solv_mol all]
  }
  $keep_sel writepsf $outfile.psf
  $keep_sel writepdb $outfile.pdb
  
  # If this is a hex box, transform to hex
  if { [string equal $box(type) "hex"] } {
    set hexmol [mol new $outfile.psf autobonds off waitfor all]
    mol addfile $outfile.pdb autobonds off waitfor all
    transformCoordsToHex $boxlist $hexmol
    set hexatoms [atomselect $hexmol all]
    $hexatoms writepdb $outfile.pdb
    $hexatoms writepsf $outfile.psf
    $hexatoms delete
    mol delete $hexmol
  }

  # Long-standing solvate bug: Periodic behavior is destroyed.
  # Here is a fix for the Auto-Solvate button under Build Surf-Struct > RunNAMD
  if {$boxlist == $guiState(structBox)} {
    ::inorganicBuilder::setVMDPeriodPDB $solv_mol "$guiState(structedFile).pdb" 
  }
  mol delete $solv_mol
  $keep_sel delete
  $oxygens delete

  return
}

proc ::inorganicBuilder::findSolvateMinMax { min max vec } {
  upvar $min m0
  upvar $max m1
  foreach { x y z } $vec {}
  foreach { x0 y0 z0 } $m0 {}
  if { $x < $x0 } { set x0 $x }
  if { $y < $y0 } { set y0 $y }
  if { $z < $z0 } { set z0 $z }
  set m0 [list $x0 $y0 $z0]
  
  foreach { x1 y1 z1 } $m1 {}
  if { $x > $x1 } { set x1 $x }
  if { $y > $y1 } { set y1 $y }
  if { $z > $z1 } { set z1 $z }
  set m1 [list $x1 $y1 $z1]
}

proc ::inorganicBuilder::findBasisVectors { { molid top} } {
  if { [string equal $molid "top"] } {
    set molid [molinfo top]
  }
  set allatoms [atomselect $molid all]
  set center [measure center $allatoms]
  set ucparams [molinfo $molid get { a b c alpha beta gamma }]
  foreach { a b c alpha beta gamma } $ucparams {}
  
  set deg2rad 1.74532925199e-02
  
  set cosbc [expr cos($alpha * $deg2rad)]
  set cosac [expr cos($beta * $deg2rad)]
  set cosab [expr cos($gamma * $deg2rad)]
  set sinab [expr sin($gamma * $deg2rad)]
  
  set avec [list $a 0 0]
  set bvec [list [expr $b * $cosab] [expr $b * $sinab] 0]
  if { [expr $sinab > 0] } {
    set ucx $cosac
    set ucy [expr ($cosbc - $cosac * $cosab) / $sinab]
    set ucz [expr sqrt(1.0 - $ucx * $ucx - $ucy * $ucy)]
  }
  set cvec [list [expr $c * $ucx] [expr $c * $ucy] [expr $c * $ucz] ]
  
  return [list $center $avec $bvec $cvec]
}

proc inorganicBuilder_tk {} {
  ::inorganicBuilder::inorganicBuilder_mainwin
  return $::inorganicBuilder::w
}

proc load_grid {} {
  set inf [open grid.dat r]
  while {[gets $inf line] >= 0} {
    graphics top sphere [concat $line] radius 2 resolution 10
  }
  close $inf
}
