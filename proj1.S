/* Project 1  */


.global main 

.data 

.balign 4 
	scanf_msg: .asciz "Enter a string for a test: " 

.balign 4
    scanf_msg2: .asciz "Enter a second string: "

.balign 4
	printf_msg: .asciz "You typed the words: \n%s %s\n" 

.balign 4
	scan_pattern: .asciz "%13s" 

.balign 1
 	word_read: .skip 12
    
.balign 1
    word_read2: .skip 12
    
.balign 1
    cat: .skip 24 

.balign 4
    return: .word 0

main: 
    //store the link register in addr_of_return
    ldr r1, addr_of_return    
    str lr, [r1]
    
    //promp user with first message
    ldr r0, addr_of_scanf_msg
    bl printf    
    

    //take the user input and store in word_read
    ldr r0, addr_of_scan_pattern
    ldr r1, addr_of_word_read
    bl scanf

    //prompt user for the second message
    ldr r0, addr_of_scanf_msg2
    bl printf

    //store user input in word_read2
    ldr r0, addr_of_scan_pattern
    ldr r1, addr_of_word_read2
    bl scanf
    
    //print to output
    ldr r0, addr_of_printf_msg
    ldr r1, addr_of_word_read
    ldr r2, addr_of_word_read2
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
addr_of_return: .word return 



.global printf 
.global scanf
