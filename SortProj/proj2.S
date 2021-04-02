.data

.balign 4
    number_in: .asciz "%d" //pattern for reading in ins

.balign 4
    number_out: .asciz "%d\n" //pattern for outputting ints

.balign 4
    read: .asciz "r"  //r for reading

.balign 4
    write: .asciz "w" //w for writing

.balign 4
    return: .word 0 //used to save and retrieve lr 

.balign 4
    inFile: .asciz "in.txt" //input file name

.balign 4
    outFile: .asciz "out.txt" //output file name

.balign 4
    inputArray: .skip 400 //array of 400 ints to be sorted

.balign 4
lengthError: 
    .asciz "ERROR: *File size limit exceeded*!\n" //error message for exceeding size 

.balign 4
nameError:
     .asciz "ERROR: *Your file name should be in.txt in the current directory!*\n" //error message for wrong name 

.text

.global main

main: 
    ldr r7, addr_of_return //set up lr for returning
    str lr, [r7]

    ldr r0, addr_of_inFile //open in.txt and retrieve its file pointer
    ldr r1, addr_of_read //open in read mode
    bl fopen

    cmp r0, #0  //if fopen fails, go to error
    beq name_error
    
    mov r13, r0 //save the file pointer to in.txt 
    mov r5, #0 //set up the iterator for reading in input 
    ldr r8, addr_of_inputArray //r8 holds the address to the start of array
    
read_inputFile: 
    cmp r5, #400    //if r5 > 400 (100 ints) throw error 
    bgt length_error 

    mov r0, r13  //move the file pointer into r0 for fscanf
    ldr r1, addr_of_number_in //load the pattern to read in ints 
    add r2, r8, r5 //go to the part of the array we're currently at (r5)
    bl fscanf
    
    mov r0, r13 //move back in the file pointer to r0 to check for EOF
    add r5, r5, #4 //increment iterator r5 to next element in array 
    bl feof //used to check if r0 is at EOF or not

    cmp r0, #0 //if equal, means we're not at the EOF so we continute
    beq read_inputFile

set_up_outputFile: //branch to this when sorting is completed
    ldr r0, addr_of_outFile //load in address of output file out.txt
    ldr r1, addr_of_write //load in w for write 
    bl fopen //call fopen on out.txt in write mode

    mov r13, r0 //move the file pointer of out.txt into r13
    ldr r8, addr_of_inputArray //laod address of sorted input into r8
    mov r6, #0  //set up iterator to determine if we're finished outputting
    sub r5, r5, #4 //when reading in input, r5 goes beyond the file length by 4 bytes, so we subtract it off
    b write_outputFile
   
write_outputFile:
    mov r0, r13 //move filer pointer of out.txt into r0
    ldr r1, addr_of_number_out //load in output pattern into r1
    add r2, r8, r6 //set up the array to where we're at currently (r6)
    ldr r2, [r2] //load into r2 the value at the point in the array
    bl fprintf

    add r6, r6, #4 //incremement iterator
    cmp r5, r6 //if r5 = r6, means we're at the end of the array 
    bgt write_outputFile

end: 
    mov r0, #0 //return 0 for success
    ldr lr, addr_of_return //retrieve lr
    ldr lr, [lr]
	bx lr 

name_error: 
	ldr r0, addr_of_nameError //load in the address of the nameError statement
	bl printf //print the error to terminal
	mov r0, #2 // error value of 2				

    ldr lr, addr_of_return  
    ldr lr, [lr]
	bx lr 

length_error: 
	ldr r0, addr_of_lengthError //load in the address of the lengthError statement
	bl printf //print error to terminal
	mov r0, #1 	//return error code of 1		

    ldr lr, addr_of_return
    ldr lr, [lr]
	bx lr 


addr_of_return: .word return 
addr_of_inputArray: .word inputArray
addr_of_number_in: .word number_in
addr_of_number_out: .word number_out
addr_of_read: .word read
addr_of_write: .word write
addr_of_inFile: .word inFile
addr_of_outFile: .word outFile
addr_of_lengthError: .word lengthError
addr_of_nameError: .word nameError 

.global fopen
.global fprintf
.global fscanf
.global feof
.global printf
