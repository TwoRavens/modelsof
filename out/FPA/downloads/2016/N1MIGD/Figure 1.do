clear
clear matrix
set mem 300m

set obs 1
generate var1 = 1 in 1
set obs 2
replace var1 = 1 in 2
set obs 3
replace var1 = 1 in 3
set obs 4
replace var1 = 2 in 4
set obs 5
replace var1 = 2 in 5
set obs 6
replace var1 = 2 in 6
set obs 7
replace var1 = 3 in 7
set obs 8
replace var1 = 3 in 8
set obs 9
replace var1 = 3 in 9
set obs 10
replace var1 = 4 in 10
set obs 11
replace var1 = 4 in 11
set obs 12
replace var1 = 4 in 12
set obs 13
replace var1 = 5 in 13
set obs 14
replace var1 = 5 in 14
set obs 15
replace var1 = 5 in 15
rename var1 model

label define model 1 "Pooled" 2 "Fixed Imp. & Exp. Effects" 3 "Dyad Fixed Effects" 4 "Dyad Random Effects" 5 "BMA Results"
label values model model

generate var2 = 1 in 1
replace var2 =7  in 2
replace var2 = 13 in 3
replace var2 = 2 in 4
replace var2 = 8 in 5
replace var2 = 14 in 6
replace var2 = 3 in 7
replace var2 = 9 in 8
replace var2 = 15 in 9
replace var2 = 4 in 10
replace var2 = 10  in 11
replace var2 = 16 in 12
replace var2 = 5 in 13
replace var2 = 11 in 14
replace var2 = 17 in 15
rename var2 variable_tags

*Pooled Alliance
generate var3 = -8 in 1 
*Pooled Diplomacy
replace var3 = -16 in 2
*Pooled Joint Diplomacy
replace var3 = -26 in 3
*exp/imp Alliance
replace var3 = -20 in 4
*exp/imp Diplomacy
replace var3 = -17 in 5
*exp/imp Joint Diplomacy
replace var3 = -21 in 6
*dyad alliance
replace var3 = -8 in 7
*dyad diplomacy
replace var3 = -11 in 8
*dyad joint diplomacy
replace var3 = -17 in 9
*re-alliance
replace var3 = -12 in 10
*re diplomacy
replace var3 = -16 in 11
*re joint diplomacy
replace var3 = -28 in 12
*BMA alliance
replace var3 = -12 in 13
*BMA Diplomacy
replace var3 = -14 in 14
*BMA joint diplomacy
replace var3 = -21 in 15
rename var3 mean_effect

generate var4 = -2 in 1
replace var4 = -10 in 2
replace var4 = -16 in 3
replace var4 = -11 in 4
replace var4 = -11 in 5
replace var4 = -9 in 6
replace var4 = -3 in 7
replace var4 = -6 in 8
replace var4 = -8 in 9
replace var4 = -1 in 10
replace var4 = -8 in 11
replace var4 = -11 in 12
replace var4 = 0.3 in 13
replace var4 = -6 in 14
replace var4 = -6 in 15
rename var4 high_ci

generate var5 = -15 in 1
replace var5 = -21 in 2
replace var5 = -36 in 3
replace var5 = -29 in 4
replace var5 = -24 in 5
replace var5 = -35 in 6
replace var5 = -13 in 7
replace var5 = -15 in 8
replace var5 = -26 in 9
replace var5 = -22 in 10
replace var5 = -24 in 11
replace var5 = -43 in 12
replace var5 = -24 in 13
replace var5 = -21 in 14
replace var5 = -36 in 15
rename var5 low_ci


twoway (bar mean_effect variable_tags if model==1) ///
       (bar mean_effect variable_tags if model==2) ///
       (bar mean_effect variable_tags if model==3) ///
       (bar mean_effect variable_tags if model==4) ///
	   (bar mean_effect variable_tags if model==5) ///
       (rcap high_ci low_ci variable_tags), ///
       legend(order(1 "Pooled" 2 "Exp./Imp. FE" 3 "Dyad FE" 4 "Dyad RE" 5 "BMA")  size(small) ) ///
	   xlabel( 2.5 "Alliance" 8.5 "Exporter Diplomacy" 14.5 "Both Diplomacy", noticks) ///
	   ylabel( 0 "0%" -10 "-10%" -20 "-20%" -30 "-30%" -40 "-40%") ///
       xtitle("") ytitle("Percentage Change in Export Volatility") 


