set depth 0
set horiz 0
set aim 0

proc forward { amount } {
    global aim depth horiz
    incr horiz $amount
    incr depth [expr $aim * $amount]
}

proc up { amount } {
    global aim
    incr aim -$amount
}

proc down { amount } {
    global aim
    incr aim $amount
}

source input.txt
#source example.txt

puts $depth
puts $horiz
puts [expr $depth * $horiz]
