.eqv MMIO, 0x11000000
init: 	li s0, MMIO #setup MMIO
	la t0, ISR 
	csrw t0, mtvec #setup ISR
	addi t0, zero, 1 
	csrw t0, mie #enable interrups
	lui t0, 0 #clear interrupt flag
	sw s1, 0x20(s0) #clear LEDs
	li s2, 0xFFFF0000 #impossible value for checking first input zeros
	
loop:	beqz t0, loop #wait for interrupt
	sw s1, 0x20(s0) #write to LEDs
	csrw t0, mie #re-enable interrupts
	li t0, 0 #clear interrupt flag
	j loop
	
ISR:	addi t0, zero, 1 #set interrupt flag
	lw t1, (s0) #load in switches
	bne t1, s2, skip #check if the last switches is the same as the current
	sw zero, 0x20(s0) #turn off leds
	loop2:	lw t1, 0x200(s0) #load in button
		beqz t1, loop2 #check if button has been pressed
		j end #jump to end of isr
	skip:	add s2, zero, t1 #store switch value for comparison
		xor s1, s1, t1 #toggle bits to be written to LEDs
	end:	mret