;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Create a GPS navigation system that provides real-time location tracking and 
;   route guidance using port 2DH for GPS data processing. The system should:
;   1. Continuously read GPS coordinates from port 2DH.
;   2. Calculate current position and route to the destination.
;   3. Display real-time location and route guidance on port 2EH.
;----------------------------------------------------------------------------------

ORG 1200H

DATA_SEG SEGMENT
    CURRENT_LAT DW 0    ; current latitude
    CURRENT_LON DW 0    ; current longitude
    DEST_LAT DW 0       ; destination latitude
    DEST_LON DW 0       ; destination longitude
DATA_SEG ENDS

CODE_SEG SEGMENT
ASSUME CS:CODE_SEG, DS:DATA_SEG

START:
    MOV AX, DATA_SEG    ; initialize data segment
    MOV DS, AX

GPS_LOOP:
    IN AL, 2DH          ; read latitude from GPS
    MOV CURRENT_LAT, AL
    IN AL, 2DH+1        ; read longitude from GPS
    MOV CURRENT_LON, AL

    CALL CALCULATE_ROUTE; calculate route to destination
    CALL DISPLAY_GPS    ; display current position and route

    JMP GPS_LOOP        ; loop back to continue tracking

CALCULATE_ROUTE PROC
    ; calculate route from current position to destination
    ; (this is a placeholder, actual implementation would involve complex calculations)
    RET
CALCULATE_ROUTE ENDP

DISPLAY_GPS PROC
    MOV AX, CURRENT_LAT
    OUT 2EH, AX         ; display current latitude
    MOV AX, CURRENT_LON
    OUT 2EH+1, AX       ; display current longitude
    RET
DISPLAY_GPS ENDP

CODE_SEG ENDS
END START

;----------------------------------------------------------------------------------