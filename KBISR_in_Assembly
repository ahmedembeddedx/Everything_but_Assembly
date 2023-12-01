[org 0x0100]
jmp start
oldisr: dd 0

s: dw 14
name:   dw "Ahmed         "
prompt: dw "Enter Name:   "

kbisr: 
	push ax
	push es
	mov ax, 0xb800
	mov es, ax
	in al, 0x60
	cmp al, 0x2a
	jne nextcmp
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x07
	mov dx, 0x0A0A
	mov cx, 14
	push cs 
	pop es 
	mov bp, name
	int 0x10 
	jmp exit
	nextcmp: 
		cmp al, 0xaa
		jne nomatch
		call clrscreen
		jmp exit
		
	nomatch: 
		pop es
		pop ax
		jmp far [cs:oldisr]
	exit: 
		mov al, 0x20
		out 0x20, al
		pop es
		pop ax
		iret
clrscreen:
	pusha
	
	mov ax, 0xb800
	mov es, ax
	xor di, di
	mov ax, 0x0720
	mov cx, 2000
	cld 
	rep stosw
	
	popa
	ret
	
get_input:
	

	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x07
	mov dx, 0x0A00
	mov cx, 14
	push cs 
	pop es 
	mov bp, prompt
	int 0x10 
	
	
	push 0xb800
	pop es
	
	mov bx, name
	mov si, 0
	mov di, 1626
	l1:
		mov ah, 0
		int 0x16
		cmp ah, 28
		je exit_ 

		mov byte[bx+si], al
		mov byte[es:di], al
		mov byte[es:di+1], 0x07	
		add di, 2
		
		inc si
		cmp si, 14
		jbe l1
			
	exit_:
	ret
	
	
	
	
start: 
	call clrscreen
	call get_input
	call clrscreen
	xor ax, ax
	mov es, ax
	mov ax, [es:9*4]
	mov [oldisr], ax
	mov ax, [es:9*4+2]
	mov [oldisr+2], ax
	cli
	mov word [es:9*4], kbisr
	mov [es:9*4+2], cs
	sti
	mov dx, start
	add dx, 15
	mov cl, 4
	shr dx, cl

mov ax, 0x3100
int 0x21 
