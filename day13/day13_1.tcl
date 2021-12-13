package require struct::graph

set input example.txt
set input input.txt

set lines [split [read [open $input]] "\n"]

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
    lappend folds $axis $splitpos
}

set firstaxis [lindex $folds 0]
set firstsplit [lindex $folds 1]

puts "$firstaxis $firstsplit"
foreach pos [paper nodes] {
    lassign [split $pos ","] x y
    if { $x == $firstsplit } {
        throw INVALIDSPLIT "Splits aren't supposed to have dots on them"
    }

    if { $firstaxis == "y" } {
        if { $y > $firstsplit } {
            paper node delete $pos

            set newy [expr $firstsplit - ($y - $firstsplit)]
            set newnode $x,$newy
            puts "inserting $newnode from $x, $y"
            if { ![paper node exists $newnode] } {
                paper node insert $newnode
            }
        }
    } else {
        if { $x > $firstsplit } {
            paper node delete $pos

            set newx [expr $firstsplit - ($x - $firstsplit)]
            set newnode $newx,$y
            puts "inserting $newnode from $x, $y"
            if { ![paper node exists $newnode] } {
                paper node insert $newnode
            }
        }
    }
}

puts [paper nodes]
puts [llength [paper nodes]]

