.MODEL SMALL
.STACK 100
.DATA
	NL DB 10,13, '$'
	;LOGIN
	GET_USERNAME DB "Input username: $"
	GET_PASSWORD DB "Input Password: $"
	
	INPUT_USERNAME LABEL BYTE
	MAXN_U DB 30
	ACTN_U DB ?
	OUTPUT_USERNAME DB 30 DUP ("$")
	
	INPUT_PASSWORD LABEL BYTE
	MAXN_P DB 30
	ACTN_P DB ?
	OUTPUT_PASSWORD DB 30 DUP ("$")
	
	SUCCESS DB "LOGGED IN SUCCESSFULLY$"
	FAIL DB "LOG IN FAILED$"
	
	USERNAME_FAIL DB "WRONG USERNAME$"
	PASSWORD_FAIL DB "WRONG PASSWORD$"
	
	USERNAME DB "admin"
	PASSWORD DB "1234"
	
	TELL_COUNTER DB "TRIES LEFT: $"
	COUNTER_USERNAME DB 3
	COUNTER_PASSWORD DB 3
	
	;MAIN MENU
	DASH DB "====================$"
	MENU DB "     MAIN MENU     $"
	MENU_OPT1 DB "1. BOOK A VENUE$"
	MENU_OPT2 DB "2. VIEW PRICES AND PACKAGES$"
	MENU_OPT3 DB "3. EXIT$"
	GET_CHOICE DB "ENTER YOUR CHOICE (1-3): $"
	CHOICE DB ?
	INVALID_CHOICE DB "CHOICE IS INVALID, PLEASE TRY AGAIN$"
	
	;SUB MENU 1, SELECTING OPTION
	SM1 DB 10,13, "--- VENUE SELECTION ---$"
	SM1_OPT1 DB "1. Seminar Room (RM 50/hr)$"
	SM1_OPT2 DB "2. Banquet Hall (RM 80/hr)$"
	SM1_OPT3 DB "3. Auditorium (RM 150/hr)$"
	SM1_GETCHOICE DB "Enter your venue (1-3): $"
	SM1_GETHOUR DB "Enter duration (1-9 hours): $"
	SM1_CHOICE DB ?
	SM1_HOUR DB ?
	INVALID_HOURS DB "INVALID HOURS! ENTER A NUMBER FROM 1-9$"
	
	;CALCULATIONS
	BASE_RATE DB ?
	DISCOUNT DB ?
	TOTAL_COST DW ?
	TEN DW 10
	
	;RECEIPT
	BOOKING_RECEIPT DB 10,13, "=====BOOKING RECEIPT====$"
	BASE_RECEIPT DB 10,13, "BASE HOURLY RATE: RM$"
	HOURS_RECEIPT DB 10,13, "HOURS BOOKED: $"
	DISCOUNT_RECEIPT DB 10,13,  "DISCOUNT APPLIED: RM$"
	TOTAL_RECEIPT DB 10,13,  "GRAND TOTAL: RM$"
	AVG_RECEIPT DB 10,13, "AVERAGE COST PER HOUR: RM$"
	
	;SUB MENU 2, DISPLAYING STUFF
	SM2_MAIN DB 10,13, "====================",10,13
			DB "   PRICES & PACKAGES     ",10,13
			DB "====================",10,13
            DB 10,13
            DB "1. Seminar Room    RM  50/hr",10,13
            DB "2. Banquet Hall    RM  80/hr",10,13
            DB "3. Auditorium      RM 150/hr",10,13
            DB 10,13
            DB "--- PACKAGE DEALS ---",10,13
            DB "Book 5+ hours  ->  RM 20 off",10,13
            DB "All bookings   ->  RM 20 tax added",10,13
            DB 10,13, "PRESS ANY KEY TO RETURN TO THE MAIN MENU...$"
	;SUB MENU 3
	sm3_confirmation DB "Are you sure you want to exit(Y/N): $"
	
.CODE
MAIN PROC
	MOV AX,@DATA
	MOV DS,AX
	
