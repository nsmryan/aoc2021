
array unset grid
array set grid {}

set input input.txt
#set input example.txt

set lines [split [read [open $input]] "\n"]

proc sign { num } {
    if { $num >= 0 } {
        return 1
    } else {
        return -1
    }
}

foreach line $lines {
    if { [llength $line] == 0 } {
        continue
    }

    lassign $line start sep end

    lassign [split $start ","] x0 y0
    lassign [split $end ","] x1 y1

    if { $x0 == $x1 } {
        set dir [sign [expr $y1 - $y0]]
        set y $y0 
        while { 1 } {
            incr grid($x0,$y)
            if { $y == $y1 } {
                break
            }
            incr y $dir
        }
    } elseif { $y0 == $y1 } {
        set dir [sign [expr $x1 - $x0]]
        set x $x0
        while { 1 } {
            incr grid($x,$y0)
            if { $x == $x1 } {
                break
            }
            incr x $dir
        }
    }
}

for { set y 0 } { $y < 10 } { incr y } {
    for { set x 0 } { $x < 10 } { incr x } {
        if { [info exists grid($x,$y)] } {
            puts -nonewline $grid($x,$y)
        } else {
            puts -nonewline 0
        }
    }
    puts ""
}

set count 0
foreach name [array names grid] {
    if { $grid($name) > 1 } {
        incr count
    }
}
puts $count

