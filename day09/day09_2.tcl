package require struct::matrix
namespace import struct::matrix::*

package require struct::graph
namespace import struct::graph::*

package require struct::set


set input example.txt
set input input.txt

set lines [split [string trim [read [open $input]]]]

if { [info command map] != "" } {
    map destroy
}
matrix map
map add rows [llength $lines]
map add columns [string length [lindex $lines 0]]

if { [info command links] != "" } {
    links destroy
}
struct::graph links

for { set linenum 0 } { $linenum < [llength $lines] } { incr linenum } {
    set line [lindex $lines $linenum]
    for { set i 0 } { $i < [string length $line] } { incr i } {
        set value [string index $line $i]
        map set cell $i $linenum $value

        set coord ($i,$linenum)
        links node insert $coord
        links node set $coord value $value
    }
}

for { set y 0 } { $y < [map rows] } { incr y } {
    for { set x 0 } { $x < [map columns] } { incr x } {
        set cell [map get cell $x $y]
        if { $cell == 9 } {
            continue
        }
        set coord ($x,$y) 

        set nextlist [list]
        if { $x > 0 } {
            set xprime [expr $x - 1]
            set cellprime [map get cell $xprime $y]
            set coordprime ($xprime,$y)

            if { $cellprime < $cell } {
                links arc insert $coordprime $coord
            }
        }

        if { $x < ([map columns] - 1) } {
            set xprime [expr $x + 1]
            set cellprime [map get cell $xprime $y]
            set coordprime ($xprime,$y)

            if { $cellprime < $cell } {
                links arc insert $coordprime $coord
            }
        }

        if { $y > 0 } {
            set yprime [expr $y - 1]
            set cellprime [map get cell $x $yprime]
            set coordprime ($x,$yprime)

            if { $cellprime < $cell } {
                links arc insert $coordprime $coord
            }
        }

        if { $y < ([map rows] - 1) } {
            set yprime [expr $y + 1]
            set cellprime [map get cell $x $yprime]
            set coordprime ($x,$yprime)

            if { $cellprime < $cell } {
                links arc insert $coordprime $coord
            }
        }
    }
}

set seen [list]
proc gather { typ g node } {
    global seen
    struct::set add seen $node

}

set basins [list]
foreach node [links nodes] {
    if { [links node degree -in $node] == 0 } {
        set value [links node get $node value]
        if { $value == 9 } {
            continue
        }

        set seen [list]
        links walk $node -command gather
        dict set basins $node $seen
    }
}

proc compare { basin0 basin1 } {
    global basins
    set l0 [llength [dict get $basins $basin0]]
    set l1 [llength [dict get $basins $basin1]]
    if { $l0 < $l1 } {
        return -1
    } else {
        return 1
    }

}
set basinnodes [dict keys $basins]
set basinnodes [lsort -decreasing -command compare $basinnodes]

set result [llength [dict get $basins [lindex $basinnodes 0]]]
set result [expr $result * [llength [dict get $basins [lindex $basinnodes 1]]]]
set result [expr $result * [llength [dict get $basins [lindex $basinnodes 2]]]]
puts $result
