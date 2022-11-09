format ELF64

public print_char64
public print_char32
public print_number
public print_string
public print_line

include "str.inc" ;extrn length_string

section '.bss' writeable 
    bss_char rb 1 ;резервируем область памяти размером 1 байт для записи одного символа в виде байта

section '.print_char64' executable
;input: rax = char
;outout: void
    print_char64:
        push rax
        ;системный вызов для 64битной архитектуры
        mov rax, 1 ;write
        mov rdi, 1 ;вместо rbx как было в 32бит, rdi как stdout
        mov rsi, rsp ;rsp хранит указатель на последнее значение в стэке, когда мы помещаем в стэк значение rax, то rsp указывает на него
        ;далее перемещали значение в rsi, это как rcx для 32бит
        mov rdx, 1 ;сюда кладём количество символов
        syscall ;тут хз, что сказать видимо типа вызов
        ;
        pop rax ;забираем из стэка
        ret

section '.print_char32' executable
;input: rax = char
;output: void
    print_char32:
        push rax
        push rbx
        push rcx
        push rdx

        ;mov [bss_char], rax; из rax, в котором лежит символ заносим в память, но так не выйдет, так как rax хранит 64 бита, а не 8 бит
        mov [bss_char], al; но al содержится в rax, поэтому это сработает, ведь символ записывается в самую младшую часть регистра
        mov rax, 4 ;write
        mov rbx, 1
        mov rcx, bss_char
        mov rdx, 1
        int 0x80

        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

section '.print_number' executable
    print_number:
        push rax
        push rbx
        push rcx
        push rdx 
        xor rcx, rcx ;задействуем для инкремента
        .next_iter:
            cmp rax, 0 ;сравниваем с нулём
            je .print_iter ;je выполняется если результат cmp выдаёт ,что сравниваемые числа равны
            mov rbx, 10
            xor rdx, rdx ;чистим мусор из rdx
            div rbx ;div уже ориентирован на rax как на числитель (видимо это из-за cmp), результат заносится в rdx
            add rdx, '0' ;(*) добавляем символ нуля
            push rdx
            inc rcx
            jmp .next_iter
        .print_iter: ;он должен брать значение и выводить на экран
            cmp rcx, 0
            je .close
            pop rax
            call print_char32
            dec rcx
            jmp .print_iter
        .close:
            pop rdx
            pop rcx
            pop rbx
            pop rax    
            ret   

section '.print_string' executable ;executable для исполнения
    ;он должен принимать данные message из регистра rax, то есть input: rax = message
    ;ничего не возвращает
    print_string:
        push rax ;сохраняем
        push rbx
        push rcx
        push rdx
        mov rcx, rax ;в rax было изначально записано сообщение
        call length_string ;этот метод записывает длину в rax
        mov rdx, rax ; записываем длину из rax в rdx
        mov rax, 4 ;interrupt
        mov rbx, 1
        int 0x80
        pop rdx ;вынимаем из стека по порядку обратному тому, по которому вкладывали
        pop rcx
        pop rbx
        pop rax
        ret ;при вызове возвращаемся обратно в вызывющий код, чтобы процедура дальше вниз не пошла(*)

;input: void
;output: void
section '.print_line' executable
    print_line:
    push rax
    mov rax, 0xa
    call print_char32
    pop rax
    ret