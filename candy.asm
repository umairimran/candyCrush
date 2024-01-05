[org 0x0100]
jmp start
;initializes the random values on board


printEndingScreen:
pusha

call clearscreen1
mov ah,0x13
 mov al,1
   mov bh,0
      mov bl,00110001b
   mov dx,0x0c27
   mov cx,13
   push cs
   pop es
   mov bp,endingMessage
   int 0x10

popa
ret

printBoundary:
pusha
mov ax,0xb800
mov es,ax
mov di,0
mov ah,00011110b
mov al,0x3
pp1:
mov word[es:di],ax
add di,2
cmp di,158
jne pp1

pp2:
mov word[es:di],ax
add di,160
cmp di,3998
jne pp2

pp3:
mov word[es:di],ax
sub di,2
cmp di,3840
jne pp3

pp4:
mov word[es:di],ax
sub di,160
cmp di,0
jne pp4


popa
ret


printCandies:
 pusha
  mov ax,0xb800
  mov es,ax
  mov di,372
  mov cx,8
  mov si,0
  mov dx,8
  printOuterLoop:
     mov cx,8
     printInnerLoop:
      mov ax,[board+si]
      add si,2
      call setAttribute   ; in bh
      mov word[es:di],bx
      add di,8
      sub cx,1
      jnz printInnerLoop
    sub di,64
    add di,480
    dec dx
    jnz printOuterLoop
      
 popa
 ret

setAttribute:
 ;ax mai element hai
 ; bh mai attribute rakhna hai
 s1:
 cmp al,0x40
 jne s2
 mov bh,00111010b   ;green with white background
  mov  bl,0x1
 jmp exitSetAttribute

 ;mov bl,al
 s2:
 cmp al,0x24
 jne s3
 mov bh,00111100b  ; red
 mov  bl,0x2
 ;mov bl,al
 jmp exitSetAttribute
 s3:
 cmp al,0x23
 jne s4
 mov bh,00111110b  ;yellow
 mov  bl,0x3
 ;mov bl,al
 jmp exitSetAttribute
 s4:
 cmp al,0x25
 jne s5
 mov bh,00111111b ; white
  mov  bl,0x4
 ;mov bl,al
 jmp exitSetAttribute
 s5:
 
 mov bh,00111101b  ; unknown
mov  bl,0x5
;  mov bl,al
 ;add bl,0x30
 exitSetAttribute:
 ret
printUI:
 pusha
 call clearscreen1
 mov ax,0xb800
 mov es,ax

 boundary:
 mov di,0
 mov ah,01001011b
 mov al,0x20
 b1:
 mov word[es:di],ax
 add di,2
 cmp di,160
 jne b1
 mov di,0
 b2:
 mov word[es:di],ax
 add di,160
 cmp di,3840
 jne b2
 b3:
 mov word[es:di],ax
 add di,2
 cmp di,3998
 jne b3
 b4:
 mov word[es:di],ax
 sub di,160
 cmp di,158
 jne b4
  mov ah,00111011b
 mov al,0x20
 boxes:
 mov di,210
 bx1:

  mov si,di
  add si,160
  call box
 add di,480
 cmp di,4050
 jne bx1


  mov di,218
 bx2:

  mov si,di
  add si,160
  call box
 add di,480
 cmp di,4058
 jne bx2

  mov di,226
 bx3:

  mov si,di
  add si,160
  call box
  add di,480
  cmp di,4066
  jne bx3

  mov di,234
 bx4:

  mov si,di
  add si,160
  call box
 add di,480
 cmp di,4074
 jne bx4
 
   mov di,242
 bx5:

  mov si,di
  add si,160
  call box
 add di,480
 cmp di,4082
 jne bx5

   mov di,250
 bx6:

  mov si,di
  add si,160
  call box
 add di,480
 cmp di,4090
 jne bx6
    mov di,258
 bx7:

  mov si,di
  add si,160
  call box
 add di,480
 cmp di,4098
 jne bx7
    mov di,266
 bx8:

  mov si,di
  add si,160
  call box
 add di,480
 cmp di,4106
 jne bx8

 
 call printCandies
 popa
 ret
 box:
 pusha
 mov bx,0xb800
 mov es,bx
 add si,160
 boxLoop:
 mov word[es:di],ax
  mov word[es:di],ax
 mov word[es:di+2],ax
 mov word[es:di+4],ax
 add di,160
 cmp di,si
 jne boxLoop
 
 indexing:
   mov di,52
   mov ax,0xb800
   mov es,ax
   mov bh,01001111b
   mov bl,48
   i11:
   mov word[es:di],bx
   add bl,1
   add di,8
   cmp di,116
   jne i11
    mov bh,00011111b
   mov bl,48
   mov di,206
   i22:
    mov word[es:di],bx
    add di,480
    add bl,1
    cmp di,4046
    jne i22

   mov ah,0x13
   mov al,1
   mov bh,0
   mov bl,00011100b
   mov dx,0x0139
   mov cx,17
   push cs
   pop es
   mov bp,movesMessage
   int 0x10

   mov ax,0xb800
   mov es,ax
   mov  al,[moves]
   add al,0x30
   mov ah,00111111b
   mov word[es:308],ax

  mov ah,0x13
   mov al,1
   mov bh,0
   mov bl,00011100b
   mov dx,0x0339
   mov cx,8
   push cs
   pop es
   mov bp,scoreMessage
   int 0x10

   mov ax,0xb800
   mov es,ax
   mov  al,[score]
   add al,0x30
   mov ah,00111111b
   mov word[es:618],ax


 popa
 ret
clearscreen1:
    push ax
    push es
    push di
    push cx
    mov ax,0xb800
    mov es,ax
    xor di,di
    mov cx,2000
    mov ah,10011100b
    mov al,0x20
    rep stosw
    pop cx
    pop di
    pop es
    pop ax
    ret



findPatternInCols5:
 pusha
 ;pass a parameter that will decide wheter to check for four or 5

 mov bx,0
 col1111:

 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 mov si,[board+bx+64]
 call checkPattern22   ; for columns
 add bx,16
 cmp bx,64
 jne col1111

 mov bx,2
 
 col2222:
 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 mov si,[board+bx+64]
  call checkPattern22
 add bx,16
 cmp bx,66
 jne col2222

 mov bx,4
 col3333:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 mov si,[board+bx+64]
 call checkPattern22
 add bx,16
 cmp bx,68
 jne col3333

 mov bx,6
 col4444:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 mov si,[board+bx+64]
 call checkPattern22
 add bx,16
 cmp bx,70
 jne col4444


 mov bx,8
 col5555:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 mov si,[board+bx+64]
 call checkPattern22
 add bx,16
 cmp bx,72
 jne col5555


 mov bx,10
 col6666:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 mov si,[board+bx+64]
 call checkPattern22
 add bx,16
 cmp bx,74
 jne col6666

 mov bx,12
 col7777:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 mov si,[board+bx+64]
 call checkPattern22
 add bx,16
 cmp bx,76
 jne col7777

 mov bx,14
 col8888:
 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 mov si,[board+bx+64]
 call checkPattern2
 add bx,16
 cmp bx,78
 jne col8888
 popa
 ret

checkPattern1:  ; this recieves ax,bx,cx,dx,di in same condition and it will return them as same condition after doing processing
 pusha
 mov word[patternFound],0
 cmp ax,cx
 jne exitCheckPattern1
 cmp ax,dx
 jne exitCheckPattern1
 cmp ax,di
 jne exitCheckPattern1
 cmp ax,si
 jne exitCheckPattern1
 mov word[bombFlag],1
 mov word[bombActivatorELement],ax
 call applyBombFunction
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+2],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+4],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+6],ax
 mov word[patternFound],1
  push 2000
 call sound
   push 2000
 call sound
   push 2000
 call sound
  add word[score],1
 exitCheckPattern1:
 popa
 ret

checkPattern22:  ; this recieves ax,bx,cx,dx,di in same condition and it will return them as same condition after doing processing
 pusha
 mov word[patternFound],0
 cmp ax,cx
 jne exitCheckPattern22
 cmp ax,dx
 jne exitCheckPattern22
 cmp ax,di
 jne exitCheckPattern22
 cmp ax,si
 jne exitCheckPattern22
 mov word[bombFlag],1
 mov word[bombActivatorELement],ax
 call applyBombFunction
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+16],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+32],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+48],ax
 mov word[patternFound],1
 push 2000
 call sound
  push 2000
 call sound
  push 2000
 call sound
  add word[score],1
 exitCheckPattern22:
 popa
 ret



findPatternInRows5:
 pusha
 ;pass a parameter that will decide wheter to check for four or 5

 mov bx,0
 row1111:

 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 mov si,[board+bx+8]
 call checkPattern1  ; for rows
 add bx,2
 cmp bx,8
 jne row1111

 mov bx,16
 
 row2222:
 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 mov si,[board+bx+8]
 call checkPattern1
 add bx,2
 cmp bx,24
 jne row2222

 mov bx,32
 row3333:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 mov si,[board+bx+8]
 call checkPattern1
 add bx,2
 cmp bx,40
 jne row3333

 mov bx,48
 row4444:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 mov si,[board+bx+8]
 call checkPattern1
 add bx,2
 cmp bx,56
 jne row4444


 mov bx,64
 row5555:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 mov si,[board+bx+8]
 call checkPattern1
 add bx,2
 cmp bx,72
 jne row5555


 mov bx,80
 row6666:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 mov si,[board+bx+8]
 call checkPattern1
 add bx,2
 cmp bx,88
 jne row6666

 mov bx,96
 row7777:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 mov si,[board+bx+8]
 call checkPattern1
 add bx,2
 cmp bx,104
 jne row7777

 mov bx,112
 row8888:
 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 mov si,[board+bx+8]
 call checkPattern1
 add bx,2
 cmp bx,120
 jne row8888
 popa
 ret



newGame:
 pusha
 ;call printStartingScreen
 call initializeBoard
 
 ;call printBoard
 popa
 ret
