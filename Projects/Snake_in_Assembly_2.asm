[org 0x100]

jmp start

x_snake_s: dw 0
y_snake_s: dw 0
xy_snake_s: dw 0
x_snake_e: dw 0
y_snake_e: dw 0
xy_snake_e: dw 0
last_pos: dw 0
ltmv_s: dw 1



level: dw 8
xy_fruit_s: dw 0
x_fruit_s: dw 0
y_fruit_s: dw 0

curr: db 1
m1:	db ' START  GAME ', 0
m2: db ' LEAVE ', 0

iscrashed: dw 0
move: dw " LAST MOVE: X"
status: dw "E: END P: PAUSE" 
end_message: dw "GAME HAS BEEN ENDED"

score: dw "SCORE: 000"

roll: dw " 22L-7503"
crashed: dw "CODE CRASHED DUE TO UNEXPECTED PROBLEM"


inst1: dw "   .------.        .------.                        "
inst2: dw "   |  E   |        |  P   |                        "
inst3: dw "   |      |        |      | to END/PAUSE           "
inst4: dw "   '------'        '------'                        "
inst5:  dw "            ______                                 "
inst6:  dw "           |      |                                "
inst7:  dw "   .______.|  /\  |.______.                        "
inst8:  dw "   |      ||______||      |                        "
inst9:  dw "   | <    |'------'|    > | to move snake L/R/U/D  "
inst10: dw "   '------'|      |'------'                        "
inst11: dw "           |  \/  |                                "
inst12: dw "           '------'                                "

inst13: dw "                                                    "

inst14:  dw " ___       __    _   ___     __   __  _  _  ___                __   "
inst15:  dw "[__  |\ | |__| |_/  |___    | _  |__| |\/| |___       ____    /*_>-<"
inst16:  dw "___] | \| |  | | \  |___    |__] |  | |  | |___   ___/ __ \__/ /    "
inst17:  dw "-----------------------------------------------  <____/  \____/     "

ltmv_e: dw 1
level_: dw "LEVEL: 1"
game_: dw "SNAKE"
r_message_1: dw "PRESS 'Q' TO QUIT  "
r_message_2: dw "PRESS 'M' FOR MAIN MENU"


start:
	call first_screen
	call bg
	call game
	jmp end


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

clrscreen:
	pusha
	
	mov ax, 0xb800
	mov es, ax
	xor di, di
	mov ax, 0x0720
	mov cx, 2000
	cld 
	rep stosw
	
	
	popa
	ret

show_menu:
	pusha
	start_loop:
		call menu
		mov cx, 1
		call note
		mov ah, 0
		int 0x16
		cmp ah, 0x48
		jne l_nextcmp
		mov byte[curr], 1
		jmp l_skip

		l_nextcmp:
			cmp ah, 0x50
			jne l_nextcmp1

		mov byte[curr], 2
		jmp l_skip
		
		l_nextcmp1:
			cmp ah, 0x1c
			jne l_skip

		jmp l_next
		l_skip:
			jmp start_loop

	l_next:
		cmp byte[curr], 2
		je l5
		jmp l6
		l5:
		call clrscreen
		jmp end
		l6:		
	popa
	ret
first_screen:
	pusha
	push es
	
	call clrscreen
	
	mov bp, inst1
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x0E
	mov dh, 0x9
	mov dl, 5
	mov cx, 52
	push cs 
	pop es
	int 0x10 
	
	l1: 
	inc dh 
	push cs 
	pop es 
	add bp, 52
	int 0x10
	cmp bp, 936
	jbe l1
	mov dl, 50
	add dh, 4
	push cs 
	pop es 
	add bp, 52
	int 0x10
	
	add bp, 52
	mov bl, 0x06
	mov dl, 9
	mov dh, 1
	mov cx, 67
	inc dh 
	push cs 
	pop es 
	int 0x10
	l2:
	inc dh 
	push cs 
	pop es 
	add bp, 68
	int 0x10 
	cmp bp, 1260
	jbe l2
	
	
	mov dx, 0x1700
	mov cx, 0
	int 0x10 
	mov ah, 0x0
	
	call show_menu
	call clrscreen
	popa	
	pop es
	ret	
	
