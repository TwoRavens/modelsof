***Analyses reported in race/gender county chairs paper
set matsize 800
clear all

***Analysis of Relationship between Concentration of Minority Households and Primary Turnout (County Level)
*Organize and merge data sets
insheet using "public_data\national_county.csv", clear 
sort v2
drop if v2==v2[_n-1]
keep v1 v2
rename v1 state
rename v2 state_code
sort state
save "scratch_datasets\state_codes.dta", replace

import excel "public_data\hersh_primary_data.xlsx", sheet("Sheet1") firstrow clear
gen state=substr(st_county,1,2)
gen county=substr(st_county,3,5)
destring county, force replace

sort state
merge m:1 state using "scratch_datasets\state_codes.dta"
keep if _merge==3
drop _merge
gen fips=county+state_code*1000
drop if fips==.
sort fips
drop county
merge 1:1 fips using "public_data\county_demographics.dta"
keep if _merge==3
drop _merge

*Generate primary voter variables (%Black & %Hispanic, by party)
foreach i in b h{
foreach y in 08 10{
gen `i'_D_primary_`y'=(`i'_dem_`y'/dem_`y')*100 if dem_`y'!=0
gen `i'_R_primary_`y'=(`i'_rep_`y'/rep_`y')*100 if rep_`y'!=0
}
}
label var b_D_primary_08 "Democratic Primary Voters (% Black; 2008)"
label var b_D_primary_10 "Democratic Primary Voters (% Black; 2010)"
label var b_R_primary_08 "Republican Primary Voters (% Black; 2008)"
label var b_R_primary_10 "Republican Primary Voters (% Black; 2010)"
label var h_D_primary_08 "Democratic Primary Voters (% Hispanic; 2008)"
label var h_D_primary_10 "Democratic Primary Voters (% Hispanic; 2010)"
label var h_R_primary_08 "Republican Primary Voters (% Hispanic; 2008)"
label var h_R_primary_10 "Republican Primary Voters (% Hispanic; 2010)"

*Rename variables for analysis purposes
rename perc_black_hh perc_b_hh
rename perc_hisp_hh perc_h_hh

*Appendix Table A1
foreach p in D R{
foreach r in b h{
foreach y in 08 10{
qui sum `r'_`p'_primary_`y'
local mean=r(mean)
reg `r'_`p'_primary_`y' perc_`r'_hh, r
if "`y'"=="08" & "`p'"=="D" & "`r'"=="b"{
outreg using "tables\primary_turnout", se bracket tdec(3) replace label adec(2) addstat("Mean of Outcome Variable", `mean')
}
else{
outreg using "tables\primary_turnout", se bracket tdec(3) append label adec(2) addstat("Mean of Outcome Variable", `mean')
}
}
}
}


***************************************************************
****** ANALYSIS OF CONJOINT EXPERIMENT ************************
***************************************************************
//Set directory for storing figures/tables
cd "tables"
set more off
//open now-built dataset
use "..\dataset_for_analysis\replication_data_anon.dta", clear

***DETAILS ABOUT SAMPLE (NOTE: Collapsing on respondent to calculate/report)
preserve
collapse (mean) fips age female r_white r_black r_hispanic r_other educ income incomemis democrat hispanic woman youactivelyr youhelptoconnectcandidateswithdo candidatesforstateorlocalofficer candidatesforfederalofficereques youprovidestrategicadvicetocandi, by(responseid)
*summary stats - Appendix Table A3
outsum age female r_white r_black r_hispanic r_other educ income incomemis democrat using "A3_sumstats", replace bracket

*CANDIDATE involvement questions - reported in text
foreach i in youactivelyr youhelptoconnectcandidateswithdo candidatesforstateorlocalofficer candidatesforfederalofficereques youprovidestrategicadvicetocandi{
tab `i'
}

//check correlation between predicted/actual HISP, GENDER - reported in text of Appendix
tab female woman, col
tab r_hisp hispanic, col
tab r_hisp hispanic if female==0, col
tab r_hisp hispanic if female==1, col
restore

drop r_white 

*** COUNTY DEMOGRAPHICS CORRELATIONS (see FN X)
preserve
collapse (mean) perc_black_hh perc_hisp_hh fips, by(responseid)
sort fips
*drop one of two obs in cases with two chairs from same county to calculate county-level correlation 
drop if fips==fips[_n-1]
pwcorr perc_black_hh perc_hisp_hh, sig
restore

************************************************************
*******DIRECT MFX (Table A5 and B1; Figure 2)***************
************************************************************
//looping to run regressions for linear and indicator outcome and dump them out to separate files ("_linear" appended to name of sheets using linear outcome measure)
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic abortion_cong leave_cong guns_cong foodstamp_cong X* *np, cluster(responseid)
eststo pooled_mfx`suffix'
outreg cand_female cand_black cand_hispanic abortion_cong leave_cong guns_cong X_guns_2 foodstamp_cong X_foodstamp_2 X_experience_2 using "A5_primary_amce`suffix'", se bracket tdec(3) replace label 
test cand_black==cand_hispanic
lincom (abortion_cong +leave_cong +guns_cong +foodstamp_cong)/4
lincom 3*cand_black+((abortion_cong +leave_cong +guns_cong +foodstamp_cong)/4)
lincom 2*cand_black+X_experience_2
}
//plot the coefficients
coefplot (pooled_mfx,  msymbol(O) connect(none) mcolor(black) ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(All)) , keep(cand_female cand_black cand_hispanic X_experience_2 abortion_cong leave_cong guns_cong foodstamp_cong)  yline(0) legend(off) xlabel(-.2 -.1 0 .1 .2 .3 .4) level(95) xtitle("Effect on Probability of Selecting Candidate",  size(medsmall)) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) xline(0, lc(black) lw(thin) ) xscale(lw(none))  
graph save Graph "f2_baseline.gph", replace
graph export "f1_baseline.tif", as(tif) width(4000) replace

************************************************************
*******INTERSECTIONALITY ***********************************
************************************************************
gen male_black=cand_black 
replace male_black=0 if cand_female==1
gen male_hisp=cand_hisp
replace male_hisp=0 if cand_female==1
gen female_black=cand_female*cand_black 
gen female_hisp=cand_female*cand_hispanic
gen female_white=cand_female 
label var female_white "White Female Candidate"
label var female_black "Black Female Candidate"
label var female_hisp "Latina Candidate"
label var male_black "Black Male Candidate"
label var male_hisp "Latino Candidate"

replace female_white=0 if cand_black==1 | cand_hisp==1
foreach m in rel_eval choice {
reg `m' female_white male_black female_black male_hisp female_hisp abortion_cong leave_cong guns_cong foodstamp_cong X* *np, cluster(responseid)
}
reg choice female_white male_black female_black male_hisp female_hisp abortion_cong leave_cong guns_cong foodstamp_cong X* *np, cluster(responseid)
eststo intersection_fx

coefplot (intersection_fx,  msymbol(O) mlabcolor(black) connect(none) mcolor(black) ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(All )), keep(female_white male_black female_black male_hisp female_hisp )  yline(0) legend(off) xlabel(-.2 -.1 0 .1) level(95) xtitle("Effect on Probability of Selecting Candidate",  size(medsmall)) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) xline(0, lc(black) lw(thin) ) xscale(lw(none))  
graph export "A2_intersectionality.tif", as(tif) width(4000) replace

drop female_white male_black female_black male_hisp female_hisp 

************************************************************
*******ROBUSTNESS OF FX ************************************
************************************************************
****IF GIVEN TREATMENT PRESENTED/NOT PRESENTED ("x")********
forvalues x=0/1{
gen cases_`x'=.
gen var_condition_`x'=""
format var_condition_`x' %50s
foreach m in rel_eval choice {
*set counter to 0
local count=0
*generate variables to store estimates
foreach v in cand_black cand_hispanic {
gen est_`m'_`v'=.
}
foreach i of varlist condition* *_np proleave_exclude X_*{
local label : variable label `i'

local count=`count'+1
qui reg `m' cand_female cand_black cand_hispanic abortion_cong leave_cong guns_cong foodstamp_cong X* *np if `i'==`x', cluster(responseid)
count if e(sample)
local number_cases=r(N)
foreach v in cand_black cand_hispanic {
qui display "`i'" "`m'"
qui lincom `v'
replace est_`m'_`v'=r(estimate) in `count'
if "`m'"=="choice" & "`v'"=="cand_black"{
replace var_condition_`x'="`label'" in `count'
replace cases_`x'=`number_cases' in `count'
}
}
}
}
local ylab="-.3(.05).1"
local lbound=-.3
local wid=.01
if `x'==0{
local ylab="-.15(.05)0"
local lbound=-.15
local wid=.0025

}

foreach i in est_choice_cand_black est_choice_cand_hispanic{
local ytitle="Estimated Effect of Black Candidate"
if "`i'"!=subinstr("`i'","hispanic","",.){
local ytitle="Estimated Effect of Latinx Candidate"
}
sfrancia `i'
histogram `i', graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) xlabel(`ylab') xtitle("") title(`ytitle') width(`wid') start(`lbound') percent
graph export "A3_hist_`i'_`x'.tif", as(tif) replace width(4000) 
}
outsheet cases_`x' var_condition_`x' est_choice_cand_black est_choice_cand_hispanic using outliers_`x'.csv, comma replace
drop cases_`x' var_condition_`x'  est_rel_eval_cand_black est_rel_eval_cand_hispanic est_choice_cand_black est_choice_cand_hispanic
}