getIndexFromRowsCols:  ; bp+4=col ; bp+6=row
firstRow:
 push bp
 mov bp,sp
 r00:
 cmp word[bp+6],0
 jne r01
 cmp word[bp+4],0
 jne r01
 mov di,0
 jmp exitGetIndexFromRowsCols
 r01:
  cmp word[bp+6],0
 jne r02
 cmp word[bp+4],1
 jne r02
 mov di,2
 jmp exitGetIndexFromRowsCols
 r02:
   cmp word[bp+6],0
 jne r03
 cmp word[bp+4],2
 jne r03
 mov di,4
 jmp exitGetIndexFromRowsCols
 r03:
   cmp word[bp+6],0
 jne r04
 cmp word[bp+4],3
 jne r04
 mov di,6
 jmp exitGetIndexFromRowsCols
 r04:
 cmp word[bp+6],0
 jne r05
 cmp word[bp+4],4
 jne r05
 mov di,8
 jmp exitGetIndexFromRowsCols
 r05:
  cmp word[bp+6],0
 jne r06
 cmp word[bp+4],5
 jne r06
 mov di,10
 jmp exitGetIndexFromRowsCols
 r06:
  cmp word[bp+6],0
 jne r07
 cmp word[bp+4],6
 jne r07
 mov di,12
 jmp exitGetIndexFromRowsCols
 r07:
  cmp word[bp+6],0
 jne r10
 cmp word[bp+4],7
 jne r10
 mov di,14
 jmp exitGetIndexFromRowsCols

secondRow:
 r10:
   cmp word[bp+6],1
 jne r11
 cmp word[bp+4],0
 jne r11
 mov di,16
 jmp exitGetIndexFromRowsCols
 r11:
   cmp word[bp+6],1
 jne r12
 cmp word[bp+4],1
 jne r12
 mov di,18
 jmp exitGetIndexFromRowsCols
 r12:
   cmp word[bp+6],1
 jne r13
 cmp word[bp+4],2
 jne r13
 mov di,20
 jmp exitGetIndexFromRowsCols
 r13:
   cmp word[bp+6],1
 jne r14
 cmp word[bp+4],3
 jne r14
 mov di,22
 jmp exitGetIndexFromRowsCols
 r14:
   cmp word[bp+6],1
 jne r15
 cmp word[bp+4],4
 jne r15
 mov di,24
 jmp exitGetIndexFromRowsCols
 r15:
   cmp word[bp+6],1
 jne r16
 cmp word[bp+4],5
 jne r16
 mov di,26
 jmp exitGetIndexFromRowsCols
 r16:
   cmp word[bp+6],1
 jne r17
 cmp word[bp+4],6
 jne r17
 mov di,28
 jmp exitGetIndexFromRowsCols
 r17:
   cmp word[bp+6],1
 jne r20
 cmp word[bp+4],7
 jne r20
 mov di,30
 jmp exitGetIndexFromRowsCols

row3:
 r20:
    cmp word[bp+6],2
 jne r21
 cmp word[bp+4],0
 jne r21
 mov di,32
 jmp exitGetIndexFromRowsCols
 r21:
    cmp word[bp+6],2
 jne r22
 cmp word[bp+4],1
 jne r22
 mov di,34
 jmp exitGetIndexFromRowsCols
 r22:
    cmp word[bp+6],2
 jne r23
 cmp word[bp+4],2
 jne r23
 mov di,36
 jmp exitGetIndexFromRowsCols
 r23:
    cmp word[bp+6],2
 jne r24
 cmp word[bp+4],3
 jne r24
 mov di,38
 jmp exitGetIndexFromRowsCols
 r24:
    cmp word[bp+6],2
 jne r25
 cmp word[bp+4],4
 jne r25
 mov di,40
 jmp exitGetIndexFromRowsCols
 r25:
    cmp word[bp+6],2
 jne r26
 cmp word[bp+4],5
 jne r26
 mov di,42
 jmp exitGetIndexFromRowsCols
 r26:
    cmp word[bp+6],2
 jne r27
 cmp word[bp+4],6
 jne r27
 mov di,44
 jmp exitGetIndexFromRowsCols
 r27:
    cmp word[bp+6],2
 jne r30
 cmp word[bp+4],7
 jne r30
 mov di,46
 jmp exitGetIndexFromRowsCols

row4:
 r30:
    cmp word[bp+6],3
 jne r31
 cmp word[bp+4],0
 jne r31
 mov di,48
 jmp exitGetIndexFromRowsCols
 r31:
    cmp word[bp+6],3
 jne r32
 cmp word[bp+4],1
 jne r32
 mov di,50
 jmp exitGetIndexFromRowsCols
 r32:
    cmp word[bp+6],3
 jne r33
 cmp word[bp+4],2
 jne r33
 mov di,52
 jmp exitGetIndexFromRowsCols
 r33:
    cmp word[bp+6],3
 jne r34
 cmp word[bp+4],3
 jne r34
 mov di,54
 jmp exitGetIndexFromRowsCols
 r34:
    cmp word[bp+6],3
 jne r35
 cmp word[bp+4],4
 jne r35
 mov di,56
 jmp exitGetIndexFromRowsCols
 r35:
    cmp word[bp+6],3
 jne r36
 cmp word[bp+4],5
 jne r36
 mov di,58
 jmp exitGetIndexFromRowsCols
 r36:
    cmp word[bp+6],3
 jne r37
 cmp word[bp+4],6
 jne r37
 mov di,60
 jmp exitGetIndexFromRowsCols
 r37:
    cmp word[bp+6],3
 jne r40
 cmp word[bp+4],7
 jne r40
 mov di,62
 jmp exitGetIndexFromRowsCols
