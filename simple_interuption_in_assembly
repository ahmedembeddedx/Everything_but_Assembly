[org 0x100]

jmp start

line1: dw "Hi, you pressed a                "
line2: dw "Hi, you pressed b                "
line3: dw "Hi, you entered wrong credentials"

clearscn:
	push es
	push ax
	push cx
	push di
	
	mov ax, 0xb800
	mov es, ax
	xor di, di
	mov ax, 0x0720
	mov cx, 2000
	cld 
	rep stosw
	
	
	pop di
	pop cx
	pop ax
	pop es
	ret

add_intruption:
	mov ah, 0
	int 0x16
	ret
setup:
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x0E
	mov dx, 0x0A10
	mov cx, 33
	push cs 
	pop es 
	ret
	
start:
	call add_intruption
	call clearscn
	call add_intruption
	cmp ah, 0x1E
	je i1
	cmp ah, 0x30
	je i2
	jmp i3
	i1:
		call setup
		mov bp, line1
		jmp i4
	i2:
		call setup
		mov bp, line2
		jmp i4
	i3:
		call setup
		mov bp, line3
		jmp i4
	i4:
		int 0x10



mov ax, 0x4C00
int 0x21
