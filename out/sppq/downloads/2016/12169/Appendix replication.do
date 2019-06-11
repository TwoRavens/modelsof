
* This code generates Table A3 in the appendix of Terry (2016).

** As described in the appendix, the table replicates previous work by Husted and Kenny (1997: 73).




use "Appendix data.dta", clear

xtset statealphaid year


*************************************************************************
**************************************************************************
* TABLE A3: Husted and Kenny (1997) replication analysis
  
 
** Model 1: Husted and Kenny median voter replication. (SEE TABLE 5, MODEL 5)
xtreg propwelf rgrantsHK rpyHK dist race_prop age_prop metro_prop demcon_HK med1 i.year, fe


** Model 2: Husted and Kenny median voter replication. Southern sample only.
 xtreg propwelf rgrantsHK rpyHK dist race_prop age_prop metro_prop demcon_HK med1 i.year if confederate==1, fe
stop

** Model 3: Husted and Kenny median voter replication. Southern sample only with proportion of registrants black.
 xtreg propwelf rgrantsHK rpyHK dist race_prop age_prop metro_prop demcon_HK med1 propregblack i.year if confederate==1, fe


** Model 4: Husted and Kenny literacy test and poll tax replcation. (SEE TABLE 3, MODEL 5)
xtreg propwelf rgrantsHK rpyHK dist race_prop age_prop metro_prop demcon_HK lt pt i.year, fe


** Model 5: Husted and Kenny literacy test and poll tax replcation. Southern sample only.
xtreg propwelf rgrantsHK rpyHK dist race_prop age_prop metro_prop demcon_HK lt pt i.year if confederate==1, fe

 
** Model 6: Husted and Kenny literacy test and poll tax replcation. Southern sample only with proportion of registrants black.
xtreg propwelf rgrantsHK rpyHK dist race_prop age_prop metro_prop demcon_HK propregblack lt pt i.year if confederate==1, fe


 
**************************************************************************
**************************************************************************
