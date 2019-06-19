

clear
clear matrix
clear mata
set more off
set memory 8000m

** loads data
************************
#delimit;
use  year quarter mkttkcarrier mktnonstopmiles mkt nonstop totpassengers avg_fare pct10_fare pct20_fare pct30_fare pct40_fare pct50_fare 
pct60_fare pct70_fare pct80_fare pct90_fare pct25_fare pct75_fare mkt_avg_fare mkt_pct10_fare mkt_pct20_fare mkt_pct30_fare mkt_pct40_fare
mkt_pct50_fare mkt_pct60_fare mkt_pct70_fare mkt_pct80_fare mkt_pct90_fare mkt_pct25_fare mkt_pct75_fare avg_distance avg_tktroundtrip numrouteserved 
totnumrouteserved fraction_routes origin dest pop_origin pcinc_origin hub_origin treat_origin airportyear_rank_origin totyr_treat_origin cumyr_treat_origin 
part_cover_origin full_cover_origin either_cover_origin pop_dest pcinc_dest hub_dest treat_dest airportyear_rank_dest totyr_treat_dest cumyr_treat_dest 
part_cover_dest full_cover_dest either_cover_dest pct_origin_enplane_top2 pct_dest_enplane_top2 hub_o_car hub_d_car hub_car lcc_pres num_firm
origin_share dest_share origin_herf dest_herf route_share route_herf has_other_prod
using "complete.dta", clear ;
#delimit cr
compress 


** rescales population, income, and distance
************************
replace pop_origin=pop_origin/10000
replace pcinc_origin=pcinc_origin/10000
replace pop_dest=pop_dest/10000
replace pcinc_dest=pcinc_dest/10000
replace avg_distance=avg_distance/1000


** keeps markets where neither endpoint is "not a hub, N" or "small hub, S" between 2000 and 2009
************************
gen flag=0
replace flag=1 if ((hub_origin=="N" | hub_origin=="S") | (hub_dest=="N" | hub_dest=="S"))
bysort mkt: egen max_flag=max(flag)
drop if max_flag==1
drop flag max_flag


** drops markets where one of the endpoints hub_origin and hub_dest is never labeled 
************************
gen flag_origin=0
gen flag_dest=0
replace flag_origin=1 if (hub_origin=="M" | hub_origin=="L")
replace flag_dest=1 if (hub_dest=="M" | hub_dest=="L")

bysort origin: egen max_flag_origin=max(flag_origin)
bysort dest: egen max_flag_dest=max(flag_dest)

drop if (max_flag_origin==0 | max_flag_dest==0) 
drop flag_origin flag_dest max_flag_origin max_flag_dest



** drops airports that were not simultaneously concentrated and large enough (could be useful for identification, just too small #)
************************  

* large enough one year, but not concentrated enough
drop if (origin=="ALB" | dest=="ALB")
* only becomes big enough for one year in 2003, very concentrated
drop if (origin=="ELP" | dest=="ELP")
* large enough one year, but not concentrated enough
drop if (origin=="GEG" | dest=="GEG")
* only becomes big enough from 2003 to 2009, then drops out in 2010, very concentrated
drop if (origin=="MHT" | dest=="MHT")
* large enough one year, but not concentrated enough
drop if (origin=="TUL" | dest=="TUL")
* only became concentrated enough in 2007 and drops out in 2010, also missed size cutoff in 2002
drop if (origin=="TUS" | dest=="TUS")

 
** flags some airports that were covered at a later time (JAX) or never had to file (SDF)
************************

gen flag_late=0
* covered in 2005, 2008, 2010
replace flag_late=1 if (origin=="LAS" | dest=="LAS")
* covered in only a couple years
replace flag_late=1 if (origin=="JAX" | dest=="JAX")
* covered in 2000, but never actually filed a plan
replace flag_late=1 if (origin=="SDF" | dest=="SDF")

*drop if (origin=="LAS" | dest=="LAS")
*drop if (origin=="JAX" | dest=="JAX")
*drop if (origin=="SDF" | dest=="SDF")


** drops carriers that do not serve enough passengers in a quarter to get accurate average fare
************************
drop if totpassengers<100


** defines "closeness" to the cutoff
************************
bysort dest: egen dest_max_top2=max(pct_dest_enplane_top2)
bysort origin: egen origin_max_top2=max(pct_origin_enplane_top2)
gen dest_absdiff=abs(dest_max_top2-.5)
gen origin_absdiff=abs(origin_max_top2-.5)



* replaces fares with logs of fares
gen lev_avg_fare=avg_fare
replace avg_fare=log(avg_fare)
replace pct20_fare=log(pct20_fare)
replace pct50_fare=log(pct50_fare)
replace pct80_fare=log(pct80_fare)




** allows the change for covered airports to be different after passage of the law
************************
gen byte covone=0
replace covone=1 if ((either_cover_origin==1 & either_cover_dest==0) | (either_cover_origin==0 & either_cover_dest==1)) 

gen byte covboth=0
replace covboth=1 if (either_cover_origin==1 & either_cover_dest==1)



** sets up lag structure
************************

* keeps only first quarter of data
keep if quarter==1


* sets panel and time-series variables
xtset, clear
tsset, clear

sort mkt mkttkcarrier nonstop
egen mktcarrier_id=group(mkt mkttkcarrier nonstop)

sort year quarter
egen time_id=group(year quarter)

sort mkt mkttkcarrier nonstop year
tsset mktcarrier_id time_id, delta(1)






** generates first differences of variables
************************

gen d_sample=1
foreach var of varlist lev_avg_fare avg_fare pct50_fare pct20_fare pct80_fare avg_distance fraction_routes pop_origin pop_dest pcinc_origin pcinc_dest ///
	lcc_pres num_firm origin_share dest_share origin_herf dest_herf route_share route_herf has_other_prod {
       	
		gen d_`var'=`var'-L1.`var'
		replace d_sample=0 if d_`var'==.
		
}




* clears xtset and tsset
xtset, clear
tsset, clear
drop mktcarrier_id time_id


egen origin_id=group(origin)
egen dest_id=group(dest)

* generates year dummies and interaction with treatment

forvalues i=1993(1)2008 {
		gen duyr_`i'=(year==`i')		
}

