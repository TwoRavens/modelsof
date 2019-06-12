clear
drop _all
set more off
capture mkdir tables_replicated


*Table A1
**********
use table_A1.dta, clear

collapse (mean) career_duration productivity usa number_of_coauthors number_different_locations, by(mgp)

replace usa=usa*100

format career_duration productivity usa number_of_coauthors number_different_locations %12.1f

local values "career_duration productivity usa number_of_coauthors number_different_locations"
foreach vv of local values{

replace `vv'=`vv'*10
replace `vv'=int(`vv')
replace `vv'=`vv'/10
}

format career_duration productivity usa number_of_coauthors number_different_locations %12.1f
ge measure="Mean"
save mean, replace

use table_A1.dta, clear
collapse (sd) career_duration number_different_locations usa  number_of_coauthors productivity , by(mgp)
ge measure="standard deviation"
format career_duration productivity usa number_of_coauthors number_different_locations %12.1f

append using mean


rename mgp author
tostring author, replace
replace author="MGP" if author=="1"
replace author="Non-MGP" if author=="0"

label var author "Author"
label var career_duration "Career duration"
label var productivity "Productivity"
label var usa "USA"
label var number_of_coauthors "# coauthors"
label var number_different_locations "# institutions"

sort author measure

texsave author career_duration number_different_locations usa number_of_coauthors productivity   ///
using tables_replicated/table_A1.tex, replace title(MGP vs. non-MGP author sample)  ///
align(l c c c c c) varlabel
rm mean.dta


*Table A3
**********
use mf4_fai_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  
gen byte distgt0 = dist_i>0   
keep if year_o>=1980

gen column=1 if DVprob==1
replace column=3 if DVprob==0
collapse (mean) distgt0 lndist_i b_n_i lang_i co_authors coincided_year worked_same_institution, by(column)
list
save temp, replace

use mf4_fai_ex_gf.dta , clear 
keep if valid_mgp_plus==1
replace lndist_i = ln(1) if dist_i==0  
gen byte distgt0 = dist_i>0   
keep if year_o>=1980

gen column=2 if DVprob==1
replace column=4 if DVprob==0
collapse (mean) distgt0 lndist_i b_n_i lang_i co_authors coincided_year worked_same_institution, by(column)
append using temp
sort column
list
rm temp.dta


*Table 1 & Table E1 & Table D.1.  (It does not create Table 1.tex, since it was formatted by hand to fit the page)
*******************************
clear
drop _all
eststo clear

****macros for the RHS.
*2part
global geo "distgt0  lndist_i b_n_i lang_i "  
*12 step
global geo12 "i.distint_i b_n_i lang_i "   
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 
use mf4_fai_gf.dta , clear 

replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"
label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"
label var no_shared_assoc "No shared association"
save temp0, replace

// spec 1: whole sample + only geography
eststo spec1: clogit DVprob $geo, group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)


// spec 2: whole sample + geography + network
set more off
eststo spec2: clogit DVprob $geo $ties_wos , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// geo variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

*WOS ties
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
*MGP ties
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"

label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"

save temp, replace
*** non-MGP sample
use temp0, clear
* combined spec
eststo spec1c:  clogit  DVprob $geo , group(triad)  cluster(code_art_d) 
eststo spec2b: clogit DVprob $geo $ties_wos , group(triad)  cluster(code_art_d) 

use temp0, clear
keep if valid_mgp_plus==0

eststo spec1a:  clogit  DVprob $geo , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

eststo spec2a: clogit DVprob $geo $ties_wos , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

use temp0, clear
keep if valid_mgp_plus==1
eststo spec1b:  clogit  DVprob $geo , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

eststo spec2b: clogit DVprob $geo $ties_wos , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)


*** MGP sample
use temp, clear
keep if valid_mgp_plus==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
// spec 3: 
eststo spec3:  clogit  DVprob $geo , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

//spec 4: spec 3 but with 12step instead of 2part.
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
table distint_i, c(min dist_i max dist_i mean dist_i count dist_i)
eststo spec4: clogit DVprob $geo12, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)


// spec 5: 
eststo spec5:  clogit  DVprob $geo  $ties_wos $ties_mgp, group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)

// spec 6:  spec 5 with 12step instead of 2part.
eststo spec6:  clogit  DVprob $geo12 $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

* make the baseline table and the MGP vs non-MGP table (for appendix)
set linesize 255
esttab spec1 spec2 spec3 spec4 spec5 spec6 using "tables_replicated/tableE1.tex", replace scalar(rsq aic) b(3) se(3) starlevels($^{\sim}$ 0.1  $^\dagger$ 0.05  $^{\star}$ 0.01)  label

*       Gmgp   Gnon   GTmpg  GTnon
esttab spec1b spec1a spec2b  spec2a using "tables_replicated/tableD1.tex", replace  scalar(rsq aic) b(3) se(3) starlevels($^{\sim}$ 0.1  $^\dagger$ 0.05  $^{\star}$ 0.01)  label
rm temp.dta
rm temp0.dta
 
 
 
 *Table B.1: The average effect of ties coefficient is listed, but it is not included in the .tex table
*************************************************************************************
 clear
drop _all
global geo "distgt0  lndist_i b_n_i lang_i "  // 2 part
global geo12 "i.distint_i b_n_i lang_i "   // 12 step
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years  phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 
* 3 + 11 = 14 ties.

eststo clear
use mf0_fai_ex25_gf.dta , clear 

replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

keep if valid_mgp_plus==1
egen triad = group(year_o code_art_d)  // nil-year-article d

eststo nil: clogit DVprob $geo $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)
 
 
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution])/3
estadd scalar ave_careertie = r(estimate)
estadd scalar ave_careertie_se = r(se)
di "average career link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


lincom (_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing]  + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/11
estadd scalar ave_edutie = r(estimate)
estadd scalar ave_edutie_se = r(se)
di "average edu link increase in odds ratio  =  " round(exp(r(estimate)),0.01)




***column 2 of sensitivity table:
 use mf1_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


keep if valid_mgp_plus==1  // currently losing all data!
egen triad = group(journal_o year_o code_art_d)  // journal-year-article d

eststo journal: clogit DVprob $geo $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
 di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)
 
 lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution])/3
estadd scalar ave_careertie = r(estimate)
estadd scalar ave_careertie_se = r(se)
di "average career link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


lincom (_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing]  + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/11
estadd scalar ave_edutie = r(estimate)
estadd scalar ave_edutie_se = r(se)
di "average edu link increase in odds ratio  =  " round(exp(r(estimate)),0.01)

use mf4_fai_ex_gf.dta, clear 
keep if valid_mgp_plus==1
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


