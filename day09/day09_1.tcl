package require struct::matrix
namespace import struct::matrix::*

set input example.txt
set input input.txt

set lines [split [string trim [read [open $input]]]]

if { [info command map] != "" } {
    map destroy
}

matrix map
map add rows [llength $lines]
map add columns [string length [lindex $lines 0]]


for { set linenum 0 } { $linenum < [llength $lines] } { incr linenum } {
    set line [lindex $lines $linenum]
    for { set i 0 } { $i < [string length $line] } { incr i } {
        map set cell $i $linenum [string index $line $i]
    }
}

set risk 0

for { set y 0 } { $y < [map rows] } { incr y } {
    for { set x 0 } { $x < [map columns] } { incr x } {
        set low 1

        if { $x > 0 } {
            set xprime [expr $x - 1]
            set low [expr $low && [map get cell $x $y] < [map get cell $xprime $y]]
        }

        if { $x < ([map columns] - 1) } {
            set xprime [expr $x + 1]
            set low [expr $low && [map get cell $x $y] < [map get cell $xprime $y]]
        }

        if { $y > 0 } {
            set yprime [expr $y - 1]
            set low [expr $low && [map get cell $x $y] < [map get cell $x $yprime]]
        }

        if { $y < ([map rows] - 1) } {
            set yprime [expr $y + 1]
            set low [expr $low && [map get cell $x $y] < [map get cell $x $yprime]]
        }

        if { $low } {
            incr risk [expr [map get cell $x $y] + 1]
        }
    }
}
puts $risk
