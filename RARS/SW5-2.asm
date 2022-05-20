li s0, 0x11000000 #initalizing MMIO pointer
li s1, 0x6000 #initialzing data pointer
lw t3, 0x0(s0) #loading first value
sw t3, 0x0(s1) #storing first value
addi t0, zero, 1 #setting array size
addi s2, zero, 10#setting array max size
loop: 	beq t0, s2, disp
	lw t3, 0x0(s0) #in value
	addi t2, zero, 1 #setting comparisons done
	add t1, zero, s1 #setting pointer to base index
	check: 	lw t4, 0x0(t1) #grabs current value at pointer
		bltu  t3, t4, less #checks if input is greater than comparison
		bltu t2, t0 true #checks if comparisons done is less than size
		addi t1, t1, 4
		j store #if not we are at the end of the array
		true: 	addi t2, t2, 1 #if so add one to comparisons done and   
                                         #continue with checks
			addi t1, t1, 4 #adds to pointer
			j check
		less: 	addi t5, t1, 0 #if our number is less than the compared
                                       #number, we need to insert it
			addi t6, t2, 0 #this is done by going to the end of the                  
                                        #array, working our way 
			loop2:	bgtu t6, t0, shuf #backwards moving each word to the  
                                                 #next word address
				addi t5, t5, 4 #<-- This loop is getting our
                                                 #temporary pointer to the end
				addi t6, t6, 1 #of the array
				j loop2
			shuf:	blt t5, t1, store #we are comparing the temporary 
                                                    #pointer with our comparison
				lui t6, 0 #pointer. When the pointer becomes less      
                                            #than the comparison pointer,
				addi t6, t5, 4 #we have shuffled everything.
				lw t4, 0x0(t5) #load the word at the temporary 
                                                 #pointer
				sw t4, 0x0(t6) #store the loaded word into the next  
                                                 #word address 
				addi t5, t5, -4 #subtract 4 from the temporary 
                                                  #pointer
				j shuf				
	store:	sw t3, 0x0(t1) #store the number and increment size
		addi t0, t0, 1
		j loop
disp:	lui t1, 0 #initialize counter for display
	add t2, zero, s1 #set array address pointer to beginning of array
	loop3: 	bgeu t1, t0, end #check if we have counted through all the array 
                                  #elements
		lw t3, 0x0(t2) #load current element in array
		sw t3, 0x20(s0) #store to led address
		addi t2, t2, 4 #increment pointer
		addi t1, t1, 1 #increment counter
		j loop3
end: