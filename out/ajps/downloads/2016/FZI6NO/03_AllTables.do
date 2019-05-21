clear all
cd "~/Dropbox/EconNationalism_Union/UnionInformation/ReplicationPackage"
use "UnionInformation_ReplicationData.dta"

* Note 1: To execute lines starting with eststo and esttab, you will need to install the estout package with the command “ssc install estout” in Stata.
* Note 2: To replicate Table A16 in the appendix, you will need to install the following ado file: psacalc (by Emily Oster); the file is available at: http://fmwww.bc.edu/repec/bocode/p/psacalc.ado
 
merge 1:1 caseid using "PreprocessedData.dta" /* This dataset was created from matching anlaysis -- see lines 38- 52 in 02_Matching_FigureA3_TableA2.R included in the replication package */
drop _merge

keep if employ1 == 1 /* keep observations that are currently employed */

gen trade_reduction=0 /* creating DVs */
replace trade_reduction = 1 if trade4 == 4 | trade4==5

gen trade_self=0 /* creating DVs */
replace trade_self= 1 if trade1 == 4 | trade1 == 5

gen trade_us=0 /* creating DVs */
replace trade_us = 1 if trade3 == 4 | trade3 == 5

tab naics, gen(industry_dummy) /* creating industry dummies */

gen female = 0 
replace female = 1 if gender == 2 /* creating female dummy */

gen white = 0 
replace white = 1 if race ==1 /* creating white dummy for race */

gen black = 0
replace black = 1 if race ==2 /* creating black dummy for race */

gen hispanic = 0
replace hispanic = 1 if race ==3 /* creating hispanic dummy for race */

gen age = 2011 - birthyr /* creating age variable as of 2011 */

foreach var of varlist union_member educ age family_income female white black hispanic married pol_id govt_owned{
  gen rtw_`var' = `var' * rtw /* creating interaction variables between RTW and others */
  gen econ_college_`var' = `var' * econ_college /* creating interaction variables between college economics course and others */
  gen party_id_`var' = `var' * party_id /* creating interaction variables between party id and others */
 }
 
label var rtw_union_member "RTW*Union Member"
label var party_id_union_member "Union Member * Party ID"

local control "educ age family_income female white black hispanic married"
local rtwcontrol "rtw_educ rtw_age rtw_family_income rtw_female rtw_white rtw_black rtw_hispanic rtw_married rtw_pol_id"

* Table 1: Strongly Protectinoist Unions 

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0, robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==1 & govt_owned == 0, robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0, robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==1 & govt_owned == 0, robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0, robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id  `rtwcontrol' if protectionism==1 & govt_owned == 0, robust

esttab using "Table1_RTWInteractionMore.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade ) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


* Table 1: Not Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0, robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==0 & govt_owned == 0, robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0, robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id  `rtwcontrol' if protectionism==0 & govt_owned == 0, robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0, robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==0 & govt_owned == 0, robust

esttab using "Table1_RTWInteractionLess.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade ) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

* Table 2: Auto Sector Analysis --  Change in the Union’s Policy Position and Members’ Preferences

gen postyear = 0
replace postyear = 1 if year ==2011 
label var postyear "Post-Shift"

gen post_union = union_member * postyear
label var post_union "Post-Shift*Union Member"

gen indiana = 0 
replace indiana = 1 if state == "indiana"
gen post_indiana = postyear * indiana

gen michigan = 0
replace michigan = 1 if state == "michigan"
gen post_michigan = postyear * michigan

gen ohio = 0 
replace ohio = 1 if state == "ohio"
gen post_ohio = postyear * ohio

gen newspaper_consumption = 0 
replace newspaper_consumption = 1 if info2b == 1 /*  A binary indicator taking a value of 1 if the respondent read a newspaper once a day or more. */

eststo clear

eststo: dprobit trade_reduction union_member postyear post_union if auto==1
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married if auto==1
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption if auto==1
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption michigan post_michigan ohio post_ohio if auto==1
eststo: dprobit trade_self union_member postyear post_union if auto==1
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married if auto==1
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption if auto==1
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption michigan post_michigan ohio post_ohio if auto==1

