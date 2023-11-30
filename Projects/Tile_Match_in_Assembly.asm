[org 0x0100]

jmp start

t1:db" ___  ___ ___ _____ _____ _   _   _____ _   _ _____   _____ _____ _     _____  ",0
t2:db"||  \/  |/ _ \_   _/  __ \ | | | |_   _| | | |  ___| |_   _|_   _| |   |  __|| ",0
t3:db"|| .  . / /_\ \| | | /  \/ |_| |   | | | |_| | |__     | |   | | | |   | |____ ",0
t4:db"|| |\/| |  _  || | | |   |  _  |   | | |  _  |  __|    | |   | | | |   |  __|| ",0
t5:db"|| |  | | | | || | | \__/\ | | |   | | | | | | |___    | |  _| |_| |___| |___  ",0
t6:db"\\_|  |_|_| |_/\_/  \____|_| |_/   \_/ \_| |_|____/    \_/  \___/\_____|____// ",0
press_space_string:db"PRESS SPACE BAR TO START",0 

randNum: db 0                 
randColor: db 0                                                         																	  
clrscr:   
	push ax
	push cx
	push es
	push di
	mov ax,0xb800
	mov es,ax
	mov cx,2000
	xor di,di
	mov ax,0x0720
	cld
	rep stosw
	pop di
	pop es
	pop cx
	pop ax
	ret
strlen:
	push bp 
	mov bp,sp 
	push es 
	push cx 
	push di 
	les di, [bp+4] 
	mov cx, 0xffff 
	xor al, al 
	repne scasb 
	mov ax, 0xffff 
	sub ax, cx 
	dec ax 
	pop di 
	pop cx 
	pop es 
	pop bp 
	ret 4
delay:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	mov ax,3
	l1:
		mov bx,[bp+4]
		l2:
			mov cx,[bp+4]

			l3:
				dec cx
				cmp cx,0
				jnz l3
				dec bx
				cmp bx,0
				jnz l2
				dec ax
				cmp ax,0
				jnz l1

	pop cx
	pop bx
	pop ax
	pop bp

	ret 2

msgprint:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push si
	push di

	xor ax, ax
	mov ah, 0x13 
	mov al, 1 
	mov bh, 0 
	mov bl, [bp+10] 
	mov dx, [bp+4] 
	mov cx, [bp+8]
	push cs 
	pop es 
	mov bp, [bp+6] 
	int 0x10 

	pop di
	pop si
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8

GenRandNum:
	push bp
	mov bp,sp
	push cx
	push ax
	push dx

	MOV AH, 00h 
	INT 1AH 
	mov ax, dx
	xor dx, dx
	mov cx, 80
	div cx 

	add dl, '0' 

	mov word[randNum],dx

	pop cx
	pop ax
	pop dx
	pop bp
	ret
GenRandColor:
	pusha
	push 500
	call delay
	rdtsc 
    xor dx, dx
    mov cx, 6
    div cx 
    mov bx, dx 
    mov byte[randColor], dl
	popa
welcome:
	push bp 
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	xor ax, ax

	push ds
	push t1
	call strlen

	push 01001110b 
	push ax 
	push t1 
	push 0x0801

	push 100
	call delay
    call msgprint

	push ds
	push t2
	call strlen

	push 01001110b 
	push ax 
	push t2 
	push 0x0901

	push 100
	call delay
    call msgprint

	push ds
	push t3
	call strlen

	push 01001110b 
	push ax 
	push t3 
	push 0x0A01

	push 100
	call delay
    call msgprint

	push ds
	push t4
	call strlen

	push 01001110b 
	push ax 
	push t4 
	push 0x0B01

	push 100
	call delay
    call msgprint

	push ds
	push t5
	call strlen

	push 01001110b 
	push ax 
	push t5 
	push 0x0C01

	push 100
	call delay
    call msgprint

	push ds
	push t6
	call strlen

	push 01001110b 
	push ax 
	push t6 
	push 0x0D01

	push 100
	call delay
    call msgprint

	push ds
	push press_space_string
	call strlen

	push 00011110b 
	push ax 
	push press_space_string 
	push 0x0F19

	push 500
	call delay
    call msgprint

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 

	popa

