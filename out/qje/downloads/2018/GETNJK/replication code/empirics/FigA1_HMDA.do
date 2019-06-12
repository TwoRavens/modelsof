
// Purpose: create monthly time series of overall HMDA mortgage origination amounts (and also just refi amounts) across the US (by application month)

// Pull in two parts, to keep size managable (SQL codes below are for RADAR within Fed system):

use chmda_1.dta, clear
/* all originated loans 1990-2003:
SELECT year,agency_code,respondent_id,action_date,application_date,loan_amount,loan_purpose,loan_type,msa_md,property_type,state_code 
FROM chmda.view_lar_chmda WHERE (view_ lar_chmda.year BETWEEN 1990 AND 2003 AND view_lar_chmda.action_type =1)
*/

append using chmda_2.dta
/* all originated loans 2004-2015
SELECT year,agency_code,respondent_id,action_date,application_date,loan_amount,loan_purpose,loan_type,msa_md,property_type,state_code 
FROM chmda.view_lar_chmda WHERE (view_ lar_chmda.year BETWEEN 2004 AND 2015 AND view_lar_chmda.action_type =1)
*/

tab year agency_code, row
drop if agency_code=="8" // PMI
drop if state_code =="72" // PR
drop if property_type==3 // Multifam

drop if loan_purpose<1 | loan_purpose>3 // 4 is multifamily pre 2004

g x = regexm(application_date , "/")
g appdate = date(application_date, "MDY", 2050) if x==1
replace appdate = date(application_date, "YMD") if x==0
format appdate %td

g datem_app = mofd(appdate)
format datem_app %tm
drop if datem_app<m(1990m1)|datem_app>m(2015m12)
drop x

rename loan_amount loanamt
gen refiamt = loanamt 
replace refiamt = 0 if loan_purp==1 

g refi_code = refiamt<. & refiamt>0
g loan_code = loanamt<. & loanamt>0

collapse (sum) total_loanvol=loanamt refi_HI_loanvol = refiamt ///
		 (sum) count_loans=loan_code count_refi_HI = refi_code ///
		 , by(datem_app) fast

rename datem_app datem

replace total_loanvol = total_loanvol/10^6
replace refi_HI_loanvol = refi_HI_loanvol/10^6
g purch_loanvol = total_loanvol - refi_HI_loanvol

keep if datem>=m(2000m1)&datem<=m(2012m12)

// plot separately:
line refi_HI_loanvol datem , ylabel(0(50)350) xlabel(#14, angle(45)) ///
 ytitle("Origination amount (bn)", axis(1)) tline(2008m11) xtitle("") name(rp1, replace)

line purch_loanvol  datem , ylabel(0(50)350) xlabel(#14, angle(45)) ///
 ytitle("Origination amount (bn)", axis(1)) tline(2008m11) xtitle("") name(rp2, replace)


