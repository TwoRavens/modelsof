*This file replicates all results reported in Table I of the main paper.

*clear Stata session
clear
eststo clear

*change working directory to location of main dataset
cd "JPR Replication Files\Data"
set more off

*load primary data
use "LOTL_Rep.dta", clear

*small NB
eststo: xi:nbreg incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime i.year, cluster(gid)

*small ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*medium ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*large ZINB
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*out-write results to a latex table
esttab using mainresults.tex, b(3) se(3) title(Atrocities Against Civilians (1997-2009)\label{tab:main})  nonumbers mtitles("Model 1" "Model 2" "Model 3" "Model 4") star(* 0.05 ** 0.01) replace
