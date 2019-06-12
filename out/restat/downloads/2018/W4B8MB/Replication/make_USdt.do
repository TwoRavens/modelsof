*Run this in Replication/ folder
*use "../final sample/mf4_fai_ex_gf.dta" , clear 
use mf4_fai_ex_gf.dta , clear 
gen age=year_o-year_d
*keep if age<=10
replace lndist_i = ln(1) if dist_i==0  // an institution assumed to be 1km from self.
gen byte distgt0 = dist_i>0   // 2-part indicator. 
keep if valid_mgp_plus==1  // needed for the _fai sample w/ grandfather
*keep if valid_mgp_plus==0
keep if year_o>=1980 
gen msc3_citing = substr(field_o,1,3)
egen triad = group(msc3_citing year_o code_art_d)  // new form of FE
save temp, replace
gen sum_ties = co_authors+coincided_year+worked_same_institution+phd_same_school_5years+phd_siblings+phd_cousins +advisor_citing+advisor_cited+gf_citing+gf_cited + uncle_citing + uncle_cited  +affciting_sccited_i+affcited_scciting_i
***now add US dummy
*merge m:1 code_art using "../final sample/US_dummy.dta"
merge m:1 code_art using US_dummy.dta
* no merge =1 but lots of merge =2 for non-MGP obs
drop if _merge==2
drop _merge
rename US US_o
label var US_o "US-resident authors citing"
tab US_o  // 37% of the citing author teams at US institutions.

rename code_art code_art_temp
rename code_art_d code_art
*merge m:1 code_art using "../final sample/US_dummy.dta"
merge m:1 code_art using US_dummy.dta
* no merge =1 but lots of merge =2 for non-MGP obs
drop if _merge==2
drop _merge
rename US US_d
label var US_d "US-resident authors citing"
tab US_d  // 49% of the cited author teams at US institutions.
rename code_art code_art_d
rename code_art_temp code_art
gen byte bothUS = US_o*US_d
drop msc3_citing
save USdt, replace
