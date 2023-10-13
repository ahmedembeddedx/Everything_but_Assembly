[org 0x0100]

jmp start
array1: dw 6, 7,3, 9, 100, 5, 1, 50
lenArray1: dw 8

;code copied from book, mentioning it
swap: db 0 
bubblesort: 
	dec cx
	shl cx, 1  
mainloop: 
	mov si, 0
	mov byte [swap], 0  
innerloop: 
	mov ax, [bx+si]  
	cmp ax, [bx+si+2]  
	jbe noswap  
	 
	mov dx, [bx+si+2]  
	mov [bx+si], dx  
	mov [bx+si+2], ax  
	mov byte [swap], 1  
noswap: 
	add si, 2  
	cmp si, cx 
	jne innerloop  
 
	cmp byte [swap], 1  
	je mainloop 
	ret


; storing cx->median, bx->max, ax->min
statsOfArray:

	push bp
	mov bp, sp
	;creating 3 local variables to hold statsOfArray
	sub sp, 2*3
	push ax
	push bx
	push cx
	push dx
	;storing values in local variables
	call bubblesort
	mov ax, [array1]
	mov [bp-2], ax
	mov di, [lenArray1]
	mov ax, [array1+di]
	mov [bp-4], ax
	shl di, 1
	sub di, 2
	mov ax, [array1+di]
	mov [bp-6], ax
	
	;poping the normal registers
	pop dx
	pop cx
	pop bx
	pop ax
	;poping values of local variables in registers
	pop bx ;maximum
	pop cx ;median
	pop ax ;minimum
	pop dx
	ret

start:
	mov bx, array1 
	push bx
	mov cx, [lenArray1] 
	push cx
	call statsOfArray
	



mov ax, 0x4C00
int 0x21
