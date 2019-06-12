** Replication Data for DeSante and Smith (JOP) "Less is More..." ** 

clear
use "anes16small.dta" 
 

gen Weight = V160101
tab V161310a
 
gen WhiteNH = 0
replace WhiteNH=1 if V161310x==1
*recode White (-10/0 = 0)
tab White

tab V162211
tab V162212
tab V162213
tab V162214
gen rr1 = 5-V162211 if V162211>0
tab rr1

gen rr2= V162212-1 if  V162212>0
gen rr3 = V162213-1 if  V162213>0
gen rr4 = 5-V162214 if V162214>0

sum rr1 rr2 rr3 rr4

gen addRR = (rr1+rr2+rr3+rr4)/16
gen age =   V161267
tab V161267
gen Mill = 0 if V161267>36
replace Mill= 1 if V161267<=36  
replace Mill=. if V161267<0
tab Mill
 

tab V161198
gen helpBlacks = V161198-1 if V161198>0 & V161198<99
tab helpBlacks

tab V162113
gen ftBLM = V162113 if V162113<=100 & V162113>=0
sum ftBLM
tab V162349
gen violWhite =  V162349-1 if V162349>0
gen violBlack = V162350-1 if V162350>0
 
gen violDif = violBlack-violWhite
 
 
***Table 3, Columns 1-3:
reg violDif  addRR if Mill==0 & White==1 [weight = Weight]
reg violDif  addRR if Mill==1 & White==1 [weight = Weight]
reg violDif  c.addRR##Mill  if White==1 [weight = Weight]

 
 

tab V162345 V162346
gen hwWhite = 7-V162345 if V162345>0
gen hwBlack = 7-V162346 if V162346>0
tab hwWhite hwBlack
sum hwWhite hwBlack
gen hwDif = hwW-hwB

***Table 4, Columns 1-3:
reg hwDif  addRR if Mill==0 & White==1 [weight = Weight]
reg hwDif  addRR if Mill==1 & White==1 [weight = Weight]
reg hwDif  c.addRR##Mill  if White==1 [weight = Weight]

 
 
gen discWhite = 5-V162360 if V162360>0
gen discBlack = 5-V162357 if V162357>0  
gen sysRacism = discBlack-discWhite
 
 ***Table 5, Columns 1-3:
reg helpBlacks  c.addRR##Mill  if White==1 [weight = Weight]
reg sysRacism   c.addRR##Mill  if White==1 [weight = Weight]
reg ftBLM       c.addRR##Mill  if White==1 [weight = Weight]

**** 

 

