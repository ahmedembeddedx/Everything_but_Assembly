	[org 0x100]

jmp start
	message1: dw "This is Message 1"
	message2: dw "This is Message 2"
	message3: dw "This is Message 3"
	length: dw 17

clrscrn:
	mov cx, 2000
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x0720
	mov di, 0

	cld
	rep stosw 

	ret
printstr:
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di

	mov ax, 0xb800
	mov es, ax
	mov al, 80
	mul byte[bp+10]
	add ax, [bp+12]
	shl ax, 1
	mov di, ax

	mov si, [bp+6]
	mov cx, [bp+4]
	mov ah, [bp+8]


nextchar:
	mov al, [si]
	mov [es:di], ax
	add di, 2
	add si, 1
	loop nextchar

	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	ret 10

start:
	call clrscrn
	mov ax, 0
	push ax	
	mov ax, 0
	push ax 
	mov ax, 0xEE 
	push ax 
	mov ax, message3
	push ax 
	push word [length]
	call printstr 
        mov ax, 19
	push ax	
	mov ax, 2
	push ax 
	mov ax, 0xE7
	push ax 
	mov ax, message2
	push ax 
	push word [length]
	call printstr 
	mov ax, 4
	push ax	
	mov ax, 4
	push ax 
	mov ax, 0xDE 
	push ax 
	mov ax, message1
	push ax 
	push word [length]
	call printstr 



mov ax, 0x4c00
int 0x21
