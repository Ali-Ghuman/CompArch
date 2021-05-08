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

.balign 4
    idx: .skip 4 

.balign 4
    scanPattern: .asciz "%lf%n"

.balign 4
    null: .asciz "\0"

.balign 4 
    left: .ascii "("

.balign 4 
    right: .ascii ")"

.balign 4 
    exponent: .ascii "^"

.balign 4 
    mul: .ascii "*"

.balign 4 
    div: .ascii "/"

.balign 4 
    add: .ascii "+" 

.balign 4 
    sub: .ascii "-" 

.balign 4
    printPattern: .asciz "%s\n" //for outputting

.balign 4
    return: .word 0 //used to save and retrieve lr 

.balign 4
    testPattern1: .asciz "%lf\n"    

.balign 4
    testPattern2: .asciz "%d\n"

.balign 8
    converted: .skip 152

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

load_char:

    ldr r0, addr_of_converted
    ldr r1, addr_of_input

    ldr r1, [r1, r4]
    str r1, [r0,r9]
    
    ldr r6, addr_of_idx
    ldr r6, [r6]
    add r4, r4, r6

    mov r10, #8
    mul r0, r6, r10
    add r9, r9, r0
    
    b float

float: 
    //still need ot check for starting with paranthesis
    cmp r4, r5 
    bge end

    ldr r0, addr_of_input
    add r0, r0, r4
    ldr r1, addr_of_scanPattern
    ldr r2, addr_of_converted
    ldr r3, addr_of_idx
    
    bl sscanf

    cmp r0, #0
    beq load_char
    //addeq r9, r9, #8
    //beq float
    
    //mov r1, r0
    //ldr r0, addr_of_testPattern2
    //bl printf
    
    ldr r0, addr_of_testPattern1
    ldr r6, addr_of_converted
    ldmia r6, {r2-r3}
    bl printf

    //ldr r0, addr_of_testPattern2
    //mov r1, r4
    //bl printf
    
    //ldr r0, addr_of_testPattern2
    //ldr r1, addr_of_idx
    //ldr r1, [r1]
    //bl printf
    
    ldr r0, addr_of_converted
    ldr r1, addr_of_input

    ldr r1, [r1, r4]
    str r1, [r0,r9]
    
   // ldr r0, addr_of_testPattern2
   // mov r1, r4
   // bl printf
     
    ldr r6, addr_of_idx
    ldr r6, [r6]
    add r4, r4, r6 

    mov r10, #8
    mul r0, r6, r10
    add r9, r9, r0

    b float    


initialize_postfix:
    mov r9, #0 //index of infix
    mov r4, #0 //index of postfix 
    
    push {r10}//push null onto stack as a marker for checking when the stack is empty 

    b read_exp 

read_exp:
    ldrb r5, [r8, r9] //load the next element from infix
    cmp r5, r10 //if it is the null char, go to empty_stack 
    beq empty_stack

    //check if char is a left parenthesis 
    ldr r3, addr_of_left 
    ldr r3, [r3] //load left parenthesiss char into r4
    cmp r5, r3
    beq left_parenthesis//branch to left_parenthesis if comparison is equal

    //check if char is a right parenthesis 
    ldr r3, addr_of_right 
    ldr r3, [r3] //overwrite r4 with the new char we are checking 
    cmp r5, r3 
    beq right_parenthesis//(right_parenthesis) 

    //check if char is a carrot (for exponent) 
    ldr r3, addr_of_exponent 
    ldr r3, [r3]
    cmp r5, r3 
    pusheq {r5} //always push the carrot
    addeq r9, r9, #1
    beq read_exp 

    //check if char is "*" (for multiplication) 
    ldr r3, addr_of_mul 
    ldr r3, [r3] 
    cmp r5, r3 
    beq mul_div

    //check if char is "/" ( division) 
    ldr r3, addr_of_div 
    ldr r3, [r3]
    cmp r5, r3 
    beq mul_div //for "*" and "/", branch to mul_div (same precendence)

    //check if char is "+" (addition) 
    ldr r3, addr_of_add
    ldr r3, [r3] 
    cmp r5, r3 
    beq add_sub  

    //check if char is "-" (subtraction) 
    ldr r3, addr_of_sub 
    ldr r3, [r3] 
    cmp r5, r3
    beq add_sub //addition and subtraction have the same precendence 

    ldr r2, addr_of_postfix 
    strb r5, [r2, r4] //append operands and decimals to postfix 
    add r4, r4, #1 
    add r9, r9, #1 
    

    b read_exp 

