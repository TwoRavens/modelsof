

* Correlations


clear
cap log close
set mem 500m

cd "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts"
global tables="C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\tables"

use  school_district_database

drop statecode

* Census Regions

gen region=.

* New England

replace region=1 if state==9 | state==23 | state==25 | state==33 | state==44 | state==50

* Middle Atlantic 

replace region=2 if state==34 | state==36 | state==42 

* East North Central

replace region=3 if state==17 | state==18 | state==26 | state==39 | state==55

* West North Central

replace region=4 if state==19 | state==20 | state==27 | state==29 | state==31 | state==38 | state==46

* South Atlantic

replace region=5 if state==10 | state==11 | state==12 | state==13 | state==24 | state==37 | state==45 | state==51 | state==54

* East South Central 

replace region=6 if state==1 | state==21 | state==28 | state==47 

* West South Central

replace region=7 if state==5 | state==22 | state==40 | state==48

*Mountain 

replace region=8 if state==4 | state==8 | state==16 | state==30 | state==32 | state==35 | state==49 | state==56 

* Pacific

replace region=9 if state==2 | state==6 | state==15 | state==41 | state==53 

label define region 1 "New England" 2 "Middle Atlantic" 3 "East North Central" 4 "West North Central" 5 "South Atlantic" 6 "East South Central" 7 "West South Central" 8 "Mountain" 9 "Pacific"

**** Aggregate regions ****

gen agg_region=.
replace agg_region=1 if region>=1 & region<=2
replace agg_region=2 if region>=3 & region<=4
replace agg_region=3 if region>=5 & region<=7
replace agg_region=4 if region>=8 & region<=9




tsset id_place year

global variables300="totrev totigr proptax totexpend extra_rev totgenchgs totstaigr"


*** School finance equalization ***

gen fin_eq=.
replace fin_eq=0 if year==1969 | year==1999
replace fin_eq=1 if year==1999 & (state==1 | state==4 | state==5 | state==6 | state==20 | state==21 | state==25 | state==29 | state==30 | state==33 | state==34 | state==39  | state==47 | state==48 | state==50 | state==53 | state==54 | state==55 | state==56)




*global variables="ltotrev_pc"




******************  start loop for base year *************



*keep if year==1969 | year==1999 

** Interaction with initial gini/median income

gen aux=gini if year==1969
egen initial_gini=mean(aux), by(id_place)
gen gini_ini_gini=gini*initial_gini
drop aux

gen aux=lmedian_income if year==1969
egen initial_lmi=mean(aux), by(id_place)
gen gini_ini_lmi=gini*initial_lmi
drop aux

gen fin_eq_ini_gini=fin_eq*initial_gini
gen fin_eq_ini_lmi=fin_eq*initial_lmi

save database_for_regressions_school_sch_coun_base1969, replace

********************************* Descriptives **************************************************

* Keep obs in all years
foreach var in gini gini_predicted lmedian_income  gini lpopulation share_black share65 ltotexpend_pc lproptax_pc   ltotstaigr_pc {
egen aux=count(`var'), by(id_place)
tab aux
keep if aux==4
drop aux
}

egen aux_time=group(year)
tsset id_place aux_time
sum aux_time
local time_span=r(max)-r(min)

global variables_desc="gini totrev_pc totexpend_pc proptax_pc totigr_pc extra_rev_pc totgenchgs_pc totstaigr_pc"

mat  descriptives_sch_coun1969= J(5,50,.)

local column =1

foreach var in $variables_desc   {

replace `var'=. if `var'<0

sum `var' if `var'>0 & year==1969, d
mat descriptives_sch_coun1969[1,`column']=r(mean)
mat descriptives_sch_coun1969[2,`column']=r(sd)

gen aux=l`time_span'.`var'
gen aux1=`var'-aux if `var'>=0 & aux>=0

sum aux1 if aux>0 & year==1999, d
mat descriptives_sch_coun1969[3,`column']=r(mean)

drop aux aux1

local column=`column'+3

}

gen lmedian_income_fin_eq=lmedian_income*fin_eq
gen gini_fin_eq=gini*fin_eq

/************** ERASE THIS!!!!!!!!!!

global aux_vars ltotrev_pc ltotexpend_pc lproptax_pc  ltotgenchgs_pc ltotstaigr_pc ltotigr_pc lextra_rev_pc lmedian_income  gini gini_predicted lpopulation share_black share65 

foreach var in $aux_vars   {

gen `var'3=`var'-l3.`var'

}

*/

*************************************************** Regressions ***************************************************

global variables_reg="  proptax   totstaigr "
**** Without outliers 


 *** 

 
foreach var in totexpend   {
sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: reg  d.l`var'_pc  d.lmedian_income  d.gini d.lpopulation d.share_black d.share65 i.region*i.year   if outliers==1 & outliers1==1 , cluster(state) 
outreg2  d.gini d.lmedian_income  using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\tables\table7", replace ctitle(`var',`i') bracket excel   symbol(***,**,*) 
drop outliers*

}



foreach var in $variables_reg   {
sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: reg  d.l`var'_pc  d.lmedian_income  d.gini d.lpopulation d.share_black d.share65 i.region*i.year   if outliers==1 & outliers1==1 , cluster(state) 
outreg2  d.gini d.lmedian_income  using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\tables\table7", append ctitle(`var',`i') bracket excel   symbol(***,**,*) 
drop outliers*

}





******** IV results




foreach var in totexpend $variables_reg   {


sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: ivreg  d.l`var'_pc  d.lmedian_income  (d.gini =d.gini_predicted) d.lpopulation d.share_black d.share65  i.region*i.year    if outliers==1 & outliers1==1, cluster(state) first
outreg2  d.gini d.lmedian_income using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\tables\table7", append ctitle(`var',`i') bracket excel   symbol(***,**,*) 
drop outliers*

}

sum  d.ltotexpend_pc,d
gen outliers=1 if d.ltotexpend_pc>=r(p1) &  d.ltotexpend_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 


xi: reg  d.gini d.gini_predicted  d.lpopulation d.share_black d.share65  i.region*i.year if e(sample) & outliers==1 & outliers1==1 , cluster(state) 
outreg2  d.gini d.gini_predicted using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\tables\table7", append ctitle(`var',`i') bracket excel   symbol(***,**,*) 
drop outliers*

 */ 








*log close