esttab using "Table2_AutoShift.tex", booktabs margin label title (Change in the Union's Policy Position and Members' Preferences \label{auto}) keep (union_member postyear post_union) order(union_member postyear post_union) mtitles ("Trade Level" "" "" "" "Trade on Self" "" "" "" )  stats(N, labels(Observations) fmt(0 0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


* Table A5: Union Average Protectionism Stance and Worker’s View on Trade

gen industry_union = industry_score * union_member 
label var industry_union "Industry Protectionism Score*Union Member"
label var industry_score "Industry Protectionism Score"

eststo clear

foreach var in trade_reduction trade_self trade_us{
eststo: dprobit `var' industry_score union_member 
eststo: dprobit `var' industry_score union_member industry_union
eststo: dprobit `var' industry_score union_member industry_union educ age family_income female white black hispanic married govt_owned
}

esttab using "TableA5_IndustryProtectionism.tex", booktabs margin label title (Union Average Protectionism Stance and Worker's View on Trade /label{unionaverage}) ///
   keep(industry_score union_member industry_union) order(industry_score union_member industry_union) mtitles ("Trade Level" "" "" "Trade on Self" "" "" "Trade on US" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate(Demographic Controls = educ)


* Table A6 (Pre-processed Data): Strongly Protectinoist Unions 

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id  `rtwcontrol' if protectionism==1 & govt_owned == 0 & pre_processed == 1, robust

esttab using "TableA6_RTWInteractionMore_Preprocess.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade with Pre-processed Data ) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


* Table A6  (Pre-processed Data): Not Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id  `rtwcontrol' if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==0 & govt_owned == 0 & pre_processed == 1, robust

esttab using "TableA6_RTWInteractionLess_Preprocess.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade with Pre-processed Data ) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

  
* Table A7 (Sampling Weight): Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0 [pweight=weight], robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==1 & govt_owned == 0 [pweight=weight], robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0 [pweight=weight], robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==1 & govt_owned == 0 [pweight=weight], robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1 & govt_owned == 0 [pweight=weight], robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id  `rtwcontrol' if protectionism==1 & govt_owned == 0 [pweight=weight], robust

esttab using "TableA7_RTWInteractionMore_Weight.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade with Sampling Weight) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

* Table A7 (Sampling Weight): Not Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0 [pweight=weight], robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==0 & govt_owned == 0 [pweight=weight], robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0 [pweight=weight], robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id  `rtwcontrol' if protectionism==0 & govt_owned == 0 [pweight=weight], robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0 & govt_owned == 0 [pweight=weight], robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0 & govt_owned == 0 [pweight=weight], robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==0 & govt_owned == 0 [pweight=weight], robust


esttab using "TableA7_RTWInteractionLess_Weight.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade wigh Sampling Weight) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

   
* Table A8 (Full Sample with Public Sector Workers Included): Strongly Protectinoist Unions 

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1, robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==1, robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1, robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==1, robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==1, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==1, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==1, robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id  `rtwcontrol' if protectionism==1, robust


esttab using "TableA8_RTWInteractionMore_Full.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade with the Full Sample) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


* Table A8 (Full Sample with Public Sector Workers Included): Not Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0, robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==0, robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0, robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id  `rtwcontrol' if protectionism==0, robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if protectionism==0, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if protectionism==0, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if protectionism==0, robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if protectionism==0, robust

esttab using "TableA8_RTWInteractionLess_Full.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade with the Full Sample) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


* Table A9 (Individuals in Management Excluded): Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==1, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==1, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if govt_owned == 0  & occupation!=1 & protectionism==1, robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if govt_owned == 0  & occupation!=1 & protectionism==1, robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==1, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==1, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if govt_owned == 0  & occupation!=1 & protectionism==1, robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if govt_owned == 0  & occupation!=1 & protectionism==1, robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==1, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==1, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if govt_owned == 0  & occupation!=1 & protectionism==1, robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if govt_owned == 0  & occupation!=1 & protectionism==1, robust

esttab using "TableA9_RTWInteractionMore_Managers.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

* Table A9 (Individuals in Management Excluded): Not Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member rtw `control' industry_dummy1 - industry_dummy12 if govt_owned == 0 & occupation!=1 & protectionism==0, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==0, robust
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if govt_owned == 0  & occupation!=1 & protectionism==0, robust 
eststo: dprobit trade_reduction union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if govt_owned == 0  & occupation!=1 & protectionism==0, robust

eststo: dprobit trade_self union_member rtw `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==0, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==0, robust
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if govt_owned == 0  & occupation!=1 & protectionism==0, robust 
eststo: dprobit trade_self union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if govt_owned == 0  & occupation!=1 & protectionism==0, robust

eststo: dprobit trade_us union_member rtw `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==0, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 if govt_owned == 0  & occupation!=1 & protectionism==0, robust
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id if govt_owned == 0  & occupation!=1 & protectionism==0, robust 
eststo: dprobit trade_us union_member rtw rtw_union_member `control' industry_dummy1 - industry_dummy12 pol_id `rtwcontrol' if govt_owned == 0  & occupation!=1 & protectionism==0, robust

esttab using "TableA9_RTWInteractionLess_Managers.tex", booktabs margin label title (Robustness Analysis with Individuals in Management Excluded) ///
   keep (union_member rtw rtw_union_member) /// 
   order (union_member rtw rtw_union_member)  mtitles ("" "" "" "" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

* Table A10 Auto Sector Analysis -- (Change in the Union’s Policy Position and Members’ Preferences with Pre-processed Data)

eststo clear

eststo: dprobit trade_reduction union_member postyear post_union if auto==1 & pre_processed==1 
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married if auto==1 & pre_processed==1 
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married pol_id  newspaper_consumption if auto==1 & pre_processed==1 
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married pol_id  newspaper_consumption michigan post_michigan ohio post_ohio if auto==1 & pre_processed==1 

eststo: dprobit trade_self union_member postyear post_union if auto == 1 & pre_processed==1 
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married if auto==1 & pre_processed==1 
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption if auto==1 & pre_processed==1 
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption michigan post_michigan ohio post_ohio if auto==1 & pre_processed==1 

esttab using "TableA10_AutoShift_Preprocess.tex", booktabs margin label title (Change in the Union's Policy Position and Members' Preferences with Pre-processed Data \label{auto}) keep (union_member postyear post_union) order(union_member postyear post_union) mtitles ("Trade Level" "" "" "" "Trade on Self" "" "" "" )  stats(N, labels(Observations) fmt(0 0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

* Table A11 Auto Sector Analysis -- (Change in the Union’s Policy Position and Members’ Preferences with Sampling Weight)

eststo clear

eststo: dprobit trade_reduction union_member postyear post_union if auto==1 [pweight=weight]
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married if auto==1 [pweight=weight]
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married pol_id  newspaper_consumption if auto==1 [pweight=weight]
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married pol_id  newspaper_consumption michigan post_michigan ohio post_ohio if auto==1 [pweight=weight]

eststo: dprobit trade_self union_member postyear post_union if auto==1 [pweight=weight]
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married if auto==1 [pweight=weight]
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption if auto==1 [pweight=weight]
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption michigan post_michigan ohio post_ohio if auto==1 [pweight=weight]

esttab using "TableA11_AutoShift_Weight.tex", booktabs margin label title (Change in the Union's Policy Position and Members' Preferences with Sampling Weight \label{auto}) keep (union_member postyear post_union) order(union_member postyear post_union) mtitles ("Trade Level" "" "" "" "Trade on Self" "" "" "" )  stats(N, labels(Observations) fmt(0 0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

* Table A12 Auto Sector Analysis --  (Change in the Union’s Policy Position and Members’ Preferences with Managers Excluded)

eststo clear

eststo: dprobit trade_reduction union_member postyear post_union if auto==1 & occupation!=1 
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married if auto==1 & occupation!=1 
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married pol_id  newspaper_consumption if auto==1 & occupation!=1 
eststo: dprobit trade_reduction union_member postyear post_union age family_income female white black educ married pol_id  newspaper_consumption michigan post_michigan ohio post_ohio if auto==1 & occupation!=1 

eststo: dprobit trade_self union_member postyear post_union if auto == 1 & occupation!=1 
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married if auto==1 & occupation!=1 
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption if auto==1 & occupation!=1 
eststo: dprobit trade_self union_member postyear post_union age family_income female white black educ married pol_id newspaper_consumption michigan post_michigan ohio post_ohio if auto==1 & occupation!=1 

esttab using "TableA12_AutoShift_Managers.tex", booktabs margin label title (Change in the Union's Policy Position and Members' Preferences with Individuals in Management Excluded \label{auto}) keep (union_member postyear post_union) order(union_member postyear post_union) mtitles ("Trade Level" "" "" "" "Trade on Self" "" "" "" )  stats(N, labels(Observations) fmt(0 0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


* Table A13 (Effect of Union Membership Conditional on Partisan Stance): Strongly Protectionist Unions

local partyid_control "party_id_educ party_id_age party_id_family_income party_id_female party_id_white party_id_black party_id_hispanic party_id_married"

eststo clear

eststo: dprobit trade_reduction union_member party_id educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==1, robust
eststo: dprobit trade_reduction union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==1, robust
eststo: dprobit trade_reduction union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `partyid_control' if govt_owned == 0 & protectionism==1, robust

eststo: dprobit trade_self union_member party_id educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==1, robust
eststo: dprobit trade_self union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 &  protectionism==1, robust
eststo: dprobit trade_self union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `partyid_control' if govt_owned == 0 & protectionism==1, robust

eststo: dprobit trade_us union_member party_id educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==1, robust
eststo: dprobit trade_us union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==1, robust
eststo: dprobit trade_us union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12  `partyid_control' if govt_owned == 0 & protectionism==1, robust

esttab using "TableA13_PartyID_InteractionMore.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade Conditional on Partisan Stance \label{interaction1}) ///
  keep (union_member party_id party_id_union_member) /// 
  order (union_member party_id party_id_union_member) mtitles ("" "" "" "" "" "" "" "" "") ///
  stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

* Table A13 (Effect of Union Membership Conditional on Partisan Stance): Not Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member party_id educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_reduction union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_reduction union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `partyid_control' if govt_owned == 0 & protectionism==0, robust

eststo: dprobit trade_self union_member party_id educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_self union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_self union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `partyid_control' if govt_owned == 0 & protectionism==0, robust

eststo: dprobit trade_us union_member party_id educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_us union_member party_id party_id_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_us union_member party_id party_id_union_member `control' industry_dummy1 - industry_dummy12  `partyid_control' if govt_owned == 0 & protectionism==0, robust

esttab using "TableA13_PartyID_InteractionLess.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade Conditional on Partisan Stance \label{interaction1}) ///
  keep (union_member party_id party_id_union_member) /// 
  order (union_member party_id party_id_union_member) mtitles ("" "" "" "" "" "" "" "" "") ///
  stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

* Table A14 (Effectf of Union Membership Conditional on Economic Knowledge): Strongly Protectionist Unions

local econcontrol "econ_college_educ econ_college_age econ_college_family_income econ_college_female econ_college_white econ_college_black econ_college_hispanic econ_college_married"

eststo clear

eststo: dprobit trade_reduction union_member econ_college educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==1, robust
eststo: dprobit trade_reduction union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 &  protectionism==1, robust
eststo: dprobit trade_reduction union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `econcontrol' if govt_owned == 0 &  protectionism==1, robust 

eststo: dprobit trade_self union_member econ_college educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 &  protectionism==1, robust
eststo: dprobit trade_self union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 &  protectionism==1, robust
eststo: dprobit trade_self union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `econcontrol' if govt_owned == 0 &  protectionism==1, robust 

eststo: dprobit trade_us union_member econ_college educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 &  protectionism==1, robust
eststo: dprobit trade_us union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 &  protectionism==1, robust
eststo: dprobit trade_us union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `econcontrol' if govt_owned == 0 &  protectionism==1, robust 

esttab using "TableA14_EconEduInteractionMore.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade Conditional on Economic Knowledge \label{interaction1}) ///
   keep (union_member econ_college econ_college_union_member) /// 
   order (union_member econ_college econ_college_union_member)  mtitles ("" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


* Table A14 (Effectf of Union Membership Conditional on Economic Knowledge): Not Strongly Protectionist Unions

eststo clear

eststo: dprobit trade_reduction union_member econ_college educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_reduction union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_reduction union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `econcontrol' if govt_owned == 0 & protectionism==0, robust 

eststo: dprobit trade_self union_member econ_college educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_self union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_self union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `econcontrol' if govt_owned == 0 &  protectionism==0, robust 

eststo: dprobit trade_us union_member econ_college educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_us union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 if govt_owned == 0 & protectionism==0, robust
eststo: dprobit trade_us union_member econ_college econ_college_union_member educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12 `econcontrol' if govt_owned == 0 & protectionism==0, robust 

esttab using "TableA14_EconEduInteractionLess.tex", booktabs margin label title (Effect of Union Membership on Attitudes toward Trade Conditional on Economic Knowledge \label{interaction1}) ///
   keep (union_member econ_college econ_college_union_member) /// 
   order (union_member econ_college econ_college_union_member)  mtitles ("" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


* Table A15 (Union’s Protectionism Stance, Economic Success and Members’ View on Trade)

gen log_union_spending_pc = log(union_spending_pc)
label var log_union_spending_pc "Per Member Union Spending, Logged"

gen score_spending_logpc =  log_union_spending_pc * union_score
label var score_spending_logpc "Protectionism Score * Per Member Spending"

eststo clear

eststo: dprobit trade_reduction union_score log_union_spending_pc  
eststo: dprobit trade_reduction union_score log_union_spending_pc score_spending_logpc 
eststo: dprobit trade_reduction union_score log_union_spending_pc score_spending_logpc educ age family_income female white black hispanic married 

eststo: dprobit trade_self union_score log_union_spending_pc  
eststo: dprobit trade_self union_score log_union_spending_pc score_spending_logpc 
eststo: dprobit trade_self union_score log_union_spending_pc score_spending_logpc educ age family_income female white black hispanic married 

eststo: dprobit trade_us union_score log_union_spending_pc  
eststo: dprobit trade_us union_score log_union_spending_pc score_spending_logpc 
eststo: dprobit trade_us union_score log_union_spending_pc score_spending_logpc educ age family_income female white black hispanic married 

esttab using "TableA15_Spending.tex", booktabs margin label title (Union's Protectionism Stance and Members' View on Trade \label{uniononly}) ///
   keep (union_score log_union_spending_pc score_spending_logpc) order (union_score log_union_spending_pc score_spending_logpc)  mtitles ("" "" "" "" "" "" "" "" "") ///
   stats(N, labels(Observations) fmt(0)) nodepvars se(3) b(3) replace star(* 0.10 ** 0.05 *** 0.01) compress nogaps


* Table A16 (Unobservable Selection: Identification of Lower Bound of Treatment Effect)
	* Note: In order to replicate the following analysis, you need to install psscalc (by Emily Oster); the file is available at:http://fmwww.bc.edu/repec/bocode/p/psacalc.ado

findit psacalc

keep if protectionism==1 & govt_owned == 0 & family_income!=.
	
* Strongly Protectionist Unions

regress trade_reduction union_member /* Baseline */
regress trade_reduction union_member rtw educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12  /* Controlled */
display e(r2)*2.2
psacalc union_member beta, rmax(.13062443) 

regress trade_self union_member /* Baseline */
regress trade_self union_member rtw educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12  /* Controlled */
display e(r2)*2.2
psacalc union_member beta, rmax(.095681) 

regress trade_us union_member /* Baseline */
regress trade_us union_member rtw educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12  /* Controlled */
display e(r2)*2.2
psacalc union_member beta, rmax(.09893663) 

* Not Strongly Protectionist Unions

clear 
use "UnionInformation_ReplicationData.dta"

keep if employ1 == 1 /* keep observations that are currently employed */

gen trade_reduction=0 /* creating DVs */
replace trade_reduction = 1 if trade4 == 4 | trade4==5

gen trade_self=0 /* creating DVs */
replace trade_self= 1 if trade1 == 4 | trade1 == 5

gen trade_us=0 /* creating DVs */
replace trade_us = 1 if trade3 == 4 | trade3 == 5
tab naics, gen(industry_dummy) /* creating industry dummies */

gen female = 0 
replace female = 1 if gender == 2 /* creating female dummy */

gen white = 0 
replace white = 1 if race ==1 /* creating white dummy for race */

gen black = 0
replace black = 1 if race ==2 /* creating black dummy for race */

gen hispanic = 0
replace hispanic = 1 if race ==3 /* creating hispanic dummy for race */

gen age = 2011 - birthyr /* creating age variable as of 2011 */

keep if protectionism==0 & govt_owned == 0 & family_income!=.

regress trade_reduction union_member /* Baseline */
regress trade_reduction union_member rtw educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12  /* Controlled */
display e(r2)*2.2
psacalc union_member beta, rmax(.23663513) 

regress trade_self union_member /* Baseline */
regress trade_self union_member rtw educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12  /* Controlled */
display e(r2)*2.2
psacalc union_member beta, rmax(.13381159) 

regress trade_us union_member /* Baseline */
regress trade_us union_member rtw educ age family_income female white black hispanic married industry_dummy1 - industry_dummy12  /* Controlled */
display e(r2)*2.2
psacalc union_member beta, rmax(.19135272) 