row5:
 r40:
     cmp word[bp+6],4
 jne r41
 cmp word[bp+4],0
 jne r41
 mov di,64
 jmp exitGetIndexFromRowsCols
 
 r41:
     cmp word[bp+6],4
 jne r42
 cmp word[bp+4],1
 jne r42
 mov di,66
 jmp exitGetIndexFromRowsCols
 r42:
     cmp word[bp+6],4
 jne r43
 cmp word[bp+4],2
 jne r43
 mov di,68
 jmp exitGetIndexFromRowsCols
 r43:
     cmp word[bp+6],4
 jne r44
 cmp word[bp+4],3
 jne r44
 mov di,70
 jmp exitGetIndexFromRowsCols
 r44:
     cmp word[bp+6],4
 jne r45
 cmp word[bp+4],4
 jne r45
 mov di,72
 jmp exitGetIndexFromRowsCols
 r45:
     cmp word[bp+6],4
 jne r46
 cmp word[bp+4],5
 jne r46
 mov di,74
 jmp exitGetIndexFromRowsCols
 r46:
     cmp word[bp+6],4
 jne r47
 cmp word[bp+4],6
 jne r47
 mov di,76
 jmp exitGetIndexFromRowsCols
 r47:
     cmp word[bp+6],4
 jne r50
 cmp word[bp+4],7
 jne r50
 mov di,78
 jmp exitGetIndexFromRowsCols
row6:


 r50:
     cmp word[bp+6],5
 jne r51
 cmp word[bp+4],0
 jne r51
 mov di,80
 jmp exitGetIndexFromRowsCols
 r51:
     cmp word[bp+6],5
 jne r52
 cmp word[bp+4],1
 jne r52
 mov di,82
 jmp exitGetIndexFromRowsCols
 r52:
  cmp word[bp+6],5
 jne r53
 cmp word[bp+4],2
 jne r53
 mov di,84
 jmp exitGetIndexFromRowsCols
 r53:
     cmp word[bp+6],5
 jne r54
 cmp word[bp+4],3
 jne r54
 mov di,86
 jmp exitGetIndexFromRowsCols
 r54:
     cmp word[bp+6],5
 jne r55
 cmp word[bp+4],4
 jne r55
 mov di,88
 jmp exitGetIndexFromRowsCols
 r55:
     cmp word[bp+6],5
 jne r56
 cmp word[bp+4],5
 jne r56
 mov di,90
 jmp exitGetIndexFromRowsCols
 r56:
     cmp word[bp+6],5
 jne r57
 cmp word[bp+4],6
 jne r57
 mov di,92
 jmp exitGetIndexFromRowsCols
 r57:
     cmp word[bp+6],5
 jne r60
 cmp word[bp+4],7
 jne r60
 mov di,94
 jmp exitGetIndexFromRowsCols

row7:


 r60:
     cmp word[bp+6],6
 jne r61
 cmp word[bp+4],0
 jne r61
 mov di,96
 jmp exitGetIndexFromRowsCols
 r61:
     cmp word[bp+6],6
 jne r62
 cmp word[bp+4],1
 jne r62
 mov di,98
 jmp exitGetIndexFromRowsCols
 r62:
     cmp word[bp+6],6
 jne r63
 cmp word[bp+4],2
 jne r63
 mov di,100
 jmp exitGetIndexFromRowsCols
 r63:
     cmp word[bp+6],6
 jne r64
 cmp word[bp+4],3
 jne r64
 mov di,102
 jmp exitGetIndexFromRowsCols
 r64:
     cmp word[bp+6],6
 jne r65
 cmp word[bp+4],4
 jne r65
 mov di,104
 jmp exitGetIndexFromRowsCols
 r65:
     cmp word[bp+6],6
 jne r66
 cmp word[bp+4],5
 jne r66
 mov di,106
 jmp exitGetIndexFromRowsCols
 r66:
     cmp word[bp+6],6
 jne r67
 cmp word[bp+4],6
 jne r67
 mov di,108
 jmp exitGetIndexFromRowsCols
 r67:
     cmp word[bp+6],6
 jne r70
 cmp word[bp+4],7
 jne r70
 mov di,110
 jmp exitGetIndexFromRowsCols

row8:
 r70:
     cmp word[bp+6],7
 jne r71
 cmp word[bp+4],0
 jne r71
 mov di,112
 jmp exitGetIndexFromRowsCols
 r71:
     cmp word[bp+6],7
 jne r72
 cmp word[bp+4],1
 jne r72
 mov di,114
 jmp exitGetIndexFromRowsCols
 r72:
     cmp word[bp+6],7
 jne r73
 cmp word[bp+4],2
 jne r73
 mov di,116
 jmp exitGetIndexFromRowsCols
 r73:  
 cmp word[bp+6],7
 jne r74
 cmp word[bp+4],3
 jne r74
 mov di,118
 jmp exitGetIndexFromRowsCols
 r74:
     cmp word[bp+6],7
 jne r75
 cmp word[bp+4],4
 jne r75
 mov di,120
 jmp exitGetIndexFromRowsCols
 r75:
     cmp word[bp+6],7
 jne r76
 cmp word[bp+4],5
 jne r76
 mov di,122
 jmp exitGetIndexFromRowsCols
 r76:
     cmp word[bp+6],7
 jne r77
 cmp word[bp+4],6
 jne r77
 mov di,124
 jmp exitGetIndexFromRowsCols
 r77:
     cmp word[bp+6],7
 jne exitGetIndexFromRowsCols
 cmp word[bp+4],7
 jne exitGetIndexFromRowsCols
 mov di,126
 jmp exitGetIndexFromRowsCols

exitGetIndexFromRowsCols:
pop bp
ret 4



