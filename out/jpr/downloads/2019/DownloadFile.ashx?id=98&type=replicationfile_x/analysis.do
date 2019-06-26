*Set working directory to replication folder

cd ""
use data, replace


// Table 1

xtset cowcode year
global x   "lprio_civilwar lprio_civilwar Lrsh_war le_migdppcln lv2x_libdem ethfrac postcold styear*"
global x2  "lprio_civilwar Lrsh_war le_migdppcln lv2x_libdem ethfrac postcold nomkyrs*"
global opt "if statefail ==1"
global opt2 "if l.mkincidence != 1"

cap program drop supp
program def supp
	unique cowcode if e(sample)
	estadd scalar country=r(sum)
	count if e(sample) & `e(depvar)' ==1
	estadd scalar trans=r(N)
end

eststo clear
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc postcold styear*  $opt, cl(cowcode) 
	supp
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc lnonterrrivalry lnonterrr_elc $x $opt, cl(cowcode)
	supp
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(styear*) ///
	order(lelc_eliti lterrrivalry lterrr_elc lnonterrrivalry lnonterrr_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))
	
	
// Table 2
	
global threat "lelc_eliti l1_tclaim ltclaim_elc"
eststo clear
eststo: qui logit mkonset $threat postcold styear* $opt, cl(cowcode) 
	supp
eststo: qui logit mkonset $threat $x $opt, cl(cowcode)
	supp

global threat "lelc_eliti l1_icowsal licow_elc"
eststo: qui logit mkonset $threat postcold styear*  $opt, cl(cowcode) 
	supp
eststo: qui logit mkonset $threat $x $opt, cl(cowcode)
	supp

esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(styear*) ///
	order(lelc_eliti l1_tclaim ltclaim_elc l1_icowsal licow_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))

	
// Figure 1

foreach x of varlist log_munrest log_eunrest log_mepv_civtot latentmean  {
kdensity `x' if !terrrivalry, lc(gray) plot(kdensity `x' if terrrivalry, lc(red)) legend(order(1 "No territorial rivalry" 2 "Territorial rivalry") col(1) pos(2) ring(0)) title("")  saving("gg`x'",replace) 
local gg `"`gg' "gg`x'""'	
}
graph combine `gg'  , col(2) saving(dist, replace) 
graph export "/Users/nkim2/Dropbox/MyWorks/Mass atrocities/External threats and MK/dist.pdf", replace
graph drop _all	


// Figure 3
	
qui logit mkonset lterrrivalry##lelc_eliti $x $opt, cl(cowcode)
margins, at(lterrrivalry = (0 1) lelc_eliti= (0 1))
marginsplot


qui logit mkonset l1_tclaim##lelc_eliti $x $opt, cl(cowcode)
margins, at(l1_tclaim = (0 1) lelc_eliti= (0 1))
marginsplot

// Figure 4

qui logit mkonset c.l1_icowsal##lelc_eliti $x $opt, cl(cowcode)
qui margins, at(l1_icowsal = (0(1)12) lelc_eliti= (0 1))
marginsplot



/* ****************** Appendix **************************** */

				
// Table A2

xtset cowcode year
eststo clear
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc postcold nomkyrs*  $opt2, cl(cowcode) 
	supp
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $opt2, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc lnonterrrivalry lnonterrr_elc $x2 $opt2, cl(cowcode)
	supp

global threat "lelc_eliti l1_tclaim ltclaim_elc"
eststo: qui logit mkonset $threat postcold nomkyrs* $opt2, cl(cowcode) 
	supp
eststo: qui logit mkonset $threat $x2 $opt2, cl(cowcode)
	supp

global threat "lelc_eliti l1_icowsal licow_elc"
eststo: qui logit mkonset $threat postcold nomkyrs*  $opt2, cl(cowcode) 
	supp
eststo: qui logit mkonset $threat $x2 $opt2, cl(cowcode)
	supp

esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(nomkyrs*) ///
	order(lelc_eliti lterrrivalry lterrr_elc l1_tclaim ltclaim_elc l1_icowsal licow_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))


	
// Table A3

eststo clear
global opt  "if e_boix_regime == 0 & statefail ==1"
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_icowsal licow_elc $x $opt, cl(cowcode)
	supp

global opt  "if e_boix_regime == 0"
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x2 $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_icowsal licow_elc $x2 $opt, cl(cowcode)
	supp
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))
		
		
// Table A4

eststo clear	
global opt  "if lmkincidence != 1 & v2x_libdem <  .5  & statefail ==1"
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_icowsal licow_elc $x $opt, cl(cowcode)
	supp
global opt  "if lmkincidence != 1 & v2x_libdem <  .5 "
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x2 $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_icowsal licow_elc $x2 $opt, cl(cowcode)
	supp
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))
	

	
// Table A5

global x   "Lrsh_war le_migdppcln lv2x_libdem ethfrac postcold nomkyrs*"

eststo clear
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x if prio100==1, cl(cowcode)
supp
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x if prio100==0, cl(cowcode)
supp
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x if prio100==0 & statefail==1, cl(cowcode)
supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x if prio100==1, cl(cowcode)
supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x if prio100==0, cl(cowcode)
supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x if prio100==0 & statefail==1, cl(cowcode)
supp
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label  ///
	order(lelc_eliti lterrrivalry lterrr_elc l1_tclaim ltclaim_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))

cap program drop suppD
program def suppD
	unique cowcode if e(sample)
	estadd scalar country=r(sum)
	count if e(sample) & `e(depvar)' ==1
	estadd scalar trans=r(N)
	estadd scalar ll
end

// Table A6
	
global x  "lprio_civilwar Lrsh_war le_migdppcln lv2x_libdem ethfrac postcold styear*"
global x2 "lprio_civilwar Lrsh_war le_migdppcln lv2x_libdem ethfrac postcold nomkyrs*"
global opt "if statefail == 1"

eststo clear
eststo: qui relogitll mkonset lelc_eliti lterrrivalry lterrr_elc $x $opt, cl(cowcode)
	suppD
eststo: qui relogitll mkonset lelc_eliti l1_tclaim ltclaim_elc $x $opt, cl(cowcode)
	suppD
eststo: qui relogitll mkonset lelc_eliti l1_icowsal licow_elc $x $opt, cl(cowcode)
	suppD
eststo: qui relogitll mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $opt2, cl(cowcode)
	suppD
eststo: qui relogitll mkonset lelc_eliti l1_tclaim ltclaim_elc $x2 $opt2, cl(cowcode)
	suppD
eststo: qui relogitll mkonset lelc_eliti l1_icowsal licow_elc $x2 $opt2, cl(cowcode)
	suppD
	
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(nomkyrs* styear*) ///
	order(lelc_eliti lterrrivalry lterrr_elc lnonterrrivalry lnonterrr_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))

	
// Table A7

xtset cowcode year
eststo clear
	
eststo: qui firthlogit mkonset lelc_eliti lterrrivalry lterrr_elc $x $opt
	supp
eststo: qui firthlogit mkonset lelc_eliti l1_tclaim ltclaim_elc $x $opt
	supp
eststo: qui firthlogit mkonset lelc_eliti l1_icowsal licow_elc $x $opt
	supp

eststo: qui firthlogit mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $opt2
	supp
eststo: qui firthlogit mkonset lelc_eliti l1_tclaim ltclaim_elc $x2 $opt2
	supp	
eststo: qui firthlogit mkonset lelc_eliti l1_icowsal licow_elc $x2 $opt2
	supp	
	
esttab, star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(nomkyrs*) ///
	order(lelc_eliti lterrrivalry lterrr_elc l1_tclaim ltclaim_elc l1_icowsal licow_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))


// Table A8

xtset cowcode year
eststo clear
eststo: qui xtlogit mkonset lelc_eliti lterrrivalry lterrr_elc $x $opt
	supp
eststo: qui xtlogit mkonset lelc_eliti l1_tclaim ltclaim_elc $x $opt
	supp
eststo: qui xtlogit mkonset lelc_eliti l1_icowsal licow_elc $x $opt
	supp

eststo: qui xtlogit mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $opt2
	supp
eststo: qui xtlogit mkonset lelc_eliti l1_tclaim ltclaim_elc $x2 $opt2
	supp	
eststo: qui xtlogit mkonset lelc_eliti l1_icowsal licow_elc $x2 $opt2
	supp
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(nomkyrs*) ///
	order(lelc_eliti lterrrivalry lterrr_elc l1_tclaim ltclaim_elc l1_icowsal licow_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))


// Table A9

global reg "eur na eas lac mena sa "

xtset cowcode year
eststo clear
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x $reg $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x $reg $opt, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_icowsal licow_elc $x $reg $opt, cl(cowcode)
	supp

eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $reg $opt2, cl(cowcode)
	supp
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x2 $reg $opt2, cl(cowcode)
	supp	
eststo: qui logit mkonset lelc_eliti l1_icowsal licow_elc $x2 $reg $opt2, cl(cowcode)
	supp
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(nomkyrs*) ///
	order(lelc_eliti lterrrivalry lterrr_elc l1_tclaim ltclaim_elc l1_icowsal licow_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))

	