reset:
	push ax
	push cx
	push di
	push es
	mov word[level], 8
	mov byte[level_+7], '1'
	
	mov word[x_snake_s], 17
	mov word[y_snake_s], 2
	mov word[x_snake_e], 13
	mov word[y_snake_e], 2
	mov word[iscrashed], 0
	mov word[ltmv_s], 1
	mov word[score+7], '0'
	mov word[score+8], '0'
	mov word[score+9], '0'
	mov cx, 4
	mov ax, 0xB800
	mov es, ax
	call calc_position_start
	std
	mov ax, 0x0EDC
	rep stosw
	
	pop es
	pop di
	pop cx
	pop ax
	ret
game:
	pusha
	push es

	call reset
	call Genxy_fruit_s
	mov ah, 0x0
	int 16h

	main:
		call check_key
		cmp word[ltmv_s], 1
		jbe label1
		
		mov ax, [level]
		sub ax, 2
		push ax
		jmp label2
		
		label1:
			mov ax, [level]
			shr ax, 1
			push ax
		label2:
			call delay
			call snake

	jmp main

	pop es
	popa
	ret


check_key:

	mov ah, 0x1
	int 16h
	jz cont1
	mov ah, 0x0
	int 16h
	
	cmp ah, 12h
	je end
	cmp ah, 19h
	je _pause
	cmp ah, 4Bh
	je left
	cmp ah, 4Dh
	je right
	cmp ah, 48h
	je up
	cmp ah, 50h
	je down

	jmp cont1

left:
	cmp word[ltmv_s], 1
	je cont1
	add word[x_snake_s], -1
	mov word[ltmv_s], 0
	mov word[move+12], 'L'
	ret
 
right:

	cmp word[ltmv_s], 0
	je cont1
	add word[x_snake_s], 1
	mov word[ltmv_s], 1
	mov word[move+12], 'R'
	ret

up:
	cmp word[ltmv_s], 3
	je cont1
	add word[y_snake_s], -1
	mov word[ltmv_s], 2
	mov word[move+12], 'U'
	ret

down:
	cmp word[ltmv_s], 2
	je cont1
	add word[y_snake_s], 1
	mov word[ltmv_s], 3
	mov word[move+12], 'D'
	ret
	
_pause:
	mov ah, 0x0
	mov word[move+12], 'P'
	call info
	int 16h
	cmp ah, 19h
	jne _pause
	
cont1:
	cmp word[ltmv_s], 0
	je left
	cmp word[ltmv_s], 1
	je right
	cmp word[ltmv_s], 2
	je up
	cmp word[ltmv_s], 3
	je down
	ret

snake:	
	push ax
	push di
	push si
	push es
	mov ax, 0xB800
	mov es, ax
	call info
	
	call calc_position_start
	mov ax, [es:di]
	mov word[last_pos], ax
	
	cmp ax, 0x0CDC
	je cont3
	call update_back_pointer
	jmp cont5
	
	cont3:
	call update_score
	cont5:
	cmp word[ltmv_s], 1
	jle i1
	mov word[es:di], 0x0EDB	
	jmp i2
	i1:
	mov word[es:di], 0x0EDC
	i2:
	mov ax, 0x0CDC
	mov di, word[xy_fruit_s]
	stosw
	
	call calc_position_start
	cmp word[last_pos], 0x0720
	je cont4
	cmp word[last_pos], 0x0CDC
	je cont4

	
	cmp word[ltmv_s], 3
	je i3
	mov word[es:di], 0x83DC 
	jmp end
	i3:
	mov word[es:di], 0x83DF
	jmp end
	
	
	cont4:
	pop es
	pop si
	pop di
	pop ax
	ret

calc_position_start:
	push ax
	mov ax, word[x_snake_s]
	push ax
	mov ax, word[y_snake_s]
	push ax
	mov ax, xy_snake_s
	push ax
	call get_cords
	mov di, word[xy_snake_s]
	pop ax
	ret
