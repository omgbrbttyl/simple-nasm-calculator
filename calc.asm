;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;run using "make";;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

bits 32 ; init 32 bit for nasm 
extern printf ; declare external function "printf" 
extern scanf ; declare external function "scanf" for user input
global main ; set gcc entry point (main function)

section .data ;place to init variable str
    t0: db "Method (1=add, 2=sub, 3=mult, 4=div): ", 0 ;user input string
    t1: db "Number 1: ", 0 ;first user input num 
    t2: db "Number 2: ", 0 ;second user input num 

    formatin: db "%d", 0 ;format for input (num)

    int1: times 4 db 0 ;32-bits integer = 4 bytes
    int2: times 4 db 0 ;same as int1
    method: times 4 db 0 ;same as other ints

	welcome0: db 10, "++++++++++++++++++++++++++++++++++++++++++++++++++++++", 0
	welcome1: db 10, "++++++++++WELCOME TO DYLAN'S NASM CALCULATOR++++++++++", 0
	welcome2: db 10, "++++++++++++++++++++++++++++++++++++++++++++++++++++++", 10, 10, 0

    prompt: db 10, "Type 1 to solve another equation or 2 to exit: ", 0 ;user prompt
    promptval: times 4 db 0 ;same as other ints

    final: db 10, "Answer=%d", 10, 0 ;setup for final printed string (printf)

main:

	call welcome ;calls method to print welcome screen

	call getinfo


getinfo: 

   	push t1 ;pushes first message to stack
   	call printf ;calls print with t1 param

   	add esp, 4 ;adjusts stack pointer by 4 bits (removes 1 param)
   	push int1 ;pushes int1 to stack (first param)
   	push formatin ;pushes format to stack (second param)
   	call scanf ;calls scanf with param 1 and param 2 in stack

   	add esp, 8 ;adjusts stack pointer by 8 bits (removes 2 params)

   	push t2 ;pushes second message to stack
   	call printf ;calls print with t2 param

   	add esp, 4 ;adjusts stack pointer by 4 bits (removes 1 param)
   	push int2 ;pushes int2 to stack (first param)
   	push formatin ;pushes format to stack (second param)
   	call scanf ;call scanf using format and int2

   	add esp, 8 ;adjusts stack pointer by 8 bits (removes 2 params)

   	push t0; pushes third message to stack (method 1=add, 2=sub, etc...)
   	call printf; prints t0

   	add esp, 4 ;adjusts stack pointer by 4 bits (removes 1 param)
   	push method ;pushes method to stack (first param)
   	push formatin ;pushes format to stack (second param)
   	call scanf ;calls scanf using method and format params

   	add esp, 8 ;adjusts stack pointer by 8 bits (removes 2 params)

   	;now that inputs are in data --> move inputs to register's

   	mov eax, dword [int1] ;move int1 to eax register
   	mov ebx, dword [int2] ;move int2 to ebx register
   	mov ecx, dword [method] ;move method to ecx register

   	;now that we have all of user inputs situated --> call proper method

   	cmp ecx, 1 ;compare method value and 1 (if ecx - 1 == 0)
   	je add ;jumps to add function

   	cmp ecx, 2 ;compare method value and 2 (if ecx - 2 == 0)
   	je sub ;jumps to sub function

   	cmp ecx, 3 ;compare method value and 3 (if ecx - 3 == 0)
   	je mult ;jumps to mult function

   	cmp ecx, 4 ;compare method value and 4 (if ecx - 4 == 0)
   	je div ;jumps to div function 


add:

	add eax,ebx ;add eax and ebx
	push eax ;push final eax value to stack

	push dword final ;pushes final string using eax as param

	call printf ;call printf using final as param

	add esp, 8 ;remove off stack

	jmp prompted ;call prompted to prompt next equation
	
sub: 

	sub eax, ebx ;subtract eax and ebx
	push eax ;push final eax value to stack

	push dword final ;pushes final string to stack using eax as param

	call printf ;call printf using final as param

	add esp, 8 ;remove off stack

	call prompted ;call prompted to prompt next equation


div:

	xor edx, edx ;make sure edx register isn't in use (we need for div operation)
	mov eax, dword [int1] ; make eax int1 for div
	div ebx ;divide eax and ebx
	push eax ;push final eax value

	push dword final ;pushes final string to stack using eax as param

	call printf ;call printf using final as param

	add esp, 8 ;remove off stack

	call prompted ;call prompted to prompt next equation

mult:

	xor edx, edx ;make sure edx register isn't in use (we need for mult operation)
	mov eax, dword [int1] ; make eax int1 for mult
	mul ebx ;mult eax and ebx
	push eax ;push final eax value

	push dword final ;pushes final string to stack using eax as param

	call printf ;call printf using final as param

	add esp, 8 ;remove off stack

	call prompted ;call prompted to prompt next equation


prompted:

	push prompt ;pushes prompt to stack
	call printf ;call printf

	add esp, 4 ;remove prompt off stack
	push promptval ;push int that scanf will push to
	push formatin ;push format for scanf
	call scanf ;call scanf function

	add esp, 8 ;remove promptval and formatin from stack

	mov eax, dword [promptval] ;set eax as promptval

	cmp eax, 1 ;figure out if promptval is 1 for 'yes'
	je getinfo ;if so then jump to main

	call exit ;exit program if doesn't jump


welcome: 

	push welcome0 ;push message to stack
	call printf ;print

	add esp, 4 ;clear stack pointers

	push welcome0 ;push message to stack
	call printf ;print

	add esp, 4 ;clear stack pointers

	push welcome1 ;push message to stack
	call printf ;print

	add esp, 4 ;clear stack pointers

	push welcome0 ;push message to stack
	call printf ;print

	add esp, 4 ;clear stack pointers

	push welcome2 ;push message to stack
	call printf ;print

	add esp, 4 ;clear stack pointers
	ret ;return


exit:

	mov eax, 1 ; system.exit
	mov ebx, 0 ; sys.exit("ebx") so set to 0
	int 0x80 ; interupt process (exit)
