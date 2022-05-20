li x5, 0x11000000 #assign address location to register
lhu x6, 0(x5) #take in the two switch values
lhu x7, 0(x5)
add x6, x6, x7 #add the first two values and store in first register
lhu x7, 0(x5) #take in the third switch value
add x6, x6, x7 #add the first sum and the new switch value
sh x6, 0x20(x5) #output to led address