merge 1:1 DVprob code_art code_art_d using cocitation_mf4_fai_ex_gf.dta
keep if _merge==3
drop _merge
gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // msc3-year-article d

gen byte cocitation=cocite>0


label var cocitation "Cocitation"

eststo msc3: clogit DVprob $geo $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
 di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)
 
 
 lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution])/3
estadd scalar ave_careertie = r(estimate)
estadd scalar ave_careertie_se = r(se)
di "average career link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


lincom (_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing]  + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/11
estadd scalar ave_edutie = r(estimate)
estadd scalar ave_edutie_se = r(se)
di "average edu link increase in odds ratio  =  " round(exp(r(estimate)),0.01)

// mf4_fai_ex_gf + cocitation
eststo msc3_co: clogit DVprob $geo $ties_wos $ties_mgp cocitation, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
 di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)

lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution])/3
estadd scalar ave_careertie = r(estimate)
estadd scalar ave_careertie_se = r(se)
di "average career link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


lincom (_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing]  + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/11
estadd scalar ave_edutie = r(estimate)
estadd scalar ave_edutie_se = r(se)
di "average edu link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


// col 4: MSC-5d + cocitation: mf5_fai_ex_gf 
use mf5_fai_ex_gf.dta , clear 

replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
egen triad = group(field_o year_o code_art_d)  // msc5-year-article d

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


merge 1:1 DVprob code_art code_art_d using cocitation_mf5_fai_ex_gf.dta
keep if valid_mgp_plus==1  // all _merge=3 (good)
drop _merge
gen byte cocitation=cocite>0

label var cocitation "Cocitation"

eststo msc5: clogit DVprob $geo $ties_wos $ties_mgp cocitation, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
 di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)

 lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution])/3
estadd scalar ave_careertie = r(estimate)
estadd scalar ave_careertie_se = r(se)
di "average career link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


lincom (_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing]  + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/11
estadd scalar ave_edutie = r(estimate)
estadd scalar ave_edutie_se = r(se)
di "average edu link increase in odds ratio  =  " round(exp(r(estimate)),0.01)

// col 5: keyword: mf2_fai_ex_gf (26587 observations)
use mf2_fai_ex_gf.dta, clear 

replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
egen triad = group(keyword_o year_o code_art_d)  // msc3-year-article d

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


merge 1:1 DVprob code_art code_art_d using cocitation_mf2_fai_ex_gf.dta
keep if _merge==3 
drop _merge
keep if valid_mgp_plus==1
gen byte cocitation=cocite>0

label var cocitation "Cocitation"
label var same_field_5d "Same 5-digit MSC"

eststo key: clogit DVprob $geo $ties_wos $ties_mgp cocitation, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
 di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)

 
 lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution])/3
estadd scalar ave_careertie = r(estimate)
estadd scalar ave_careertie_se = r(se)
di "average career link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


lincom (_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing]  + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/11
estadd scalar ave_edutie = r(estimate)
estadd scalar ave_edutie_se = r(se)
di "average edu link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


esttab nil journal msc3 msc3_co msc5 key using tables_replicated/tableb1.tex,    ///
keep($geo cocitation) replace scalar(rsq aic bic ave_network ave_network_se ave_careertie ave_careertie_se    ///
ave_edutie ave_edutie_se) b(3) se(3)  starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label



*Table 2  (average effect of ties is listed but not included in table2.tex ) &  summary statistics for Table E.2
**************************************************************************************************
clear
drop _all

global geo "distgt0  lndist_i b_n_i lang_i "  
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 

eststo clear

// column 1 without interaction; column 2-3 for obscure (defined by median <=5); col 4-5 for recent (defined by median <=9); col 6-7 for different field.  

// Column 1:
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE


eststo all: clogit  DVprob $geo $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

//-postfile-
tempname hdle
cap erase "results/interaction_lincom.dta"

