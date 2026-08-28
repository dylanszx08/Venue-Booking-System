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
	FAIL DB 10,13, "LOG IN FAILED$"
	
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
	INVALID_CHOICE DB "CHOICE IS INVALID, PLEASE ONLY PICK 1-3$"
	
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
	JMP finish                ; Quit program safely
	
valid_userlength:
	LEA SI, OUTPUT_USERNAME         ; SI points to typed username [Chapter 5]
	LEA DI, USERNAME        
	
	MOV CX, 5                       
compareUser_loop:
	MOV AL, [SI]
	CMP AL, [DI]
	JE word_equal                ; If characters match, keep checking
	JMP wrong_user                  ; If character mismatches, jump directly to wrong_user!
word_equal:
	INC SI                          ; Move to next typed character
	INC DI                          ; Move to next key character
	LOOP compareUser_loop               ; Repeat until all 5 characters are verified [8.2]
	
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
	JE ifOpt1
	CMP CHOICE,2
	JE ifOpt2
	CMP CHOICE,3
	JE ifOpt3
	
	MOV AH,09H
	LEA DX,INVALID_CHOICE
	INT 21H
	JMP main_menu
	
ifOpt1:

ifOpt2:

ifOpt3:
	JMP finish

finish:
	MOV AX,4C00H
	INT 21H
MAIN ENDP
END MAIN
