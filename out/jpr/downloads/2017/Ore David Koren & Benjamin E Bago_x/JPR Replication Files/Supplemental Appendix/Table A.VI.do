*This code replicates Table A.VI, which is reported in the Supplemental Appendix

*Clear Stata sessionclear
eststo clear

*change working directory to location of primary replication dataset
cd "JPR Replication Files\Data"
set more off

*load primary data
use "LOTL_Rep.dta", clear

********************************************************************************
**************************Estimate Relevant Models******************************
********************************************************************************

*rebel conflict only
eststo:  xi:zinb acled_rebciv lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splacled_rebciv loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*gov conflict only
eststo:  xi:zinb acled_govciv lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splacled_govciv loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid) difficult

*gov conflict only, low milex countries
eststo:  xi:zinb acled_govciv lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splacled_govciv loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year if lagmilper<72.50783, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid) difficult

*militia conflict only
eststo:  xi:zinb acled_milciv lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splacled_milciv loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid) difficult

*govreb conflict only
eststo:  xi:zinb acled_govrebciv lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splacled_govrebciv loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*outwrite results to latex table
esttab using disagg.tex, b(3) se(3) title(Disaggregated Robustness Models (1997-2009)\label{tab:DisRob})  nonumbers mtitles("Rebel Perpetrators" "Government Perpetrators" "Militia Perpetrators" "Rebel and Government Perpetrators (No Militia)") star(* 0.05 ** 0.01) replace
