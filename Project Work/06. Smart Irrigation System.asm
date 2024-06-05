;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Optimize water usage in agricultural fields by controlling irrigation based
;   on soil moisture and weather conditions. Sensors interface with port 25H.
;
;   --------Assume, port 25H receives soil moisture data (low moisture triggers
;   irrigation) and port 26H controls the irrigation system (01H = on, 00H = off).---------
;----------------------------------------------------------------------------------

#ORG 3500H

; to loop back to start
start:

    ; read soil moisture data from port 25H
    IN 25H

    ; check if irrigation is needed (example condition, moisture level < threshold)
    CPI 10H

    ; if irrigation is needed, jump to irrigation_on
    JC irrigation_on

    ; if irrigation is not needed, jump to irrigation_off
    JMP irrigation_off

; defining the label to turn irrigation on
irrigation_on:

    ; move 01H to accumulator (irrigation on command)
    MVI A, 01H

    ; send the irrigation on command to port 26H
    OUT 26H

    ; go back to start
    JMP start

; defining the label to turn irrigation off
irrigation_off:

    ; move 00H to accumulator (irrigation off command)
    MVI A, 00H

    ; send the irrigation off command to port 26H
    OUT 26H

    ; go back to start
    JMP start

HLT

;----------------------------------------------------------------------------------
