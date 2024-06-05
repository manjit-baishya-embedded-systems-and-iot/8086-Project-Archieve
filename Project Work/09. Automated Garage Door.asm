;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Open and close a garage door automatically in response to vehicle presence
;   or remote commands received at port 29H.
;
;   --------Assume, port 29H receives vehicle presence or remote command (bit 0 set
;   for open, bit 1 set for close) and port 2AH controls the door (01H = open,
;   00H = close).---------
;----------------------------------------------------------------------------------

#ORG 3800H

; to loop back to start
start:

    ; read command data from port 29H
    IN 29H

    ; check if open command is received (bit 0 is set)
    ANI 01H

    ; if open command is received, jump to open_door
    JNZ open_door

    ; check if close command is received (bit 1 is set)
    ANI 02H

    ; if close command is received, jump to close_door
    JNZ close_door

    ; if no command is received, jump back to start
    JMP start

; defining the label to open the door
open_door:

    ; move 01H to accumulator (open door command)
    MVI A, 01H

    ; send the open door command to port 2AH
    OUT 2AH

    ; go back to start
    JMP start

; defining the label to close the door
close_door:

    ; move 00H to accumulator (close door command)
    MVI A, 00H

    ; send the close door command to port 2AH
    OUT 2AH

    ; go back to start
    JMP start

HLT

;----------------------------------------------------------------------------------
