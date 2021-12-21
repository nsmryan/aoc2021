
set p1 4
set p2 8

set p1 10
set p2 6


set p1score 0
set p2score 0

set numRolls 0
set diePos 1

proc rollDie { die } {
    incr die
    if { $die > 100 } {
        set die 1
    }
    return $die
}

while { $p1score < 1000 && $p2score < 1000 } {
    puts "$p1score $p2score"

    set roll $diePos
    set diePos [rollDie $diePos]
    incr roll $diePos
    set diePos [rollDie $diePos]
    incr roll $diePos

    set p1 [expr $p1 + $roll]
    while { $p1 > 10 } {
        set p1 [expr $p1 - 10]
    }
    incr p1score $p1
    incr numRolls 3

    if { $p1score >= 1000 } {
        break
    }

    set diePos [rollDie $diePos]
    set roll $diePos
    set diePos [rollDie $diePos]
    incr roll $diePos
    set diePos [rollDie $diePos]
    incr roll $diePos
    set diePos [rollDie $diePos]
    set p2 [expr $p2 + $roll]
    while { $p2 > 10 } {
        set p2 [expr $p2 - 10]
    }
    incr p2score $p2

    incr numRolls 3
}

set loserScore $p1score
if { $p1score > $p2score } {
    set loserScore $p2score
}
puts "numRolls $numRolls"
puts "p1score $p1score"
puts "p2score $p2score"
puts [expr $loserScore * $numRolls]

