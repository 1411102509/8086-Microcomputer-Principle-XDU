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
		MOV BH, 0 	 	 		; 页号  	
		MOV DL, 41  	 	 	; 列号 
		MOV DH, 10  	 	 	; 行号 
		INT 10H  	 	 		; 光标位置设置 
		MOV AH, 1 
		INT 21H					; 接收输入

		CMP AL, '1' 			; 确保接收到的是1-5
		JB AGAIN 
		CMP AL, '5' 
		JA AGAIN

		SUB AL, '1'    			; 字符和整数转换   
		SHL AL, 1				; AL*2
		CBW						; 将AL拓展为AX
		LEA BX, TABLE			; BX为子程序入口地址
		ADD BX, AX
		JMP WORD PTR [BX] 
G1:    
		CALL CHGLTR   
		MOV AH, 1   
		INT 21H 
		CMP AL, 1BH   			; ESC退出到main
		JZ MAIN 
		JMP G1 					; 否则重复
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
       ;设置显示器方式 
		MOV AH, 0 
		MOV AL, 3; 
		MOV BL, 0; 
		INT 10H  	 	; 清屏

		MOV AH, 2 
		MOV BH, 0 	 	; 页号 
		MOV DL, 5 	 	; 列号 
		MOV DH, 5  	 	; 行号 
		INT 10H  	 	; 光标位置设置
		MOV AH, 9 
		LEA DX, STRING1
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; 列号 
		MOV DH, 6  	 	 ; 行号 
		INT 10H  	 	 ; 光标位置设置 
		MOV AH, 9 
		LEA DX, STRING2
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; 列号 
		MOV DH, 7  	 	 ; 行号 
		INT 10H  	 	 ; 光标位置设置 
		MOV AH, 9 
		LEA DX, STRING3   
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; 列号 
		MOV DH, 8  	 	 ; 行号 
		INT 10H  	 	 ; 光标位置设置 
		MOV AH, 9 
		LEA DX, STRING4
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; 列号 
		MOV DH, 9  	 	 ; 行号 
		INT 10H  	 	 ; 光标位置设置 
		MOV AH, 9
		LEA DX, STRING5
		INT 21H

		MOV AH, 2 
		MOV DL, 5 	 	 ; 列号 
		MOV DH, 10		 ; 行号 
		INT 10H  	 	 ; 光标位置设置 
		MOV AH, 9 
		LEA DX, STRINGN 
		INT 21H

		RET 
MENU   ENDP 

;**************************************** NUM-1 ***************************************8
CHGLTR 	PROC NEAR 
RECHG: 
 	 ;设置显示器方式 
		MOV AH, 0  	 	
		MOV AL, 3 
		MOV BL, 0 
		INT 10H  	 	 	 	; 清屏

		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 5  	 	 		; 行号 
		INT 10H  	 	 	 	; 输入提示光标位置设置 
		MOV AH, 9 
		LEA DX, IN_STR 
		INT 21H  	 	 	 	; 输入字符串提示

		MOV AH, 2 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 6  	 	 		; 行号 
		INT 10H  	 	 	 	; 输入字符串光标位置设置

		MOV AH, 0AH 
		LEA DX, KEYBUF 
		INT 21H  	 	 	 	; 输入字符串,KEYBUF[1]中为长度，字符从2开始

		CMP KEYBUF+1, 0
		JZ  RECHG   	 	 	; 判断输入字符串是否为空串 
		LEA BX, KEYBUF+2 
		MOV AL, KEYBUF+1 		; AL存储长度
		CBW 					; AL拓展16位
		MOV CX, AX 				; CX为长度
		ADD BX, AX 				; 现在BX为最后一个字符后一个位置
		MOV BYTE PTR [BX], '$' 	; 在输入字符串尾加结束标志$

		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 7  	 	 		; 行号 
		INT 10H  	 	 	 	; 源字符串提示光标位置设置
		MOV AH, 9 
		LEA DX, PRESTR
		INT 21H 	  			; 输出源字符串提示
		MOV AH, 9 
		LEA DX, KEYBUF + 2 
		INT 21H  	 	 	 	; 输出源字符串

		LEA BX, KEYBUF + 2		; BX为第一个字符位置
LCHG:
		CMP BYTE PTR [BX], 61H   
		JB NOCHG 
		AND BYTE PTR [BX], 0DFH ; 小写->大写
NOCHG: 
		INC BX 
		LOOP LCHG  	 	 		; 将字符串中小写字母转换成大写字母,直至CX=0 
		
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 8  	 	 		; 行号 
		INT 10H  	 	 	 	; 新字符串提示光标位置设置 
		MOV AH, 9 
		LEA DX, NEWSTR 
		INT 21H  	 	 	 	; 输出新字符串提示 
		MOV AH, 9 
		LEA DX, KEYBUF + 2 
		INT 21H  	 	 	 	; 输出新字符串

		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 9  	 	 		; 行号 
		INT 10H  	 	 	 	; 提示信息光标位置设置 
		MOV AH, 9 
		LEA DX, HINTSTR 		
		INT 21H  	 	 	 	; 输出提示返回信息

		RET 
