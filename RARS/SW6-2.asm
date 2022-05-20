li s0, 0x11000000 #MMIO
li sp, 0x10000 #initalize sp
li s1, 0xFFFFFFFF #custom stop value
li s2, 0xeffc #stack underflow control value
loop: 	lw t1, 0x0(s0) #load in new value
	beq t1, s1, read #checking FFFF_FFFF
	addi sp, sp, -4 #go to next sack location
	beq sp, s2, under #checking stack underflow
	sw t1, (sp) #push to stack
	j loop
under:	addi sp, sp, 4 #fixing underlfow
read:	li s1, 0x10000 #setting temp stack pointer
loop2:	beq s1, sp, end #check if temp pointer = current sp
	addi s1, s1, -4 #run through stack in FIFO
	lw t1, 0(s1)#run through stack in FIFO
	sw t1, 0x20(s0) #write to LED's
	j loop2
end: 	li sp, 0x10000 #reset stack pointer
	