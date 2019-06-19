**************************************************************************************
* 	         Do-file to compute correlations using municipality data             *
**************************************************************************************

clear
cap log close
*clear matrix
set mem 800m
*set maxvar 3000
set matsize 5000
mat drop _all

global tables="C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Tables"
cd "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities"


use C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\shares_edu

egen aux=count(year), by(year fips)
keep if aux==1
drop aux
compress
sort fipsid year_aux
save  C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\shares_edu, replace

use rough1906_2005extract_wginis
sort fipsid year_aux
merge fipsid year_aux using C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\shares_edu, update replace

replace share_edu1=. if share_edu1==999
replace share_edu2=. if share_edu2==999
replace share_edu3=. if share_edu3==999
replace share_edu4=. if share_edu4==999
replace share_edu5=. if share_edu5==999

replace share_edu1=share_edu1*100 if year_aux==1999
replace share_edu2=share_edu2*100 if year_aux==1999
replace share_edu3=share_edu3*100 if year_aux==1999
replace share_edu4=share_edu4*100 if year_aux==1999
replace share_edu5=share_edu5*100 if year_aux==1999
tab _merge
 





drop _merge
   

* Initial shares in income bins
local counter=1
forvalues i=1427(1)1440 {
gen share_income_group`counter'=V`i'/V103
egen aux=mean(share_income_group`counter'), by(state census)
drop share_income_group`counter'
rename aux share_income_group`counter'
local counter=`counter'+1
}
 

gen state_name=""
replace state_name="Alabama" if state==01
replace state_name="Alaska" if state==02
replace state_name="Arizona" if state==04
replace state_name="Arkansas" if state==05
replace state_name="California" if state==06
replace state_name="Colorado" if state==08
replace state_name="Connecticut" if state==09
replace state_name="Delaware" if state==10
replace state_name="District of Columbia" if state==11
replace state_name="Florida" if state==12
replace state_name="Georgia" if state==13
replace state_name="Hawaii" if state==15
replace state_name="Idaho" if state==16
replace state_name="Illinois" if state==17
replace state_name="Indiana" if state==18
replace state_name="Iowa" if state==19
replace state_name="Kansas" if state==20
replace state_name="Kentucky" if state==21
replace state_name="Louisiana" if state==22
replace state_name="Maine" if state==23
replace state_name="Maryland" if state==24
replace state_name="Massachusetts" if state==25
replace state_name="Michigan" if state==26
replace state_name="Minnesota" if state==27
replace state_name="Mississippi" if state==28
replace state_name="Missouri" if state==29
replace state_name="Montana" if state==30
replace state_name="Nebraska" if state==31
replace state_name="Nevada" if state==32
replace state_name="New Hampshire" if state==33
replace state_name="New Jersey" if state==34
replace state_name="New Mexico" if state==35
replace state_name="New York" if state==36
replace state_name="North Carolina" if state==37
replace state_name="North Dakota" if state==38
replace state_name="Ohio" if state==39
replace state_name="Oklahoma" if state==40
replace state_name="Oregon" if state==41
replace state_name="Pennsylvania" if state==42
replace state_name="Rhode Island" if state==44
replace state_name="South Carolina" if state==45
replace state_name="South Dakota" if state==46
replace state_name="Tennessee" if state==47
replace state_name="Texas" if state==48
replace state_name="Utah" if state==49
replace state_name="Vermont" if state==50
replace state_name="Virginia" if state==51
replace state_name="Washington" if state==53
replace state_name="West Virginia" if state==54
replace state_name="Wisconsin" if state==55
replace state_name="Wyoming" if state==56

egen id_place=group(state census)
*drop if id_place== 19704 
egen aux=count(year), by(state census year_aux )
drop if aux>1 
drop aux

 
drop if id_place==.
drop id_place 

drop year

rename bgini gini
 

replace gini_predicted=gini if year_aux==1969
 

keep if year_aux==1949 | year_aux==1959 | year_aux==1969 | year_aux==1979 | year_aux==1989 | year_aux==1999
*keep if merge0==3
*drop if fipsid=="0.0000."
drop if state==48 & census==2356 
drop if state==55 & census==2242 & noned_charges==0
drop if state==42 & census==8220 

egen id_place=group(state census)

tsset id_place year_aux

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



* Generate Year dummy variables


gen d1949=.
replace d1949=0 if year_aux!=1949
replace d1949=1 if year_aux==1949

gen d1959=.
replace d1959=0 if year_aux!=1959
replace d1959=1 if year_aux==1959

gen d1969=.
replace d1969=0 if year_aux!=1969
replace d1969=1 if year_aux==1969

gen d1979=.
replace d1979=0 if year_aux!=1979
replace d1979=1 if year_aux==1979

gen d1989=.
replace d1989=0 if year_aux!=1989
replace d1989=1 if year_aux==1989

gen d1999=.
replace d1999=0 if year_aux!=1999
replace d1999=1 if year_aux==1999

*Log of Per capita variables

global variables genrev totigr proptax genexpend gencurrexp police_tot fire_tot toted_tot libry_tot prkrec_tot totcapout  totrev extra_rev extra_exp noned_charges other_tax police_new fire_new highways hospital water electric sewerage public_welfare sales_tax


egen aux=rsum(proptax totigr noned_charges sales_tax)
gen extra_rev=genrev-aux
drop aux

egen aux=rsum(police_new fire_new highways    public_welfare hospital)
gen extra_exp=genexpend-aux
drop aux
 
replace extra_rev=0 if extra_rev<0
replace extra_exp=0 if extra_exp<0

gen aux=0
replace aux=1 if toted_tot>0 & toted_tot!=.

egen aux1=max(aux), by(id_place)

gen dummy_educ=0
replace dummy_educ=1 if aux1==1

drop if dummy_educ==1
drop aux*


*replace genrev=genrev-aux
*replace proptax=proptax-aux
*replace genexpend=genexpend-aux
*replace gencurrexp=gencurrexp-aux
*replace totrev=totrev-aux

* Correct for inflation : source CPI: BLS

gen cpi=.
replace cpi=0.142857143   if year_aux==1949
replace cpi=0.174669868   if year_aux==1959
replace cpi=0.220288115   if year_aux==1969
replace cpi=0.43577431    if year_aux==1979
replace cpi=0.744297719   if year_aux==1989
replace cpi=1             if year_aux==1999





foreach var in $variables {

replace `var'=`var'/cpi

}





foreach var in $variables {
replace `var'=0 if `var'==. 
gen `var'_pc=`var'/population

**** OJO!!!!!!!!!!
gen l`var'_pc=(`var'/population)

}

gen share_top_bottom=share_top/share_bottom

replace median_income=median_income/cpi
replace mean_income=mean_income/cpi
replace median_housev=median_housev/cpi
replace median_rent=median_rent/cpi

* Log population
gen lpopulation=ln(population)

gen lmean_income=ln(mean_income)
gen lmedian_income=ln(median_income)
gen lmedian_housev=ln(median_housev)

 

cap drop aux

* Gen intial shares of education

forvalues i=1(1)5   {

gen aux=share_edu`i' if year_aux==1969
egen ini_share_edu`i'=mean(aux), by(id_place)
drop aux
}


* Property tax rate


gen prop_tax_rate=proptax/( (owner_units*median_housev)+(rental_units*median_rent*80)   )

replace  prop_tax_rate=. if prop_tax_rate>0.2

* Drop gini=0

drop if gini==0

 


*** Ethnic Fractionalization

global race_vars share_nl_black share_nl_white share_hisp

foreach var in $race_vars   {

replace `var'=0 if `var'==. 
replace `var'=. if share_nl_black==0 & share_nl_white==0 & share_hisp==0

}



gen share_other=1-share_nl_black-share_nl_white-share_hisp
sum share_other
replace share_other=0 if share_other<0

gen ethnic_fract=1-(share_other^2)-(share_nl_white^2)-(share_hisp^2)-(share_nl_black^2)




*/


global years= "1969"
******************  start loop for base year *************
foreach base_year in $years        {


*preserve
cap drop base_year
gen base_year=`base_year'

* Keep cities in all years

keep if year>=`base_year' & year!=.
gen aux=1 if lgenrev_pc!=. &  gini!=. & lpopulation!=. & share_black!=. & share_hisp!=. &  lmedian_income!=. &   share65!=. & year==`base_year'
egen aux1=mean(aux), by(id_place)
egen aux2=sum(aux1), by(id_place)

if `base_year'==1969  {
keep if aux2==4 
}

if `base_year'==1979  {
keep if aux2==3 
}

drop aux*

 
gen aux1=1 if population >0           & population<10000  & year==1969
gen aux2=1 if population >=10000      & population<25000  & year==1969
gen aux3=1 if population >=25000         & population!=.     & year==1969
gen aux4=1 if population >=100000	 & population!=.     & year==1969

egen city_size1=mean(aux1), by(id_place)
egen city_size2=mean(aux2), by(id_place)
egen city_size3=mean(aux3), by(id_place)
egen city_size4=mean(aux4), by(id_place)
drop aux*

* Stats boxes
egen aux_time=group(year_aux)
tsset id_place aux_time
sum aux_time
local time_span=r(max)-r(min)


sum gini if year==1969 & dummy_educ==0,d
gen aux1=1 if gini>=0 & gini<=r(p50) & year==1969 & dummy_educ==0
gen aux2=1 if gini>=r(p50) & gini!=. & year==1969 & dummy_educ==0

sum lmedian_income if year==1969 & aux1==1 & dummy_educ==0,d
gen aux3=1 if lmedian_income>=0 & lmedian_income<=r(p50) & year==1969 & aux1==1 & dummy_educ==0
gen aux4=1 if lmedian_income>=r(p50) & lmedian_income!=. & year==1969 & aux1==1 & dummy_educ==0

sum lmedian_income if year==1969 & aux2==1 & dummy_educ==0,d
gen aux5=1 if lmedian_income>=0 & lmedian_income<=r(p50) & year==1969 & aux2==1 & dummy_educ==0
gen aux6=1 if lmedian_income>=r(p50) & lmedian_income!=. & year==1969 & aux2==1 & dummy_educ==0

egen aux3_1=max(aux3), by(id_place)
egen aux4_1=max(aux4), by(id_place)
egen aux5_1=max(aux5), by(id_place)
egen aux6_1=max(aux6), by(id_place)


gen aux8=gini-l`time_span'.gini


sum aux8 if  year==1999 & aux3_1==1 & dummy_educ==0, d
gen aux10=1 if year==1999 & aux3_1==1 & aux8<=r(p50) & dummy_educ==0
gen aux11=1 if year==1999 & aux3_1==1 & aux8>=r(p50) & aux8!=. & dummy_educ==0

sum aux8 if  year==1999 & aux4_1==1 & dummy_educ==0, d
gen aux12=1 if year==1999 & aux4_1==1 & aux8<=r(p50) & dummy_educ==0
gen aux13=1 if year==1999 & aux4_1==1 & aux8>=r(p50) & aux8!=. & dummy_educ==0

sum aux8 if  year==1999 & aux5_1==1 & dummy_educ==0, d
gen aux14=1 if year==1999 & aux5_1==1 & aux8<=r(p50) & dummy_educ==0
gen aux15=1 if year==1999 & aux5_1==1 & aux8>=r(p50) & aux8!=. & dummy_educ==0

sum aux8 if  year==1999 & aux6_1==1 & dummy_educ==0, d
gen aux16=1 if year==1999 & aux6_1==1 & aux8<=r(p50) & dummy_educ==0
gen aux17=1 if year==1999 & aux6_1==1 & aux8>=r(p50) & aux8!=. & dummy_educ==0


egen box10_1=max(aux10), by(id_place)
egen box11_1=max(aux11), by(id_place)
egen box12_1=max(aux12), by(id_place)
egen box13_1=max(aux13), by(id_place)
egen box14_1=max(aux14), by(id_place)
egen box15_1=max(aux15), by(id_place)
egen box16_1=max(aux16), by(id_place)
egen box17_1=max(aux17), by(id_place)

drop aux*

** Interaction with initial gini/median income

gen aux=gini if year==1969
egen initial_gini=mean(aux), by(id_place)
gen gini_ini_gini =gini*initial_gini
drop aux

gen aux=lmedian_income if year==1969
egen initial_lmi=mean(aux), by(id_place)
gen gini_ini_lmi=gini*initial_lmi
drop aux


*** Graphs


 kdensity gini if year==1969, nograph gen(x69 y69)
 kdensity gini if year==1979, nograph gen(x79 y79)
 kdensity gini if year==1989, nograph gen(x89 y89)
 kdensity gini if year==1999, nograph gen(x99 y99)

 kdensity gini_predicted if year==1979, nograph gen(x79_hat y79_hat)
 kdensity gini_predicted if year==1989, nograph gen(x89_hat y89_hat)
 kdensity gini_predicted if year==1999, nograph gen(x99_hat y99_hat)

egen aux_time=group(year_aux)
tsset id_place aux_time

twoway (scatter gini gini_predicted) (line gini gini), saving($tables\gini_vs_gini, replace)  ytitle(Gini coefficient) xtitle(Predicted Gini)  legend(on order(2 "45 degree line")) nodraw
twoway (scatter d.gini d.gini_predicted) (line d.gini d.gini), saving($tables\dgini_vs_dgini, replace)  ytitle(Gini coefficient) xtitle(Predicted Gini)  legend(on order(2 "45 degree line")) nodraw


xi: reg d.gini i.region*i.year d.lpopulation d.share_black d.share_hisp d.lmedian_income d.share65 if lgenrev_pc!=0 & l.lgenrev_pc!=0, cluster(id_place) 
predict aux_dgini if e(sample), residuals
xi: reg d.gini_predicted i.region*i.year d.lpopulation d.share_black d.share_hisp d.lmedian_income d.share65 if lgenrev_pc!=0 & l.lgenrev_pc!=0, cluster(id_place) 
predict aux_dginip if e(sample), residuals



twoway (scatter aux_dgini aux_dginip) (line aux_dginip aux_dginip), saving($tables\dginir_vs_dginir, replace)  ytitle(Gini (Change)) xtitle(Predicted Gini (Change))  legend(on order(2 "45 degree line")) nodraw
drop aux_dgini aux_dginip 

******************************** Descriptives **************************************************

sum aux_time
local time_span=r(max)-r(min)

egen infrastructure_pc=rsum(water_pc electric_pc sewerage_pc)
gen linfrastructure_pc=ln(infrastructure_pc)

*global variables_desc gini ethnic_fract genrev_pc genexpend_pc proptax_pc totigr_pc extra_rev_pc noned_charges_pc toted_tot_pc other_tax_pc  police_tot_pc fire_tot_pc libry_tot_pc prkrec_tot_pc police_new_pc fire_new_pc highways_pc hospital_pc water_pc electric_pc sewerage_pc infrastructure_pc public_welfare_pc sales_tax_pc gini_predicted


global variables_desc gini ethnic_fract   genrev_pc  proptax_pc totigr_pc noned_charges_pc sales_tax_pc extra_rev_pc genexpend_pc  police_new_pc fire_new_pc highways_pc    public_welfare_pc hospital_pc extra_exp_pc


mat  descriptives`base_year'= J(10,50,.)

local column=1
local column1=2

foreach var in $variables_desc   {

replace `var'=. if `var'<0

sum `var' if  dummy_educ==0 & year==`base_year', d

mat descriptives`base_year'[1,`column']=r(mean)
mat descriptives`base_year'[2,`column']=r(sd)


gen aux=l`time_span'.`var'
gen aux1=`var'-aux 

sum aux1 if  dummy_educ==0 & year==1999, d
mat descriptives`base_year'[5,`column']=r(mean)


drop aux aux1

local column=`column'+1
local column1=`column1'+3

}


