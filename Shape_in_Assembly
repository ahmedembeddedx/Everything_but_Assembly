	[org 0x100]

jmp start


clrscrn:
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	
	mov cx, 2000
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x0720
	mov di, 0
	cld
	rep stosw 
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret

; will store coordinates from dh-->x, dl-->y, to dx single
calculate_coordinates:
	push ax
	push bx
	push cx
	push di
	push si
	mov bx, 0
	mov al, 80
	mul dl 			;ax<-4*80
	mov bl, dh 		;bx<-0002
	add ax, bx		;ax<-322
	shl ax, 1		;ax<-644
	mov dx, ax
	
	pop si
	pop di
	pop cx
	pop bx
	pop ax
	ret

print_ax_at_dx:
	push ax
	push dx
	push es
	push di
	
	call calculate_coordinates
	mov di, dx
	mov dx, 0xb800
	mov es, dx
	mov [es:di], ax

	pop di
	pop es
	pop dx
	pop ax
	ret
	
printrect:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push es
	push si
	push di
	
mov cx, word[bp+4]
mov ax, 0x072D
mov dx, 0
add dh, byte[bp+10]
add dl, byte[bp+8]
l1:
	add dh, 1
	call print_ax_at_dx
	dec cx
	jnz l1
	

mov cx, word[bp+4]
mov ax, 0x072D
mov dx, 0
add dh, byte[bp+10]
add dl, byte[bp+8]
add dl, byte[bp+6]
l2:
	add dh, 1
	call print_ax_at_dx
	dec cx
	jnz l2


mov cx, word[bp+6]
mov ax, 0x077C
mov dx, 0
add dh, byte[bp+10]
add dl, byte[bp+8]
l3:
	add dl, 1
	call print_ax_at_dx
	dec cx
	jnz l3

mov cx, word[bp+6]
mov ax, 0x077C
mov dx, 0
add dh, byte[bp+10]
add dh, byte[bp+4]

add dl, byte[bp+8]
l4:
	add dl, 1
	call print_ax_at_dx
	dec cx
	jnz l4


	pop di
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret

start:

	call clrscrn
	push 5   ;+10 x
	push 5  ;+8 y
	push 5  ;+6 length
	push 20  ;+4 width
	call printrect

mov ax, 0x4c00
int 0x21
