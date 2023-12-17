[org 0x0100]
jmp start

String1: db "Mr. Ali, Usman, & Anwar! Doing what???? want to travel????", 0
String2: db "                                                          ", 0


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
	
find_size:
	push bp
	mov bp, sp
	push es
	push ax
	push si
	push di
	push ds
	pop es
	mov di, [bp+4]
	mov cx, 0xffff 
	mov al, 0
	repne scasb
	mov ax, 0xffff 
	sub ax, cx
	mov cx, ax 
	pop di
	pop si
	pop ax
	pop es
	pop bp
	ret 2
	
	
remove_punctuation:
	push ax
	push bx
	push cx
	push dx
	
	mov di, 0
	mov si, 0
	push String1
	call find_size
	
	mov di, String1
	mov si, String2
	
	l1:
		mov al, [di]
		
		cmp al, 65
		jb here
		cmp al, 122
		ja here
		
		mov [si], al
		inc si
		
		here:
		inc di
		loop l1

	end_:
		
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
start:
	call clrscreen
	call remove_punctuation


	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x07
	mov dx, 0x0000
	mov cx, 59
	push cs 
	pop es 
	mov bp, String2
	int 0x10

mov ax, 0x4C00
int 0x21 
