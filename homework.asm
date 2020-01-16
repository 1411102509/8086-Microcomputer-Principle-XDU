STACK SEGMENT STACK   
      DB 256 DUP(?) 
TOP   LABEL WORD 
STACK ENDS 
DATA 	 SEGMENT 
TABLE  	DW G1, G2, G3, G4, G5 
STRING1 DB '1. Please enter characters, converted to uppercase letters;', 0DH, 0AH, '$' 
STRING2 DB '2. Find the maximum of string,Please enter characters;', 0DH, 0AH, '$' 
STRING3 DB '3. Bubble sort,Please enter numbers;', 0DH, 0AH, '$' 
STRING4 DB '4. Show Time;', 0DH, 0AH, '$' 
STRING5 DB '5. Exit.', 0DH, 0AH, '$' 
STRINGN DB 'Input the number you select (1-5) : $' 
IN_STR DB  'Input the string (including letters & numbers, less than 60 letters) :', 0DH, 0AH, '$' 
PRESTR  DB 'Original string : $' 
NEWSTR 	DB 'New string      : $' 
OUT_STR DB 'The string is $' 
MAXCHR 	DB 'The maximum is $' 
IN_NUM 	DB 'Input the numbers (0 - 255, no more than 20 numbers) : ', 0DH, 0AH, '$' 
OUT_NUM DB 'Sorted numbers : ', 0DH, 0AH, '$' 
IN_TIM  DB 'Correct the time (HH:MM:SS) : $' 
HINTSTR DB 'Press ESC, go back to the menu; or press any key to play again!$' 
KEYBUF 	DB 61 
 	DB ? 
 	DB 61 DUP(?)
NUMBUF 	DB ? 
 	DB 20 DUP(?)
DATA 	ENDS
CODE   	SEGMENT
		ASSUME CS:CODE, DS:DATA, SS:STACK
START:
		MOV AX, DATA   
		MOV DS, AX   
		MOV AX, STACK   
		MOV SS, AX
		MOV SP, OFFSET TOP
MAIN:  CALL MENU
AGAIN:
		MOV AH, 2
		MOV BH, 0 	 	 		; ҳ��  	
		MOV DL, 41  	 	 	; �к� 
		MOV DH, 10  	 	 	; �к� 
		INT 10H  	 	 		; ���λ������ 
		MOV AH, 1 
		INT 21H					; ��������

		CMP AL, '1' 			; ȷ�����յ�����1-5
		JB AGAIN 
		CMP AL, '5' 
		JA AGAIN

		SUB AL, '1'    			; �ַ�������ת��   
		SHL AL, 1				; AL*2
		CBW						; ��AL��չΪAX
		LEA BX, TABLE			; BXΪ�ӳ�����ڵ�ַ
		ADD BX, AX
		JMP WORD PTR [BX] 
G1:    
		CALL CHGLTR   
		MOV AH, 1   
		INT 21H 
		CMP AL, 1BH   			; ESC�˳���main
		JZ MAIN 
		JMP G1 					; �����ظ�
G2: 
		CALL MAXLTR   
		MOV AH, 1   
		INT 21H 
		CMP AL, 1BH   
		JZ MAIN 
		JMP G2
G3: 
		CALL SORTNUM 
		MOV AH, 1   
		INT 21H 
		CMP AL, 1BH   
		JZ MAIN 
		JMP G3 
G4: 
		CALL TIMCHK   
		MOV AH, 1   
		INT 21H 
		CMP AL, 1BH
		JZ MAIN 
		JMP G4 
G5: 
		MOV AH, 4CH  
		INT 21H 
