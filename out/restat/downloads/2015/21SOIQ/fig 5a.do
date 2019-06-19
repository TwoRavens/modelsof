clear
set more off
set mem 5000m 
set matsize 500 
capture log close
log using /ssb/ovibos/a1/swp/kav/wk24/allreforms/log/graph_dys_leave_92.log, replace

/*forst test ut forskjellige spesifikasjoner paa 2 utfall: GPA (skriftlig) og 14-diskontert mors inntekt. Test paa reform 90, 91,92*/




                                                                    
                                             
/*********************************
*days of parental leave 1992-2009
**********************************/




use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95_costs.dta, clear

*keep if in window

gen reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(7,1,1992)
replace reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(1,1,1992)
tab b_month if reform92==1
tab b_month if reform92==0

keep if reform92!=.

drop if mor_lnr==0
keep if eligible==1

keep mor_lnr lnr fodtaar

bys mor_lnr: gen n=_n
bys mor_lnr: gen N=_N
tab N

*samme fodselsdag (multiples)?
drop n N
bys mor_lnr fodtaar: gen n=_n
bys mor_lnr fodtaar: gen N=_N
tab N
drop N n

bys mor_lnr: gen n=_n
reshape wide fodtaar lnr, i(mor_lnr) j(n)



save "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/sample_temp.dta", replace

*Create dataset
clear
use "/ssb/ovibos/h1/kvs/wk24/fodsel_f_fp.dta"
destring , replace force
keep lnr arbuf spfom sptom fpregr
rename lnr mor_lnr


sort mor_lnr

merge m:1 mor_lnr using "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/sample_temp.dta"

drop if _merge==1

drop _merge



save "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/daysleave9209.dta", replace

erase "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/sample_temp.dta"


*****CREATE days of leave per child

*first, generate elapsed time format of year of birth and spells

clear
use "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/daysleave9209.dta"

tostring arbuf spfom sptom, replace format(%20.0f)
gen earbuf=date(arbuf, "YMD")
gen espfom=date(spfom, "YMD")
gen esptom=date(sptom, "YMD")


format earbuf espfom esptom %td
drop arbuf spfom sptom  
save "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/daysleave9209.dta", replace

clear
use "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/daysleave9209.dta"

*Mother child 1

gen end_1_m=esptom if esptom<=fodtaar1+500 & esptom>fodtaar1
gen start_1_m=earbuf if earbuf<=fodtaar1+400 & earbuf>fodtaar1-100

sort mor_lnr
by mor_lnr: egen stop_1_m=max(end_1_m)
by mor_lnr: egen begin_1_m=min(start_1_m)
gen days_1=stop_1_m-begin_1_m+1
replace days_1=. if days_1<0

*Mother child 2

gen end_2_m=esptom if esptom<=fodtaar2+500 & esptom>fodtaar2
gen start_2_m=earbuf if earbuf<=fodtaar2+400 & earbuf>fodtaar2-100

sort mor_lnr
by mor_lnr: egen stop_2_m=max(end_2_m)
by mor_lnr: egen begin_2_m=min(start_2_m)
gen days_2=stop_2_m-begin_2_m+1
replace days_2=. if days_2<0

*Mother child 3

gen end_3_m=esptom if esptom<=fodtaar3+500 & esptom>fodtaar3
gen start_3_m=earbuf if earbuf<=fodtaar3+400 & earbuf>fodtaar3-100

sort mor_lnr
by mor_lnr: egen stop_3_m=max(end_3_m)
by mor_lnr: egen begin_3_m=min(start_3_m)
gen days_3=stop_3_m-begin_3_m+1
replace days_3=. if days_3<0

*Mother child 4

gen end_4_m=esptom if esptom<=fodtaar4+500 & esptom>fodtaar4
gen start_4_m=earbuf if earbuf<=fodtaar4+400 & earbuf>fodtaar4-100

sort mor_lnr
by mor_lnr: egen stop_4_m=max(end_4_m)
by mor_lnr: egen begin_4_m=min(start_4_m)
gen days_4=stop_4_m-begin_4_m+1
replace days_4=. if days_4<0

keep mor_lnr lnr1 lnr2 lnr3 lnr4 fodtaar1 fodtaar2 fodtaar3 fodtaar4 days_1 days_2 days_3 days_4 
duplicates drop

reshape long lnr fodtaar days_, i(mor_lnr)
drop _j

gen reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(7,1,1992)
replace reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(1,1,1992)


keep if reform92!=.

save  "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/daysleave9209.dta", replace




*ca 1000 obs. hvor vi har karakterisert de som eligible men som ikke er i parental leave data. keep as missing.



*graph

use "/ssb/ovibos/a1/swp/kav/wk24/allreforms/data/daysleave9209.dta", clear
sum fodtaar if fodtaar==mdy(4,1,1992)
local threshold92=r(mean)
display `threshold92'

gen triw92=1-abs((fodtaar-`threshold92')/92) if reform92!=.
replace triw92=1/92 if triw92==0 & reform92!=.



label var days_ "days of paid leave"



set scheme s2mono
forvalues t=92/92 {

preserve

drop if reform`t'==.

count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=7(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in  days{


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min)
local maxy=round(max)
sum week2
sort week2









twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), ylabel(240(2)280, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/`c'_reform`t'.eps,replace

drop a b max min 
clear matrix
}
restore

}
