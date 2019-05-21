*
*This file replicates the Table A.4 summary statistics reported in
*the supplemental appendix to "Droughts, Land Appropriation, and Rebel Violence in The Developing World"
*by Benjamin E. Bagozzi, Ore Koren, and Bumba Mukherjee
*
*Following this, we provide the code that was used to derive the summary statistics that are discussed in the
*text of the main paper's introduction.

*clear stata, set working directory
clear
set more off
cd "\JOP Replication Files\"

*read-in replication dataset
use "JOP_drought.dta", clear 

********************************
*********Table A.4 Results******
********************************

*summarize variables
summarize incidentnonstatefull spidum spi6 lagcivconflagtemp  loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc temp logprec lagspidum al_ethnic laggroupsum lagpolitysq GED_atrocities spatialDVlag splag_GED_atrocities lagincidentstatefull if lagcropland!=0, detail


************************************
*******Intro Summary Statistics*****
************************************

*non-state atrocities within and outside of civil conflict cells
collapse (sum) incidentnonstatefull, by(civconf)
table incidentnonstatefull

*non-state atrocities within and outside of cropland cells
*read in main data
use "JOP_drought.dta", clear 
collapse (sum) incidentnonstatefull, by(croplanddum)
table incidentnonstatefull

*atrocity affected grid-cells
*read in main data
use "JOP_drought.dta", clear
keep if cropland>0
collapse (sum) incidentnonstatefull, by(gid)
generate incidentdum=0
replace incidentdum=1 if incidentnonstatefull>0
replace incidentdum=. if incidentnonstatefull==.
table incidentdum
