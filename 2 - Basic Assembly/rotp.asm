section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE

    xor eax, eax
    xor ebx, ebx

create_ciphertext:
    ; retains in EAX the [i] index and stores it on the stack for future use
    mov eax, [ebp + 20]
    sub eax, ecx
    push eax

    ; retains in EBX the [len - i - 1] index
    mov ebx, [ebp + 20]
    sub ebx, eax
    sub ebx, 1

    mov al, byte [esi + eax]    ; AL retains plaintext[i]
    mov bl, byte [edi + ebx]    ; BL retains key[len - i - 1]
    
    xor al, bl                  ; computes xor
    mov bl, al                  ; saves the xor result in BL
    pop eax                     ; restores the [i] index value in EAX
    mov byte [edx + eax], bl    ; puts result in ciphertext[i]

    loop create_ciphertext

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY