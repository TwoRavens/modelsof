*
*This file replicates the Table A.7 robustness analysis reported in
*the supplemental appendix to "Droughts, Land Appropriation, and Rebel Violence in The Developing World"
*by Benjamin E. Bagozzi, Ore Koren, and Bumba Mukherjee
*

*clear stata, set working directory
clear
set more off
cd "\JOP Replication Files\"

*read-in replication dataset
use "JOP_drought.dta", clear 


********************************
*********Table A.7 Results*****
********************************

*Model 1: Baseline NB
xi:nbreg incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop, cluster(gid) nolog difficult

*Model 2: Baseline ZINB
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop, inflate(laglogpop loglagttime lagurban lagcivconflagtemp) cluster(gid) nolog difficult

*Model 3: Medium ZINB
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid) difficult

*Model 4: Large ZINB
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag t t2 t3, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid) difficult