// Table A10

xtset cowcode year
eststo clear
eststo: qui xtreg mkonset lelc_eliti lterrrivalry lterrr_elc $x $opt, fe ro
	supp
eststo: qui xtreg mkonset lelc_eliti l1_tclaim ltclaim_elc $x $opt, fe ro
	supp
eststo: qui xtreg mkonset lelc_eliti l1_icowsal licow_elc $x $opt, fe ro
	supp

eststo: qui xtreg mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $opt2, fe ro
	supp
eststo: qui xtreg mkonset lelc_eliti l1_tclaim ltclaim_elc $x2 $opt2, fe ro
	supp	
eststo: qui xtreg mkonset lelc_eliti l1_icowsal licow_elc $x2 $opt2, fe ro
	supp
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(nomkyrs*) ///
	order(lelc_eliti lterrrivalry lterrr_elc l1_tclaim ltclaim_elc l1_icowsal licow_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))

// Table A11


xtset cowcode year
eststo clear
eststo: qui xtlogit mkonset lelc_eliti lterrrivalry lterrr_elc $x $opt, fe 
	supp
eststo: qui xtlogit mkonset lelc_eliti l1_tclaim ltclaim_elc $x $opt, fe 
	supp
eststo: qui xtlogit mkonset lelc_eliti l1_icowsal licow_elc $x $opt, fe 
	supp

eststo: qui xtlogit mkonset lelc_eliti lterrrivalry lterrr_elc $x2 $opt2, fe 
	supp
eststo: qui xtlogit mkonset lelc_eliti l1_tclaim ltclaim_elc $x2 $opt2, fe 
	supp	
eststo: qui xtlogit mkonset lelc_eliti l1_icowsal licow_elc $x2 $opt2, fe 
	supp
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(nomkyrs*) ///
	order(lelc_eliti lterrrivalry lterrr_elc l1_tclaim ltclaim_elc l1_icowsal licow_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))
	
	

// Table A12
global x   "lprio_civilwar le_migdppcln lv2x_libdem ethfrac postcold styear*"
global opt "if statefail==1"

eststo clear
eststo: qui firthlogit mkonset lelc_eliti new_terrrivalry new_terrrivalry_el old_terrrivalry  old_terrrivalry_el $x $opt
eststo: qui logit mkonset lelc_eliti new2_terrrivalry new2_terrrivalry_el old2_terrrivalry  old2_terrrivalry_el $x $opt, cl(cowcode)

eststo: qui firthlogit mkonset lelc_eliti new_tclaim new_tclaim_el old_tclaim old_tclaim_el $x $opt
eststo: qui logit mkonset lelc_eliti new2_tclaim new2_tclaim_el old2_tclaim old2_tclaim_el $x $opt
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(styear*) ///
	order(lelc_eliti new2_terrrivalry new2_terrrivalry_el old_terrrivalry  old_terrrivalry_el new2_tclaim new2_tclaim_el old2_tclaim old2_tclaim_el) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))


// Table A13

eststo clear
eststo: qui logit mkonset lelc_eliti##c.terrrivalry_yrs $x $opt, cl(cowcode)
eststo: qui logit mkonset lelc_eliti##c.tclaim_yrs $x $opt, cl(cowcode)
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(styear*)
	
	
// Table A14

xtset cowcode year
global x   "lprio_civilwar Lrsh_war le_migdppcln lv2x_libdem ethfrac postcold styear*"
global opt "if statefail ==1"

eststo clear
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x log_munrest log_eunrest $opt, cl(cowcode)
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x log_ltrade_WB $opt, cl(cowcode)
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x log_loilpop $opt, cl(cowcode)
eststo: qui logit mkonset lelc_eliti lterrrivalry lterrr_elc $x log_munrest log_eunrest log_ltrade_WB log_loilpop $opt, cl(cowcode)
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x log_munrest log_eunrest $opt, cl(cowcode)
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x log_ltrade_WB $opt, cl(cowcode)
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x log_loilpop $opt, cl(cowcode)
eststo: qui logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x log_munrest log_eunrest log_ltrade_WB log_loilpop $opt, cl(cowcode)

esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(styear*) ///
	order(lelc_eliti lterrrivalry lterrr_elc l1_tclaim ltclaim_elc) ///
	stats(N country trans ll, fmt(0 0 0 2) labels("Observations" "Countries" "Onsets" "Log-Likelihood" ))


// Table A18