**INDIVIDUAL NAME FX
tab name_, gen(A_name_)
reg rel_eval cand_female cand_black cand_hispanic A_name_* abortion_cong leave_cong guns_cong foodstamp_cong X* *np, cluster(responseid)
*test all name indicators
test A_name_1 A_name_2 A_name_3 A_name_4 A_name_5 A_name_6 A_name_7 A_name_8 A_name_9 A_name_10 A_name_11 A_name_12 A_name_13 A_name_14 A_name_15 A_name_16 A_name_17 A_name_18 A_name_19 A_name_20 A_name_21 A_name_22 A_name_23 A_name_24 A_name_25 A_name_27 A_name_28 A_name_29 A_name_30 A_name_31 A_name_32 A_name_33 A_name_34 A_name_35 A_name_36 A_name_37 A_name_38 A_name_39 A_name_40 A_name_42 A_name_43 A_name_44 A_name_45 A_name_46 A_name_47 A_name_48 A_name_49 A_name_50 A_name_51 A_name_52 A_name_53 A_name_54 A_name_55 A_name_56 A_name_57 A_name_58 A_name_59 A_name_60 A_name_61 A_name_62 A_name_63 A_name_64 A_name_65 A_name_66 A_name_67 A_name_68 A_name_69 A_name_70 A_name_71 A_name_72 A_name_73 A_name_74 A_name_75 A_name_76 A_name_77 A_name_78 A_name_79 A_name_80 A_name_81 A_name_82 A_name_83 A_name_84 A_name_85 A_name_86 A_name_87 A_name_89 A_name_90 A_name_91 A_name_92 A_name_93 A_name_94 A_name_95 A_name_96 A_name_97 A_name_98 A_name_99 A_name_100 A_name_101 A_name_102 A_name_103 A_name_104 A_name_105 A_name_106 A_name_107 A_name_108 A_name_109 A_name_110 A_name_112 A_name_113 A_name_114 A_name_115 A_name_116 A_name_117 A_name_118 A_name_119 A_name_120 A_name_121 A_name_122 A_name_123
**male names
test A_name_4 A_name_11 A_name_12 A_name_15 A_name_16 A_name_26 A_name_27 A_name_29 A_name_30 A_name_31 A_name_32 A_name_33 A_name_34 A_name_35 A_name_36 A_name_42 A_name_46 A_name_47 A_name_48 A_name_49 A_name_52 A_name_53 A_name_54 A_name_55 A_name_58 A_name_60 A_name_61 A_name_63 A_name_64 A_name_65 A_name_68 A_name_69 A_name_72 A_name_74 A_name_75 A_name_76 A_name_77 A_name_78 A_name_79 A_name_87 A_name_88 A_name_91 A_name_92 A_name_93 A_name_94 A_name_101 A_name_102 A_name_104 A_name_106 A_name_111 A_name_113 A_name_115 A_name_116 A_name_117 A_name_118 A_name_119 A_name_120 A_name_121 A_name_122 A_name_123 A_name_110 A_name_112 A_name_114
**female names
test A_name_1 A_name_2 A_name_3 A_name_5 A_name_6 A_name_7 A_name_8 A_name_9 A_name_10 A_name_13 A_name_14 A_name_17 A_name_18 A_name_19 A_name_20 A_name_21 A_name_22 A_name_23 A_name_24 A_name_25 A_name_28 A_name_37 A_name_38 A_name_39 A_name_40 A_name_41 A_name_43 A_name_44 A_name_45 A_name_50 A_name_51 A_name_56 A_name_57 A_name_59 A_name_62 A_name_66 A_name_67 A_name_70 A_name_71 A_name_73 A_name_80 A_name_81 A_name_82 A_name_83 A_name_84 A_name_85 A_name_86 A_name_89 A_name_90 A_name_95 A_name_96 A_name_97 A_name_98 A_name_99 A_name_100 A_name_103 A_name_105 A_name_107 A_name_108 A_name_109
**white
test A_name_5 A_name_6 A_name_7 A_name_11 A_name_12 A_name_13 A_name_17 A_name_23 A_name_28 A_name_29 A_name_30 A_name_31 A_name_32 A_name_42 A_name_43 A_name_50 A_name_51 A_name_53 A_name_54 A_name_55 A_name_56 A_name_57 A_name_59 A_name_60 A_name_61 A_name_63 A_name_69 A_name_71 A_name_73 A_name_80 A_name_81 A_name_82 A_name_83 A_name_86 A_name_91 A_name_94 A_name_95 A_name_101 A_name_102 A_name_103 A_name_110 A_name_111 A_name_113 A_name_116 A_name_122
**black
test A_name_2 A_name_33 A_name_34 A_name_35 A_name_36 A_name_37 A_name_38 A_name_41 A_name_44 A_name_45 A_name_62 A_name_64 A_name_65 A_name_66 A_name_67 A_name_70 A_name_72 A_name_84 A_name_85 A_name_87 A_name_88 A_name_89 A_name_90 A_name_105 A_name_106 A_name_107 A_name_112 A_name_115 A_name_117 A_name_118 A_name_119 A_name_120 A_name_121 A_name_123
**latino
test A_name_4 A_name_8 A_name_9 A_name_10 A_name_14 A_name_15 A_name_16 A_name_18 A_name_19 A_name_20 A_name_21 A_name_22 A_name_24 A_name_25 A_name_26 A_name_27 A_name_39 A_name_40 A_name_46 A_name_47 A_name_48 A_name_49 A_name_52 A_name_58 A_name_68 A_name_74 A_name_75 A_name_76 A_name_77 A_name_78 A_name_79 A_name_92 A_name_93 A_name_96 A_name_97 A_name_98 A_name_99 A_name_100 A_name_104 A_name_108 A_name_109 A_name_114


