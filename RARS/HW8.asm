.eqv SSEG, 0x11000040
INIT: 	li s1, SSEG
	la t0, ISR
	csrrw x0, mtvec, t0 #setup ISR address
	li t0, 1
	csrrw x0, mie, t0 #enable interrupts
	addi t0, x0, 0 #clear interrupt flag
	addi s0, x0, 0 #clear interrupt count
	sw s0, 0(s1) #clear SSEG
LOOP: 	beq t0, x0, LOOP #check for interrupt flag
	sw s0, 0(s1) #update SSEG with new count
	csrrw x0, mie, t0 #re-enable interrupts
	addi t0, x0, 0 #clear interrupt flag
	j LOOP
ISR: 	addi t0, x0, 1 #set interrupt flag
	addi s0, s0, 1 #increment interrupt count
	mret