include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
a1	dd	?
b1	dd	?
variable1	dd	?
p1	dd	?
p2	dd	?
p3	dd	?
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
base	dd	?
var1	dd	?
y	dd	?
_cte1	dd	1
_cte3	dd	3
_cte7	dd	7
_cte4	dd	4
_cte2	dd	2
_T_a es mas grande que b	db	"a es mas grande que b", '$', 3 dup (?)
_T_a es mas chico o igual a b	db	"a es mas chico o igual a b", '$', 3 dup (?)
_cte21	dd	21
_cte99999_99	dd	99999.99
_cte_99_0	dd	99
_cte0_9999	dd	0.9999
_T_@sdADaSjfla%dfg	db	"@sdADaSjfla%dfg", '$', 3 dup (?)
_T_asldk  fh sjf	db	"asldk  fh sjf", '$', 3 dup (?)
_cte27	dd	27
_cte500	dd	500
_cte34	dd	34
_T_a es mas grande que b y c es mas grande que b	db	"a es mas grande que b y c es mas grande que b", '$', 3 dup (?)
_T_a es mas grande que b o c es mas grande que b	db	"a es mas grande que b o c es mas grande que b", '$', 3 dup (?)
_T_a no es mas grande que b	db	"a no es mas grande que b", '$', 3 dup (?)
_T_verderill	db	"verderill", '$', 3 dup (?)
_T_lenguajesmpilad	db	"lenguajesmpilad", '$', 3 dup (?)
_T_ewr	db	"ewr", '$', 3 dup (?)

.CODE
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

FLD _cte1
FSTP a
FLD _cte3
FSTP b
_ET_W0
FLD a
FLD _cte3
FMUL
FLD _cte7
FSUB
FLD b
FLD _cte4
FMUL
FLD @AUX
FXCH
FCOM
FSTSW AX
SAHF
JNBE _ET_0
FLD a
FLD _cte2
FADD
FSTP a
JMP _ET_W0
_ET_0
_ET_W1
FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA _ET_1
FLD a
FLD _cte1
FADD
FSTP a
JMP _ET_W1
_ET_1
FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA _ET_2
JMP _ET_3
_ET_2
_ET_3
FLD e
FLD _cte21
FSUB
FLD d
FLD @AUX
FMUL
FLD _cte4
FDIV
FSTP c
FLD _cte99999_99
FSTP a1
FLD _cte99_0
FSTP a1
FLD .9999
FSTP a1
FLD 15
FSTP p1
FLD 13
FSTP p1
FLD _cte27
FLD c
FSUB
FSTP x
FLD r
FLD _cte500
FADD
FSTP x
FLD _cte34
FLD _cte3
FMUL
FSTP x
FLD z
FLD f
FDIV
FSTP x
FLD _cte1
FSTP a
FLD _cte1
FSTP b
FLD _cte2
FSTP c
FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA _ET_4
FLD c
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA _ET_5
_ET_5
_ET_4
FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNBE _ET_6
FLD c
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNA _ET_7
_ET_6
_ET_7
FLD a
FLD b
FXCH
FCOM
FSTSW AX
SAHF
JNBE _ET_8
_ET_8
FLD _T_verderill
FSTP y
FLD _T_lenguajesmpilad
FSTP y
MOV DX, OFFSET var1
	MOV AH, 9
	INT 21h
NEWLINE 1

MOV AH, 1
INT 21h
MOV AX, 4c00h
INT 21h
END
