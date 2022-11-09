format ELF64

public string_to_number
public number_to_string
public length_string


;logic:
;у каждого символа отнимаем '0', затем каждый такой результат умножаем на 10 в какой-то степени
;Input: "752"; '7' - '0' = 7, '5' - '0' = 5, '2' - '0' = 2 => 2*10^0 + 5*10^1 + 7*10^2
;input: rax=string
;output: rax=number
section '.string_to_number' executable
    string_to_number:
        push rbx
        push rcx
        push rdx 
        xor rbx, rbx
        xor rcx, rcx
        .next_iter:
            cmp [rax+rbx], byte 0
            je .next_step
            mov cl, [rax+rbx]
            sub cl, '0'
            push rcx ;не можем cl, так как стек 64битный
            inc rbx
            jmp .next_iter
        .next_step:
            mov rcx, 1
            xor rax,rax
        .to_number:
            cmp rbx, 0
            je .close
            pop rdx
            imul rdx, rcx
            imul rcx, 10
            add rax, rdx
            dec rbx
            jmp .to_number    
        .close:
            pop rdx
            pop rcx
            pop rbx
            ret


;input: rax = number, rbx = buffer, rcx = buffer_size
section '.number_to_string' executable
    number_to_string:
        push rax
        push rbx
        push rcx
        push rdx 
        push rsi
        mov rsi, rcx ;записываем buffer_size в rsi
        dec rsi
        xor rcx, rcx ;обнулим и задействуем для инкремента
        .next_iter:
            push rbx ;нужно сохранить указатель на буффер
            mov rbx, 10
            xor rdx, rdx ;чистим мусор из rdx
            div rbx ;div уже ориентирован на rax как на числитель, результат заносится в rdx
            pop rbx ;забираем указатель на буфер
            add rdx, '0' ;добавляем символ нуля к остатку от деления
            push rdx ;записываем в стек символ остатка от деления
            inc rcx
            cmp rax, 0 ;сравниваем с нулём
            je .next_step ;je выполняется если результат cmp выдаёт ,что сравниваемые числа равны 
            jmp .next_iter

        .next_step: ;выполнится когда все символы будут в стеке
            mov rdx, rcx ;записываем значение инкремента в rdx (то есть число символов)
            xor rcx, rcx ;обнуляем rcx и будем сравнивать его с макс значением буфера и стека

        .to_string: ;он должен брать значение и выводить на экран
            cmp rcx, rsi ;сравниение с максимальным значением стека (а может длины буфера?)
            je .pop_iter
            cmp rcx, rdx ;сравниение с максимальным значением буфера
            je .null_char
            pop rax ;в стеке лежали остатки от деления, записываем их в rax
            mov [rbx+rcx], rax ;перемещаем по указателю rbx со смещением rcx, которое каждый раз увеличивается помещаем значение из стека (rax)
            inc rcx ;
            jmp .to_string

        .pop_iter: ;выгружает значение из стека
            cmp rcx, rdx
            je .close
            pop rax
            inc rcx
            jmp .pop_iter
        .null_char:
            mov rsi, rdx    
        .close:
            mov [rbx+rsi], byte 0
            pop rsi
            pop rdx
            pop rcx
            pop rbx
            pop rax    
            ret   

section '.length_string' executable
    ;input: rax = message
    ;output: rax = length_message
    length_string:
        push rbx ;(**) кладём значение rbx в стэк, то есть сохраняем
        xor rbx,rbx ;обнуление регистра, аналогично - mov rbx, 0 но об этом позже
        ;цикл, перебирающий сообщение пока указатель не дойдёт до терминатора 0, с "." начинаются внутренние процедуры
        .next_iter:
            cmp [rax+rbx], byte 0 ; cmp сравнивает операнды 
            ;во-первых rax содержит адрес на начало строки сообщения, если укажем просто rax, то он возьмёт просто первый байт (символ)
            ;с +rbx будет смещение на обпределённое количество байт, byte 0 означает перемещение по одному байту для сравнения с 0
            ;если не указать "byte", то смещение будет не определено
            ;[] означают разыменование - взятие значения по адресу в памяти, в rаx не значение а адрес
            je .close ; если байт равен нулю, то закрываем процедуру 
            inc rbx ; добавление единицы к rbx, чтобы смещаться по массиву регистра на один байт выше (аналог i++)
            jmp .next_iter ;снова вызываем процедуру (типа делаем цикл)
        .close:
            mov rax, rbx ;записываем полученное значение в rax (см. output перед процедурой)
            pop rbx ;вынимаем из стека
            ret