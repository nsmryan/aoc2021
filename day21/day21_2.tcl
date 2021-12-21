
proc solve {} {
    set outcomes [list]
    for { set roll1 1 } { $roll1 < 4 } { incr roll1 } {
        for { set roll2 1 } { $roll2 < 4 } { incr roll2 } {
            for { set roll3 1 } { $roll3 < 4 } { incr roll3 } {
                #lappend outcomes [expr $roll1 + $roll2 + $roll3]
                dict incr outcomes [expr $roll1 + $roll2 + $roll3] 
            }
        }
    }

    #set scoreMap [list [list 4 0 8 0] 1]
    set scoreMap [list [list 10 0 6 0] 1]

    set p1wins 0
    set p2wins 0

    while { [dict size $scoreMap] > 0 } {
        puts "[dict size $scoreMap] p1wins $p1wins p2wins $p2wins"

        set newMap [list]
        dict for { state count } $scoreMap {
            lassign $state p1 p1score p2 p2score

            dict for { p1outcome outcomeCount1 } $outcomes {
                set newp1 [expr $p1 + $p1outcome]
                while { $newp1 > 10 } {
                    set newp1 [expr $newp1 - 10]
                }
                set newp1score [expr $p1score + $newp1]
                if { $newp1score >= 21 } {
                    incr p1wins [expr $count * $outcomeCount1]
                    continue
                }

                dict for { p2outcome outcomeCount2 } $outcomes {
                    set newp2 [expr $p2 + $p2outcome]
                    while { $newp2 > 10 } {
                        set newp2 [expr $newp2 - 10]
                    }
                    set newp2score [expr $p2score + $newp2]
                    if { $newp2score >= 21 } {
                        incr p2wins [expr $count * $outcomeCount1 * $outcomeCount2]
                        continue
                    }

                    set newState [list $newp1 $newp1score $newp2 $newp2score]
                    dict incr newMap $newState [expr $count * $outcomeCount1 * $outcomeCount2]
                }
            }
        }

        set scoreMap $newMap
    }

    puts "final p1wins $p1wins p2wins $p2wins"
    puts [expr max($p1wins, $p2wins)]
}

solve
