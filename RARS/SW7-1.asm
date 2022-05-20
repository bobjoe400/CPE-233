li s0, 0x11000000 #MMIO address

addi s2, zero, 10 #value for checking if we are done with divison
lw s1, (s0) #read in from switches
loop:	bltu s1, s2, one#checking if the number loaded in is less than 10
	addi t0, s1, 0#set temporary for number loaded in
	lui t1, 0 #reset number of divisions
	chklp:	add a0, t0, zero #send value in to function
		add a1, t1, zero #send current number of divisions to function
		jal ra, div10
		addi t0, a0, 0 #get return qotient
		addi t1, a1, 0 #get new number of divisions
	bgt t0, s2, chklp#checking if we need to divide again
	add a0, t0, zero #loading division result into function input
	addi s2, zero, 4 #value for checking number of divisions
	beq t1, s2, tenth #multiply quoteint by 10,000 if numdiv = 4
	addi s2, s2, -1 #t2 = 3
	beq t1, s2, thou  #multiply quotient by 1,000 if numdiv = 3
	addi s2, s2, -1 #t2 = 2
	beq t1, s2, hund #mutliply quotient by 1,000 if numdiv = 2
	addi s2, s2, -1 #t2 = 1
	beq t1, s2, ten #multiply quotient by 10 if numdiv = 1
	one:	add s3, s3, s1
		sw s3, 0x40(s0)
		j end
	write:	addi t0, a0, 0 #get BCD digit
		addi t1, a1, 0 #get new subtract value
		add s3, s3, t0 #put BCD in final answer
		sub s1, s1, t1 #subtract from number to get new dividend
	bgez s1, loop

div10: 	add t0, a0, zero #loading in number to divide
	add t1, a1, zero #load in number of divisions
	lui t2, 0 #reset t2
	lui t3, 0 #reset t3
	addi t4, zero, 1 #number of shifts
	addi t5, zero, 16 #divide by 10 needs 5 shifts 
	addi t6, zero, 4 #change from shifting input to current quotient
	divlp: 	blt t4, t6, in #check for what we are shifting
		srl t3, t2, t4 #shift current quotient
		j addchk
	in:	srl t3, t0, t4 #shift input
	addchk:	add t2, t3, t2 #add shifted value to quotient
		slli t4, t4, 1 #multiply shift amount by 2
		ble t4, t5, divlp#check if we have gone over 16 for shift amnt
	srli t2, t2, 3 #final quotient shift
	slli t3, t2, 3 #multiply quotient by 10
	slli t4, t2, 1 
	add t3, t3, t4 
	sub t0, t0, t3 #remainder (r = x - q*10)
	addi t3, zero, 9
	sgt t3, t0, t3 # (r > 9)
	add a0, t2, t3 # q = q + (r>9)
	addi a1, t1, 1 #increment number of divisions
	jr ra

tenth: 	add t0, a0, zero #load in quotient
	slli t1, t0, 13 #x*10^4 = (x<<13) + (x<<10) + (x<<9) + (x<<8) + (x<<4)
	slli t3, t0, 10
	add t4, t1, t3 #(x<<13) + (x<<10)
	slli t1, t0, 9
	slli t3, t0, 8
	add t6, t1, t3 #(x<<9) + (x<<8)
	add t6, t4, t6 #adding previous two to release t4
	slli t1, t0, 4
	slli a0, t0, 16	 #shift 10,000's number into 10,000's nibble
	add a1, t1, t6 #final amount to subtract from total
	j write

thou: 	add t0, a0, zero #load in quotient
	slli t1, t0, 9 #x*10^3 = (x<<9) + (x<<8) + (x<<7) + (x<<6) + (x<<5) + (x<<3)
	slli t3, t0, 8
	add t4, t1, t3 #(x<<9) + (x<<8)
	slli t1, t0, 7
	slli t3, t0, 6
	add t6, t1, t3 #(x<<7) + (x<<6)
	add t6, t4, t6 #adding previous two to release t4
	slli t1, t0, 5
	slli t3, t0, 3
	add t4, t1, t3 #(x<<5) + (x<<3)
	add a1, t4, t6 #final amount to subtract from total
	slli a0, t0, 12 #shift 1,000's nubmer into 1,000's nibble
	j write

hund:	add t0, a0, zero #load in quotient
	slli t1, t0, 6 #x*10^2  = (x<<6) + (x<<5) + (x<<2)
	slli t3, t0, 5 
	add t6, t1, t3 #(x<<6) + (x<<5)
	slli t1, t0, 2
	slli a0, t0, 8 #shift 100's number into 100's nibble
	add a1, t1, t6 #final amount to get subbed from total
	j write

ten:	add t0, a0, zero #load in quotient
	slli t1, t0, 3 #x*10 = (x<<3) + (x<<1)
	slli t3, t0, 1
	slli a0, t0, 4 #shift 10's number into 10's nibble
	add a1, t1, t3 #final amount to get subbed from total
	j write

end: 	
