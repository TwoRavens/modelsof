* Cirone, Alexandra and Van Coppenolle, Brenda
* ‘Cabinets, Committees and Careers: The Causal Effect of Committee Service'
* The Journal of Politics

* Dofile 2/3 (online appendix)



use "committee_CCC.dta", clear

xi: gen i.year



/* Online appendix */
*******************************

* Table 1: Summary Statistics

sum F1to5billdummy F1to5billbudgetdummy F1to5billecondummy F1to5billagendadummy F1to5billwelfaredummy F1to5billfinancedummy 
sum min leader senate reelect reelecttwoterm rannext
sum cummyears age permargin inscrits proprietaire lib_all civil paris 

sum F1to5billdummy F1to5billbudgetdummy F1to5billecondummy F1to5billagendadummy F1to5billwelfaredummy F1to5billfinancedummy if budget==1 
sum min leader senate reelect reelecttwoterm rannext if budget==1
sum cummyears age permargin inscrits proprietaire lib_all civil paris if budget==1
tab budget,m


* Table 2: see budget_incumbency_CCC.do 
 

* Table 3: Budget Committee and Future Bill Sponsorship

ivreg2 F1to5billdummy budget _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5billdummy budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5billdummy budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) fe partial(_I*)
ivreg2 F1to5billdummy (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5billdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5billdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Table 4: Balance of Characteristics Across Bureaux

local i=1
while `i'<=11 {
gen bureau`i'=(bureau==`i')
local ++i
}
ivreg2 age bureau2 bureau3 bureau4 bureau5 bureau6 bureau7 bureau8 bureau9 bureau10 bureau11 _I*, cluster(id clburyear) partial(_I*) 
foreach var of varlist permargin inscrits proprietaire lib_all civil paris cummyears budgetincumbent budgetexptermyears {
ivreg2 `var' bureau2 bureau3 bureau4 bureau5 bureau6 bureau7 bureau8 bureau9 bureau10 bureau11 _I*, cluster(id clburyear) partial(_I*) 
}


* Table 5: Pretreatment Covariates and Instrument

ivreg2 age bureauotherbudgetincumbent _I*, cluster(id clburyear) partial(_I*) 
foreach var of varlist permargin inscrits proprietaire lib_all civil paris cummyears budgetincumbent budgetexptermyears {
ivreg2 `var' bureauotherbudgetincumbent _I*, cluster(id clburyear) partial(_I*) 
}


* Table 6 Full First Stage

ivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*) first 
ivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) first 
xtivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe first


* Table 7: Budget Committee and Future Ministerial Position

ivreg2 F1to5firstminyear budget _I*, cluster(id clburyear) partial(_I*) 
ivreg2 F1to5firstminyear budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5firstminyear budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe
ivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I* , cluster(id clburyear) partial(_I*) 
ivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Table 8: Budget Committee and Future Party Leadership

ivreg2 F1to5firstleaderyear budget _I*, cluster(id clburyear) partial(_I*) 
ivreg2 F1to5firstleaderyear budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5firstleaderyear budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe
ivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I* , cluster(id clburyear) partial(_I*) 
ivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Table 9: Budget Committee and Future Senate Post

ivreg2 F1to5senateyear budget _I*, cluster(id clburyear) partial(_I*) 
ivreg2 F1to5senateyear budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5senateyear budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe
ivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I* , cluster(id clburyear) partial(_I*) 
ivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Table 10: Future Budget Bill Sponsorship, Controlling for Partisanship

ivreg2 F1to5billbudgetdummy budget _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5billbudgetdummy budget _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5billbudgetdummy budget _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) fe partial(_I*)
ivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Table 11: Future Ministerial Position, Controlling for Partisanship

ivreg2 F1to5firstminyear budget _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5firstminyear budget _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5firstminyear budget _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) fe partial(_I*)
ivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Table 12: Future Party Leadership, Controlling for Partisanship

ivreg2 F1to5firstleaderyear budget _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5firstleaderyear budget _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5firstleaderyear budget _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) fe partial(_I*)
ivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Table 13: Future Senate Post, Controlling for Partisanship

ivreg2 F1to5senateyear budget _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5senateyear budget _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5senateyear budget _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) fe partial(_I*)
ivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Table 14: Reelection, within the Next Two Terms, Controlling for Partisanship