********************************************************
**** NON-RACE FX DIFFERENT WHEN NO RACE / GENDER CUE? **
********************************************************
foreach i of varlist abortion_cong leave_cong guns_cong foodstamp_cong X*{
//gen both_minorityX`i'=both_minority*`i'
gen same_raceX`i'=same_race*`i'
//gen same_sexX`i'=same_sex*`i'
}

foreach i in same_race {
reg choice `i'* cand_female cand_black cand_hispanic abortion_cong leave_cong guns_cong foodstamp_cong X* *np if democrat==0, cluster(responseid)
test `i'Xabortion_cong `i'Xleave_cong `i'Xguns_cong `i'Xfoodstamp_cong `i'XX_foodstamp_2 `i'XX_guns_2 `i'XX_military_2 `i'XX_inarea_2 `i'XX_inarea_3 `i'XX_inarea_4 `i'XX_inarea_5 `i'XX_inarea_6 `i'XX_inarea_7 `i'XX_inarea_8 `i'XX_inarea_9 `i'XX_inarea_10 `i'XX_inarea_11 `i'XX_inarea_12 `i'XX_inarea_13 `i'XX_inarea_14 `i'XX_children_2 `i'XX_children_3 `i'XX_children_4 `i'XX_children_5 `i'XX_marital_2 `i'XX_marital_3 `i'XX_marital_4 `i'XX_occupation_2 `i'XX_occupation_3 `i'XX_occupation_4 `i'XX_occupation_5 `i'XX_occupation_6 `i'XX_occupation_7 `i'XX_occupation_8 `i'XX_compromise_2 `i'XX_experience_2 
drop `i'X*
}

*************************************************************
*******MASKING **********************************************
*************************************************************
********issue cue mask? First generate indicators for "presence of cue"
recode compromise_np (1=0) (0=1),gen(assign_compromise)
recode no_issue (1=0) (0=1),gen(assign_issue)
gen assign_none=no_issue&compromise_np
label var assign_compromise "Compromise Presented (1=yes)"
label var assign_issue "Issue Position Presented (1=yes)"
label var assign_none "No Policy Cue Presented (1=yes)"

foreach i in cand_female cand_black cand_hispanic{
gen assign_compromiseX`i'=assign_compromise*`i'
gen assign_issueX`i'=assign_issue*`i'
gen assign_noneX`i'=assign_none*`i'
local label : variable label `i'
label var assign_compromiseX`i' "Compromise Presented x `label'"
label var assign_issueX`i' "Issue Position Presented x `label'"
label var assign_noneX`i' "No Policy/Compromise Cues x `label'"
}

************************************
*****NOTE: FOR THIS MASKING AND CHAIR CHARACTERISTIC MODERATION ANALYSES, THIS CODE RUNS THE REGRESSION ONCE, OUTREGS IT, AND SAVES THE ESTIMATES. 
*****IT THEN RERUNS THE MODEL SWAPPING OUT WHICH MODERATOR INDICATOR IS THE REFERENCE CATEGORY. THUS, THE COEFFICIENT ON THE COMPONENT INDICATOR
*****E.G., "BLACK NAME" CAN BE INTERPRETED AS EFFECT AMONG CASES IN EXCLUDED CATEGORY. CODE THEN STORES THOSE CANDIDATE CHARACTERISTIC COEFFICIENT FX TO PLOT.
************************************
***POSITIONING: NO CUE
//NOTE: because "issue position presented" and "compomise cue presented" indicators necessitate dropping the issue position not presented indicators, as well as one additional NP indicator (to serve as reference category)
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic assign_compromise* assign_issue* X* *cong experience_np occupation_np marital_np children_np inarea_np, cluster(responseid)
test assign_compromiseXcand_black assign_compromiseXcand_hispanic assign_issueXcand_black assign_issueXcand_hispanic
outreg cand_female cand_black cand_hispanic assign_compromise* assign_issue* using "A6_masking`suffix'", se bracket tdec(3) adec(3) replace label addstat("Joint Significance of Race/Ethnicity Interactions (p-value)",r(p))
}
margins, dydx(cand_female cand_black cand_hispanic) post
eststo no_cue

***POSITIONING: COMPROMISE CUE
reg choice cand_female cand_black cand_hispanic assign_none* assign_issue* X* *cong *np, cluster(responseid)
margins, dydx(cand_female cand_black cand_hispanic) post
eststo compromise

***POSITIONING: POLICY CUE
reg choice cand_female cand_black cand_hispanic assign_compromise* assign_none* X* *cong *np, cluster(responseid)
margins, dydx(cand_female cand_black cand_hispanic) post
eststo issue

drop assign_compromise* assign_issue* assign_none*

******experience mask?
recode experience_np (1=0) (0=1), gen(experience_p)
label var experience_p "Experience Presented"

foreach i in cand_female cand_black cand_hispanic{
foreach c in experience_np experience_p{
gen M_`c'X`i'=`c'*`i'
local label : variable label `i'
local labelc : variable label `c'
label var M_`c'X`i' "`labelc' x `label'"
}
}

***EXPERIENCE: MENTIONED
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic M_experience_npX* X* *cong *np, cluster(responseid)
test M_experience_npXcand_black M_experience_npXcand_hispanic
outreg cand_female cand_black cand_hispanic M_experience_npX* experience_np using "A6_masking`suffix'", se bracket tdec(3) adec(3) append label addstat("Joint Significance of Race/Ethnicity Interactions (p-value)",r(p))
}
eststo exp_p

