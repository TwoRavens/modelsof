*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A.7 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
						*-----------------------------------------------------------------*
						*-----------------------------------------------------------------*
						* TABLE A.7 - CORRELATIONS CONFLICTS - CELL SPEC. CHARACTERISTICS *    
						*-----------------------------------------------------------------*
						*-----------------------------------------------------------------*
*
use "$Output_data\data_BC_Restat2014", clear
/* Some statistics about conflicts and distance */
sum distance_cp, d
forvalues x=25(25)75{
egen p`x'_distance_cp = pctile(distance_cp), p(`x')
}
gen dist_cat     = 1 if distance_cp <  p25_distance_cp & distance_cp !=.
replace dist_cat = 2 if distance_cp > =p25_distance_cp & distance_cp <p50_distance_cp & distance_cp !=.
replace dist_cat = 3 if distance_cp > =p50_distance_cp & distance_cp <p75_distance_cp & distance_cp !=.
replace dist_cat = 4 if distance_cp > =p75_distance_cp & distance_cp !=.	 		  & distance_cp !=.
*
bys dist_cat: sum conflict_c1 conflict_c2 conflict_c3
*
g temp0 = pop if year == 1990
bys gid : egen pop90 = mean(pop)
g lgdp    			 = log(ppp90)
g lpop 			  	 = log(pop90)

foreach x in c3 c1 c2{
eststo: reg conflict_`x' ldist ldist_cap ldist_bord ldist_res			 yeard* iso3d*, ro
eststo: reg conflict_`x' ldist ldist_cap ldist_bord ldist_res lgdp lpop  yeard* iso3d*, ro
}
log using Table_A7.log, replace
set linesize 250
esttab, mtitles keep(ldist ldist_cap ldist_bord ldist_res  lgdp lpop) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(ldist ldist_cap ldist_bord ldist_res  lgdp lpop) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
