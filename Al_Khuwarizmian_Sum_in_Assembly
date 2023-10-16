
[org 0x100]

jmp start

n: db 0

binary_ones:
	mov bx, ax
	mov dl, 0
	mov cx, 16

	l1:
		shr bx, 1
		jc incc
		dec cx
		cmp cx, 0
		je endit
		jmp l1

	incc:
		add dl, 1
		dec cx
		cmp cx, 0
		jne l1

	endit:
		mov [n], dl
		ret 2
	
	
khwarizmi_sum:	
	mov dl, byte[n]
	inc dl
	mov bx, 0

	l2:
		mov ax, 0
		dec dl
		mov al, dl
		mul al
		add bx, ax
		cmp dl, 0
		jne l2

	end:
		ret 2		


start:
	mov ax, 0x4195
	call binary_ones
	call khwarizmi_sum
	

terminate:
	mov ax, 0x4C00
	int 0x21
