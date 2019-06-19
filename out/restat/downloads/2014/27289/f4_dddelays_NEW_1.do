


clear
set more off



** loads data
************************

use mkt year quarter mkttkcarrier lcc_pres num_firm origin_herf dest_herf route_herf t100_depts using "complete.dta", clear 

compress 

* drops repetitive observations
sort mkt year quarter mkttkcarrier
drop if (mkt==mkt[_n-1] & year==year[_n-1] & quarter==quarter[_n-1] & mkttkcarrier==mkttkcarrier[_n-1])
drop mkttkcarrier

bysort origin: egen origin_depts=total(t100_depts)
bysort dest: egen dest_depts=total(t100_depts)


sort mkt year quarter
drop if mkt==mkt[_n-1] & year==year[_n-1] & quarter==quarter[_n-1]
save "D:\research\connan\compplan\data\other\temp.dta", replace




clear
use "delays_all.dta", clear


drop if strlen(mkt)~=6
drop if pct_cancel<0

*drop if num_obs<20
gen origin=substr(mkt,1,3)
gen dest=substr(mkt,4,3)




* merges in competition variables
sort mkt year quarter
merge m:1 mkt year quarter using "temp.dta"
tab _merge
drop if _merge==2
drop _merge

erase "temp.dta"



** merges origin information
************************

* merges origin population and income data
rename origin airport
sort airport year
merge airport year using "clean_bea_pop+pcincome.dta"
rename airport origin
rename pop pop_origin
rename pcinc pcinc_origin
tab _merge
drop if _merge==2
drop _merge



* merges origin faa enplanement data
rename origin airport
sort airport year 
merge airport year using "faa_carrier-airport\top2_all.dta"
tab _merge
drop if _merge==2
drop _merge
compress 
rename airport origin
rename airport_enplane origin_enplane
rename tot_airport_enplane tot_origin_enplane
rename pct_airport_enplane pct_origin_enplane
rename pct_airport_enplane_top2 pct_origin_enplane_top2
rename hub hub_origin
rename treat treat_origin
rename airportyear_rank airportyear_rank_origin
rename totyr_treat totyr_treat_origin
rename cumyr_treat cumyr_treat_origin
rename part_cover part_cover_origin
rename full_cover full_cover_origin
rename either_cover either_cover_origin





** merges dest information
************************

* merges dest population and income data
rename dest airport
sort airport year
merge airport year using "clean_bea_pop+pcincome.dta"
rename airport dest
rename pop pop_dest
rename pcinc pcinc_dest
tab _merge
drop if _merge==2
drop _merge



* merges dest faa enplanement data
rename dest airport
sort airport year 
merge airport year using "faa_carrier-airport\top2_all.dta"
tab _merge
drop if _merge==2
drop _merge
compress 
rename airport dest
rename airport_enplane dest_enplane
rename tot_airport_enplane tot_dest_enplane
rename pct_airport_enplane pct_dest_enplane
rename pct_airport_enplane_top2 pct_dest_enplane_top2
rename hub hub_dest
rename treat treat_dest
rename airportyear_rank airportyear_rank_dest
rename totyr_treat totyr_treat_dest
rename cumyr_treat cumyr_treat_dest
rename part_cover part_cover_dest
rename full_cover full_cover_dest
rename either_cover either_cover_dest






* calculates aggregate delay figures for market leve
************************

bysort mkt year quarter: egen mkt_obs=total(num_obs)
*drop if mkt_obs<20

gen wgt=num_obs/mkt_obs
bysort mkt year quarter: egen mkt_avg=total(wgt*avg_arr)
bysort mkt year quarter: egen mkt_15=total(wgt*pct_arr15)
bysort mkt year quarter: egen mkt_60=total(wgt*pct_arr60)
drop wgt




* drops repetitive observations
sort mkt year quarter 
drop if (mkt==mkt[_n-1] & year==year[_n-1] & quarter==quarter[_n-1])





** rescales population and income
************************
replace pop_origin=pop_origin/10000
replace pcinc_origin=pcinc_origin/10000
replace pop_dest=pop_dest/10000
replace pcinc_dest=pcinc_dest/10000



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



** defines "closeness" to the cutoff
************************
bysort dest: egen dest_max_top2=max(pct_dest_enplane_top2)
bysort origin: egen origin_max_top2=max(pct_origin_enplane_top2)
gen dest_absdiff=abs(dest_max_top2-.5)
gen origin_absdiff=abs(origin_max_top2-.5)



** allows the change for covered airports to be different after passage of the law
************************
gen byte covone=0
replace covone=1 if ((either_cover_origin==1 & either_cover_dest==0) | (either_cover_origin==0 & either_cover_dest==1)) 

gen byte covboth=0
replace covboth=1 if (either_cover_origin==1 & either_cover_dest==1)



* gets some descriptives
su mkt_avg if covone==1 | covboth==1
su mkt_avg if covone~=1 & covboth~=1



* rescales enplanements to be in millions
************************
replace dest_enplane=dest_enplane/1000000
replace origin_enplane=origin_enplane/1000000


** sets up lag structure
************************

* keeps only first quarter of data
keep if quarter==1
keep if (year==1993 | year==1999 | year==2002 | year==2008)


* sets panel and time-series variables
xtset, clear
tsset, clear

sort mkt 
egen mkt_id=group(mkt)
sort year quarter
egen time_id=group(year quarter)
sort mkt year
tsset mkt_id time_id, delta(1)





** generates first differences of variables
************************

foreach var of varlist mkt_avg mkt_15 mkt_60 pop_origin pop_dest pcinc_origin pcinc_dest lcc_pres num_firm origin_herf dest_herf route_herf {
       
		gen d_`var'=`var'-L1.`var'
		
}

