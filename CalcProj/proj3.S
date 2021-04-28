.data 

.balign 4
    scan: .asciz "%c" #for reading in input

.balign 4
    lengthError: .asciz "ERROR: *Input length limit exceeded*\n" #error for later on i guess

.balign 4
    input: .skip 100  #used 100 here for now

.balign 4
    null: .asciz "\0" 

.balign 4
    printPattern: .asciz "%s\n" #for outputting

.balign 4
    return: .word 0 //used to save and retrieve lr 

.text

.global main

main: 
    ldr r7, addr_of_return //set up lr for returning
    str lr, [r7]

    ldr r6, [r1, #4] //pointer to first char of argv into r6

    ldr r0, addr_of_printPattern //check to make sure what you're reading in 
    ldr r1, [r1, #4]
    bl printf

    ldr r10, addr_of_null #null to check for end of string
    ldr r10, [r10]
    mov r5, #0 #set up iterator to put into array
    ldr r8, addr_of_input

loop: #store into array 
    ldrb r9, [r6, r5]  #r9 = argv[r5]
    strb r9, [r8, r5]  #input[r5] = r9
    cmp r9, r10 #if null, end
    beq end
    
    add r5, r5, #1 #update iterator
    b loop

end: 
    ldr r0, addr_of_printPattern 
    ldr r1, addr_of_input #used to print out the array, to check if what i read in was correct
    bl printf

    mov r0, #0 //return 0 for success
    ldr lr, addr_of_return //retrieve lr
    ldr lr, [lr]
	bx lr 



addr_of_printPattern: .word printPattern
addr_of_input: .word input
addr_of_scan: .word scan
addr_of_null: .word null
addr_of_lengthError: .word lengthError
addr_of_return: .word return 

.global printf
.global scanf

