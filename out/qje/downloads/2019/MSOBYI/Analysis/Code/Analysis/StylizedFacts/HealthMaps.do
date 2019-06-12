/* HealthMaps.do */

******************************************************************
** Install zip3 and state maps 
*ssc install maptile
*ssc install spmap


/* County-level maps */
*maptile_install using "http://files.michaelstepner.com/geo_county2010.zip"
use $Externals/Calculations/Geographic/Ct_DemandInfo.dta, replace
rename state_countyFIPS county
	* PrD_lHEI_per1000Cal PrD_HealthIndex_per1000Cal
maptile PrD_$HealthVar, geography(county2010) conus stateoutline(medthick) revcolor spopt(mosize(vvthin)) nq(10)  //  twopt(legtitle(HEI)) 
graph export Output/Maps/HealthyEatingByCounty.pdf, as(pdf) replace