***EXPERIENCE: NOT MENTIONED
reg choice cand_female cand_black cand_hispanic M_experience_pX* X* *cong experience_p *np, cluster(responseid)
eststo exp_np

******occupation mask?
recode occupation_np (1=0) (0=1), gen(occupation_p)
label var occupation_p "Occupation Presented"

foreach i in cand_female cand_black cand_hispanic{
foreach c in occupation_np occupation_p{
gen M_`c'X`i'=`c'*`i'
local label : variable label `i'
local labelc : variable label `c'
label var M_`c'X`i' "`labelc' x `label'"
}
}

***OCCUPATION: MENTIONED
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic M_occupation_npX* X* *cong *np, cluster(responseid)
test M_occupation_npXcand_black M_occupation_npXcand_hispanic
outreg cand_female cand_black cand_hispanic M_occupation_npX* occupation_np using "A6_masking`suffix'", se bracket tdec(3) adec(3) append label addstat("Joint Significance of Race/Ethnicity Interactions (p-value)",r(p))
}
eststo occup_p

***OCCUPATION: NOT MENTIONED
reg choice cand_female cand_black cand_hispanic M_occupation_pX* X* *cong occupation_p *np, cluster(responseid)
eststo occup_np

***************************************************
***MASKING FIGURE*******************
***************************************************
coefplot (no_cue,  msymbol(O) connect(none) mcolor(black) ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(No Policy Cue)) (issue, msymbol(T) connect(none) mcolor(black)  ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Issue Position Cue)) (compromise, msymbol(S) connect(none) mcolor(black)  ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Compromise Cue)) (exp_np,  msymbol(none) ciopts(lcolor(none))) (exp_np,  msymbol(O) connect(none) mcolor(gs10) ciopts(lcolor(gs10) lpattern(solid) lwidth(thin) msize(vtiny)) label(Experience: Not Presented)) (exp_p, msymbol(T) connect(none) mcolor(gs10)  ciopts(lcolor(gs10) lpattern(solid) lwidth(thin) msize(vtiny)) label(Experience: Presented)) (exp_np,  msymbol(none) ciopts(lcolor(none))) (occup_p, msymbol(Oh) connect(none) mcolor(black)  ciopts(lcolor(black) lpattern(solid) lwidth(thin) msize(vtiny)) label(Occupation: Presented)) (occup_np, msymbol(Th) connect(none) mcolor(black)  ciopts(lcolor(black) lpattern(solid) lwidth(thin) msize(vtiny)) label(Occupation: Not Presented)), keep(cand_female cand_black cand_hispanic)  yline(0) xlabel(-.2 -.1 0 .1) legend(order(2 4 6 10 12 16 18) keygap(0) symxsize(7) region(lcolor(white) color(none)) span holes(6) colf cols(3)  size(small)) level(95) xtitle("Effect on Probability of Selecting Candidate",  size(medsmall)) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) xline(0, lc(black) lw(thin) ) xscale(lw(none))  
graph export "f2_masking_plot.tif", as(tif) width(4000) replace

drop M_*

eststo drop *

*****************************************************************************
*******CHAIR CHARACTERISTIC INTERACTIONS ************************************
*****************************************************************************
*generate Republican
recode democrat (0=1) (1=0), gen(republican)
label var republican "Republican"
*generate male
recode female (1=0) (0=1), gen(male)
label var male "Male (1=yes)"
gen r_white=(r_black==0)&(r_hispanic==0)&(r_other==0)

*set missing/rf age and income to means
qui sum income if income!=15
replace income=income-r(mean) if income!=15
replace income=0 if income==15

*and mean center age, income, educ (set to mean if missing)
foreach i in age educ{
qui sum `i'
replace `i'=`i'-r(mean)
replace `i'=0 if `i'==.
}
label var age "Age (mean-centered)"
label var income "Income (mean-centered)"
label var educ "Education (mean-centered)"

*then generate interactions
foreach i in democrat republican age male female r_white r_black r_hispanic r_other educ income {
foreach c in cand_female cand_black cand_hispanic {
local label : variable label `i'
local labelc : variable label `c'
gen `c'X`i'=`i'*`c'
label var `c'X`i' "`labelc' x `label'"
}
}

***GENDER: COMPONENTS ARE FOR MALE
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic female *Xfemale X* *cong *np, cluster(responseid)
outreg cand_female cand_black cand_hispanic female *Xfemale using "A7_char_interactions`suffix'", se bracket tdec(3) replace label  
}
eststo male_mfx

***GENDER: COMPONENTS ARE FOR FEMALE
reg choice cand_female cand_black cand_hispanic male *Xmale X* *cong *np, cluster(responseid)
eststo female_mfx

***RACE: COMPONENTS ARE FOR WHITE
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic *r_black *r_hispanic *r_other X* *cong *np, cluster(responseid)
outreg cand_female cand_black cand_hispanic *r_black *r_hispanic *r_other using "A7_char_interactions`suffix'", se bracket tdec(3) append label 
}
eststo white_mfx

***RACE: COMPONENTS ARE FOR BLACK
reg choice cand_female cand_black cand_hispanic *r_white *r_hispanic *r_other X* *cong *np, cluster(responseid)
margins, dydx(cand_female cand_black cand_hispanic) post
eststo black_mfx

***RACE: COMPONENTS ARE FOR HISPANIC
reg choice cand_female cand_black cand_hispanic *r_white *r_black *r_other X* *cong *np, cluster(responseid)
margins, dydx(cand_female cand_black cand_hispanic) post
eststo hispanic_mfx

***PARTY COMPONENTS ARE FOR DEMOCRATS
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic *Xrepublican republican X* *cong *np, cluster(responseid)
outreg cand_female cand_black cand_hispanic *republican using "A7_char_interactions`suffix'", se bracket tdec(3) append label 
}
eststo dems_mfx

***PARTY COMPONENTS ARE FOR REPUBLICANS
qui reg choice cand_female cand_black cand_hispanic *Xdemocrat democrat X* *cong *np, cluster(responseid)
eststo reps_mfx

***ROBUSTNESS (ALL + CONTROLS FOR AGE, EDUC, INCOME INTERACTIONS)
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic *republican female *Xfemale *r_black *r_hispanic *r_other *age *educ *income X* *cong *np, cluster(responseid)
outreg cand_female cand_black cand_hispanic *republican female *Xfemale *r_black *r_hispanic *r_other *age *educ *income using "A7_char_interactions`suffix'", se bracket tdec(3) append label 
}
***PLOT EFFECTS
foreach i in M F W B H D R{
gen label_`i'="`i'"
} 

