u admit, clear
ren tsa aptitude_test
cumul apt if male==1 & indep==1, gen(male_indep) equal
cumul apt if male==1 & indep==0, gen(male_state) equal
cumul apt if (1-male)*indep==1, gen(female_indep) equal
cumul apt if (1-male)*(1-indep)==1, gen(female_state) equal

stack male_indep apt male_state apt female_indep apt female_state apt, into (CDF Aptitude_Test) wide clear
line male_indep male_state female_indep female_state Apt if Apt<85 & Apt>45, sort  lpattern(longdash solid dash dash_dot) saving(g1.gph, replace)

clear
u admit, clear
reg col1av tsaoverall gcsescore male indep
predict Int, xb

cumul Int if male==1 & indep==1, gen(male_indep) equal
cumul Int if male==1 & indep==0, gen(male_state) equal
cumul Int if (1-male)*indep==1, gen(female_indep) equal
cumul Int if (1-male)*(1-indep)==1, gen(female_state) equal

stack male_indep Int male_state Int female_indep Int female_state Int, into (CDF Predicted_Interview) wide clear
line male_indep male_state female_indep female_state Predicted_Interview, sort  lpattern(longdash solid dash dash_dot) saving(g2.gph, replace)



u admit, clear
gen twone=(prelim>192)

probit twone col1av tsaoverall gcsescore male indep
keep if prelim~=.
predict Int, p

cumul Int if male==1 & indep==1, gen(male_indep) equal
cumul Int if male==1 & indep==0, gen(male_state) equal
cumul Int if (1-male)*indep==1, gen(female_indep) equal
cumul Int if (1-male)*(1-indep)==1, gen(female_state) equal

stack male_indep Int male_state Int female_indep Int female_state Int, into (CDF Two_one) wide clear
line male_indep male_state female_indep female_state Two_one, sort  lpattern(longdash solid dash dash_dot) saving(g3.gph, replace)



clear
use "C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\combined_2007_2008_with_finals_new_version.dta", clear
drop if year==2010
keep prelim tsaoverall male indep col1av gcsescore
replace prelim=prelim/3
keep if col1av~=.
reg prelim col1av tsaoverall gcsescore male indep
predict Int, xb

cumul Int if male==1 & indep==1, gen(male_indep) equal
cumul Int if male==1 & indep==0, gen(male_state) equal
cumul Int if (1-male)*indep==1, gen(female_indep) equal
cumul Int if (1-male)*(1-indep)==1, gen(female_state) equal

stack male_indep Int male_state Int female_indep Int female_state Int, into (CDF Predicted_Prelim) wide clear
line male_indep male_state female_indep female_state Predicted_Prelim, sort  lpattern(longdash solid dash dash_dot) saving(g2.gph, replace)