postfile `hdle' est se   /*
*/ using "results/interaction_lincom.dta"

* 2 sets of lincoms
*ties (get rid of gf)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]   + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13
post `hdle' (r(estimate)) (r(se))
* dummy geo base
lincom (_b[distgt0] +_b[b_n_i]+_b[lang_i])/3
post `hdle' (r(estimate)) (r(se))

// three specifications: 
// spec 1: interact with less known dummy; column 2-3 for obscure (defined by median <=3)
use mf_cites.dta, clear 
gen int totcites =1
collapse (sum) totcites , by(code_art_d)
sum totcites, d
sort totcites
gen pctile = _n/(_N+1)
gen byte obscure = totcites<=3  
keep code_art_d obscure
sort code_art_d
save temp, replace

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

merge m:1 code_art_d using temp
replace obscure=1 if _merge==1
drop if _merge==2
drop _merge
table year_o, c(mean obscure)

*Some summary statistics for Table C.3
codebook obscure if DVprob==1
codebook obscure if DVprob==0

gen comb = co_authors + coincided_year +worked_same_institution + phd_same_school_5years + phd_siblings + phd_cousins + advisor_citing + advisor_cited + gf_citing + gf_cited +uncle_citing +uncle_cited+ affciting_sccited_i + affcited_scciting_i 


bys code_art_d: egen ncites=count(code_art) if DVprob==1
gsort code_art_d -ncites
replace ncites=ncites[_n-1] if code_art_d==code_art_d[_n-1] & ncites==.

*Obscure & DVprob==1
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if obscure==1 & DVprob==1

*Non-Obscure and DVprob==1
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if obscure==0 & DVprob==1

*Obscure & DVprob==0
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if obscure==1 & DVprob==0

*Non-Obscure and DVprob==0
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if obscure==0 & DVprob==0

*Obscure & DVprob==All
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if obscure==1

*Non-Obscure and DVprob==All
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if obscure==0



foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*obscure
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo obscure: clogit DVprob  $geo $ties_wos $ties_mgp *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*sets of lincoms
*ties 
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]   + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13
post `hdle' (r(estimate)) (r(se))

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]    + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
post `hdle' (r(estimate)) (r(se))


// spec 2: interact with recent dummy; col 4-5 for recent (defined by median <=9)
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


gen age=year_o-year_d
replace age=0 if age==-1

// using age=9 (median) as threshold
gen byte recent = age<=9

*Some summary statistics for Table C.3
codebook recent if DVprob==1

bys code_art_d: egen ncites=count(code_art) if DVprob==1
gsort code_art_d -ncites
replace ncites=ncites[_n-1] if code_art_d==code_art_d[_n-1] & ncites==.

gen comb = co_authors + coincided_year +worked_same_institution + phd_same_school_5years + phd_siblings + phd_cousins + advisor_citing + advisor_cited + gf_citing + gf_cited +uncle_citing +uncle_cited+ affciting_sccited_i + affcited_scciting_i 

*Recent - DVprob==1
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if recent==1 & DVprob==1

*Non-recent - DVprob==1
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if recent==0 & DVprob==1

*Recent - DVprob==0
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if recent==1 & DVprob==0

*Non-recent - DVprob==0
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if recent==0 & DVprob==0

*Recent - DVprob==All
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if recent==1 

*Non-recent - DVprob==All
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if recent==0 


**generate interaction terms

foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*recent
}


gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo recent: clogit DVprob $geo $ties_wos $ties_mgp *_x   , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*sets of lincoms
*ties 
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]    + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13
post `hdle' (r(estimate)) (r(se))

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]    + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
post `hdle' (r(estimate)) (r(se))

// spec 3: interact with diff_field2 (using 2 digit MSC); col 6-7 for different field
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

gen fd_3o=substr(field_o, 1,3)
gen fd_2o = substr(field_o, 1,2)
gen fd_3d = substr(field_d, 1,3)
gen fd_2d=substr(field_d, 1,2)
drop if field_o==""
drop if field_d==""
gen byte diff_fd2 = fd_2d != fd_2o
gen byte diff_fd3 = fd_3d != fd_3o
gen byte diff_fd5 = field_o != field_d

*Some summary statistics
codebook diff_fd2 if DVprob==1

bys code_art_d: egen ncites=count(code_art) if DVprob==1
gsort code_art_d -ncites
replace ncites=ncites[_n-1] if code_art_d==code_art_d[_n-1] & ncites==.

gen comb = co_authors + coincided_year +worked_same_institution + phd_same_school_5years + phd_siblings + phd_cousins + advisor_citing + advisor_cited + gf_citing + gf_cited +uncle_citing +uncle_cited+ affciting_sccited_i + affcited_scciting_i 

*Different field - DVprob==1
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if diff_fd2==1 & DVprob==1

*Same field - DVprob==1
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if diff_fd2==0 & DVprob==1

*Different field - DVprob==0
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if diff_fd2==1 & DVprob==0

*Same field - DVprob==0
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if diff_fd2==0 & DVprob==0

*Different field - DVprob==All
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if diff_fd2==1 

*Same field - DVprob==All
summarize dist_i ncites  comb co_authors coincided_year worked_same_institution phd_same_school_5years phd_siblings phd_cousins  ///
advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i if diff_fd2==0 


foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*diff_fd2
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
eststo diff_fd2: clogit DVprob $geo $ties_wos $ties_mgp *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
*sets of lincoms
*ties (get rid of gf)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] /* + _b[gf_citing] */ + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13
post `hdle' (r(estimate)) (r(se))

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x] /* + _b[gf_citing_x] */ + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
post `hdle' (r(estimate)) (r(se))


**************create table************
esttab all obscure recent diff_fd2 using tables_replicated/table2.tex, replace  scalar(rsq aic bic)  b(3) se(3) starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label



*Table C.1
************
use conference_participation, clear

*Regressions
*All years pooled. Year fixed-effects
*logit attend different_location lndist different_state different_country different_language i.year, vce(robust)
logit attend different_location lndist different_country canada different_language i.year, vce(cluster loc_pair)
estadd local yfe "Yes"
estadd local afe "No"
local k=e(N)
estadd local num_n `k'
local t=e(r2_p)
estadd local pseudo `t'
estadd local mmodel "Logit"
est store reg1

clogit attend different_location lndist different_country canada different_language i.year, group(author_o_id) vce(cluster author_o_id) 
estadd local yfe "Yes"
estadd local afe "Yes"
local k=e(N)
estadd local num_n `k'
local t=e(r2_p)
estadd local pseudo `t'
estadd local mmodel "Logit"
est store reg2

reg attend different_location lndist different_country canada different_language i.year, vce(cluster loc_pair)
estadd local yfe "Yes"
estadd local afe "No"
local k=e(N)
estadd local num_n `k'
local t=e(r2_p)
estadd local pseudo `t'
estadd local mmodel "LPM"
est store reg3


xtreg attend different_location lndist different_country canada different_language i.year, fe i(author_o_id) vce(cluster author_o_id) 
estadd local yfe "Yes"
estadd local afe "Yes"
local k=e(N)
estadd local num_n `k'
local t=e(r2_p)
estadd local pseudo `t'
estadd local mmodel "LPM"
est store reg4


esttab reg1 reg2 reg3 reg4 using tables_replicated/tablec1.tex,  ///
keep(different_location lndist different_country canada different_language)   ///
starlevels($^{\sim}$ 0.1  $^\dagger$ 0.05  $^{\star}$ 0.01) b(3) se(3) label replace nonotes nocons compress   ///
nogaps nomtitles eqlabels(none) /// 
s(num_n afe mmodel, label( "N. obs."   "Participant FE" "Model"))  


*Summary statistics for Table C.2 and Table C.3
************************************************
use mf4_fai_ex_gf_conferences.dta, clear 
keep code_art code_art_d conference_coincidences conference_session_coincidences  conference_paperd_coincidences    ///
conference_paperc_coincidences   
merge 1:1 code_art code_art_d using mf4_fai_ex_gf
keep if _merge==3
drop _merge


*Transform the conference variables into 0-1 variables. Previously they measured the number of times authors coincide
replace conference_coincidences=1 if conference_coincidences>0 
replace conference_session_coincidences=1 if conference_session_coincidences>0 
replace conference_paperd_coincidences=1 if conference_paperd_coincidences>0 
replace  conference_paperc_coincidences=1 if conference_paperc_coincidences>0 


****macros for the RHS.
*2part
global geo "distgt0  lndist_i b_n_i lang_i "  

*12 step
global geo12 "i.distint_i b_n_i lang_i "   
global ties_wos "co_authors coincided_year worked_same_institution"  

*we could include phd same school: global ties_mgp "phd_same_school_5years phd_same_school phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited  affciting_sccited_i affcited_scciting_i" 
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 

global conference "conference_coincidences conference_session_coincidences  conference_paperd_coincidences conference_paperc_coincidences"
 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// geo variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"

*WOS ties
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
*MGP ties
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"

label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"

***Conference variables
label var conference_coincidences "Coincided conference"
label var conference_session_coincidences "Coincided conference+session"
label var conference_paperd_coincidences "Coincided conference cited paper presented"
label var conference_paperc_coincidences "Coincided conference citing paper presented"

*** MGP sample
keep if valid_mgp_plus==1

*Descriptives
*Total
bys DVprob: count /* Number of actual citations*/
bys DVprob: count if conference_coincidences>0 /*Number of cases where any citing-cited author pair coincided in a conference*/
bys DVprob: count if conference_session_coincidences>0 /*Number of cases where any citing-cited author pair coincided in the same session in a conference*/
bys DVprob: count if conference_paperd_coincidences>0 /*Number of cases where any citing-cited author pair coincided in a conference where the cited paper was presented*/
bys DVprob: count if conference_paperc_coincidences>0 /*Number of cases where any citing-cited author pair coincided in a conference where the citing paper was presented*/

*Mean
bys DVprob: egen mconference_coincidences=mean(conference_coincidences)
bys DVprob: egen mconference_session_coincidences=mean(conference_session_coincidences)
bys DVprob: egen mconference_paperd_coincidences=mean(conference_paperd_coincidences)
bys DVprob: egen mconference_paperc_coincidences=mean(conference_paperc_coincidences)

sort DVprob
list mconference_coincidences mconference_session_coincidences mconference_paperd_coincidences  mconference_paperc_coincidences  in 1 if DVprob==0

gsort -DVprob
list mconference_coincidences mconference_session_coincidences mconference_paperd_coincidences ///
mconference_paperc_coincidences in 1 if DVprob==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE


eststo spec2a: clogit  DVprob $geo  $ties_wos $ties_mgp conference_coincidences conference_session_coincidences  ///
conference_paperd_coincidences conference_paperc_coincidences, group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)

eststo spec2b: xtreg  DVprob $geo  $ties_wos $ties_mgp conference_coincidences  conference_session_coincidences ///
conference_paperd_coincidences conference_paperc_coincidences, fe i(triad)  vce(cluster code_art_d)
estadd scalar rsq = e(r2_o)


*set linesize 255
esttab spec2a spec2b  using tables_replicated/tablec3.tex, replace  b(3) se(3)  nocons nodep mti("Logit" "LPM")   ///
starlevels($^{\sim}$ 0.1  $^\dagger$ 0.05  $^{\star}$ 0.01)  label s(rsq, label("pseudo-R2 or R2" ))





*Table D2
***********
clear
drop _all
eststo clear

*2part
global geo "distgt0  lndist_i b_n_i lang_i no_shared_assoc "  
*12 step
global geo12 "i.distint_i b_n_i lang_i no_shared_assoc"   
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 

use mf4_fai_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"
label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"
label var no_shared_assoc "No shared association"
save temp0, replace

// spec 1: whole sample + only geography
eststo spec1: clogit DVprob $geo, group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

// spec 2: whole sample + geography + network
set more off
eststo spec2: clogit DVprob $geo $ties_wos , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// geo variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

*WOS ties
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"

*MGP ties
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"

label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"

keep if valid_mgp_plus==1
gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

//spec 3
eststo spec3:  clogit  DVprob $geo , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

// spec 4: 
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
table distint_i, c(min dist_i max dist_i mean dist_i count dist_i)
eststo spec4:  clogit  DVprob $geo12 , group(triad)  cluster(code_art_d) 

// spec 5: 
set more off
eststo spec5:  clogit  DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)

// spec 6:  spec 5 with 12step instead of 2part.
eststo spec6:  clogit  DVprob $geo12 $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

set linesize 255
esttab spec1 spec2 spec3 spec4 spec5 spec6 using tables_replicated/tabled2.tex, replace scalar(rsq aic) b(3) se(3) starlevels($^{\sim}$ 0.1  $^\dagger$ 0.05  $^{\star}$ 0.01)  label



*Table D.3
**********
clear
drop _all
eststo clear
****macros for the RHS.
*2part
global geo "distgt0  lndist_i b_n_i lang_i "  
*12 step
global geo12 "i.distint_i b_n_i lang_i "   
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 
use mf4_fai_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
*
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"
label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"
label var no_shared_assoc "No shared association"
save temp0, replace
// spec 1: whole sample + only geography
eststo spec1: xtreg DVprob $geo, fe i(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_o)
// spec 2: whole sample + geography + network
set more off
eststo spec2: xtreg DVprob $geo $ties_wos , fe i(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_o)
***************************move to ex file (all control obs available for mgp fai sample
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
// geo variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

*WOS ties
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
*MGP ties
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"

label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"


*** MGP sample
keep if valid_mgp_plus==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
// spec 3: 
eststo spec3:  xtreg  DVprob $geo , fe i(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_o)

egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
table distint_i, c(min dist_i max dist_i mean dist_i count dist_i)

// spec 4: spec 3 but with 12step instead of 2part.
eststo spec4: xtreg DVprob $geo12, fe i(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_o)

// spec 5: 
eststo spec5:  xtreg DVprob $geo  $ties_wos $ties_mgp , fe i(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_o)

// spec 6:  spec 5 with 12step instead of 2part.
eststo spec6:  xtreg  DVprob $geo12 $ties_wos $ties_mgp , fe i(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_o)

set linesize 255
esttab spec1 spec2 spec3 spec4 spec5 spec6 using tables_replicated/tabled3.tex, replace scalar(rsq aic) b(3) se(3) starlevels($^{\sim}$ 0.1  $^\dagger$ 0.05  $^{\star}$ 0.01)  label




*Table D.4. Creates 5 sub-tables reporting all coefficients. Average effect of ties and geography indicators are listed but not included in the tables
**************************************************************************************************************************************
clear
drop _all

global geo "distgt0  lndist_i b_n_i lang_i "  
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 

set more off



*ROW 1: WOS sample
*********************
*1.1. WOS - Obscure (defined by median <=3)
use mf_cites.dta, clear 
gen int totcites =1
collapse (sum) totcites , by(code_art_d)
sum totcites, d
sort totcites
gen byte obscure = totcites<=3  
keep code_art_d obscure
sort code_art_d
save temp, replace

use mf4_fai_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

merge m:1 code_art_d using temp
replace obscure=1 if _merge==1
drop if _merge==2
drop _merge

foreach var of varlist $geo $ties_wos {
gen `var'_x = `var'*obscure
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  //

eststo WOS1: clogit DVprob  $geo $ties_wos *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)


*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x])/3
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3
drop *_x


*1.2. WOS - Recent
gen age=year_o-year_d
replace age=0 if age==-1

// using age=9 (median) as threshold
gen byte recent = age<=9

foreach var of varlist $ties_wos $geo {
gen `var'_x = `var'*recent
}

eststo WOS2: clogit DVprob  $geo $ties_wos *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x])/3
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

drop *_x

*1.3. WOS - Different field
gen fd_2o = substr(field_o, 1,2)
gen fd_2d=substr(field_d, 1,2)
drop if field_o==""
drop if field_d==""
gen byte diff_fd2 = fd_2d != fd_2o

foreach var of varlist $ties_wos $geo {
gen `var'_x = `var'*diff_fd2
}

eststo WOS3: clogit DVprob  $geo $ties_wos *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x])/3
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3
drop *_x

**************create tables************
esttab WOS1 WOS2 WOS3 using tables_replicated/tabled4_WOS.tex, replace  scalar(rsq aic bic)  b(3) se(3) starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label



*ROW 2: LPM  /*gf_citing & i_gf_citing not included*/
******************************************************
*2.1 LPM - Obscure
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1

merge m:1 code_art_d using temp
replace obscure=1 if _merge==1
drop if _merge==2
drop _merge

foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*obscure
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  //

eststo LPM1: xtreg DVprob $geo $ties_wos $ties_mgp *_x, fe i(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2)


*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] +    ///
_b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]  +  _b[gf_cited_x] + _b[uncle_citing_x]    ///
 + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

 drop *_x


 *2.2. LPM - Recent
gen age=year_o-year_d
replace age=0 if age==-1

// using age=9 (median) as threshold
gen byte recent = age<=9

foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*recent
}

eststo LPM2: xtreg DVprob $geo $ties_wos $ties_mgp *_x, fe i(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2)


*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] +    ///
_b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]  +  _b[gf_cited_x] + _b[uncle_citing_x]    ///
 + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

 drop *_x


*2.3. LPM - Different field
gen fd_2o = substr(field_o, 1,2)
gen fd_2d=substr(field_d, 1,2)
drop if field_o==""
drop if field_d==""
gen byte diff_fd2 = fd_2d != fd_2o

foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*diff_fd2
}

eststo LPM3: xtreg DVprob $geo $ties_wos $ties_mgp *_x, fe i(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2)


*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] +    ///
_b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]  +  _b[gf_cited_x] + _b[uncle_citing_x]    ///
 + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

 drop *_x

**************create tables************
esttab LPM1 LPM2 LPM3 using tables_replicated/tabled4_LPM.tex, replace  scalar(rsq aic bic)  b(3) se(3) starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label



 *ROW 3: SUM of TIES 
 *gf_citing & i_gf_citing included
 *********************************************************
*3.1 Sum of ties - Obscure
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1

merge m:1 code_art_d using temp
replace obscure=1 if _merge==1
drop if _merge==2
drop _merge

gen sum_ties = co_authors + coincided_year +worked_same_institution + phd_same_school_5years + phd_siblings +   ///
phd_cousins + advisor_citing + advisor_cited + gf_citing + gf_cited +uncle_citing +uncle_cited+ affciting_sccited_i +    ///
affcited_scciting_i 

gen sum_geo = distgt0 + b_n_i + lang_i

gen sum_ties_x = sum_ties*obscure
gen sum_geo_x = sum_geo*obscure
gen dist_x = lndist_i*obscure

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  //

eststo sum1: clogit DVprob  lndist_i dist_x  sum_geo sum_geo_x sum_ties sum_ties_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
drop sum_ties_x sum_geo_x dist_x



 *3.2. Sum of ties  - Recent
gen age=year_o-year_d
replace age=0 if age==-1

// using age=9 (median) as threshold
gen byte recent = age<=9

gen sum_ties_x = sum_ties*recent
gen sum_geo_x = sum_geo*recent
gen dist_x = lndist_i*recent

eststo sum2: clogit DVprob  lndist_i dist_x  sum_geo sum_geo_x sum_ties sum_ties_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

drop sum_ties_x sum_geo_x dist_x


*3.3. Sum of ties - Different field
gen fd_2o = substr(field_o, 1,2)
gen fd_2d=substr(field_d, 1,2)
drop if field_o==""
drop if field_d==""
gen byte diff_fd2 = fd_2d != fd_2o

gen sum_ties_x = sum_ties*diff_fd2
gen sum_geo_x = sum_geo*diff_fd2
gen dist_x = lndist_i*diff_fd2

eststo sum3: clogit DVprob  lndist_i dist_x  sum_geo sum_geo_x sum_ties sum_ties_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

drop sum_ties_x sum_geo_x dist_x

**************create tables************
esttab sum1 sum2 sum3 using tables_replicated/tabled4_sum.tex, replace  scalar(rsq aic bic)  b(3) se(3) starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label


*ROW 4: Means
*****************
*4.1. Means - Obscure
use mf_cites.dta , clear 
gen int totcites =1
collapse (sum) totcites , by(code_art_d)
sum totcites, d
gen byte obscure = totcites <=r(mean) //mean is 6
keep code_art_d obscure
sort code_art_d
save temp, replace

use mf4_fai_ex_gf.dta , clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1

merge m:1 code_art_d using temp
replace obscure=1 if _merge==1
drop if _merge==2
drop _merge

foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*obscure
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  //

eststo mean1: clogit DVprob $geo $ties_wos $ties_mgp *_x, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] +    ///
_b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]  +  _b[gf_cited_x] + _b[uncle_citing_x]    ///
 + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

 drop *_x


*4.2: Means - Recent
gen age=year_o-year_d
replace age=0 if age==-1
sum age
gen byte recent = age <= r(mean) // mean is 11, very similar results to median

foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*recent
}

eststo mean2: clogit DVprob $geo $ties_wos $ties_mgp *_x, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)


*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] +    ///
_b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]  +  _b[gf_cited_x] + _b[uncle_citing_x]    ///
 + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

 drop *_x

 
 
 *4.3. Means  - Different 3-digit field
gen fd_3o = substr(field_o, 1,3)
gen fd_3d=substr(field_d, 1,3)
drop if field_o==""
drop if field_d==""
gen byte diff_fd3 = fd_3d != fd_3o
 
 
foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*diff_fd3
}

eststo mean3: clogit DVprob $geo $ties_wos $ties_mgp *_x, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] +    ///
_b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]  +  _b[gf_cited_x] + _b[uncle_citing_x]    ///
 + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

 drop *_x
 

 **************create tables************
esttab mean1 mean2 mean3 using tables_replicated/tabled4_mean.tex, replace  scalar(rsq aic bic)  b(3) se(3) starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label



 
 *ROW 5: Continuous measures of the interaction variables
********************************************************
*5.1.  Continuous Obscure
use mf_cites.dta, clear 
gen int totcites =1
collapse (sum) totcites , by(code_art_d)
 tab totcites if totcites <=12
sum totcites
sort totcites
gen cites_ecdf = (_n-0.3)/(_N+0.4)
gen obscure = 1-cites_ecdf // bounded between 0 and 1
keep code_art_d obscure
sort code_art_d
save temp, replace

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1

