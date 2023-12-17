[org 0x0100]
jmp start

String1: dw "I am Mr X", 0
String2: dw "         ", 0


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
	
reverse:
	push String1
	call find_size
	mov si, cx
	sub si, 1
	mov di, 0
	l1:
	mov ax, [String1+si]
	mov [String2+di], ax
	dec si
	inc di
	loop l1
	ret		
	
start:
	call clrscreen
	call reverse
	
	
	push String1
	call find_size
	
	
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x07
	mov dx, 0x0000
	push cs 
	pop es 
	mov bp, String1
	int 0x10

	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x07
	mov dx, 0x0200
	push cs 
	pop es 
	mov bp, String2
	int 0x10

mov ax, 0x4C00
int 0x21
