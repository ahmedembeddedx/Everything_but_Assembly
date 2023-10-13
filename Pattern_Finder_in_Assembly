[org 0x0100]

jmp start
	n: dw 0
	k: dw 0
;si will carry the result
findarr:
	push ax
	push bx
	push cx
	push dx
	push di
	
l1:
	add dx, 1
	mov cx, ax
	shl ax, 1
	mov si, 0
	mov di, 0
	inc word[k]
	cmp dx, 16
	jae not_found
l2:
	add si, 1
	shl cx, 1
	rcl di, 1
	cmp si, word[n]
	jb l2
	cmp di, bx
	je found
	jmp l1


not_found:
	mov si, -1
	jmp return

found:
	mov si, word[k]
	jmp return

return:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret

start:
	mov ax, 0x2525
	mov bx, 0x3
	mov word[n], 4
	call findarr



mov ax, 0x4C00
int 0x21
