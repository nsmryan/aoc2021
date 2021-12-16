package require struct::matrix

set input example.txt
set input input.txt

set lines [split [string trim [read [open $input]]] "\n"]


catch {map destroy}
struct::matrix map

catch {costs destroy}
struct::matrix costs

set height [llength $lines]
set width [string length [lindex $lines 0]]

costs add rows [expr $height * 5]
costs add columns [expr $width * 5]
map add rows [expr $height * 5]
map add columns [expr $width * 5]

set largeNumber 10000000
for { set y 0 } { $y < $height } { incr y } {
    for { set x 0 } { $x < $width } { incr x } {
        set danger [string index [lindex $lines $y] $x]
        map set cell $x $y $danger
        costs set cell $x $y $largeNumber
    }
}
costs set cell 0 0 0

for { set times 1 } { $times < 25 } { incr times } {
    set repcol [expr $times % 5]
    set reprow [expr $times / 5]
    set xoffset [expr $repcol * $width]
    set yoffset [expr $reprow * $height]

    for { set y 0 } { $y < [llength $lines] } { incr y } {
        for { set x 0 } { $x < [llength $lines] } { incr x } {
            set cellx [expr $x + $xoffset]
            set celly [expr $y + $yoffset]

            set danger [map get cell $x $y]
            set newDanger [expr ((($danger - 1) + $repcol + $reprow) % 9) + 1]
            map set cell $cellx $celly $newDanger
            costs set cell $cellx $celly $largeNumber
        }
    }
}
set height [expr $height * 5]
set width [expr $width * 5]

set target [list [expr $width - 1] [expr $height - 1]]

set startPos [list 0 0]

set queue [list $startPos]

set startTime [clock milliseconds]
set tries 0
while { [llength $queue] > 0 } {
    lassign [lindex $queue 0] x y
    set queue [lrange $queue 1 end]

    set currentCost [costs get cell $x $y]

    set offsets { {0 1} {1 0} {-1 0} {0 -1} }
    foreach offset $offsets {
        lassign $offset xoffset yoffset
        set xp [expr $x + $xoffset]
        set yp [expr $y + $yoffset]
        if { $xp >= $width || $xp < 0 || $yp >= $height || $yp < 0 } {
            continue
        }
        set newpos [list $xp $yp]

        set danger [map get cell $xp $yp]

        set newCost [expr $currentCost + $danger]

        if { $newCost < [costs get cell $xp $yp] } {
            costs set cell $xp $yp $newCost
            lappend queue $newpos
        }
    }
    incr tries

    if { $tries > 10000000 } {
        puts "too many tries"
        break
    }
    if { ($tries % 10000) == 0 } {
        puts "tries $tries"
        puts "queue length [llength $queue]"
        set currentTime [clock milliseconds]
        set took [expr ($currentTime - $startTime) / 1000.0]
        puts "took $took"
        puts "[expr $tries / $took] tries per second"
    }
}

puts [costs get cell [expr $width - 1] [expr $height - 1]]
