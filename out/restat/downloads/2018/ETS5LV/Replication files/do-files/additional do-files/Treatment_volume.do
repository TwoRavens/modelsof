

*** This file breaks down the number of treated subdistrict and household - years ***


use "$data/podes_pkhrollout.dta", clear



gen temp=pop_size if year==2011
bys kecid2000: egen pop_size2011=max(temp)
drop temp

*** Extrapolat population size linearly ***
gen pop_size2007=(pop_size2011-pop_size2005)*2/6+pop_size2005
gen pop_size2008=(pop_size2011-pop_size2005)*3/6+pop_size2005
gen pop_size2009=(pop_size2011-pop_size2005)*4/6+pop_size2005
gen pop_size2010=(pop_size2011-pop_size2005)*5/6+pop_size2005
gen pop_size2012=(pop_size2011-pop_size2005)*7/6+pop_size2005
gen pop_size2013=(pop_size2011-pop_size2005)*8/6+pop_size2005
gen pop_size2014=(pop_size2011-pop_size2005)*9/6+pop_size2005


*** HH level *** 
gen hhtreat_07= pop_size2007*0.1*treat2007
gen hhtreat_08= pop_size2008*0.1*treat2008 
gen hhtreat_10= pop_size2010*0.1*treat2010
gen hhtreat_11= pop_size2011*0.1*treat2011 
gen hhtreat_12= pop_size2012*0.1*treat2012
gen hhtreat_13= pop_size2013*0.1*treat2013


*** Keca level ***


gen treat_dur=6*treat2007 if treat2007>0
replace treat_dur=6*treat2008 if treat2008>0
replace treat_dur=4*treat2010 if treat2010>0
replace treat_dur=3*treat2011 if treat2011>0
replace treat_dur=2*treat2012 if treat2012>0
replace treat_dur=1*treat2013 if treat2013>0
replace treat_dur=0 if treat_dur==.

*Generate treatment duration for each group

gen treat_dur_07=6
gen treat_dur_08=6
gen treat_dur_10=4
gen treat_dur_11=3
gen treat_dur_12=2
gen treat_dur_13=1

*Keep one observation per keca
duplicates drop kecid200, force


*** Treated KECA years ***

egen treat_keca_years=total(treat_dur)

qui sum treat_keca_years

di "The total number of treated subdistrict years is: " r(mean)

di "The program averted 0.2 suicides per subdistrict year, on average."
di "Thus, the total number of averted suicides is: " r(mean)*0.2

di "That is " 716/(r(mean)*0.2) "million dollar per suicide" //The total expenditure was 716 million dollar (see Expenditure .xls file).

*Generate hh-years

gen hh_years_07=hhtreat_07* treat_dur_07
gen hh_years_08=hhtreat_08* treat_dur_08
gen hh_years_10=hhtreat_10* treat_dur_10
gen hh_years_11=hhtreat_11* treat_dur_11
gen hh_years_12=hhtreat_12* treat_dur_12
gen hh_years_13=hhtreat_13* treat_dur_13

keep treat* hh*

collapse (sum) hh* 

egen  hhtreat_total=rowtotal(hhtreat*)

egen  hh_years_total=rowtotal(hh_years*)

qui sum hh_years_total

di "The total number of treated household-years is: " r(mean)



***Average household size in 2011***

use "$data/podes_pkhrollout.dta", clear

keep if year==2011


egen temp=sum(pop_size)


egen temp1=sum(n_families)

gen temp2=temp/temp1
qui sum temp2
di "The average family size in the 2011 PODES is: " r(mean)








