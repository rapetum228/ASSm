format ELF64
public _start 

include "mth.inc" ;extrn gcd
include "fmt.inc" ;extrn print_number extrn print_line
include "sys.inc" ;extrn exit


section '.text' executable
    _start:
        mov rax, 46
        mov rbx, 20
        call gcd
        call print_number
        call print_line
        call exit
        