checkPattern3:  ; this recieves ax,bx,cx,dx,di in same condition and it will return them as same condition after doing processing
 pusha
 mov word[patternFound],0
 cmp ax,cx
 jne exitCheckPattern3
 cmp ax,dx
 jne exitCheckPattern3
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+2],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+4],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 ;mov word[board+bx+6],ax
 mov word[patternFound],1
 push 2000
 call sound
 add word[score],1
 exitCheckPattern3:
 popa
 ret



findPatternInRows3:
 pusha
 ;pass a parameter that will decide wheter to check for four or 5

 mov bx,0
 row11111:

 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 call checkPattern3   ; for rows
 add bx,2
 cmp bx,12
 jne row11111

 mov bx,16
 
 row22222:
 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 call checkPattern3
 add bx,2
 cmp bx,28
 jne row22222

 mov bx,32
 row33333:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 call checkPattern3
 add bx,2
 cmp bx,44
 jne row33333

 mov bx,48
 row44444:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 call checkPattern3
 add bx,2
 cmp bx,60
 jne row44444


 mov bx,64
 row55555:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 call checkPattern3
 add bx,2
 cmp bx,76
 jne row55555


 mov bx,80
 row66666:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 call checkPattern3
 add bx,2
 cmp bx,92
 jne row66666

 mov bx,96
 row77777:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 call checkPattern3
 add bx,2
 cmp bx,108
 jne row77777

 mov bx,112
 row88888:
 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 call checkPattern3
 add bx,2
 cmp bx,124
 jne row88888
 popa
 ret



findPatternInCols:
 pusha
 ;pass a parameter that will decide wheter to check for four or 5

 mov bx,0
 col111:

 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 call checkPattern2   ; for columns
 add bx,16
 cmp bx,80
 jne col111

 mov bx,2
 
 col222:
 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 call checkPattern2
 add bx,16
 cmp bx,82
 jne col222

 mov bx,4
 col333:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 call checkPattern2
 add bx,16
 cmp bx,84
 jne col333

 mov bx,6
 col444:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 call checkPattern2
 add bx,16
 cmp bx,86
 jne col444


 mov bx,8
 col555:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 call checkPattern2
 add bx,16
 cmp bx,88
 jne col555


 mov bx,10
 col666:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 call checkPattern2
 add bx,16
 cmp bx,90
 jne col666

 mov bx,12
 col777:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 call checkPattern2
 add bx,16
 cmp bx,92
 jne col777

 mov bx,14
 col888:
 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 mov di,[board+bx+48]
 call checkPattern2
 add bx,16
 cmp bx,94
 jne col888
 popa
 ret

checkPattern:  ; this recieves ax,bx,cx,dx,di in same condition and it will return them as same condition after doing processing
 pusha
 mov word[patternFound],0
 cmp ax,cx
 jne exitCheckPattern
 cmp ax,dx
 jne exitCheckPattern
 cmp ax,di
 jne exitCheckPattern
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+2],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+4],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+6],ax
 mov word[patternFound],1
 push 2000
 call sound
 add word[score],1
 exitCheckPattern:
 popa
 ret

checkPattern2:  ; this recieves ax,bx,cx,dx,di in same condition and it will return them as same condition after doing processing
 pusha
 mov word[patternFound],0
 cmp ax,cx
 jne exitCheckPattern2
 cmp ax,dx
 jne exitCheckPattern2
 cmp ax,di
 jne exitCheckPattern2
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+16],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+32],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+48],ax
 mov word[patternFound],1
 push 2000
 call sound
  add word[score],1
 exitCheckPattern2:
 popa
 ret



checkPattern33:  ; this recieves ax,bx,cx,dx,di in same condition and it will return them as same condition after doing processing
 pusha
 mov word[patternFound],0
 cmp ax,cx
 jne exitCheckPattern33
 cmp ax,dx
 jne exitCheckPattern33
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+16],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 mov word[board+bx+32],ax
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 ;mov word[board+bx+48],ax
 mov word[patternFound],1
 push 2000
 call sound
  add word[score],1
 exitCheckPattern33:
 popa
 ret


findPatternInCols3:
 pusha
 ;pass a parameter that will decide wheter to check for four or 5

 mov bx,0
 col111111:

 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 
 call checkPattern33   ; for columns
 add bx,16
 cmp bx,96
 jne col111111

 mov bx,2
 
 col222222:
 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]

 call checkPattern33
 add bx,16
 cmp bx,98
 jne col222222

 mov bx,4
 col333333:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]

 call checkPattern33
 add bx,16
 cmp bx,100
 jne col333333

 mov bx,6
 col444444:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]

 call checkPattern33
 add bx,16
 cmp bx,102
 jne col444444


 mov bx,8
 col555555:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 
 call checkPattern33
 add bx,16
 cmp bx,104
 jne col555555


 mov bx,10
 col666666:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]

 call checkPattern33
 add bx,16
 cmp bx,106
 jne col666666

 mov bx,12
 col777777:
  mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]

 call checkPattern33
 add bx,16
 cmp bx,108
 jne col777777

 mov bx,14
 col888888:
 mov ax,[board+bx]
 mov cx,[board+bx+16]
 mov dx,[board+bx+32]
 call checkPattern33
 add bx,16
 cmp bx,110
 jne col888888
 popa
 ret















