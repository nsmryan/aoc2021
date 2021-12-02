
set depth 0
set horiz 0

proc forward { amount } {
    global horiz
    incr horiz $amount
}

proc up { amount } {
    global depth
    incr depth $amount
}

proc down { amount } {
    global depth
    incr depth -$amount
}

source input.txt

puts $depth
puts $horiz
puts [expr $depth * $horiz]
