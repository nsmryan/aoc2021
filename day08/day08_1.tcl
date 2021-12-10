set input example.txt
set input input.txt

set lines [split [read [open $input]] "\n"]

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

set ones 0
set fours 0
set sevens 0
set eigths 0

foreach line $lines {
    lassign [split $line "|"] digits answers

    foreach digit $digits {
        if { [string length $digit] == $oneslength } {
            set one $digit
        } elseif { [string length $digit] == $fourslength } {
            set four $digit
        } elseif { [string length $digit] == $sevenslength } {
            set seven $digit
        } elseif { [string length $digit] == $eigthslength } {
            set eigth $digit
        }
    }

    foreach answer $answers {
        if { [string length $answer] == $oneslength } {
            incr ones
        } elseif { [string length $answer] == $fourslength } {
            incr fours
        } elseif { [string length $answer] == $sevenslength } {
            incr sevens
        } elseif { [string length $answer] == $eigthslength } {
            incr eigths
        }
    }
}

puts $ones
puts $fours
puts $sevens
puts $eigths
puts [expr $ones + $fours + $sevens + $eigths]
