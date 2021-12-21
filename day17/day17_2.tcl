# NOTE a better solution might be:
# for each reasonable x velocity, map that velocity
# to a set of times where it intersects with the target
# area.
# Do the same for y velocities.
#
# Then, for each pair of x and y velocity, 

# example
lassign [list 20 30 -10 -5] xStart xEnd yStart yEnd

# input
lassign [list 201 230 -99 -65] xStart xEnd yStart yEnd


proc stepX { x vx } {
    set newVx 0
    if { $vx < 0 } {
        set newVx [expr $vx + 1]
    } elseif { $vx > 0 } {
        set newVx [expr $vx - 1]
    }

    return [list [expr $x + $vx] [expr $newVx]]
}

proc stepY { y vy } {
    set newVY [expr $vy - 1]
    return [list [expr $y + $vy] [expr $newVY]]
}

proc simple { startX endX startY endY } {
    set maxY 0
    set count 0

    for { set nextVx -200 } { $nextVx <= 300 } { incr nextVx } {
        for { set nextVy -200 } { $nextVy <= 300 } { incr nextVy } {
            set x 0
            set y 0
            set vx $nextVx
            set vy $nextVy

            set highY 0
            set hitTarget 0
            while { $x < $endX && $y > $startY } {
                lassign [stepX $x $vx] x vx
                lassign [stepY $y $vy] y vy

                set highY [expr max($highY, $y)]

                if { $x >= $startX && $x <= $endX && $y >= $startY && $y <= $endY } {
                    set hitTarget 1
                    break
                }
            }

            if { $hitTarget } {
                incr count
            }
        }
    }

    return $count
}

puts [simple $xStart $xEnd $yStart $yEnd]
#puts [solve $xStart $xEnd $yStart $yEnd]

