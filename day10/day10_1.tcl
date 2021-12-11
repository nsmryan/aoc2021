
set input example.txt
set input input.txt

set lines [split [read [open $input]] "\n"]

set closing [list ")" "(" "}" "{" "]" "\[" ">" "<"]
set openers [list "(" "\[" "{" "<"]
set scoremap [list ")" 3 "]" 57 "}" 1197 ">" 25137]

set score 0
foreach line $lines {
    set opens ""

    for { set i 0 } { $i < [string length $line] } { incr i } {
        set chr [string index $line $i]
        
        if { [lsearch -exact $openers $chr] >= 0 } {
            lappend opens $chr
        } else {
            set openchr [dict get $closing $chr]
            if { ![string equal [lindex $opens end] $openchr] } {
                incr score [dict get $scoremap $chr]
                break
            }
            set opens [lrange $opens 0 end-1]
        }
    }

    # skip incomplete
    if { [llength $opens] > 0 } {
        continue
    }
}

puts $score
