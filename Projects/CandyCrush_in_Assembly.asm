[org 0x100]

jmp start
randNum: db '0'
data: db 'Start Game(Press Enter)'
d1: db ' _  _ __ __ _ __     ___  __  __ _ ____ _  _     ___ ____ _  _ ____ _  _ '
d2: db '( \/ (  (  ( (  )   / __)/ _\(  ( (    ( \/ )   / __(  _ / )( / ___/ )( \'
d3: db '/ \/ \)(/    /)(   ( (__/    /    /) D ()  /   ( (__ )   ) \/ \___ ) __ ('
d4: db '\_)(_(__\_)__(__)   \___\_/\_\_)__(____(__/     \___(__\_\____(____\_)(_/'
click: db 0

matcher: db 0

save: dw 0
savec: dw 0
score: dw 0
sscore: db 'score:'


 
;10x10 grid
;copied sound
sound:
	push ax
	push bx
	mov al, 182
	out 43h, al
	mov ax, 1000
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
	
sound2:
	push ax
	push bx
	mov al, 182
	out 43h, al
	mov ax, 700
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
printnum: 
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov ax, [bp+4] ; load number in ax
	mov bx, 10 ; use base 10 for division
	mov cx, 0 ; initialize count of digits
	nextdigit: 
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigit ; if no divide it again
		
	mov di, 144
	nextpos: 
		pop dx ; remove a digit from the stack
		mov dh, 0x07 ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location
		loop nextpos ; repeat for all digits on stack
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 2 

clrscr: push es
 push ax
 push cx
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 xor di, di ; point di to top left column
 mov ax, 0x0720 ; space char in normal attribute
 mov cx, 2000 ; number of screen locations
 cld ; auto increment mode
 rep stosw ; clear the whole screen
 pop di 
pop cx
 pop ax
 pop es
 ret  
	
game:
	mov ax, 0xb800
    mov es, ax
	
	mov bx, d1
	
	
	xor si, si
	mov si, bx
	xor di, di
	add di, 806
	mov ah, 10;green color
	mov cx, 73
	nextchar:
		lodsb
		stosw
		loop nextchar
	
	mov bx, d2
	
	
	xor si, si
	mov si, bx
	xor di, di
	add di, 806
	add di, 160
	mov ah, 10;green color
	mov cx, 73
	nextchar1:
		lodsb
		stosw
		loop nextchar1
		
	mov bx, d3
	xor si, si
	mov si, bx
	xor di, di
	add di, 806
	add di, 320
	mov ah, 10;green color
	mov cx, 73
	nextchar2:
		lodsb
		stosw
		loop nextchar2
		
	mov bx, d4	
	xor si, si
	mov si, bx
	xor di, di
	add di, 806
	add di, 480
	mov ah, 10;green color
	mov cx, 73
	nextchar3:
		lodsb
		stosw
		loop nextchar3
		
	mov bx, data	
	xor si, si
	mov si, bx
	xor di, di
	add di, 806
	add di, 840
	mov ah, 2
	mov cx, 23
	nextchar4:
		lodsb
		stosw
		loop nextchar4
		
	a:	
		mov ah,00
		int 16h
		cmp ah, 28
		jne a
	
	ret
	
delayer:

push dx
push bx
push cx
mov dx, 5


l1:
	
	mov bx, 10		;change these values to change randomness
	


l2:

	
	mov cx, 5000

l3:
	loop l3

sub bx, 1
cmp bx,0
jnz l2
sub bx, 1


sub dx, 1
cmp dx, 0
jnz l1

pop cx
pop bx
pop dx

ret
GenRandNum:
	
	push bp
	mov bp,sp;
	push cx
	push ax
	push dx;
	MOV AH, 00h ; interrupts to get system time
	INT 1AH ; CX:DX now hold number of clock ticks since midnight
	mov ax, dx
	xor dx, dx
	mov cx, 5;
	div cx ; here dx contains the remainder of the division - from 0 to 9
	
	add dl, 1 ; to ascii from '0' to '9'
	
	mov word[randNum],dx;
	
	
	pop cx;
	pop ax;
	pop dx;
	pop bp;
	ret
