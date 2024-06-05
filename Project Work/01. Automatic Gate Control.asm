;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Design a system to open and close a gate automatically based on vehicle 
;   detection using sensors connected to port 20H. The system operates as follows:
;
;   1. The vehicle detection sensor provides an 8-bit reading through port 20H.
;      - 01H: Vehicle detected
;      - 00H: No vehicle detected
;   2. If a vehicle is detected, the gate should open by sending a signal to port 21H.
;      - 01H: Open gate
;      - 00H: Close gate
;   3. If no vehicle is detected, the gate should close.
;
;   Use the following ports:
;   - Port 20H: Vehicle detection sensor
;   - Port 21H: Gate control
;----------------------------------------------------------------------------------

.MODEL SMALL
.STACK 100H
.DATA
    vehicle_detected_message DB 'Vehicle detected, opening gate...', 0DH, 0AH, '$'
    vehicle_not_detected_message DB 'No vehicle detected, closing gate...', 0DH, 0AH, '$'
.CODE
MAIN PROC
    MOV AX, @DATA       ; initialize data segment
    MOV DS, AX

START:
    IN AL, 20H          ; read vehicle detection sensor
    CMP AL, 01H         ; compare with 01H to check if a vehicle is detected
    JE OPEN_GATE        ; if vehicle is detected, jump to OPEN_GATE
    JMP CLOSE_GATE      ; if no vehicle is detected, jump to CLOSE_GATE

OPEN_GATE:
    MOV AL, 01H         ; move 01H to AL to open gate
    OUT 21H, AL         ; send open gate signal to port 21H
    LEA DX, vehicle_detected_message
    CALL DISPLAY_MESSAGE
    JMP START           ; go back to start

CLOSE_GATE:
    MOV AL, 00H         ; move 00H to AL to close gate
    OUT 21H, AL         ; send close gate signal to port 21H
    LEA DX, vehicle_not_detected_message
    CALL DISPLAY_MESSAGE
    JMP START           ; go back to start

DISPLAY_MESSAGE PROC
    MOV AH, 09H         ; DOS function: display string
    INT 21H             ; call DOS interrupt
    RET
DISPLAY_MESSAGE ENDP

MAIN ENDP

END MAIN

; ------------------------------------------------------------------------------------------