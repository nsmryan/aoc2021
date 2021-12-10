package require struct::set

set input input.txt
set input example.txt

set lines [split [read [open $input]] "\n"]
set lines {{acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf}}

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

set guesses [list]
foreach name $segmentnames {
    dict set guesses $name $segmentnames
}

proc enlist { str } {
    set chrs [list]
    for { set i 0 } { $i < [string length $str] } { incr i } { 
        lappend chrs [string index $str $i]
    }
    return $chrs
}

set oneslength [llength [dict get $digitsegments 1]]
set fourslength [llength [dict get $digitsegments 4]]
set sevenslength [llength [dict get $digitsegments 7]]
set eigthslength [llength [dict get $digitsegments 8]]

foreach line $lines {
    lassign [split $line "|"] digits answers

    set mapping $guesses

    foreach digit $digits {
        set seglist [enlist $digit]

        if { [string length $digit] == $oneslength } {
            foreach seg [dict get $digitsegments 1] {
                dict set mapping $seg [struct::set intersect $seglist [dict get $mapping $seg]]
            }
        } elseif { [string length $digit] == $fourslength } {
            foreach seg [dict get $digitsegments 4] {
                dict set mapping $seg [struct::set intersect $seglist [dict get $mapping $seg]]
            }
        } elseif { [string length $digit] == $sevenslength } {
            foreach seg [dict get $digitsegments 7] {
                dict set mapping $seg [struct::set intersect $seglist [dict get $mapping $seg]]
            }
        } elseif { [string length $digit] == $eigthslength } {
            foreach seg [dict get $digitsegments 8] {
                dict set mapping $seg [struct::set intersect $seglist [dict get $mapping $seg]]
            }
        }
    }

    puts $mapping
}