merge m:1 code_art_d using temp
replace obscure=1 if _merge==1
drop if _merge==2
drop _merge

foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*obscure
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  //

eststo cont1: clogit DVprob $geo $ties_wos $ties_mgp *_x, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] +    ///
_b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]  +  _b[gf_cited_x] + _b[uncle_citing_x]    ///
 + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

 drop *_x


*5.2: Continuous  - Recent
gen age=year_o-year_d
replace age=0 if age==-1
sum age
sort age
gen age_ecdf =(_n-0.3)/(_N+0.4)
gen recent = 1-age_ecdf


foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*recent
}

eststo cont2: clogit DVprob $geo $ties_wos $ties_mgp *_x, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*interaction_ties lincom
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] +    ///
_b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]  +  _b[gf_cited_x] + _b[uncle_citing_x]    ///
 + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13
*interaction_geo dummy lincom
lincom (_b[distgt0_x] +_b[b_n_i_x]+_b[lang_i_x])/3

 drop *_x

 
 
 *5.3. Differences in 2, 3 and 5-digit fields
drop if field_o=="". // none dropped
drop if field_d=="" // 216 ths dropped
gen fd_2o = substr(field_o, 1,2)
gen fd_2d=substr(field_d, 1,2)

gen fd_3o = substr(field_o, 1,3)
gen fd_3d=substr(field_d, 1,3)
 
gen fd_5o = substr(field_o, 1,5)
gen fd_5d=substr(field_d, 1,5)

ge diff_field=0
replace diff_field=1 if fd_5o!=fd_5d
replace diff_field=2 if fd_3o!=fd_3d
replace diff_field=3 if fd_2o!=fd_2d


 
foreach var of varlist $geo $ties_wos $ties_mgp{
gen `var'_x = `var'*diff_field
}

** note: we added diff_field as a "main" (direct) effect, since there is variation within triad for citing papers with a different 5-d field
*********we see it is very strong negative. and now the positive interaction is restored.
gen diff_5only =  (fd_5o!=fd_5d) &  (fd_3o==fd_3d)
eststo cont3: clogit DVprob diff_5only $geo $ties_wos $ties_mgp *_x, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)


**************create tables************
esttab cont1 cont2 cont3 using tables_replicated/tabled4_cont.tex, replace  scalar(rsq aic bic)  b(3) se(3) starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label




*Table D.5
**********
clear
drop _all
eststo clear

global SPLITYEAR = 2005 

set more off

****macros for the RHS.
*2part
global geo "distgt0  lndist_i b_n_i lang_i "  
*12 step
global geo12 "i.distint_i b_n_i lang_i "   
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 
use mf4_fai_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if year_o< $SPLITYEAR

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
*
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"
label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"
label var no_shared_assoc "No shared association"
// spec 1: whole sample + only geography
eststo spec1: clogit DVprob $geo, group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)
*regsave using ../data/Regsave/basespec1, replace
// spec 2: whole sample + geography + network
set more off
eststo spec2: clogit DVprob $geo $ties_wos , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

***************************move to ex file (all control obs available for mgp fai sample
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
// geo variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

*WOS ties
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
*MGP ties
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"

label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"

keep if valid_mgp_plus==1
keep if year_o< $SPLITYEAR


gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
// spec 3: 
eststo spec3:  clogit  DVprob $geo , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

*spec 4: spec 3 but with 12step instead of 2part.
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
table distint_i, c(min dist_i max dist_i mean dist_i count dist_i)
eststo spec4: clogit DVprob $geo12, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)


// spec 5: 
set more off
eststo spec5:  clogit  DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)
 
// spec 6:  spec 5 with 12step instead of 2part.
eststo spec6:  clogit  DVprob $geo12 $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


set linesize 255
esttab spec1 spec2 spec3 spec4 spec5 spec6 using tables_replicated/tabled5.tex, replace scalar(rsq aic) b(3) se(3) starlevels($^{\sim}$ 0.1  $^\dagger$ 0.05  $^{\star}$ 0.01)  label



*Table D.6
*************
clear
drop _all
eststo clear

global SPLITYEAR = 2005 

set more off

****macros for the RHS.
*2part
global geo "distgt0  lndist_i b_n_i lang_i "  
*12 step
global geo12 "i.distint_i b_n_i lang_i "   
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 
use mf4_fai_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if year_o>= $SPLITYEAR

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
*
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"
label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"
label var no_shared_assoc "No shared association"
// spec 1: whole sample + only geography
eststo spec1: clogit DVprob $geo, group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)
// spec 2: whole sample + geography + network
set more off
eststo spec2: clogit DVprob $geo $ties_wos , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

***************************move to ex file (all control obs available for mgp fai sample
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
// geo variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

*WOS ties
label var co_authors "Co-authors"
label var coincided_year  "Coincided past"
label var worked_same_institution "Worked same place"
*MGP ties
label var phd_same_school_5years "Share Ph.D. (5 years)"
label var phd_same_school "Share Ph.D. (any year)"

label var phd_siblings "PhD siblings"
label var phd_cousins "PhD cousins"
label var advisor_citing "Advisor citing"
label var advisor_cited "Advisor cited"
label var gf_citing "Academic grandfather citing"
label var gf_cited "Academic grandfather cited"
label var uncle_citing "Academic uncle citing"
label var uncle_cited "Academic uncle cited"
label var affciting_sccited_i "Alma Mater citing"
label var affcited_scciting_i  "Alma Mater cited"

keep if valid_mgp_plus==1
keep if year_o>= $SPLITYEAR

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
// spec 3: 
eststo spec3:  clogit  DVprob $geo , group(triad)  cluster(code_art_d) 
estadd scalar rsq = e(r2_p)

*spec 4: spec 3 but with 12step instead of 2part.
egen distint_i= cut(dist_i), at(0,0.001,2.5,10,25,50,100,250,500,1000,2500,5000,10000,20000) label
table distint_i, c(min dist_i max dist_i mean dist_i count dist_i)
eststo spec4: clogit DVprob $geo12, group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)


// spec 5: 
set more off
eststo spec5:  clogit  DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)
 

// spec 6:  spec 5 with 12step instead of 2part.
eststo spec6:  clogit  DVprob $geo12 $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


set linesize 255
esttab spec1 spec2 spec3 spec4 spec5 spec6 using tables_replicated/tabled6.tex, replace scalar(rsq aic) b(3) se(3) starlevels($^{\sim}$ 0.1  $^\dagger$ 0.05  $^{\star}$ 0.01)  label





	 
*Table D.7 Average effect of ties listed but not included in the table
****************************************************************
clear
drop _all
eststo clear