keyboardISR:
    push ax

    in al, 0x60 
    cmp al, 0x01 
    jne exit_out

    mov ax, [KbISR] 
    mov [es: 9 * 4], ax
    mov ax, [KbISR + 2] 
    mov [es: 9 * 4 + 2], ax

    mov al, 0x20
    out 0x20, al

    call disableMouseCursor
    call print_last_screen 

    mov ax, 0x4c00
    int 0x21

    exit_out:
    mov al, 0x20
    out 0x20, al

    pop ax
    iret

start:
	mov ah, 0 
	int 0x16 
	call clrscr

        mov ax, 1003h
        mov bx, 0
        mov bl, 0
        int 10h

	call welcome
	s:
	mov ah, 0 
	int 0x16 
	cmp ah, 57
	jne s

    mov ax, 0
    mov es, ax

    mov ax, [es: 9 * 4] 
    mov [KbISR], ax
    mov ax, [es: 9 * 4 + 2] 
    mov [KbISR + 2], ax

        mov ah, 01h
        mov cl, 0
        mov ch, 00101000b
        int 10h

    push 1
    call changeScreen 
    call clrscr

    call print_outline
    call print_outer_txt

    cli
    mov word[es: 9 * 4], keyboardISR
    mov word[es: 9 * 4 + 2], cs
    sti

gameLoop:

    call mouse_interupt

    mov al, ah
    mov ah, 0
    mov si, ax 
    push dx
    push cx

    call waitforButtonRelease

    push dx
    push cx
    push 1
    call selectDeselectCandy

    push dx
    push cx

    push dx
    push cx

    call mouse_interupt

    push dx
    push cx
    call checkValidMove

    cmp bx, 0 
    je noSwap

    mov al, ah
    mov ah, 0
    push ax
    call print_bloc
    call waitforButtonRelease
    call disableMouseCursor

    push dx
    push cx
    push si
    call print_bloc

    push 0
    call selectDeselectCandy
    call checkFiveCombination
    call checkPopVertical
    call checkPopHorizontal
    call EnableMouseCursor
    jmp keepGoing

    noSwap:
        sub sp, 4
        call waitforButtonRelease
        push 0
        call selectDeselectCandy

    keepGoing:
    jmp gameLoop

    cleanExit:
        mov ax, 0x4c00
        int 0x21

checkValidMove:
    push bp
    mov bp, sp
    push si
    push di

    mov si, [bp + 10] 
    mov di, [bp + 8] 
    mov bx, 0

    add si, 4
    cmp si, [bp + 6]
    jne when_2
    cmp di, [bp + 4]
    je validEnd

    when_2:

    sub si, 4
    sub si, 4
    cmp si, [bp + 6] 
    jne when_3
    cmp di, [bp + 4]
    je validEnd

    when_3:

    add si, 4
    add di, 8
    cmp di, [bp + 4] 
    jne when_4
    cmp si, [bp + 6]
    je validEnd

    when_4:

    sub di, 8
    sub di, 8
    cmp di, [bp + 4]
    jne officialEnd
    cmp si, [bp + 6]
    jne officialEnd

    validEnd:
        mov bx, 1

    officialEnd:
        pop di
        pop si
        pop bp
        ret 8