MENU   PROC  NEAR
       ;������ʾ����ʽ 
		MOV AH, 0 
		MOV AL, 3; 
		MOV BL, 0; 
		INT 10H  	 	; ����

		MOV AH, 2 
		MOV BH, 0 	 	; ҳ�� 
		MOV DL, 5 	 	; �к� 
		MOV DH, 5  	 	; �к� 
		INT 10H  	 	; ���λ������
		MOV AH, 9 
		LEA DX, STRING1
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; �к� 
		MOV DH, 6  	 	 ; �к� 
		INT 10H  	 	 ; ���λ������ 
		MOV AH, 9 
		LEA DX, STRING2
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; �к� 
		MOV DH, 7  	 	 ; �к� 
		INT 10H  	 	 ; ���λ������ 
		MOV AH, 9 
		LEA DX, STRING3   
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; �к� 
		MOV DH, 8  	 	 ; �к� 
		INT 10H  	 	 ; ���λ������ 
		MOV AH, 9 
		LEA DX, STRING4
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; �к� 
		MOV DH, 9  	 	 ; �к� 
		INT 10H  	 	 ; ���λ������ 
		MOV AH, 9
		LEA DX, STRING5
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; �к� 
		MOV DH, 10		 ; �к� 
		INT 10H  	 	 ; ���λ������ 
		MOV AH, 9 
		LEA DX, STRINGN 
		INT 21H

		RET 
MENU   ENDP 

;**************************************** NUM-1 ***************************************8
CHGLTR 	PROC NEAR 
RECHG: 
 	 ;������ʾ����ʽ 
		MOV AH, 0  	 	
		MOV AL, 3 
		MOV BL, 0 
		INT 10H  	 	 	 	; ����

		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 5  	 	 		; �к� 
		INT 10H  	 	 	 	; ������ʾ���λ������ 
		MOV AH, 9 
		LEA DX, IN_STR 
		INT 21H  	 	 	 	; �����ַ�����ʾ

		MOV AH, 2 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 6  	 	 		; �к� 
		INT 10H  	 	 	 	; �����ַ������λ������

		MOV AH, 0AH 
		LEA DX, KEYBUF 
		INT 21H  	 	 	 	; �����ַ���,KEYBUF[1]��Ϊ���ȣ��ַ���2��ʼ

		CMP KEYBUF+1, 0
		JZ  RECHG   	 	 	; �ж������ַ����Ƿ�Ϊ�մ� 
		LEA BX, KEYBUF+2 
		MOV AL, KEYBUF+1 		; AL�洢����
		CBW 					; AL��չ16λ
		MOV CX, AX 				; CXΪ����
		ADD BX, AX 				; ����BXΪ���һ���ַ���һ��λ��
		MOV BYTE PTR [BX], '$' 	; �������ַ���β�ӽ�����־$

		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 7  	 	 		; �к� 
		INT 10H  	 	 	 	; Դ�ַ�����ʾ���λ������
		MOV AH, 9 
		LEA DX, PRESTR
		INT 21H 	  			; ���Դ�ַ�����ʾ
		MOV AH, 9 
		LEA DX, KEYBUF + 2 
		INT 21H  	 	 	 	; ���Դ�ַ���

		LEA BX, KEYBUF + 2		; BXΪ��һ���ַ�λ��
LCHG:
		CMP BYTE PTR [BX], 61H   
		JB NOCHG 
		AND BYTE PTR [BX], 0DFH ; Сд->��д
NOCHG: 
		INC BX 
		LOOP LCHG  	 	 		; ���ַ�����Сд��ĸת���ɴ�д��ĸ,ֱ��CX=0 
		
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 8  	 	 		; �к� 
		INT 10H  	 	 	 	; ���ַ�����ʾ���λ������ 
		MOV AH, 9 
		LEA DX, NEWSTR 
		INT 21H  	 	 	 	; ������ַ�����ʾ 
		MOV AH, 9 
		LEA DX, KEYBUF + 2 
		INT 21H  	 	 	 	; ������ַ���

		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 9  	 	 		; �к� 
		INT 10H  	 	 	 	; ��ʾ��Ϣ���λ������ 
		MOV AH, 9 
		LEA DX, HINTSTR 		
		INT 21H  	 	 	 	; �����ʾ������Ϣ

		RET 
