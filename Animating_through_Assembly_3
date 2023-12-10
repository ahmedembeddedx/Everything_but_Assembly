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
	
taskTwo:
	push 0xb800
	pop es
	mov di, 158
	mov si, 3200
	mov cx, 0
	
	mov word[es:di], 0x072A
	mov word[es:si], 0x072A

	
	l1:
		push 10
		call delay
		mov word[es:di], 0x0720
		mov word[es:si], 0x0720
		
		add di, 152
		sub si, 152
		
		mov word[es:di], 0x072A
		mov word[es:si], 0x072A
		add cx, 1
		
		cmp cx, 19
		jb l1
		mov cx, 0
		xchg si, di
		jmp l1
	
	

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
	call taskTwo

mov ax, 0x3100
int 0x21 
