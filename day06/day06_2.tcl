
set input example.txt
set numdays 18

set input input.txt
set numdays 80

set startdays [split [string trim [read [open $input]]] ","]


set days [lrepeat 9 0]

proc add_index { l index amount } {
    set currentvalue [lindex $l $index]
    set newvalue [incr currentvalue $amount]
    set l [lreplace $l $index $index $newvalue]
    return $l
}
foreach day $startdays {
    set currentvalue [lindex $days $day]
    set newvalue [incr currentvalue]
    set days [add_index $days $day 1]
}

puts $days


for { set i 0 } { $i < $numdays } { incr i } {
    set current [lindex $days 0]
    set days [lrange $days 1 end]
    lappend days $current
    set days [add_index $days 6 $current]
}

set total 0
foreach day $days {
    incr total $day
}
puts $total
