	bits 16
 	org 0x100
 	; This program accepts a number from the user as input
	; and displays a message to say if the number if a multiple of 3 
	;
	;--------------------- Jump over data declarations

	jmp main  ;

 ;prompt
message: db 'Please enter the number you select $'

 ; Input_buffer
in_buf: db 12 ; Length of input buffer (12 chars)
  
len_in: db 00 ; Length of input string will be stored here by dos

user: times 12 db '  ' ; Reserver 12 storage posisitons for input buffer

cr_lf: db 0x0a,0x0d,'$' ; Carriage return, Line feed	

; output messages
out_err_mess: db 'Number is NOT a multiple of 3$'

out_mess: db 'Numer is a multiple of 3$'

;----------------------Get characters that are input by user
get_chars:	; Accept a string of characters from the keyboard.
; The address of the input parameter block must be in DX 
	mov ah,0x0a
	int 21h
	ret

 ;---------------------- Display routine ------
display:     ; Display a message on the screen.
			 ; The address of the message must be in DX.
	mov ah,09h	;Request - display message
	int 21h  ;DOS system call
	ret 	; return	

;--------- string to number routine ------ 
; takes the value of string in user and converts to a number, and returns the result in ax
str_to_num:
	xor ax,ax ; Initial value of AX  = 0  
	xor bx,bx ; BH = 0 
	mov cx,10 ; To build integer in AX (multiply by 10)
	mov si,user ; DX points to start of input buffer

;---------- next char routine ------------------ 
next_char: 
	mov bl,[si] ; Move contents of memory pointed to by SI to BL	
	cmp bl,0Dh ; Is it a carriage return?
	je finish ; Yes, we are done
	cmp bl,39h ; ASCII for the character '9' is 39h
	jg error ; > '9', invalid character
	sub bl,30h
	imul cx ; DX:AX = AX * 10 (32-bit result)
	add ax,bx ; Add next digit
	inc si ; Pointer to next char
	jmp next_char ; Repeat for next character	

error:
	mov al,'E' ; Flag an error

finish:
	ret 

; --------- logic to test if number if divisable by 3 -----
divide:  ;--- assume value is in AX ; 
	mov bl,3 ; set the number we want to dive by
	div bl ; divide by 3 ;
	cmp ah,0 ; compare the Remainder with 0 
	jnz set_error 
	call set_success 
	ret 

set_error : 
	mov dx,out_err_mess
	ret

set_success: 
	mov dx, out_mess 
	ret

change_cursor: ; change the cursor position back to the left top of the screen
	mov ah,02 ; bios Set cursor position
	mov bh,00	
	mov dh,0
	mov dl,0
	int 10h
	ret

scroll_screen_up:	; Accept a string of characters from the keyboard.
; Assuming the screen is at default of 80x25 
	mov ah,06
	mov al,00
	mov ch,0
	mov cl,0
	mov dh, 24	; send of screen
	mov dl, 79 ; end of screen at 79
	mov bh, 17h	
	int 10h
	ret	

; -------------------- Main program ---------------------------
main:
		
	call scroll_screen_up ; clear the screen and change the colour 
	call change_cursor ;	
    	
	mov ax,30; Address of prompt
	mov dx, message; Address of prompt
	call display ;	Display prompt

	mov dx, in_buf ; Address of input buffer
	call get_chars	;	Get buffered keyboard input

	mov dx,cr_lf; Address of CR and LF 
	call display ; Send CRLF to screen

	call str_to_num ; conver to number
	call divide ; call divide subroutine ; 

	call display ; displays the message , either error or pass
	mov dx,cr_lf; Address of CR and LF 
	call display ; Send CRLF to screen


	int 20h; End of program 	