selectDeselectCandy:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, [bp + 8]
    mov di, [bp + 6]

    mov ah, 09h
    mov al, '-'
    mov bh, 1
    cmp word[bp + 4], 1
    jne select_colors
    mov bl, [clr_selection]
    jmp one__for

    select_colors:
        mov al, ' '
        mov bl, 0x07

    one__for:
    dec si
    push si
    push di
    call setCursorPosition

    mov cx, 7
    int 10h

    add si, 4
    push si
    push di
    call setCursorPosition

    int 10h

    cmp word[bp + 4], 1
    jne select_color
        mov al, '|'

    select_color:
    mov cx, 1
    sub si, 4
    add di, 7
    mov dh, 0
    mov dl, 3

    right_side:
        inc si
        push si
        push di
        call setCursorPosition
        int 10h
        inc dh
        cmp dh, dl
        jne right_side

    mov dh, 0
    sub di, 8

    left_side:
        push si
        push di
        call setCursorPosition
        int 10h
        dec si
        inc dh
        cmp dh, dl
        jne left_side    

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6

checkFiveCombination:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov dx, 0 

    Rowcheck:
        mov si, [first_box]
        mov di, [first_box + 2]
        add si, dx
        push si
        push di
        call readColor
        mov bh, ah 
        mov cx, 4

        row___:
            add di, 8
            push si
            push di
            call readColor
            cmp ah, bh
            jne one_for_one_____
            loop row___

            push dx
            push 2 
            call gapFillRow
            mov bl, bh
            mov bh, 0

            
            push bx
            call deleteAllColorInstances

           

            mov di, [first_box + 2]
            push si
            push di
            call deleteCandyInstance

            one_for_one_____:
            add dx, 4
            cmp dx, 16
            jne Rowcheck

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 

checkPopVertical:
    push bp
    mov bp, sp
    sub sp, 2 
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov word[bp - 2], 0
    mov dx, 0 

    fullColcheck:
        mov si, [first_box]
        mov di, [first_box + 2]
        add di, dx
        push si
        push di
        call readColor
        mov bh, ah 
        mov cx, 3

        col1:
            add si, 4
            push si
            push di
            call readColor
            cmp ah, bh
            jne one_for_one_one
            loop col1

            push dx
            call gapFillCol
            mov word[bp - 2], 1

            one_for_one_one:
            add dx, 8
            cmp dx, 40
            jne fullColcheck

    cmp word[bp - 2], 1
    jne all_ok
    call checkPopVertical 
    call checkPopHorizontal

    all_ok:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret

checkPopHorizontal:
    push bp
    mov bp, sp
    sub sp, 2 
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov word[bp - 2], 0
    mov dx, 0 

    LeftRowcheck:
        mov si, [first_box]
        mov di, [first_box + 2]
        add si, dx
        push si
        push di
        call readColor
        mov bh, ah 
        mov cx, 3

        row1:
            add di, 8
            push si
            push di
            call readColor
            cmp ah, bh
            jne one_for_one
            loop row1

            push dx
            push 0
            call gapFillRow
            mov word[bp - 2], 1

            one_for_one:
            add dx, 4
            cmp dx, 16
            jne LeftRowcheck

    mov dx, 0
    RightRowcheck:
        mov si, [first_box]
        mov di, [first_box + 2]
        add di, 8
        add si, dx
        push si
        push di
        call readColor
        mov bh, ah 
        mov cx, 3

        row2:
            add di, 8
            push si
            push di
            call readColor
            cmp ah, bh
            jne one_for_out
            loop row2

            push dx
            push 1
            call gapFillRow
            mov word[bp - 2], 1

            one_for_out:
            add dx, 4
            cmp dx, 16
            jne RightRowcheck

    cmp word[bp - 2], 1
    jne all_ok_ok
    call checkPopHorizontal 
    call checkPopVertical

    all_ok_ok:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret

gapFillCol:
    push bp
    mov bp, sp
    push cx
    push si
    push di

    mov si, [first_box] 
    mov di, [first_box + 2] 

    add di, [bp + 4]
    mov cx, 4

    to_one:
        push si
        push di
        push 0
        call print_bloc
        inc word[score]
        call printScore

        

        add si, 4
        loop to_one

    mov cx, 4
    sub si, 4

    to_two:
        push si
        push di
        call print_rand_bloc

      

        sub si, 4
        loop to_two

    pop di
    pop si
    pop cx
    pop bp
    ret 2