CHGLTR 	ENDP 

;****************************************** NUM-2 ********************************
MAXLTR  PROC NEAR 
REMAX: 
		;������ʾ����ʽ 
		MOV AH, 0  	 	
		MOV AL, 3 
		MOV BL, 0 
		INT 10H  	 	 	 	; ���� 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 5  	 	 		; �к� 
		INT 10H 				; ������ʾ���λ������ 
		MOV AH, 9 
		LEA DX, IN_STR 
		INT 21H  	 	 	 	; �����ַ�����ʾ

		MOV AH, 2 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 6  	 	 		; �к� 
		INT 10H  	 	 	 	; �����ַ������λ������ 
		MOV AH, 0AH 
		LEA DX, KEYBUF 
		INT 21H  	 	 	 	; �����ַ���

		CMP KEYBUF + 1, 0 
		JZ REMAX 	 	 	 	; �ж������ַ����Ƿ�Ϊ�մ� 
		LEA BX, KEYBUF + 2 		; BX=��һ���ַ�λ��
		MOV AL, KEYBUF + 1 		; AL=�ַ�����
		CBW 
		MOV CX, AX 				; CXΪ�ַ�����
		ADD BX, AX 				; BX��Ϊ���һ��λ�õĺ�һ��
		MOV BYTE PTR [BX], '$' 	; �������ַ���λ�ӽ�����־$

		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 7  	 	 		; �к� 
		INT 10H  	 	 	 	; Դ�ַ�����ʾ���λ������ 
		MOV AH, 9 
		LEA DX, OUT_STR 
		INT 21H  	 	 	 	; ����ַ�����ʾ 
		MOV AH, 9 
		LEA DX, KEYBUF + 2 
		INT 21H  	 	 	 	; ����ַ���
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 8  	 	 		; �к� 
		INT 10H  	 	 	 	; ���ַ�����ʾ���λ������ 
		MOV AH, 9 
		LEA DX, MAXCHR 
		INT 21H  	 	 	 	; ����ַ��������ֵ��ʾ

		MOV DL, 0  	 	
		LEA BX, KEYBUF + 2
LCMP: 
		CMP [BX], DL   			; DLΪ����ַ�
		JB NOLCHG 				; С����ִ�н���
		MOV DL, [BX]			; ����
NOLCHG: 
		INC BX 
		LOOP LCMP  	 	 	 	; �ҳ��ַ���������ַ�����DL

		MOV AH, 2 
		INT 21H  	 	 	 	; ����ַ���������ַ� 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 9  	 	 	 	; �к� 
		INT 10H  	 	 	 	; ��ʾ��Ϣ���λ������ 
		MOV AH, 9 
		LEA DX, HINTSTR 
		INT 21H  	 	 	 	; �����ʾ��Ϣ

		RET
MAXLTR 	   ENDP 

;*************************************** NUM-3 ************************************
SORTNUM PROC NEAR 	 	 	; ���������������� 
RESORT: 
		;������ʾ����ʽ 
		MOV AH, 0  	 	
		MOV AL, 3 
		MOV BL, 0 
		INT 10H  	 	 	 	; ���� 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 5  	 	 		; �к� 
		INT 10H  	 	 	 	; ������ʾ���λ������ 
		MOV AH, 9 
		LEA DX, IN_NUM  
		INT 21H 
		MOV AH, 2 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 6  	 	 		; �к� 
		INT 10H  	 	 	 	; ������������λ������ 
		MOV AH, 0AH 
		LEA DX, KEYBUF 
		INT 21H  	 	 	 	; �����������ַ��� 
		CALL CIN_INT 	 	 	; �ַ���ת�������ݴ� 
		CMP AL, 0 
		JZ RESORT  	 	 		; �ж����ݴ��Ƿ��д� 
		CMP NUMBUF, 0 
		JZ RESORT               ; �ж����ݴ��Ƿ�Ϊ�� 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 7  	 	 		; �к� 
		INT 10H  	 	 	 	; �����ʾ���λ������ 
		MOV AH, 9 
		LEA DX, OUT_NUM 
		INT 21H  	 	 	 	; ������ݴ���ʾ 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 8  	 	 		; �к� 
		INT 10H  	 	 	 	; �����������λ������ 
		CALL  MPSORT 	   		; ���������� 
		CALL INT_OUT      		; ����������   
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 9  	 	 		; �к� 
		INT 10H  	 	 	 	; ��ʾ��Ϣ���λ������ 
		MOV AH, 9 
		LEA DX, HINTSTR 
		INT 21H  	 	 	 	; �����ʾ��Ϣ 
		RET 
