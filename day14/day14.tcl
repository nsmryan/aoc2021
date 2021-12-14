set input example.txt
set input input.txt
# part 1
#set numsteps 10

# part 2
set numsteps 40

set lines [split [string trim [read [open $input]]] "\n"]


set poly [lindex $lines 0]
set rawsubs [lrange $lines 2 end]
set subs [list]
foreach rawsub $rawsubs {
    set left [string range $rawsub 0 1]
    set right [string range $rawsub end end]
    lappend subs $left $right
}

set counts [list]
for { set i 0 } { ($i + 1) < [string length $poly] } { incr i } {
    set pair [string range $poly $i $i+1]
    
    set count 0
    if { [dict exists $counts $pair] } {
        set count [dict get $counts $pair]
    } 
    incr count

    dict set counts $pair $count
}

puts $counts
for { set step 0 } { $step < $numsteps } { incr step } {
    puts "step $step"
    set newcounts [list]
    dict for { pair count } $counts {
        if { [dict exists $subs $pair] } {
            set chr [dict get $subs $pair]

            set pair0 "[string index $pair 0]$chr"
            set newcount0 $count
            if { [dict exists $newcounts $pair0] } {
                incr newcount0 [dict get $newcounts $pair0]
            }
            dict set newcounts $pair0 $newcount0
            #puts "$pair0 : $newcount0"

            set pair1 "$chr[string index $pair 1]"
            set newcount1 $count
            if { [dict exists $newcounts $pair1] } {
                incr newcount1 [dict get $newcounts $pair1]
            }
            dict set newcounts $pair1 $newcount1
            #puts "$pair1 : $newcount1"
        } else {
            set newcount 1
            if { [dict exists $newcounts $pair] } {
                incr newcount [dict get $newcounts $pair]
            }
            dict set newcounts $pair $newcount
        }
    }

    set counts $newcounts
    #puts $counts
    set len 1
    foreach count [dict values $counts] {
        incr len $count
    }
    #puts "length $len"
}

#puts $counts

set elcounts [list]
dict for { pair count } $counts {
    set l0 [string index $pair 0]
    set newcount $count
    if { [dict exists $elcounts $l0] } {
        incr newcount [dict get $elcounts $l0]
    }
    dict set elcounts $l0 $newcount

    set l1 [string index $pair 1]
    set newcount $count
    if { [dict exists $elcounts $l1] } {
        incr newcount [dict get $elcounts $l1]
    }
    dict set elcounts $l1 $newcount
}
set finalcounts [list]
dict for { letter count } $elcounts {
    dict set finalcounts $letter [expr (($count - 1) / 2) + 1]
}

puts "finalcounts $finalcounts"
puts ""

set sorted [lsort -integer [dict values $finalcounts]]
puts "sorted $sorted"
puts [expr [lindex $sorted end] - [lindex $sorted 0]]
