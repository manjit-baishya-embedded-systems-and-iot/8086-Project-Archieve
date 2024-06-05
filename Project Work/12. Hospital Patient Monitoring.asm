;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Continuously monitor vital signs of patients in a hospital and alert medical 
;   staff to any abnormalities. Sensors interface with port 2CH. The system should:
;   1. Read heart rate, blood pressure, and oxygen levels.
;   2. Compare readings against predefined thresholds.
;   3. Alert medical staff via port 2DH if abnormalities are detected.
;----------------------------------------------------------------------------------

ORG 1100H

DATA_SEG SEGMENT
    HR_THRESHOLD DW 100  ; heart rate threshold
    BP_THRESHOLD DW 140  ; blood pressure threshold
    O2_THRESHOLD DW 95   ; oxygen level threshold
DATA_SEG ENDS

CODE_SEG SEGMENT
ASSUME CS:CODE_SEG, DS:DATA_SEG

START:
    MOV AX, DATA_SEG    ; initialize data segment
    MOV DS, AX

MONITOR_LOOP:
    IN AL, 2CH          ; read sensor data from port 2CH
    MOV BL, AL
    MOV BH, 0
    CMP BL, HR_THRESHOLD
    JG ALERT            ; if heart rate exceeds threshold, alert

    IN AL, 2CH+1        ; read next sensor data (blood pressure)
    MOV BL, AL
    CMP BL, BP_THRESHOLD
    JG ALERT            ; if blood pressure exceeds threshold, alert

    IN AL, 2CH+2        ; read next sensor data (oxygen levels)
    MOV BL, AL
    CMP BL, O2_THRESHOLD
    JL ALERT            ; if oxygen level is below threshold, alert

    JMP MONITOR_LOOP    ; continue monitoring

ALERT:
    MOV AL, 01H         ; alert signal
    OUT 2DH, AL
    JMP MONITOR_LOOP    ; continue monitoring

CODE_SEG ENDS
END START

;----------------------------------------------------------------------------------