CHGLTR 	ENDP 

;****************************************** NUM-2 ********************************
MAXLTR  PROC NEAR 
REMAX: 
		;设置显示器方式 
		MOV AH, 0  	 	
		MOV AL, 3 
		MOV BL, 0 
		INT 10H  	 	 	 	; 清屏 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 5  	 	 		; 行号 
		INT 10H 				; 输入提示光标位置设置 
		MOV AH, 9 
		LEA DX, IN_STR 
		INT 21H  	 	 	 	; 输入字符串提示

		MOV AH, 2 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 6  	 	 		; 行号 
		INT 10H  	 	 	 	; 输入字符串光标位置设置 
		MOV AH, 0AH 
		LEA DX, KEYBUF 
		INT 21H  	 	 	 	; 输入字符串

		CMP KEYBUF + 1, 0 
		JZ REMAX 	 	 	 	; 判断输入字符串是否为空串 
		LEA BX, KEYBUF + 2 		; BX=第一个字符位置
		MOV AL, KEYBUF + 1 		; AL=字符长度
		CBW 
		MOV CX, AX 				; CX为字符长度
		ADD BX, AX 				; BX现为最后一个位置的后一个
		MOV BYTE PTR [BX], '$' 	; 在输入字符串位加结束标志$

		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 7  	 	 		; 行号 
		INT 10H  	 	 	 	; 源字符串提示光标位置设置 
		MOV AH, 9 
		LEA DX, OUT_STR 
		INT 21H  	 	 	 	; 输出字符串提示 
		MOV AH, 9 
		LEA DX, KEYBUF + 2 
		INT 21H  	 	 	 	; 输出字符串
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 8  	 	 		; 行号 
		INT 10H  	 	 	 	; 新字符串提示光标位置设置 
		MOV AH, 9 
		LEA DX, MAXCHR 
		INT 21H  	 	 	 	; 输出字符串中最大值提示

		MOV DL, 0  	 	
		LEA BX, KEYBUF + 2
LCMP: 
		CMP [BX], DL   			; DL为大的字符
		JB NOLCHG 				; 小于则不执行交换
		MOV DL, [BX]			; 交换
NOLCHG: 
		INC BX 
		LOOP LCMP  	 	 	 	; 找出字符串中最大字符放入DL

		MOV AH, 2 
		INT 21H  	 	 	 	; 输出字符串中最大字符 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 9  	 	 	 	; 行号 
		INT 10H  	 	 	 	; 提示信息光标位置设置 
		MOV AH, 9 
		LEA DX, HINTSTR 
		INT 21H  	 	 	 	; 输出提示信息

		RET
MAXLTR 	   ENDP 

;*************************************** NUM-3 ************************************
SORTNUM PROC NEAR 	 	 	; 对输入数据组排序 
RESORT: 
		;设置显示器方式 
		MOV AH, 0  	 	
		MOV AL, 3 
		MOV BL, 0 
		INT 10H  	 	 	 	; 清屏 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 5  	 	 		; 行号 
		INT 10H  	 	 	 	; 输入提示光标位置设置 
		MOV AH, 9 
		LEA DX, IN_NUM  
		INT 21H 
		MOV AH, 2 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 6  	 	 		; 行号 
		INT 10H  	 	 	 	; 输入数据组光标位置设置 
		MOV AH, 0AH 
		LEA DX, KEYBUF 
		INT 21H  	 	 	 	; 输入数据组字符串 
		CALL CIN_INT 	 	 	; 字符串转换成数据串 
		CMP AL, 0 
		JZ RESORT  	 	 		; 判断数据串是否有错 
		CMP NUMBUF, 0 
		JZ RESORT               ; 判断数据串是否为空 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 7  	 	 		; 行号 
		INT 10H  	 	 	 	; 输出提示光标位置设置 
		MOV AH, 9 
		LEA DX, OUT_NUM 
		INT 21H  	 	 	 	; 输出数据串提示 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 8  	 	 		; 行号 
		INT 10H  	 	 	 	; 输出数据组光标位置设置 
		CALL  MPSORT 	   		; 数据组排序 
		CALL INT_OUT      		; 数据组的输出   
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 9  	 	 		; 行号 
		INT 10H  	 	 	 	; 提示信息光标位置设置 
		MOV AH, 9 
		LEA DX, HINTSTR 
		INT 21H  	 	 	 	; 输出提示信息 
		RET 
