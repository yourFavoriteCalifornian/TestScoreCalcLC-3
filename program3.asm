.ORIG x3000         ; Origination address

; Display welcome message 
    LEA R0, WELCOME_MSG              ; Load address of welcome message
    PUTS                    ; Print welcome message
WELCOME_MSG .STRINGZ "\nEnter 5 test scores: *scores can range from 0 to 99\n"

; Use appropriate labels and comments
    LD R0, NEWLINE
    OUT

; Get 5 user input for 5 test scores and store in array
; Use subroutine calls and branching for control

; 1st score
    JSR GET_GRADE           ; Call subroutine to get user input for a grade
    LEA R6, GRADES          ; Load address of GRADES array
    STR R3, R6, #0          ; Store the grade in the first element of the array
    JSR GET_LETTER          ; Call subroutine to determine the letter grade
    JSR POP                 ; Pop the letter grade from the stack and print it
    LD R0, NEWLINE
    OUT

; 2nd score
    JSR GET_GRADE
    LEA R6, GRADES
    STR R3, R6, #1          ; Store the grade in the second element of the array
    JSR GET_LETTER
    JSR POP
    LD R0, NEWLINE
    OUT

; 3rd score
    JSR GET_GRADE
    LEA R6, GRADES
    STR R3, R6, #2          ; Store the grade in the third element of the array
    JSR GET_LETTER
    JSR POP
    LD R0, NEWLINE
    OUT

; 4th score
    JSR GET_GRADE
    LEA R6, GRADES
    STR R3, R6, #3          ; Store the grade in the fourth element of the array
    JSR GET_LETTER
    JSR POP
    LD R0, NEWLINE
    OUT

; 5th score
    JSR GET_GRADE
    LEA R6, GRADES
    STR R3, R6, #4          ; Store the grade in the fifth element of the array
    JSR GET_LETTER
    JSR POP
    LD R0, NEWLINE
    OUT

; Calculate maximum score
CALCULATE_MAX
    LD R1, NUM_SCORES        ; Load the number of tests
    LEA R2, GRADES          ; Load address of GRADES array
    LD R4, GRADES           ; Load the first grade as the initial maximum
    ST R4, MAX_GRADE        ; Store the initial maximum grade
    ADD R2, R2, #1          ; Move to the next grade in the array
    LOOP1 LDR R5, R2, #0    ; Load the current grade
    NOT R4, R4              ; Negate the current maximum grade
    ADD R4, R4, #1
    ADD R5, R5, R4          ; Compare the current grade with the maximum grade
    BRp NEXT1               ; If the current grade is greater, update the maximum
    LEA R0, MAX             ; Load address of "Maximum Score: " message
    PUTS                    ; Print the message
    LD R3, MAX_GRADE        ; Load the maximum grade
    AND R1, R1, #0
    JSR BREAK_INT           ; Call subroutine to break the integer into digits and print it
    LD R0, SPACE
    OUT
    LD R0, NEWLINE
    OUT
    JSR CLEAR_REG           ; Call subroutine to clear registers R1-R6

; Calculate minimum score
CALCULATE_MIN
    LD R1, NUM_SCORES
    LEA R2, GRADES
    LD R4, GRADES           ; Load the first grade as the initial minimum
    ST R4, MIN_GRADE        ; Store the initial minimum grade
    ADD R2, R2, #1          ; Move to the next grade in the array
    ADD R1, R1, #-1         ; Decrement the loop counter
    LOOP2 LDR R5, R2, #0    ; Load the current grade
    NOT R4, R4              ; Negate the current minimum grade
    ADD R4, R4, #1
    ADD R5, R5, R4          ; Compare the current grade with the minimum grade
    BRn NEXT2               ; If the current grade is smaller, update the minimum
    ADD R2, R2, #1          ; Move to the next grade in the array
    LD R4, GRADES           ; Reset the minimum grade to the first grade
    AND R5, R5,#0
    ADD R1,R1,#-1           ; Decrement the loop counter
    BRp LOOP2               ; If there are more grades to compare, continue the loop
    LEA R0, MIN             ; Load address of "Minimum Score: " message
    PUTS                    ; Print the message
    LD R3, MIN_GRADE        ; Load the minimum grade
    AND R1, R1, #0
    JSR BREAK_INT           ; Call subroutine to break the integer into digits and print it
    LD R0, SPACE
    OUT
    JSR CLEAR_REG
    LD R0, NEWLINE
    OUT