replace  share_black=0 if  share_black==.
replace  share_hisp=0 if  share_hisp==.

********************************* Regressions ***************************************************

global variables_reg       genrev  proptax totigr noned_charges sales_tax extra_rev genexpend  police_new fire_new highways    public_welfare hospital extra_exp

*global variables_reg_rural genrev genexpend proptax totigr noned_charges other_tax police_new fire_new highways hospital  sales_tax public_welfare

rename year_aux year
tsset id_place aux_time

*** First differences
* generate region-specific time effects
gen gini_educ=gini*dummy_educ
gen ethnic_fract_educ=ethnic_fract*dummy_educ

 
gen ratio=ln(mean_income/median_income)

local var_count=1

**** Table 2 ****

xi: reg d.lgenrev_pc d.gini d.lpopulation  d.lmedian_income d.share65  d.share_black d.share_hisp  i.region*i.year  , cluster(id_place) 

outreg2 d.gini d.lpopulation   d.lmedian_income d.share65   d.share_black d.share_hisp   using "$tables\table2", replace bracket excel   symbol(***,**,*) ctitle(`var',"OLS")  addstat(coeff_20, _b[d.gini]/20)

foreach var in  genexpend   {


xi: reg d.l`var'_pc d.gini d.lpopulation  d.lmedian_income d.share65  d.share_black d.share_hisp  i.region*i.year  , cluster(id_place) 

outreg2 d.gini d.lpopulation   d.lmedian_income d.share65   d.share_black d.share_hisp   using "$tables\table2", append bracket excel   symbol(***,**,*) ctitle(`var',"OLS")  addstat(coeff_20, _b[d.gini]/20)



}


foreach var in genrev genexpend   {
sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: reg d.l`var'_pc d.gini d.lpopulation  d.lmedian_income d.share65  d.share_black d.share_hisp  i.region*i.year  if outliers==1 & outliers1==1 , cluster(id_place) 

outreg2 d.gini d.lpopulation   d.lmedian_income d.share65   d.share_black d.share_hisp   using "$tables\table2", append bracket excel   symbol(***,**,*) ctitle(`var',"OLS")  addstat(coeff_20, _b[d.gini]/20)

drop outliers*


}


**** Table 3 ****


foreach var in     genrev  {

sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: reg d.l`var'_pc d.gini d.lpopulation  d.lmedian_income d.share65  d.share_black d.share_hisp  i.region*i.year  if outliers==1 & outliers1==1 , cluster(id_place) 

outreg2 d.gini d.lpopulation   d.lmedian_income d.share65   d.share_black d.share_hisp   using "$tables\table3", replace bracket excel   symbol(***,**,*) ctitle(`var',"OLS")  addstat(coeff_20, _b[d.gini]/20)

drop outliers*


}


foreach var in     proptax totigr noned_charges sales_tax extra_rev genexpend  police_new fire_new highways    public_welfare hospital extra_exp   {

sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: reg d.l`var'_pc d.gini d.lpopulation  d.lmedian_income d.share65  d.share_black d.share_hisp  i.region*i.year  if outliers==1 & outliers1==1 , cluster(id_place) 

outreg2 d.gini d.lpopulation   d.lmedian_income d.share65   d.share_black d.share_hisp   using "$tables\table3", append bracket excel   symbol(***,**,*) ctitle(`var',"OLS")  addstat(coeff_20, _b[d.gini]/20)

drop outliers*


}


**** Table 4 ****

sum  d.lgenrev_pc,d
gen outliers=1 if d.lgenrev_pc>=r(p1) &  d.lgenrev_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: reg  d.gini d.gini_predicted  d.lpopulation  d.lmedian_income d.share65  i.region*i.year  if outliers==1 & outliers1==1, cluster(id_place) 
outreg2 d.gini_predicted d.lpopulation d.lmedian_income d.share65  using "$tables\table4", replace bracket excel   symbol(***,**,*)  ctitle(gini,"firststage")  
drop outlier*


foreach var in $variables_reg   {

sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 



xi: ivreg2 d.l`var'_pc (d.gini=d.gini_predicted )   d.lmedian_income  d.lpopulation d.share65  d.share_black d.share_hisp  i.region*i.year  if outliers==1 & outliers1==1  , cluster(id_place) 

outreg2 d.gini d.lmedian_income d.lpopulation   d.share65   d.share_black d.share_hisp   using "$tables\table4", append bracket excel   symbol(***,**,*) ctitle(genrev,"IV") 


drop outliers*


}


***** Table 5 *****

gen lmedian_income2=lmedian_income^2
gen lmedian_income3=lmedian_income^3
gen lmedian_income4=lmedian_income^4
gen lmedian_income5=lmedian_income^5


sum  d.lgenrev_pc,d
gen outliers=1 if d.lgenrev_pc>=r(p1) &  d.lgenrev_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: ivreg2 d.lgenrev_pc (d.gini=d.gini_predicted )   d.lmedian_income  d.lpopulation d.share65  d.share_black d.share_hisp  i.region*i.year  if outliers==1 & outliers1==1  , cluster(id_place) 

outreg2 d.gini d.lmedian_income d.lpopulation   d.share65   d.share_black d.share_hisp   using "$tables\table5", replace bracket excel   symbol(***,**,*) ctitle(`var',"IV") 



drop outliers*


foreach var in  genexpend   {
sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 

xi: ivreg2 d.l`var'_pc (d.gini=d.gini_predicted )   d.lmedian_income  d.lpopulation d.share65  d.share_black d.share_hisp  i.region*i.year  if outliers==1 & outliers1==1  , cluster(id_place) 
outreg2 d.gini d.lmedian_income d.lpopulation   d.share65   d.share_black d.share_hisp   using "$tables\table5", append bracket excel   symbol(***,**,*) ctitle(`var',"IV") 


drop outliers*


}

foreach var in genrev genexpend   {
sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.gini,d
gen outliers1=1 if d.gini>=r(p1) &  d.gini<=r(p99) 



xi: ivreg2 d.l`var'_pc (d.gini=d.gini_predicted )  d.lpopulation d.share_black d.share_hisp d.lmedian_income d.share65  d.share_edu2  d.share_edu3 d.share_edu4 d.share_edu5 i.region*i.year   if outliers==1 & outliers1==1, cluster(id_place) 
outreg2 d.gini d.lpopulation d.share_black d.share_hisp d.lmedian_income d.share65  d.share_edu2  d.share_edu3 d.share_edu4 d.share_edu5 using "$tables\table5", append bracket excel   symbol(***,**,*)  ctitle(`var',"IV")  

xi: ivreg2 d.l`var'_pc (d.gini=d.gini_predicted )   d.lmean_income  d.lpopulation d.share65  d.share_black d.share_hisp  i.region*i.year  if outliers==1 & outliers1==1  , cluster(id_place) 
outreg2 d.gini d.lmean_income d.lpopulation   d.share65   d.share_black d.share_hisp   using "$tables\table5", append bracket excel   symbol(***,**,*) ctitle(`var',"IV") 


xi: ivreg2 d.l`var'_pc (d.gini=d.gini_predicted) d.lpopulation d.share_black d.share_hisp d.lmedian_income d.lmedian_income2 d.lmedian_income3 d.lmedian_income4 d.lmedian_income5 d.share65  i.region*i.year    if outliers==1 & outliers1==1, cluster(id_place) 
outreg2 d.gini d.lpopulation d.share_black d.share_hisp d.lmedian_income  d.lmedian_income2 d.lmedian_income3 d.lmedian_income4 d.lmedian_income5 d.share65  using "$tables\table5", append bracket excel   symbol(***,**,*) ctitle(`var',"IV")  addstat(coeff_20, _b[d.gini]/20)


xi: ivreg2 d.l`var'_pc (d.gini= d.gini_predicted) d.lpopulation d.share_black d.share_hisp d.lmedian_income d.share65 initial_gini i.region*i.year   if outliers==1 & outliers1==1 , cluster(id_place) 
outreg2 d.gini d.lpopulation d.share_black d.share_hisp d.lmedian_income d.share65 initial_gini  using "$tables\table5", append bracket excel   symbol(***,**,*) ctitle(`var',"IV")  addstat(coeff_20, _b[d.gini]/20)


xi: ivreg2 d.l`var'_pc (d.gini=d.gini_predicted )  d.lpopulation   d.lmedian_income d.share65   d.share_black d.share_hisp  i.state*i.year   if outliers==1 & outliers1==1, cluster(id_place) 
outreg2 d.gini d.lpopulation  d.lmedian_income d.share65   d.share_black d.share_hisp  using "$tables\table5", append bracket excel   symbol(***,**,*)  ctitle(`var',"IV")  

xi: ivreg2 d.l`var'_pc (d.gini=d.gini_predicted )   d.lmedian_income  d.lpopulation d.share65  d.share_black d.share_hisp  i.region*i.year     , cluster(id_place) 
outreg2 d.gini d.lmedian_income d.lpopulation   d.share65   d.share_black d.share_hisp   using "$tables\table5", append bracket excel   symbol(***,**,*) ctitle(`var',"IV") 

xi: xtivreg l`var'_pc (gini=gini_predicted) lpopulation share_black share_hisp lmedian_income share65 i.region*i.year      if outliers==1 & outliers1==1,  fe
outreg2 gini lpopulation share_black share_hisp lmedian_income share65  using "$tables\table5", append bracket excel   symbol(***,**,*) ctitle(`var',"IV")  
xi: ivreg2 d.l`var'_pc (d.gini=d.gini_predicted )  d.lpopulation   d.lmedian_income d.share65     i.region*i.year  if outliers==1 & outliers1==1 , cluster(id_place) 
outreg2 d.gini d.lpopulation  d.lmedian_income d.share65     using "$tables\table5", append bracket excel   symbol(***,**,*)  ctitle(`var',"IV")  

drop outliers*


}

***** Table 6 *****
sum  d.lgenrev_pc,d
gen outliers=1 if d.lgenrev_pc>=r(p1) &  d.lgenrev_pc<=r(p99) 
sum  d.ethnic_fract,d
gen outliers1=1 if d.ethnic_fract>=r(p1) &  d.ethnic_fract<=r(p99) 

xi: reg d.lgenrev_pc d.ethnic_fract d.lpopulation  d.lmedian_income d.share65  i.region*i.year   if outliers==1 & outliers1==1 , cluster(id_place) 
outreg2 d.ethnic_fract  d.ethnic_fract d.lpopulation  d.lmedian_income d.share65  using "$tables\table6"   if outliers==1 & outliers1==1, append bracket excel   symbol(***,**,*) ctitle(genrev,"OLS")  addstat(coeff_10, _b[d.ethnic_fract]/10)
drop outliers*


foreach var in  proptax totigr noned_charges sales_tax extra_rev genexpend  police_new fire_new highways    public_welfare hospital extra_exp     {

sum  d.l`var'_pc,d
gen outliers=1 if d.l`var'_pc>=r(p1) &  d.l`var'_pc<=r(p99) 
sum  d.ethnic_fract,d
gen outliers1=1 if d.ethnic_fract>=r(p1) &  d.ethnic_fract<=r(p99) 

xi: reg d.l`var'_pc d.ethnic_fract d.lpopulation  d.lmedian_income d.share65  i.region*i.year   if outliers==1 & outliers1==1 , cluster(id_place) 
outreg2 d.ethnic_fract  d.ethnic_fract d.lpopulation  d.lmedian_income d.share65  using "$tables\table6"   if outliers==1 & outliers1==1, append bracket excel   symbol(***,**,*) ctitle(`var',"OLS")  addstat(coeff_10, _b[d.ethnic_fract]/10)
drop outliers*


}



}

preserve 

* Export tables

global tables_desc descriptives1969    

outsheet x* y* if _n<70  using "$tables\\densities.xls", replace


foreach that in $tables_desc $tables_desc79  {
	                      drop _all
			       svmat double `that'
			       di in red "`that'"
	                       outsheet  using "$tables\\`that'.xls", replace
                               }


log close


