*This code replicates Table A.VII, which is reported in the Supplemental Appendix

*Clear Stata session
clear
eststo clear

*Change working directory to location of main replication dataset
cd "\JPR Replication Files\Data"
set more off

*load primary data
use "LOTL_Rep.dta", clear


********************************************************************************
***********************Estimate Relevant Models*********************************
********************************************************************************

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex lagter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex lagter_change i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp ter_change_bin) cluster(gid)

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex lagter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp  lagter_change_bin) cluster(gid)

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp ter_change) cluster(gid)

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex lagter_change i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp lagter_change) cluster(gid)

*save results to latex table
esttab using territoryresults.tex, b(3) se(3) title(Atrocities Against Civilians (1997-2009)\label{tab:main})  nonumbers mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8") star(* 0.05 ** 0.01) replace
