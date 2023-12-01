[org 0x100]

jmp start

line1: dw "Hi, I'm Ahmed          "
line2: dw "I'm Depressed          "
line3: dw "I'm from FAST          "
line4: dw "My Roll No. is 22L-7503"

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
	push ax
	mov ah, 0
	int 0x16
	pop ax
	ret

start:
	call clearscn
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x07
	mov dx, 0x0A1E
	mov cx, 23
	push cs 
	pop es 
	mov bp, line1
	int 0x10
	
	call add_intruption
	
	mov dx, 0x0C1E
	push cs 
	pop es 
	mov bp, line2
	int 0x10
	
	call add_intruption	
	
	mov dx, 0x0E1E
	push cs 
	pop es 
	mov bp, line3
	int 0x10
	
	call add_intruption
	
	mov dx, 0x101E
	push cs 
	pop es 
	mov bp, line4
	int 0x10
	




mov ax, 0x4C00
int 0x21
