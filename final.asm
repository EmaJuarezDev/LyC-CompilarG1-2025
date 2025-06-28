.MODEL LARGE
.386
.STACK 200h
.DATA


.CODE
mov AX,@DATA
mov DS,AX
mov es,ax

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

mov ax,4c00h
int 21h
End
