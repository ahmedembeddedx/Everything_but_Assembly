[org 0x100]
jmp start

ctr: db 0
PIN: dw 52413
lowbound: db 5, 2, 4, 1, 3
upbound: db 9, 5, 8, 4, 6



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
	
delay:
	push cx
	mov cx, 100
	delay_loop1:
	push cx
	mov cx, 0xffff
	delay_loop2:
	loop delay_loop2
	pop cx
	loop delay_loop1
	pop cx
	ret
		
	
print_triangle:
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push di
	
	mov ax, 0xb800
	mov es, ax
	
	mov di, [bp+4]
	mov cx, 10
	mov ax, 0x07B2
	
	rep stosw
	mov cx, 9
	sub di, 10*2
	add di, 160
	rep stosw
	mov cx, 8
	sub di, 9*2
	add di, 160
	rep stosw
	mov cx, 7
	sub di, 8*2
	add di, 160
	rep stosw
	mov cx, 6
	sub di, 7*2
	add di, 160
	rep stosw
	mov cx, 5
	sub di, 6*2
	add di, 160
	rep stosw
	mov cx, 4
	sub di, 5*2
	add di, 160
	rep stosw
	mov cx, 3
	sub di, 4*2
	add di, 160
	rep stosw
	mov cx, 2
	sub di, 3*2
	add di, 160
	rep stosw
	mov cx, 1
	sub di, 1*4
	add di, 160
	rep stosw
	
	pop di
	pop cx
	pop ax
	pop es
	pop bp
	ret 2
	
start:
	call clearscn
	push 200
	call print_triangle
	call delay
	call clearscn
	push 2114
	call print_triangle
	call delay
	call clearscn
	push 1548
	call print_triangle
	



mov ax, 0x4c00
int 0x21
