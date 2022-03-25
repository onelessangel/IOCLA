;; defining constants, you can use these as immediate values in your code
CACHE_LINES     EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS     EQU 3
TAG_BITS        EQU 29 ; 32 - OFSSET_BITS

section .data
    tag dd 0
    offset dd 0

section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE

    ; cache is retained in ESI
    mov esi, [ebp + 16]

    ; saves address in offset variable
    mov [offset], edx
 
    ; computes tag and saves it in corresponding variable
    shr edx, 3
    mov [tag], edx

    ; EDX is used as mask
    mov edx, 1
    shl edx, OFFSET_BITS
    sub edx, 1

    ; computes AND between address and mask to get offset
    and [offset], edx

    ; EAX will indicate the line in the cache matrix
    xor eax, eax

; iterates through the tags vector and searches for the tag
tags_iteration:
    ; compares tags[i] with the tag
    mov edx, [ebx + eax]
    cmp [tag], edx

    ; if found, it's a CACHE HIT situation
    je cache_hit
    
    ; continues loop
    inc eax
    cmp eax, CACHE_LINES
    jl tags_iteration

    ;; it's a CACHE MISS situation

    ; puts tag in tags[to_replace]
    mov edx, [tag]
    mov [ebx + edi], edx

    ; sets loop counter to 8 (the number of bytes to be written)
    mov ecx, CACHE_LINE_SIZE

    ; EDX contains the first octet
    shl edx, 3

    ; ESI retains the address of cache[to_replace]
    lea esi, [esi + edi * CACHE_LINE_SIZE]

; puts the 8 consecutive bytes on the cache[to_replace] line
populate_cache_line:
    ; puts the x octet in cache[to_replace][x]
    push edx
    mov edx, [edx]
    mov [esi], edx
    pop edx

    ; moves to the next address
    inc edx
    inc esi
    loop populate_cache_line

    ; EAX will have the to_replace value
    mov eax, edi

; puts correct element in reg
cache_hit:
    ; gets correct element from cache
    mov edx, [offset]
    mov esi, [ebp + 16]
    lea esi, [esi + eax * CACHE_LINE_SIZE]
    lea esi, [esi + edx]
    mov edx, [esi]

    ; puts the element in reg
    mov eax, [ebp + 8]
    mov [eax], edx

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