update_back_pointer:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov ax, word[x_snake_e] 
	push ax
	mov ax, word[y_snake_e] 
	push ax
	mov ax, xy_snake_e 
	push ax
	call get_cords
	mov di, word[xy_snake_e]
	
	cmp word[es:di], 0x0EDC
	je w2
	
	cmp word[es:di], 0x0EB1
	je w1
	
	
	w1:
	;down
	mov ax, word [es:di+160] 
	cmp ax, 0x0EDB
	je q3
	
	;up
	mov ax, word [es:di-160]
	cmp ax, 0x0EDB
	je q4 


	w2:
	;right
	mov ax, word [es:di+2]
	cmp ax, 0x0EDC
	je q1
	
	;left
	mov ax, word [es:di-2]
	cmp ax, 0x0EDC
	je q2
	 
	;down
	mov ax, word [es:di+160] 
	cmp ax, 0x0EDB
	je q3
	
	;up
	mov ax, word [es:di-160]
	cmp ax, 0x0EDB
	je q4

	w3:
	mov word[iscrashed], 1
	jmp end
	
	 
	q1:
	add word[x_snake_e], 1
	jmp cont6
	q2:
	add word[x_snake_e], -1
	jmp cont6
	q3:
	add word[y_snake_e], 1
	jmp cont6
	q4:
	add word[y_snake_e], -1
	
	cont6:
	mov word[es:di], 0x0720
	
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
update_score:
	push ax
	mov cx, 2
	call note
	mov al, byte[score+9]
	cmp al, '9'
	je label3
	add byte[score+9], 1
	jmp label5
	label3:
	mov al, byte[score+8]
	cmp al, '9'
	je label4
	add byte[score+8], 1
	mov byte[score+9], '0'
	jmp label5
	label4:
	mov cx, 10
	call note
	add byte[score+7], 1
	mov byte[score+8], '0'
	mov byte[score+9], '0'
	
	label5:
	call update_speed
	call Genxy_fruit_s
	pop ax
	ret 
	
update_speed:
	pusha
	cmp word[level], 2
	jbe cont9
	
	cmp byte[score+9], '0'
	je cont10
	cmp byte[score+9], '5'
	je cont10

	
	jmp cont9
	cont10:
	sub word[level], 1
	add byte[level_+7], 1
	
	cont9:
	popa
	ret
get_cords:
	push bp
	mov bp, sp
	push ax
	push bx

	mov al, [bp+6]
	mov bl, 80
	mul bl
	add ax, [bp+8]
	shl ax, 1
	mov bx, [bp+4]
	mov [bx], ax
	
	pop bx
	pop ax
	pop bp
	ret 6


	
delay:
	push bp
	mov bp, sp
	push cx
	push dx
	push di
	
	mov cx, [bp+4]
	mov di, 0

	dl1: 
		mov dx, 0x8888
		dl2: 
			dec dx
			jnz dl2
	loop dl1
	
	pop di
	pop dx
	pop cx
	pop bp
	ret 2


bg:
	push ax
	push cx
	push di
	push es
	
	
	mov ax, 0xB800
	mov es, ax
	mov ah, 0x07
	mov al, 0x20
	mov di, 0
	mov cx, 2000
	cld
	rep stosw
	mov ah, 0x06
	mov al, 0xB1
	
	mov cx, 24
	mov di, 0
	l3:
		stosw
		add di, 156
		stosw
	loop l3
	
	mov di, 0
	mov cx, 80
	cld
	rep stosw
	mov di, 3520
	mov cx, 80
	cld 
	rep stosw
	
	mov ah, 0x06
	mov di, 840
	mov cx, 40
	cld 
	rep stosw
	mov di, 1000
	mov cx, 40
	cld 
	rep stosw
	mov di, 1160
	mov cx, 40
	cld 
	rep stosw
	
	mov di, 2280
	mov cx, 40
	cld 
	rep stosw
	mov di, 2440
	mov cx, 40
	cld 
	rep stosw
	mov di, 2600
	mov cx, 40
	cld 
	rep stosw
	
	mov cx, 19
	mov di, 330
	l7:
	mov word[es:di], 0x06B1
	mov word[es:di+2], 0x06B1
	add di, 160
	loop l7
	
	mov cx, 19
	mov di, 466
	l8:
	mov word[es:di], 0x06B1
	mov word[es:di+2], 0x06B1
	add di, 160
	loop l8
	
	
	call info
	pop es
	pop di
	pop dx
	pop cx
	ret
	
