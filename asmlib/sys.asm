format ELF64

public exit

section '.exit' executable
    exit: 
        mov rax, 1 
        xor rbx,rbx ;mov rbx, 0
        int 0x80