gapFillRow:
    push bp
    mov bp, sp
    sub sp, 2 
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov word[bp - 2], 0 
    mov si, [first_box]
    mov di, [first_box + 2]
    add si, [bp + 6]
    mov dx, 4

    cmp word[bp + 4], 1
    jne nine_for

    add di, 8

    nine_for:
    mov bx, [first_box] 

    cmp word[bp + 4], 2 
    jne nine__for
        mov dx, 5

    nine__for:
    mov cx, dx

    to_three:
        push si
        push di
        push 0
        call print_bloc
        inc word[score]
        call printScore

       
        add di, 8
        loop to_three

    cmp si, bx
    jne two_for

    mov cx, dx
    sub di, 8

    to_four:
        push si
        push di
        call print_rand_bloc

       

        sub di, 8
        loop to_four
        cmp word[bp + 4], 2 
        jne one_for_one_one0____
            cmp word[bp - 2], 0
            jne one_for_one_one0____
            add di, 8
            push si
            push di
            call bomb
            mov word[bp - 2], 1
        one_for_one_one0____:
        jmp byebye

    two_for:

    add bx, 4
    cmp si, bx
    jne three_for

    sub di, 8
    mov cx, dx

    to_five:
        sub si, 4
        push si
        push di
        call readColor
        cmp ah, 0b
        jne carry_on3
            sub si, 4
            push si
            push di
            call readColor
            add si, 4

        carry_on3:
        add si, 4
        mov al, ah
        mov ah, 0
        push si 
        push di 
        push ax 
        call print_bloc

        sub di, 8
        loop to_five
        cmp word[bp + 4], 2 
        jne one_for_one_one1____
            cmp word[bp - 2], 0
            jne one_for_one_one1____
            add di, 8
            push si
            push di
            call bomb
            mov word[bp - 2], 1
            sub di, 8
        one_for_one_one1____:
        sub si, 4
        add di, 32
        cmp word[bp + 4], 2 
        jne ignore____
            add di, 8
        ignore____:
        mov cx, dx
        jmp to_four

    three_for:

    add bx, 4
    cmp si, bx
    jne four_for

    sub di, 8
    mov cx, dx

    to_six:
        sub si, 4
        push si
        push di
        call readColor
        cmp ah, 0b
        jne carry_on2
            sub si, 4
            push si
            push di
            call readColor
            add si, 4

        carry_on2:
        add si, 4
        mov al, ah
        mov ah, 0
        push si 
        push di 
        push ax 
        call print_bloc

        sub di, 8
        loop to_six
        cmp word[bp + 4], 2 
        jne one_for_one_one2____
            cmp word[bp - 2], 0
            jne one_for_one_one2____
            add di, 8
            push si
            push di
            call bomb
            mov word[bp - 2], 1
            sub di, 8
        one_for_one_one2____:
        sub si, 4
        add di, 32
        cmp word[bp + 4], 2 
        jne ignore____2
            add di, 8
        ignore____2:
        mov cx, dx
        jmp to_five

    four_for:

    add bx, 4
    cmp si, bx
    jne byebye

    sub di, 8
    mov cx, dx

    to_seven:
        sub si, 4
        push si
        push di
        call readColor

        cmp ah, 0
        jne carry_on
            sub si, 4
            push si
            push di
            call readColor
            add si, 4

        carry_on:
        add si, 4
        mov al, ah
        mov ah, 0
        push si 
        push di 
        push ax 
        call print_bloc

        sub di, 8
        loop to_seven
        cmp word[bp + 4], 2 
        jne one_for_one_one3____
            cmp word[bp - 2], 0
            jne one_for_one_one3____
            add di, 8
            push si
            push di
            call bomb
            mov word[bp - 2], 1
            sub di, 8
        one_for_one_one3____:
        sub si, 4
        add di, 32
        cmp word[bp + 4], 2 
        jne ignore____3
            add di, 8
        ignore____3:
        mov cx, dx
        jmp to_six

    byebye:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 4

