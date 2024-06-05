;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Optimize plant growth conditions in a greenhouse by adjusting temperature, 
;   humidity, and lighting based on sensor inputs at port 2EH. The system should:
;   1. Continuously monitor temperature, humidity, and light levels.
;   2. Adjust the environment to maintain optimal conditions for plant growth.
;   The sensors provide data on port 2EH and actuators are controlled via port 2FH.
;----------------------------------------------------------------------------------

ORG 1300H

DATA_SEG SEGMENT
    TEMP_THRESHOLD DW 25  ; optimal temperature threshold
    HUMID_THRESHOLD DW 60 ; optimal humidity threshold
    LIGHT_THRESHOLD DW 80 ; optimal light threshold
DATA_SEG ENDS

CODE_SEG SEGMENT
ASSUME CS:CODE_SEG, DS:DATA_SEG

START:
    MOV AX, DATA_SEG    ; initialize data segment
    MOV DS, AX

CONTROL_LOOP:
    IN AL, 2EH          ; read temperature data
    CMP AL, TEMP_THRESHOLD
    JG COOLING_ON       ; if temperature exceeds threshold, turn on cooling
    JL HEATING_ON       ; if temperature below threshold, turn on heating

COOLING_ON:
    MOV AL, 01H         ; signal to turn on cooling system
    OUT 2FH, AL
    JMP CHECK_HUMIDITY

HEATING_ON:
    MOV AL, 02H         ; signal to turn on heating system
    OUT 2FH, AL

CHECK_HUMIDITY:
    IN AL, 2EH+1        ; read humidity data
    CMP AL, HUMID_THRESHOLD
    JG HUMIDIFY_OFF     ; if humidity exceeds threshold, turn off humidifier
    JL HUMIDIFY_ON      ; if humidity below threshold, turn on humidifier

HUMIDIFY_ON:
    MOV AL, 03H         ; signal to turn on humidifier
    OUT 2FH, AL
    JMP CHECK_LIGHT

HUMIDIFY_OFF:
    MOV AL, 04H         ; signal to turn off humidifier
    OUT 2FH, AL

CHECK_LIGHT:
    IN AL, 2EH+2        ; read light data
    CMP AL, LIGHT_THRESHOLD
    JG LIGHTS_OFF       ; if light exceeds threshold, turn off lights
    JL LIGHTS_ON        ; if light below threshold, turn on lights

LIGHTS_ON:
    MOV AL, 05H         ; signal to turn on lights
    OUT 2FH, AL
    JMP CONTROL_LOOP

LIGHTS_OFF:
    MOV AL, 06H         ; signal to turn off lights
    OUT 2FH, AL
    JMP CONTROL_LOOP

CODE_SEG ENDS
END START

;----------------------------------------------------------------------------------