row1:
	
	push bp
	mov bp, sp
	push cx
	mov di, [bp+4]
	mov cx, 8
	nextblock:
	
	mov ax, [es:di]
	cmp ax, 0x0720
	jne adder
	call delayer
	call GenRandNum
	mov ah,[randNum]
	
	mov al, [randNum]
	mov [es:di], ax
	add di, 4
	loop nextblock
	jmp return
	adder:
		add di, 4
		jmp nextblock
	return:
	pop cx
	pop bp
	ret 2
pg:
	mov ax, 0xb800
	mov es, ax
	mov di, 340
	mov cx, 5
	l:
	push di
	call row1
	add di, 256
	
	loop l
	
	xor di, di
	mov di, 340
	sub di, 320
	mov cx, 32
	mov ah, 11
	mov al, '-'
	rep stosw
	
	xor di, di
	mov di, 340
	add di, 1440
	mov cx, 32
	mov ah, 11
	mov al, '-'
	rep stosw
	
	xor di, di
	mov di, 130
	mov si, sscore
	mov ah, 15
	mov cx, 6
	nscore:
		lodsb
		stosw
		loop nscore
	
	ret
	
displayscore:
	
	push word[score]
	call printnum
	ret


dcursor:
	
	push ax
	push es
	
	mov ax, 0xb800
	mov es, ax
	
	xor ax, ax
	xor di, di
	
	mov di, 340
	mov ah, 15
	mov al, '|'
	
	mov [es:di-2], ax
	mov [es:di+2], ax
	
	pop es
	pop ax
	
	ret
	
cursor:
	
	push ax
	push es
	
	mov ax, 0xb800
	mov es, ax
	
	xor ax, ax
	
	call comparison
	
	pop es
	pop ax
	ret


comparison:
	push ax
	push dx
	mov ah,00
	int 16h
	
	cmp ah, 0x48
	je up
	cmp ah, 0x50
	je down
	cmp ah, 0x4B
	je lefter
	cmp ah, 0x4D
	je right
	cmp ah, 28
	je select
	cmp ah, 01
	je escape
	
	jmp returnercomp
	
	up:
		push cx
		mov cx, 1
		call sound
		pop cx
		mov dh, 11
		mov dl, '-'
		cmp [es:di-320], dx
		je returnercomp
		call removeAllS
		xor ax, ax
		mov ah, 15
		mov al, '|'
		mov [es:di-322], ax
		mov [es:di-318], ax
		sub di, 320
		jmp returnercomp
		
	down:
		push cx
		mov cx, 1
		call sound
		pop cx
		
		mov dh, 11
		mov dl, '-'
		cmp [es:di+160], dx
		je returnercomp
		call removeAllS
		xor ax, ax
		mov ah, 15
		mov al, '|'
		mov [es:di+322], ax
		mov [es:di+318], ax
		add di, 320
		jmp returnercomp
		
	
	lefter:
		push cx
		mov cx, 1
		call sound
		pop cx
	
		mov dx, 0x0720
		cmp [es:di-4], dx
		je returnercomp
		call removeAllS
		xor ax, ax
		mov ah, 15
		mov al, '|'
		mov [es:di-6], ax
		mov [es:di-2], ax
		sub di, 4
		jmp returnercomp
	
	right:
		push cx
		mov cx, 1
		call sound
		pop cx
		
		mov dx, 0x0720
		cmp [es:di+4], dx
		je returnercomp
		call removeAllS
		xor ax, ax
		mov ah, 15
		mov al, '|'
		mov [es:di+6], ax
		mov [es:di+2], ax
		add di, 4
		jmp returnercomp
	
	select:
		push cx
		mov cx, 1
		call sound
		pop cx
		
		call manageSelect	;when enter is pressed
		jmp returnercomp
	escape:
		push cx
		mov cx, 2
		call sound
		pop cx
		;removing brackets
		call removeAllSBrack1
		call removeAllSBrack2
		push ax
		
		;resetting memory
		xor ax, ax
		mov [save], ax
		mov [savec], al
		
		; replacing brackets with straight lines
		xor ax, ax
		mov ah, 15
		mov al, '|'
		mov [es:di-2], ax
		mov [es:di+2], ax
		pop ax
	
	returnercomp:
	pop dx
	pop ax
	ret 


validmove:
	push dx
	push ax
	
	mov ax, di
	mov dx, [savec]
	mov cx, 0
	
	sub ax, dx
	cmp ax, 320
	je valid
	cmp ax, -320
	je valid
	cmp ax, 4
	je valid
	cmp ax, -4
	je valid
	
	jmp vreturner
	
	valid:
		mov cx, 1
		
	vreturner:
	pop ax
	pop dx
	ret
	
	
	
