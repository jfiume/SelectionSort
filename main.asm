;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
		.data
List:	.byte 100, 25, 75, 80, 35, 2, 127, 60, 18, 40, 15, 66, 90, 66, 10, 115, 59, 50, 28, 41
numListElements:
		.byte 20

		.text
	clr.b R4		;address of list
	clr.b R5		;one element of list
	clr.b R6		;current sorted list index
	clr.b R7		;index of smallest
	clr.b R8		;local smallest value
	clr.b R9		;current index


	mov.w #List, R4
	mov.b @R4, R8
select:
	mov.b @R4, R5
	cmp.b R5, R8
	jl increment
	mov.b R5, R8
	mov.b R9, R7
increment:
	inc.b R9
	inc.w R4
	cmp.b R9, numListElements
	jz swap
	jmp select
swap:
	mov.b @R6(List), @R7(List)
	mov.b R8, @R6(List)
	inc.b R6
	cmp.w R6, R9
	jz end
	mov.w #List, R4
	add.w R6, R4
	mov.b @R4, R8
	clr.b R7
	add.b R6, R7
	clr.b R9
	add.b R6, R9
	jmp select
end:
	jmp $
                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