SORTNUM  ENDP

CIN_INT PROC NEAR  	 	 		; ���������� 
; ��ڲ����� 
; ���ڲ���ΪAL���޴����־0 Ϊ��1 Ϊ�� 
		MOV CL, KEYBUF + 1  	 	
		LEA SI, KEYBUF + 2 
		MOV CH, 0 	 	 	 	; ���������ݸ����� 0 
		MOV DH, 10 
		MOV AL, 0 	 	 	 	; ��ǰ���� x=0 
		MOV DL, 0 	 	 	 	; �������ݱ�־�� 0�������� 
FNDNUM: 
		CMP BYTE PTR [SI], ' ' 
		JZ ADDNUM  	 	 		; �жϵ�ǰ�ַ��Ƿ�Ϊ�ո� 
		CMP BYTE PTR [SI], '0' 
		JB ERRNUM 
		CMP BYTE PTR [SI], '9' 
		JA ERRNUM  	 	 		; �жϵ�ǰ�ַ��Ƿ���'0'-'9'֮�� 
		MOV DL, 1   	 		; �������ݱ�־�� 1��������   
		MUL DH
		XOR BH, BH  	 	
		MOV BL, [SI]  	 	
		ADD AX, BX 
		SUB AX, '0' 	 	 	; �������ǰ���� x  	 	
		CMP AH, 0 
		JA ERRNUM  	 	 		; �ж� x �Ƿ�Խ�� 
		JMP NEXT 
ADDNUM: 
		CMP DL, 1 
		JNZ NEXT 	 	 	 	; �ж��Ƿ������� 
		INC CH  	 	 	 	; ���������ݸ����� 1 
		CALL ADDNEW   
		MOV DL, 0 
		MOV AL, 0 	 	 	 	; ���� 
NEXT: 
 	 INC SI  	 	
 	 DEC CL 
 	 CMP CL, 0 
 	 JNZ FNDNUM 	 	 	; ���μ����ַ� 
 	 CMP DL, 1 
 	 JNZ TOTAL  	 	 	; �ж��Ƿ���δ��������� 
         INC CH   
         CALL ADDNEW 
TOTAL: 
 	 MOV NUMBUF, CH 	 	; �����������ݸ��� 
 	 MOV AL, 1 	 	 	 	; ���������޴��� 
 	 JMP CRTNUM 
ERRNUM: 
 	 MOV AL, 0 	 	 	 	; ���������д��� 
CRTNUM: 
 	 RET  
CIN_INT  ENDP
ADDNEW 	PROC NEAR  	 		; �������� 
; ��ڲ���CH���������ݸ�����AL��ǰ���� x 
; ���ڲ����� 
		PUSH AX 
		LEA BX, NUMBUF 
		MOV AL, CH 
		CBW 
		ADD BX, AX   
		POP AX 
		MOV [BX], AL 
		RET 
ADDNEW 	   ENDP