findPatternInRows:
 pusha
 ;pass a parameter that will decide wheter to check for four or 5

 mov bx,0
 row111:

 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 call checkPattern   ; for rows
 add bx,2
 cmp bx,10
 jne row111

 mov bx,16
 
 row222:
 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 call checkPattern
 add bx,2
 cmp bx,26
 jne row222

 mov bx,32
 row333:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 call checkPattern
 add bx,2
 cmp bx,42
 jne row333

 mov bx,48
 row444:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 call checkPattern
 add bx,2
 cmp bx,58
 jne row444


 mov bx,64
 row555:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 call checkPattern
 add bx,2
 cmp bx,74
 jne row555


 mov bx,80
 row666:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 call checkPattern
 add bx,2
 cmp bx,90
 jne row666

 mov bx,96
 row777:
  mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 call checkPattern
 add bx,2
 cmp bx,106
 jne row777

 mov bx,112
 row888:
 mov ax,[board+bx]
 mov cx,[board+bx+2]
 mov dx,[board+bx+4]
 mov di,[board+bx+6]
 call checkPattern
 add bx,2
 cmp bx,122
 jne row888
 popa
 ret


makeMove:

 ;first push row 
 ;then push column
 ;row ax
 ;col dx
 ;si source index
 ; di destination index
 ; cx source content
 ; dx destination content
 pusha
 call validMove
 ;call validMoveOneRowOneColStepCheck
 cmp word[isValid],0
 je exitMakeMoveWithoutMakingMove
 push word[row1]
 push word[col1]
 call getIndexFromRowsCols
 mov cx,[board+di]
 push di
 push word[row2]
 push word[col2]
 call getIndexFromRowsCols
 mov dx,[board+di]

 ;xchanging the source and destination
 mov word[board+di],cx
 mov word[undoSourceIndex],di
 mov word[undoSourceElement],cx
 pop di
 mov word[board+di],dx
 mov word[undoDestIndex],di
 mov word[undoDestElement],dx
 

 
 call findPatternInRows5
 call findPatternInCols5
 
 cmp word[bombFlag],1
 je exitMakeMoveWithoutMakingMove
 furtherCheckingOfPattern:
 call findPatternInRows
 call findPatternInCols
 call findPatternInRows3
 call findPatternInCols3
  
 ;call undoMove
 exitMakeMoveWithoutMakingMove:
  mov word[bombFlag],0
 popa 
 ret

applyBombFunction:
 pusha
  mov si,0
  mov ax,[bombActivatorELement]
  bombLoop:
   add si,2
   mov bx,[board+si]
   cmp bx,ax
   jne continueSearching
   push ax
   call GenRandNum
   mov di,dx
   mov ah,0
   mov al,[symbols+di]
   mov word[board+si],ax
   pop ax
   continueSearching:
   cmp si,128
   jne bombLoop

   call printBombMessage
   push 1000
   call sound
   
 popa
 ret



sound:
	push bp
	mov bp, sp
	push ax

	mov al, 182
	out 0x43, al
	mov ax, [bp + 4]   ; frequency
	out 0x42, al
	mov al, ah
	out 0x42, al
	in al, 0x61
	or al, 0x03
	out 0x61, al
call delay
call delay
call delay
call delay
call delay
call delay
	in al, 0x61

	and al, 0xFC
	out 0x61, al

	pop ax
	pop bp
  ret 2
printBombMessage:
    mov ah,0x13
   mov al,1
   mov bh,0
   mov bl,10011100b
   mov dx,0x0301
   mov cx,7
   push cs
   pop es
   mov bp,bombMessage
   int 0x10
ret
validMoveOneRowOneColStepCheck:
  cmp word[isValid],1
  je exitValidMoveRowColStepCheckSettingIsValidFalse
  rowUpStep:
  cmp word[row1],0
  je rowDownStep
  mov ax,[row1]
  sub ax,1
  cmp ax,[row2]
  je colRightStep
  jmp exitValidMoveRowColStepCheckSettingIsValidFalse

  rowDownStep:
  cmp word[row1],7
  je colRightStep
  mov ax,[row1]
  add ax,1
  cmp ax,[row2]
  je colRightStep
  jmp exitValidMoveRowColStepCheckSettingIsValidFalse

  colRightStep:
  cmp word[col1],7
  je colLeftStep
  mov ax,[col1]
  add ax,1
  cmp ax,[col2]
  jne exitValidMoveRowColStepCheckSettingIsValidFalse
  je exitValidMoveRowColStepCheckSettingIsValidTrue

  colLeftStep:
  cmp word[col1],0
  je exitValidMoveRowColStepCheckSettingIsValidFalse
  mov ax,[col1]
  sub ax,1
  cmp ax,[col2]
  jne exitValidMoveRowColStepCheckSettingIsValidFalse
  je exitValidMoveRowColStepCheckSettingIsValidTrue
  
  exitValidMoveRowColStepCheckSettingIsValidTrue:
  mov word[isValid],1
  jmp exit2
  exitValidMoveRowColStepCheckSettingIsValidFalse:
  mov word[isValid],0
  exit2:
  ret

undoMove:
 
 pusha
 cmp word[patternFound],1
 je exitUndoMove
 mov si,[undoSourceIndex]
 mov di,[undoDestIndex]
 mov ax,[board+si]
 mov bx,[board+di]
 mov word[board+si],bx
 mov word[board+di],ax

 jmp exitUnDoMove
 exitUndoMove:

 add word[score],1
 exitUnDoMove:
 popa
 ret



