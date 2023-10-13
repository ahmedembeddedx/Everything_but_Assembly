[org 0x0100]

jmp start

	iv1: dw 5
	iv2: dw 6
	iv3: dw 7
	iv4: dw 8
	ov1: dw 0
	ov2: dw 0
	ov3: dw 0

this_function_does_some_work:
	push bp
	mov bp, sp
	sub sp, 2*5 ;5 word spc
	;(Local Variables);
	push ax
	push bx
	push si
	push di
	push cx

	mov ax, [bp+4];iv1
	mov bx, [bp+6];iv2
	mov cx, [bp+8];iv3
	mov di, [bp+10];iv4

		;(some logic applied on ax, bx, cx);

	mov [bp-2], ax;Local Variable 1
	mov [bp-4], bx;Local Variable 2
	mov [bp-6], cx;Local Variable 3
	mov [bp-8], bx;Local Variable 4
	mov [bp-10], cx;Local Variable 5

	pop cx
	pop di
	pop si
	pop bx
	pop ax
	mov sp, bp
	pop bp
	ret 6


start:
	mov ax, iv1 
	push ax 
	mov ax, iv2 
	push ax
	mov ax, iv3 
	push ax
	mov ax, iv4 
	push ax
	mov ax, ov1 
	push ax
	mov ax, ov2 
	push ax
	mov ax, ov3 
	push ax

	call this_function_does_some_work

	pop ax
	mov [ov1], ax
	pop ax
	mov [ov2], ax
	pop ax
	mov [ov3], ax

mov ax, 0x4C00
int 0x21
