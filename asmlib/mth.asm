format ELF64

;делаем процедуры видимыми
public gcd
public fibonacci
public factorial

;input: rax = number1, rbx = number2
;output: rax=result
section '.gcd' executable
    gcd:
        push rbx
        push rdx
        .next_iter:
            cmp rbx, 0
            je .close

            xor rdx,rdx ;готовим к записи остатка от деления
            div rbx ;делим rax на rbx
            push rbx ;сохраняем делитель
            mov rbx, rdx ;записываем остаток в rbx
            pop rax ;записываем предыдущий делитель в делимое

            jmp .next_iter
        .close:
            pop rdx
            pop rbx
            ret

;input: rax = n
;output: rax = n_fibonacci
section '.fibonacci' executable
    fibonacci:
        push rbx
        push rcx
        mov rcx, 0
        mov rbx, 1
        cmp rax, 0
        je .next_step
        .next_iter:
            cmp rax, 1
            jle .close
            push rbx
            add rbx, rcx
            pop rcx
            dec rax
            jmp .next_iter
        .next_step:
            xor rbx, rbx    
        .close:
            mov rax, rbx
            pop rcx
            pop rbx
            ret
;input: rax = n
;output: rax = n_factorial
section '.factorial' executable
    factorial:
    push rbx
        mov rbx, rax
        mov rax, 1
        .next_iter:
            cmp rbx, 1
            jle .close ;jle - меньше или равно
            mul rbx
            dec rbx
            jmp .next_iter
        .close:   
            pop rbx 
            ret