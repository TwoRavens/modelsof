

clear
insheet using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\Evolving the Democratic Peace\globals-standard.csv"



gen demdemWarPercent = demdemwar / demmeetdem
gen demauthWarPercent = demauthwar / demmeetauth
gen authauthWarPercent = authauthwar / authmeetauth 
gen demWinPercent = demdefeatsauth / demauthwar 
gen totalWarPercent = (demdemwar + demauthwar + authauthwar) / (demmeetdem + demmeetauth + demauthwar) 
 
* produces summary stats for Table I 
sum demdemWarPercent
sum demauthWarPercent
sum authauthWarPercent
sum demWinPercent
sum totalWarPercent
 
 
clear  
insheet using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\Evolving the Democratic Peace\leaders-standard.csv" 


* produces sumary stats for Table II
sum acceptdem if democracy == 1
sum acceptauth if democracy == 1 
sum acceptdem if democracy == 0 
sum acceptauth if democracy == 0

sum conflictuse if democracy == 1
sum conflictuse if democracy == 0
ttest conflictuse, by(democracy) 

sum giveout if democracy == 1
sum giveout if democracy == 0 
 
sum publicgood if democracy == 1
sum publicgood if democracy == 0
 
 
 *** Varying demPercent ***
clear  
insheet using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\Evolving the Democratic Peace\globals-vary-dempercent.csv", delimiter(";")


gen demdemWarPercent = demdemwar / demmeetdem
gen demauthWarPercent = demauthwar / demmeetauth
gen authauthWarPercent = authauthwar / authmeetauth 
gen demWinPercent = demdefeatsauth / demauthwar 
 
gen totalMeet =  demmeetdem + demmeetauth + authmeetauth
gen totalWar = demdemwar + demauthwar + authauthwar
gen totalWarPercent = totalWar / totalMeet 
 
twoway fpfitci  demdemWarPercent percentdem
twoway fpfitci  demauthWarPercent percentdem
twoway fpfitci  authauthWarPercent percentdem
twoway fpfitci  totalWarPercent percentdem
twoway fpfitci  demWinPercent percentdem

* produces Figure 2
set scheme s1mono 
twoway fpfitci  demdemWarPercent percentdem, clcolor(black)  clpattern(longdash) fintensity(inten50) || fpfitci  demauthWarPercent percentdem, clcolor(black) clpattern(dash) fintensity(inten50) || fpfitci  authauthWarPercent percentdem, clcolor(black) clpattern(dot) fintensity(inten50) ||  fpfitci  totalWarPercent percentdem, clcolor(black) fintensity(inten50) ylabel(0 .20 .40 .60 .80 1.00) xlabel(0 .20 .40 .60 .80 1.00) legend(off)   xtitle(Proportion of Democracies) ytitle(Proportion of Wars) 

clear 
 insheet using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\Evolving the Democratic Peace\leaders-vary-dempercent.csv"


twoway fpfitci acceptdem percentdem if democracy == 1
twoway fpfitci acceptdem percentdem if democracy == 0

twoway fpfitci acceptauth percentdem if democracy == 1
twoway fpfitci acceptauth percentdem if democracy == 0

twoway fpfitci conflictuse percentdem if democracy == 1
twoway fpfitci conflictuse percentdem if democracy == 0
 
 
 
*** Varying Prize *** 
 
clear 
insheet using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\Evolving the Democratic Peace\globals-vary-prize.csv", delimiter(";")

gen demdemWarPercent = demdemwar / demmeetdem
gen demauthWarPercent = demauthwar / demmeetauth
gen authauthWarPercent = authauthwar / authmeetauth 
gen demWinPercent = demdefeatsauth / demauthwar 
 
gen totalMeet =  demmeetdem + demmeetauth + authmeetauth
gen totalWar = demdemwar + demauthwar + authauthwar
gen totalWarPercent = totalWar / totalMeet 
 
twoway fpfitci  demdemWarPercent prize
twoway fpfitci  demauthWarPercent prize
twoway fpfitci  authauthWarPercent prize
twoway fpfitci  totalWarPercent prize
twoway fpfitci  demWinPercent prize
 
 * percentage of wars as the value of the prize increases
 * not in paper