global SPLITYEAR = 2005 

set more off

global geo "distgt0  lndist_i b_n_i lang_i "  
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 


// column 1 without interaction; column 2-3 for obscure (defined by median <=5); col 4-5 for recent (defined by median <=9); col 6-7 for different field.  

// Column 1:
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1
keep if year_o< $SPLITYEAR

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE


eststo all: clogit  DVprob $geo $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

* 2 sets of lincoms
*ties (get rid of gf)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]   + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13
* dummy geo base
lincom (_b[distgt0] +_b[b_n_i]+_b[lang_i])/3

// three specifications: 
// spec 1: interact with less known dummy; column 2-3 for obscure (defined by median <=3)
use mf_cites.dta, clear 
gen int totcites =1
collapse (sum) totcites , by(code_art_d)
sum totcites, d
sort totcites
gen pctile = _n/(_N+1)
gen byte obscure = totcites<=3  
keep code_art_d obscure
sort code_art_d
save temp, replace

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1
keep if year_o< $SPLITYEAR
// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


merge m:1 code_art_d using temp
replace obscure=1 if _merge==1
drop if _merge==2
drop _merge
table year_o, c(mean obscure)

foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*obscure
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo obscure: clogit DVprob  $geo $ties_wos $ties_mgp *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

* sets of lincoms
*ties 
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]   + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]    + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13


// spec 2: interact with recent dummy; col 4-5 for recent (defined by median <=9)

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1
keep if year_o< $SPLITYEAR

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


gen age=year_o-year_d
replace age=0 if age==-1

// using age=9 (median) as threshold
gen byte recent = age<=9


**generate interaction terms

foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*recent
}


gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo recent: clogit DVprob $geo $ties_wos $ties_mgp *_x   , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

* sets of lincoms
*ties 
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]    + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]    + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13


// spec 3: interact with diff_field2 (using 2 digit MSC); col 6-7 for different field

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1
keep if year_o< $SPLITYEAR

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

gen fd_3o=substr(field_o, 1,3)
gen fd_2o = substr(field_o, 1,2)
gen fd_3d = substr(field_d, 1,3)
gen fd_2d=substr(field_d, 1,2)
drop if field_o==""
drop if field_d==""
gen byte diff_fd2 = fd_2d != fd_2o
gen byte diff_fd3 = fd_3d != fd_3o
gen byte diff_fd5 = field_o != field_d



foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*diff_fd2
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
eststo diff_fd2: clogit DVprob $geo $ties_wos $ties_mgp *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
*sets of lincoms
*ties (get rid of gf)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] /* + _b[gf_citing] */ + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x] /* + _b[gf_citing_x] */ + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13


**************create tables************
esttab all obscure recent diff_fd2 using tables_replicated/tabled7.tex, replace  scalar(rsq aic bic)  b(3) se(3) starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label



*Table D.8 Average effect of ties listed but not included in the table
****************************************************************
clear
drop _all
eststo clear

global SPLITYEAR = 2005 

set more off

global geo "distgt0  lndist_i b_n_i lang_i "  
global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years phd_siblings phd_cousins  advisor_citing advisor_cited gf_cited  uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 


// column 1 without interaction; column 2-3 for obscure (defined by median <=5); col 4-5 for recent (defined by median <=9); col 6-7 for different field.  

// Column 1:
use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1
keep if year_o>= $SPLITYEAR

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE


eststo all: clogit  DVprob $geo $ties_wos $ties_mgp , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

* 2 sets of lincoms
*ties (get rid of gf)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]   + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13
* dummy geo base
lincom (_b[distgt0] +_b[b_n_i]+_b[lang_i])/3

// three specifications: 
// spec 1: interact with less known dummy; column 2-3 for obscure (defined by median <=3)
use mf_cites.dta, clear 
gen int totcites =1
collapse (sum) totcites , by(code_art_d)
sum totcites, d
sort totcites
gen pctile = _n/(_N+1)
gen byte obscure = totcites<=3  
keep code_art_d obscure
sort code_art_d
save temp, replace

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1
keep if year_o>= $SPLITYEAR
// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


merge m:1 code_art_d using temp
replace obscure=1 if _merge==1
drop if _merge==2
drop _merge
table year_o, c(mean obscure)

foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*obscure
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo obscure: clogit DVprob  $geo $ties_wos $ties_mgp *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

*sets of lincoms
*ties 
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]   + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]    + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13


// spec 2: interact with recent dummy; col 4-5 for recent (defined by median <=9)

use mf4_fai_ex_gf.dta, clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1
keep if year_o>=$SPLITYEAR

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


gen age=year_o-year_d
replace age=0 if age==-1

// using age=9 (median) as threshold
gen byte recent = age<=9


**generate interaction terms

foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*recent
}


gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo recent: clogit DVprob $geo $ties_wos $ties_mgp *_x   , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)

* sets of lincoms
*ties 
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited]    + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x]    + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13



// spec 3: interact with diff_field2 (using 2 digit MSC); col 6-7 for different field

use mf4_fai_ex_gf.dta , clear 
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.
keep if valid_mgp_plus==1
keep if year_o>= $SPLITYEAR

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

gen fd_3o=substr(field_o, 1,3)
gen fd_2o = substr(field_o, 1,2)
gen fd_3d = substr(field_d, 1,3)
gen fd_2d=substr(field_d, 1,2)
drop if field_o==""
drop if field_d==""
gen byte diff_fd2 = fd_2d != fd_2o
gen byte diff_fd3 = fd_3d != fd_3o
gen byte diff_fd5 = field_o != field_d

foreach var of varlist $ties_wos $ties_mgp  $geo {
gen `var'_x = `var'*diff_fd2
}

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
eststo diff_fd2: clogit DVprob $geo $ties_wos $ties_mgp *_x , group(triad) cluster(code_art_d)
estadd scalar rsq = e(r2_p)
* sets of lincoms
*ties (get rid of gf)
lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] /* + _b[gf_citing] */ + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/13

*ties interactions 
lincom (_b[co_authors_x] +_b[coincided_year_x]+_b[worked_same_institution_x]+_b[phd_same_school_5years_x] + _b[phd_siblings_x]  + _b[phd_cousins_x] + _b[advisor_citing_x] + _b[advisor_cited_x] /* + _b[gf_citing_x] */ + _b[gf_cited_x] + _b[uncle_citing_x] + _b[uncle_cited_x] + _b[affciting_sccited_i_x] + _b[affcited_scciting_i_x])/13


