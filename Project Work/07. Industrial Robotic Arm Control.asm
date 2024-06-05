;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Coordinate the movements of a robotic arm in manufacturing processes for
;   precise assembly tasks. Commands are received at port 26H.
;
;   --------Assume, port 26H receives commands for the robotic arm and port 27H
;   controls the arm's movements (01H = move, 00H = stop).---------
;----------------------------------------------------------------------------------

#ORG 3600H

; to loop back to start
start:

    ; read command data from port 26H
    IN 26H

    ; check the type of command
    CPI 00H
    JZ move_left
    CPI 01H
    JZ move_right
    CPI 02H
    JZ move_up
    CPI 03H
    JZ move_down
    
    ; if command type not recognized, jump to no_move
    JMP no_move

move_left:
    ; move left command
    MVI A, 01H ; move command
    OUT 27H, A ; send the move command to port 27H
    JMP start ; go back to start

move_right:
    ; move right command
    MVI A, 02H ; move command
    OUT 27H, A ; send the move command to port 27H
    JMP start ; go back to start

move_up:
    ; move up command
    MVI A, 03H ; move command
    OUT 27H, A ; send the move command to port 27H
    JMP start ; go back to start

move_down:
    ; move down command
    MVI A, 04H ; move command
    OUT 27H, A ; send the move command to port 27H
    JMP start ; go back to start

no_move:
    ; no move command received
    MVI A, 00H ; stop command
    OUT 27H, A ; send the stop command to port 27H
    JMP start ; go back to start

HLT

;----------------------------------------------------------------------------------
