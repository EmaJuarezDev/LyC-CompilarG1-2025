include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
a1	dd	?
b1	dd	?
variable1	dd	?
p1	db	51 dup('$')
p2	db	51 dup('$')
p3	db	51 dup('$')
a	dd	?
b	dd	?
c	dd	?
d	dd	?
e	dd	?
x	dd	?
r	dd	?
j	dd	?
z	dd	?
f	dd	?
base	db	51 dup('$')
var1	db	51 dup('$')
y	db	51 dup('$')
_cte99999_99	dd	1e+005
_cte99_0	dd	99.0
_cte0_9999	dd	0.9999
_T_@sdADaSjfla%dfg	db	"@sdADaSjfla%dfg", '$', 3 dup(?)
_T_asldk__fh_sjf	db	"asldk  fh sjf", '$', 3 dup(?)
_T_verderill	db	"verderill", '$', 3 dup(?)
_T_lenguajesmpilad	db	"lenguajesmpilad", '$', 3 dup(?)

.CODE
main:
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

FLD _cte99999_99
FSTP a1
DisplayFloat a1, 2

NEWLINE 1

FLD _cte99_0
FSTP a1
DisplayFloat a1, 2

NEWLINE 1

FLD _cte0_9999
FSTP a1
DisplayFloat a1, 2

NEWLINE 1

lea SI, _T_@sdADaSjfla%dfg
lea DI, p1
ET_C0:
lodsb
stosb
cmp AL, '$'
JNE ET_C0
lea DX, p1
mov AH, 09h
int 21h

NEWLINE 1

lea SI, _T_asldk__fh_sjf
lea DI, p1
ET_C1:
lodsb
stosb
cmp AL, '$'
JNE ET_C1
lea DX, p1
mov AH, 09h
int 21h

NEWLINE 1

lea SI, _T_verderill
lea DI, y
ET_C2:
lodsb
stosb
cmp AL, '$'
JNE ET_C2
lea DX, y
mov AH, 09h
int 21h

NEWLINE 1

lea SI, _T_lenguajesmpilad
lea DI, y
ET_C3:
lodsb
stosb
cmp AL, '$'
JNE ET_C3
lea DX, y
mov AH, 09h
int 21h

NEWLINE 1

MOV AH, 1
INT 21h
MOV AX, 4c00h
INT 21h
END main
