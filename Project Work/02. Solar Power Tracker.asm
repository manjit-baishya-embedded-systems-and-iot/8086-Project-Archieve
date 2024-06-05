;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Orient solar panels to maximize sunlight exposure throughout the day using
;   sensor data from 3000H to 3009H. The system should adjust the panel's angle 
;   based on the sensor input.
;
;----------------------------------------------------------------------------------

#ORG 3100H

SENSORS DB 10 DUP(0) ; array to hold sensor values
MAXIMUM DB 0 ; to store the maximum value
INDEX DB 0 ; to store the index of the maximum value

; to loop back to start
start:

    ; Load sensor data from memory locations 3000H to 3009H
    MOV SI, 3000H
    MOV DI, OFFSET SENSORS
    MOV CX, 10

LOAD_SENSORS:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    LOOP LOAD_SENSORS

    ; Find the maximum value and its index
    MOV CX, 10
    MOV SI, OFFSET SENSORS
    MOV DI, 0
    MOV BL, 0 ; BL will hold the maximum value found
    MOV BH, 0 ; BH will hold the index of the maximum value

FIND_MAX:
    MOV AL, [SI]
    CMP AL, BL
    JBE CONTINUE
    MOV BL, AL
    MOV BH, DI

CONTINUE:
    INC SI
    INC DI
    LOOP FIND_MAX

    ; Store the maximum value and its index
    MOV MAXIMUM, BL
    MOV INDEX, BH

    ; Output the maximum value to port 22H
    MOV AL, BL
    OUT 22H, AL

    ; Halt the program
    HLT

;----------------------------------------------------------------------------------
