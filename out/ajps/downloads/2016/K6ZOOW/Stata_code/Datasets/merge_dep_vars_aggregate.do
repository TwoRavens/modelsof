***************************************************************************
* File:               merge_dep_vars_aggregate.do
* Author:             Miguel R. Rueda
* Description:        Creates two panels of dependent variables: One 
*					  with info from monitors' reports and a second one with citizens' reports.
* Created:            Feb - 01 - 2012
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************

clear
cd "\Datasets\Dep_vars\"


set more off
*Appending dependent variables for years 2007 and 2011

use 2007munif_depvar.dta,clear
keep muni_code year moving_votes intimidation vote_buying neg_t_buying fraud irregular_voting pol_suport total_moe type

append using 2011munif_depvar.dta
append using 2010munif_depvar.dta
append using 2006cmuni.dta

rename fraud manipulating_results


foreach var in moving_votes intimidation vote_buying neg_t_buying manipulating_results irregular_voting pol_suport{
rename `var' `var'_moe
} 


label var total_moe "Total reports MOE"

save panel_depvar.dta,replace

*Comparing database with database on file
*cf _all using "C:\Users\mrueda\Documents\Rochester\Clientelism\Data\Colombia\Bases Iniciales\panel_depvar.dta", v all



*Putting together panel from voters' reports
import excel "Denuncias ciudadanos 2003 2007.xlsx", sheet("aux") firstrow clear



collapse (sum) Total_2007 Perturbacion_2007 intimidation_2007 information_2007 moving_votes_2007 vote_buying_2007 voto_Fraudulento_2007 f_voto_fraudulento_2007 Mora_2007 alteracion_2007 neg_t_buying_2007 d_inscripcion_2007 intervencion_2007 Generic_2007 ///
			   Total_2006 Perturbacion_2006 intimidation_2006 information_2006 moving_votes_2006 vote_buying_2006 voto_Fraudulento_2006 f_voto_fraudulento_2006 Mora_2006 alteracion_2006 neg_t_buying_2006 d_inscripcion_2006 intervencion_2006 Generic_2006 ///
			   Total_2003 Perturbacion_2003 intimidation_2003 information_2003 moving_votes_2003 vote_buying_2003 voto_Fraudulento_2003 f_voto_fraudulento_2003 Mora_2003 alteracion_2003 neg_t_buying_2003 d_inscripcion_2003 intervencion_2003 Generic_2003 ///
			   Total_2002 Perturbacion_2002 intimidation_2002 information_2002 moving_votes_2002 vote_buying_2002 voto_Fraudulento_2002 f_voto_fraudulento_2002 Mora_2002 alteracion_2002 neg_t_buying_2002 d_inscripcion_2002 intervencion_2002 Generic_2002, by(muni_code)

merge 1:1 muni_code using  "divipol_muni2007.dta"

foreach var in Total_2007 Perturbacion_2007 intimidation_2007 information_2007 moving_votes_2007 vote_buying_2007 voto_Fraudulento_2007 f_voto_fraudulento_2007 Mora_2007 alteracion_2007 neg_t_buying_2007 d_inscripcion_2007 intervencion_2007 Generic_2007 ///
			   Total_2006 Perturbacion_2006 intimidation_2006 information_2006 moving_votes_2006 vote_buying_2006 voto_Fraudulento_2006 f_voto_fraudulento_2006 Mora_2006 alteracion_2006 neg_t_buying_2006 d_inscripcion_2006 intervencion_2006 Generic_2006 ///
			   Total_2003 Perturbacion_2003 intimidation_2003 information_2003 moving_votes_2003 vote_buying_2003 voto_Fraudulento_2003 f_voto_fraudulento_2003 Mora_2003 alteracion_2003 neg_t_buying_2003 d_inscripcion_2003 intervencion_2003 Generic_2003 ///
			   Total_2002 Perturbacion_2002 intimidation_2002 information_2002 moving_votes_2002 vote_buying_2002 voto_Fraudulento_2002 f_voto_fraudulento_2002 Mora_2002 alteracion_2002 neg_t_buying_2002 d_inscripcion_2002 intervencion_2002 Generic_2002{
replace `var'=0 if `var'==.
}			   
			   


