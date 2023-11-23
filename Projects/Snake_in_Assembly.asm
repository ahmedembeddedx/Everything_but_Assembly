[org 0x0100]
jmp start
buds: dw 20
dif:dw 0


tail: dw 0
head:dw 0
score: dw 0
dir: dw 0
on: dw 1
i1:db'   _____             _                                 __              /)',0 
i2:db'  / ____|           | |                    _______    /**>-<      .-"".L,""-.',0
i3:db' | (___  _ __   __ _| | _____          ___/ _____ \__/ /         ;           :',0
i4:db'  \___ \|  _ \ / _  | |/ / _ |        <____/     \____/          (           )',0
i5:db'  ____) | | | | (_| |   <  __/                                    :         ;' ,0
i6:db' |_____/|_| |_|\__,_|_|\_\___|                                     "..-"-.."',0
i7:db'    Press ARROW Keys to Play',0
i8:db'    Press Spacebar to Pause',0
i10:db'    Press R to Restart',0  
i11:db'Easy      Medium       Hard',0 
i12:db' Y  ',0
i13:db'(")',0
i14:db' \\ ',0
i15:db'  \\',0
i16:db'   ))',0
i17:db'  //',0
i18:db' //',0
i19:db' ((',0
i20:db' \\',0
i21:db'  \\',0
i22:db'   V',0    
ending: db'Game Over!   Restart    Quit',0
ending2:db'Restart    Quit',0
                                     
clrscr: 
	push ax
	push es
	push di
	push cx
	mov ax,0xb800
	mov es,ax
	xor di,di
	mov cx,2000
	mov ax,0x0720
	cld
	nextpos:
	rep stosw
	pop cx
	pop di
	pop es
	pop ax
	ret
setsnake:
	push ax
	push es
	push di
	push cx
	mov ax,0xb800
	mov es,ax
	mov di,2000
	mov [tail],di
	mov cx,[buds]
	add di,2
	mov ah,0x07
	mov al,0xB1
	addbox:	
		mov [es:di],ax
		add di,2
		loop addbox
	mov [head],di
	pop cx
	pop di
	pop es
	pop ax
	ret
moveright:
	push ax
	push es
	push di
	push si
	mov ax,0xb800
	mov es,ax

	mov di,word[head]
	cmp word[es:di+2],0x1720
	jne c1
	mov word[on],0
	jmp exitright

	c1:
	cmp word[es:di+2],0x07B1
	jne fdr
	mov word[on],0
	jmp exitright
	fdr:
	call updatetail
	cmp word[es:di+2],0x4020
	jne ngr
	inc word[score]
	mov cx,2
	call note
	mov word[es:di+4],0x07B1
	mov word[es:di+2],0x07B1
	add word[head],4

	call GenRandNum
	jmp exitright
	ngr:
	mov word[es:di+2],0x07B1
	mov word[es:di],0x07B1
	add word[head],2
	exitright:
	pop si
	pop di
	pop es
	pop ax
	call delay
	ret
moveleft:
	push ax
	push es
	push cx
	push di
	push si
	mov ax,0xb800
	mov es,ax
	mov di,word[head]
	cmp word[es:di-2],0x1720
	jne c2
	mov word[on],0
	jmp exitleft
	c2:
	cmp word[es:di-2],0x07B1
	jne fdl
	mov word[on],0
	jmp exitleft
	fdl:
	call updatetail
	cmp word[es:di-2],0x4020
	jne ngl
	inc word[score]
	mov cx,2
	call note
	mov word[es:di-4],0x07B1
	mov word[es:di-2],0x07B1
	sub word[head],4
	inc word[buds]
	call GenRandNum
	jmp exitleft
	ngl:
	mov word[es:di-2],0x07B1
	mov word[es:di],0x07B1
	sub word[head],2
	exitleft:
	
	pop si
	pop di
	pop cx
	pop es
	pop ax
	call delay
	ret
