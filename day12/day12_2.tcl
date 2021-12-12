package require struct::graph


set input example.txt
set input example2.txt
set input example3.txt
set input example4.txt
set input input.txt

set lines [read [open $input]]

catch {cave destroy}
struct::graph cave


foreach entry $lines {
    lassign [split $entry "-"] start end

    if { ![cave node exists $start] } {
        cave node insert $start
    }

    if { ![cave node exists $end] } {
        cave node insert $end
    }

    cave arc insert $start $end
    cave arc insert $end $start
}

# path, seen, smallcave name
set pending [list [list start start ""]]
set fullpaths [list]

while { [llength $pending] > 0 } {
    lassign [lindex $pending end] path seen smallcave
    set pending [lrange $pending 0 end-1]

    set node [lindex $path end]

    if { $node == "end" } {
        lappend fullpaths $path
        continue
    }

    set newpaths [list]
    foreach arc [cave arcs] {
        lassign [cave arc nodes $arc] start end

        if { $start != $node } {
            continue
        }

        set newsmallcave $smallcave
        if { [lsearch $seen $end] >= 0 } {
            if { $smallcave == "" && $end != "start" } {
                set newsmallcave $end
            } else {
                continue
            }
        }

        set nextpath $path
        lappend nextpath $end

        set nextseen $seen
        if { [string is lower $end] } {
            lappend nextseen $end
        }

        lappend newpaths [list $nextpath $nextseen $newsmallcave]
    }

    foreach newpath $newpaths {
        lappend pending $newpath
    }

    if { [llength $pending] > 10000 } {
        throw PENDINGTOOLARGE "There were [llength $pending] paths to check, which seems a bit much"
    }
}

#foreach path $fullpaths {
#    puts $path
#}
puts [llength $fullpaths]
