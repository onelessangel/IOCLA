section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	xor edx, edx	; array index counter
	xor ecx, ecx	; counter to help iterate through array for each element

array_iteration:
	; set esi to retain first element in array
	mov esi, [ebp + 12]

	; checks if the end of the array has been reached
	; if it has, it means all elements have been linked
	cmp edx, [ebp  + 8]
	je reset

	mov ecx, [ebp + 8]
	dec ecx

	; ebx retains the value of the next node
	mov ebx, [ebp + 12]
	mov ebx, [ebx + edx * 8]	; value of current node
	inc ebx						; value to be put in "next" of current node

link_node:
	; checks if current node is the one searched for
	cmp ebx, [esi]
	je set_next

	; if it's not the searched node, moves to the next element in the array
	add esi, 8

	dec ecx
	cmp ecx, 0
	jge link_node
	jmp continue_iteration

set_next:
	; the "next" node has been found

	; eax becomes pointer to the "next" field of current element
	mov eax, [ebp + 12]
	lea eax, [eax + edx * 8 + 4]
	
	; sets "next" of current element
	; moves in the "next" field of current element the address of the "next" node
	mov [eax], esi

continue_iteration:
	; moves to the next element in the array 
	inc edx
	jmp array_iteration

reset:
	; resets ecx and esi
	mov ecx, [ebp + 8]
	mov esi, [ebp + 12]

find_head:
	; finds head of linked list
	cmp dword [esi], 1
	je set_head
	add esi, 8
	loop find_head

set_head:
	lea eax, [esi]

out:
	leave
	ret