moveup:
	push ax
	push es
	push cx
	push di
	push si
	mov ax,0xb800
	mov es,ax
	mov di,word[head]
	
	cmp word[es:di-160],0x07B1
	jne fdu
	mov word[on],0
	jmp exitup
	fdu:
	mov si,di
	sub si,160
	cmp si,160
	jg upfd
	mov word[on],0
	jmp exitup
	upfd:
	call updatetail
	cmp word[es:di-160],0x4020
	jne ngu
	mov cx,2
	call note
	inc word[score]
	mov word[es:di-320],0x07B1
	mov word[es:di-160],0x07B1
	sub word[head],320
	call GenRandNum
	jmp exitup
	ngu:
	mov word[es:di-160],0x07B1
	mov word[es:di],0x07B1
	sub word[head],160
	exitup:
	
	pop si
	pop di
	pop cx
	pop es
	pop ax
	;call delay
	ret
movedown:
	push ax
	push es
	push cx
	push di
	push si
	mov ax,0xb800
	mov es,ax
	mov di,word[head]
	cmp word[es:di+160],0x07B1
	jne fdd
	mov word[on],0
	jmp exitdown
	fdd:
	mov si,di
	add si,160
	cmp si,3838
	jl dfd
	mov word[on],0
	jmp exitdown
	dfd:
	call updatetail
	cmp word[es:di+160],0x4020
	jne ngd
	mov cx,2
	call note
	inc word[score]
	mov word[es:di+160],0x07B1
	mov word[es:di+320],0x07B1
	add word[head],320
	call GenRandNum
	jmp exitdown
	ngd:
	mov word[es:di+160],0x07B1
	add word[head],160
	exitdown:
	pop si
	pop di
	pop cx
	pop es
	pop ax
	;call delay
	ret
		
updatetail:
	push ax
	push es
	push di
	mov ax,0xb800
	mov es,ax
	mov di,word[tail]
	cmp word[es:di+2],0x07B1
	je right
	cmp word[es:di+160],0x07B1
	je down
	cmp word[es:di-2],0x07B1
	je left
	cmp word[es:di-160],0x07B1
	jne exit
	up:
	mov word[es:di-160],0x8020
	sub word[tail],160
	jmp exit
	left:
	mov word[es:di-2],0x8020
	sub word[tail],2
	jmp exit
	right:
	mov word[es:di+2],0x8020
	add word[tail],2
	jmp exit
	down:
	mov word[es:di+160],0x8020
	add word[tail],160
	exit:
	pop di
	pop es
	pop ax
	ret


start:
    call clrscr
	call menu
    call setbckg
    call setsnake
    call GenRandNum
	mov word[dir],0
	mov word[score],0
	mov word[on],1
game_loop:
	cmp word[on],1
	jne over 
    call checkkey
	call printscore
	cmp word[dir],-1
	je start
    cmp word[dir], 1
    je callright
    cmp word[dir], 2
    je callleft
    cmp word[dir], 3
    je callup
    cmp word[dir], 4
    je calldown
    jmp game_loop
over:
	call clrscr
	call gameover
	cmp word[dif],1
	je start
	mov ax,0x4c00
	int 0x21
	
callright:
    call moveright
    jmp game_loop

callleft:
    call moveleft
    jmp game_loop

callup:
	call delay
    call moveup
    jmp game_loop

calldown:
	call delay
    call movedown
    jmp game_loop

checkkey:
    mov ah, 1
    int 0x16
    jz cont
    mov ah, 0
    int 0x16
	cmp ah,0x13
	jne res
	mov word[dir],-1
	jmp cont
	res:
	cmp ah,0x39
	je pause
    cmp ah, 0x4D
    je move_right
    cmp ah, 0x4B
    je move_left
    cmp ah, 0x48
    je move_up
    cmp ah, 0x50
    je move_down
    jmp cont
pause:
	mov ah,0
	int 0x16
	cmp ah,0x39
	jne pause
	jmp cont
