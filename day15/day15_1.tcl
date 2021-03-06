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
map add rows $height
map add columns $width

costs add rows $height
costs add columns $width

set largeNumber 10000000
for { set y 0 } { $y < [llength $lines] } { incr y } {
    for { set x 0 } { $x < [llength $lines] } { incr x } {
        set danger [string index [lindex $lines $y] $x]
        map set cell $x $y $danger
        costs set cell $x $y $largeNumber
    }
}
costs set cell 0 0 0

set target [list [expr $width - 1] [expr $height - 1]]


set startPos [list 0 0]

set queue [list $startPos]

set tries 0
while { [llength $queue] > 0 } {
    lassign [lindex $queue 0] x y
    if { ($x + 1) == $width && ($y + 1) == $height } {
        #puts "SOLUTION FOUND, maybe!"
        #break
    }
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

    #if { $tries > 500000 } {
    #    puts "too many tries"
    #    break
    #}
    if { ($tries % 10000) == 0 } {
        puts "q [llength $queue]"
    }
}

puts [costs get cell [expr $width - 1] [expr $height - 1]]
