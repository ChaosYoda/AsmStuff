	bits 16
 	org 0x100
 	; This program accepts a number from the user as input
	; and displays a message to say if the number if a multiple of 3 
	;
	;--------------------- Jump over data declarations

	jmp main  ;

 ;prompt
message: db 'Even orr odd? $'
evenMsg: db 'Even number $'
oddMsg : db 'Odd number $'

 ; Input_buffer
in_buf: db 12 ; Length of input buffer (12 chars)
  
len_in: db 00 ; Length of input string will be stored here by dos

user: times 12 db '  ' ; Reserver 12 storage posisitons for input buffer

cr_lf: db 0x0a,0x0d,'$' ; Carriage return, Line feed		

 ;---------------------- Display routine ------
display:     ; Display a message on the screen.
			 ; The address of the message must be in DX.
	mov ah,09h	;Request - display message
	int 21h  ;DOS system call
	ret 	; return		


even:
	mov dx, evenMsg
	call display
	pop ax
	mov dl,al
	mov ah, 02h
	int 21h
	mov ax ,1 
	ret;	



oddEven:
	;mov ax, 6h;
	push ax
	and ax, 01H
	jz 	even;
	cmp ax,1
	je odd
	ret;


; -------------------- Main program ---------------------------
main:
    	
	;mov ax,30; Address of prompt
	mov dx, message; Address of prompt
	call display ;	Display prompt

	mov ah,7h
	int 21h

	;mov dx, in_buf ; Address of input buffer
	;call get_chars	;	Get buffered keyboard input
	call oddEven;


	mov dx,cr_lf; Address of CR and LF 
	call display ; Send CRLF to screen


	int 20h; End of program 		

odd:
	mov dx,oddMsg
	call display
	int 20h
