** Set working directory
log using "psrm rep.txt", text replace
version 11
set linesize 80
set more off
use "MRR_budgets.dta",clear


tsset fips year


*Table 1
reg pc_diff l.pc_diff supermajority divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
reg pc_diff l.pc_diff supermajority2 divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if state!="Alaska" & state!="Nebraska" & state!="Maryland" & state!="Wyoming",cl(govname)
reg pc_diff l.pc_diff supermajority divided_gov house_copart legprof_  ln_govbudg   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_ termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year if state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)

*govbudg=governor's budget
gen kbudget=0
replace kbudget=1 if govbudg<=actbudg

reg pc_diff l.pc_diff supermajority divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
reg pc_diff l.pc_diff supermajority2 divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Maryland" & state!="Wyoming",cl(govname)
reg pc_diff l.pc_diff supermajority divided_gov house_copart legprof_  ln_govbudg   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_ termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)


*Table 2
reg pc_diff l.pc_diff i.override divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
test 60.override=67.override

reg pc_diff l.pc_diff i.override divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if state!="Alaska" & state!="Nebraska" & state!="Maryland" & state!="Wyoming",cl(govname)
test 60.override=67.override

reg pc_diff l.pc_diff i.override divided_gov house_copart legprof_  ln_govbudg   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_  ///
termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year if state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
test 60.override=67.override

*gov's request less than budget 
reg pc_diff l.pc_diff i.override divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
test 60.override=67.override

reg pc_diff l.pc_diff i.override divided_gov  house_copart legprof_  ln_govbudg   gsp_pc item ln_unemp i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Maryland" & state!="Wyoming",cl(govname)
test 60.override=67.override

reg pc_diff l.pc_diff i.override divided_gov house_copart legprof_  ln_govbudg   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_  termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year if kbudget==1 & state!="Alaska" & state!="Nebraska" & state!="Hawaii" & state!="Connecticut"  & state!="Illinois" & state!="Maine" & state!="Mississippi" & state!="Maryland"  & state!="Wyoming" & state!="California" & state!="Arkansas" & state!="Rhode Island",cl(govname)
test 60.override=67.override



drop first_term
gen first_term=0 if years_served>4
replace first_term=1 if years_served<5

gen log_pop=log(pop)
tsset fips year

gen drop=0
replace drop=1 if state=="Alaska"
replace drop=1 if state=="Nebraska"
replace drop=1 if state=="Hawaii"
replace drop=1 if state=="Connecticut"
replace drop=1 if state=="Illinois"
replace drop=1 if state=="Maine"
replace drop=1 if state=="Mississippi"
replace drop=1 if state=="Maryland"
replace drop=1 if state=="Wyoming"
replace drop=1 if state=="California"
replace drop=1 if state=="Arkansas"
replace drop=1 if state=="Rhode Island"


*Table 3
* First stage regressions reported in Table B.1
ivregress 2sls pc_diff l.pc_diff supermajority divided_gov  house_copart legprof_   gsp_pc item ln_unemp (ln_govbudg=log_pop first_term i.year_of_term ) i.year if drop==0,cl(govname) first
estat endogenous
estat firststage

ivregress 2sls pc_diff l.pc_diff supermajority2 divided_gov  house_copart legprof_  gsp_pc item ln_unemp (ln_govbudg=i.year_of_term first_term log_pop)    i.year if  state!="Alaska" & state!="Nebraska"& state!="Maryland" & state!="Wyoming", cl(govname) first
estat endogenous
estat firststage

ivregress 2sls pc_diff l.pc_diff supermajority divided_gov house_copart legprof_  (ln_govbudg=i.year_of_term first_term log_pop)   gsp_pc ln_unemp prep_ fed_ itemveto reorg_  red_budg_ termlimits_governor termlimits_house termlimits_senate tel initiatives  i.year  if drop==0, cl(govname) first
estat endogenous
estat firststage

log close
