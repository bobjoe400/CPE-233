.eqv MMIO, 0x11000000
init: 	li s0, MMIO #setup MMIO
	la t0, ISR 
	csrw t0, mtvec #setup ISR
	addi t0, zero, 1 
	csrw t0, mie #enable interrups
	lui t0, 0 #clear interrupt flag
	sw s1, 0x20(s0) #clear LEDs
	
loop:	beqz t0, loop
	sw s1, 0x20(s0) #write to LEDs
	csrw t0, mie #re-enable interrupts
	li t0, 0 #clear interrupt flag
	j loop
	
ISR:	addi t0, zero, 1 #set interrupt flag
	lw t1, (s0) #load in switches
	xor s1, s1, t1 #toggle bits to be written to LEDs
	mret