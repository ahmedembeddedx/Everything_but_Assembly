[org 0x0100]
jmp start
w equ 50 ; width offset
x1 equ 50 ; starting x coordinate of line
y1 equ 100 ; starting y coordinate of line
x2 equ 100
y2 equ 50
c equ 60 ; color


start:
		
	mov ah, 0
	mov al, 13h
	int 10h
	push w
	push x1
	push y1
	push c
	call print_line_f
	push w
	push y1
	push x1
	push c
	call print_line_f
	push w	
	push x1
	push y1
	push c
	call print_line_b
	push w
	push 100
	push 150
	push c
	call print_line_b
	
	
	jmp end
	
	
print_line_b:
	push bp
	mov bp, sp

	push ax
	push bx
	push cx
	push dx


	mov cx, [bp+8]
	mov dx, [bp+6]
	add dx, 2
	mov al, [bp+4]
u1: 
	dec	dx
	mov ah, 0x0C ; put pixel
	int 10h
	inc cx
	mov bx, [bp+8]
	add bx, [bp+10]
	cmp cx, bx
	jbe u1
	
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8	

print_line_f:
	push bp
	mov bp, sp

	push ax
	push bx
	push cx
	push dx


	mov cx, [bp+8]
	mov dx, [bp+6]
	mov al, [bp+4]
u2: 
	inc dx
	mov ah, 0x0C ; put pixel
	int 10h
	inc cx
	mov bx, [bp+8]
	add bx, [bp+10]
	cmp cx, bx
	jbe u2
	
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8
	
end:
mov ah,00
int 16h
mov ax, 0x4c00
int 0x21
22L-7503_Q2.asm