**************create tables************
esttab all obscure recent diff_fd2 using tables_replicated/tabled8.tex, replace  scalar(rsq aic bic)  b(3) se(3) starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label









*Table D.9
**************
clear
drop _all
set more off

*Panel A. Average effect of ties listed, but not included in the table

****macros for the RHS.
global geo "distgt0  lndist_i b_n_i lang_i "  // 2 part
global geo0 "distgt0  lndist_i "  // 2 part---this is for US only sample (no_shared_assoc omitted in US only sample regression)

global ties_wos "co_authors coincided_year worked_same_institution"  
global ties_mgp "phd_same_school_5years  phd_siblings phd_cousins  advisor_citing advisor_cited gf_citing gf_cited uncle_citing uncle_cited affciting_sccited_i affcited_scciting_i" 

eststo clear
// col 1: bothUS vs notbothUS 
use mf4_fai_ex_gf.dta, clear 
*** this includes the merge to bring on the US dummy
*** run this with bothUS  (so that the non-interacted variable is notbothUS)
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"

keep if valid_mgp_plus==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

gen sum_ties = co_authors+coincided_year+worked_same_institution+phd_same_school_5years+phd_siblings+phd_cousins +advisor_citing+advisor_cited+gf_citing+gf_cited + uncle_citing + uncle_cited  +affciting_sccited_i+affcited_scciting_i

***now add US dummy
merge m:1 code_art using US_dummy.dta
drop if _merge==2
drop _merge
rename US US_o
label var US_o "US-resident authors citing"

rename code_art code_art_temp
rename code_art_d code_art
merge m:1 code_art using US_dummy.dta
drop if _merge==2
drop _merge
rename US US_d
label var US_d "US-resident authors citing"

rename code_art code_art_d
rename code_art_temp code_art
gen byte bothUS = US_o*US_d
gen byte oneUS = US_o*(1-US_d) + (1-US_o)*US_d // only 1 team in US
* default group is Neither team in US
gen lndistXbothUS = lndist_i*bothUS
gen lndistXoneUS = lndist_i*oneUS

gen tiesXbothUS = sum_ties*bothUS
gen tiesXoneUS = sum_ties*oneUS

gen difUniXbothUS = distgt0*bothUS


eststo bothUS: clogit DVprob $geo bothUS difUniXbothUS lndistXbothUS  sum_ties tiesXbothUS, group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)


// col 2: mf4_ave sample
use mf4_fai_ave_ex_gf.dta, clear 
set more off

replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"


keep if valid_mgp_plus==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo average: clogit DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)

lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
 di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)

// col 3: original geography
use mf4_fai_ex_gf.dta, clear 

drop lndist_i
gen lndist_i=lndist
replace lndist_i = ln(1) if dist==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist>0   // 2-part indicator. 
keep if year_o>=1980

drop b_n_i lang_i
gen b_n_i=b_n
gen lang_i=lang 


// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


keep if valid_mgp_plus==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo original: clogit DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)

lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
 di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)

// col 4: available author information
set more off
use mf4_aai_ex_gf.dta, clear 

replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

set more off

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo available: clogit DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)

lincom (_b[co_authors] +_b[coincided_year]+_b[worked_same_institution]+_b[phd_same_school_5years] + _b[phd_siblings]  + _b[phd_cousins] + _b[advisor_citing] + _b[advisor_cited] + _b[gf_citing] + _b[gf_cited] + _b[uncle_citing] + _b[uncle_cited] + _b[affciting_sccited_i] + _b[affcited_scciting_i])/14
estadd scalar ave_network = r(estimate)
estadd scalar ave_network_se = r(se)
 di "average link increase in odds ratio  =  " round(exp(r(estimate)),0.01)


esttab bothUS average original available using tables_replicated/tabled9PanelA.tex, replace scalar(rsq aic bic ave_network ave_network_se)  keep($geo bothUS difUniXbothUS lndistXbothUS  sum_ties tiesXbothUS) b(3) se(3)  starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label


*Panel B


****macros for the RHS.
global ties_wos " "  
global ties_mgp " "


clear
drop _all
set more off

****macros for the RHS.
eststo clear

// col 1: bothUS
 
use mf4_fai_ex_gf.dta , clear 

*** this includes the merge to bring on the US dummy
*** run this with bothUS  (so that the non-interacted variable is notbothUS)
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"

keep if valid_mgp_plus==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

***now add US dummy
merge m:1 code_art using US_dummy.dta
drop if _merge==2
drop _merge
rename US US_o
label var US_o "US-resident authors citing"

rename code_art code_art_temp
rename code_art_d code_art
merge m:1 code_art using US_dummy.dta
drop if _merge==2
drop _merge
rename US US_d
label var US_d "US-resident authors citing"

rename code_art code_art_d
rename code_art_temp code_art
gen byte bothUS = US_o*US_d
gen byte oneUS = US_o*(1-US_d) + (1-US_o)*US_d // only 1 team in US
* default group is Neither team in US
gen lndistXbothUS = lndist_i*bothUS
gen lndistXoneUS = lndist_i*oneUS

gen difUniXbothUS = distgt0*bothUS



** this specification replaces below
eststo bothUS: clogit DVprob $geo bothUS difUniXbothUS lndistXbothUS  , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)



// col 2: mf4_ave sample
use mf4_fai_ave_ex_gf.dta, clear 
set more off

replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


keep if valid_mgp_plus==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo average: clogit DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)


// col 3: original geography
use mf4_fai_ex_gf.dta, clear 

drop lndist_i
gen lndist_i=lndist
replace lndist_i = ln(1) if dist==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist>0   // 2-part indicator. 
keep if year_o>=1980

drop b_n_i lang_i
gen b_n_i=b_n
gen lang_i=lang 


// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"


keep if valid_mgp_plus==1

gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo original: clogit DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)


// col 4: available author information
set more off
use mf4_aai_ex_gf.dta, clear 

replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if year_o>=1980  // 30 years of data.

// label variables:
label var distgt0 "Distance $>0$km"
label var lndist_i "ln Distance"
label var b_n_i "Different country"
label var lang_i "Different language"
label var no_shared_assoc "No shared association"

set more off
gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE

eststo available: clogit DVprob $geo  $ties_wos $ties_mgp , group(triad)  cluster(code_art_d)
estadd scalar rsq = e(r2_p)


**************create tables************
esttab bothUS average original available using tables_replicated/tabled9PanelB.tex, append scalar(rsq aic bic ave_network ave_network_se)  keep($geo bothUS difUniXbothUS lndistXbothUS) b(3) se(3)  starlevels($^\sim$ 0.1  $^\dagger$ 0.05  $^\star$ 0.01)  label

