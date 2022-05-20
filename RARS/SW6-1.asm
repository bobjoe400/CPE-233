li s0, 0x11000000 #MMIO
li sp, 0x10000 #initalize sp
li s1, 0xFFFFFFFF #custom stop value
li s2, 0xf000 #stack underflow control value
loop: 	lw t1, 0x0(s0) #load in new value
	beq t1, s1, read #checking FFFF_FFFF
	beq sp, s2, under#checking stack underflow
	addi sp, sp, -4 #go to next stack location
	sw t1, (sp) #push to stack
	j loop
under:	nop #catch underflow
read:	li s1, 0x10000 #resetting stack pointer control
loop2:	beq sp, s1, end #checking stack overflow
	lw t1, 0(sp) #pop from stack
	addi sp, sp, 4
	sw t1, 0x20(s0) #send to LED's
	j loop2
end:	
