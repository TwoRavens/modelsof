*
*This file replicates the primary (Table 1) analysis reported in "Droughts, Land Appropriation, and Rebel Violence in The Developing World"
*by Benjamin E. Bagozzi, Ore Koren, and Bumba Mukherjee
*

*clear stata, set working directory
clear
set more off
cd "\JOP Replication Files\"

*read-in replication dataset
use "JOP_drought.dta", clear 

********************************
*********Table 1 Results********
********************************

*Model 1: Baseline NB
xi:nbreg incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop if lagcropland>0, cluster(gid) nolog difficult

*Model 2: Baseline ZINB
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop if lagcropland>0, inflate(laglogpop loglagttime lagurban lagcivconflagtemp) cluster(gid) nolog

*Model 3: Medium ZINB
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid) nolog

*Model 3: Large ZINB
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid) nolog

