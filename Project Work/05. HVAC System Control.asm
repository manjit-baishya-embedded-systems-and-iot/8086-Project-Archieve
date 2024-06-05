;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Regulate heating, ventilation, and air conditioning systems in a building
;   based on temperature and occupancy data received at port 24H.
;
;   --------Assume, port 24H receives temperature and occupancy data and port 25H
;   controls the HVAC system (01H = on, 00H = off).---------
;----------------------------------------------------------------------------------

#ORG 3400H

; to loop back to start
start:

    ; read temperature and occupancy data from port 24H
    IN 24H

    ; check if HVAC needs to be turned on (example condition, temperature > threshold)
    CPI 18H

    ; if HVAC needs to be turned on, jump to hvac_on
    JNC hvac_on

    ; if HVAC needs to be turned off, jump to hvac_off
    JMP hvac_off

; defining the label to turn HVAC on
hvac_on:

    ; move 01H to accumulator (HVAC on command)
    MVI A, 01H

    ; send the HVAC on command to port 25H
    OUT 25H

    ; go back to start
    JMP start

; defining the label to turn HVAC off
hvac_off:

    ; move 00H to accumulator (HVAC off command)
    MVI A, 00H

    ; send the HVAC off command to port 25H
    OUT 25H

    ; go back to start
    JMP start

HLT

;----------------------------------------------------------------------------------