match:
	push si
	push ax
	push bx
	push cx
	push dx
	push di
	push es
	xor di, di
	mov di, 340		;when changing dimensions make sure to change this too
	
	xor bx, bx
	xor cx, cx
	xor dx, dx
	xor si, si
	
	nextcandyC:
		mov cx, 16		;when changing dimensions change this too
		nextcandyR:
		mov ax, [es:di]
		
		cmp ax, 0x0720
		je nomatch
		cmp ax, [es:di+4]
		jne vertical
		cmp ax,[es:di+8]
		jne vertical
		cmp ax,[es:di+12]
		jne no4matcher
		
		mov dx, 1	;check for 4 matcher(horizontal)
		no4matcher:
			mov si, 1	;for horizontal match
			call foundmatch
			jmp foundreturner
		vertical:
		cmp ax, [es:di+320]
		jne nomatch
		cmp ax, [es:di+640]
		jne nomatch
		cmp ax, [es:di+960]
		jne no4matcher2
		
		mov dx, 1
		no4matcher2:
			call foundmatch
			jmp foundreturner
		nomatch:
		add di, 4
		loop nextcandyR
		
	add di, 256		;when changing dimensions make sure to change this too
	inc bx
	cmp bx, 5		;when changing dimensions make sure to change this too
	jne nextcandyC
	
	
	
	foundreturner:
	pop es
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	ret

foundmatch:
	push cx
	mov cx, 1
	call sound
	mov cx, 3
	call sound2
	pop cx
	push si
	push ax
	push bx
	push cx
	push dx
	
	xor bx, bx
	mov bl, 1
	mov [matcher], bl	;to tell that a match is found so repeat the process
	cmp si, 0	;whether match is vertical(0) or horizontal (1)
	je vmatch
	cmp dx, 1
	je allCandy
	
	mov dx, [es:di]
	or dh, 10000000b	;blinking before removing
	mov [es:di], dx
	mov [es:di+4], dx
	mov [es:di+8], dx
	
	call delayer
	call delayer
	call delayer
	call delayer
	call delayer
	call delayer
	call delayer
	call delayer
	call delayer
	call delayer
	
	mov dx, 0x0720
	mov [es:di], dx
	mov [es:di+4], dx
	mov [es:di+8], dx
	add word[score], 3
	jmp freturnter
	
	
	vmatch:
		cmp dx, 1 
		je allCandy
		mov dx, [es:di]
		or dh, 10000000b	;blinking before removing
		mov [es:di], dx
		mov [es:di+320], dx
		mov [es:di+640], dx
		
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		
		mov dx, 0x0720
		mov [es:di], dx
		mov [es:di+320], dx
		mov [es:di+640], dx
		add word[score], 3
		jmp freturnter
		
		
		
	allCandy:
		push di
		xor di, di
		push dx
		xor dx, dx
		mov dx, ax
		or dh, 10000000b
		push dx	;push value in dx (blinking value) for new ax
		mov cx, 2000
		ncr1:
		cmp [es:di], ax
		je blinkcandy
		add di, 2
		loop ncr1
		
		jmp after
		
		blinkcandy:
		mov [es:di], dx
		add di, 2
		sub cx, 1
		jmp ncr1
		
		
		
		after:
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		pop ax	;poping value of blinking candy to ax
		pop dx
		pop di
		xor di, di
		mov di, 340
		push di
		push ax
		
		xor di, di
		mov dx, 0x0720
		mov cx, 2000
		ncr:
		cmp [es:di], ax
		je removercandy
		add di, 2
		loop ncr
		
		jmp before
		
		removercandy:
		inc word[score]
		mov [es:di], dx
		add di, 2
		sub cx, 1
		jmp ncr
		
	before:
	pop ax
	pop di
	
	
	freturnter:
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
			
	ret

