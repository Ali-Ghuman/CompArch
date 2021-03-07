/* Project 1  */
/* Read in two strings of max length 12 and concatenate them */ 
/* Ali Ghuman, Xue Ru Zhou, Husam Almanakly, Layth Yassin */ 

.global main 

.data 

.balign 4 
    input1: .asciz "Enter a string for a test: " 

.balign 4
    input2: .asciz "Enter a second string: "

.balign 4
	printf_msg: .asciz "You typed the words:\n%s\nLength: %d\n" 
    
.balign 1
    word_read: .skip 14
    
.balign 1
    word_read2: .skip 14
    
.balign 1
    concatenated: .skip 25

.balign 4
    return: .word 0

.balign 4
    newline: .asciz "\n"

.balign 4
    null: .asciz "\0"

.balign 4
    error_msg: .asciz "Error Code 7: Program Exited\n"

.balign 4
    error_msg2: .asciz "Error Code 8: Program Exited\n"

.text

main: 
    //store the link register in addr_of_return
    ldr r1, addr_of_return    
    str lr, [r1]
    
   //set up counter and newline to check against 
    mov r9, #0
    ldr r6, addr_of_newline
    ldr r6, [r6]

    bl read_input 

read_input: 
    //promp user with first message
    ldr r0, addr_of_input
    bl printf    
    //use c function fgets to read in input of length 14 
    ldr r0, addr_of_word_read
    mov r1, #14
    ldr r3, addr_of_stdin
    ldr r2, [r3] 
    bl fgets
    b loop1

read_input2: 
    ldr r0, addr_of_input2
    bl printf    

    ldr r0, addr_of_word_read2
    mov r1, #14
    ldr r3, addr_of_stdin
    ldr r2, [r3] 
    bl fgets
    b buffer

loop1: //loop through string and add it to array while checking bounds
    cmp r9, #13
    beq error
    ldr r1, addr_of_concat
    ldr r2, addr_of_word_read
    ldrb r5, [r2, r9]
    cmp r5, r6
    beq read_input2
    strb r5, [r1, r9]
    add r9, r9, #1
    b loop1

buffer: 
    mov r7, #0
    
    b loop2

loop2: 
    cmp r7, #13
    beq error2
    ldr r1, addr_of_concat
    ldr r2, addr_of_word_read2
    ldrb r5, [r2, r7]
    cmp r5, r6
    beq end 
    strb r5, [r1, r9]
    add r9, r9, #1
    add r7, r7, #1
    b loop2

end: 
    ldr r0, addr_of_printf_msg
    ldr r1, addr_of_concat
    mov r2, r9
    bl printf

    
    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr

error:
    ldr r0, addr_of_error_msg
    bl printf
    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr

error2:
    ldr r0, addr_of_error_msg2
    bl printf
    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr
    
addr_of_printf_msg: .word printf_msg
addr_of_input: .word input1
addr_of_input2: .word input2
addr_of_word_read: .word word_read
addr_of_word_read2: .word word_read2
addr_of_concat: .word concatenated
addr_of_stdin: .word stdin
addr_of_return: .word return 
addr_of_newline: .word newline
addr_of_error_msg: .word error_msg
addr_of_error_msg2: .word error_msg2
addr_of_null: .word null
.global printf 
.global fgets 