move_right:
	cmp word[dir],2
	je cont
	mov cx,1
	call note
    mov word[dir], 1
    ret

move_left:
	cmp word[dir],1
	je cont
	mov cx,1
	call note
    mov word[dir], 2
    ret

move_up:
	cmp word[dir],4
	je cont
	mov cx,1
	call note
    mov word[dir], 3
    ret

move_down:
	cmp word[dir],3
	je cont
	mov cx,1
	call note
    mov word[dir], 4
    ret

cont:
    ret

	
	
	
	
setbckg:
	push ax
	push cx
	push es
	push di
	push dx
	push si
	mov ax,0xb800
	mov es,ax
	xor di,di
	mov ax,0x1720
	mov cx,80
	cld
	rep stosw
	mov di,3840
	mov cx,80
	rep stosw
	mov di,0
	mov cx,25
	vert1:
		stosw
		add di,158
		loop vert1
	mov di,158
	mov cx,25
	vert2:
		stosw
		add di,158
		loop vert2

	mov ax,0x8020
	mov di,162
	mov si,di
	mov dx,23
	f1:
		mov cx,78
		cld
		rep stosw
		add si,160
		mov di,si
		dec dx
		jnz f1
	pop si
	pop dx
	pop di
	pop es
	pop cx
	pop ax
	ret
GenRandNum:
	push di
	push cx
	push ax
	push dx
	push es
	
	mov ax,0xb800
	mov es,ax
	newrand:
	mov ah, 00h 
	int 0x1a 
	mov ax, dx
	xor dx,dx
	mov cx,4000
	div cx 
	mov di,dx
	cmp word[es:di],0x8020
	jne newrand
	mov word[es:di],0x4020;
	pop es
	pop dx;
	pop ax;
	pop cx;
	pop di
	ret
delay:
	push cx
	push dx
	mov cx,[dif]
	da:mov dx,0xFFFF
	d:
	dec dx
	jnz d
	loop da
	pop dx
	pop cx
	ret
printstr: 
	push bp
	 mov bp, sp
	 push es
	 push ax
	 push cx
	 push si
	 push ds
	 pop es
	push di	 
	 mov di, [bp+4] 
	 mov cx, 0xffff 
	 xor al, al 
	 repne scasb 
	 mov ax, 0xffff 
	 sub ax, cx 
	 dec ax
	 jz exit 
	 mov cx, ax 
	 mov ax, 0xb800
	 mov es, ax 
	 mov di,[bp+6]
	 mov si, [bp+4]
	 mov ah, [bp+8]
	 cld
	nextchar:
	lodsb 
	 stosw 
	 loop nextchar 
	exitsub:
		add di,160
	pop di
	 pop si
	 pop cx
	 pop ax
	 pop es
	 pop bp
	 ret 6
menu:
	push 0x04
	push 0
	push i1
	call printstr
	push 0x04
	push 160
	push i2
	call printstr
	push 0x04
	push 320
	push i3
	call printstr
	push 0x04
	push 480
	push i4
	call printstr
	push 0x04
	push 640
	push i5
	call printstr
	push 0x04
	push 800
	push i6
	call printstr
	push 0x09
	push 1280
	push i7
	call printstr
	push 0x09
	push 1440
	push i8
	call printstr
	push 0x09
	push 1600
	push i10
	call printstr
	call front
	call clrscr
	ret
note:
	push ax
	push bx
	mov al, 182
	out 43h, al
	mov ax, 2711
	out 42h, al
	mov al, ah
	out 42h, al
	in al, 61h
	or al, 00000011b
	out 61h, al
	mov bx, cx
	.pause1:
	mov cx, 65535
	.pause2:
	dec cx
	jne .pause2
	dec bx
	jne .pause1
	in al, 61h
	and al, 11111100b
	out 61h, al
	pop bx
	pop ax
	ret  
