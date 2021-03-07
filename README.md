# CompArch

## Fri Mar 5
So far, I made it take in two strings and print out both of them

it still kind of bugs out when its too big though

I was thinking we pass in %13s for the scan pattern, 
so that it cuts off after 13 input chars. We can check that
and know if its too large

Make file works, use command "make all" and then run ./a.out 

## Sat Mar 6
Okay so, i think i got it working to check for 13 characters. 
I changed the input to fgets to 14 characters, so it cuts off 
at 13 and the thirteenth will be the null terminator

Then our conditional checks if r9 is equal to 13 and gives an error if it is 
(meaning we went out of bounds into 12)

I also added a conditional to check if we hit the newline character (so that if the 
string is < 12 it wont include the newline in the string)

Fixed redundancies and separated parts of code to make more organized. 
Fixed error messages so that $? gives the appropriate message. 
Added loop2 which loops through the second string and concatenates it to the first