; Calculate average score
CALC_AVG
    LD R1, NUM_SCORES        ; Load the number of tests
    LEA R2, GRADES          ; Load address of GRADES array
    GEN_SUM LDR R4, R2, #0  ; Load the current grade
    ADD R3, R3, R4          ; Add the current grade to the sum
    ADD R2, R2, #1          ; Move to the next grade in the array
    ADD R1, R1, #-1         ; Decrement the loop counter
    BRp GEN_SUM             ; If there are more grades to add, continue the loop
    LD R1, NUM_SCORES        ; Load the number of tests
    NOT R1, R1              ; Negate the number of tests
    ADD R1, R1, #1
    ADD R4, R3, #0          ; Copy the sum to R4
    LOOP3 ADD R4, R4, #0    ; Check if the sum is divisible by the number of tests
    BRnz DONE_AVG           ; If the sum is not divisible, skip the division
    ADD R6, R6, #1          ; Increment the quotient (average)
    ADD R4, R4, R1          ; Subtract the number of tests from the sum
    BRp LOOP3               ; If the sum is still positive, continue the loop
    DONE_AVE
    ST R6, AVERAGE_SCORE    ; Store the average score
    LEA R0, AVG             ; Load address of "Average Score: " message
    PUTS                    ; Print the message
    AND R3, R3, #0
    AND R1, R1, #0
    AND R4, R4, #0
    ADD R3, R3, R6          ; Load the average score
    JSR BREAK_INT           ; Call subroutine to break the integer into digits and print it

; Restart program if desired
    JSR RESTART_PROG        ; Call subroutine to prompt the user to restart the program
    HALT

; Using appropriate system call directives
; Fill addresses and data storage
NEWLINE .FILL xA
SPACE .FILL X20
ASCII_TO_DECIMAL .FILL #-48
DECIMAL_TO_ASCII .FILL #48
UNUSED_LABEL .FILL #-30
NUM_SCORES .FILL #5
RESTART2 .FILL x3000
MAX_GRADE .BLKW #1          ; Reserve memory for storing the maximum grade
MIN_GRADE .BLKW #1          ; Reserve memory for storing the minimum grade
DONE_AVG .BLKW #1
AVERAGE_SCORE .BLKW #1      ; Reserve memory for storing the average score

; Branches for calculating min and max
NEXT2
LDR R4, R2, #0              ; Load the current grade
ST R4, MIN_GRADE            ; Update the minimum grade
ADD R2, R2, #1              ; Move to the next grade in the array
ADD R1, R1, #-1             ; Decrement the loop counter
BRnzp LOOP2                 ; Continue the loop
NEXT1
LDR R4, R2, #0              ; Load the current grade
ST R4, MAX_GRADE            ; Update the maximum grade
ADD R2, R2, #1              ; Move to the next grade in the array
ADD R1, R1, #-1             ; Decrement the loop counter
BRp LOOP1                   ; Continue the loop

; Array to store test scores
GRADES .BLKW #5             ; Reserve memory for storing 5 test scores

; Messages for displaying results
MIN .STRINGZ "Minimum Score: "
MAX .STRINGZ "Maximum Score: "
AVG .STRINGZ "Average Score: "

; Subroutine to restart the program
RESTART_PROG
ST R7, SAVELOC1             ; Save the return address
LD R1, LOWER_Y              ; Load the ASCII value of lowercase 'y'
LD R3, UPPER_Y              ; Load the ASCII value of uppercase 'Y'
LD R2, ORIGIN               ; Load the address to jump to for restarting the program
LD R0, NEWLINE
OUT
LEA R0 RESTARTPROG_STR      ; Load address of the prompt message
PUTS                        ; Print the prompt message
LD R0, NEWLINE
OUT
GETC                        ; Get a character from the user
ADD R1, R1, R0              ; Compare the input with lowercase 'y'
BRz RESTART_TRUE            ; If the input is 'y', restart the program
ADD R3, R3, R0              ; Compare the input with uppercase 'Y'
BRz RESTART_TRUE            ; If the input is 'Y', restart the program
HALT                        ; If the input is neither 'y' nor 'Y', halt the program
RESTART_TRUE
JMP R2                      ; Jump to the address for restarting the program
RESTARTPROG_STR .STRINGZ "\nWOULD YOU LIKE TO RUN THIS PROGRAM AGAIN? Y/N "
LOWER_Y .FILL xFF87         ; ASCII value of lowercase 'y'
UPPER_Y .FILL xFFA7         ; ASCII value of uppercase 'Y'
ORIGIN .FILL x3000          ; Address to jump to for restarting the program

; Data storage for subroutines
SAVELOC1 .FILL X0           ; Storage for saving return address
SAVELOC2 .FILL X0           ; Storage for saving return address
SAVELOC3 .FILL X0           ; Storage for saving register values
SAVELOC4 .FILL X0           ; Storage for saving register values
SAVELOC5 .FILL X0           ; Storage for saving register values