keep if (year==1999 | year==2008)

* generates second differences
************************

xtset, clear
tsset, clear
drop time_id
sort year quarter
egen time_id=group(year quarter)
sort mkt year
tsset mkt_id time_id, delta(1)

gen dd_sample=1
foreach var of varlist mkt_avg mkt_15 mkt_60 pop_origin pop_dest pcinc_origin pcinc_dest lcc_pres num_firm origin_herf dest_herf route_herf {
       
	gen dd_`var'=d_`var'-L1.d_`var'
	replace dd_sample=0 if dd_`var'==.
}


* summarizes pre and post fares for descriptive table
bysort mkt: egen temp=max(dd_sample)
gen temp_cov=(covone==1 | covboth==1)
bysort mkt: egen max_temp_cov = max(temp_cov)

bysort max_temp_cov: su d_mkt_avg if (temp==1 & year==1999)
bysort max_temp_cov: su d_mkt_avg if (temp==1 & year==2008)

bysort max_temp_cov: su d_mkt_15 if (temp==1 & year==1999)
bysort max_temp_cov: su d_mkt_15 if (temp==1 & year==2008)


drop temp temp_cov




keep if year==2008




* drops airports that don't show up in both samples

keep mkt origin dest dd_mkt_avg dd_mkt_15 dd_mkt_60 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_sample dd_lcc_pres dd_num_firm dd_origin_herf dd_dest_herf dd_route_herf dest_absdiff origin_absdiff origin_max_top2 dest_max_top2



* gets rid of directional aspect of markets
gen airport_1=origin
gen airport_2=dest

reshape long airport_, i(mkt) string
sort mkt airport_
gen next=airport_[_n+1] if mkt==mkt[_n+1]
egen nondirectmkt=concat(airport_ next) if next~=""
drop if nondirectmkt==""



gen ones=1
bysort nondirectmkt: egen nondirectmkt_count=total(ones)
sort nondirectmkt_count nondirectmkt
drop ones
drop if nondirectmkt_count==1



* clears xtset and tsset
xtset, clear
tsset, clear



		
		

egen origin_id=group(origin)
egen dest_id=group(dest)



***********************************************************************
** SECOND DIFFERENCE
***********************************************************************


** avg arrival
***************************

* all markets
cgmreg dd_mkt_avg covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store avgarr_r1dd	

* .2 window
cgmreg dd_mkt_avg covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store avgarr_r2dd

* .1 window
cgmreg dd_mkt_avg covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store avgarr_r3dd



** ontime 15
***************************

* all markets
cgmreg dd_mkt_15 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store pct15_r1dd

* .2 window
cgmreg dd_mkt_15 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store pct15_r2dd

* .1 window
cgmreg dd_mkt_15 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store pct15_r3dd


** ontime 60
***************************

* all markets
cgmreg dd_mkt_60 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store pct60_r1dd

* .2 window
cgmreg dd_mkt_60 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store pct60_r2dd

* .1 window
cgmreg dd_mkt_60 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store pct60_r3dd




***********************************************************************
** SECOND DIFFERENCE - COMPETITION
***********************************************************************

** avg arrival
***************************

* all markets
cgmreg dd_mkt_avg covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store cavgarr_r1dd	

* .2 window
cgmreg dd_mkt_avg covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store cavgarr_r2dd

* .1 window
cgmreg dd_mkt_avg covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store cavgarr_r3dd



** ontime 15
***************************

* all markets
cgmreg dd_mkt_15 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store cpct15_r1dd

* .2 window
cgmreg dd_mkt_15 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store cpct15_r2dd

* .1 window
cgmreg dd_mkt_15 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store cpct15_r3dd


** ontime 60
***************************

* all markets
cgmreg dd_mkt_60 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<1 | origin_absdiff<1), cluster(origin_id dest_id)
estimates store cpct60_r1dd

* .2 window
cgmreg dd_mkt_60 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<.2 | origin_absdiff<.2), cluster(origin_id dest_id)
estimates store cpct60_r2dd

* .1 window
cgmreg dd_mkt_60 covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest ///
dd_origin_herf dd_dest_herf ///
if (dest_absdiff<.1 | origin_absdiff<.1), cluster(origin_id dest_id)
estimates store cpct60_r3dd



xml_tab avgarr_r1dd avgarr_r2dd avgarr_r3dd pct15_r1dd pct15_r2dd pct15_r3dd ///
pct60_r1dd pct60_r2dd pct60_r3dd ///
cavgarr_r1dd cavgarr_r2dd cavgarr_r3dd cpct15_r1dd cpct15_r2dd cpct15_r3dd ///
cpct60_r1dd cpct60_r2dd cpct60_r3dd ///
, sd below stats(r2 r2_a r2_b r2_w N) ///
sheet("dd_delay") replace save("delay_new.xls") ///
keep(covone covboth dd_pop_origin dd_pop_dest dd_pcinc_origin dd_pcinc_dest dd_origin_herf dd_dest_herf)

drop origin_id dest_id




** WRITES OUT FILES FOR RDD ANALYSIS
***************************


* generates origin and destination ids
sort origin
egen origin_id=group(origin)
sort dest
egen dest_id=group(dest)



* base data set
outfile dd_mkt_avg if dd_sample==1 using "dd_delays_avg.txt", wide nolabel replace
outfile origin_max_top2 dest_max_top2 if dd_sample==1 using "dd_delays_top2.txt", wide nolabel replace
outfile origin_id if dd_sample==1 using "dd_delays_origin_id.txt", wide nolabel replace
outfile dest_id if dd_sample==1 using "dd_delays_dest_id.txt", wide nolabel replace













