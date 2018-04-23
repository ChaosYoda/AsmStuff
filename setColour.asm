bits 16
org 0x100
jmp main


message: db 'Please enter the number you select $'

change_colour:	; Accept a string of characters from the keyboard.
; The address of the input parameter block must be in DX 
	mov ah,06h
	mov ch,0
	mov cl,0
	mov dh, 0
	mov dl, 0
	mov bh, 14h
	int 10h
	ret
 ;---------------------- Display routine ------
display:     ; Display a message on the screen.
			 ; The address of the message must be in DX.
	mov ah,09h	;Request - display message
	int 21h  ;DOS system call
	ret 	; return	

main: 

	call change_colour:	;
	mov dx, message; Address of prompt
	call display ;	Display prompt
	int 20h