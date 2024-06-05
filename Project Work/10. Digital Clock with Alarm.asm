;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Implement a digital clock with alarm functionality, displaying time and
;   triggering alarms based on user input at port 2AH.
;
;   --------Assume, port 2AH receives user input for setting the alarm and port 2BH
;   controls the display and alarm (01H = trigger alarm, 00H = no alarm).---------
;----------------------------------------------------------------------------------

#ORG 3900H

; to loop back to start
start:

    ; read user input from port 2AH
    IN 2AH

    ; check if alarm needs to be triggered (example condition, bit 0 is set)
    ANI 01H

    ; if alarm needs to be triggered, jump to trigger_alarm
    JNZ trigger_alarm

    ; if alarm does not need to be triggered, jump to no_alarm
    JMP no_alarm

; defining the label to trigger the alarm
trigger_alarm:

    ; move 01H to accumulator (trigger alarm command)
    MVI A, 01H

    ; send the trigger alarm command to port 2BH
    OUT 2BH, A

    ; go back to start
    JMP start

; defining the label for no alarm
no_alarm:

    ; move 00H to accumulator (no alarm command)
    MVI A, 00H

    ; send the no alarm command to port 2BH
    OUT 2BH, A

    ; go back to start
    JMP start

HLT

; Define constants for 7-segment display patterns
SEGMENTS equ 4 ; Number of 7-segment displays
DISPLAY_DELAY equ 1000 ; Delay for displaying each segment (adjust as needed)

; Define memory location for time data and alarm time
TIME_DATA equ 78H
ALARM_TIME equ 80H

; Define 7-segment display patterns
SEGMENT_PATTERNS DB 7FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 67H ; 0-9 patterns

; Define subroutine to display time on 7-segment displays
DISPLAY_TIME:
    MOV CX, SEGMENTS ; Number of displays
    MOV SI, TIME_DATA ; Start address of time data
DISPLAY_LOOP:
    MOV AL, [SI] ; Get digit from memory
    MOV BL, SEGMENT_PATTERNS[AL] ; Get 7-segment pattern
    OUT 2BH, BL ; Output pattern to display port
    CALL DELAY ; Delay for display
    INC SI ; Move to next digit
    LOOP DISPLAY_LOOP ; Repeat for all displays
    RET

; Define subroutine to delay for displaying each segment
DELAY:
    MOV DX, DISPLAY_DELAY ; Load delay value
DELAY_LOOP:
    DEC DX ; Decrement delay counter
    JNZ DELAY_LOOP ; Loop until delay counter is zero
    RET

;----------------------------------------------------------------------------------
