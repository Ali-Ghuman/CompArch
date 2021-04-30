# Makefile

all: calc

calc: proj3.S .clean
	arm-linux-gnueabi-gcc $< -o $@ -ggdb3 -static   

.clean: 
	rm -f calc
