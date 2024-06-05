;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Check for motion detection data from multiple sensors. The sensors update data
;   from 80H to 87H. Check to see if there is any motion detected, if any of the
;   sensors are sending HIGH. Send signal to owner if so via 67H and ring alarm
;   if user requests so. User request is detected in 44H and alarm is connected in 7EH.
;   
;   --------Assume, ports 80H to 87H receive motion detection data from sensors.
;   Port 67H is used to send a signal to the owner, port 44H detects user requests,
;   and port 7EH controls the alarm (01H = activate, 00H = deactivate).---------
;----------------------------------------------------------------------------------

#ORG 3600H

; to loop back to start
start:

    ; initialize sensor data to 00H
    MVI A, 00H

    ; loop through sensors from 80H to 87H
    MVI B, 80H
    MVI C, 07H  ; total of 8 sensors
    
sensor_loop:
    
    ; read motion detection data from current sensor port
    IN B

    ; check if motion is detected (example condition, sensor data is not 00H)
    CPI 00H

    ; if motion is detected, jump to motion_detected
    JNZ motion_detected

    ; move to the next sensor port
    INX B

    ; decrease the counter
    DCR C

    ; if there are more sensors, loop back to sensor_loop
    JNZ sensor_loop

    ; if no motion is detected from any sensor, jump to no_motion_detected
    JMP no_motion_detected

; defining the label for motion detected
motion_detected:
    
    ; move sensor port number to accumulator for signaling the owner
    MOV A, B

    ; send signal to owner via port 67H
    OUT 67H

    ; check if user requests alarm (bit 0 set in port 44H)
    IN 44H
    ANI 01H

    ; if user requests alarm, jump to activate_alarm
    JNZ activate_alarm

    ; loop back to start
    JMP start

; defining the label for no motion detected
no_motion_detected:
    
    ; loop back to start
    JMP start

; defining the label to activate the alarm
activate_alarm:
    
    ; move 01H to accumulator (activate alarm command)
    MVI A, 01H

    ; send the activate alarm command to port 7EH
    OUT 7EH

    ; loop back to start
    JMP start

HLT

;----------------------------------------------------------------------------------
