section .data
	delim db " ,.", 10, 0

section .text
	extern strtok
	extern strlen
	extern strcmp
	extern qsort
	global get_words
	global compare_func
	global sort

;; int compare_func(char **word1, char **word2)
compare_func:
	enter 0, 0

	; store len of word1 in ebx
	mov ebx, [ebp + 8]  ; word1
	mov ebx, [ebx]
	push ebx
	call strlen
	add esp, 4
	mov ebx, eax

	; store len of word2 in ecx
	mov ecx, [ebp + 12] ; word2
	mov ecx, [ecx]
	push ecx
	call strlen
	add esp, 4
	mov ecx, eax

	; compares words by length
	cmp ebx, ecx
	jl word1_before_word2
	jg word1_after_word2


	mov ebx, [ebp + 8]  ; word1
	mov ebx, [ebx]

	mov ecx, [ebp + 12] ; word2
	mov ecx, [ecx]

	; compares words lexicographically
	push ecx
	push ebx
	call strcmp
	add esp, 8

	jmp out2    

word1_before_word2:
	mov eax, -1
	jmp out2

word1_after_word2:
	mov eax, 1

out2:
	leave
	ret


;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru sortarea cuvintelor 
;  dupa lungime si apoi lexicografic
sort:
	enter 0, 0

	push compare_func
	push dword [ebp + 16]
	push dword [ebp + 12]
	push dword [ebp + 8]    
	call qsort
	add esp, 16

	leave
	ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
	enter 0, 0

	mov esi, [ebp + 8]  ; string
	mov edi, [ebp + 12] ; words array
	mov ecx, [ebp + 16] ; number of words

	push delim
	push esi
	call strtok
	add esp, 8

break_into_tokens:
	cmp eax, 0
	je out

	mov [edi], eax  ; move in the words array the current token

	add edi, 4      ; go to the next element in the words array

	push delim
	push 0
	call strtok		; eax now contains the next token
	add esp, 8

	loop break_into_tokens

out:
	leave
	ret