coefplot (male_mfx,  msymbol(none) mlabel(label_M) mlabposition(0) mlabcolor(black) connect(none) mcolor(black) ciopts(lcolor(gs12) lwidth(thin) msize(vtiny)) label(Male Chairs)) (female_mfx, msymbol(none) mlabel(label_F) mlabposition(0) mlabcolor(black) connect(none) mcolor(black)  ciopts(lcolor(gs12) lwidth(thin) msize(vtiny)) label(Female Chairs))  (male_mfx,  msymbol(none) ciopts(lcolor(none)))(white_mfx,  msymbol(none) mlabel(label_W) mlabposition(0) mlabcolor(black) connect(none) mcolor(gs10) ciopts(lcolor(gs12) lpattern(solid) lwidth(thin) msize(vtiny)) label(White Chairs)) (black_mfx, msymbol(none) mlabel(label_B) mlabposition(0) mlabcolor(black)  connect(none) mcolor(gs10)  ciopts(lcolor(gs12) lpattern(solid) lwidth(thin) msize(vtiny)) label(Black Chairs)) (hispanic_mfx, msymbol(none) mlabel(label_H) mlabposition(0) mlabcolor(black)  connect(none) mcolor(gs10)  ciopts(lcolor(gs12) lpattern(solid) lwidth(thin) msize(vtiny)) label(Hispanic Chairs)) (male_mfx,  msymbol(none) ciopts(lcolor(none))) (dems_mfx, msymbol(none) mlabel(label_D) mlabposition(0) mlabcolor(black)  connect(none) mcolor(black)  ciopts(lcolor(gs12) lpattern(solid) lwidth(thin) msize(vtiny)) label(Democratic Chairs)) (reps_mfx, msymbol(none) mlabel(label_R) mlabposition(0) mlabcolor(black)  connect(none) mcolor(black)  ciopts(lcolor(gs12) lpattern(solid) lwidth(thin) msize(vtiny)) label(Republican Chairs)), keep(cand_female cand_black cand_hispanic)  yline(0) legend(off) level(95) xtitle("Effect on Probability of Selecting Candidate",  size(medsmall)) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) xline(0, lc(black) lw(thin) ) xscale(lw(none))  
graph export "A4_chair_char_plot.tif", as(tif) width(4000) replace

drop label_*

***HISPANIC CHAIR MODERATION ROBUST TO CONTROLS FOR COUNTY DEMOGRAPHIC INTERACTIONS?
reg choice c.ln_pct_hisp##(cand_female cand_black cand_hispanic) cand_female cand_black cand_hispanic *democrat female *Xfemale *r_black *r_white *r_other *age *educ *income X* *cong *np , cluster(responseid)

drop *Xdemocrat *Xrepublican republican *Xfemale *Xmale male *Xr_black *Xr_hispanic *Xr_other *Xr_white r_white *Xage *Xeduc *Xincome 
*eststo drop *


*****************************************************************************
*******CONTEXT MODERATION ***************************************************
*****************************************************************************
*first, drop all non-county cases (MISSING ON COUNTY DEMOGRAPHICS)
drop if perc_black_hh==.

foreach i in ln_pct_black ln_pct_hisp{
local label : variable label `i'
gen `i'_nonzero=`i' if `i'!=0
label var `i'_nonzero "`label'; Exclude 0s"
qui sum `i', det
gen `i'_p10=`i' if `i'>r(p10)
label var `i'_p10 "`label'; Exclude Bottom 10%"
}

foreach i in rresent immig {
gen `i'_R10=`i' if `i'_count>=10
local label : variable label `i'
label var `i'_R10 "`label'; At Least 10 Responses"
}

*****************************************
****ELECTORAL HISTORY ANALYSIS **********
*****************************************
foreach i in l_female_any l_black_any l_hisp_any ln_pct_black ln_pct_hisp{
//foreach i in l_female l_female_any l_black l_black_any l_hisp l_hisp_any ln_pct_black ln_pct_hisp{
foreach c in cand_female cand_black cand_hispanic {
local label : variable label `i'
local labelc : variable label `c'
gen `i'X`c'=`i'*`c'
label var `i'X`c' "`labelc' x `label'"
}
}
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
**any legislator
reg `m' cand_female cand_black cand_hispanic l_female_any* l_black_any* l_hisp_any*  X* *cong *np, cluster(responseid)
outreg cand_female cand_black cand_hispanic l_female_any l_female_anyXcand_female  l_female_anyXcand_black l_female_anyXcand_hisp l_black_any l_black_anyXcand_female l_black_anyXcand_black l_black_anyXcand_hisp l_hisp_any l_hisp_anyXcand_female l_hisp_anyXcand_black l_hisp_anyXcand_hisp  using "A12_elec_history_any`suffix'", se bracket tdec(3) replace label ctitle("All")
reg `m' cand_female cand_black cand_hispanic l_female_any* l_black_any* l_hisp_any* ln_pct_black ln_pct_blackXcand_female ln_pct_blackXcand_black ln_pct_blackXcand_hisp ln_pct_hisp ln_pct_hispXcand_female ln_pct_hispXcand_black ln_pct_hispXcand_hisp  X* *cong *np, cluster(responseid)
outreg cand_female cand_black cand_hispanic l_female_any l_female_anyXcand_female  l_female_anyXcand_black l_female_anyXcand_hisp l_black_any l_black_anyXcand_female l_black_anyXcand_black l_black_anyXcand_hisp l_hisp_any l_hisp_anyXcand_female l_hisp_anyXcand_black l_hisp_anyXcand_hisp ln_pct_black ln_pct_blackXcand_female ln_pct_blackXcand_black ln_pct_blackXcand_hisp ln_pct_hisp ln_pct_hispXcand_female ln_pct_hispXcand_black ln_pct_hispXcand_hisp   using "A12_elec_history_any`suffix'", se bracket tdec(3) append label ctitle("All")

reg `m' cand_female cand_black cand_hispanic l_female_any* l_black_any* l_hisp_any*  X* *cong *np if democrat==1, cluster(responseid)
outreg cand_female cand_black cand_hispanic l_female_any l_female_anyXcand_female  l_female_anyXcand_black l_female_anyXcand_hisp l_black_any l_black_anyXcand_female l_black_anyXcand_black l_black_anyXcand_hisp l_hisp_any l_hisp_anyXcand_female l_hisp_anyXcand_black l_hisp_anyXcand_hisp  using "A12_elec_history_any`suffix'", se bracket tdec(3) append label ctitle("Democratic Chairs")
reg `m' cand_female cand_black cand_hispanic l_female_any* l_black_any* l_hisp_any* ln_pct_black ln_pct_blackXcand_female ln_pct_blackXcand_black ln_pct_blackXcand_hisp ln_pct_hisp ln_pct_hispXcand_female ln_pct_hispXcand_black ln_pct_hispXcand_hisp  X* *cong *np if democrat==1, cluster(responseid)
outreg cand_female cand_black cand_hispanic l_female_any l_female_anyXcand_female  l_female_anyXcand_black l_female_anyXcand_hisp l_black_any l_black_anyXcand_female l_black_anyXcand_black l_black_anyXcand_hisp l_hisp_any l_hisp_anyXcand_female l_hisp_anyXcand_black l_hisp_anyXcand_hisp ln_pct_black ln_pct_blackXcand_female ln_pct_blackXcand_black ln_pct_blackXcand_hisp ln_pct_hisp ln_pct_hispXcand_female ln_pct_hispXcand_black ln_pct_hispXcand_hisp   using "A12_elec_history_any`suffix'", se bracket tdec(3) append label ctitle("Democratic Chairs")

