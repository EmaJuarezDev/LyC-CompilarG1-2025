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
base	dd	?
var1	dd	?
y	dd	?

.CODE
mov AX,@DATA
mov DS,AX
mov es,ax

FLD _cte1
FLD _cte3
FADD
FLD _cte0
FADD
FLD _cte3
FADD
FLD _cte4
FADD
FLD _cte4
FDIV
FSTP a

mov ax,4c00h
int 21h
End
