* Andrew Healy, Katrina Kosec, and Cecilia Hyunjung Mo
* March 31, 2017
* Replication File for American Political Science Review
* Final Data File: pakistan_tocqueville_replication_final.dta
* To find the complete dataset and codebook for the Pakistan Rural Household Panel Survey go to:
* Round 1
	* Dataset: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/28558
	* Codebook: https://dataverse.harvard.edu/file.xhtml?fileId=2531516&version=1.3
* Round 2
	* Dataset: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/LT631P
	* Codebook: http://www.ifpri.org/publication/users-guide-data-round-2-pakistan-rural-household-panel-survey-prhps-2013-0


*******************************************************************************************************************
**** OPEN DATA
*******************************************************************************************************************

************** MERGE IN ASPIRATION MEASURE
* Run "create_aspiration_variable_using_all_aspirations_data_2017_April.do" first to construct the aspiration level measure to merge in
use pakistan_tocqueville_replication_final.dta, clear
sort hid pid district 
merge 1:1 hid pid district using apsr_aspirations_construction_file.dta
keep if _merge == 3

*******************************************************************************************************************
**** REPLICATION CODE FOR MAIN RESULTS
*******************************************************************************************************************

************** GENERATE TREATMENT VARIABLES
gen group=.
replace group=1 if dmprimemobility==0 & dmprimepoverty==0
replace group=2 if dmprimemobility==1 & dmprimepoverty==0
replace group=3 if dmprimemobility==0 & dmprimepoverty==1
replace group=4 if dmprimemobility==1 & dmprimepoverty==1
label define group_label 1 "Neither" 2 "Mobility Only" 3 "Poverty Only" 4 "Both" 
label define mobilityprime 0 "None" 1 "Mobility Prime"
label define povertyprime 0 "None" 1 "Poverty Prime"
label values dmprimemobility mobilityprime
label values dmprimepoverty povertyprime
label values group group_label
tab group, gen(gr)

************** GENERATE CONTROLS
gen log_hhincome = log(A_1_4)
gen log_hhasset = log(total_all_assets)
gen socialstatus = A_3_1

gen trust=(B_8_1 + B_8_2 + B_8_3 + B_8_4 + B_8_5 + B_8_6 + B_8_7 + B_8_8 + B_8_9 + B_8_10 + B_8_11 + B_8_12)/12
label var trust "Trust score (uses all 12 questions)"

forvalues x=1/3 {
gen B_7_`x'_reverse=.
replace B_7_`x'_reverse=1 if B_7_`x'==2
replace B_7_`x'_reverse=2 if B_7_`x'==1
egen meanB_7_`x'_reverse=mean(B_7_`x'_reverse)
egen sdB_7_`x'_reverse=sd(B_7_`x'_reverse)
gen B_7_`x'_norm= (B_7_`x'_reverse - meanB_7_`x'_reverse)/ sdB_7_`x'_reverse
label var B_7_`x'_norm "Normalized version of B_7_`x' - mean 0, sd 1, larger = more rivalry/envy/competition"
}
gen envy= (B_7_1_reverse + B_7_2_reverse + B_7_3_reverse)/3
label var envy "Basic rivalry/envy/competition score (sum score (1-2) on 3 questions, higher= more envy)"

global control4 log_hhincome log_hhasset socialstatus dmprimary* dmmiddle* dmsecondary* dmtertiary* mom_yrseduc* dad_yrseduc* trust envy female Agedm* dmmarried* hhsize ethFE*
global control5 log_hhincome log_hhasset socialstatus dmprimary* dmmiddle* dmsecondary* dmtertiary* 
	
************** GENERATE OUTCOME VARIABLES
gen support_system = (s8p2_q15-1)/4
gen overall_satisfaction = (s8p3_q1-1)/6
gen community_satisfaction = (s8p3_q2-1)/6
gen security_satisfaction = (s8p3_q3-1)/6
alpha support_system overall_satisfaction community_satisfaction security_satisfaction, std item
gen govt_support_index = (support_system + overall_satisfaction + community_satisfaction + security_satisfaction)/4

************** TABLE 1: SUMMARY STATISTICS
set more off
gen intelligence = (s8p2_q7-1)/4
gen subj_wellbeing = B_9
replace subj_wellbeing = 5 if B_9 == .

global control gr1-gr4 aspirationlevel_rd1 trust envy log_hhincome log_hhasset socialstatus female Agedm* dmmarried* dmprimary* dmmiddle* dmsecondary* dmtertiary* mom_yrseduc* dad_yrseduc* hhsize ethFE*
su govt_support_index overall_satisfaction community_satisfaction security_satisfaction support_system $control intelligence subj_wellbeing 

