clear
u admit.dta, clear

gen Int=prelims
cumul Int if male==1, gen(Male) equal
cumul Int if male==0, gen(Female) equal
stack Male Int Female Int, into (CDF Prelim_Score) wide clear
line Male Female  Prelim_Score, sort  lpattern(longdash solid dash dash_dot) xlabel(50(5)75) saving("C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\ReStat\Revision\gr2.gph", replace)


clear
u admit, clear
gen Int=finals

drop if Int<50

cumul Int if male==1, gen(Male) equal
cumul Int if male==0, gen(Female) equal
stack Male Int Female Int, into (CDF Finals_Score) wide clear
line Male Female  Finals_Score, sort  lpattern(longdash solid dash dash_dot) xlabel(50(5)75) saving("C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\ReStat\Revision\gr3.gph", replace)
graph combine "C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\ReStat\Revision\gr2.gph" "C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\ReStat\Revision\gr3.gph"


*------------------------------------------------
clear
u admit.dta, clear
replace prelim=prelim/3
keep if col1av~=.
reg prelim col1av tsaoverall gcsescore male indep
predict Int, xb


cumul Int if male==1 & indep==1, gen(male_indep) equal
cumul Int if male==1 & indep==0, gen(male_state) equal
cumul Int if (1-male)*indep==1, gen(female_indep) equal
cumul Int if (1-male)*(1-indep)==1, gen(female_state) equal

stack male_indep Int male_state Int female_indep Int female_state Int, into (CDF Prelim_Score) wide clear
line male_indep male_state female_indep female_state Prelim_Score, sort  lpattern(longdash solid dash dash_dot) xlabel(50(5)75) saving("C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\ReStat\Revision\gr4.gph", replace)


clear
u admit, clear
reg finals col1av tsaoverall gcsescore male indep
predict Int, xb


cumul Int if male==1 & indep==1, gen(male_indep) equal
cumul Int if male==1 & indep==0, gen(male_state) equal
cumul Int if (1-male)*indep==1, gen(female_indep) equal
cumul Int if (1-male)*(1-indep)==1, gen(female_state) equal

stack male_indep Int male_state Int female_indep Int female_state Int, into (CDF Final_Score) wide clear
line male_indep male_state female_indep female_state Final_Score, sort  lpattern(longdash solid dash dash_dot) xlabel(50(5)75) saving("C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\ReStat\Revision\gr5.gph", replace)
graph combine "C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\ReStat\Revision\gr4.gph" "C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\ReStat\Revision\gr5.gph"
