set nums [read [open input.txt]]

set numbits [string length [lindex $nums 0]]
set mask 0
for { set i 0 } { $i < $numbits } { incr i } {
    lappend numones 0
    set mask [expr ($mask << 1) | 1]
}

foreach num $nums {
    for { set i 0 } { $i < $numbits } { incr i } {
        if { [string index $num $i] == "1" } {
            set n [lindex $numones $i]
            incr n
            set numones [lreplace $numones $i $i $n]
        }
    }
}

set midrate [expr [llength $nums] / 2]
set gamma ""
set epsilon ""
for { set i 0 } { $i < $numbits } { incr i } {
    if { [lindex $numones $i] > $midrate } {
        set gamma [string cat $gamma 1]
        set epsilon [string cat $epsilon 0]
    } else {
        set gamma [string cat $gamma 0]
        set epsilon [string cat $epsilon 1]
    }
}

set gamma [binary format b* [string reverse $gamma]]
binary scan $gamma s gamma
set gamma [expr $gamma & $mask]

set epsilon [binary format b* [string reverse $epsilon]]
binary scan $epsilon s epsilon
set epsilon [expr $epsilon & $mask]

puts [format %04X $gamma]
puts [format %04X $epsilon]
puts [expr $gamma * $epsilon]