deleteCandyInstance:
    push bp
    mov bp, sp
    push ax
    push bx
    push si
    push di

    mov si, [bp + 6]
    mov di, [bp + 4]

    mov bx, [first_box] 

    empty_this:
        push si
        push di
        push 0
        call print_bloc
        inc word[score]
        call printScore

       

    cmp si, bx
    jne two_for_

    to_four_:
        push si
        push di
        call print_rand_bloc

        

        jmp byebye2

    two_for_:

    add bx, 4
    cmp si, bx
    jne three_for_

    to_five_:
        sub si, 4
        push si
        push di
        call readColor
        cmp ah, 0b
        jne carry_on8
        add si, 8
        push si
        push di
        call readColor
        sub si, 8

    carry_on8:

        add si, 4
        mov al, ah
        mov ah, 0
        push si 
        push di 
        push ax 
        call print_bloc

        sub si, 4
        jmp to_four_

    three_for_:

    add bx, 4
    cmp si, bx
    jne four_for_

    to_six_:
        sub si, 4
        push si
        push di
        call readColor
        cmp ah, 0b
        jne carry_on7
        sub si, 4
        push si
        push di
        call readColor
        add si, 4

    carry_on7:

        add si, 4
        mov al, ah
        mov ah, 0
        push si 
        push di 
        push ax 
        call print_bloc

        sub si, 4
        jmp to_five_

    four_for_:

    add bx, 4
    cmp si, bx
    jne byebye2

    sub si, 4
    push si
    push di
    call readColor
    cmp ah, 0b
    jne carry_on6
        sub si, 4
        push si
        push di
        call readColor
        add si, 4

    carry_on6:
    add si, 4
    mov al, ah
    mov ah, 0
    push si 
    push di 
    push ax 
    call print_bloc

    sub si, 4
    jmp to_six_

    byebye2:
    pop di
    pop si
    pop bx
    pop ax
    pop bp
    ret 4

deleteAllColorInstances:
    push bp
    mov bp, sp
    push cx
    push dx
    push si
    push di

    mov si, [first_box] 
    mov cx, 4

    outer_loop:
    mov dh, 0
    mov dl, 5
    mov di, [first_box + 2] 

    inner_loop:
        push si
        push di
        call readColor 
        mov al, ah
        cmp al, byte[bp + 4]
        jne ignore
            push si
            push di
            call deleteCandyInstance
        ignore:
        add di, 8
        inc dh
        cmp dh, dl
        jne inner_loop
    add si, 4
    loop outer_loop

    pop di
    pop si
    pop dx
    pop cx
    pop bp
    ret 2

EnableMouseCursor:
    push ax

    mov ax, 1
    int 33h

    pop ax
    ret

disableMouseCursor:
    push ax

    mov ax, 2
    int 33h

    pop ax
    ret

waitforButtonRelease:
    push ax
    push bx
    push cx
    push dx

    wait_l1:
        mov ax, 3
        int 33h

        cmp bx, 0
        jne wait_l1

    pop dx
    pop cx
    pop bx
    pop ax
    ret

mouse_interupt:

    mov ax, 7
    mov cx, 475 
    mov dx, 168 
    int 33h

    mov ax, 8
    mov cx, 36
    mov dx, 150
    int 33h

    mov ax, 1
    int 33h

    mov ax, 3
    int 33h

    shr cx, 3   
    shr dx, 3   

    cmp bx, 1
    jne mouse_interupt

    call disableMouseCursor

    push dx
    push cx
    call setCursorPosition

    mov bh, 1
    mov ah, 08h
    int 10h

    cmp ah, 0x07 
    je mouse_interupt

    call getBox 

    push dx
    push cx
    call setCursorPosition

    mov bh, 1
    mov ah, 08h
    int 10h

    call EnableMouseCursor
    ret

