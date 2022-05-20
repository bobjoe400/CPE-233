li s0, 0x11000000
lw t0, (s0)
li sp, 0x10000
BCD:	bltu t0, s5, one#checking if the numer is less than 10
	addi s5, zero, 10 #value for checking if we are done with divison
	addi sp, sp, -4
	sw t0, (sp)
	jal ra, div10
	bgt a0, s5, div10 #checking if we need to divide again
	blt a1, s3, thou #multiply quoteint by 10,000 if t5 = 4
	slli t1, s1, 13 #x*10^4 = (x<<13) + (x<<10) + (x<<9) + (x<<8) + (x<<4)
	slli t3, s1, 10
	add t4, t1, t3
	slli t1, s1, 9
	slli t3, s1, 8
	add t6, t1, t3
	add t6, t4, t6
	slli t1, s1, 4
	slli t4, s1, 16	 #shift 10,000's number into 10,000's nibble
	add t2, t1, t6 #final amount to subtract from total
	j write
	thou:	addi s3, s3, -1 #t5 = 3
		blt t5, s3, hund #mutliply quotient by 1,000 if t5 = 3
		slli t1, s1, 9 #x*10^3 = (x<<9) + (x<<8) + (x<<7) + (x<<6) + (x<<5) + (x<<3)
		slli t3, s1, 8
		add t4, t1, t3
		slli t1, s1, 7
		slli t3, s1, 6
		add t6, t1, t3
		add t6, t4, t6
		slli t1, s1, 5
		slli t3, s1, 3
		add t4, t1, t3
		add t2, t4, t6 #final amount to subtract from total
		slli t4, s1, 12 #shift 1,000's nubmer into 1,000's nibble
		j write
	hund:	addi s3, s3, -1 #2 
		blt t5, s3, ten #multiply quotient by 100 if t5 = 2
		slli t1, s1, 6 #x*10^2  = (x<<6) + (x<<5) + (x<<2)
		slli t3, s1, 5 
		add t6, t1, t3
		slli t1, s1, 2
		slli t4, s1, 8 #shift 100's number into 100's nibble
		add t2, t1, t6 #final amount to get subbed from total
		j write
	ten: 	addi s3, s3, -1 #1
		blt t5, s3, one #multiply quotient by 10 when t5 = 1
		slli t1, s1, 3 #x*10 = (x<<3) + (x<<1)
		slli t3, s1, 1
		slli t4, s1, 4 #shift 10's number into 10's nibble
		add t2, t1, t3 #final amount to get subbed from total
		j write
	one:	add s4, s4, t0
		j end
	write:	sub t0, t0, t2
		li t2, 0 #resetting t2
		add s4, s4, t4
		li t4, 0 #resetting t4
	bgez t0, BCD
end: sw	s4, 0x40(s0) #write ending number to 7SEGMENT		

div10: 	lw t4, -4(sp) #load input from stack pointer
	addi t3, zero, 1 #number of shifts
	addi t5, zero, 16 #divide by 10 needs 5 shifts 
	addi t6, zero, 4 #change from shifting input to current quotient
	loop: 	blt t3, t6, in #check for what we are shifting
		srl t1, t2, t3 #shift current quotient
		j addchk
	in:	srl t1, t4, t3 #shift input
	addchk:	add t2, t1, t2 #add value to quotient
		slli t3, t3, 1 #multiply shift amount by 2
		ble t3, t5, loop#check if we have gone over 16 for shift amnt
	srli t2, t2, 3 #final quotient shift
	addi a1, a1, 1 #increment division's done
	add a0, t2, zero #setting new division amount to the result of div10
	jr ra