global x   "lprio_civilwar le_migdppcln lv2x_libdem ethfrac postcold styear*"

eststo clear
eststo: qui logit mkonset lelc_eliti lag_midhi lag_midhielc postcold styear*  $opt, cl(cowcode) 
	supp
eststo: qui logit mkonset lelc_eliti lag_Tmidhi lag_Tmidhielc lag_Nmidhi lag_Nmidhielc $x $opt, cl(cowcode)
	supp
eststo: qui firthlogit mkonset lelc_eliti recent_midhi_dum recent_midhi_dumelc $x $opt
	supp
eststo: qui logit mkonset lelc_eliti recent_Tmidhi_dum recent_Tmidhi_dumelc recent_Nmidhi_dum recent_Nmidhi_dumelc $x $opt, cl(cowcode)
	supp

esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label drop(styear*) ///
	order(lelc_eliti lag_midhi lag_midhielc lag_Tmidhi lag_Tmidhielc lag_Nmidhi lag_Nmidhielc ///
	recent_midhi_dum recent_midhi_dumelc recent_Tmidhi_dum recent_Tmidhi_dumelc recent_Nmidhi_dum recent_Nmidhi_dumelc) 

// Table A19

eststo clear
for X in any 1 2 3 4 5: eststo: qui logit mkonset lelc_eliti recent_TmidhiX_dum recent_TmidhiX_dumelc recent_NmidhiX_dum recent_NmidhiX_dumelc postcold $x2 $opt2, cl(cowcode) 
esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label 


// Figure A1

foreach x of varlist log_munrest log_eunrest log_mepv_civtot latentmean  {
qui kdensity `x' if !tclaim, lc(gray) plot(kdensity `x' if tclaim, lc(red)) legend(order(1 "No territorial claim" 2 "Territorial claim") col(1) pos(2) ring(0)) title("")  saving("gg3`x'",replace) 
local gg3 `"`gg3' "gg3`x'""'	
}	

graph combine `gg3'  , col(2) saving(dist3, replace) 


/*** using multiply imputed data ***/
		
use "imputed.dta", clear


// Table A15

global x   "lprio_civilwar Lrsh_war le_migdppcln lv2x_libdem ethfrac postcold styear*"

set more off
eststo clear	
eststo: qui mi est, post : logit mkonset lelc_eliti lterrrivalry lterrr_elc $x if statefail ==1 & lmkincidence==0, cl(cowcode)
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti lterrrivalry lterrr_elc $x logLmunrest logLeunrest  if statefail ==1  & lmkincidence==0, cl(cowcode)  
foreach x of varlist log_ltrade_WB log_loilpop   {
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti lterrrivalry lterrr_elc $x `x'  if statefail ==1  & lmkincidence==0, cl(cowcode)  
}
eststo: qui mi est, post esampvaryok : logit mkonset lelc_eliti lterrrivalry lterrr_elc $x logLmunrest logLeunrest log_ltrade_WB log_loilpop   if statefail ==1 & lmkincidence==0, cl(cowcode)

esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label


// Table A16
set more off
eststo clear	
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x if statefail ==1  & lmkincidence==0 &  year<2002, cl(cowcode)
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x logLmunrest logLeunrest  if statefail ==1  & lmkincidence==0 & year<2002, cl(cowcode)

foreach x of varlist  log_ltrade_WB log_loilpop   {
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x `x'  if statefail ==1  & lmkincidence==0 & year<2002, cl(cowcode)
}
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti l1_tclaim ltclaim_elc $x logLmunrest logLeunrest log_ltrade_WB log_loilpop   if statefail ==1  & lmkincidence==0 & year<2002, cl(cowcode)

esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label


// Table A17

set more off
eststo clear	
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti l1_icowsal licow_elc $x if statefail ==1  & lmkincidence==0 & year<2002, cl(cowcode)
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti l1_icowsal licow_elc $x logLmunrest logLeunrest  if statefail ==1  & lmkincidence==0 & year<2002, cl(cowcode)
foreach x of varlist log_ltrade_WB log_loilpop   {
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti l1_icowsal l1_icowsal $x `x'  if statefail ==1  & lmkincidence==0 & year<2002, cl(cowcode)
}
eststo: qui mi est, post esampvaryok: logit mkonset lelc_eliti l1_icowsal l1_icowsal $x logLmunrest logLeunrest log_ltrade_WB log_loilpop   if statefail ==1  & lmkincidence==0 & year<2002, cl(cowcode)

esttab , star(+ 0.10 * 0.05 ** 0.01) b(3) se(3) noomitted nobase label
		

