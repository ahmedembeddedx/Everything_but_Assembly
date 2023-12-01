[org 0x0100]
jmp start

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
mov_char:
	push 0xb800
	pop es
	
	
	l5:
		mov di, 0
		l1:
			mov word[es:di-2], 0x0720
			mov word[es:di], 0x072A
			push 2
			call delay
			add di, 2			
			cmp di, 160
			jne l1
		add di, 158
		l2:
			mov word[es:di-160], 0x0720
			mov word[es:di], 0x072A
			push 2
			call delay
			add di, 160
			cmp di, 4000
			jb l2
		mov di, 3998
		l3:
			mov word[es:di+2], 0x0720
			mov word[es:di], 0x072A
			push 2
			call delay
			sub di, 2			
			cmp di, 3840
			jae l3
		mov di, 3840
		l4:
			mov word[es:di], 0x072A
			push 2
			call delay
			sub di, 160
			mov word[es:di+160], 0x0720
			cmp di, 0
			ja l4	
	jmp l5
	

	ret
	
delay:
	push bp
	mov bp, sp
	push cx
	push dx
	push di
	
	mov cx, [bp+4]
	mov di, 0

	dl1: 
		mov dx, 0x8888
		dl2: 
			dec dx
			jnz dl2
	loop dl1
	
	pop di
	pop dx
	pop cx
	pop bp
	ret 2	
	
start: 
	call clrscreen
	call mov_char

mov ax, 0x3100
int 0x21 