; Subroutine to get user input for a test score
GET_GRADE ST R7, SAVELOC1   ; Save the return address
JSR CLEAR_REG               ; Call subroutine to clear registers R1-R6
LD R4, ASCII_TO_DECIMAL           ; Load the value for decoding ASCII digits
GETC                        ; Get the first digit of the grade
JSR VALIDA                  ; Call subroutine to validate the input
OUT                         ; Echo the input
ADD R1, R0, #0              ; Move the input to R1
ADD R1, R1, R4              ; Convert the ASCII digit to its numeric value
ADD R2, R2, #10             ; Set the loop counter for multiplying by 10
MULT10 ADD R3, R3, R1       ; Multiply the previous value by 10 and add the current digit
ADD R2, R2, #-1             ; Decrement the loop counter
BRp MULT10                  ; If the loop counter is positive, continue the loop
GETC                        ; Get the second digit of the grade
JSR VALIDA                  ; Call subroutine to validate the input
OUT                         ; Echo the input
ADD R0, R0, R4              ; Convert the ASCII digit to its numeric value
ADD R3, R3, R0              ; Add the second digit to the grade
LD R0, SPACE
OUT                         ; Print a space
LD R7, SAVELOC1             ; Restore the return address
RET                         ; Return from the subroutine

; Subroutine to break an integer into two digits for printing
BREAK_INT
ST R7, SAVELOC1             ; Save the return address
LD R5, DECIMAL_TO_ASCII           ; Load the value for encoding digits as ASCII
ADD R4, R3, #0              ; Copy the integer to R4
DIV1 ADD R1, R1, #1         ; Increment the quotient
ADD R4, R4, #-10            ; Subtract 10 from the integer
BRp DIV1                    ; If the result is positive, continue the division loop
ADD R1, R1 #-1              ; Decrement the quotient to get the correct value
ADD R4, R4, #10             ; Add 10 back to the remainder
ADD R6, R4, #-10            ; Check if the remainder is negative
BRnp POS                    ; If the remainder is non-negative, skip the NEG block
NEG ADD R1, R1, #1          ; If the remainder is negative, increment the quotient
ADD R4, R4, #-10            ; Subtract 10 from the remainder
POS ST R1, Q                ; Store the quotient
ST R4, R                    ; Store the remainder
LD R0, Q                    ; Load the quotient
ADD R0, R0, R5              ; Convert the quotient to ASCII
OUT                         ; Print the quotient
LD R0, R                    ; Load the remainder
ADD R0, R0, R5              ; Convert the remainder to ASCII
OUT                         ; Print the remainder
LD R7, SAVELOC1             ; Restore the return address
RET                         ; Return from the subroutine
R .FILL X0                  ; Storage for the remainder
Q .FILL X0                  ; Storage for the quotient

; Subroutine to push a value onto the stack
PUSH ST R7, SAVELOC2        ; Save the return address
JSR CLEAR_REG               ; Call subroutine to clear registers R1-R6
LD R6, POINTER              ; Load the stack pointer
ADD R6, R6, #0              ; Check if the stack pointer is zero
BRnz STACK_ERROR            ; If the stack pointer is zero or negative, jump to the error block
ADD R6, R6, #-1             ; Decrement the stack pointer
STR R0, R6, #0              ; Store the value at the top of the stack
ST R6, POINTER              ; Update the stack pointer
LD R7, SAVELOC2             ; Restore the return address
RET                         ; Return from the subroutine
POINTER .FILL X4000         ; Initial value of the stack pointer

; Subroutine to pop a value from the stack
POP LD R6, POINTER          ; Load the stack pointer
ST R1, SAVELOC5             ; Save the value of R1
LD R1, BASELINE             ; Load the base address of the stack
ADD R1, R1, R6              ; Check if the stack is empty
BRzp STACK_ERROR            ; If the stack is empty, jump to the error block
LD R1, SAVELOC5             ; Restore the value of R1
LDR R0, R6, #0              ; Load the value from the top of the stack
ST R7, SAVELOC4             ; Save the return address
OUT                         ; Print the value
LD R0, SPACE
OUT                         ; Print a space
ADD R6, R6, #1              ; Increment the stack pointer
ST R6, POINTER              ; Update the stack pointer
LD R7, SAVELOC4             ; Restore the return address
RET                         ; Return from the subroutine
STACK_ERROR LEA R0, ERROR   ; Load address of the error message
PUTS                        ; Print the error message
HALT                        ; Halt the program
BASELINE .FILL xC000        ; Base address of the stack
ERROR .STRINGZ "STACK UNDERFLOW OR UNDERFLOW. HALTING PROGRAM"