************** TABLE 2: IMPACT OF MOBILITY AND RELATIVE POVERTY
set more off
xi: reg govt_support_index i.group, cluster(hid) robust
outreg2 using pakistan_output_table2.xls, se bdec(3) alpha(0.01,.05,.1) replace
xi: reg govt_support_index i.group i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_output_table2.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group aspirationlevel_rd1 $control4 i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_output_table2.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group aspirationlevel_rd1 $control4 i.MAUZA_ID, cluster(hid) robust
outreg2 using pakistan_output_table2.xls, se bdec(3) alpha(0.01,.05,.1) append

************** TABLE 3: IMPACT BY ASPIRATION LEVEL
set more off
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control5, cluster(hid) robust
outreg2 using pakistan_output_table3.xls, se bdec(3) alpha(0.01,.05,.1) replace
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control5 i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_output_table3.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control4 i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_output_table3.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control4 i.MAUZA_ID, cluster(hid) robust
outreg2 using pakistan_output_table3.xls, se bdec(3) alpha(0.01,.05,.1) append

***** FIGURE 1: EFFECT OF ASPIRATION LEVEL BY CONDITION
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control5, cluster(hid) robust
predict yhat
twoway (lfitci yhat aspirationlevel_rd1 if group == 1 , ciplot(rline)), legend(col(1) label(1 "95 Percent Confidence Interval") label(2 "Control Condition") size(vsmall) ) ytitle("Government Confidence Index", size(small)) xtitle("Aspiration Level", size(small)) ylabel(0(.1)0.7,labsize(vsmall) nogrid) xlab(, labsize(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion (fcolor(white))
twoway (lfitci yhat aspirationlevel_rd1 if group == 2 , ciplot(rline)), legend(col(1) label(1 "95 Percent Confidence Interval") label(2 "Mobility Prime") size(vsmall) ) ytitle("Government Confidence Index", size(small)) xtitle("Aspiration Level", size(small)) ylabel(0(.1)0.7,labsize(vsmall) nogrid) xlab(, labsize(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion (fcolor(white))
twoway (lfitci yhat aspirationlevel_rd1 if group == 3 , ciplot(rline)), legend(col(1) label(1 "95 Percent Confidence Interval") label(2 "Poverty Prime") size(vsmall) ) ytitle("Government Confidence Index", size(small)) xtitle("Aspiration Level", size(small)) ylabel(0(.1)0.7,labsize(vsmall) nogrid) xlab(, labsize(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion (fcolor(white))
twoway (lfitci yhat aspirationlevel_rd1 if group == 4 , ciplot(rline)), legend(col(1) label(1 "95 Percent Confidence Interval") label(2 "Poverty + Mobility Prime") size(vsmall) ) ytitle("Government Confidence Index", size(small)) xtitle("Aspiration Level", size(small)) ylabel(0(.1)0.7,labsize(vsmall) nogrid) xlab(, labsize(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion (fcolor(white))

***** FIGURE 2: INTERACTION EFFECT
set more off

mat results = J(5,3,0)
local a=1
foreach var of varlist govt_support_index overall_satisfaction community_satisfaction security_satisfaction support_system{ 
	eststo: quietly xi: reg `var' i.group*aspirationlevel_rd1 $control5 if e(sample)==1, cluster(hid) robust
	mat results[`a',1] = _b[_IgroXaspir_4]
	mat results[`a',2] = _se[_IgroXaspir_4]
	mat results[`a',3] = `a'
	local ++a
	}

mat2txt, matrix(results) saving(figinterac.txt) replace 
eststo clear
* Use Plots.R to create the figure


*******************************************************************************************************************
**** REPLICATION CODE FOR APPENDIX
*******************************************************************************************************************

************** FIGURE A.1: EFFECT OF POVERTY PRIME
mat results = J(5,3,0)
local a=1
foreach var of varlist govt_support_index overall_satisfaction community_satisfaction security_satisfaction support_system{ 
	eststo: quietly xi: reg `var' i.group if e(sample)==1, cluster(hid) robust
	mat results[`a',1] = _b[ _Igroup_3]
	mat results[`a',2] = _se[ _Igroup_3]
	mat results[`a',3] = `a'
	local ++a
	}

mat2txt, matrix(results) saving(figpov.txt) replace 
eststo clear
* Use Plots.R to create the figure

************** TABLE A.1: BALANCE TEST
set more off
global control aspirationlevel_rd1 log_hhincome log_hhasset socialstatus dmprimary* dmmiddle* dmsecondary* dmtertiary* mom_yrseduc* dad_yrseduc* trust envy female Agedm* dmmarried* hhsize ethFE*
orth_out $control using balancetest_tocqueville.csv, by(group) pcompare proportion test replace


************** TABLE A.2: IMPACT BY EACH GOVERNMENT CONFIDENCE MEASURE
set more off
foreach x of varlist govt_support_index overall_satisfaction community_satisfaction security_satisfaction support_system{ 
xi: reg `x' i.group, cluster(hid) robust
outreg2 using pakistan_tablea2.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg `x' i.group*aspirationlevel_rd1 $control5 if e(sample)==1, cluster(hid) robust
outreg2 using pakistan_tablea2.xls, se bdec(3) alpha(0.01,.05,.1) append
}

************** TABLE A.3: IMPACT CONDITIONING ON ECONOMIC SITUATION
set more off
gen dmimprovingecon=(s4p4a_q3==0|s4p4a_q3==1)
replace dmimprovingecon=. if s4p4a_q3==.
label var dmimprovingecon "Dummy - Economic condition has improved in the last 2 years"

xi: reg govt_support_index i.group dmimprovingecon, cluster(hid) robust
outreg2 using pakistan_tablea3.xls, se bdec(3) alpha(0.01,.05,.1) replace
xi: reg govt_support_index i.group dmimprovingecon i.DISTRICT_ID if e(sample)==1, cluster(hid) robust
outreg2 using pakistan_tablea3.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group dmimprovingecon aspirationlevel_rd1 $control4 i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_tablea3.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group dmimprovingecon aspirationlevel_rd1 $control4 i.MAUZA_ID, cluster(hid) robust
outreg2 using pakistan_tablea3.xls, se bdec(3) alpha(0.01,.05,.1) append

************** TABLE A.4: IMPACT BY ASPIRATION LEVEL CONDITIONING ON ECONOMIC SITUATION
set more off
xi: reg govt_support_index i.group*aspirationlevel_rd1 dmimprovingecon $control5, cluster(hid) robust
outreg2 using pakistan_tablea4.xls, se bdec(3) alpha(0.01,.05,.1) replace
xi: reg govt_support_index i.group*aspirationlevel_rd1 dmimprovingecon $control5 i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_tablea4.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 dmimprovingecon $control4 i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_tablea4.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 dmimprovingecon $control4 i.MAUZA_ID, cluster(hid) robust
outreg2 using pakistan_tablea4.xls, se bdec(3) alpha(0.01,.05,.1) append

************** TABLE A.5: IMPACT BY SUBJECTIVE WELL-BEING
set more off
xi: reg govt_support_index i.group if B_9<5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) replace
xi: reg govt_support_index i.group $control4 i.DISTRICT_ID if B_9<5 & e(sample) == 1, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group $control4 i.MAUZA_ID if B_9<5 & e(sample) == 1, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control5 if B_9<5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control4 i.DISTRICT_ID if B_9<5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control4 i.MAUZA_ID if B_9<5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append

xi: reg govt_support_index i.group if B_9>=5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group $control4 i.DISTRICT_ID if B_9>=5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group $control4 i.MAUZA_ID if B_9>=5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control5 if B_9>=5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control4 i.DISTRICT_ID if B_9>=5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append
xi: reg govt_support_index i.group*aspirationlevel_rd1 $control4 i.MAUZA_ID if B_9>=5, cluster(hid) robust
outreg2 using pakistan_output_tablea5.xls, se bdec(3) alpha(0.01,.05,.1) append

************** TABLE A.6: MOBILITY PRIME MANIPULATION CHECK
set more off
gen pov_asp = dmprimepoverty*aspirationlevel_rd1 
gen mob_asp = dmprimemobility*aspirationlevel_rd1 

reg intelligence dmprimemobility dmprimepoverty, cluster(hid) robust
outreg2 using pakistan_tablea6.xls, se bdec(3) alpha(0.01,.05,.1) replace
test dmprimemobility = dmprimepoverty
reg intelligence dmprimemobility dmprimepoverty i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_tablea6.xls, se bdec(3) alpha(0.01,.05,.1) append
test dmprimemobility = dmprimepoverty
reg intelligence dmprimemobility dmprimepoverty aspirationlevel_rd1 mob_asp pov_asp $control5, cluster(hid) robust
outreg2 using pakistan_tablea6.xls, se bdec(3) alpha(0.01,.05,.1) append
test dmprimemobility = dmprimepoverty
reg intelligence dmprimemobility dmprimepoverty aspirationlevel_rd1 mob_asp pov_asp $control5 i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_tablea6.xls, se bdec(3) alpha(0.01,.05,.1) append
test dmprimemobility = dmprimepoverty
reg intelligence dmprimemobility dmprimepoverty aspirationlevel_rd1 mob_asp pov_asp $control4 i.DISTRICT_ID, cluster(hid) robust
outreg2 using pakistan_tablea6.xls, se bdec(3) alpha(0.01,.05,.1) append
test dmprimemobility = dmprimepoverty
reg intelligence dmprimemobility dmprimepoverty aspirationlevel_rd1 mob_asp pov_asp $control4 i.MAUZA_ID, cluster(hid) robust
outreg2 using pakistan_tablea6.xls, se bdec(3) alpha(0.01,.05,.1) append
test dmprimemobility = dmprimepoverty

