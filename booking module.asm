.MODEL SMALL
.STACK 100H
.DATA
;HILSON

	Welcome DB 13,10,'Hi,Welcome to Atlantic Hostel$'
	Ask DB 13,10,'What would you like to do?$'
	Ask2 DB 13,10,'1:Hostel Booking$' 
	Ask3 DB 13,10,'2:Guide About Our Hostel$' 
	Ask4 DB 13,10,'Please pick 1 or 2$'
	
	Ask5 DB 13,10,'Welcome to the Hostel Booking$'
	Ask6 DB 13,10,'Please pick your Hostel$'
	Ask7 DB 13,10,'1:Standard Room -Rm50/night$'
	Ask8 DB 13,10,'2:Deluxe Room -Rm80/night$'
	Ask9 DB 13,10,'3:Executive Suite -Rm150/night$'
	Ask10 DB 13,10,'Please pick 1, 2, or 3$'
	
	Ask11 DB 13,10,'Please Choose Again$'
	Ask12 DB 13,10,'blablabla$'
	Ask13 DB 13,10,'Your Pick:$'
	Ask14 DB 13,10,'Would you like to choose your room?$'
	Ask15 DB 13,10,'Thank you,for visiting.We hope to see you again$'
	Ask16 DB 13,10,'Press Y for yes,N for no$'
	Ask17 DB 0Dh,0aH,'$'
	Ask18 DB 13,10,'Great choice!$'
	Ask19 DB 13,10,'Would You Like To Add More Room or Would You Like To Check The Bill$'
	Ask20 DB 13,10,'1:Adding More Room$'
	Ask21 DB 13,10,'2:Check The Bills$'
	Ask22 DB 13,10,'Please pick 1 or 2$'
	Ask23 DB 13,10,'Please pick again$'
	Ask24 DB 13,10,'--------------------------------------------------------------------------------$'

.CODE
MAIN PROC

	MOV AX,@DATA
	MOV DS,AX
	
	MOV AH,09H
	LEA DX,Welcome
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask2
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask3
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask4
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask13
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	MOV AH,01H
	INT 21H
	

	;CHECK REPLY
ROOM_OR_GUIDE:
	CMP AL,'1'
	JE ROOM_CHOOSING3
	CMP AL,'2'
	JE HOSTEL_GUIDE
	JNE WRONG_PICK

	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
 WRONG_PICK:
	MOV AH,09H
	LEA DX,Ask11
	INT 21H
	
	MOV AH,01H
	INT 21H
	
	JMP ROOM_OR_GUIDE
	
ROOM_CHOOSING3:
	JMP ROOM_CHOOSING
	
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	MOV AH,01H
	INT 21H
	
	MOV AH, AL
	JMP ROOM_OR_GUIDE
	
	
HOSTEL_GUIDE:
	MOV AH,09H
	LEA DX,Ask12
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask24
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	
	MOV AH,09H
	LEA DX,Ask14
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask16
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask13
	INT 21H
	
	MOV AH,01H
	INT 21H
	MOV AH, AL
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	
	
AFTER_GUIDE:

	CMP AH,'Y'
	JE ROOM_CHOOSING
	
	CMP AH,'y'
	JE ROOM_CHOOSING
	
	CMP AH,'N'
	JE THANKS_VISITS2
	CMP AH,'n'
	JE THANKS_VISITS2
	
	JNE WRONG_PICK2
	
	
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	
	
	
WRONG_PICK2:
	
	
	
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	
	
	MOV AH,09H
	LEA DX,Ask11
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	MOV AH,01H
	INT 21H
	MOV AH,AL
	
	
	JMP AFTER_GUIDE
	
	
	
	
THANKS_VISITS2:
	JMP THANKS_VISITS
	
	
ROOM_CHOOSING:
	MOV AH,09H
	LEA DX,ASK5
	INT 21H
	
	MOV AH,09H
	LEA DX,ASK6
	INT 21H
	
	MOV AH,09H
	LEA DX,ASK7
	INT 21H
	
	MOV AH,09H
	LEA DX,ASK8
	INT 21H
	
	MOV AH,09H
	LEA DX,ASK9
	INT 21H
	
	MOV AH,09H
	LEA DX,ASK10
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask13
	INT 21H
	
	MOV AH,01H
	LEA DX,Ask13
	INT 21H
	
	
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
	JMP AFTER_CHOOSING
	
AFTER_CHOOSING:
	MOV AH,09H
	LEA DX,Ask18
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask19
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask20
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask21
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask22
	INT 21H
	

	 MOV AH,01H
	INT 21H
	
	CMP AH,'1'
	JE ROOM_CHOOSING
	
	CMP AH,'2'
	JE Bill
	
	MOV AX,0

	

	
	;bill should be place here
	
	
Bill:
     
	
	
	
THANKS_VISITS:
	MOV AH,09H
	LEA DX,Ask15
	INT 21H
	
	MOV AH,09H
	LEA DX,Ask17
	INT 21H
	
EXIT:
	MOV AX,4C00H
	INT 21H

MAIN ENDP
END MAIN
