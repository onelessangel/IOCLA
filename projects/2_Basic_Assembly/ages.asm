%define SIZEOF_DWORD 4

; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .data
    present_date:
        istruc my_date
            at my_date.day,   dw 0
            at my_date.month, dw 0
            at my_date.year,  dd 0
        iend


section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE

    ; copies current date in present_date variable
    mov ax, [esi + my_date.day]
    mov [present_date + my_date.day], ax
    mov ax, [esi + my_date.month]
    mov [present_date + my_date.month], ax
    mov eax, [esi + my_date.year]
    mov [present_date + my_date.year], eax

    xor eax, eax    ; stores age
    xor ebx, ebx    ; counter

dates_vector_iteration:
    jmp compute_age

; adds new age in all_ages vector and loops
populate_result_vector:
    mov [ecx + ebx * SIZEOF_DWORD], eax     ; stores age in all_ages vector

    ; increases counter and loops if necessary
    inc ebx
    cmp ebx, edx
    jl dates_vector_iteration

    jmp out

; computes age for each given element
compute_age:
    ; stores in eax the difference between the current year and the given year
    mov eax, [present_date + my_date.year]
    sub eax, [edi + my_date_size * ebx + my_date.year]

    ; if the years' difference is 0 the person is too young or it is not a valid date
    cmp eax, 0
    je populate_result_vector

    push eax

    ; compares given month and current month
    mov ax, [present_date + my_date.month]
    cmp [edi + my_date_size * ebx + my_date.month], ax
    pop eax
    jg age_is_less
    je compare_day

    jmp populate_result_vector

; substracts 1 from the current age
age_is_less:
    dec eax
    jmp populate_result_vector

; compares given day and current day
compare_day:
    push eax
    mov ax, [present_date + my_date.day]
    cmp [edi + my_date_size * ebx + my_date.day], ax
    pop eax
    jg age_is_less
    jmp populate_result_vector

out:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