xi: gen i.term
preserve
sort id term termyear
bysort id term: egen lastty=max(termyear)
gen keeptag=(termyear==lastty)
keep if keeptag==1
tab rannext,m

ivreg2 reelectterm (budget = bureauotherbudgetincumbent) _I* if rannext==1, cluster(id clburyear) first partial(_I*)
ivreg2 reelectterm (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris if rannext==1, cluster(id clburyear) first partial(_I*)
ivreg2 reelecttwoterm (budget = bureauotherbudgetincumbent) _I* if rannext==1, cluster(id clburyear) first partial(_I*)
ivreg2 reelecttwoterm (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris if rannext==1, cluster(id clburyear) first partial(_I*)
ivreg2 rannext (budget = bureauotherbudgetincumbent) _I* , cluster(id clburyear) first partial(_I*)
ivreg2 rannext (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 centrist_all age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris , cluster(id clburyear) first partial(_I*)
restore


* Figure 2: Budget Incumbency and Budget Committee Selection 

xi: gen i.year

bysort termyear bureau: egen meanbudget_t=mean(budget) if budgetincumbent==0
bysort termyear bureau: egen meanbudget_inc_t=mean(budget) if budgetincumbent==1
twoway (scatter meanbudget_t bureauotherbudgetincumbent if budgetincumbent==0, msymbol(circle)) (fpfit budget bureauotherbudgetincumbent if budgetincumbent==0, fcolor(none) msymbol(circle)) , scheme(s1mono) xlabel(0(1)8) ytitle("Budget committee selection" ) legend(order(1 "Proportion selected, non-incumbents" 2 "Predicted selection, non-incumbents") cols(1))
twoway (scatter meanbudget_inc_t bureauotherbudgetincumbent if budgetincumbent==1, msymbol(triangle)) (fpfit budget bureauotherbudgetincumbent if budgetincumbent==1, fcolor(none) msymbol(triangle)), scheme(s1mono) xlabel(0(1)8) ytitle("Budget committee selection" ) legend(order(1 "Proportion selected, budget incumbents" 2 "Predicted selection, incumbents") cols(1))


* Table 15: Budget Committee and Future Budget Bill Sponsorship

* Budget incumbency
gen bo=budgetincumbent *bureauotherbudgetincumbent
gen budget_inc=budget*budgetincumbent
* Budget experience
gen be=(budgetexptermyears>0)*bureauotherbudgetincumbent
gen budget_exp=budget*(budgetexptermyears>0)
gen budgetexperienced=(budgetexptermyears>0)

ivreg2 F1to5billbudgetdummy (budget budget_inc = bureauotherbudgetincumbent bo) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) first
xtivreg2 F1to5billbudgetdummy (budget budget_inc = bureauotherbudgetincumbent bo) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe first
ivreg2 F1to5billbudgetdummy (budget budget_exp = bureauotherbudgetincumbent be) _I* budgetexperienced cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) first
xtivreg2 F1to5billbudgetdummy (budget budget_exp = bureauotherbudgetincumbent be) _I* budgetexperienced cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe first


*Table 16: Budget Committee and Future Ministerial Position

ivreg2 F1to5firstminyear (budget budget_inc = bureauotherbudgetincumbent bo) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) first
xtivreg2 F1to5firstminyear (budget budget_inc = bureauotherbudgetincumbent bo) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe first
ivreg2 F1to5firstminyear (budget budget_exp = bureauotherbudgetincumbent be) _I* budgetexperienced cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) first
xtivreg2 F1to5firstminyear (budget budget_exp = bureauotherbudgetincumbent be) _I* budgetexperienced cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe first


* Table 17: Budget Committee and Parisian Deputies

gen po=paris*bureauotherbudgetincumbent
gen budget_paris=budget*paris

ivreg2 F1to5billbudgetdummy (budget budget_paris = bureauotherbudgetincumbent po) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) first
xtivreg2 F1to5billbudgetdummy (budget budget_paris = bureauotherbudgetincumbent po) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe first
ivreg2 F1to5firstminyear (budget budget_paris = bureauotherbudgetincumbent po) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) first
xtivreg2 F1to5firstminyear (budget budget_paris = bureauotherbudgetincumbent po) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe first
