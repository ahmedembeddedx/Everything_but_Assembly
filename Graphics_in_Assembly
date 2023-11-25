[org 0x0100]
jmp start
w equ 50 ; width offset
x1 equ 50 ; starting x coordinate of line
y1 equ 100 ; starting y coordinate of line
x2 equ 100
y2 equ 50
c equ 0 ; color


start:
	mov ah, 0
	mov al, 13h
	int 10h
	
	mov ah,00	
	int 16h
	mov cx, 200
	mov ax, 0
l5:
	push 319
	push 0
	push ax
	push 67
	mov di, 0
	call print_line
	add ax, 1
	loop l5	


	push 45
	push 149
	push 22
	push 42
	mov di, 1
	call print_line
	
	push 45
	push 103
	push 70
	push 42
	mov di, -1
	call print_line
	
	push 92
	push 103
	push 70
	push 42
	mov di, 0
	call print_line
	
	
	mov cx, 46
	mov ax, 70
l3:
	push 1
	push 118
	push ax
	push c
	mov di, 0
	call print_line
	push 1
	push 179
	push ax
	push c
	mov di, 0
	call print_line
	
	add ax, 1
	loop l3	
	
	
	push 319
	push 0
	push 116
	push c
	mov di, 0
	call print_line
	
	push 10
	push 162
	push 90
	push c
	mov di, 0
	call print_line
	
	push 10
	push 144
	push 90
	push c
	mov di, 0
	call print_line
	
	mov cx, 25
	mov ax, 90
l1:
	push 10
	push 144
	push ax
	push c
	mov di, 0
	call print_line
	add ax, 1
	loop l1
	
	
	mov cx, 10
	mov ax, 90
l2:
	push 10
	push 125
	push ax
	push 9
	mov di, 0
	call print_line
	push 10
	push 162
	push ax
	push 9
	mov di, 0
	call print_line
	add ax, 1
	loop l2
	
	mov cx, 25
	mov ax, 100
l4:
	push 12
	push 20
	push ax
	push 4
	mov di, 0
	call print_line
	push 8
	push 278
	push ax
	push 4
	mov di, 0
	call print_line
	
	
	add ax, 1
	loop l4		
	
	push 80
	push 175
	push 116
	push c
	mov di, 1
	call print_line
	
	push 80
	push 45
	push 198
	push c
	mov di, -1
	call print_line
	
	
	push 20
	push 284
	push 90
	push 10
	mov di, 1
	call print_line
	
	push 20
	push 284
	push 80
	push 10
	mov di, 1
	call print_line
	
	push 20
	push 264
	push 102
	push 10
	mov di, -1
	call print_line
	
	push 20
	push 264
	push 112
	push 10
	mov di, -1
	call print_line
	
	push 40
	push 264
	push 102
	push 10
	mov di, 0
	call print_line
	
	
	push 40
	push 264
	push 112
	push 10
	mov di, 0
	call print_line	
	
	mov cx, 10
	mov ax, 10
	mov bx, 35
	mov dx, 80
	mov si, 10
	call print_circle
	
	
	mov cx, 10
	mov ax, 10
	mov bx, 20
	mov dx, 60
	mov si, 45
	call print_circle
	
	
	mov cx, 10
	mov ax, 10
	mov bx, 10
	mov dx, 80
	mov si, 10
	call print_circle
	
	
	mov cx, 13
	mov ax, 10
	mov bx, 250
	mov dx, 20
	mov si, 42
	call print_circle
	
	mov cx, 8
	mov ax, 10
	mov bx, 250
	mov dx, 28
	mov si, 40
	call print_circle
	
	
	mov cx, 8
	mov ax, 10
	mov bx, 50
	mov dx, 140
	mov si, 9
	call print_circle
	
	jmp end

print_circle:

	push cx
	
	l6:
	push ax
	push bx
	push dx
	push si
	mov di, 0
	call print_line
	add ax, 2
	sub bx, 1
	add dx, 1
	loop l6
	
	pop cx
	push cx
	
	l7:
	push ax
	push bx
	push dx
	push si
	mov di, 0
	call print_line
	
	add dx, 1
	loop l7
	
	pop cx
	
	l8:
	push ax
	push bx
	push dx
	push si
	mov di, 0
	call print_line
	sub ax, 2
	add bx, 1
	add dx, 1
	loop l8
	
	
	

	ret
	
print_line:
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
	add dx, di
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

end:
mov ah,00
int 16h
mov ax, 0x4c00
int 0x21
