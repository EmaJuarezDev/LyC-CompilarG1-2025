.MODEL LARGE
.386
.STACK 200h
MAXTEXTSIZE equ 255

.DATA
a1 dd ?
b1 dd ?
variable1 dd ?
p1 db MAXTEXTSIZE dup('?')
p2 db MAXTEXTSIZE dup('?')
p3 db MAXTEXTSIZE dup('?')
a dd ?
b dd ?
c dd ?
d dd ?
e dd ?
x dd ?
r dd ?
j dd ?
base db MAXTEXTSIZE dup('?')
var1 db MAXTEXTSIZE dup('?')
y db MAXTEXTSIZE dup('?')
_1.5 dd 1.5
_999. dd 999.
_.999 dd .999
_2.5 dd 2.5
_99999.99 dd 99999.99
_99. dd 99.
_.9999 dd .9999
_1.1 dd 1.1
_340200000000000000000000000000000000000.0 dd 340200000000000000000000000000000000000.0
_0.00000000000000000000000000000000000001176 dd 0.00000000000000000000000000000000000001176
_01.1 dd 01.1
_1.10 dd 1.10
_00000000000000.125 dd 00000000000000.125
_0 dd 0
_1 dd 1
_32767 dd 32767
_00000000000000125 dd 00000000000000125
_2 dd 2
_3 dd 3
_9 dd 9
@lis dd ?
@can dd ?
@ori dd ?
@des dd ?
@aux dd ?
@piv dd ?

.CODE
START:
	mov ax, @data
	mov ds, ax
	mov es, ax

FLD _cte999_
FLD _cte1_5
FADD
FLD _@AUX
FSTP _b1
FLD _cte2_5
FLD _cte_999
FADD
FLD _@AUX
FSTP _b1
READ String base
IMP String var1, 2
NEWLINE
FLD _99999_99
FSTP _a1
FLD _99_0
FSTP _a1
FLD __9999
FSTP _a1
FLD _1_1
FSTP _a1
FLD _340200000000000000000000000000000000000_0
FSTP _a1
FLD _0_00000000000000000000000000000000000001176
FSTP _a1
FLD _01_1
FSTP _a1
FLD _1_10
FSTP _a1
FLD _00000000000000_125
FSTP _a1
FLD _0
FSTP _c
FLD _1
FSTP _c
FLD _32767
FSTP _c
FLD _00000000000000125
FSTP _c
FILD _a
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNAE IMP String var1, 2
NEWLINE
FILD _a
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNBE IMP String var1, 2
NEWLINE
FILD _a
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JE IMP String var1, 2
NEWLINE
FILD _a
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNE IMP String var1, 2
NEWLINE
FILD _a
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNB IMP String var1, 2
NEWLINE
FLD _1
FSTP _a
FLD _1
FSTP _b
FLD _2
FSTP _c
FILD _a
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNA FILD _c
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNA IMP String var1, 2
NEWLINE
FILD _a
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNBE FILD _c
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNA IMP String var1, 2
NEWLINE
FILD _a
FILD _b
FXCH 
FCOMP 
fstsw ax
sahf
JNBE IMP String var1, 2
NEWLINE
FLD _cte3
FLD _ctex
FADD
FLD _@AUX
FSTP _@lis[0]
FLD _1
FSTP _@can
FILD _1
FILD _1
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FILD _x
FILD _9
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FLD _2
FSTP _@piv
FILD _@piv
FILD _@can
FXCH 
FCOMP 
fstsw ax
sahf
JNB FLD _0
FSTP _@ori
FLD _@piv
FSTP _@des
ET
FILD _@ori
FILD _@des
FXCH 
FCOMP 
fstsw ax
sahf
JNB FLD _@lis[@ori]
FSTP _@aux
FLD _@lis[@des]
FSTP _@lis[@ori]
FLD _@aux
FSTP _@lis[@des]
FLD _cte1
FLD _cte@ori
FADD
FLD _@AUX
FSTP _@ori
FILD _1
FILD _@des
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@des
JMP FLD _r
FMUL _j
FSTP _@AUX
FILD _2
FLD _@AUX
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@lis[0]
FLD _1
FSTP _@can
FLD _cte3
FLD _ctex
FADD
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FLD _cte1
FLD _cte1
FADD
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FILD _x
FILD _9
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FLD _2
FSTP _@piv
FILD _@piv
FILD _@can
FXCH 
FCOMP 
fstsw ax
sahf
JNB FLD _@piv
FSTP _@ori
FILD _1
FILD _@can
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@des
ET
FILD _@ori
FILD _@des
FXCH 
FCOMP 
fstsw ax
sahf
FLD _@lis[@ori]
FSTP _@aux
FLD _@lis[@des]
FSTP _@lis[@ori]
FLD _@aux
FSTP _@lis[@des]
FLD _cte1
FLD _cte@ori
FADD
FLD _@AUX
FSTP _@ori
FILD _1
FILD _@des
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@des
JMP FLD _r
FMUL _j
FSTP _@AUX
FILD _2
FLD _@AUX
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@lis[0]
FLD _1
FSTP _@can
FLD _cte3
FLD _ctex
FADD
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FLD _cte1
FLD _cte1
FADD
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FILD _x
FILD _9
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FLD _3
FSTP _@piv
FILD _@piv
FILD _@can
FXCH 
FCOMP 
fstsw ax
sahf
JNB FLD _@piv
FSTP _@ori
FILD _1
FILD _@can
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@des
ET
FILD _@ori
FILD _@des
FXCH 
FCOMP 
fstsw ax
sahf
FLD _@lis[@ori]
FSTP _@aux
FLD _@lis[@des]
FSTP _@lis[@ori]
FLD _@aux
FSTP _@lis[@des]
FLD _cte1
FLD _cte@ori
FADD
FLD _@AUX
FSTP _@ori
FILD _1
FILD _@des
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@des
JMP FLD _r
FMUL _j
FSTP _@AUX
FILD _2
FLD _@AUX
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@lis[0]
FLD _1
FSTP _@can
FLD _cte3
FLD _ctex
FADD
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FLD _cte1
FLD _cte1
FADD
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FILD _x
FILD _9
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@lis[@can]
FLD _cte1
FLD _cte@can
FADD
FLD _@AUX
FSTP _@can
FLD _0
FSTP _@piv
FILD _@piv
FILD _@can
FXCH 
FCOMP 
fstsw ax
sahf
JNB FLD _0
FSTP _@ori
FLD _@piv
FSTP _@des
ET
FILD _@ori
FILD _@des
FXCH 
FCOMP 
fstsw ax
sahf
JNB FLD _@lis[@ori]
FSTP _@aux
FLD _@lis[@des]
FSTP _@lis[@ori]
FLD _@aux
FSTP _@lis[@des]
FLD _cte1
FLD _cte@ori
FADD
FLD _@AUX
FSTP _@ori
FILD _1
FILD _@des
FSUB
FSTP _@AUX
FLD _@AUX
FSTP _@des
JMP 
mov ax,4c00h
int 21h

STRLEN PROC NEAR
	mov BX,0

STRL01:
	cmp BYTE PTR [SI+BX],'$'
	je STREND
	inc BX
	jmp STRL01

STREND:
	ret

STRLEN ENDP

COPIAR PROC NEAR
	call STRLEN
	cmp BX,MAXTEXTSIZE
	jle COPIARSIZEOK
	mov BX,MAXTEXTSIZE

COPIARSIZEOK:
	mov CX,BX
	cld
	rep movsb
	mov al,'$'
	mov BYTE PTR [DI],al
	ret

COPIAR ENDP

END START
