#include "INTERRUPT.INC"
#include "MAIN.INC"
start:
	ldi r16,high(RAMEND) ; Main program start
	out SPH,r16 ; Set Stack Pointer to top of RAM
	ldi r16,low(RAMEND)
	out SPL,r16
	SEI
;-----------------------------------MAIN START---------------------------------------------
	LDI I,0
	LDI FLAG,FRUN
	LDI TMP,0
	LDI S,0
	LDI M,0
	LDI CURSORSTATE,CURSORHOUR

	LDI TMP,TRUE
	STS MINALARM,TMP

	LDI TMP,12
	STS HOUR,TMP
	STS HOURALARM,TMP
	LDI TMP,21
	STS DAY,TMP
	LDI TMP,1
	STS MONTH,TMP
	LDI TMP,18
	STS YEAR,TMP

	LDI TMP,0XFF
	OUT DDRD,TMP

	CALL LCDINIT
	MLCMD _LCURSOROFF
	
	/*MDISREG M
	MLDATA ':'
	MDISREG S*/
	.MACRO MFRUNSHOW
				MLCMD _LCLEAR
				MLDATA 'T'
				MLDATA 'i'
				MLDATA 'm'
				MLDATA 'e'
				MLDATA ' '
				MLCMD LCS(0,CURSORHOME)
				LDS TMP,HOUR
				MDISREG TMP
				MLDATA ':' 
				MDISREG M
				MLDATA ':' 
				MDISREG S
				MLCMD LCS(1,0)
				MLDATA 'D'
				MLDATA 'a'
				MLDATA 't'
				MLDATA 'e'
				MLDATA ' '
				MLCMD LCS(1,CURSORHOME)
				LDS TMP,YEAR
				MDISREG TMP
				MLDATA '/' 
				LDS TMP,MONTH
				MDISREG TMP
				MLDATA '/'
				LDS TMP,DAY
				MDISREG TMP
 .ENDMACRO 
	MFRUNSHOW

	LDI TMP,low(MYTCNT)
	OUT TCNT1L,TMP
	LDI TMP,high(MYTCNT)
	OUT TCNT1H,TMP

	LDI TMP,1<<TOIE1
	OUT TIMSK,TMP
	
	LDI TMP,0X01
	OUT TCCR1B,TMP
	