;****************************** ð������ ***************************
MPSORT 	PROC NEAR 	 	 	; ����������  	 	
		MOV AL, NUMBUF 		; NUMBUF:�ַ�����
		CMP AL, 1 
		JBE NOSORT 	 	 	; ��ֻ��һ��Ԫ��ֹͣ���� 
		CBW 
		MOV CX, AX 			; CX=�ַ�����
		LEA SI, NUMBUF  	; SI ָ���������׵�ַ 
		ADD SI, CX         	; SI ָ��������ĩ��ַ
		DEC CX        		; ��ѭ������ 
LP1: 	 	 	 	 	 	; ��ѭ����ʼ 
		PUSH CX 
		PUSH SI 
		MOV DL, 0 	 	 	; ������־�� 0 
LP2: 	 	 	 	 	 	; ��ѭ����ʼ 
		MOV AL, [SI]  	 	
		CMP AL, [SI - 1] 
		JAE NOXCHG 			; ǰһ��Ԫ�ش��ڵ��ں�һ��Ԫ�ؾͽ���
		XCHG AL, [SI - 1]   ; ��������   
		MOV [SI], AL 
		MOV DL, 1 	 	 	; ������־�� 1 
NOXCHG: 
		DEC SI  			; ��ǰ�ߣ�ֱ��CX=0�������������� 
		LOOP LP2

		POP SI 
		POP CX 
		CMP DL, 1 
		JNZ NOSORT   		; �жϽ�����־�������ѭ�����������ͽ��������򣬼�����ѭ��

		LOOP LP1
NOSORT:RET 
MPSORT ENDP 
INT_OUT  PROC NEAR 	 	 	; ���������  	 	
		MOV AL, NUMBUF 
		CBW 
		MOV CX, AX   
		MOV BL, 10H   
		LEA SI, NUMBUF + 1
PRINT: 
		MOV AL, [SI] 		; SI�����ֵ�һ��λ��
		CALL OUTNUM   		; Ϊ����ĸ�����ֶ�ת�����ַ���DL���
		INC SI

		MOV AH, 2 
		MOV DL, ' ' 
		INT 21H				; ��ʾ�ַ�

		LOOP PRINT 
		RET
INT_OUT ENDP 

OUTNUM 	PROC NEAR  	 		; ��ʮ��������ʮ��������� 
; ��ڲ���AL��ת��������BLת�������� 16 
; ���ڲ����� 
		MOV AH, 0   
		DIV BL 
		PUSH AX				; AX/BL �̣�SL�����ࣨAH��,AX��ջ

		CMP AH, 10   
		JB PNUM				; ˵��Ϊ���� 
		ADD AH, 7 			; ��ĸ�������ֶ�7
PNUM:  
		ADD AH, 30H  		; ת�����ַ�
		MOV DL, AH   

		POP AX 
		PUSH DX   
		CMP AL, 0   
		JZ OUTN   
		CALL OUTNUM 
OUTN: 
 	 	POP DX 
		MOV AH, 2 
 	 	INT 21H 
 	 	RET 
