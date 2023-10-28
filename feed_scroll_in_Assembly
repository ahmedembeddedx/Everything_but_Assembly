[org 0x0100]

jmp start


myname: dw "Name: Ahmed Abdullah ", '0'
roll: dw "Roll: 22L-7503 ", '0'
sect: dw "Section: BDS-3A1 ", '0'
CGPA: dw "GPA: 2.57 ", '0'
intrests: dw "Cricket, Game Development, Data ", '0'


clrscrn:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es

	mov cx, 2000
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x07B1
	mov di, 0

	cld
	rep stosw 
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
delay:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	
	mov cx, 10
	mov di, 0

	l1: 
		mov dx, 0xFFFF
		l2: 
			dec dx
			jnz l2
	loop l1
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
		
	
scrollup:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov ax, 80
	mul byte [bp+4]
	mov si, ax
	push si
	shl si, 1
	mov cx, 2000
	sub cx, ax
	mov ax, 0xb800
	mov es, ax
	mov ds, ax
	mov di, 0
	
	cld 
	rep movsw
	mov ax, 0x0720
	pop cx
	rep stosw
	
exit1:
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
		
printstr:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push si
	push di
	push es

	mov di, [bp+4]
	mov cx, 0xffff
	mov al, 0
	repne scasb
	mov ax, 0xffff
	sub ax, cx
	dec ax
	
	mov cx, ax
	mov ax, 0xb800
	mov es, ax
	mov ah, 0x07
	mov di, dx
	mov si, 0
	mov si, [bp+4]
	sub cx, 1
	
	cld
	l3:
		lodsb
		stosw
	loop l3

exit2:
	pop es
	pop di
	pop si
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2

start:
	
	call clrscrn
	mov dx, 1810
	mov ax, roll
	push ax
	call printstr
	
	mov dx, 1970
	mov ax, myname
	push ax
	call printstr
	
	mov dx, 2130
	mov ax, sect
	push ax
	call printstr
	
	mov dx, 2290
	mov ax, CGPA
	push ax
	call printstr
	
	mov dx, 2450
	mov ax, intrests
	push ax
	call printstr
	
	
	mov cx, 10
l4:
	mov ax, 1
	push ax
	call delay
	call scrollup
	loop l4
	
	mov ax, 0x4c00
	int 0x21
