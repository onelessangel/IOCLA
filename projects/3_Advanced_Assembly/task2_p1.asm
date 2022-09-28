section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; [ebp +  8] -> a	; retained in ebx
;; [ebp + 12] -> b	; retained in ecx
;
;; calculate least common multiple for 2 numbers, a and b
cmmmc:
	push ebp
	push esp
	pop ebp

	push dword [ebp + 8]
	push dword [ebp + 12]
	pop ecx	; retains b
	pop ebx	; retains a

; computes cmmdc
cmmdc:
	cmp ebx, ecx
	je compute_cmmmc
	jg substract_ecx

substract_ebx:
	sub ecx, ebx
	jmp continue_loop

substract_ecx:
	sub ebx, ecx

continue_loop:
	jmp cmmdc


; computes cmmmc
compute_cmmmc:
	; eax = a * b / cmmdc(a, b)
	push dword [ebp + 8]
	pop eax
	mul dword [ebp + 12]
	div ebx

out:
	push ebp
	pop esp
	pop ebp
	ret
