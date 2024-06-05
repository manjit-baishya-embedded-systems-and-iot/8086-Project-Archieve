;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Monitor the stock levels of items in a warehouse and generate alerts when
;   inventory runs low. Sensors connected to port 67H update the stock count
;   when the sensor at port 34H is HIGH.
;
;   --------Assume, port 67H updates stock level data, and port 89H receives
;   an alert signal with the index of the item (01H = alert, 00H = no alert).---------
;----------------------------------------------------------------------------------

#ORG 3200H

; to loop back to start
start:

    ; Load stock data from memory locations 4000H to 4511H
    MOV SI, 4000H
    MOV DI, OFFSET STOCK
    MOV CX, 512

LOAD_STOCK:
    IN 67H
    ANI 01H
    JZ SKIP_UPDATE
    MOV AL, 01H
    MOV [SI], AL
    JMP CONTINUE_LOAD

SKIP_UPDATE:
    MOV AL, 00H
    MOV [SI], AL

CONTINUE_LOAD:
    INC SI
    LOOP LOAD_STOCK

    ; Check if any stock is low (less than 10)
    MOV SI, OFFSET STOCK
    MOV CX, 512

CHECK_STOCK:
    MOV AL, [SI]
    CMP AL, 10H
    JAE NO_ALERT
    ; If stock is low, send an alert signal to port 89H with the index of the item
    MOV AL, SI
    OUT 89H, AL

NO_ALERT:
    INC SI
    LOOP CHECK_STOCK

    ; Go back to start
    JMP start

HLT

STOCK DB 512 DUP(0) ; array to hold stock values

;----------------------------------------------------------------------------------