getBox:
    push si
    push di

    mov di, [first_box + 2] 
    mov si, [first_box] 

    colCheck:
        add di, 8
        cmp cx, di
        jge colCheck

        sub di, 8
        mov cx, di
        jmp rowCheck

    rowCheck:
        add si, 4
        cmp dx, si
        jge rowCheck

        sub si, 4
        mov dx, si

    pop di
    pop si
    ret

print_last_screen:

    push 2
    call changeScreen

    push 0
    push 0
    push 2
    call setPageCursorPosition

    mov ah, 09h
    mov al, ' '
    mov bh, 2
    mov bl, 01010000b
    mov cx, 2000
    int 10h

    mov ah, 13h
    mov al, 00b
    mov bh, 2
    mov bl, 00001110b
    mov cx, [lenhigh_greet]
    mov dh, 8 
    mov dl, 36 
    push ds
    pop es
    mov bp, high_greet
    int 10h

    push 12 
    push 40 
    push 2 
    call setPageCursorPosition

    mov si, 12
    mov di, 40

    mov ax, [score]
    cmp ax, 0
    je print_zero

    divide__it:
        mov dx, 0
        mov bx, 10
        div bx
        add dl, 0x30 

        push ax
        mov ah, 09h
        mov al, dl
        mov bh, 2
        mov bl, 1010b
        mov cx, 1
        int 10h
        pop ax

        dec di
        push si
        push di
        push 2
        call setPageCursorPosition

        cmp ax, 0
        jne divide__it
        jmp last_for_out

    print_zero:
        mov bh, 2
        mov bl, 1010b
        mov cx, 1
        mov ah, 09h
        mov al, '0'
        int 10h

    last_for_out:
   
    ret

print_outer_txt:
    push ax
    push bx
    push dx
    push cx
    push es
    push bp

        mov ah, 13h
        mov al, 00b
        mov bh, 1
        mov bl, 00000000b
        mov cx, [lenMadeBy]
        mov dh, [pos_madeBy]
        mov dl, [pos_madeBy + 1]
        push ds
        pop es
        mov bp, madeBY
        int 10h

        mov bl, 00001010b
        mov cx, [lenRollno]
        mov dh, [pos_rollNo]
        mov dl, [pos_rollNo + 1]
        mov bp, rollNo
        int 10h

        mov bl, 01001110b
        mov cx, [len_game_name]
        mov dh, [pos_welcom]
        mov dl, [pos_welcom + 1]
        mov bp, game_name
        int 10h

        mov cx, [lenScore]
        mov dh, [pos_score]
        mov dl, [pos_score + 1]
        mov bp, scoreMSG
        int 10h 
        call printScore

        mov cx, [lenEscape1]
        mov dh, 20
        mov dl, 7
        mov bp, exitHint1
        int 10h

        mov cx, [lenEscape2]
        mov dh, 21
        mov dl, 8
        mov bp, exitHint2
        int 10h

        mov cx, [lenEscape3]
        mov dh, 22
        mov dl, 6
        mov bp, exitHint3
        int 10h

    pop bp
    pop es
    pop cx
    pop dx
    pop bx
    pop ax
    ret

