.data

.balign 4
    number_in: .asciz "%d" //pattern for reading in ints

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
    array: .skip 400 //array of 400 ints to be sorted

.balign 4
lengthError: 
    .asciz "ERROR: *File size limit exceeded*!\n" //error message for exceeding size 

.balign 4
nameError:
    .asciz "ERROR: *Your file name should be 'in.txt' in the current directory!*\n" //error message for wrong name 

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
    ldr r8, addr_of_array //r8 holds the address to the start of array
    
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

    sub r5, r5, #4 //when reading in input, r5 goes beyond the file length by 4 bytes, so we subtract it off

    b intialize_sort 

intialize_sort:
    mov r6, #0 //r6 = iteration number 
    sub r4, r5, #4 //r4 = last array index in bytes (array size - 4 bytes) 
	
    b iterate_sort

iterate_sort: //iterate through the array many times until sorted 
    cmp r5, r6, LSL #2 //compare if the iteration number = # of iterations needed (= array size) 
    beq set_up_outputFile 

    add r6, r6, #1 //the start of the new iteration 
    sub r2, r6, #1 //r2 = current element index, set to 1 less than iteration # at start of iteration
	
    mov r3, r2 //setting the current element index as r3 = current minimum index 

    b loop_sort 
 
loop_sort: //incrementing through the array elements 
    cmp r4, r2, LSL #2 //if current element is last element of array, go to swap_sort
    beq swap_sort 

    add r2, r2, #1 //increment index counter 
	
    ldr r9, [r8, r2, LSL #2] //current element value in array
    ldr r10, [r8, r3, LSL #2] //current minimum value
    cmp r9, r10 //if current element < current minimum, overwrite the current minimum index 
    movlt r3, r2 

    b loop_sort

swap_sort: //swapping values in the array after getting the minimum value in one iteration
    sub r7, r6, #1 //subtracting iteration number by 1 to get the index that should be replaced
	
    ldr r9, [r8, r3, LSL #2]
    ldr r10, [r8, r7, LSL #2] 

    str r10, [r8, r3, LSL #2] 
    str r9, [r8, r7, LSL #2] 	
	
    b iterate_sort 

set_up_outputFile: //branch to this when sorting is completed
    ldr r0, addr_of_outFile //load in address of output file out.txt
    ldr r1, addr_of_write //load in w for write 
    bl fopen //call fopen on out.txt in write mode

    mov r13, r0 //move the file pointer of out.txt into r13
    ldr r8, addr_of_array //laod address of sorted input into r8
    mov r6, #0  //set up iterator to determine if we're finished outputting
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
addr_of_array: .word array
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
