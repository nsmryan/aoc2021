package require struct::matrix
namespace import struct::matrix::*

package require struct::set


set input example.txt
set input input.txt

set lines [split [string trim [read [open $input]]] "\n"]

catch {energy destroy}
struct::matrix energy
energy add rows [llength $lines] 
energy add columns [string length [lindex $lines 0]]

for { set y 0 } { $y < [llength $lines] } { incr y } {
    set line [lindex $lines $y]

    for { set x 0 } { $x < [string length $line] } { incr x } {
        energy set cell $x $y [string index $line $x]
    }
}

puts "initial board, rows [energy rows] cols [energy columns]"
puts [energy format 2string]

set turns 100
set totalflashes 0
for { set turn 0 } { $turn < $turns } { incr turn } {
    #puts ""
    #puts "turn $turn, rows [energy rows] cols [energy columns]"

    set toSpread [list]
    set flashed [list]
    set numflashes 0
    for { set y 0 } { $y < [energy rows] } { incr y } {
        for { set x 0 } { $x < [energy columns] } { incr x } {
            energy set cell $x $y [expr [energy get cell $x $y] + 1]

            if { [energy get cell $x $y] > 9 } {
                energy set cell $x $y 0
                struct::set include flashed ($x,$y)
                lappend toSpread [list $x $y]
                incr numflashes
            }
        }
    }

    while { [llength $toSpread] > 0 } {
        lassign [lindex $toSpread end] x y
        set toSpread [lrange $toSpread 0 end-1]

        for { set yoffset -1 } { $yoffset < 2 } { incr yoffset } {
            for { set xoffset -1 } { $xoffset < 2 } { incr xoffset } {
                if { ($xoffset == 0) && ($yoffset == 0) } {
                    continue
                }
                set xprime [expr $x + $xoffset]
                set yprime [expr $y + $yoffset]

                if { $xprime < 0 || $yprime < 0 || $xprime >= [energy columns] || $yprime >= [energy rows]} {
                    continue
                }

                if { ![struct::set contains $flashed ($xprime,$yprime)] } {
                    energy set cell $xprime $yprime [expr [energy get cell $xprime $yprime] + 1]

                    if { [energy get cell $xprime $yprime] > 9 } {
                        energy set cell $xprime $yprime 0
                        struct::set include flashed ($xprime,$yprime)
                        lappend toSpread [list $xprime $yprime]
                        incr numflashes
                    }
                }
            }
        }
    }
    #puts [energy format 2string]
    #puts "num flashes $numflashes"
    #puts "flashed: $flashed"
    incr totalflashes $numflashes
}

puts ""
puts "final board"
puts [energy format 2string]
puts "total flashes: $totalflashes"
