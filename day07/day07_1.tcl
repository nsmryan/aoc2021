set input example.txt
set input input.txt

set positions [split [read [open $input]] ","]

set max [lindex $positions 0]
foreach pos $positions {
    if { $pos > $max } {
        set max $pos
    }
}

set leastcost 1000000000000000
set bestpos 0
for { set i 0 } { $i < $max } { incr i } {
    set cost 0
    foreach pos $positions { 
        incr cost [expr abs($pos - $i)]
    }

    if { $cost < $leastcost } {
        set bestpos $i
        set leastcost $cost
    }
}

puts $bestpos
puts $leastcost