try_again:
	MOV AH,09H
	LEA DX,GET_USERNAME
	INT 21H
	
	MOV AH,0AH
	LEA DX,INPUT_USERNAME
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AL, ACTN_U                
	CMP AL, 5                       
	JE valid_userlength                 
                                   

wrong_user:
	MOV AH,09H
	LEA DX,USERNAME_FAIL
	INT 21H
	
	DEC COUNTER_USERNAME     
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,TELL_COUNTER
	INT 21H
	
	MOV AH,02H
	MOV DL,COUNTER_USERNAME
	ADD DL,30H                     
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	; CHECK IF STILL HAS TRIES LEFT
	CMP COUNTER_USERNAME, 0                  
	JG try_again                   
	
	; FAIL
	MOV AH, 09H
	LEA DX, FAIL
	INT 21H
	JMP finish               
	
valid_userlength:
	LEA SI, OUTPUT_USERNAME         ; SI points to typed username [Chapter 5]
	LEA DI, USERNAME        
	
	MOV CX, 5                       
compareUser_loop:
	MOV AL, [SI]
	CMP AL, [DI]
	JE word_equal                
	JMP wrong_user                
word_equal:
	INC SI                        
	INC DI                     
	LOOP compareUser_loop            
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	; PASSWORD checking
password_tryagain:
	MOV AH,09H
	LEA DX,GET_PASSWORD
	INT 21H
	
	MOV AH,0AH
	LEA DX,INPUT_PASSWORD
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	CMP ACTN_P,4
	JE valid_passlength
	
wrong_password:
	MOV AH,09H
	LEA DX,PASSWORD_FAIL
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	DEC COUNTER_PASSWORD
	
	MOV AH,09H
	LEA DX,TELL_COUNTER
	INT 21H
	
	MOV AH,02H
	MOV DL,COUNTER_PASSWORD
	ADD DL,30H
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	CMP COUNTER_PASSWORD,0
	JNE password_tryagain
	JMP finish
	
valid_passlength:
	LEA SI,OUTPUT_PASSWORD
	LEA DI,PASSWORD
	
	MOV CX,0
	MOV CX,4
	
num_check: 
	MOV AL,[SI]
	CMP AL,[DI]
	JE continue_passcheck
	JMP wrong_password
continue_passcheck:
	INC SI
	INC DI
	LOOP num_check
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,SUCCESS
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	;MAIN MENU
main_menu:
	MOV AH,09H
	LEA DX,DASH
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,MENU
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,DASH
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,MENU_OPT1
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,MENU_OPT2
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,MENU_OPT3
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,GET_CHOICE
	INT 21H
	
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV CHOICE,AL
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	CMP CHOICE,1
	JNE check_opt2                
	JMP ifOpt1                   
	
check_opt2:
	CMP CHOICE,2
	JNE check_opt3                 
	JMP ifOpt2                    
	
check_opt3:
	CMP CHOICE,3
	JNE sm1_invalidChoice             
	JMP ifOpt3                     
	
sm1_invalidChoice:
	MOV AH,09H
	LEA DX,INVALID_CHOICE
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	JMP main_menu
	
ifOpt1:
	MOV AH,09H
	LEA DX,SM1
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H
	LEA DX,SM1_OPT1
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,SM1_OPT2
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,SM1_OPT3
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,SM1_GETCHOICE
	INT 21H
	
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV SM1_CHOICE,AL
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	CMP SM1_CHOICE,1
	JNB sm1_next1 
	MOV AH,09H
	LEA DX,INVALID_CHOICE
	INT 21H
	JMP ifOpt1
	
sm1_next1:
	CMP SM1_CHOICE,3
	JNA sm1_next2
	MOV AH,09H
	LEA DX,INVALID_CHOICE
	INT 21H
	JMP ifOpt1
sm1_next2:
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,SM1_GETHOUR
	INT 21H

	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV SM1_HOUR,AL
	
	;CHECK IF HOUR IS CORRECT
	CMP SM1_HOUR,1
	JB ifInvalidHour
	CMP SM1_HOUR,9
	JA ifInvalidHour
	JMP validHour
	
ifInvalidHour:
	MOV AH,09H
	LEA DX,INVALID_HOURS
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	JMP sm1_next2
	
