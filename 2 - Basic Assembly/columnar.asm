%define SIZEOF_DWORD 4

section .data
    extern len_cheie, len_haystack
    no_rows dd 0
    row_counter dd 0

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE

    xor eax, eax
    xor edx, edx

    ; computes the following division: len_haystack / len_cheie
    mov eax, dword [len_haystack]
    mov edx, dword [len_haystack + 4]
    mov ecx, dword [len_cheie]
    div ecx

    ; if the division has a remainder, the number of rows is incremented
    cmp edx, 0
    jg increase_no_rows
    jmp put_no_rows

; increments the number of rows of the matrix
increase_no_rows:
    inc eax

; copies the number of rows of the matrix in the corresponding variable
put_no_rows:
    mov [no_rows], eax

    ; sets the counters to 0
    xor eax, eax    ; used to iterate through ciphertext
    xor ecx, ecx    ; used to iterate through key

; checks if the position is within the boundaries of the haystack
check_boundary:
    ; puts EAX on stack for future use
    push eax

    ; computes position and saves it in EAX
    mov eax, [len_cheie]
    mul dword [row_counter]
    add eax, [edi + ecx * SIZEOF_DWORD]

    ; checks if the position is within the string's boundaries
    cmp eax, [len_haystack]

    ; EAX resumes its role as a counter
    pop eax

    ; if the position is outside the boundary, the counters are increased
    jge increase_counters

; puts the correct character in ciphertext
create_ciphertext:
    lea ebx, [ebx + eax]

    ; stores current index in EDX
    mov edx, eax

    ; puts the correct character in ciphertext[i]
    mov eax, [len_cheie]
    mul dword [row_counter]
    add eax, [edi + ecx * SIZEOF_DWORD]
    mov al, byte [esi + eax]
    mov byte [ebx + edx], al

    ; EAX resumes its role as counter
    mov eax, edx

    ; increases the EAX counter
    inc eax
    cmp eax, [len_haystack] 
    jl increase_counters
    jmp out

; increases the row_counter and the ECX counter
increase_counters:
    ; increases row_counter
    inc dword [row_counter]
    mov edx, [row_counter]
    cmp edx, [no_rows]
    jl check_boundary

    ; if the row_counter is greater than the number of rows in the matrix
    ; sets it to 0
    mov dword [row_counter], 0
    
    ; increases the ECX counter
    inc ecx
    cmp ecx, [len_cheie]
    jl check_boundary

; exits
out:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY