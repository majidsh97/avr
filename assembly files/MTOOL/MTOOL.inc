#ifndef _MTOOL_INC_
#define _MTOOL_INC_

#define TRUE 1
#define FALSE 0

.equ DDRB0=0
.equ DDRB1=1
.equ DDRB2=2
.equ DDRB3=3
.equ DDRB4=4
.equ DDRB5=5
.equ DDRB6=6
.equ DDRB7=7






#define IFE(X,Y) Y X##_IF RJMP X##_ELSE X##_IF:
#define IF(X,Y) Y X##_IF RJMP X##_ENDIF X##_IF:
#define ELSE(X) RJMP X##_ENDIF X##_ELSE:
#define END(X) X##_ENDIF:

#define FOR(X,Y) CPI Y,0 BREQ ENDF_##X FOR_##X: 
#define ENDF(X,Y) DEC Y CPI Y,0 BRNE FOR_##X ENDF_##X:

#define POW(n) 1<<n
#define GETARR(X,Y) X+Y

#include "MTOOL\MTOOL.ASM"

#endif

