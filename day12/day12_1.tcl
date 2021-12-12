package require struct::graph


set input example.txt
set input example2.txt
set input example3.txt
set input example4.txt
set input input.txt

set lines [read [open $input]]
puts $lines

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

# remove small caves with only one way in and out
foreach arc [cave arcs] {
    lassign [cave arc nodes $arc] start end
    if { [string is lower $start] && [string is lower $end] } {
        if { ([cave node degree -in $end] == 1) && ([cave node degree -out $end] == 1) } {
            cave node delete $end
        }
    }
}

set pending [list [list start start]]
set fullpaths [list]

while { [llength $pending] > 0 } {
    lassign [lindex $pending end] path seen
    set pending [lrange $pending 0 end-1]

    set node [lindex $path end]

    if { $node == "end" } {
        lappend fullpaths $path
        continue
    }

    set newpaths [list]
    foreach arc [cave arcs] {
        lassign [cave arc nodes $arc] start end
        # check if we have found an arc going out of the current node,
        # where the end node is not marked as seen (visited lowercase cave)
        if { $start == $node && [lsearch $seen $end] == -1 } {
            set nextpath $path
            lappend nextpath $end

            set nextseen $seen
            if { [string is lower $end] } {
                lappend nextseen $end
            }

            lappend newpaths [list $nextpath $nextseen]
        }
    }

    foreach newpath $newpaths {
        lappend pending $newpath
    }

    if { [llength $pending] > 100 } {
        break
    }
}

#foreach path $fullpaths {
#    puts $path
#}
puts [llength $fullpaths]
