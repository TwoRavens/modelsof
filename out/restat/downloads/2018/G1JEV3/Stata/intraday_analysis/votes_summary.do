set more off  //Note: As in GW (2016) and GSS (2005) we use standard S&P500 and yield changes (we do not apply risk-free TYield as LM(2015))
capture log close

use "$path1\\FED_dissent_date_governors.dta", clear
drop if year<1994
joinby date_FOMC using "$path1\FOMC_Xvars.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_FOMC using "$path1\FED_dissent_date_extralags.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_FOMC using "$path1\\dissent_pastTrack.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_day using "$path1\\FED_dissent_date.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_day using "$path1\\FED_dissent_6dayW.dta", unmatched(master) update //joinby date_day using "$path1\\bloomberg2_dissent_window.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge
joinby year day month using "$path1\\FED_surprise.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge Date
joinby date_day using "$path1\bloomberg2_reduced.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge 
joinby date_day using "$path1\\yields_d.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge
joinby year month using "$path1\CycleDummyVariables.dta", unmatched(master) update
tab _merge
drop _merge
xtset id_member date_FOMC
log using "$path0T0\dissent_gov1.log", replace  
tab dissent
xtlogit dissent, re
clogit dissent, group(id_member)
di 1 - (-275.44423)/(-285.98179)  //-275.44423  -285.98179 
di 1 - (-183.10983 )/(-193.63496)
logit dissent exp_votes_all exp_all_FOMC exp_dissents_FOMC USA_TB10y_p VIX_p S_P500_itv //S_P500_dv 
outreg2 using "$path0T0\logit1.xls", replace
xtlogit dissent exp_votes_all exp_all_FOMC exp_dissents_FOMC USA_TB10y_p VIX_p S_P500_itv, re
outreg2 using "$path0T0\logit1.xls", append
clogit dissent exp_votes_all exp_all_FOMC exp_dissents_FOMC USA_TB10y_p VIX_p S_P500_itv, group(id_member)
outreg2 using "$path0T0\logit1.xls", append
clogit dissent exp_all_FOMC exp_dissents_FOMC USA_TB10y_p VIX_p S_P500_itv, group(id_member)
outreg2 using "$path0T0\logit1.xls", append
log close
clear

use "$path1\FED_dissent_date.dta", clear //"$path0\FOMC_timeseries.dta"
drop if year<1994
joinby date_FOMC using "$path1\FOMC_Xvars.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_FOMC using "$path1\FED_dissent_date_extralags.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_FOMC using "$path1\\dissent_pastTrack.dta", unmatched(master) update
tab _merge
drop _merge
tsset date_day
label variable date_day "FOMC Date"
label variable dissent "Dissent"
label variable nr_dissents "Dissent Votes"
tsline dissent nr_dissents 
collapse dissent nr_dissents, by(month year)
g date_month=ym(year,month)
format %tm date_month
tsset date_month
label variable date_month "FOMC Date"
label variable dissent "Dissent"
label variable nr_dissents "Dissent Votes"
tsline dissent nr_dissents //, note("")
graph export "$path_g\tsline_votes.emf", replace

use "$path1\FED_dissent_date_governors.dta", clear
bysort date_day: egen NV=count(dissent)
bysort date_day: egen NV2=sum(dissent)
tab NV2 nr_dissents
collapse dissent nr_dissents NV, by(date_day month year)
g fraction_dissents=nr_dissents/NV
format %td date_day
tsset date_day
label variable date_day "FOMC Date"
label variable fraction_dissents "Fraction of Dissent Votes"
tsline fraction_dissents //, note("")
graph export "$path_g\tsline_Fvotes.emf", replace
collapse dissent nr_dissents fraction_dissents, by(month year)
g date_month=ym(year,month)
format %tm date_month
tsset date_month
label variable date_month "FOMC Date"
label variable fraction_dissents "Fraction of Dissent Votes"
tsline fraction_dissents //, note("")
graph export "$path_g\tsline_Fvotes2.emf", replace

global pathF2 "D:\Docs2\CM_JM\RESTAT_newcodes\new_data\fed_votes_data\\"
log using "$path0T0\dissent_gov_summary.log", replace  
use "$pathF2\\FED_dissent93_13f.dta", clear // 1994-2002
keep if FOMC_public_vote==0
drop if year<1994
tab dissent
tab dissent_ma
tab dissent_la
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
sum nr_votes if id_d>0, d
sum id_d if dissent_one_or_more==1, d
use "$pathF2\\FED_dissent93_13f.dta", clear // 2002-2018
keep if FOMC_public_vote==1
tab dissent
tab dissent_ma
tab dissent_la
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
sum nr_votes if id_d>0, d
sum id_d if dissent_one_or_more==1, d
use "$path1\\FED_dissent_date.dta", clear
drop if year<1994
tab dissent_la if FOMC_public_vote==0
tab dissent_ma if FOMC_public_vote==0
tab dissent if FOMC_public_vote==0
tab dissent_la if FOMC_public_vote==1
tab dissent_ma if FOMC_public_vote==1
tab dissent if FOMC_public_vote==1
log close
