set input 4054460802532B12FEE8B180213B19FA5AA77601C010E4EC2571A9EDFE356C7008E7B141898C1F4E50DA7438C011D005E4F6E727B738FC40180CB3ED802323A8C3FED8C4E8844297D88C578C26008E004373BCA6B1C1C99945423798025800D0CFF7DC199C9094E35980253FB50A00D4C401B87104A0C8002171CE31C41201062C01393AE2F5BCF7B6E969F3C553F2F0A10091F2D719C00CD0401A8FB1C6340803308A0947B30056803361006615C468E4200E47E8411D26697FC3F91740094E164DFA0453F46899015002A6E39F3B9802B800D04A24CC763EDBB4AFF923A96ED4BDC01F87329FA491E08180253A4DE0084C5B7F5B978CC410012F9CFA84C93900A5135BD739835F00540010F8BF1D22A0803706E0A47B3009A587E7D5E4D3A59B4C00E9567300AE791E0DCA3C4A32CDBDC4830056639D57C00D4C401C8791162380021108E26C6D991D10082549218CDC671479A97233D43993D70056663FAC630CB44D2E380592FB93C4F40CA7D1A60FE64348039CE0069E5F565697D59424B92AF246AC065DB01812805AD901552004FDB801E200738016403CC000DD2E0053801E600700091A801ED20065E60071801A800AEB00151316450014388010B86105E13980350423F447200436164688A4001E0488AC90FCDF31074929452E7612B151803A200EC398670E8401B82D04E31880390463446520040A44AA71C25653B6F2FE80124C9FF18EDFCA109275A140289CDF7B3AEEB0C954F4B5FC7CD2623E859726FB6E57DA499EA77B6B68E0401D996D9C4292A881803926FB26232A133598A118023400FA4ADADD5A97CEEC0D37696FC0E6009D002A937B459BDA3CC7FFD65200F2E531581AD80230326E11F52DFAEAAA11DCC01091D8BE0039B296AB9CE5B576130053001529BE38CDF1D22C100509298B9950020B309B3098C002F419100226DC

set example0 D2FE28

proc hex2bin { hex } {
    set bits [binary format H* $hex]
    binary scan $bits B* bitChrs
    return $bitChrs
}

proc b2n { bits } {
    set bits [string reverse $bits]
    set n 0
    for { set i 0 } { $i < [string length $bits] } { incr i } {
        incr n [expr int(pow(2, $i)) * [string index $bits $i]]
    }
    return $n
}

proc decodeHeader { bitChrs } {
    set version [b2n [string range $bitChrs 0 2]]
    set typeId [b2n [string range $bitChrs 3 5]]
    set rest [string range $bitChrs 6 end]
    return [list $version $typeId $rest]
}

proc pullBits { bits n } {
    set prefix [string range $bits 0 [expr $n - 1]]
    set suffix [string range $bits $n end]
    return [list $prefix $suffix]
}

set versionSum 0

set opstack [list]
set bits [hex2bin $example0]
set bits [hex2bin $input]
while { [string length $bits] > 0 } {
    lassign [decodeHeader $bits] version typeId bits

    incr versionSum $version

    if { $typeId == 4 } {
        # constant
        set constBits ""
        lassign [pullBits $bits 1] continuation bits
        while { $continuation == 1 } {
            lassign [pullBits $bits 4] num bits
            set constBits "$constBits$num" 
            lassign [pullBits $bits 1] continuation bits
        }
        # pull final 4 bit sequence
        lassign [pullBits $bits 4] num bits
        set constBits "$constBits$num" 
        puts "$constBits -> [b2n $constBits]"
    } else {
        # operator
        lassign [pullBits $bits 1] typeLengthId bits
        
        if { $typeLengthId == 0 } {
            # 15 bit total length
            lassign [pullBits $bits 15] typeLengthId bits
        } else {
            # 11 bit number of packets
            lassign [pullBits $bits 11] typeLengthId bits
        }
    }
}

puts $versionSum
