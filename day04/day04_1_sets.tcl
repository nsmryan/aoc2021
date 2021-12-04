package require struct::matrix
namespace import struct::matrix::*

package require struct::set


#set input example.txt
set input input.txt
set lines [split [read [open $input]] "\n"]

set moves [split [lindex $lines 0] ","]
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


proc checkwin { board moves } {
    # check rows
    for { set y 0 } { $y < [$board rows]} { incr y } {
        set all 1
        for { set x 0 } { $x < [$board columns] } { incr x } {
            set num [$board get cell $x $y]
            set within [struct::set contains $moves $num]
            set all [expr $all & $within]
        }

        if { $all } {
            return 1
        }
    }

    # check columns
    for { set x 0 } { $x < [$board columns] } { incr x } {
        set all 1
        for { set y 0 } { $y < [$board rows]} { incr y } {
            set num [$board get cell $x $y]
            set within [struct::set contains $moves $num]
            set all [expr $all & $within]
        }

        if { $all } {
            return 1
        }
    }

    return 0
}

proc score { board moves move } {
    set unmarkedsum 0
    for { set y 0 } { $y < [$board rows]} { incr y } {
        for { set x 0 } { $x < [$board columns] } { incr x } {
            set num [$board get cell $x $y]
            if { ![struct::set contains $moves $num] } {
                incr unmarkedsum $num
            }
        }
    }

    return [expr $unmarkedsum * $move]
}

proc play { boards moves } {
    set numboards [llength $boards]

    foreach move $moves {
        struct::set include moved $move

        for { set i 0 } { $i < $numboards } { incr i } {
            set board [lindex $boards $i]

            if { [checkwin $board $moved] } {
                return [score $board $moved $move]
            }
        }
    }

    throw NOWINNER "No board won after all moves were played!"
}

puts [play $boards $moves]