OUTNUM 	ENDP 
;***************************** NUM-4 ***********************************
TIMCHK 	PROC NEAR	 	 	 	; �趨����ʾʱ�� 
		;������ʾ����ʽ 
		MOV AH, 0 
		MOV AL, 3; 
		MOV BL, 0; 
		INT 10H  	 	 	 	; ���� 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ�� 
		MOV DL, 5 	 	 	 	; �к� 
		MOV DH, 6  	 	 		; �к� 
		INT 10H  	 	 	 	; ������ʾ���λ������ 
		MOV AH, 9 
		LEA DX, IN_TIM 
		INT 21H  	 	 	 	; ʱ�䴮��ʾ

		MOV AH, 0AH 
		LEA DX, KEYBUF 
		INT 21H  	 	 	 	; ����ʱ�䴮

		MOV BL, 10 
		MOV AL, KEYBUF + 2 
		SUB AL, '0' 
		MUL BL 
		ADD AL, KEYBUF + 3  	 	
		SUB AL, '0'  	 	
		CMP AL, 0  	 	
		JB INVALID 
		CMP AL, 24 
		JAE INVALID 	 	 	; �ж� ʱ ��Ч��
		 
		MOV CH, AL 
		MOV AL, KEYBUF + 5 
		SUB AL, '0' 
		MUL BL 
		ADD AL, KEYBUF + 6  	 	
		SUB AL, '0'  	 	
		CMP AL, 0  	 	
		JB INVALID 
		CMP AL, 60 
		JAE INVALID 	 	 	; �ж� �� ��Ч��

		MOV CL, AL 
		MOV AL, KEYBUF + 8 
		SUB AL, '0' 
		MUL BL 
		ADD AL, KEYBUF + 9  	 	
		SUB AL, '0'  	 	
		CMP AL, 0  	 	
		JB INVALID 
		CMP AL, 60 
		JAE INVALID   			; �ж� �� ��Ч��

		MOV DH, AL   
		MOV DL, 0 
		MOV AH, 2DH 
		INT 21H  	 	 	 	; ��ϵͳʱ�� 
INVALID: 
		CALL TIME 
		RET 
TIMCHK 	ENDP 
TIME 	PROC 	 	 	 	 	; ��ʾʱ���ӳ��� 
		;������ʾ����ʽ 
		MOV AH, 0 
		MOV AL, 3; 
		MOV BL, 0; 
		INT 10H  	 	 	 	; ���� 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ��  	 	
		MOV DL, 10  	 	 	; �к�  	 	
		MOV DH, 9  	 	 		; �к� 
		INT 10H  	 	 	 	; ��ʾ��Ϣ���λ������ 
		MOV AH, 9 
		LEA DX, HINTSTR 
		INT 21H  	 	 	 	; �����ʾ��Ϣ 
DISP1: 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; ҳ��  	 	
		MOV DL, 72  	 	 	; �к�  	 	
		MOV DH, 0  	 	 		; �к� 
		INT 10H  	 	 	 	; ��ʾ���λ������

		MOV AH, 2CH 	 	 	; ȡϵͳʱ��,CH,CL,DH �ֱ���ʱ/��/�� 
		INT 21H 
		MOV AL, CH    			; ��ʾ ʱ   
		CALL SHOWNUM   
		MOV AH, 2   
		MOV DL, ':' 
		INT 21H 
		MOV AL, CL    			; ��ʾ ��   
		CALL SHOWNUM   
		MOV AH, 2 
		MOV DL, ':' 
		INT 21H 
		MOV AL, DH    			; ��ʾ : ��   
		CALL SHOWNUM

		MOV AH,02H 	 	 		; ���ù��λ�� 
		MOV DX,090AH  	 	
		MOV BH,0  	 	
		INT 10H
		 
		MOV BX,0018H 
RE:     
		MOV CX,0FFFFH   		; ��ʱ 
REA:    
		LOOP REA 
		DEC BX 
		JNZ RE 
		MOV AH, 0BH 	 	 		; ��  	MOV AH, 01H  	 	
		INT 21H  	 	 	 		;  		INT 16H  	 	
		CMP AL, 0 	 	 	 		;  	 	JE DISP1 
		JZ DISP1 	 	 	 		; ������״̬ 
		RET 
TIME 	ENDP 
 
SHOWNUM PROC	 	 	 	; �� AL �е�������ʮ������� 
; ��ڲ���AL����ʾ������ 
; ���ڲ����� 
		CBW 
		PUSH CX 
		PUSH DX   
		MOV CL, 10   
		DIV CL 
		ADD AH, '0'   
		MOV BH, AH   
		ADD AL, '0'   
		MOV AH, 2   
		MOV DL, AL   
		INT 21H   
		MOV DL, BH   
		INT 21H   
		POP DX   
		POP CX 
		RET 
SHOWNUM ENDP 
CODE 	ENDS 
  END 	START
