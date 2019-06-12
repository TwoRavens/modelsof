*
*This file replicates the Tables A.5-A.6 robustness analysis reported in
*the supplemental appendix to "Droughts, Land Appropriation, and Rebel Violence in The Developing World"
*by Benjamin E. Bagozzi, Ore Koren, and Bumba Mukherjee
*

*clear stata, set working directory
clear
set more off
cd "\JOP Replication Files\"

*read-in replication dataset
use "JOP_drought.dta", clear 

************************************
*********Table A.5-A.6 Results******
************************************

*Year FE in Inflation Stage
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum i.year) cluster(gid) difficult nolog

*Spatially Lagged DV in Inflation Stage)
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum spatialDVlag) cluster(gid) difficult nolog

*All Additional Controls
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum temp logprec lagpolitysq spatialDVlag al_ethnic lagincidentstatefull t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum spatialDVlag) cluster(gid) difficult nolog

*Alternative Drought Var. 
xi:zinb incidentnonstatefull lagcivconflagtemp spi6 loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spi6) cluster(gid) nolog

*ZIP Model 
xi:zip incidentnonstatefull lagcivconflagtemp spidum  loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag  t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum ) cluster(gid) nolog

*GED-Atrocity Sample
xi: zinb GED_atrocities lagcivconflagtemp spidum  loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum splag_GED_atrocities ged_t ged_t2 ged_t3 if lagcropland>0 & GED_flag==1, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid) nolog

*Non-Urban Cells Only
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland  loglagwdi_gdpc laggroupsum  spatialDVlag  t t2 t3 if lagurban<10, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid) difficult nolog

*Africa sample
keep if (ccode>400 & ccode<630) | ccode==651
xi:zinb incidentnonstatefull lagcivconflagtemp spidum  loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum  spatialDVlag t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban  loglagwdi_gdpc lagp_polity2 spidum) cluster(gid) difficult nolog