SORTNUM  ENDP

CIN_INT PROC NEAR  	 	 		; 读入整型数 
; 入口参数无 
; 出口参数为AL有无错误标志0 为有1 为无 
		MOV CL, KEYBUF + 1  	 	
		LEA SI, KEYBUF + 2 
		MOV CH, 0 	 	 	 	; 数据组数据个数置 0 
		MOV DH, 10 
		MOV AL, 0 	 	 	 	; 当前数据 x=0 
		MOV DL, 0 	 	 	 	; 有无数据标志置 0即无数据 
FNDNUM: 
		CMP BYTE PTR [SI], ' ' 
		JZ ADDNUM  	 	 		; 判断当前字符是否为空格 
		CMP BYTE PTR [SI], '0' 
		JB ERRNUM 
		CMP BYTE PTR [SI], '9' 
		JA ERRNUM  	 	 		; 判断当前字符是否在'0'-'9'之间 
		MOV DL, 1   	 		; 有无数据标志置 1即有数据   
		MUL DH
		XOR BH, BH  	 	
		MOV BL, [SI]  	 	
		ADD AX, BX 
		SUB AX, '0' 	 	 	; 计算出当前数据 x  	 	
		CMP AH, 0 
		JA ERRNUM  	 	 		; 判断 x 是否越界 
		JMP NEXT 
ADDNUM: 
		CMP DL, 1 
		JNZ NEXT 	 	 	 	; 判断是否有数据 
		INC CH  	 	 	 	; 数据组数据个数加 1 
		CALL ADDNEW   
		MOV DL, 0 
		MOV AL, 0 	 	 	 	; 清零 
NEXT: 
 	 INC SI  	 	
 	 DEC CL 
 	 CMP CL, 0 
 	 JNZ FNDNUM 	 	 	; 依次检查各字符 
 	 CMP DL, 1 
 	 JNZ TOTAL  	 	 	; 判断是否有未加入的数据 
         INC CH   
         CALL ADDNEW 
TOTAL: 
 	 MOV NUMBUF, CH 	 	; 置数据组数据个数 
 	 MOV AL, 1 	 	 	 	; 输入数据无错误 
 	 JMP CRTNUM 
ERRNUM: 
 	 MOV AL, 0 	 	 	 	; 输入数据有错误 
CRTNUM: 
 	 RET  
CIN_INT  ENDP
ADDNEW 	PROC NEAR  	 		; 增加新数 
; 入口参数CH数据组数据个数、AL当前数据 x 
; 出口参数无 
		PUSH AX 
		LEA BX, NUMBUF 
		MOV AL, CH 
		CBW 
		ADD BX, AX   
		POP AX 
		MOV [BX], AL 
		RET 
ADDNEW 	   ENDP

;****************************** 冒泡排序 ***************************
MPSORT 	PROC NEAR 	 	 	; 数据组排序  	 	
		MOV AL, NUMBUF 		; NUMBUF:字符数量
		CMP AL, 1 
		JBE NOSORT 	 	 	; 若只有一个元素停止排序 
		CBW 
		MOV CX, AX 			; CX=字符数量
		LEA SI, NUMBUF  	; SI 指向数据组首地址 
		ADD SI, CX         	; SI 指向数据组末地址
		DEC CX        		; 外循环次数 
LP1: 	 	 	 	 	 	; 外循环开始 
		PUSH CX 
		PUSH SI 
		MOV DL, 0 	 	 	; 交换标志置 0 
LP2: 	 	 	 	 	 	; 内循环开始 
		MOV AL, [SI]  	 	
		CMP AL, [SI - 1] 
		JAE NOXCHG 			; 前一个元素大于等于后一个元素就交换
		XCHG AL, [SI - 1]   ; 交换操作   
		MOV [SI], AL 
		MOV DL, 1 	 	 	; 交换标志置 1 
NOXCHG: 
		DEC SI  			; 往前走，直到CX=0，遍历所有数字 
		LOOP LP2

		POP SI 
		POP CX 
		CMP DL, 1 
		JNZ NOSORT   		; 判断交换标志，如果内循环不交换，就结束，否则，继续外循环

		LOOP LP1
NOSORT:RET 
MPSORT ENDP 
INT_OUT  PROC NEAR 	 	 	; 输出数据组  	 	
		MOV AL, NUMBUF 
		CBW 
		MOV CX, AX   
		MOV BL, 10H   
		LEA SI, NUMBUF + 1
PRINT: 
		MOV AL, [SI] 		; SI：数字第一个位置
		CALL OUTNUM   		; 为了字母和数字都转换成字符，DL输出
		INC SI

		MOV AH, 2 
		MOV DL, ' ' 
		INT 21H				; 显示字符

		LOOP PRINT 
		RET
