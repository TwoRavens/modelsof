*This code replicates Table A.III, which is reported in the Supplemental Appendix

*Clear Stata session
clear
eststo clear

*change working directory to location of main replication dataset
cd "JPR Replication Files\Data"
set more off

*load primary data
use "LOTL_Rep.dta", clear

*estimate relevant models
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin laggroupsum loglagross_oil_prod loglagross_gas_prod i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin laggroupsum loglagross_oil_prod loglagross_gas_prod lagcapdist countrycropland i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin laggroupsum loglagross_oil_prod loglagross_gas_prod lagcapdist countrycropland lagGDPgrowth lagpts_amn i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)
eststo: xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin laggroupsum loglagross_oil_prod loglagross_gas_prod lagcapdist countrycropland lagGDPgrowth lagpts_amn lagpresence_informal lagPKOdum lagacled i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)

*out-write results as a latex table
esttab using expcontrols.tex, b(3) se(3) title(Expanded Controls Robustness Models (1997-2009)\label{tab:expcontrols})  nonumbers mtitles("Model 1" "Model 2" "Model 3" "Model 4") star(* 0.05 ** 0.01) replace
