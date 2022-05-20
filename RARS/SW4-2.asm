li s0, 0x11000000
lhu t0, 0x0(s0) #load in dividend from switches 
lhu t1, 0x0(s0) #load in divisor from switches
beqz t1, end #check for zero condition
addi t2, zero, 1 #set t2 to 1 to check for a divisor of 1
beq t1, t2, one #check for if divisor is 1, to skip uneeded subtraction
lui t2, 0 #reset t2 to 0
loop:	bltu t0, t1, end #check if divisor is less than divisor
	addi t2, t2, 1 #add 1 to quotient
	sub t0, t0, t1 #subtract divisor from dividend
	j loop
one:	addi t2, t0, 0 #set quotient register to dividend
	lui t0, 0 #set remainder register to 0
end:	sh t2, 0x40(s0) #store quotient in 7SEGMENT
	sh t0, 0x20(s0) #store remainder in LEDS