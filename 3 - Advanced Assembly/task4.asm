section .text
	extern strlen
	extern atoi
	global expression
	global term
	global factor


	; word1 -- part of string BEFORE the separator
	; word2 -- pard of string AFTER the separator


; `int factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
	push    ebp
	mov     ebp, esp

	mov eax, [ebp + 8]	; eax retains the string

	push eax
	call strlen
	add esp, 4

	mov ecx, eax		; ecx retains the string length
	mov eax, [ebp + 8]	; eax retains the string

	; if string starts with paranthesis it's an expression
	cmp byte [eax], "("
	je is_exp
	jne is_number

is_exp:
	; puts NULL in place of ")"
	add eax, ecx
	dec eax
	mov byte [eax], 0

	; moves at the beginning of the string, on first char after "("
	sub eax, ecx
	add eax, 2

	; local variable containing 0
	push dword 0
	lea ecx, [esp]

	; expression(string, 0)
	push ecx
	push eax
	call expression
	add esp, 8

	add esp, 4	; pop 0 from stack

	jmp factor_out

is_number:
	; the string is a number
	mov eax, [ebp + 8]	; eax contains string

	; computes atoi(string)
	push eax
	call atoi
	add esp, 4

	jmp factor_out

factor_out:
	leave
	ret

; `int term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
	push    ebp
	mov     ebp, esp

	mov eax, [ebp + 8]	; eax retains the string

	; computes strlen(string)
	push eax
	call strlen
	add esp, 4

	push eax

	mov ecx, eax		; ecx retains the string length
	mov eax, [ebp + 8]	; eax retains the string

	; moves to last char of string
	add eax, ecx
	dec eax

	xor ebx, ebx	; counts chars until separator is found
	xor edx, edx	; paranthesis counter

term_loop:
	; loops through the string's chars from end to beginning
	inc ebx

	cmp byte [eax], "*"
	je term_check_par_counter

	cmp byte [eax], "/"
	je term_check_par_counter

	cmp byte [eax], "("
	je term_inc_par_counter

	cmp byte [eax], ")"
	je term_dec_par_counter

continue_term_loop:
	dec eax
	loop term_loop

	jmp term_no_separator

term_inc_par_counter:
	; increases paranthesis counter
	inc edx
	jmp continue_term_loop

term_dec_par_counter:
	; decreases paranthesis counter
	dec edx
	jmp continue_term_loop

term_check_par_counter:
	; checks if the paranthesis counter is 0
	cmp edx, 0
	je term_separator
	jmp continue_term_loop

term_separator:
	; * or / has been found

	pop ecx	; strlen

	; saves on stack the separator (+ or -)
	xor edx, edx
	mov dl, byte [eax]
	push edx

	inc eax

	push eax ; word2

	sub ecx, ebx ; index separator in string

	; ebx retains word1
	mov ebx, [ebp + 8]
	add ebx, ecx
	mov byte [ebx], 0
	sub ebx, ecx

	; local variable containing 0
	push dword 0
	lea ecx, [esp]

	; term(word1, 0)
	push ecx
	push ebx
	call term
	add esp, 8

	add esp, 4	; pop 0 from stack

	; ebx retains word2
	pop ebx

	push eax	; result word1

	; local variable containing 0
	push dword 0
	lea ecx, [esp]

	; factor(word2, 0)
	push ecx
	push ebx
	call factor
	add esp, 8

	add esp, 4	; pop 0 from stack

	mov ebx, eax	; ebx retains result word2
	pop eax			; eax retains result word1

	; perform correct operation
	pop edx
	cmp dl, "*"
	je mul
	jne div

mul:
	; computes multiplication
	mul ebx
	jmp term_out

div:
	; computes division
	cdq
	idiv ebx
	jmp term_out

term_no_separator:
	; expression doesn't contains a separator (* or /)

	mov eax, [ebp + 8]	; eax retains string

	; local variable containing 0
	push dword 0
	lea ecx, [esp]

	; factor(string, 0)
	push ecx
	push eax
	call factor
	add esp, 8

	add esp, 4	; pop 0 from stack

term_out:
	leave
	ret

; `int expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
	push    ebp
	mov     ebp, esp

	mov eax, [ebp + 8]	; eax retains the string

	; computes strlen(string)
	push eax
	call strlen
	add esp, 4

	push eax

	mov ecx, eax		; ecx retains the string length
	mov eax, [ebp + 8]	; eax retains the string

	; moves to last char of string
	add eax, ecx
	dec eax

	xor ebx, ebx	; counts chars until separator is found
	xor edx, edx	; paranthesis counter

exp_loop:
	; loops through the string's chars from end to beginning
	inc ebx

	cmp byte [eax], "+"
	je exp_check_par_counter

	cmp byte [eax], "-"
	je exp_check_par_counter

	cmp byte [eax], "("
	je exp_inc_par_counter

	cmp byte [eax], ")"
	je exp_dec_par_counter

continue_exp_loop:
	dec eax
	loop exp_loop

	jmp exp_no_separator

exp_inc_par_counter:
	; increases paranthesis counter
	inc edx
	jmp continue_exp_loop

exp_dec_par_counter:
	; decreases paranthesis counter
	dec edx
	jmp continue_exp_loop

exp_check_par_counter:
	; checks if the paranthesis counter is 0
	cmp edx, 0
	je exp_separator
	jmp continue_exp_loop

exp_separator:
	; + or - has been found

	pop ecx	; strlen

	; saves on stack the separator (+ or -)
	xor edx, edx
	mov dl, byte [eax]
	push edx

	inc eax

	push eax ; word2

	sub ecx, ebx ; index separator in string

	; ebx retains word1
	mov ebx, [ebp + 8]
	add ebx, ecx
	mov byte [ebx], 0
	sub ebx, ecx

	; local variable containing 0
	push dword 0
	lea ecx, [esp]

	; expression(word1, 0)
	push ecx
	push ebx
	call expression
	add esp, 8

	add esp, 4	; pop 0 from stack

	; ebx retains word2
	pop ebx

	push eax	; result word1

	; local variable containing 0
	push dword 0
	lea ecx, [esp]

	; term(word2, 0)
	push ecx
	push ebx
	call term
	add esp, 8

	add esp, 4	; pop 0 from stack

	mov ebx, eax	; ebx retains result word2
	pop eax			; eax retains result word1

	; perform correct operation
	pop edx
	cmp dl, "+"
	je sum
	jne diff

sum:
	; computes sum
	add eax, ebx
	jmp exp_out

diff:
	; computes difference
	sub eax, ebx
	jmp exp_out

exp_no_separator:
	; expression doesn't contains a separator (+ or -)

	mov eax, [ebp + 8]	; eax retains string

	; local variable containing 0
	push dword 0
	lea ecx, [esp]

	; term(string, 0)
	push ecx
	push eax
	call term
	add esp, 8

	add esp, 4	; pop 0 from stack

exp_out:
	leave
	ret
