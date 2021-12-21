package require struct::set

# part 1
set numIterations 2
# part 2
set numIterations 50

set input example.txt
set input input.txt

set lines [split [string trim [read [open $input]]] "\n"]

set map [lindex $lines 0]

set imageLines [lrange $lines 2 end]

set pixels [list]

for { set y 0 } { $y < [llength $imageLines] } { incr y } {
    set line [lindex $imageLines $y]
    for { set x 0 } { $x < [string length $line] } { incr x } {
        if { [string index $line $x] == "#" } {
            struct::set include pixels [list $x $y]
        }
    }
}

proc pixelValue { pixels x y } {
    if { [struct::set contains $pixels [list $x $y]] } {
        return 1
    }
    return 0
}

proc neighbors { x y } {
    set result [list]
    for { set dy 1 } { $dy >= -1 } { incr dy -1 } {
        for { set dx 1 } { $dx >= -1 } { incr dx -1 } {
            lappend result [list [expr $x + $dx] [expr $y + $dy]]
        }
    }
    return $result
}

proc printPixels { pixels } {
    set maxY 0
    set maxX 0
    set minY 0
    set minX 0
    foreach pair $pixels {
        lassign $pair x y
        set maxX [expr max($maxX, $x)]
        set maxY [expr max($maxY, $y)]
        set minX [expr min($minX, $x)]
        set minY [expr min($minY, $y)]
    }
    puts "range $maxX $maxY"
    set chrs ""
    for { set y $minY } { $y < $maxY } { incr y } {
        for { set x $minX } { $x < $maxX } { incr x } {
            if { [struct::set contains $pixels [list $x $y]] } {
                set chrs [string cat $chrs "#"]
            } else {
                set chrs [string cat $chrs "."]
            }
        }
        set chrs [string cat $chrs "\n"]
    }
    puts $chrs
}

set invert 0
set light "#"
set dark "."
for { set iter 0 } { $iter < $numIterations } { incr iter } {
    set newPixels [list]

    lassign [list $dark $light] light dark

    set activeLocations [list]

    foreach pixel $pixels {
        lassign $pixel x y

        foreach aroundXY [neighbors $x $y] {
            struct::set include activeLocations $aroundXY
        }
    }

    foreach aroundXY $activeLocations {
        lassign $aroundXY aroundX aroundY

        set mult 1
        set index 0
        foreach neighbor [neighbors $aroundX $aroundY] {
            lassign $neighbor nx ny
            incr index [expr $mult * ($invert ^ [pixelValue $pixels $nx $ny])]
            incr mult $mult
        }

        if { [string index $map $index] == $light } {
            struct::set include newPixels [list $nx $ny]
        }
    }

    set pixels $newPixels

    if { [string index $map 0] == "#" } {
        set invert [expr $invert ^ 1]
    }

    puts [struct::set size $pixels]
    #printPixels $pixels
}

puts [struct::set size $pixels]