; Subroutine to determine the letter grade based on the numeric score
GET_LETTER
    AND R2, R2, #0

    A_GRADE LD R0, A_NUM        ; Load the minimum score for an 'A' grade
        LD R1, A_LET                ; Load the ASCII value for 'A'
        ADD R2, R3, R0              ; Compare the score with the minimum score for 'A'
        BRzp STR_GRADE              ; If the score is greater than or equal to the minimum, store 'A'
    B_GRADE AND R2, R2, #0
        LD R0, B_NUM                ; Load the minimum score for a 'B' grade
        LD R1, B_LET                ; Load the ASCII value for 'B'
        ADD R2, R3, R0              ; Compare the score with the minimum score for 'B'
        BRzp STR_GRADE              ; If the score is greater than or equal to the minimum, store 'B'
    C_GRADE AND R2, R2, #0
        LD R0, C_NUM                ; Load the minimum score for a 'C' grade
        LD R1, C_LET                ; Load the ASCII value for 'C'
        ADD R2, R3, R0              ; Compare the score with the minimum score for 'C'
        BRzp STR_GRADE              ; If the score is greater than or equal to the minimum, store 'C'
    D_GRADE AND R2, R2, #0
        LD R0, D_NUM                ; Load the minimum score for a 'D' grade
        LD R1, D_LET                ; Load the ASCII value for 'D'
        ADD R2, R3, R0              ; Compare the score with the minimum score for 'D'
        BRzp STR_GRADE              ; If the score is greater than or equal to the minimum, store 'D'
    F_GRADE AND R2, R2, #0
        LD R0, F_NUM                ; Load the minimum score for an 'F' grade
        LD R1, F_LET                ; Load the ASCII value for 'F'
        ADD R2, R3, R0              ; Compare the score with the minimum score for 'F'
        BRNZP STR_GRADE             ; Store 'F' for any score below the minimum for 'D'
    RET
    STR_GRADE ST R7, SAVELOC1   ; Save the return address
    AND R0, R0, #0
    ADD R0, R1, #0              ; Move the letter grade to R0
    JSR PUSH                    ; Push the letter grade onto the stack
    LD R7, SAVELOC1             ; Restore the return address
    RET                         ; Return from the subroutine

; Constants for letter grade ranges
A_NUM .FILL #-90            ; Minimum score for an 'A' grade (90)
A_LET .FILL X41             ; ASCII value for 'A'
B_NUM .FILL #-80            ; Minimum score for a 'B' grade (80)
B_LET .FILL X42             ; ASCII value for 'B'
C_NUM .FILL #-70            ; Minimum score for a 'C' grade (70)
C_LET .FILL X43             ; ASCII value for 'C'
D_NUM .FILL #-60            ; Minimum score for a 'D' grade (60)
D_LET .FILL X44             ; ASCII value for 'D'
F_NUM .FILL #-50            ; Minimum score for an 'F' grade (50)
F_LET .FILL X46             ; ASCII value for 'F'

; Subroutine to clear registers R1-R6
CLEAR_REG AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0
RET                         ; Return from the subroutine

; Subroutine for data validation of user input
VALIDA ST R1, SAVELOC5      ; Save the value of R1
ST R2, SAVELOC4             ; Save the value of R2
ST R3, SAVELOC3             ; Save the value of R3
LD R1, DATA_MIN             ; Load the minimum valid ASCII value ('0')
ADD R2, R0, R1              ; Compare the input with the minimum valid value
BRN FAIL                    ; If the input is less than the minimum, jump to the FAIL block
LD R1, DATA_MAX             ; Load the maximum valid ASCII value ('9')
ADD R3, R0, R1              ; Compare the input with the maximum valid value
BRP FAIL                    ; If the input is greater than the maximum, jump to the FAIL block
LD R1, SAVELOC5             ; Restore the value of R1
LD R2, SAVELOC4             ; Restore the value of R2
LD R3, SAVELOC3             ; Restore the value of R3
RET                         ; Return from the subroutine

; Branch for invalid input
FAIL LEA R0, FAIL_STR       ; Load address of the failure message
PUTS                        ; Print the failure message
LD R0, NEWLINE2
OUT                         ; Print a newline
LD R7, RESTART              ; Load the address for restarting the program
JMP R7                      ; Jump to the restart address
FAIL_STR .STRINGZ "INVALID INPUT! RESTARTING PROGRAM..."
RESTART .FILL X3000         ; Address for restarting the program
DATA_MIN .FILL #-48         ; ASCII value for '0'
DATA_MAX .FILL #-57         ; ASCII value for '9'
NEWLINE2 .FILL XA           ; ASCII value for newline
.END                        ; End of the program
