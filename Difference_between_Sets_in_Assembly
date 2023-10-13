[org 0x100]

jmp start


S1: dw -3, -1, 2, 5, 6, 8, 9
S2: dw -2, 2, 6, 7, 9 
S3: dw 0, 0, 0, 0, 0, 0, 0

size1: dw 14
size2: dw 10
size3: dw 14

comparesets:
push ax
push bx
push cx
push si
push di

mov cx, 0
mov si, -2
l1:
add si, 2
cmp si, [size1]
jae endit
mov ax, [S1+si]
mov di, 0
l2:
cmp ax, [S2+di]
je l1
add di, 2
cmp di, [size2]
jb l2

pushelelement:
xchg cx, di
mov [S3+di], ax
xchg cx, di
add cx, 2
jmp l1

endit:
pop di
pop si
pop cx
pop si
pop di

ret 2

start:
call comparesets


terminate:
mov ax, 0x4C00
int 0x21
L227503_Q1.ASM