save citizen_report.dta,replace
*Do not eliminate other municipalities

keep muni_code Perturbacion_2007 Perturbacion_2006 Perturbacion_2003 Perturbacion_2002
reshape long Perturbacion_, i(muni_code) j(year)
save panel_citizen_report.dta,replace

foreach var in intimidation information moving_votes vote_buying voto_Fraudulento f_voto_fraudulento Mora alteracion neg_t_buying d_inscripcion intervencion Generic{
use citizen_report.dta, clear
keep muni_code `var'_2007 `var'_2006 `var'_2003 `var'_2002
reshape long `var'_, i(muni_code) j(year)
merge 1:1 muni_code year using panel_citizen_report.dta
drop _merge

save panel_citizen_report.dta,replace
}



rename Generic_ other 
label var other "Other"

rename intimidation_ intimidation 
label var intimidation "Threats to induce voting/abstention"

rename information_ information 
label var information "False information to induce voting/abstention"

rename moving_votes moving_votes 
label var moving_votes "Registering voting ID in different place of recidence"

rename vote_buying vote_buying 
label var vote_buying "Payments to induce voting for a given candidate"

rename voto_Fraudulento irregular_voting 
label var irregular_voting "Voting without being registered/ Voting twice"

rename f_voto_fraudulento_ f_irregular_voting 
label var f_irregular_voting "Facilitating irregular voting"

rename Mora_ delay 
label var delay "Unjustified delays with materials in voting station"

rename alteracion_ manipulating_results 
label var manipulating_results "Manipulating results (e.g. double counting)"

rename neg_t_buying_ neg_t_buying
label var neg_t_buying "Negative turnout buying"

rename d_inscripcion_ deny_c_register
label var deny_c_register "To deny or to inhibit candidates registration"

rename intervencion_ pol_suport
label var pol_suport "Using public policy to help a candidate during campaign"

rename Perturbacion_ perturbacion
label var perturbacion "Action that inhibits voting"

save panel_citizen_report.dta,replace


*Adding new reports with accusations


merge 1:1 muni_code year using new_citizens_rep

*gen d_`var'=`var'-(`var'_c+`var'_d) if `var'!=.&`var'_c!=.&`var'_d!=. 
*Creating new dependent variables for all years (citizens reports)
foreach var in vote_buying perturbacion pol_suport neg_t_buying manipulating_results f_irregular_voting information intimidation irregular_voting delay{
gen d_`var'=`var'-`var'_c if `var'!=.&`var'_c!=. 
replace d_`var' = `var'_a if year>=2010
replace d_`var' =`var' if year<=2003
}


*Series 'e' just have the total
foreach var in vote_buying perturbacion pol_suport neg_t_buying manipulating_results f_irregular_voting information intimidation irregular_voting delay{
gen e_`var'=`var' 
replace e_`var' = `var'_a+`var'_b+`var'_c+`var'_d if year>=2008 
}

drop _merge

*Generating discrete dep vars
foreach var in moving_votes intimidation vote_buying neg_t_buying{
gen di_`var'=cond(`var'>0.,1,0)
replace di_`var'=. if `var'==. 
}


*Generating total number of reports
gen e_total1=e_vote_buying+e_perturbacion+e_pol_suport+e_neg_t_buying+e_manipulating_results+e_f_irregular_voting+e_information+e_intimidation+e_irregular_voting+e_delay

gen e_total2=e_vote_buying+e_neg_t_buying+e_intimidation
label var  e_total1 "All reports"
label var  e_total2 "Vote Buying, Restrictions on Turnout and Fraud reports"

save panel_citizen_report.dta,replace
erase new_citizens_rep.dta

*Comparing database with database on file
*cf _all using "C:\Users\mrueda\Documents\Rochester\Clientelism\Data\Colombia\Bases Iniciales\panel_citizen_report.dta", all v












