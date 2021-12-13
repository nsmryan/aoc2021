package require struct::graph

set input example.txt
set input input.txt

set lines [split [string trim [read [open $input]]] "\n"]

catch {paper destroy}
struct::graph paper

while { [llength [lindex $lines 0]] > 0 } {
    set line [lindex $lines 0]
    set lines [lrange $lines 1 end]
    lassign [split $line ","] x y

    paper node insert $x,$y
}

# skip blank
set lines [lrange $lines 1 end]

set folds [list]
foreach line $lines {
    lassign [split $line " "] fold along assign
    lassign [split $assign "="] axis splitpos
    lappend folds [list $axis $splitpos]
}

foreach fold $folds {
    puts "folding $fold"
    lassign $fold axis splitpos

    foreach pos [paper nodes] {
        lassign [split $pos ","] x y
        if { $x == $splitpos } {
            #throw INVALIDSPLIT "Splits aren't supposed to have dots on them"
        }

        if { $axis == "y" } {
            if { $y > $splitpos } {
                paper node delete $pos

                set newy [expr $splitpos - ($y - $splitpos)]
                set newnode $x,$newy
                if { ![paper node exists $newnode] } {
                    paper node insert $newnode
                }
            }
        } else {
            if { $x > $splitpos } {
                paper node delete $pos

                set newx [expr $splitpos - ($x - $splitpos)]
                set newnode $newx,$y
                if { ![paper node exists $newnode] } {
                    paper node insert $newnode
                }
            }
        }
    }
}

set maxx 0
set maxy 0
foreach node [paper nodes] {
    lassign [split $node ","] x y
    set maxx [expr max($maxx, $x)]
    set maxy [expr max($maxy, $y)]
}
incr maxx
incr maxy

puts "max x $maxx, max y $maxy"
for { set y 0 } { $y < $maxy } { incr y } {
    for { set x 0 } { $x < $maxx } { incr x } {
        if { [paper node exists $x,$y] } {
            puts -nonewline "*"
        } else {
            puts -nonewline " "
        }
    }
    puts ""
}

puts [llength [paper nodes]]

