li x5, 0x11000000
lw x6, 0(x5)
andi x7,x6,3
bnez x7, ELSE #if either of the last two bits are 1, then its not divisible by 4 
not x6,x6
j end
ELSE: andi x7,x6,1
bnez x7, ODD #if the last bit is a 1 its not divisible by 2
addi x7,x0,1
sub x6, x6, x7
j end
ODD:
not x8, x0
li x7, 4095 #amount less than max 
sub x8,x8,x7 #max-4095 = max before overflow
bgeu x6, x8, toobig #check if amount will overflow when 4095 is added
add x6, x6, x7 #add 4095
srli x6, x6, 1 #shfit right by 1 to divide by 2
toobig: #break up the division so we wont overflow
srli x7,x7, 1 #4095//2
srli x6,x6, 1 #in//2
add x6,x6,x7 #in//2 + 4095//2 
end:
sw x6, 0x40(x5)
