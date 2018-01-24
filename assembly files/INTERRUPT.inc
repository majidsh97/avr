#ifndef _INTERRUPT_INC_
#define _INTERRUPT_INC_
 jmp RESET ; Reset Handler
 jmp EXT_INT0 ; IRQ0 Handler
 jmp EXT_INT1 ; IRQ1 Handler
 jmp EXT_INT2 ; IRQ2 Handler
 jmp TIM2_COMP ; Timer2 Compare Handler
 jmp TIM2_OVF ; Timer2 Overflow Handler
 jmp TIM1_CAPT ; Timer1 Capture Handler
 jmp TIM1_COMPA ; Timer1 CompareA Handler
 jmp TIM1_COMPB ; Timer1 CompareB Handler
 jmp TIM1_OVF ; Timer1 Overflow Handler
 jmp TIM0_COMP ; Timer0 Compare Handler
 jmp TIM0_OVF ; Timer0 Overflow Handler
 jmp SPI_STC ; SPI Transfer Complete Handler
 jmp USART_RXC ; USART RX Complete Handler
 jmp USART_UDRE ; UDR Empty Handler
 jmp USART_TXC ; USART TX Complete Handler
 jmp ADC_INTERRUPT ; ADC Conversion Complete Handler
 jmp EE_RDY ; EEPROM Ready Handler
 jmp ANA_COMP ; Analog Comparator Handler
 jmp TWI ; Two-wire Serial Interface Handler
 jmp SPM_RDY ; Store Program Memory Ready Handler

#endif	