print_outline:
    push dx
    push bx
    push ax
    push cx
    push si
    push di

    mov dh, 0
    mov dl, [grid]
    mov si, dx
    mov dh, 0
    mov dl, [grid + 1]
    mov di, dx

    push si
    push di
    call setCursorPosition

        mov dx, 0
        mov dl, [grid + 3]
        sub dl, [grid + 1]
        mov cx, 1
        mov dh, 0

        mov ah, 09h
        mov al, '-'
        mov bl, 0x00
        mov bh, 1

    inc dl
    ups:
        int 10h
        inc di
        push si
        push di
        call setCursorPosition
        inc dh
        
        cmp dh, dl
        jne ups

        mov dh, 0
        dec dl
        sub dl, 25

    rights:
        int 10h
        inc si
        push si
        push di
        call setCursorPosition
        inc dh
       
        cmp dh, dl
        jne rights

        mov dh, 0
        add dl, 25

    inc dl
    bottoms:
        int 10h
        dec di
        push si
        push di
        call setCursorPosition
        inc dh
        
        cmp dh, dl
        jne bottoms

        mov dh, 0
        dec dl
        sub dl, 25

    lefts:
        int 10h
        dec si
        push si
        push di
        call setCursorPosition
        inc dh
      
        cmp dh, dl
        jne lefts   

    mov dh, 0

    add si, 2
    add di, 3

    mov [first_box], si 
    mov [first_box + 2], di 

    push si
    push di
    push word[candy_clrs]
    call print_bloc

  

    mov cx, 4

    right_fill1:
        add di, 8
        push si
        push di
        cmp cx, 4
        je ok_color
        cmp cx, 2
        je ok_color
        push word[candy_clrs]
        jmp wego1
        ok_color:
        push word[candy_clrs + 1]
        wego1:
        call print_bloc
        
        loop right_fill1

        add si, 4
        sub di, 32 
        push si
        push di
        push word[candy_clrs + 2]
        call print_bloc

        mov cx, 4

    right_fill2:
        add di, 8
        push si
        push di
        cmp cx, 4
        je ok_one_color
        cmp cx, 2
        je ok_one_color
        push word[candy_clrs + 2]
        jmp wego2
        ok_one_color:
        push word[candy_clrs + 3]
        wego2:
        call print_bloc
        loop right_fill2

       

        add si, 4
        sub di, 32 
        push si
        push di
        push word[candy_clrs + 4]
        call print_bloc

        mov cx, 4

    right_fill3:
        add di, 8
        push si
        push di
        cmp cx, 4
        je odd2Color
        cmp cx, 2
        je odd2Color
        push word[candy_clrs + 4]
        jmp wego3
        odd2Color:
        push word[candy_clrs + 5]
        wego3:
        call print_bloc
        loop right_fill3

      
        add si, 4
        sub di, 32 
        push si
        push di
        push word[candy_clrs + 1]
        call print_bloc

        mov cx, 4

    right_fill4:
        add di, 8
        push si
        push di
        cmp cx, 4
        je odd3Color
        cmp cx, 2
        je odd3Color
        push word[candy_clrs + 1]
        jmp wego4
        odd3Color:
        push word[candy_clrs]
        wego4:
        call print_bloc
        loop right_fill4

    pop di
    pop si
    pop cx
    pop ax
    pop bx
    pop dx
    ret

print_rand_bloc:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, [bp + 6] 
    mov di, [bp + 4] 

    push si
    push di
    call setCursorPosition

    sub sp, 2
    call generateRandomColor
    pop bx 

    mov ah, 09h
    mov al, ' '
    mov bh, 1
    mov dh, 0
    mov cx, 7 
    mov dl, 3 

    print_black:
        int 10h
        inc si
        push si
        push di
        call setCursorPosition
        inc dh
        cmp dh, dl
        jne print_black 

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4

print_bloc:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, [bp + 8] 
    mov di, [bp + 6] 

    push si
    push di
    call setCursorPosition

    mov bx, [bp + 4] 

    mov ah, 09h
    mov al, ' '
    mov bh, 1
    mov dh, 0
    mov cx, 7 
    mov dl, 3 

    print_boxes:
        int 10h
        inc si
        push si
        push di
        call setCursorPosition
        inc dh
        cmp dh, dl
        jne print_boxes 

     mov si, [bp + 8] 
     add si, 1
     add di, 3

     push si
     push di
     call setCursorPosition

     mov ah, 0Ah
     mov al, '#'
     mov bh, 1
     mov cx, 1
     int 10h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6

