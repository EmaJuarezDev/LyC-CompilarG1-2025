include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
a1	dd	?
b1	dd	?
variable1	dd	?
var1	dd	?
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
y	db	51 dup('$')
_cte99999_99	dd	1e+005
_cte99_0	dd	99.0
_cte0_9999	dd	0.9999
_T_@sdADaSjfla%dfg	db	"@sdADaSjfla%dfg", '$', 3 dup(?)
_T_asldk__fh_sjf	db	"asldk  fh sjf", '$', 3 dup(?)
_cte27	dd	27
_cte500	dd	500
_cte34	dd	34
_cte3	dd	3
_T_ewr	db	"ewr", '$', 3 dup(?)
_T_a_es_mas_grande_que_b	db	"a es mas grande que b", '$', 3 dup(?)
_T_a_es_mas_chico_o_igual_a_b	db	"a es mas chico o igual a b", '$', 3 dup(?)
_cte1	dd	1
_cte2	dd	2
_T_a_es_mas_grande_que_b_y_c_es_mas_grande_que_b	db	"a es mas grande que b y c es mas grande que b", '$', 3 dup(?)
_T_a_es_mas_grande_que_b_o_c_es_mas_grande_que_b	db	"a es mas grande que b o c es mas grande que b", '$', 3 dup(?)
_T_a_no_es_mas_grande_que_b	db	"a no es mas grande que b", '$', 3 dup(?)
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

FLD _cte27
FLD c
FSUB
FSTP x
DisplayFloat x, 2

NEWLINE 1

FLD r
FLD _cte500
FADD
FSTP x
DisplayFloat x, 2

NEWLINE 1

FLD _cte34
FLD _cte3
FMUL
FSTP x
DisplayFloat x, 2

NEWLINE 1

FLD z
FLD f
FDIV
FSTP x
DisplayFloat x, 2

NEWLINE 1

lea DX, _T_ewr
mov AH, 09h
int 21h

NEWLINE 1

lea DX, var1
mov AH, 09h
int 21h

NEWLINE 1

FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA ET_0
lea DX, _T_a_es_mas_grande_que_b
mov AH, 09h
int 21h

NEWLINE 1

JMP ET_1
ET_0:
lea DX, _T_a_es_mas_chico_o_igual_a_b
mov AH, 09h
int 21h

NEWLINE 1

ET_1:
FLD _cte1
FSTP a
DisplayFloat a, 2

NEWLINE 1

FLD _cte1
FSTP b
DisplayFloat b, 2

NEWLINE 1

FLD _cte2
FSTP c
DisplayFloat c, 2

NEWLINE 1

FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA ET_2
FLD c
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA ET_3
lea DX, _T_a_es_mas_grande_que_b_y_c_es_mas_grande_que_b
mov AH, 09h
int 21h

NEWLINE 1

ET_3:
ET_2:
FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNBE ET_4
FLD c
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA ET_5
ET_4:
lea DX, _T_a_es_mas_grande_que_b_o_c_es_mas_grande_que_b
mov AH, 09h
int 21h

NEWLINE 1

ET_5:
FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNBE ET_6
lea DX, _T_a_no_es_mas_grande_que_b
mov AH, 09h
int 21h

NEWLINE 1

ET_6:
FLD _cte1
FSTP a
DisplayFloat a, 2

NEWLINE 1

FLD _cte3
FSTP b
DisplayFloat b, 2

NEWLINE 1

ET_W0:
FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA ET_7
lea DX, _T_a_es_mas_grande_que_b
mov AH, 09h
int 21h

NEWLINE 1

FLD a
FLD _cte1
FADD
FSTP a
DisplayFloat a, 2

NEWLINE 1

JMP ET_W0
ET_7:
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
