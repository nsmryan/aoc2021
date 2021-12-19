#py(t) = t*(t*vy - (t + 1)/2 + 1)
#
#px(t) = (vx - t + 1) + px(t - 1)
#px(0) = 0
#
#vy = (2py(t) + t + 1) / t

# example
lassign [list 20 30 -10 -5] xStart xEnd yStart yEnd]

# input
lassign [list 201 230 -99 -65] xStart xEnd yStart yEnd]


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

proc solve { startX endX startY endY } {
    set results [list]

    set currentVx 1
    set maxY 0
    # break when we pass the target in 1 step
    while { $currentVx <= $endX } {
        puts "trying vx $currentVx"

        set x 0
        set t 0
        set vx $currentVx
        # run X forward for a given velocity
        while { $x <= $endX } {
            lassign [stepX $x $vx] x vx
            incr t
            puts "t = $t"

            # if we are in the target area, check y velocities
            if { $x >= $startX } {
                for { set y $startY } { $y <= $endY } { incr y } {
                    # vy = (2py(t) + t + 1) / t
                    set vy [expr 2 * $y + $t + 1]
                    set vy [expr -$vy]

                    puts "vy $vy"
                    set highY 0
                    for { set yt 0 } { $yt < $t } { incr yt } {
                        incr highY $vy
                        incr vy -1

                        if { $vy == 0 } {
                            break
                        }
                    }
                    puts "highY $highY"

                    set maxY [expr max($maxY, $highY)]
                }
            }

            # if vx is 0, we aren't going any further anyway
            if { $vx == 0 } {
                break
            }
        }

        incr currentVx
    }

    return $maxY
}

proc simple { startX endX startY endY } {
    set maxY 0

    for { set nextVx 1 } { $nextVx <= 250 } { incr nextVx } {
        for { set nextVy 1 } { $nextVy <= 250 } { incr nextVy } {
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
                }
            }

            if { $hitTarget } {
                set maxY [expr max($maxY, $highY)]
            }
        }
    }

    return $maxY
}

puts [simple $xStart $xEnd $yStart $yEnd]
#puts [solve $xStart $xEnd $yStart $yEnd]

