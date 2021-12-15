package require struct::matrix
package require struct::prioqueue

set input example.txt
set input input.txt

set lines [split [string trim [read [open $input]]] "\n"]


catch {map destroy}
struct::matrix map

set height [llength $lines]
set width [string length [lindex $lines 0]]
map add rows $height
map add columns $width

for { set y 0 } { $y < [llength $lines] } { incr y } {
    for { set x 0 } { $x < [llength $lines] } { incr x } {
        set danger [string index [lindex $lines $y] $x]
        map set cell $x $y $danger
    }
}

set target [list [expr $width - 1] [expr $height - 1]]

proc dist { pos } {
    global target
    lassign $pos x y
    lassign $target xp yp
    return [expr abs($x - $xp) + abs($y - $yp)]
}

set startPos [list 0 0]
set initialSolution [list [list $startPos] 0]

catch {queue destroy}
struct::prioqueue -real queue
queue put $initialSolution [expr 1.0 / [dist $startPos]]

set tries 0
while { [queue size] > 0 } {
    lassign [queue get] path cost
    #puts "path ($cost) $path"

    lassign [lindex $path end] x y
    if { ($x + 1) == $width && ($y + 1) == $height } {
        puts "SOLUTION FOUND!"
        break
    }

    set offsets { {0 1} {1 0} {-1 0} {0 -1} }
    foreach offset $offsets {
        lassign $offset xoffset yoffset
        set xp [expr $x + $xoffset]
        set yp [expr $y + $yoffset]
        if { $xp >= $width || $xp < 0 || $yp >= $height || $yp < 0 } {
            continue
        }
        set newpos [list $xp $yp]

        if { [lsearch $path $newpos] >= 0 } {
            continue
        }

        set danger [map get cell $xp $yp]
        set newcost [expr $cost + $danger]
        set newpath $path
        lappend newpath $newpos
        set estcost [dist $newpos]
        set newprio [expr $newcost + $estcost]
        queue put [list $newpath $newcost] [expr 1.0 / $newprio]
    }
    incr tries

    if { $tries > 100000 } {
        puts "too many tries"
        break
    }
    if { ($tries % 1000) == 0 } {
        puts "q [queue size]"
    }
}

puts $path
puts $cost
