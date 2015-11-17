# TODO (Max): get rid of ::drawenv:: -- merge it to inorganicbuilder
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
    set materialId [ list [graphics $molid materials on ] [graphics $molid materials off ] ]

  } else {
    set materialId [ list [graphics $molid materials on] [graphics $molid material $material] ]
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

