li x5, 0x11000000 #load switch address
lhu x6, 0(x5) #load value from swtiches
neg x6,x6 #negate number (2 negatives make postive)
sh x6,0x20(x5) #store number in LEDs address
end: j end