bomb:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, [bp + 6] 
    mov di, [bp + 4] 

    push si
    push di
    call setCursorPosition

    mov bl, 0 

    mov ah, 09h
    mov al, ' '
    mov bh, 1
    mov dh, 0
    mov cx, 7 
    mov dl, 3 

    print_final_bloc:
        int 10h
        inc si
        push si
        push di
        call setCursorPosition
        inc dh
        cmp dh, dl
        jne print_final_bloc

    mov bl, 00001110b
    mov ah, 09h
    mov al, '#'
    mov bh, 1

    mov si, [bp + 6] 
    add di, 3
    mov cx, 1
    push si
    push di
    call setCursorPosition
    int 10h

    inc si
    sub di, 1
    mov cx, 3
    push si
    push di
    call setCursorPosition
    int 10h

    inc si
    mov di, [bp + 4]
    mov cx, 7
    push si
    push di
    call setCursorPosition
    int 10h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4

printScore:

   pusha

    mov dh, 0
    mov dl, [pos_score]
    inc dl
    mov si, dx
    push si
    mov dl, [pos_score + 1]
    add dx, 4
    mov di, dx
    push di
    call setCursorPosition

    mov ax, [score]
    cmp ax, 0
    je print_zeross

    divide_it:
        mov dx, 0
        mov bx, 10
        div bx
        add dl, 0x30 

        push ax
        mov ah, 09h
        mov al, dl
        mov bh, 1
        mov bl, 1010b
        mov cx, 1
        int 10h
        pop ax

        dec di
        push si
        push di
        call setCursorPosition

        cmp ax, 0
        jne divide_it
        jmp end

    print_zeross:
        mov bh, 1
        mov bl, 1010b
        mov cx, 1
        mov ah, 09h
        mov al, '0'
        int 10h

    end:
    popa
    ret

setCursorPosition:
    push bp
    mov bp, sp
    push dx
    push bx
    push ax

    mov dh, [bp + 6]
    mov dl, [bp + 4]
    mov bh, 1 
    mov ah, 02h
    int 10h

    pop ax
    pop bx
    pop dx
    pop bp
    ret 4

setPageCursorPosition:
    push bp
    mov bp, sp
    push dx
    push bx
    push ax

    mov dh, [bp + 8]
    mov dl, [bp + 6]
    mov bh, [bp + 4]
    mov ah, 02h
    int 10h

    pop ax
    pop bx
    pop dx
    pop bp
    ret 6

changeScreen:

    push bp
    mov bp, sp
    push ax

    mov al, byte[bp + 4]
    mov ah, 0x05
    int 0x10

    pop ax
    pop bp
    ret 2

generateRandomColor:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    rdtsc 
    xor dx, dx
    mov cx, [len_colors]
    div cx
    mov bx, dx
    mov dx, [candy_clrs + bx] 
    mov [bp + 4], dx

    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

readColor:
    push bp
    mov bp, sp
    push bx
    push si
    push di

    mov si, [bp + 6]
    mov di, [bp + 4]

    push si
    push di
    call setCursorPosition

    mov al, 0
    mov ah, 08h
    mov bh, 1
    int 10h

    pop di
    pop si
    pop bx
    pop bp
    ret 4

    high_greet: db 'YOUR SCORE'
    graded_score: db ''
    game_name: db 'MATCH THE TILE'
    exitHint1: db 'Press'
    exitHint2: db 'ESC'
    exitHint3: db 'To Exit'
    madeBY: db 'MADE BY'
    rollNo: db '22L-7764'
    scoreMSG: db 'SCORE'
    lengraded_score:dw 0
    lenhigh_greet: dw 10
    lenMadeBy: dw 7
    lenRollno: dw 8
    len_game_name: dw 14
    lenEscape1: dw 5
    lenEscape2: dw 3
    lenEscape3: dw 7
    lenScore: dw 5

    countDown: db 3
    pos_rollNo: db 3, 3
    pos_madeBy: db 2, 3
    pos_welcom: db 1, 32
    pos_score: db 3, 72
    KbISR: dd 0

    grid: db 2, 18, 16, 50
    clr_grid: db 10010000b
    clr_selection: db 00001111b
    first_box: dw 0, 0 

    candy_clrs: db 0xdd, 0xcc, 0xee, 0xaa, 0xbb, 0x99
    len_colors: dw 6

    score: dw 0
