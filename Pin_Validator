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

Validate_PIN:
	push bp
	mov bp, sp
	push es
	push bx
	push cx
	push dx
	push di
	push si
	
	mov ax, 0xb800
	mov es, ax
	mov ax, [bp+4]
	mov bx, 10
	mov cx, 0

nextdigit:	
	mov dx, 0
	div bx
	push dx
	inc cx
	cmp ax, 0
	jnz nextdigit
	mov di, 0
	cmp cx, 5
	mov ax, 1
	je nextpos
	
nextpos:
	pop dx
	mov ax, dx

	cmp dl, byte[lowbound+si]
	jae chk1
	jmp continue
return1:	
	cmp dl, byte[upbound+si]
	jbe chk2
	jmp continue
chk1:	
	add byte[ctr], 1
	jmp return1
chk2:	
	add byte[ctr], 1
	jmp continue

	
continue:	
	mov dx, ax
	add si, 1
	mov dh, 0x07
	add dl, 0x30
	mov [es:di], dx
	add di, 2
	loop nextpos
	
	
	cmp byte[ctr], 10
	je valid
	jmp invalid

valid: 
	mov ax, 0x0759
	add di, 2
	mov [es:di], ax
	jmp done
	
invalid: 
	mov ax, 0x074E
	add di, 2
	mov [es:di], ax
	jmp done
	
	
done:	
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop es
	pop bp
	ret 2
	
	
	
start:
	call clearscn

	mov ax, 12345
	push ax
	call clearscn
	call Validate_PIN
	call delay
	mov ax, 52413
	push ax
	call clearscn
	call Validate_PIN
	call delay
	mov ax, 64538
	push ax
	call clearscn
	call Validate_PIN
	call delay
	mov ax, 11111
	push ax
	call clearscn
	call Validate_PIN
	
	

	



mov ax, 0x4c00
int 0x21