reg `m' cand_female cand_black cand_hispanic l_female_any* l_black_any* l_hisp_any*  X* *cong *np if democrat==0, cluster(responseid)
outreg cand_female cand_black cand_hispanic l_female_any l_female_anyXcand_female  l_female_anyXcand_black l_female_anyXcand_hisp l_black_any l_black_anyXcand_female l_black_anyXcand_black l_black_anyXcand_hisp l_hisp_any l_hisp_anyXcand_female l_hisp_anyXcand_black l_hisp_anyXcand_hisp  using "A12_elec_history_any`suffix'", se bracket tdec(3) append label ctitle("Republican Chairs")
reg `m' cand_female cand_black cand_hispanic l_female_any* l_black_any* l_hisp_any* ln_pct_black ln_pct_blackXcand_female ln_pct_blackXcand_black ln_pct_blackXcand_hisp ln_pct_hisp ln_pct_hispXcand_female ln_pct_hispXcand_black ln_pct_hispXcand_hisp  X* *cong *np if democrat==0, cluster(responseid)
outreg cand_female cand_black cand_hispanic l_female_any l_female_anyXcand_female  l_female_anyXcand_black l_female_anyXcand_hisp l_black_any l_black_anyXcand_female l_black_anyXcand_black l_black_anyXcand_hisp l_hisp_any l_hisp_anyXcand_female l_hisp_anyXcand_black l_hisp_anyXcand_hisp ln_pct_black ln_pct_blackXcand_female ln_pct_blackXcand_black ln_pct_blackXcand_hisp ln_pct_hisp ln_pct_hispXcand_female ln_pct_hispXcand_black ln_pct_hispXcand_hisp   using "A12_elec_history_any`suffix'", se bracket tdec(3) append label ctitle("Republican Chairs")
}


*******************************************************
****OTHER COUNTY CONTEXT MODERATORS ANALYSIS **********
*******************************************************
*set starting local value to main so we can separate out the attitudes within party models (which go in a different table)
local round="A8_main"
recode democrat(0=1) (1=0), gen(republican)
label var republican "Republican Chair (1=yes)"
*NOTE: Black HH excluding bottom 10% not run because same as non-zero :(
foreach i in ln_pct_black ln_pct_hisp rresent immig perc_black_hh ln_pct_black_nonzero perc_hisp_hh ln_pct_hisp_p10 rresent_R10 immig_R10 closeness{
*generate a working variable called moderator so we don't have a billion rows in the tables
gen moderator=`i'
label var moderator "Moderator"

if "`i'"=="perc_black_hh"{
local round="A9_robustness"
}
if "`i'"=="rresent_R10"{
local round="A10_att_robust"
}
if "`i'"=="closeness"{
local round="A11_e_context"
}
local xlab = ""
local label : variable label `i'
local xaxis="`label'"

if "`i'"=="ln_pct_black"{
local xaxis="Percent Black Households"
local increments="(0 0.693 1.099 1.386 1.609 1.792 1.946 2.079 2.197 2.303 2.398 2.485 2.565 2.639 2.708 2.773 2.833 2.890 2.944 2.996 3.045 3.091 3.135 3.178 3.219 3.258 3.296 3.332 3.367 3.401 3.434 3.466 3.497 3.526 3.555 3.584 3.611 3.638 3.664 3.689 3.714 3.738 3.761 3.784 3.807 3.829 3.850 3.871 3.892 3.912 3.932)"
}
if "`i'"=="ln_pct_hisp"{
local xaxis="Percent Hispanic Households"
local increments="(0 0.693 1.099 1.386 1.609 1.792 1.946 2.079 2.197 2.303 2.398 2.485 2.565 2.639 2.708 2.773 2.833 2.890 2.944 2.996 3.045 3.091 3.135 3.178 3.219 3.258 3.296 3.332 3.367 3.401 3.434 3.466 3.497 3.526 3.555 3.584 3.611 3.638 3.664 3.689 3.714 3.738 3.761 3.784 3.807 3.829 3.850 3.871 3.892 3.912 3.932)"
}
if "`i'"=="rresent"{
local xaxis="Racial Resentment (1-5; County Level)"
local increments="(2 2.25 2.5 2.75 3 3.25 3.5 3.75 4 4.25 4.5 4.75 5)"
}
if "`i'"=="dem_rresent"{
local xaxis="Racial Resentment (1-5; County Level; Democrats)"
local increments="(2 2.25 2.5 2.75 3 3.25 3.5 3.75 4 4.25 4.5 4.75 5)"
}
if "`i'"=="rep_rresent"{
local xaxis="Racial Resentment (1-5; County Level; Republicans)"
local increments="(2 2.25 2.5 2.75 3 3.25 3.5 3.75 4 4.25 4.5 4.75 5)"
}
if "`i'"=="immig"{
local xaxis="Pro-Immigration Attitudes (0-1; County Level)"
local increments="(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1)"
}
if "`i'"=="dem_immig"{
local xaxis="Pro-Immigration Attitudes (0-1; County Level; Democrats)"
local increments="(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1)"
}
if "`i'"=="rep_immig"{
local xaxis="Pro-Immigration Attitudes (0-1; County Level; Republicans)"
local increments="(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1)"
}

gen womanXmoderator=cand_female*moderator
gen blackXmoderator=cand_black*moderator
gen hispanicXmoderator=cand_hispanic*moderator
gen republicanXmoderator=republican*moderator
label var womanXmoderator "Moderator x Female Candidate"
label var blackXmoderator "Moderator x Black Candidate"
label var hispanicXmoderator "Moderator x Latinx Candidate"
label var republicanXmoderator "Moderator x Republican Chair"

*components for 3-ways
gen republicanXwoman=cand_female*republican
gen republicanXblack=cand_black*republican
gen republicanXhispanic=cand_hispanic*republican
label var republicanXwoman "Republican Chair x Female Candidate"
label var republicanXblack "Republican Chair x Black Candidate"
label var republicanXhispanic "Republican Chair x Latinx Candidate"

*three way interactions
gen republicanXwomanXmoderator=cand_female*republican*moderator
gen republicanXblackXmoderator=cand_black*republican*moderator
gen republicanXhispanicXmoderator=cand_hispanic*republican*moderator
label var republicanXwomanXmoderator "Moderator x Republican Chair x Female Candidate"
label var republicanXblackXmoderator "Moderator x Republican Chair x Black Candidate"
label var republicanXhispanicXmoderator "Moderator x Republican Chair x Latinx Candidate"

foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
reg `m' cand_female cand_black cand_hispanic womanXmoderator blackXmoderator hispanicXmoderator moderator X* *cong *np, cluster(responseid)
qui test womanXmoderator 
local fem_p=r(p)
qui test blackXmoderator 
local black_p=r(p)
qui test hispanicXmoderator 
local hisp_p=r(p)
if "`i'"=="ln_pct_black" | "`i'"=="perc_black_hh" | "`i'"=="rresent_R10"| "`i'"=="closeness"{
outreg cand_female cand_black cand_hispanic womanXmoderator blackXmoderator hispanicXmoderator moderator using "`round'_moderator_interactions_`suffix'", se bracket tdec(3) adec(3) addstat("Two Way Interactions (p-value)","0","Female Candidate Interaction", `fem_p',"Black Candidate Interaction", `black_p',"Latinx Candidate Interaction", `hisp_p') replace label ctitle("`label'")
}
else{
outreg cand_female cand_black cand_hispanic womanXmoderator blackXmoderator hispanicXmoderator moderator using "`round'_moderator_interactions_`suffix'", se bracket tdec(3) adec(3) addstat("Two Way Interactions (p-value)","0","Female Candidate Interaction", `fem_p',"Black Candidate Interaction", `black_p',"Latinx Candidate Interaction", `hisp_p') append label ctitle("`label'")
}
}
*NOW RUN THE SAME MODELS USING STATA'S FACTOR MODELS (to get p-values)
foreach m in rel_eval choice {
if "`m'"=="rel_eval"{
local suffix="_linear"
}
else{
local suffix=""
}
qui reg `m' c.moderator##(i.cand_female##i.republican i.cand_black##i.republican i.cand_hispanic##i.republican) X* *cong *np, cluster(responseid)
qui test 1.cand_female#1.republican#c.moderator
local femaleX=r(p)
qui test 1.cand_black#1.republican#c.moderator
local blackX=r(p)
qui test 1.cand_hispanic#1.republican#c.moderator
local hispanicX=r(p)
reg `m' cand_female cand_black cand_hispanic womanXmoderator blackXmoderator hispanicXmoderator moderator republican republicanX* X* *cong *np, cluster(responseid)
outreg cand_female cand_black cand_hispanic womanXmoderator blackXmoderator hispanicXmoderator moderator republican republicanX* using "`round'_moderator_interactions_`suffix'", se bracket tdec(3) adec(3) append label addstat("Three Way Interactions (p-value)","0", "Female Candidate Interaction",`femaleX',"Black Candidate Interaction",`blackX',"Latinx Candidate Interaction",`hispanicX')
}