manageSelect:
	push ax
	push dx
	push cx
	
	xor cx, cx
	mov ax, [save]
	cmp ax, 0
	je selector
	
	mov dx, [es:di]
	call validmove	;move only valid when it is adjacent to selected candy
	
	cmp cx, 0
	je vskiper	;if cx 0 then invalid else valid
	
	
	xchg [es:di], ax
	
	
	push di
	mov di, [savec]
	mov [es:di], ax
	pop di
	
	call match
	cmp byte[matcher], 0 	;if there is no matching then 
	jne vskiper				;it is not a valid move thus exchange values again to get them back to normal
	
	xchg [es:di], ax
	
	
	push di
	mov di, [savec]
	mov [es:di], ax
	pop di
	
	
	
	vskiper:
	mov byte[matcher], 0
	mov ah, 15
	mov al, '|'
	mov [es:di-2], ax
	mov [es:di+2], ax
	xor dx, dx
	mov [save], dx	;resetting value of selected
	mov [savec], dl	;resetting coordinates
	call removeAllSBrack1
	call removeAllSBrack2
	jmp mreturner
	
	selector:
		mov ah, 15
		mov al, '['
		mov [es:di-2], ax
		mov al, ']'
		mov [es:di+2], ax
		mov ax, [es:di]
		mov [save], ax
		mov [savec], di
	
	
	mreturner:
	pop cx
	pop dx
	pop ax
	ret

removeAllS:;removes all selector characters
	push es
	push ax
	push bx
	push cx
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	xor di, di ; point di to top left column
	mov ax, 0x0720 ; space char in normal attribute
	mov cx, 2000 ; number of screen locations
	mov bh, 15
	mov bl, '|'
	nextchara:
	cmp [es:di], bx
	je remover
	add di, 2
	loop nextchara
	jmp returnRemove
	
	remover:
	mov [es:di], ax
	add di, 2
	sub cx, 1
	jmp nextchara
	
	returnRemove:
	pop di 
	pop cx
	pop bx
	pop ax
	pop es
	ret  
	
removeAllSBrack1:;removes all selector characters
	push es
	push ax
	push bx
	push cx
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	xor di, di ; point di to top left column
	mov ax, 0x0720 ; space char in normal attribute
	mov cx, 2000 ; number of screen locations
	mov bh, 15
	mov bl, '['
	nextchara1:
	cmp [es:di], bx
	je remover1
	add di, 2
	loop nextchara1
	jmp returnRemove1
	
	remover1:
	mov [es:di], ax
	add di, 2
	sub cx, 1
	jmp nextchara1
	
	returnRemove1:
	pop di 
	pop cx
	pop bx
	pop ax
	pop es
	ret  	
	
removeAllSBrack2:;removes all selector characters
	push es
	push ax
	push bx
	push cx
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	xor di, di ; point di to top left column
	mov ax, 0x0720 ; space char in normal attribute
	mov cx, 2000 ; number of screen locations
	mov bh, 15
	mov bl, ']'
	nextchara2:
	cmp [es:di], bx
	je remover2
	add di, 2
	loop nextchara2
	jmp returnRemove2
	
	remover2:
	mov [es:di], ax
	add di, 2
	sub cx, 1
	jmp nextchara2
	
	returnRemove2:
	pop di 
	pop cx
	pop bx
	pop ax
	pop es
	ret  	

fillna:
	push es
	push di
	push ax
	push cx
	push bx
	
	mov ax, 0xb800
	mov es, ax
	restart:
	xor di, di
	xor cx, cx
	xor ax, ax
	xor bx, bx
	
	mov di, 340
	
	
	
	
	
	
	nextcandyC1:
		mov cx, 16		;when changing dimensions change this too
		nextcandyR1:
		mov ax, [es:di]
		
		cmp ax, 0x0720
		jne filledspace
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		call delayer
		
		call GenRandNum
		push ax
		mov al, byte[randNum]
		mov ah, byte[randNum]
		mov [es:di], ax
		pop ax
		jmp restart
		filledspace:
		add di, 4
		loop nextcandyR1
		
	add di, 256 	;when changing dimensions make sure to change this too
	inc bx
	cmp bx, 5		;when changing dimensions make sure to change this too
	jne nextcandyC1
	
	call match
	
	pop bx
	pop cx
	pop ax
	pop di
	pop es
	ret

start:
	
    call clrscr
	call game
	call clrscr
	call pg
	call dcursor
	
	looper1:
		mov byte[matcher], 0
		call displayscore
		call cursor
		call displayscore
		call fillna
		jmp looper1
	
	
	
	

mov ax, 0x4c00
int 0x21
