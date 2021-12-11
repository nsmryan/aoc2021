set input example.txt
set input input.txt

set lines [split [read [open $input]] "\n"]

set closing [list ")" "(" "}" "{" "]" "\[" ">" "<"]
set opening [lreverse $closing]
set openers [dict keys $opening]
set scoremap [list ")" 1 "]" 2 "}" 3 ">" 4]

set scores [list]
foreach line $lines {
    set opens ""

    for { set i 0 } { $i < [string length $line] } { incr i } {
        set chr [string index $line $i]
        
        if { [lsearch -exact $openers $chr] >= 0 } {
            lappend opens $chr
        } else {
            set openchr [dict get $closing $chr]
            if { ![string equal [lindex $opens end] $openchr] } {
                set opens ""
                break
            }
            set opens [lrange $opens 0 end-1]
        }
    }

    # incomplete, calculate score
    if { [llength $opens] > 0 } {
        set score 0

        while { [llength $opens] > 0 } {
            set endchr [lindex $opens end]
            set closechr [dict get $opening $endchr]
            set chrscore [dict get $scoremap $closechr]
            set score [expr ($score * 5) + $chrscore]
            set opens [lrange $opens 0 end-1]
        }

        lappend scores $score
    }
}

set scores [lsort -integer $scores]

puts [lindex $scores [expr [llength $scores] / 2]]

