/*
ALL CONSTANT HERE
*/
#ifndef _RES_INC_
#define _RES_INC_

 .DEF TMP=R16
 .DEF S=R17
 .DEF M=R18
 .DEF ARG1=R20
 .DEF ARG2=R21
 .DEF CURSORSTATE=R22
 .DEF RES=R23
 .DEF I=R24
 .DEF FLAG=R25


 #define MYOCR 50000
 #define MYTCNT 15535
 #define BU PINB3
 #define BD PINB4
 #define BN PINB5
 #define BA PINB6
 #define BUZZER PINB7
 ;HH:MM:SS
 ;0,3,6
 #define CURSORHOME 6
  ;#define CURSOREND 
 
  ;----------------------------------------LCD CURSOR------------------------------------

 #define CURSORSEC CURSORHOME+6+LLINE1DDRAM
 #define CURSORMIN CURSORHOME+3+LLINE1DDRAM
 #define CURSORHOUR CURSORHOME+LLINE1DDRAM
 
 #define CURSORDAY CURSORHOME+6+LLINE2DDRAM
 #define CURSORMONTH CURSORHOME+3+LLINE2DDRAM
 #define CURSORYEAR CURSORHOME+LLINE2DDRAM

 ;----------------------------------------FLAGS------------------------------------
 #define FTANZIM 1
 #define FRUN 0
 #define FALARM 2
 #define FTANZIMALARM 3
 #define BUZZERACTIVE 4


 ;----------------------------------------RAM----------------------------------------
 ;0-31 ($20) gpr
 ;32-95 ($21-$5f)io
 ;mystack $60-$6f
 #define HOUR $0070
 #define DAY $0071
 #define MONTH $0074
 #define YEAR $0075
 #define HOURALARM $0076
 #define MINALARM $0077
 ;#define MINALARMEQ $0078


 ;----------------------------------------ARRAY-------------------------------------

 ;#define ACURSORSTATE $0080
 
#endif	
