;----------------------------------------------------------------------------------
; Problem Statement:-
;----------------------------------------------------------------------------------
;   Develop a secure electronic voting system allowing voters to cast ballots and 
;   tally results using port 2BH for input and output. The system should:
;   1. Ensure each voter can cast only one vote.
;   2. Record and tally votes securely.
;   3. Display final results upon request.
;   The voting data from port 2BH will have the following format:
;   - Bit 0: Vote for Candidate A
;   - Bit 1: Vote for Candidate B
;   - Bit 2: Vote for Candidate C
;   - Bit 7: Request to display results
;----------------------------------------------------------------------------------

ORG 1000H

DATA_SEG SEGMENT
    VOTES_A DW 0        ; vote count for Candidate A
    VOTES_B DW 0        ; vote count for Candidate B
    VOTES_C DW 0        ; vote count for Candidate C
DATA_SEG ENDS

CODE_SEG SEGMENT
ASSUME CS:CODE_SEG, DS:DATA_SEG

START:
    MOV AX, DATA_SEG    ; initialize data segment
    MOV DS, AX

VOTE_LOOP:
    IN AL, 2BH          ; read input from port 2BH
    TEST AL, 01H        ; check vote for Candidate A
    JZ CHECK_B
    INC WORD PTR VOTES_A; increment vote count for Candidate A
    JMP CHECK_RESULT

CHECK_B:
    TEST AL, 02H        ; check vote for Candidate B
    JZ CHECK_C
    INC WORD PTR VOTES_B; increment vote count for Candidate B
    JMP CHECK_RESULT

CHECK_C:
    TEST AL, 04H        ; check vote for Candidate C
    JZ CHECK_RESULT
    INC WORD PTR VOTES_C; increment vote count for Candidate C

CHECK_RESULT:
    TEST AL, 80H        ; check if results display is requested
    JZ VOTE_LOOP
    CALL DISPLAY_RESULT ; display the voting results
    JMP VOTE_LOOP

DISPLAY_RESULT:
    MOV AX, VOTES_A
    OUT 2BH, AX         ; display vote count for Candidate A
    MOV AX, VOTES_B
    OUT 2BH, AX         ; display vote count for Candidate B
    MOV AX, VOTES_C
    OUT 2BH, AX         ; display vote count for Candidate C
    RET

CODE_SEG ENDS
END START

;----------------------------------------------------------------------------------