INT_OUT ENDP 

OUTNUM 	PROC NEAR  	 		; 将十进制数以十六进制输出 
; 入口参数AL待转换的数据BL转换进制数 16 
; 出口参数无 
		MOV AH, 0   
		DIV BL 
		PUSH AX				; AX/BL 商（SL），余（AH）,AX进栈

		CMP AH, 10   
		JB PNUM				; 说明为数字 
		ADD AH, 7 			; 字母，比数字多7
PNUM:  
		ADD AH, 30H  		; 转换成字符
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
TIMCHK 	PROC NEAR	 	 	 	; 设定并显示时间 
		;设置显示器方式 
		MOV AH, 0 
		MOV AL, 3; 
		MOV BL, 0; 
		INT 10H  	 	 	 	; 清屏 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号 
		MOV DL, 5 	 	 	 	; 列号 
		MOV DH, 6  	 	 		; 行号 
		INT 10H  	 	 	 	; 设置提示光标位置设置 
		MOV AH, 9 
		LEA DX, IN_TIM 
		INT 21H  	 	 	 	; 时间串提示

		MOV AH, 0AH 
		LEA DX, KEYBUF 
		INT 21H  	 	 	 	; 输入时间串

		MOV BL, 10 
		MOV AL, KEYBUF + 2 
		SUB AL, '0' 
		MUL BL 
		ADD AL, KEYBUF + 3  	 	
		SUB AL, '0'  	 	
		CMP AL, 0  	 	
		JB INVALID 
		CMP AL, 24 
		JAE INVALID 	 	 	; 判断 时 有效性
		 
		MOV CH, AL 
		MOV AL, KEYBUF + 5 
		SUB AL, '0' 
		MUL BL 
		ADD AL, KEYBUF + 6  	 	
		SUB AL, '0'  	 	
		CMP AL, 0  	 	
		JB INVALID 
		CMP AL, 60 
		JAE INVALID 	 	 	; 判断 分 有效性

		MOV CL, AL 
		MOV AL, KEYBUF + 8 
		SUB AL, '0' 
		MUL BL 
		ADD AL, KEYBUF + 9  	 	
		SUB AL, '0'  	 	
		CMP AL, 0  	 	
		JB INVALID 
		CMP AL, 60 
		JAE INVALID   			; 判断 秒 有效性

		MOV DH, AL   
		MOV DL, 0 
		MOV AH, 2DH 
		INT 21H  	 	 	 	; 置系统时间 
INVALID: 
		CALL TIME 
		RET 
TIMCHK 	ENDP 
TIME 	PROC 	 	 	 	 	; 显示时间子程序 
		;设置显示器方式 
		MOV AH, 0 
		MOV AL, 3; 
		MOV BL, 0; 
		INT 10H  	 	 	 	; 清屏 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号  	 	
		MOV DL, 10  	 	 	; 列号  	 	
		MOV DH, 9  	 	 		; 行号 
		INT 10H  	 	 	 	; 提示信息光标位置设置 
		MOV AH, 9 
		LEA DX, HINTSTR 
		INT 21H  	 	 	 	; 输出提示信息 
DISP1: 
		MOV AH, 2 
		MOV BH, 0 	 	 	 	; 页号  	 	
		MOV DL, 72  	 	 	; 列号  	 	
		MOV DH, 0  	 	 		; 行号 
		INT 10H  	 	 	 	; 提示光标位置设置

		MOV AH, 2CH 	 	 	; 取系统时间,CH,CL,DH 分别存放时/分/秒 
		INT 21H 
		MOV AL, CH    			; 显示 时   
		CALL SHOWNUM   
		MOV AH, 2   
		MOV DL, ':' 
		INT 21H 
		MOV AL, CL    			; 显示 分   
		CALL SHOWNUM   
		MOV AH, 2 
		MOV DL, ':' 
		INT 21H 
		MOV AL, DH    			; 显示 : 秒   
		CALL SHOWNUM

		MOV AH,02H 	 	 		; 设置光标位置 
		MOV DX,090AH  	 	
		MOV BH,0  	 	
		INT 10H
		 
		MOV BX,0018H 
RE:     
		MOV CX,0FFFFH   		; 延时 
REA:    
		LOOP REA 
		DEC BX 
		JNZ RE 
		MOV AH, 0BH 	 	 		; 或  	MOV AH, 01H  	 	
		INT 21H  	 	 	 		;  		INT 16H  	 	
		CMP AL, 0 	 	 	 		;  	 	JE DISP1 
		JZ DISP1 	 	 	 		; 检查键盘状态 
		RET 
TIME 	ENDP 
 
SHOWNUM PROC	 	 	 	; 把 AL 中的数字以十进制输出 
; 入口参数AL待显示的数据 
; 出口参数无 
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
