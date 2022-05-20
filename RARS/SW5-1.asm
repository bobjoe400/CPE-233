li t0, 3 #array index
li s0, 0x6000 #data index start
li s1, 0x11000020 #led index
li t2, 1 #fn-1
sw t2, 0x4(s0) #store in array
li t1, 0#fn-2
sw t1, 0x0(s0)
add t3, t1, t2 #first fibonacci number
sw t3, 0x8(s0)
addi s0, s0, 12 #setting start point of loop as 4th index of array
li t4, 24 #stop at 436368
loop: 	bgt t0, t4, diff #check if array index > 24
	lw t1, -4(s0) #load 2 previous numbers
	lw t2, -8(s0) 
	add t3, t1, t2 #add them 
	sw t3, 0x0(s0) #save them to current array index
	addi s0, s0, 4 #move index up 4
	addi t0, t0, 1 #increment counter
	j loop 
diff:	li s0, 0x6000 #reset array pointer
	addi t3, zero, 3
	addi t4, zero, 25
loop2: 	lw t1, 0x0(s0) #load first word
	lw t2, 0xc(s0) #load second word
	addi, s0, s0, 4 #move primary index up by 4
	addi, t3, t3, 1
	sub t0, t2, t1 #find difference between numbers
	sw t0, 0x0(s1) #send difference to leds 
	bne t3, t4, loop2 