printscore:
	 push es
	 push ax
	 push bx
	 push cx
	 push dx
	 push di
	 mov ax, 0xb800
	 mov es, ax
	 mov ax, [score] 
	 mov bx, 10 
	 mov cx, 0 
	nextdigit:
   	mov dx, 0 
	 div bx 
	 add dl, 0x30 
	 push dx
	 inc cx 
	 cmp ax, 0 
	 jnz nextdigit 
	 mov di, 80
	nextnum: 
	 pop dx 
	 mov dh, 0x17 
	 mov [es:di], dx 
	 add di, 2 
	 loop nextnum
	 pop di
	 pop dx
	 pop cx
	 pop bx
	 pop ax
	 pop es
	 ret 
front:
	push dx
	push 0x6
	push 2000
	push i11
	call printstr
	mov dx,3
	lp:
		cmp dx,4
		jne g
		dec dx
		jmp f
		g:
		cmp dx,0
		jne f
		inc dx
		f:
		cmp dx,1
		jne r2
		call clear
		push 2208
		call printsnake
		jmp check
		r2:
		cmp dx,2
		jne r3
		call clear
		push 2184
		call printsnake
		jmp check
		r3:
		call clear
		push 2160
		call printsnake
	check:
		mov ah,0
		int 0x16
		cmp ah,0x4B
		jne right1
		inc dx
		jmp lp
		
		right1:
		cmp ah,0x4D
		jne checkenter
		dec dx
		jmp lp
		checkenter:
			cmp ah,0x1c
			je exitfront
			jmp lp
	exitfront:
	mov [dif],dx
	pop dx
	ret
		
printsnake:
	push bp
	mov bp,sp
	push ax
	push cx
	push di
	mov di,[bp+4]
	push 0x04
	push di
	push i12
	call printstr
	add di,160
	push 0x04
	push di
	push i13
	call printstr
	add di,160
	push 0x04
	push di
	push i14
	call printstr
	add di,160
	push 0x04
	push di
	push i15
	call printstr
	add di,160
	push 0x04
	push di
	push i16
	call printstr
	add di,160
	push 0x04
	push di
	push i17
	call printstr
	add di,160
	push 0x04
	push di
	push i18
	call printstr
	add di,160
	push 0x04
	push di
	push i19
	call printstr
	add di,160
	push 0x04
	push di
	push i20
	call printstr
	add di,160
	push 0x04
	push di
	push i21
	call printstr
	add di,160
	push 0x04
	push di
	push i22
	call printstr
	pop di
	pop cx
	pop ax
	pop bp
	ret 2
	
clear:
	pusha
	push 0xb800
	pop es
	mov di,2160
	mov bx,13
	mov ax,0x0720
	co1:
		mov cx,40
		push di
		rep stosw
		pop di
		add di,160
		dec bx
		jnz co1
	popa
ret	
gameover:
	pusha
	push 7
	push 1800
	push ending
	call printstr
	mov dx,1
	lp1:
		cmp dx,3
		jne g1
		dec dx
		jmp h1
		g1:
		cmp dx,0
		jne h1
		inc dx
		h1:
		cmp dx,1
		jne h2
			push 0xb800
			pop es
			mov di,1960
			mov bx,13
			mov ax,0x0720
			co2:
			mov cx,40
			push di
			rep stosw
			pop di
			add di,160
			dec bx
			jnz co2
		push 1990
		call printsnake
		jmp check1
		h2:
			push 0xb800
			pop es
			mov di,1960
			mov bx,13
			mov ax,0x0720
			co3:
			mov cx,40
			push di
			rep stosw
			pop di
			add di,160
			dec bx
			jnz co3
		push 2010
		call printsnake
	check1:
		mov ah,0
		int 0x16
		cmp ah,0x4B
		jne right2
		dec dx
		jmp lp1
		
		right2:
		cmp ah,0x4D
		jne checkenter1
		inc dx
		jmp lp1
		checkenter1:
			cmp ah,0x1c
			je exitover
			jmp lp1
	exitover:
	mov [dif],dx
	popa
	
	ret
	
	