left_parenthesis: 
    //load first element of stack into r2
    pop {r2}
    push {r2} 

    add r9, r9, #1

    push {r5} //else, just push "(" to stack
    b read_exp

right_parenthesis: 
    //if stack is empty, a "(" is missing
    pop {r2} 
    push {r2}	

    cmp r2, r10 //comparing to null char to check if stack is empty 
    beq err_missing_parenthesis 
    
    ldr r3, addr_of_left 
    ldr r3, [r3]
    mov r6, r3  
    cmp r2, r3 //discard "("
    popeq {r3} 

    cmp r2, r6
    addeq r9, r9, #1 
    beq read_exp
    

    pop {r3} //in other cases, pop the operands left in the stack
    ldr r2, addr_of_postfix
    strb r3, [r2, r4] 
    add r4, r4, #1 
    b right_parenthesis //loop until you reach "("

mul_div: //push only if top of stack is "+", "-", "(" or stack is empty 
    pop {r2} 
    push {r2}
	
    add r9, r9, #1

    cmp r2, r10 
    pusheq {r5}
    beq read_exp 

    ldr r3, addr_of_add 
    ldr r3, [r3] 
    cmp r2, r3 
    pusheq {r5}
    beq read_exp 

    ldr r3, addr_of_sub 
    ldr r3, [r3] 
    cmp r2, r3 
    pusheq {r5}
    beq read_exp 

    ldr r3, addr_of_left 
    ldr r3, [r3]
    mov r6, r3 
    cmp r2, r3 
    pusheq {r5} 
    cmp r2, r6
    beq read_exp 

    pop {r3} 
    push {r5}
    ldr r2, addr_of_postfix
    strb r3, [r2, r4] 
    add r4, r4, #1  
    b read_exp 
 
add_sub: //push only if stack is empty or top of stack is "(" 
    pop {r2}
    push {r2} 	
    
    cmp r2, r10
    pusheq {r5}
    addeq r9, r9, #1
    beq read_exp 

    ldr r3, addr_of_left 
    ldr r3, [r3] 
    cmp r2, r3 
    pusheq {r5}
    addeq r9, r9, #1
    beq read_exp 

    pop {r3}
    ldr r2, addr_of_postfix 
    strb r3, [r2, r4] 
    add r4, r4, #1 
    b add_sub 

empty_stack: 
    pop {r5} //check if top of stack is null

    cmp r5, r10 
    beq append_null //branch to append_null if stack is empty 

    ldr r3, addr_of_left
    ldr r3, [r3]
    cmp r5, r3
    beq err_missing_parenthesis
     
    ldr r2, addr_of_postfix
    strb r5, [r2, r4] //append operator to postfix, loop until stack is empty
    add r4, r4, #1 
    b empty_stack 

append_null: //append null char to postfix  
    ldr r2, addr_of_postfix
    strb r10, [r2, r4] 
    b print_postfix 

print_postfix: //a test to print postfix
    ldr r1, addr_of_postfix
    ldr r0, addr_of_printPattern
    bl printf

    b end 

err_missing_operator:
    ldr r0, addr_of_missOp
    bl printf

    b end

err_missing_parenthesis:
    ldr r0, addr_of_parError
    bl printf

    b end


end:
    ldr r0, addr_of_scan 
    ldr r1, addr_of_converted //used to print out the array, to check if what i read in was correct
    ldr r1, [r1, #8]

    bl printf

    mov r0, #0 //return 0 for success
    ldr lr, addr_of_return //retrieve lr
    ldr lr, [lr]
    bx lr 



addr_of_printPattern: .word printPattern
addr_of_input: .word input
addr_of_postfix: .word postfix
addr_of_scan: .word scan
addr_of_null: .word null
addr_of_left: .word left 
addr_of_right: .word right 
addr_of_exponent: .word exponent 
addr_of_mul: .word mul 
addr_of_div: .word div
addr_of_add: .word add
addr_of_sub: .word sub 
addr_of_lengthError: .word lengthError
addr_of_parError: .word parError
addr_of_missOp: .word missOp
addr_of_return: .word return 
addr_of_idx: .word idx
addr_of_scanPattern: .word scanPattern
addr_of_testPattern1: .word testPattern1
addr_of_testPattern2: .word testPattern2
addr_of_converted: .word converted
addr_of_temp: .word temp

.global printf
.global scanf
.global sscanf
