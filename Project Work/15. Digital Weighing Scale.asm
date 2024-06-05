;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Build a digital weighing scale capable of accurately measuring weights and 
;   displaying results using port 2FH. The system should:
;   1. Continuously read weight measurements from the sensor at port 2FH.
;   2. Display the weight measurements on port 30H.
;----------------------------------------------------------------------------------

ORG 1400H

DATA_SEG SEGMENT
DATA_SEG ENDS

CODE_SEG SEGMENT
ASSUME CS:CODE_SEG, DS:DATA_SEG

START:
    MOV AX, DATA_SEG    ; initialize data segment
    MOV DS, AX

WEIGH_LOOP:
    IN AL, 2FH          ; read weight data from sensor
    MOV BL, AL
    MOV BH, 0
    OUT 30H, BX         ; display weight data
    JMP WEIGH_LOOP      ; loop back to continue weighing

CODE_SEG ENDS
END START

;----------------------------------------------------------------------------------