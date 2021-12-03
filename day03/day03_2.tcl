
proc mostcommonbit { nums pos } {
    set ones 0
    set zeros 0
    foreach num $nums {
        if { [string index $num $pos] == "1" } {
            incr ones
        } else {
            incr zeros
        }
    }
    if { $ones >= $zeros } {
        return 1
    } else {
        return 0
    }
}

proc leastcommonbit { nums pos } {
    set ones 0
    set zeros 0
    foreach num $nums {
        if { [string index $num $pos] == "1" } {
            incr ones
        } else {
            incr zeros
        }
    }

    if { $ones < $zeros } {
        return 1
    } else {
        return 0
    }
}

proc filterbybit { nums bit pos } {
    set newlist [list]
    foreach num $nums {
        if { [string index $num $pos] == $bit } {
            lappend newlist $num
        }
    }

    return $newlist
}

proc frombits { bits } {
    for { set i 0 } { $i < [expr 16 - [string length $bits]] } { incr i } {
        set bits "0$bits"
    }
    set bits [binary format b* [string reverse $bits]]
    binary scan $bits s bits
    set bits [expr $bits & 0x0FFFFFFF]
    return $bits
}

#set datafile example.txt
set datafile input.txt
set nums [read [open $datafile]]

set numbits [string length [lindex $nums 0]]

set oxylist $nums
for { set i 0 } { $i < $numbits } { incr i } {
    set mostcommon [mostcommonbit $oxylist $i]
    set oxylist [filterbybit $oxylist $mostcommon $i]
    if { [llength $oxylist] == 1 } {
        break
    }
}
set oxy $oxylist

set co2list $nums
for { set i 0 } { $i < $numbits } { incr i } {
    set leastcommon [leastcommonbit $co2list $i]
    set co2list [filterbybit $co2list $leastcommon $i]
    if { [llength $co2list] == 1 } {
        break
    }
}
set co2 $co2list

set oxy [frombits $oxy]
set co2 [frombits $co2]

puts [format %04X $oxy]
puts [format %04X $co2]
puts [expr $oxy * $co2]

