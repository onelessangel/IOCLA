section .text
	global par

;; int par(int str_length, char* str)
;
;; [ebp +  8] -> str_length	; retained in ecx
;; [ebp + 12] -> str		; retained in esi
;
; check for balanced brackets in an expression
par:
	push ebp
	push esp
	pop ebp

	push dword [ebp + 8]
	pop ecx

	push dword [ebp + 12]
	pop esi

	xor eax, eax

check:
	cmp byte [esi], "("
	jne is_closed_par
	jmp is_open_par
is_open_par:
	; "(" gets pushed on stack
	push "("
	jmp complete_check
is_closed_par:
	; checks if stack is empty
	cmp ebp, esp
	je out

	; checks if previous element was an ")"
	; if it's not, the bracketing is wrong
	pop ebx		; prev element on stack
	cmp ebx, "("
	jne out
complete_check:
	; moves to next element in string
	inc esi
	loop check

final_check_of_stack:
	; checks if stack is empty
	cmp ebp, esp
	jne out

	inc eax

out:
	push ebp
	pop esp
	pop ebp
	ret
