package require struct::set

set input example.txt
set input input.txt

set lines [split [string trim [read [open $input]]] "\n"]
#set lines {{acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf}}

set digitsegments { 
    0 { a b c e f g }
    1 { c f }
    2 { a c d e g }
    3 { a c d f g }
    4 { b c d f }
    5 { a b d f g }
    6 { a b d e f g }
    7 { a c f }
    8 { a b c d e f g }
    9 { a b c d f g }
}

set segmentnames { a b c d e f g }

set initialguesses [list]
foreach name $segmentnames {
    #dict set initialguesses $name $segmentnames
    dict set initialguesses $name [list]
}

proc enlist { str } {
    set chrs [list]
    for { set i 0 } { $i < [string length $str] } { incr i } { 
        lappend chrs [string index $str $i]
    }
    return $chrs
}

proc comp { a b } {
    if { [llength $a] < [llength $b] } {
        return -1
    } elseif { [llength $a] > [llength $b] } {
        return 1
    } else {
        return 0
    }
}

set total 0
foreach line $lines {
    lassign [split $line "|"] digits answers

    set mapping [list]
    set remaining [list]
    foreach digit $digits {
        set seglist [enlist $digit]
        if { [struct::set size $seglist] == 2 } {
            dict set mapping 1 $seglist
        } elseif { [struct::set size $seglist] == 7 } {
            dict set mapping 8 $seglist
        } elseif { [struct::set size $seglist] == 3 } {
            dict set mapping 7 $seglist
        } elseif { [struct::set size $seglist] == 4 } {
            dict set mapping 4 $seglist
        } else {
            lappend remaining $seglist
        }
    }

    set one [dict get $mapping 1]
    set four [dict get $mapping 4]
    set seven [dict get $mapping 7]
    set eigth [dict get $mapping 8]

    set remaining [lsort -decreasing -command comp $remaining]
    foreach remain $remaining {
        if { [llength $remain] == 6 } {
            if { [struct::set equal [struct::set intersect $four $remain] $four] } {
                dict set mapping 9 $remain
            } elseif { [struct::set equal [struct::set intersect $one $remain] $one] } {
                dict set mapping 0 $remain
            } else {
                dict set mapping 6 $remain
            }
        } elseif { [llength $remain] == 5 } {
            if { [struct::set size [struct::set intersect [dict get $mapping 9] $remain]] == 4 } {
                dict set mapping 2 $remain
            } elseif { [struct::set size [struct::set intersect $one $remain]] == 2 } {
                dict set mapping 3 $remain
            } else {
                dict set mapping 5 $remain
            }
        } else {
            throw INVALIDREMAIN "Segments $remain unexpected"
        }
    }

    if { [llength [dict keys $mapping]] != 10 } {
        throw INVALIDMAP "Mapping too short: $mapping, \n[lsort -integer [dict keys $mapping]]"
    }

    set decoded ""
    foreach answer $answers {
        dict for { num map } $mapping {
            if { [struct::set equal [enlist $answer] $map] } {
                set decoded "${decoded}$num"
                break
            }
        }
    }
    while { [string index $decoded 0] == "0" } {
        set decoded [string range $decoded 1 end]
    }
    incr total $decoded
}

puts $total