***NOW RUN THE SAME MODELS USING STATA'S FACTOR MODELS (DUMPING OUT ESTIMATES TO NEW DTA FILES); Just for main analysis.
if "`round'"=="A8_main"{
*************CREATE DATASETS TO BUILD MFX GRAPHS (ALLOWING FOR "UNLOGGING" OF PCT BLACK/HISP)
reg choice c.moderator##(i.cand_female##i.republican i.cand_black##i.republican i.cand_hispanic##i.republican) X* *cong *np, cluster(responseid)
margins republican, dydx(cand_black) at(c.moderator=`increments') post
*Saves margins to new file
parmest, saving(..\scratch_datasets\black_`i'.dta, replace)

reg choice c.moderator##(i.cand_female##i.republican i.cand_black##i.republican i.cand_hispanic##i.republican) X* *cong *np, cluster(responseid)
margins republican, dydx(cand_hisp) at(c.moderator=`increments') post
parmest, saving(..\scratch_datasets\hisp_`i'.dta, replace)

}


drop moderator womanX* blackX* hispanicX* republicanX* 
}

//ROBUST TO INCLUSION OF ALL INTERACTIONS? YES.
reg choice c.ln_pct_black##(i.cand_female i.cand_black i.cand_hispanic) c.ln_pct_hisp##(i.cand_female i.cand_black i.cand_hispanic) c.rresent##(i.cand_female i.cand_black i.cand_hispanic) c.immig##(i.cand_female i.cand_black i.cand_hispanic) X* *cong *np, cluster(responseid)
reg choice c.ln_pct_black##(i.cand_female##i.republican i.cand_black##i.republican i.cand_hispanic##i.republican) c.ln_pct_hisp##(i.cand_female##i.republican i.cand_black##i.republican i.cand_hispanic##i.republican) c.rresent##(i.cand_female##i.republican i.cand_black##i.republican i.cand_hispanic##i.republican) c.immig##(i.cand_female##i.republican i.cand_black##i.republican i.cand_hispanic##i.republican) X* *cong *np, cluster(responseid)

preserve
****BUILD THE MFX GRAPHS
foreach i in ln_pct_black ln_pct_hisp rresent immig {
local d_x_coord=38
local r_x_coord=38
foreach r in black hisp{
if "`r'"=="black"{
local ytitle="Effect of Black (v. White) Candidate"
}

if "`r'"=="hisp"{
local ytitle="Effect of Latinx (v. White) Candidate"
}

use "..\scratch_datasets\\`r'_`i'.dta", clear
drop if estimate==0
split parm,p("#")
split parm1,p(".")
split parm2,p(".")
rename parm11 predictor
rename parm21 republican
destring predictor, replace force
destring republican, replace force


//set up/merge county data for histograms
gen fips=1000000
merge m:m fips using "..\scratch_datasets\county_info.dta"

if "`i'"=="ln_pct_black"{
gen `i'=perc_black_hh 
replace `i'=50 if `i'>50 & `i'!=.
replace predictor=predictor-1
local xtitle="Percent Black Households in County"
if "`r'"=="black"{
local d_y_coord=.03
local r_y_coord=-.115
}
if "`r'"=="hisp"{
local d_y_coord=-.01
local r_y_coord=-.145
}
}

if "`i'"=="ln_pct_hisp"{
gen `i'=perc_hisp_hh 
replace `i'=50 if `i'>50 & `i'!=.
replace predictor=predictor-1
local xtitle="Percent Hispanic Households in County"
if "`r'"=="black"{
local d_y_coord=-.055
local r_y_coord=-.14
}
if "`r'"=="hisp"{
local d_y_coord=.03
local r_y_coord=-.11
}
}
if "`i'"=="rresent"{
local xtitle="Racial Resentment (1-5; County Level)"
replace predictor=(predictor-1)/4+2
}
if "`i'"=="immig"{
local xtitle="Pro-Immigration Attitudes (0-1; County Level)"
replace predictor=(predictor-1)/10
}
twoway (hist `i', lcolor(gs14) fcolor(gs14)  yaxis(2)) (line estimate predictor if republican==1, lwidth(thick) lcolor(black)) (line min95 predictor if republican==1, lwidth(thin) lpattern(dash) lcolor(black)) (line max95 predictor if republican==1, lwidth(thin) lpattern(dash) lcolor(black)) (line estimate predictor if republican==0, lwidth(thick) lcolor(gs8)) (line min95 predictor if republican==0, lwidth(thin) lpattern(dash) lcolor(gs8)) (line max95 predictor if republican==0, lwidth(thin) lpattern(dash) lcolor(gs8)), legend(off)  graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) xtitle(`xtitle', size(medium)) ytitle(`ytitle') title("") ylabel(-.2 -.1 0 .1 .2)  text(`d_y_coord' `d_x_coord'  "Democratic Chairs", place(c))  text(`r_y_coord' `r_x_coord'  "Republican Chairs", place(c))
graph save Graph "`r'_`i'.gph", replace
}
}