validMove:
 pusha
 boundsCheck:
 mov word[isValid],0
  rowTopSide:
  cmp word[row1],0
  jl exitValidMoveBySettingValidFalse
  cmp word[row2],0
  jl exitValidMoveBySettingValidFalse
  rowBottomSide:
  cmp word[ row1],7
  jg exitValidMoveBySettingValidFalse
  cmp word[row2],7
  jg exitValidMoveBySettingValidFalse
  colLeftSide:
  cmp  word[col1],0
  jl exitValidMoveBySettingValidFalse
  cmp word[col2],0
  jl exitValidMoveBySettingValidFalse
  colRightSide:
  cmp word[col1],7
  jg exitValidMoveBySettingValidFalse
  cmp word[col2],7
  jg exitValidMoveBySettingValidFalse



     call checkRowColStep
    cmp word[isValid],0
   je exitValidMoveBySettingValidFalse
   mov word[isValid],1
   jmp exitValidMoveBySettingValidTrue
 exitValidMoveBySettingValidFalse:
   call printInValidMove
 mov word[isValid],0
 exitValidMoveBySettingValidTrue:
 popa
 ret
checkRowColStep:
pusha
    mov ax,[row1]
    mov bx,[row2]
    mov cx,[col1]
    mov dx,[col2]
    comparison1:
       up:
       add bx,1
       cmp bx,ax
       jne down
       cmp cx,dx
       jne down
       mov word[isValid],1
       jmp exitCheckRowColStep

       down:
          mov ax,[row1]
          mov bx,[row2]
          mov cx,[col1]
          mov dx,[col2]  
          sub bx,1
          cmp bx,ax
          jne right
          cmp dx,cx
          jne right
          mov word[isValid],1
          jmp exitCheckRowColStep   
        right:
              mov ax,[row1]
             mov bx,[row2]
              mov cx,[col1]
              mov dx,[col2]
              cmp ax,bx
              jne left
              sub dx,1
              cmp dx,cx
              jne left
              mov word[isValid],1
              jmp exitCheckRowColStep
        left: 
            mov ax,[row1]
            mov bx,[row2]
            mov cx,[col1]
            mov dx,[col2]
            cmp ax,bx
            jne exitCheckRowColStep
            add dx,1
            cmp dx,cx
            jne exitCheckRowColStep
            mov word[isValid],1
            jmp exitCheckRowColStep
   exitCheckRowColStep:
   popa
  ret
printInValidMove:
    mov ah,0x13
   mov al,1
   mov bh,0
   mov bl,00011100b
   mov dx,0x0c3e
   mov cx,15
   push cs
   pop es
   mov bp,invalidMessage
   int 0x10

ret

initializeBoard:
 pusha
 row11:  ;  0 to 14
 mov bx,0
 i1:
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 call delay
 mov word[board+bx],ax
 add bx,2
 cmp bx,16
 jne i1

 row22:   ;16 to 30
 mov bx,16
 i2:
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 call delay
 mov word[board+bx],ax
 add bx,2
 cmp bx,32
 jne i2


 row33:  ;32 to 46
 mov bx,32
 i3:
  call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 call delay
 mov word[board+bx],ax
 add bx,2
 cmp bx,48
 jne i3


 row44: ;48 to 62
 mov bx,48
 i4: 
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 call delay
 mov word[board+bx],ax
 add bx,2
 cmp bx,64
 jne i4

 row55:  ;64 to 78
 mov bx,64
 i5:
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 call delay
 mov word[board+bx],ax
 add bx,2
 cmp bx,80
 jne i5



 row66:  ;80 to 94
 mov bx,80
 i6:
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 call delay
 mov word[board+bx],ax
 add bx,2
 cmp bx,96
 jne i6

 



 row77:  ;96 to 110
 mov bx,96
 i7:
 call GenRandNum
 mov si,dx
 mov ah,0
 mov al,[symbols+si]
 call delay
 mov word[board+bx],ax
 add bx,2
 cmp bx,112
 jne i7



 row88:  ;112 to 126
 mov bx,112
 i8:
 call GenRandNum
  mov si,dx
 mov ah,0
 mov al,[symbols+si]
 call delay
 mov word[board+bx],ax
 add bx,2
 cmp bx,128
 jne i8 
 popa
 ret
delay:
    push ax

    mov ax,0xffff
    ll:
    sub ax,1
    cmp ax,0
    jne ll
    pop ax
    ret
GenRandNum:
    call delay
    push bp
    mov bp,sp;
    push cx
    push ax


    MOV AH, 00h ; interrupts to get system time
    INT 1AH ; CX:DX now hold number of clock ticks since midnight
    mov ax, dx
    xor dx, dx
    mov cx, 5;
    div cx ; here dx contains the remainder of the division - from 0 to 9

    ;add dl, '0' ; to ascii from '0' to '9'




    pop cx;
    pop ax;

    pop bp;
    ret
green:
  pusha

  green1:

  mov di,0
  mov si,3840
  call linePrint
  call delay

  mov di,2
  mov si,3842
  call linePrint
  call delay
  mov di,4
  mov si,3844
  call linePrint
  call delay
  mov di,6
  mov si,3846
  call linePrint
  call delay
  mov di,8
  mov si,3848
  call linePrint