gen tcovone=(covone==1 & year>2001)
gen tcovboth=(covboth==1 & year>2001)



*** AVG Fare
**********************************************


** avg_fare
************************

* base regression for M,L hub markets, all markets 
cgmreg d_avg_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store avg_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg d_avg_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store avg_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_avg_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store avg_r3	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_avg_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.05 | origin_absdiff<.05), cluster(origin_id dest_id)
estimates store avg_r4	




** avg_fare - competition
************************

* base regression for M,L hub markets, all markets 
cgmreg d_avg_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store cavg_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg d_avg_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store cavg_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_avg_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store cavg_r3	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_avg_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.05 | origin_absdiff<.05), cluster(origin_id dest_id)
estimates store cavg_r4



xml_tab avg_r1 avg_r2 avg_r3 avg_r4 cavg_r1 cavg_r2 cavg_r3 cavg_r4, sd below stats(r2 r2_a r2_b r2_w N) ///
sheet("d_avg") replace save("fares.xls") ///
keep(d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest ///
	d_lcc_pres d_num_firm d_origin_herf d_dest_herf d_route_herf d_has_other_prod)


	
*** pct20 Fare
**********************************************


** pct20_fare
************************

* base regression for M,L hub markets, all markets 
cgmreg d_pct20_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store pct20_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg d_pct20_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store pct20_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct20_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store pct20_r3	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct20_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.05 | origin_absdiff<.05), cluster(origin_id dest_id)
estimates store pct20_r4	




** pct20_fare - competition
************************

* base regression for M,L hub markets, all markets 
cgmreg d_pct20_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store cpct20_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg d_pct20_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store cpct20_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct20_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store cpct20_r3	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct20_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.05 | origin_absdiff<.05), cluster(origin_id dest_id)
estimates store cpct20_r4



xml_tab pct20_r1 pct20_r2 pct20_r3 pct20_r4 cpct20_r1 cpct20_r2 cpct20_r3 cpct20_r4, sd below stats(r2 r2_a r2_b r2_w N) ///
sheet("d_pct20") append save("fares.xls") ///
keep(d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest ///
	d_lcc_pres d_num_firm d_origin_herf d_dest_herf d_route_herf d_has_other_prod)	
	

	
	
	
	
	
*** pct50 Fare
**********************************************


** pct50_fare
************************

* base regression for M,L hub markets, all markets 
cgmreg d_pct50_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store pct50_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg d_pct50_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store pct50_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct50_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store pct50_r3	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct50_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.05 | origin_absdiff<.05), cluster(origin_id dest_id)
estimates store pct50_r4	




** pct50_fare - competition
************************

* base regression for M,L hub markets, all markets 
cgmreg d_pct50_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store cpct50_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg d_pct50_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store cpct50_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct50_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store cpct50_r3	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct50_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.05 | origin_absdiff<.05), cluster(origin_id dest_id)
estimates store cpct50_r4



xml_tab pct50_r1 pct50_r2 pct50_r3 pct50_r4 cpct50_r1 cpct50_r2 cpct50_r3 cpct50_r4, sd below stats(r2 r2_a r2_b r2_w N) ///
sheet("d_pct50") append save("fares.xls") ///
keep(d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest ///
	d_lcc_pres d_num_firm d_origin_herf d_dest_herf d_route_herf d_has_other_prod)		

	
	
	
	
	
*** pct80 Fare
**********************************************


** pct80_fare
************************

* base regression for M,L hub markets, all markets 
cgmreg d_pct80_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store pct80_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg d_pct80_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store pct80_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct80_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store pct80_r3	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct80_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.05 | origin_absdiff<.05), cluster(origin_id dest_id)
estimates store pct80_r4	




** pct80_fare - competition
************************

* base regression for M,L hub markets, all markets 
cgmreg d_pct80_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store cpct80_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg d_pct80_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store cpct80_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct80_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store cpct80_r3	

* base regression for M,L hub markets, .05 window markets 
cgmreg d_pct80_fare d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth duyr_* ///
	d_lcc_pres d_num_firm d_origin_share d_dest_share d_origin_herf d_dest_herf d_route_share d_route_herf d_has_other_prod ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest if (dest_absdiff<.05 | origin_absdiff<.05), cluster(origin_id dest_id)
estimates store cpct80_r4



xml_tab pct80_r1 pct80_r2 pct80_r3 pct80_r4 cpct80_r1 cpct80_r2 cpct80_r3 cpct80_r4, sd below stats(r2 r2_a r2_b r2_w N) ///
sheet("d_pct80") append save("fares.xls") ///
keep(d_avg_distance d_fraction_routes nonstop covone covboth tcovone tcovboth ///
	d_pop_origin d_pop_dest d_pcinc_origin d_pcinc_dest ///
	d_lcc_pres d_num_firm d_origin_herf d_dest_herf d_route_herf d_has_other_prod)		