twoway fpfitci  demdemWarPercent prize, clcolor(black)  clpattern(longdash) || fpfitci  demauthWarPercent prize, clcolor(black) clpattern(dash) || fpfitci  authauthWarPercent prize, clcolor(black) clpattern(dot) ||  fpfitci  totalWarPercent prize, clcolor(black)  ylabel(0 .20 .40 .60 .80 1.00) xlabel(0 100 200 300 400 500) legend(off)   xtitle(Percentage of Democracies) ytitle(Percentage of Wars) 
 
 
 clear 
insheet using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\Evolving the Democratic Peace\leaders-vary-prize.csv"

 
twoway fpfitci acceptdem prize if democracy == 1
twoway fpfitci acceptdem prize if democracy == 0

twoway fpfitci acceptauth prize if democracy == 1
twoway fpfitci acceptauth prize if democracy == 0

twoway fpfitci conflictuse prize if democracy == 1
twoway fpfitci conflictuse prize if democracy == 0

* I do this to prevent every data point from being create along the
* Nash Equilibrium. Otherwise plotting takes too long 
gen random = uniform() 
gen nash = .
replace nash = prize * .25 if random < .01 

* Produces Figure 1
twoway fpfitci conflictuse prize if democracy == 1 & prize > 10, clcolor(black)  clpattern(dash) ||  fpfitci conflictuse prize if democracy == 0, clcolor(black) clpattern(dot)  || line nash prize, clcolor(black) ylabel(0 50 100 150 200 250) xlabel(0 100 200 300 400 500) legend(off)   xtitle(Prize) ytitle(Conflict Use) 


*** Varying PG Multiplier ****
clear
insheet using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\Evolving the Democratic Peace\globals-vary-pgMultiplier.csv", delimiter(";")

gen demdemWarPercent = demdemwar / demmeetdem
gen demauthWarPercent = demauthwar / demmeetauth
gen authauthWarPercent = authauthwar / authmeetauth 
gen demWinPercent = demdefeatsauth / demauthwar 
 
gen totalMeet =  demmeetdem + demmeetauth + authmeetauth
gen totalWar = demdemwar + demauthwar + authauthwar
gen totalWarPercent = totalWar / totalMeet 
 
twoway fpfitci  demdemWarPercent pgmultiplier
twoway fpfitci  demauthWarPercent pgmultiplier
twoway fpfitci  authauthWarPercent pgmultiplier
twoway fpfitci  totalWarPercent pgmultiplier
twoway fpfitci  demWinPercent pgmultiplier

* produces Figure 2 in the appendix
twoway fpfitci  demdemWarPercent pgmultiplier, clcolor(black)  clpattern(longdash) fintensity(inten50) || fpfitci  demauthWarPercent pgmultiplier, clcolor(black) clpattern(dash) fintensity(inten50) || fpfitci  authauthWarPercent pgmultiplier if pgmultiplier < 3.8, clcolor(black) clpattern(dot) fintensity(inten50) ||  fpfitci  totalWarPercent pgmultiplier, clcolor(black) fintensity(inten50) ylabel(0 .20 .40 .60 .80 1.00) xlabel(2 3 4 5) legend(off)   xtitle(PG Multipler) ytitle(Percentage of Wars) 


clear
insheet using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\Evolving the Democratic Peace\leaders-vary-pgMultiplier.csv"

gen random = uniform() 
gen nash = .
replace nash = prize * .25 if random < .001 

* produces Figure 3 in the appendix
twoway fpfitci conflictuse pgmultiplier if democracy == 1, clcolor(black)  clpattern(dash) ||  fpfitci conflictuse pgmultiplier if democracy == 0, clcolor(black) clpattern(dot) || line nash pgmultiplier, clcolor(black) ylabel(0 50 100 125 150) xlabel(2 3 4 5) legend(off)   xtitle(PG Multipler) ytitle(Conflict Use) 

* Produces Figure 1 in the appendix
twoway fpfitci publicgood pgmultiplier if democracy == 0,  clcolor(black) ylabel(0 .2 .4 .6 .8 1) xlabel(2 3 4 5) legend(off)   xtitle(PG Multipler) ytitle(Percent of Autocracies Using Public Goods) 
