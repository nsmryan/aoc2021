package require struct::matrix
namespace import struct::matrix::*

#set input example.txt
set input input.txt
set lines [split [read [open $input]] "\n"]

set moves [lindex $lines 0]
set moves [split $moves ","]

set boardlines [lrange $lines 2 end]

proc parseboard { boardlines } {
    set dim [llength [lindex $boardlines 0]]
    set m [matrix]
    $m add rows $dim
    $m add columns $dim
    for { set y 0 } { $y < $dim } { incr y } {
        set line [lindex $boardlines 0]
        for { set x 0 } { $x < $dim } { incr x } {
            $m set cell $x $y [lindex $line $x]
        }
        set boardlines [lrange $boardlines 1 end]
    }

    return [list $m $boardlines]
}

proc parseboards { boardlines } {
    set boards [list]
    while { [llength $boardlines] > 1 } {
        lassign [parseboard $boardlines] board boardlines
        lappend boards $board

        if { [llength [lindex $boardlines 0]] == 0 } {
            set boardlines [lrange $boardlines 1 end]
        }
    }

    return $boards
}

set boards [parseboards $boardlines]
set numboards [llength $boards]
set dim [[lindex $boards 0] columns]

set marks [list]
for { set i 0 } { $i < $numboards } { incr i } {
    set mark [matrix]
    $mark add rows $dim
    $mark add columns $dim
    for { set y 0 } { $y < $dim } { incr y } {
        for { set x 0 } { $x < $dim } { incr x } {
            $mark set cell $x $y 0
        }
    }
    lappend marks $mark
}

proc playmove { board mark move } {
    for { set y 0 } { $y < [$board rows]} { incr y } {
        for { set x 0 } { $x < [$board columns] } { incr x } {
            if { [$board get cell $x $y] == $move } {
                $mark set cell $x $y 1
            }
        }
    }
}

proc checkwin { mark } {
    # check rows
    for { set y 0 } { $y < [$mark rows]} { incr y } {
        set all 1
        for { set x 0 } { $x < [$mark columns] } { incr x } {
            set all [expr $all & [$mark get cell $x $y]]
        }

        if { $all } {
            return 1
        }
    }

    # check columns
    for { set x 0 } { $x < [$mark columns] } { incr x } {
        set all 1
        for { set y 0 } { $y < [$mark rows]} { incr y } {
            set all [expr $all & [$mark get cell $x $y]]
        }

        if { $all } {
            return 1
        }
    }

    return 0
}

proc score { board mark move } {
    set unmarkedsum 0
    for { set y 0 } { $y < [$board rows]} { incr y } {
        for { set x 0 } { $x < [$board columns] } { incr x } {
            if { [$mark get cell $x $y] == 0 } {
                incr unmarkedsum [$board get cell $x $y]
            }
        }
    }

    return [expr $unmarkedsum * $move]
}

proc play { boards marks moves } {
    set numboards [llength $boards]

    foreach move $moves {
        for { set i 0 } { $i < $numboards } { incr i } {
            set board [lindex $boards $i]
            set mark [lindex $marks $i]
            playmove $board $mark $move
            if { [checkwin $mark] } {
                return [score $board $mark $move]
            }
        }
    }

    throw NOWINNER "No board won after all moves were played!"
}

puts [play $boards $marks $moves]

