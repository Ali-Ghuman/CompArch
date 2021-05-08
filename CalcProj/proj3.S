
.data 

.balign 4
    scan: .asciz "%c\n" //for reading in input

.balign 4
    lengthError: .asciz "ERROR: *Input length limit exceeded*\n" //error for later on i guess

.balign 4
    parError: .asciz "ERROR: *Paranthesis Syntax*\n"

.balign 4
    missOp: .asciz "ERROR: *Missing Operator*\n"

.balign 1
    input: .skip 19 //used 50 here for now

.balign 8
    temp: .skip 1

.balign 1 
    postfix: .skip 19 // 19 is the max number of chars, including any possible decimal points

.balign 1
    idx: .skip 4 

.balign 4
    scanPattern: .asciz "%lf%n"

.balign 4
    null: .asciz "\0"

.balign 4
    printPattern: .asciz "%s\n" //for outputting

.balign 4
    return: .word 0 //used to save and retrieve lr 

.balign 4
    testPattern1: .asciz "%lf\n"    

.balign 4
    testPattern2: .asciz "%d\n"

.balign 8
    operands: .skip 152

.balign 1
    operators: .skip 20

.text

.global main

main: 
    ldr r7, addr_of_return //set up lr for returning
    str lr, [r7]

    ldr r6, [r1, #4] //pointer to first char of argv into r6

    ldr r0, addr_of_printPattern //check to make sure what you're reading in 
    ldr r1, [r1, #4]
    bl printf

initialize_loop: //i separated this from main bc i overwrite r5 and r8
    ldr r10, addr_of_null //null to check for end of string
    ldr r10, [r10]
    mov r5, #0 //set up iterator to put into array
    ldr r8, addr_of_input

    b loop 
 
loop: //store into array 
    ldrb r9, [r6, r5]  //r9 = argv[r5]
    strb r9, [r8, r5]  //input[r5] = r9
    cmp r9, r10 //if null, end
    beq initialize_float  
    
    add r5, r5, #1 //update iterator
    b loop

//Converting from infix to postfix

initialize_float: 
    mov r4, #0 //r4 = n    
    mov r9, #0 

    ldr r6, addr_of_idx
    str r4, [r6]
    
    b float

float: 
    //still need ot check for starting with paranthesis
    cmp r4, r5 
    bge initialize_check //process 2 branch 

    ldr r6, addr_of_input
    ldrb r6, [r6, r4]
    
    //ldr r0, addr_of_testPattern2
    //mov r1, r9
    //bl printf

    //ldr r0, addr_of_testPattern2
    //mov r1, r4
    //bl printf


    ldr r0, addr_of_input
    add r0, r0, r4
    ldr r1, addr_of_scanPattern
    ldr r2, addr_of_temp
    ldr r3, addr_of_idx
    bl sscanf
    
    cmp r6, #'+'
    beq load_op
    cmp r6, #'-'
    beq load_op
    cmp r6, #'/'
    beq load_op
    cmp r6, #'*'
    beq load_op
    cmp r6, #'('
    beq load_op
    cmp r6, #')'
    beq load_op
    cmp r6, #'^'
    beq load_op
    
    //ldr r0, addr_of_input
    //add r0, r0, r4
    //ldr r1, addr_of_scanPattern
    //ldr r2, addr_of_temp
    //ldr r3, addr_of_idx
    //bl sscanf
    
    //load temp into operands 
    ldr r0, addr_of_operands
    add r0, r0, r9
    ldr r1, addr_of_temp
    ldmia r1, {r2-r3}
    stmia r0, {r2-r3}   

    //ldr r0, addr_of_testPattern1
    //ldr r6, addr_of_operands
    //add r6, r6, r9
    //ldmia r6, {r2-r3}
    //bl printf
     
    ldr r6, addr_of_idx
    ldr r6, [r6]
    add r4, r4, r6 

    //mov r10, #8
    //mul r0, r6, r10
    add r9, r9, #8

    b float

load_op:

    //ldr r6, addr_of_idx
    //ldr r6, [r6]
    //add r4, r4, r6

    //mov r10, #8
    //mul r0, r6, r10
    //add r9, r9, r0
    
    ldr r0, addr_of_operands
    ldr r1, addr_of_input
    ldrb r1, [r1, r4]
    str r1, [r0, r9]

    ldr r6, addr_of_idx
    ldr r6, [r6]
    add r4, r4, #1
    
    mov r10, #8
    mul r0, r6, r10
    add r9, r9, #8

    //ldr r0, addr_of_scan
    //ldr r1, addr_of_operands
    //ldr r1, [r1, r9]
    //bl printf

    b float

initialize_check: 
    mov r5, r9
    mov r9, #0    

    b check

check:
    cmp r9, r5
    bge end

    ldr r6, addr_of_operands
    ldrb r6, [r6, r9]

    cmp r6, #'+'
    beq printc
    cmp r6, #'-'
    beq printc
    cmp r6, #'/'
    beq printc
    cmp r6, #'*'
    beq printc
    cmp r6, #'('
    beq printc
    cmp r6, #')'
    beq printc
    cmp r6, #'^'
    beq printc

    ldr r10, addr_of_operands
    add r10, r10, r9
    ldmia r10, {r2-r3}
    ldr r0, addr_of_testPattern1
    bl printf
    
    add r9, r9, #8

    b check

printc: 
    mov r1, r6
    ldr r0, addr_of_scan
    bl printf
    
    add r9, r9, #8

    b check

//initialize_postfix:
//    mov r3, r9
//
//    mov r9, #0 //index of infix
//    mov r4, #0 //index of postfix 
//    
//    ldr r8, addr_of_operands
//        
//    ldr r10, addr_of_null
//    ldr r10, [r10]    
//    push {r10}//push null onto stack as a marker for checking when the stack is empty 
//    b read_exp 
//
//read_exp:
//    cmp r9, r3
//    beq empty_stack
//
//    add r8, r8, r9
//    ldr r5, [r8, r9] //load the next element from infix
//    cmp r5, r10 //if it is the null char, go to empty_stack 
//    beq empty_stack
//
//    //check if char is a left parenthesis 
//    ldr r3, addr_of_left 
//    ldr r3, [r3] //load left parenthesiss char into r4
//    cmp r5, r3
//    beq left_parenthesis//branch to left_parenthesis if comparison is equal
//
//    //check if char is a right parenthesis 
//    ldr r3, addr_of_right 
//    ldr r3, [r3] //overwrite r4 with the new char we are checking 
//    cmp r5, r3 
//    beq right_parenthesis//(right_parenthesis) 
//
//    //check if char is a carrot (for exponent) 
//    ldr r3, addr_ofhusam.almanakly@comparch:~/public_html/CompArch/CalcProj$ exit
//    add r4, r4, #1 
//    add r9, r9, #1 


end:
    //might be a trailing zero or something
    //ldr r0, addr_of_scan
    ldr r0, addr_of_testPattern1
    ldr r10, addr_of_operands//used to print out the array, to check if what i read in was correct
    //ldr r1, [r10, #16]
    add r10, r10, #24
    ldmia r10, {r2-r3}
    //bl printf

    //ldr r0, addr_of_testPattern1
    //ldr r1, addr_of_converted
    //bl printf

    mov r0, #0 //return 0 for success
    ldr lr, addr_of_return //retrieve lr
    ldr lr, [lr]
    bx lr


addr_of_printPattern: .word printPattern
addr_of_input: .word input
addr_of_postfix: .word postfix
addr_of_scan: .word scan
addr_of_null: .word null
addr_of_lengthError: .word lengthError
addr_of_parError: .word parError
addr_of_missOp: .word missOp
addr_of_return: .word return
addr_of_idx: .word idx
addr_of_scanPattern: .word scanPattern
addr_of_testPattern1: .word testPattern1
addr_of_testPattern2: .word testPattern2
addr_of_operands: .word operands
addr_of_temp: .word temp
addr_of_operators: .word operators

.global printf
.global scanf
.global sscanf