info:
	pusha
	push es
	
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x6E
	mov dx, 0x1701 
	mov cx, 13
	push cs 
	pop es 
	mov bp, move
	int 0x10 
	
	mov dx, 0x1710
	mov cx, 15
	push cs 
	pop es 
	mov bp, status
	int 0x10 
	mov bl, 0x0E
	mov dx, 0x1725
	mov cx, 5
	push cs 
	pop es 
	mov bp, game_
	int 0x10 
	mov bl, 0x6E
	mov dx, 0x1730
	mov cx, 10
	push cs 
	pop es 
	mov bp, score
	int 0x10 	
	
	mov dx, 0x173C
	mov cx, 8
	push cs 
	pop es 
	mov bp, level_
	int 0x10
	
	mov dx, 0x1746
	mov cx, 9
	push cs 
	pop es 
	mov bp, roll
	int 0x10
	
	pop es
	popa
	ret
	
Genxy_fruit_s:

	push cx
	push ax
	push dx
	push es
	push di
	
	mov ax, 0xB800
	mov es, ax
	
	l4:
	call GenRandCoords
	mov ax, word[x_fruit_s]
	push ax
	mov ax, word[y_fruit_s]
	push ax
	mov ax, xy_fruit_s
	push ax
	call get_cords
	mov di, word[xy_fruit_s]
	mov ax, [es:di]
	cmp ax, 0x0720
	je cont2
	jmp l4
	
	cont2:
	pop di
	pop es
	pop dx
	pop ax
	pop cx
	ret

GenRandCoords:
	push cx
	push ax
	push dx
	
	mov ah, 0x00
	int 0x1A 
	mov ax, dx
	xor dx, dx
	mov cx, 70
	div cx
	
	shr dx, 1
	shl dx, 1
	add dx, 3
	
	mov word[x_fruit_s],dx
	
	mov ah, 0x00
	int 0x1A 
	mov ax, dx
	xor dx, dx
	mov cx, 20
	div cx
	
	shr dx, 1
	shl dx, 1
	add dx, 2
	
	mov word[y_fruit_s],dx
	
	pop dx
	pop ax
	pop cx
	ret

menu:
	pusha
	push 0xB800
	pop es

	cmp byte[curr], 1
	jne m_cmp2

	mov ah, 0xEE
	jmp m_p1
	m_cmp2:
	mov ah, 0xEE
	jmp m_p2

	m_p1:
		mov si, 2046
		mov di, 0
			
	m_l1:
	mov al, [m1 + di]
		mov word[es:si], ax
		add si, 2
		inc di
		cmp byte[m1 + di], 0
		jne m_l1

	cmp byte[curr], 2
	je m_exit

	mov ah, 0x0E
	m_p2:
		mov si, 2372
	 	mov di, 0
	m_l2:
		mov al, [m2 + di]
		mov word[es:si], ax
		add si, 2
		inc di
		cmp byte[m2 + di], 0
		jne m_l2

	mov ah, 0x0E
	cmp byte[curr], 2
	je m_p1

	m_exit:
	popa
	ret

ending_message:
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x0E
	mov dh, 0x0A
	cmp word[iscrashed], 1
	jne cont7
	mov word[iscrashed], 0
	mov dl, 21
	mov cx, 38
	push cs 
	pop es 
	mov bp, crashed
	int 0x10 
	jmp cont8
	
	
	cont7:
	mov dl, 30
	mov cx, 19
	push cs 
	pop es 
	mov bp, end_message
	int 0x10 
	mov dh, 0x0C 
	mov dl, 31
	push cs  
	pop es 
	mov bp, r_message_1
	int 0x10 
	mov dh, 0x0D
	mov cx, 23
	mov dl, 28
	push cs 
	pop es 
	mov bp, r_message_2
	int 0x10 
	mov dh, 0x0E 
	mov dl, 35
	mov cx, 10
	push cs 
	pop es 
	mov bp, score
	int 0x10 

	
	cont8: 
	mov dx, 0x1700
	mov cx, 0
	int 0x10 
	
	h2:
	mov ah, 0x0
	int 16h
	cmp ah, 0x10
	je h1
	cmp ah, 0x32
	je h3
	jne h2
	
	h3:
	jmp start
	h1:
	ret

	
end:
	mov cx, 4
	call note
	call ending_message
	
mov ax, 0x4C00
int 0x21