EOF:	
	;ldi TMP,1<<BU|1<<BD
	IN TMP,PINB
	CPI FLAG,FTANZIM
	IFE(MYFTANZIM,BREQ);---------------------------DAR HALATE TANZIM
	CBRS TMP,BU
		IFE(BTNUP,BREQ);-------------------------------BTN UP
		CPI CURSORSTATE,CURSORSEC
			IFE(BTNUP_SEC,BREQ);-------------------------------BTN UP SEC
			INC S
			CPI S,60
					IF(SECLOW60_UP,BREQ)
					LDI S,0
					END(SECLOW60_UP)
			MLCMD CURSORSEC;LCS(0,CURSORSEC)
			MDISREG S
			ELSE(BTNUP_SEC)
			CPI CURSORSTATE,CURSORMIN
				IFE(BTNUP_MIN,BREQ);-------------------------------BTN UP MIN
					
				INC M
				CPI M,60
					IF(BTNUP_MINLOW60,BREQ)
					LDI M,0
					END(BTNUP_MINLOW60)
				MLCMD CURSORMIN; LCS(0,CURSORMIN)
				MDISREG M	
				ELSE(BTNUP_MIN)
					CPI CURSORSTATE,CURSORHOUR
					IFE(BTNUP_HOUR,BREQ);-------------------------------BTN UP HOUR
						PUSH TMP
						LDS TMP,HOUR
						INC TMP
						CPI TMP,24
							IF(BTNUP_HOURLOW24,BREQ)
							LDI TMP,0
							END(BTNUP_HOURLOW24)
						STS HOUR,TMP
						MLCMD CURSORHOUR
						MDISREG TMP
						POP TMP
					ELSE(BTNUP_HOUR)
							CPI CURSORSTATE,CURSORYEAR
							IFE(BTNUP_YEAR,BREQ);-------------------------------BTN UP YEAR
							PUSH TMP
							LDS TMP,YEAR
							INC TMP
							STS YEAR,TMP
							MLCMD CURSORYEAR
							MDISREG TMP
							POP TMP
						ELSE(BTNUP_YEAR)
								CPI CURSORSTATE,CURSORMONTH
								IFE(BTNUP_MONTH,BREQ);-------------------------------BTN UP MONTH
								PUSH TMP
								LDS TMP,MONTH
								
								INC TMP
								CPI TMP,12
									IF(BTNUP_MONTHLOW12,BREQ)
									LDI TMP,0
									END(BTNUP_MONTHLOW12)
								STS MONTH,TMP
								MLCMD CURSORMONTH
								MDISREG TMP
								POP TMP
							ELSE(BTNUP_MONTH)
										CPI CURSORSTATE,CURSORDAY
										IFE(BTNUP_DAY,BREQ);-------------------------------BTN UP DAY
										PUSH TMP
										LDS TMP,DAY
										INC TMP
										CPI TMP,31
											IF(BTNUP_DAYLOW31,BREQ)
											LDI TMP,0
											END(BTNUP_DAYLOW31)
										STS DAY,TMP
										MLCMD CURSORDAY
										MDISREG TMP
										POP TMP
									ELSE(BTNUP_DAY)
									;--- :|
									END(BTNUP_DAY)
							END(BTNUP_MONTH)
						END(BTNUP_YEAR)
					END(BTNUP_HOUR)
			END(BTNUP_MIN)
		END(BTNUP_SEC)
		ELSE(BTNUP)
		CBRS TMP,BD
			IFE(BTNDOWN,BREQ);-------------------------------BTN DOWN
			CPI CURSORSTATE,CURSORSEC
			IFE(BTNDOWN_SEC,BREQ);-------------------------------BTN DOWN SEC
			CPI S,0
					IF(SECLOW60_DOWN,BREQ)
					LDI S,60
					END(SECLOW60_DOWN)
			DEC S
			MLCMD CURSORSEC;LCS(0,CURSORSEC)
			MDISREG S
			ELSE(BTNDOWN_SEC)
			CPI CURSORSTATE,CURSORMIN
				IFE(BTNDOWN_MIN,BREQ);-------------------------------BTN DOWN MIN
				CPI M,0
					IF(BTNDOWN_MINLOW60,BREQ)
					LDI M,60
					END(BTNDOWN_MINLOW60)
				DEC M
				MLCMD CURSORMIN; LCS(0,CURSORMIN)
				MDISREG M	
				ELSE(BTNDOWN_MIN)
					CPI CURSORSTATE,CURSORHOUR
					IFE(BTNDOWN_HOUR,BREQ);-------------------------------BTN DOWN HOUR
						PUSH TMP
						LDS TMP,HOUR
						
						CPI TMP,0
						IF(BTNDOWN_HOURLOW24,BREQ)
						LDI TMP,24
						END(BTNDOWN_HOURLOW24)
						DEC TMP
						STS HOUR,TMP
						MLCMD CURSORHOUR
						MDISREG TMP
						POP TMP
					ELSE(BTNDOWN_HOUR)
							CPI CURSORSTATE,CURSORYEAR
							IFE(BTNDOWN_YEAR,BREQ);-------------------------------BTN DOWN YEAR
							PUSH TMP
							LDS TMP,YEAR
							
							DEC TMP
							STS YEAR,TMP
							MLCMD CURSORYEAR
							MDISREG TMP
							POP TMP
						ELSE(BTNDOWN_YEAR)
								CPI CURSORSTATE,CURSORMONTH
								IFE(BTNDOWN_MONTH,BREQ);-------------------------------BTN DOWN MONTH
								PUSH TMP
								LDS TMP,MONTH
								
								CPI TMP,0
								IF(BTNDOWN_MONTHLOW12,BREQ)
								LDI TMP,12
								END(BTNDOWN_MONTHLOW12)
								DEC TMP
								STS MONTH,TMP
								MLCMD CURSORMONTH
								MDISREG TMP
								POP TMP
							ELSE(BTNDOWN_MONTH)
										CPI CURSORSTATE,CURSORDAY
										IFE(BTNDOWN_DAY,BREQ);-------------------------------BTN DOWN DAY
										PUSH TMP
										LDS TMP,DAY
										
										CPI TMP,0
										IF(BTNDOWN_DAYLOW31,BREQ)
										LDI TMP,31
										END(BTNDOWN_DAYLOW31)
										DEC TMP
										STS DAY,TMP
										MLCMD CURSORDAY
										MDISREG TMP
										POP TMP
									ELSE(BTNDOWN_DAY)
									;--- :|
									END(BTNDOWN_DAY)
							END(BTNDOWN_MONTH)
						END(BTNDOWN_YEAR)
					END(BTNDOWN_HOUR)
			END(BTNDOWN_MIN)
		END(BTNDOWN_SEC)
			ELSE(BTNDOWN)
				CBRS TMP,BN
				IF(BTNNEXT,BREQ)
				CPI CURSORSTATE,CURSORDAY
						IFE(IF_CURSOREND,BREQ)
							LDI CURSORSTATE,CURSORHOUR
						ELSE(IF_CURSOREND)
							CPI CURSORSTATE,CURSORSEC
							IFE(NEXT_LINE2,BREQ)
							LDI CURSORSTATE,CURSORYEAR
							ELSE(NEXT_LINE2)
							PUSH TMP
							LDI TMP,3
							ADD CURSORSTATE,TMP
							POP TMP
							END(NEXT_LINE2)
						END(IF_CURSOREND)
						MOV ARG1,CURSORSTATE
						CALL LCD_CMD
				CALL DELAY_20MS
				CALL DELAY_20MS
				CALL DELAY_20MS
				IN TMP,PINB
				CBRS TMP,BN
				IF(BTNOFF2,BREQ)
				LDI FLAG,FRUN
				LDI TMP,1
				OUT TCCR1B,TMP
				MLCMD _LCURSOROFF
				LDI CURSORSTATE,CURSORHOUR`
				;MLCMD CURSORHOUR
				CALL SLEEP_1S
				END(BTNOFF2)
				
				
				END(BTNNEXT)
			END(BTNDOWN)
		END(BTNUP)
	ELSE(MYFTANZIM);----------------------------------------TANZIM AVALIYE
		CPI FLAG,FTANZIMALARM
		IFE(MYTANZIMALARM,BREQ);-------------------------------------------------------FLAG TANZIM ALARM
			
			CBRS TMP,BU
			IFE(BTNUP_ALARM,BREQ);-------------------------------BTN UP
			CPI CURSORSTATE,CURSORHOUR
					IFE(BTNUP_HOURALARM,BREQ);-------------------------------BTN UP HOURALARM
						PUSH TMP
						LDS TMP,HOURALARM
						INC TMP
						CPI TMP,24
							IF(BTNUP_HOURLOW24_ALARM,BREQ)
							LDI TMP,0
							END(BTNUP_HOURLOW24_ALARM)
						STS HOURALARM,TMP
						MLCMD CURSORHOUR
						MDISREG TMP
						POP TMP
					ELSE(BTNUP_HOURALARM)
							CPI CURSORSTATE,CURSORMIN
							IF(BTNUP_MINALARM,BREQ);-------------------------------BTN UP MINALARM
							PUSH TMP
							LDS TMP,MINALARM
							INC TMP
							CPI TMP,60
								IF(BTNUP_MINLOW24_ALARM,BREQ)
								LDI TMP,0
								END(BTNUP_MINLOW24_ALARM)
							STS MINALARM,TMP
							MLCMD CURSORMIN
							MDISREG TMP
							POP TMP
							END(BTNUP_MINALARM)
						END(BTNUP_HOURALARM)
			ELSE(BTNUP_ALARM)
			CBRS TMP,BD
				IFE(BTNDOWN_ALARM,BREQ);---------------------------------------------BTN DOWN ALARM
						CPI CURSORSTATE,CURSORHOUR
					IFE(BTNDOWN_HOURALARM,BREQ);-------------------------------BTN DOWN HOURALARM
						PUSH TMP
						LDS TMP,HOURALARM
						CPI TMP,0
							IF(BTNDOWN_HOURLOW24_ALARM,BREQ)
							LDI TMP,24
							END(BTNDOWN_HOURLOW24_ALARM)
						DEC TMP
						STS HOURALARM,TMP
						MLCMD CURSORHOUR
						MDISREG TMP
						POP TMP
					ELSE(BTNDOWN_HOURALARM)
							CPI CURSORSTATE,CURSORMIN
							IF(BTNDOWN_MINALARM,BREQ);-------------------------------BTN DOWN MINALARM
							PUSH TMP
							LDS TMP,MINALARM
							CPI TMP,0
								IF(BTNDOWN_MINLOW24_ALARM,BREQ)
								LDI TMP,60
								END(BTNDOWN_MINLOW24_ALARM)
							DEC TMP
							STS MINALARM,TMP
							MLCMD CURSORMIN
							MDISREG TMP
							POP TMP
							END(BTNDOWN_MINALARM)
						END(BTNDOWN_HOURALARM)


					ELSE(BTNDOWN_ALARM)
				CBRS TMP,BN
				IF(BTNNEXT_ALARM,BREQ)
				CPI CURSORSTATE,CURSORMIN
						IFE(IF_CURSOREND_ALARM,BREQ)
							LDI CURSORSTATE,CURSORHOUR
						ELSE(IF_CURSOREND_ALARM)
				CPI CURSORSTATE,CURSORHOUR
							IF(IF_COURSOURHOUR_ALARM,BREQ)
							LDI CURSORSTATE,CURSORMIN
							END(IF_COURSOURHOUR_ALARM)
						END(IF_CURSOREND_ALARM)
						MOV ARG1,CURSORSTATE
						CALL LCD_CMD

				CALL DELAY_20MS
				CALL DELAY_20MS
				CALL DELAY_20MS
				IN TMP,PINB
				CBRS TMP,BN
				IF(BTNOFF2_ALARM,BREQ)
				LDI FLAG,FALARM
				MLCMD _LCURSOROFF
				LDI CURSORSTATE,CURSORHOUR`
				CALL SLEEP_1S
				END(BTNOFF2_ALARM)
				
				
				END(BTNNEXT_ALARM)
				END(BTNDOWN_ALARM)
			END(BTNUP_ALARM)
		ELSE(MYTANZIMALARM)
				CPI FLAG,FALARM
				IFE(AGAINALARM,BREQ);--------------------------------FLAG ALARM
				CBRS TMP,BA
					IFE(BTNALARM,BREQ)
					LDI FLAG,FRUN
					MFRUNSHOW
					ELSE(BTNALARM)
						CBRS TMP,BN
								IF(GOTOTANZIMALARM,BREQ);--------------------------------------------BTN NEXT GO TO TANZIM ALARM
								CALL SLEEP_1S
								CALL SLEEP_1S
								IN TMP,PINB
								CBRS TMP,BN
									IF(GOTOTANZIMALARM2,BREQ)
									MLCMD _LCURSORBLINK
									LDI CURSORSTATE,CURSORHOUR
									MLCMD CURSORHOUR
									LDI FLAG,FTANZIMALARM
									CALL SLEEP_1S
									END(GOTOTANZIMALARM2)
								;END(MYPF_ALARM)
								;ELSE()
								END(GOTOTANZIMALARM)
					END(BTNALARM)
				ELSE(AGAINALARM)
					IFE(BUZZERACTIVE,BREQ)
					PUSH TMP
					LDI TMP,0
					OUT PORTB,TMP
					POP TMP
					ELSE(BUZZERACTIVE)
					CBRS TMP,BA
					IFE(GOTOALARM,BREQ);-----------------------GO TO ALARM
							LDI FLAG,FALARM
							MLCMD _LCLEAR
							MLDATA 'A'
							MLDATA 'l'
							MLDATA 'a'
							MLDATA 'r'
							MLDATA 'm'
							MLDATA ' '
							PUSH TMP
							LDS TMP,HOURALARM
							MLCMD CURSORHOUR
							MDISREG TMP
							MLDATA ':'
							LDS TMP,MINALARM
							MLCMD CURSORMIN
							MDISREG TMP
							POP TMP
					ELSE(GOTOALARM)
						CBRS TMP,BN
						IF(GOTOTANZIM,BREQ);--------------------------------------- GOTO TANZIM
						CALL SLEEP_1S
						CALL SLEEP_1S
						IN TMP,PINB
						CBRS TMP,BN
							IF(GOTOTANZIM2,BREQ)
							LDI TMP,0
							OUT TCCR1B,TMP
							MLCMD _LCURSORBLINK
							LDI CURSORSTATE,CURSORHOUR
							MLCMD CURSORHOUR
							LDI FLAG,FTANZIM
							CALL SLEEP_1S
							END(GOTOTANZIM2)
						END(GOTOTANZIM)	
					END(GOTOALARM)
					END(BUZZERACTIVE)
				END(AGAINALARM)	
		 END(MYTANZIMALARM)

	END(MYFTANZIM)
	CALL SLEEP_HALFSEC
	RJMP EOF
;-----------------------------------MAIN END---------------------------------------------

 

;-----------------------------------INTERRUPT---------------------------------------------



SLEEP_1S:
	PUSH TMP
	LDI TMP,5
	FOR(MYFSLEEP,TMP)
	CALL DELAY_20MS
	ENDF(MYFSLEEP,TMP)
	POP TMP
	RET
SLEEP_HALFSEC:
	PUSH TMP
	LDI TMP,1
	FOR(SLEEPHALF,TMP)
	CALL DELAY_20MS
	ENDF(SLEEPHALF,TMP)
	POP TMP
	RET



#include "INTERRUPT.ASM"