validHour:
	;CHECKING CHOICE
	CMP SM1_CHOICE,1
	JE ifSeminar
	CMP SM1_CHOICE,2
	JE ifBanquet
	CMP SM1_CHOICE,3
	JE ifAuditorium
ifSeminar:
	MOV BASE_RATE,50
	JMP calculation
ifBanquet:
	MOV BASE_RATE,80
	JMP calculation
ifAuditorium:
	MOV BASE_RATE,150
	
calculation:   ;base rate * hours
	MOV AL,BASE_RATE
	MOV BL,SM1_HOUR
	MUL BL 
	MOV TOTAL_COST,AX 
	
	CMP SM1_HOUR,5   ;give discount if booked duration more than 5 hours
	JA IfDiscount
	MOV DISCOUNT,0
	JMP taxCalculation
IfDiscount:    
	MOV DISCOUNT,20
	SUB TOTAL_COST,20
taxCalculation:
	ADD TOTAL_COST,20   ;RM20 as tax
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,BOOKING_RECEIPT
	INT 21H
	
    ;DISPLAY MULTIPLE DIGITS
    MOV AH,09H
    LEA DX,BASE_RECEIPT
    INT 21H

    MOV AL,BASE_RATE
    MOV AH,0
    MOV CX,0
p_rate_loop:
    MOV DX,0
    DIV TEN
    PUSH DX
    INC CX
    CMP AX,0
    JNE p_rate_loop
p_rate_digits:
    POP DX
    ADD DL,30H
    MOV AH,02H
    INT 21H
    LOOP p_rate_digits

      ;--- Hours booked (1-9, single digit is fine) ---
    MOV AH,09H
    LEA DX,HOURS_RECEIPT
    INT 21H

    MOV DL,SM1_HOUR
    ADD DL,30H
    MOV AH,02H
    INT 21H

      ;--- Discount applied ---
    MOV AH,09H
    LEA DX,DISCOUNT_RECEIPT
    INT 21H

    MOV AL,DISCOUNT
    MOV AH,0
    MOV CX,0
p_disc_loop:
    MOV DX,0
    DIV TEN
    PUSH DX
    INC CX
    CMP AX,0
    JNE p_disc_loop
p_disc_digits:
    POP DX
    ADD DL,30H
    MOV AH,02H
    INT 21H
    LOOP p_disc_digits

      ;--- Grand total ---
    MOV AH,09H
    LEA DX,TOTAL_RECEIPT
    INT 21H

    MOV AX,TOTAL_COST
    MOV CX,0
p_tot_loop:
    MOV DX,0
    DIV TEN
    PUSH DX
    INC CX
    CMP AX,0
    JNE p_tot_loop
p_tot_digits:
    POP DX
    ADD DL,30H
    MOV AH,02H
    INT 21H
    LOOP p_tot_digits

    ;AVERAGE COST PER HOUR  
    MOV AH,09H
    LEA DX,AVG_RECEIPT
    INT 21H

    MOV AX,TOTAL_COST
    MOV BX,0
    MOV BL,SM1_HOUR
	MOV DX,0
	DIV BX 
    MOV CX,0
p_avg_loop:
    MOV DX,0
    DIV TEN
    PUSH DX
    INC CX
    CMP AX,0
    JNE p_avg_loop
p_avg_digits:
    POP DX
    ADD DL,30H
    MOV AH,02H
    INT 21H
    LOOP p_avg_digits

	;RETURNING TO MAIN MENU FROM OPT 1
	MOV AH,09H
	LEA DX,NL
	INT 21H
	JMP main_menu                  

ifOpt2:
	MOV AH,09H
	LEA DX,SM2_MAIN
	INT 21H
	
	MOV AH,01H
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	JMP main_menu                  
ifOpt3:
	MOV AH,09H
	LEA DX,sm3_confirmation
	INT 21H
	
	MOV AH,01H
	INT 21H
	
	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	CMP AL,'Y'
	JE finish
	CMP AL,'y'
	JE finish
	JMP main_menu  

	JMP finish
finish:
	MOV AX,4C00H
	INT 21H
MAIN ENDP
END MAIN
