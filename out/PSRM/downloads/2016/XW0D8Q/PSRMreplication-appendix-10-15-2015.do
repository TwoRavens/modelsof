** Set working directory
log using "psrm rep appendix.txt", text replace
version 11
set linesize 80
set more off


use "MRR_budgets.dta",clear


tsset fips year

bysort fips :gen govbudg_lastbudg=govbudg/l.actbudg
bysort fips :gen actbudg_lastbudg=actbudg/l.actbudg

order govbudg_lastbudg actbudg_lastbudg actbudg govbudg pc_diff

gen success=abs(govbudg_lastbudg-actbudg_lastbudg)

/* Same */
order success cwhl_
corr success cwhl_

replace success=success*100


*Table A.1 -- with the new "success" variable and controlling for population

reg success l.success pop_million supermajority divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
reg success l.success pop_million supermajority2 divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if state!="Alaska" & state!="Nebraska" & state!="Maryland" & state!="Wyoming",cl(govname)
reg success l.success pop_million supermajority divided_gov house_copart legprof_  ln_govbudg   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_  termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year if state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)

*govbudg=governor's budget
gen kbudget=0
replace kbudget=1 if govbudg<=actbudg
replace kbudget=0 if kbudg==.

reg success l.success pop_million supermajority divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
reg success l.success pop_million supermajority2 divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Maryland" & state!="Wyoming",cl(govname)
reg success l.success pop_million supermajority divided_gov house_copart legprof_  ln_govbudg   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_  termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)


*Table A.2 -- with the new "success" variable defined based on final budget size and controlling for population

gen budgetsize=abs( govbudg- actbudg)/actbudg 
replace budgetsize=budgetsize*100

reg budgetsize l.budgetsize pop_million supermajority divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
reg budgetsize l.budgetsize pop_million supermajority2 divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if state!="Alaska" & state!="Nebraska" & state!="Maryland" & state!="Wyoming",cl(govname)
reg budgetsize l.budgetsize pop_million supermajority divided_gov house_copart legprof_  ln_govbudg   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_  termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year if state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)


reg budgetsize l.budgetsize pop_million supermajority divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
reg budgetsize l.budgetsize pop_million supermajority2 divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Maryland" & state!="Wyoming",cl(govname)
reg budgetsize l.budgetsize pop_million supermajority divided_gov house_copart legprof_  ln_govbudg   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_  termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)

