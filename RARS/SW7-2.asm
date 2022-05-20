li s0, 0x11000000 #set switch address
li sp, 0x10000 #initialize stack pointer
lw a0, (s0) #load vaule 1 into input register
lw a1, (s0) #load value 2 into input register
jal gcd
sw a0, 0x20(s0) #store result in led's
j end

gcd: 	beq a0, a1, endsr #check for end of recurse
	blt a0, a1, else #check if a0 > a1
		sub a0, a0, a1 #update x (a0) and run sr again
		j gcd
	else:	sub a1, a1, a0 #upadate y (a1) and run sr again
		j gcd
	endsr:	jr ra
end: