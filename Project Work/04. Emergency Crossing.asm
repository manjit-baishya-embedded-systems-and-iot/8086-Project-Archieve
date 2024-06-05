;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Design a system that allows emergency pedestrian crossing by changing the
;   traffic light. Port 23H interfaces with security card sensors.
;
;   --------Assume, port 23H receives data from security card sensors and port 24H
;   controls the traffic light (01H = green light for pedestrians, 00H = red light
;   for pedestrians).---------
;----------------------------------------------------------------------------------

#ORG 3300H

; to loop back to start
start:

    ; read security card sensor data from port 23H
    IN 23H

    ; check if emergency crossing is needed (example condition, bit 0 is set)
    ANI 01H

    ; if emergency crossing is needed, jump to allow_crossing
    JNZ allow_crossing

    ; if no emergency crossing, jump to no_crossing
    JMP no_crossing

; defining the label to allow crossing
allow_crossing:

    ; move 01H to accumulator (green light command)
    MVI A, 01H

    ; send the green light command to port 24H
    OUT 24H

    ; Go to traffic light sequence with an interrupt for pedestrian crossing
    JMP traffic_light

; defining the label for no crossing
no_crossing:

    ; move 00H to accumulator (red light command)
    MVI A, 00H

    ; send the red light command to port 24H
    OUT 24H

    ; Go to traffic light sequence
    JMP traffic_light

; Define an interrupt handler for pedestrian crossing
INTERRUPT_HANDLER:
    ; Set the traffic light to yellow (10s for yellow)
    MVI A, 02H ; Yellow light command
    OUT 24H, A
    ; End the interrupt routine
    EI ; Enable interrupts
    RET ; Return from interrupt

; Define the traffic light sequence
traffic_light:

    ; Loop for 10 seconds for green light
    MOV CX, 1000
    MOV AX, 0FFFFH ; Set AX to maximum value
    CALL DELAY_LOOP ; Call delay function

    ; Loop for 5 seconds for yellow light (interrupt may occur here)
    MOV CX, 500
    MOV AX, 0FFFFH ; Set AX to maximum value
    CALL DELAY_LOOP ; Call delay function

    ; Loop for 10 seconds for red light
    MOV CX, 1000
    MOV AX, 0FFFFH ; Set AX to maximum value
    CALL DELAY_LOOP ; Call delay function

    ; Go back to start of traffic light sequence
    JMP traffic_light

; Delay loop function
DELAY_LOOP:
    DEC AX ; Decrement AX
    JNZ DELAY_LOOP ; Jump if not zero
    RET ; Return from delay loop

HLT

;----------------------------------------------------------------------------------
