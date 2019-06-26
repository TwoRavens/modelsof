*This code replicates Table A.V, which is reported in the Supplemental Appendix

*Clear Stata session
clear
eststo clear

*change working directory to location of main replication dataset
cd "JPR Replication Files\Data"
set more off

*load primary data
use "LOTL_Rep.dta", clear

*estimate relevant models
eststo:  xi:nbreg incidentacledfull civconf lagcropland interaction2 laglogpop loglagcellarea loglagppp loglagttime i.year, cluster(gid)
eststo:  xi:zinb incidentacledfull civconf lagcropland interaction2 laglogpop loglagcellarea loglagppp loglagttime i.year, inflate(loglagttime laglogpop loglagcellarea civconf) cluster(gid)
eststo:  xi:zinb incidentacledfull civconf lagcropland interaction2 laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 i.year, inflate(loglagttime laglogpop loglagcellarea civconf) cluster(gid)
eststo:  xi:zinb incidentacledfull civconf lagcropland interaction2 laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea civconf) cluster(gid)

*out-write results to latex table
esttab using civconft.tex, b(3) se(3) title(Civil Conflict$_{t}$ Robustness Models (1997-2009)\label{tab:main})  nonumbers mtitles("Model 1" "Model 2" "Model 3" "Model 4") star(* 0.05 ** 0.01) replace
