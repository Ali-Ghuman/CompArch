/* Project 1  */


.global main 

.data 

.balign 4 
	scanf_msg: .asciz "Enter a string for a test: " 

.balign 4
    scanf_msg2: .asciz "Enter a second string: "

.balign 4
	printf_msg: .asciz "You typed the words:\n%s\n" 

.balign 4
	scan_pattern: .asciz "%s" 

.balign 1
 	word_read: .skip 14
    
.balign 1
    word_read2: .skip 12
    
.balign 1
    cat: .skip 24 

.balign 4
    return: .word 0

.balign 4
    null: .asciz "\0"

.balign 4
    new_line: .asciz "\n"

.balign 4
    error_msg: .asciz "Error Code 7: Program Exited \n"

.text

main: 
    //store the link register in addr_of_return
    ldr r1, addr_of_return    
    str lr, [r1]
    
    //promp user with first message
    ldr r0, addr_of_scanf_msg
    bl printf    
    
    ldr r0, addr_of_word_read
    mov r1, #14
    ldr r3, addr_of_standard
    ldr r2, [r3] 
    bl fgets
    
    mov r9, #0
    ldr r4, addr_of_null
    ldr r4, [r4]
    ldr r6, addr_of_newline
    ldr r6, [r6]
    b loop

loop:
    ldr r1, addr_of_cat
    ldr r2, addr_of_word_read
    ldrb r5, [r2, r9]
    strb r5, [r1, r9]
    add r9, r9, #1
    ldrb r3, [r2,r9]
    cmp r3, r4
    beq end   
    cmp r3, r6
    beq end
    b loop
end: 
    cmp r9, #13
    beq error
    ldr r0, addr_of_printf_msg
    bl printf
    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr

error:
    ldr r0, addr_of_error
    bl printf
    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr

addr_of_printf_msg: .word printf_msg
addr_of_scanf_msg: .word scanf_msg
addr_of_scanf_msg2: .word scanf_msg2
addr_of_scan_pattern:  .word scan_pattern
addr_of_word_read: .word word_read
addr_of_word_read2: .word word_read2
addr_of_cat: .word cat
addr_of_standard: .word stdin
addr_of_return: .word return 
addr_of_newline: .word new_line
addr_of_error: .word error_msg
addr_of_null: .word null


.global printf 
.global getchar