call delay
mov di,10
mov si,3850
call linePrint
call delay

mov di,172
mov si,3692
call linePrint
call delay

mov di,334
mov si,3534
call linePrint
call delay

mov di,496
mov si,3376
call linePrint
call delay

mov di,658
mov si,3218
call linePrint
call delay

mov di,820
mov si,3060
call linePrint


mov di,982
mov si,3062
call linePrint
call delay

mov di,1144
mov si,2904
call linePrint

mov di,1306
mov si,2746
call linePrint
call delay

mov di,1468
mov si,2588
call linePrint
call delay

mov di,1630
mov si,2430
call linePrint
call delay

mov di,1792
mov si,2272
call linePrint
call delay

mov di,1954
mov si,2274
call linePrint
call delay


green2:
mov di,158
mov si,3998
call linePrint
call delay
mov di,156
mov si,3996
call linePrint
call delay

mov di,154
mov si,3994
call linePrint
call delay

mov di,152
mov si,3992
call linePrint
call delay
mov di,150
mov si,3990
call linePrint
call delay

mov di,148
mov si,3988
call linePrint
call delay

mov di,306
mov si,3826
call linePrint
call delay

mov di,464
mov si,3664
call linePrint
call delay

mov di,622
mov si,3502
call linePrint
call delay
mov di,780
mov si,3340
call linePrint
call delay

mov di,938
mov si,3178
call linePrint
call delay

mov di,1096
mov si,3016
call linePrint
call delay

mov di,1254
mov si,2854
call linePrint


mov di,1412
mov si,2692
call linePrint
call delay
mov di,1570
mov si,2530
call linePrint
call delay

mov di,1728
mov si,2368
call linePrint
call delay
mov di,1886
mov si,2206
call linePrint
call delay
mov word[es:2044],ax

popa
ret

linePrint:
  loop100:
  mov word[es:di],ax
  add di,160
  cmp di,si
  jne loop100

  ret

printPattern:
pusha
call clearscreen1
call printBoundary
mov ax,0xb800
mov es,ax
;green
mov ah,00011010b
mov al,0x2
call green


popa
ret

printStartingScreen:
call clearscreen1
call printPattern
call printBoundary
call clearscreen1

ret
subroutines:
start:
call printStartingScreen
 mov dx,board
call newGame
call printCandies
call printUI
gameLoop:
call printUI
  firstMessage:
   mov ah,0x13
   mov al,1
   mov bh,0
   mov bl,00011100b
   mov dx,0x0504
   mov cx,11
   push cs
   pop es
   mov bp,message1
   int 0x10
   mov ah,0
 int 0x16
 cmp ah,31
 jne continue1
 call newGame
 call printUI
 jmp gameLoop
 continue1:
 cmp ah,11
 jne skipp2
 mov byte[row1],0
 jmp secondMessage

 skipp2:


 sub ah,1
 mov byte[row1],ah

  secondMessage:
   mov ah,0x13
   mov al,1
   mov bh,0
   mov bl,00011100b
   mov dx,0x0704
   mov cx,11
   push cs
   pop es
   mov bp,message2
   int 0x10
   mov ah,0
 int 0x16
 cmp ah,11
 jne skipp1
 mov ah,0
 mov byte[col1],ah
 jmp thirdMessage
 skipp1:
 sub ah,1
  mov byte[col1],ah
 thirdMessage:
   mov ah,0x13
   mov al,1
   mov bh,0
   mov bl,00011100b
   mov dx,0x0904
   mov cx,11
   push cs
   pop es
   mov bp,message3
   int 0x10
   mov ah,0
 int 0x16
 cmp ah,11
 jne skipp3
 mov byte[row2],0
 jmp fourthMessage
 skipp3:
 sub ah,1
 mov byte[row2],ah

 fourthMessage:
   mov ah,0x13
   mov al,1
   mov bh,0
   mov bl,00011100b
   mov dx,0x0b04
   mov cx,11
   push cs
   pop es
   mov bp,message4
   int 0x10
   mov ah,0
 int 0x16
 cmp ah,11
 jne skipp4
 mov byte[col2],0
 jmp skipp5
 skipp4:
 sub ah,1
 mov byte[col2],ah
 skipp5:
 
 call makeMove
 mov ah,0
 int 0x16


continue100:
dec word[moves]
cmp word[moves],0
jne gameLoop
call printEndingScreen


mov ax,0x4c00
int 0x21
symbols: db 64,35,37,36,38   ; used it as single byte to access using random number
board:
  dw 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
row1: dw 0
col1: dw 0
row2: dw 1
col2: dw 0
isValid: dw 0
patternFound: dw 0  ; to crush candies
variables:
attribute: db 0
moves: dw 10
message1: db 'Enter Row1:' ; 11
message2: db 'Enter Col1:' ; 11
message3: db 'Enter Row2:' ; 11
message4: db 'Enter Col2:'  ;11
bombFlag: dw 0
movesMessage:  db 'Moves Ramaining:'   ; 16
bombActivatorELement: dw 0
score: dw 0
scoreMessage: db 'Scores: ' ;   8
invalidMessage: db 'Invalid Move !!'   ;15
bombMessage: db 'BOMB !!'
undoSourceIndex: dw 0
undoSourceElement: dw 0
undoDestElement: dw 0
undoDestIndex: dw 0
isValid2: dw 0
endingMessage: db 'OUT OF MOVES!'  ; 13