graph combine black_ln_pct_black.gph hisp_ln_pct_hisp.gph ,  cols(2) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large))
graph export "f3_conditioning_parametric.tif", as(tif) width(4000) replace

***************************************************************************
** LOWESS FIGURES *********************************************************
***************************************************************************
restore
**trim range for LOWESS FOR SKEWED DEMOGRAPHIC MEASURES
foreach i in perc_black_hh perc_hisp_hh {
gen `i'_95=`i'
qui sum `i', det
replace `i'_95=r(p95) if `i'_95>r(p95) & `i'!=.
}
label var perc_black_hh_95 "Percent Black HHs (top coded at 95th percentile)"
label var perc_hisp_hh_95 "Percent Hispanic HHs (top coded at 95th percentile)"

***DEMOCRATS ONLY BLACK CONTEXT 
twoway (hist perc_black_hh_95,yaxis(2) freq lcolor(gs14) fcolor(gs14)) (lowess choice perc_black_hh_95 if cand_black & democrat==1, lcolor(black) lpattern(solid) lwidth(thick)) (lowess choice perc_black_hh_95  if cand_black & democrat==1 & opp_white, lcolor(black) lpattern(dash) lwidth(thick)) (lowess choice perc_black_hh_95  if cand_black & democrat==1 & opp_hisp, lcolor(gs8) lpattern(dash) lwidth(thick)) , graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) ylabel(none, axis(2)) ytitle("", axis(2)) ytitle("Probability of Selecting Black Cand.", axis(1)) xline(0, lc(black) lw(thin) ) yscale(range(.3 .8)) ylabel(.3 .4 .5 .6 .7 .8) xscale(lw(none)) legend(off) text(.71 12 "Black Candidate" "Latinx Opponent", place(c)) text(.43 20 "Black Candidate" "White Opponent", place(c))  text(.58 22 "All Black Candidates", place(c))
graph save Graph "lowess_dems_black.gph", replace

***DEMOCRATS ONLY HISPANIC CONTEXT 
twoway (hist perc_hisp_hh_95,yaxis(2) freq lcolor(gs14) fcolor(gs14)) (lowess choice perc_hisp_hh_95 if cand_hisp & democrat==1, lcolor(black) lpattern(solid) lwidth(thick)) (lowess choice perc_hisp_hh_95  if cand_hisp & democrat==1 & opp_white, lcolor(black) lpattern(dash) lwidth(thick)) (lowess choice perc_hisp_hh_95  if cand_hisp & democrat==1 & opp_black, lcolor(gs8) lpattern(dash) lwidth(thick)) , graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) ylabel(none, axis(2)) ytitle("", axis(2)) ytitle("Probability of Selecting Latinx Cand.", axis(1)) xline(0, lc(black) lw(thin) ) yscale(range(.3 .8)) ylabel(.3 .4 .5 .6 .7 .8) xscale(lw(none)) legend(off) text(.57 9 "Latinx Candidate" "Black Opponent", place(c)) text(.38 21 "Latinx Candidate" "White Opponent", place(c))  text(.5 25 "All Latinx" "Candidates", place(c))
graph save Graph "lowess_dems_hisp.gph", replace

***COMBINE LOWESS GRAPHS
graph combine lowess_dems_black.gph lowess_dems_hisp.gph, ycommon cols(2) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large))
graph export "f4_lowess_dems.tif", as(tif) width(4000) replace

***REPUBLICANS ONLY BLACK CONTEXT 
twoway (hist perc_black_hh_95,yaxis(2) freq lcolor(gs14) fcolor(gs14)) (lowess choice perc_black_hh_95 if cand_black & democrat==0, lcolor(black) lpattern(solid) lwidth(thick)) (lowess choice perc_black_hh_95  if cand_black & democrat==0 & opp_white, lcolor(black) lpattern(dash) lwidth(thick)) (lowess choice perc_black_hh_95  if cand_black & democrat==0 & opp_hisp, lcolor(gs8) lpattern(dash) lwidth(thick)) , graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) ylabel(none, axis(2)) ytitle("", axis(2)) ytitle("Probability of Selecting Black Cand.", axis(1)) xline(0, lc(black) lw(thin) ) yscale(range(.3 .8)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8) xscale(lw(none)) legend(off) text(.53 10 "Latinx Opponent", place(c)) text(.4 11 "White Opponent", place(c))  text(.415 28 "All", place(c))
graph save Graph "lowess_reps_black.gph", replace

***REPUBLICANS ONLY HISPANIC CONTEXT 
twoway (hist perc_hisp_hh_95,yaxis(2) freq lcolor(gs14) fcolor(gs14)) (lowess choice perc_hisp_hh_95 if cand_hisp & democrat==0, lcolor(black) lpattern(solid) lwidth(thick)) (lowess choice perc_hisp_hh_95  if cand_hisp & democrat==0 & opp_white, lcolor(black) lpattern(dash) lwidth(thick)) (lowess choice perc_hisp_hh_95  if cand_hisp & democrat==0 & opp_black, lcolor(gs8) lpattern(dash) lwidth(thick)) , graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) ylabel(none, axis(2)) ytitle("", axis(2)) ytitle("Probability of Selecting Latinx Cand.", axis(1)) xline(0, lc(black) lw(thin) ) yscale(range(.3 .8)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8) xscale(lw(none)) legend(off) text(.6 7 "Black Opponent", place(c)) text(.4 8 "White Opponent", place(c))  text(.415 28 "All", place(c))
graph save Graph "lowess_reps_hisp.gph", replace

***COMBINE LOWESS GRAPHS
graph combine lowess_reps_black.gph lowess_reps_hisp.gph, ycommon cols(2) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large))
graph export "A5_lowess_reps.tif", as(tif) width(4000) replace

**COUNTS OF CASES FOR FN
count if democrat & perc_black_hh>10 & cand_black & opp_white
count if democrat & perc_black_hh>10 & cand_black & opp_hisp



