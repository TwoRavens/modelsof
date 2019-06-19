

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


* does some basic descriptives
************************

su lev_avg_fare avg_distance fraction_routes totpassengers mkt_avg_fare mkt_pct20_fare mkt_pct50_fare mkt_pct80_fare lcc_pres num_firm if covone==1 | covboth==1
su lev_avg_fare avg_distance fraction_routes totpassengers mkt_avg_fare mkt_pct20_fare mkt_pct50_fare mkt_pct80_fare lcc_pres num_firm if covone~=1 & covboth~=1





** sets up lag structure
************************

* keeps only first quarter of data
keep if quarter==1
keep if (year==1994 | year==1999 | year==2002 | year==2008)


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




keep if (year==1999 | year==2008)




* generates second differences
************************
xtset, clear
tsset, clear
drop time_id
sort year quarter
egen time_id=group(year quarter)
sort mkt mkttkcarrier nonstop year
tsset mktcarrier_id time_id, delta(1)

gen dd_sample=1
foreach var of varlist lev_avg_fare avg_fare pct50_fare pct20_fare pct80_fare avg_distance fraction_routes pop_origin pop_dest pcinc_origin pcinc_dest lcc_pres num_firm origin_share dest_share origin_herf dest_herf route_share route_herf has_other_prod {
       
		gen dd_`var'=d_`var'-L1.d_`var'
		replace dd_sample=0 if dd_`var'==.
}

* summarizes pre and post fares for descriptive table
bysort mkt mkttkcarrier nonstop: egen temp=max(dd_sample)
gen temp_cov=(covone==1 | covboth==1)
bysort mkt mkttkcarrier nonstop: egen max_temp_cov = max(temp_cov)

bysort max_temp_cov: su d_lev_avg_fare if (temp==1 & year==1999)
bysort max_temp_cov: su d_lev_avg_fare if (temp==1 & year==2008)

bysort max_temp_cov: su d_fraction_routes if (temp==1 & year==1999)
bysort max_temp_cov: su d_fraction_routes if (temp==1 & year==2008)

bysort max_temp_cov: su d_avg_distance if (temp==1 & year==1999)
bysort max_temp_cov: su d_avg_distance if (temp==1 & year==2008)


drop temp temp_cov
keep if year==2008


* clears xtset and tsset
xtset, clear
tsset, clear
drop mktcarrier_id time_id


egen origin_id=group(origin)
egen dest_id=group(dest)



** avg_fare
************************

* base regression for M,L hub markets, all markets 
cgmreg dd_avg_fare dd_avg_distance dd_fraction_routes nonstop covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store avg_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg dd_avg_fare dd_avg_distance dd_fraction_routes nonstop covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store avg_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg dd_avg_fare dd_avg_distance dd_fraction_routes nonstop covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store avg_r3	



** avg_fare - competition
************************

* base regression for M,L hub markets, all markets 
cgmreg dd_avg_fare dd_avg_distance dd_fraction_routes nonstop covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_lcc_pres dd_num_firm dd_origin_share dd_dest_share dd_origin_herf dd_dest_herf dd_route_share dd_route_herf dd_has_other_prod ///
if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store cavg_r1	

* base regression for M,L hub markets, .1 window markets 
cgmreg dd_avg_fare dd_avg_distance dd_fraction_routes nonstop covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_lcc_pres dd_num_firm dd_origin_share dd_dest_share dd_origin_herf dd_dest_herf dd_route_share dd_route_herf dd_has_other_prod ///
if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store cavg_r2	

* base regression for M,L hub markets, .05 window markets 
cgmreg dd_avg_fare dd_avg_distance dd_fraction_routes nonstop covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_lcc_pres dd_num_firm dd_origin_share dd_dest_share dd_origin_herf dd_dest_herf dd_route_share dd_route_herf dd_has_other_prod ///
if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store cavg_r3	



xml_tab avg_r1 avg_r2 avg_r3 cavg_r1 cavg_r2 cavg_r3, sd below stats(r2 r2_a r2_b r2_w N) ///
sheet("dd_fare") replace save("fares_new.xls") ///
keep(dd_avg_distance dd_fraction_routes nonstop covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_lcc_pres dd_num_firm dd_origin_herf dd_dest_herf dd_route_herf dd_has_other_prod)


drop origin_id dest_id



** WRITES OUT FILES FOR RDD ANALYSIS
***************************


* generates origin and destination ids
sort origin
egen origin_id=group(origin)
sort dest
egen dest_id=group(dest)

* base data set
outfile dd_lev_avg_fare if dd_sample==1 using "dd_lev_avg.txt", wide nolabel replace
outfile dd_avg_fare if dd_sample==1 using "dd_avg.txt", wide nolabel replace
outfile dd_pct20_fare if dd_sample==1 using "\dd_pct20.txt", wide nolabel replace
outfile dd_pct50_fare if dd_sample==1 using "dd_pct50.txt", wide nolabel replace
outfile dd_pct80_fare if dd_sample==1 using "dd_pct80.txt", wide nolabel replace

outfile origin_max_top2 dest_max_top2 if dd_sample==1 using "\dd_fare_top2.txt", wide nolabel replace
outfile origin_id if dd_sample==1 using "dd_fare_origin_id.txt", wide nolabel replace
outfile dest_id if dd_sample==1 using "dd_fare_dest_id.txt", wide nolabel replace







** WRITES OUT FILES FOR MANIPULATION TEST
***************************


* merges in origin and dest concentration by year
rename origin airport
sort airport year
merge m:1 airport year using "top2_all.dta", keepusing(rank1_share) 
tab _merge 
drop if _merge==2
drop _merge
rename airport origin
rename rank1_share origin_rank1_share

drop if pct_origin_enplane_top2>.5


* writes out matlab files
outfile dd_avg_fare if dd_sample==1 using "fare_manipulate.txt", wide nolabel replace
outfile origin_rank1_share if dd_sample==1 using "rank1_manipulate.txt", wide nolabel replace
outfile pct_origin_enplane_top2 if dd_sample==1 using "top2_manipulate.txt", wide nolabel replace




