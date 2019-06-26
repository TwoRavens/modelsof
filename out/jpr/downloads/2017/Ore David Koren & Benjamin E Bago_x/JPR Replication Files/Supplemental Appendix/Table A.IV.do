*This code replicates Table A.IV, which is reported in the Supplemental Appendix

*Clear Stata session
clear
eststo clear

*Change working directory to the location of the main replication dataset
cd "JPR Replication Files\Data"
set more off

*load primary data
use "LOTL_Rep.dta", clear

********************************************************************************
**************************Estimate Relevant Models******************************
********************************************************************************

*only civil war countries
eststo:  xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year if civconfany==1, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*Non civil war countries
eststo:  xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year if civconfany==0, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*robustness model 1: ZIP
eststo:  xi:zip incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*robustness model 2: alt time setup
eststo:   xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull lagincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*robustness model 3: PITF measure 
eststo:  xi:zinb incidentsumfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentsumfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year if acled_country==1, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*robustness model outliers removed
eststo:  xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year if incidentacledfull<70, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*Alternate cropland measure
eststo:  xi:zinb incidentacledfull lagcivconflagtemp lag_agri_ih interaction3 laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*use robustness data
use "LOTL_OneDegRobustness", clear
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid) difficult

*load primary data
use "LOTL_Rep.dta", clear

*Alt spatial lag 1
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splacleddum loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*Military Expenditure
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year if loglagmilex<12.51, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*Military Expenditure
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year if lagmilper<72.50783, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*firth logit
eststo: xi:firthlogit acleddum lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splacleddum loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin

*outwrite results to a latex table
esttab using robustresults.tex, b(3) se(3) title(Zero-Inflated Negative Binomial Robustness Models (1997-2009)\label{tab:main})  nonumbers mtitles("Civil Conflict Countries" "Non-Civil Conflict Countries"  "Zero-Inflated Poisson" "Alternative Temporal Controls" "PITF Atrocities" "Outliers Removed" "Alternate Cropland" "1-Degree Cells" "Dichotomous Lag" "Low Mil. Exp." "Low Mil. Exp. PC"  "Firth Logit") star(* 0.05 ** 0.01) replace
