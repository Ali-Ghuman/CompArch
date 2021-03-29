.data

.balign 4
    number_in: .asciz "%d"

.balign 4
    number_out: .asciz "%d\n"

.balign 4
    read: .asciz "r"

.balign 4
    write: .asciz "w"

.balign 4
    return: .word 0

.balign 4
    inFile: .asciz "in.txt"

.balign 4
    outFile: .asciz "out.txt"

.balign 4
    inputArray: .skip 400

.balign 4
    outputArray: .skip 400

.balign 4
lengthError: .asciz "***File size limit exceeded***\n"

.text

.global main

main: 
    ldr r7, addr_of_return
    str lr, [r7]

    ldr r0, addr_of_inFile
    ldr r1, addr_of_read
    bl fopen
    
    mov r13, r0  
    mov r5, #0 
    ldr r8, addr_of_inputArray

    
read_inputFile: 
    cmp r5, #400 
    bgt length_error 

    mov r0, r13
    ldr r1, addr_of_number_in
    add r2, r8, r5
    bl fscanf
    
    mov r0, r13
    add r5, r5, #4
    bl feof

    cmp r0, #0
    beq read_inputFile

end: 
    ldr lr, addr_of_return
    ldr lr, [lr]
	bx lr 

length_error: 
	ldr r0, addr_of_lengthError
	bl printf
	mov r0, #1 				

    ldr lr, addr_of_return
    ldr lr, [lr]
	bx lr 


addr_of_return: .word return 
addr_of_inputArray: .word inputArray
addr_of_outputArray: .word outputArray
addr_of_number_in: .word number_in
addr_of_number_out: .word number_out
addr_of_read: .word read
addr_of_write: .word write
addr_of_inFile: .word inFile
addr_of_outFile: .word outFile
addr_of_lengthError: .word lengthError

.global fopen
.global fprintf
.global fscanf
.global feof
.global printf
