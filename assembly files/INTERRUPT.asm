#ifndef _INTERRUPT_ASM_
#define _INTERRUPT_ASM_



	RESET: 
	JMP START


     EXT_INT0:RETI
     EXT_INT1 :RETI
     EXT_INT2 :RETI
     TIM2_COMP :RETI
     TIM2_OVF :RETI
     TIM1_CAPT :RETI
     TIM1_COMPA :RETI
     TIM1_COMPB :
	 RETI

     TIM1_OVF :
	 INC I
	 CPI I,20
	 IF(MYI,BREQ)
	 LDI I,0
	 CPI FLAG,FRUN
	 IF(SHOWSEC,BREQ)
	 MLCMD CURSORSEC;LCS(0,CURSORSEC)
	 MDISREG S
	 END(SHOWSEC)
	 INC S
	 CPI S,60
		 IF(MYS,BREQ)
				
				 LDI S,0
				 INC M
				 CPI FLAG,FRUN
				 IF(SHOWMIN,BREQ)
					 MLCMD CURSORMIN;LCS(0,CURSORMIN)
					 MDISREG M
				 END(SHOWMIN)
				 PUSH TMP
				 LDS TMP,MINALARM
				 CP M,TMP
				 IF(MINALARMEQ,BREQ)
							 PUSH ARG2 ;ANOTHER TEMP :|
							 LDS ARG2,HOURALARM
							 LDS TMP,HOUR
							 CP TMP,ARG2
							 IF(HOURALARMEQ,BREQ)
								LDI ARG2,1<<BUZZER;--------------------ACTIVE BUZZER
								OUT PORTB,ARG2
							 END(HOURALARMEQ)
							 POP ARG2
				 END(MINALARMEQ)
				 POP TMP
				 CPI M,60
				 IF(MYM,BREQ)
					 LDI M,0
					 PUSH TMP
					 LDS TMP,HOUR
					 INC TMP
					
				 CPI FLAG,FRUN
				 IF(SHOWHOUR,BREQ)
				 MLCMD CURSORHOUR;LCS(0,CURSORHOUR)
				 MDISREG TMP
				 END(SHOWHOUR)
				 STS HOUR,TMP
				 CPI TMP,24
					 IF(HOURLOW24,BREQ)
					 LDI TMP,0
					 STS HOUR,TMP
					 LDS TMP,DAY
					 INC TMP
					 CPI FLAG,FALARM
					 IF(SHOWDAY,BRNE)
					 MLCMD CURSORDAY;LCS(1,CURSORDAY)
					 MDISREG TMP
					 END(SHOWDAY)
					 CPI TMP,31
					 STS DAY,TMP
						IF(DAYLOW31,BREQ)
						LDI TMP,0
						STS DAY,TMP
						LDS TMP,MONTH
						INC TMP
						CPI FLAG,FALARM
						IF(SHOWMONTH,BRNE)
						MLCMD CURSORMONTH;LCS(1,CURSORMONTH)
					    MDISREG TMP
						END(SHOWMONTH)
						STS MONTH,TMP
						CPI TMP,12
							IF(MONTHLOW12,BREQ)
							LDI TMP,0
							STS MONTH,TMP
							LDS TMP,YEAR
							INC TMP
							 CPI FLAG,FALARM
							 IF(SHOWYEAR,BRNE)
					 		MLCMD CURSORYEAR;LCS(1,CURSORYEAR)
					        MDISREG TMP
							END(SHOWYEAR)
							STS YEAR,TMP

							END(MONTHLOW12)
						END(DAYLOW31)
					 END(HOURLOW24)
					 POP TMP
				 END(MYM)
		 END(MYS)
	 END(MYI)RETI

     TIM0_COMP :
	 RETI
     TIM0_OVF :
	 RETI
     SPI_STC :RETI
     USART_RXC :RETI
     USART_UDRE :RETI
     USART_TXC :RETI
     ADC_INTERRUPT :RETI
     EE_RDY :RETI
     ANA_COMP :RETI
     TWI :RETI
     SPM_RDY:RETI


#endif	
