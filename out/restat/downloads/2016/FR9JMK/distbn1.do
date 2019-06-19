 clear all
set mem 500m
set more off
************************************************************************************
clear
use data_working
gen alos=(daysnp+daysfp+dayspb)/admtot
summ alos if admtot>1
** generate per capita beds **
gen popul=ipop/1000
gen bedstot_temps=beds_tot
replace bedstot_temps=0 if beds_tot==1
gen bedsnppub_temps=beds_nppub
replace bedsnppub_temps=0 if beds_nppub==1
gen bedsfp_temps=bdtotfp
replace bedsfp_temps=0 if bdtotfp==1
replace popul=0 if popul==.
gen bdpc=bedstot_temps/(popul+1)
gen bdpc_nppub=bedsnppub_temps/(popul+1)
gen bdpc_fp=bedsfp_temps/(popul+1)
gen admtotpc=admtot/(popul+1)
gen admnppubpc=adm_nppub/(popul+1)
gen admfppc=admtotfp/(popul+1)
*drop if year==1947
bys fcount : gen first_treat=sum(treat_it)
** gen year first treated **
forvalues i=1/1{
	gen yeart`i'=year if treat_it==1 & first_treat==`i'
	by fcounty1: egen yeart`i'2=mean(yeart`i')
	drop yeart`i'
	rename yeart`i'2 yeart`i'
	}
sort fcounty year
by fcounty: gen byte ntreat = sum(treat_it)
sort fcounty ntreat
by fcounty ntreat: gen ntreat1=_n
gen byte first_it = (ntreat==1) & ntreat1==1
xtset fcounty year
* create lags *
gen byte treat_lag=first_it
  forvalues y=1/20  {
	gen byte treat_lag`y' = L`y'.treat_lag 
 	replace treat_lag`y' = 0 if treat_lag`y' ==.
  }
gen byte treat_lag21 = 0
  forvalues y=21/30  {
	replace treat_lag21 = 1 if L`y'.treat_it == 1
  }
* create leads *
  forvalues y=1/9  {
	gen byte treat_lead`y' = F`y'.treat_lag 
 	replace treat_lead`y' = 0 if treat_lead`y' ==.
  }
** Summary stats**
gen firmstot=firmsfp+firmsnp+firmspb
gen firms_nppub=firmsnp+firmspb
summ firmstot firms_npp firmsf if year==1953 & yeart==., det
replace daysfp=0 if missing(daysfp)
replace daysnp=0 if missing(daysnp)
replace dayspb=0 if missing(dayspb)
gen daystot=daysfp+daysnp+dayspb
gen days_nppub=daysnp+daysp
forvalues i=1/20 {
	label var treat_lag`i' "`i' Years Later"
}
label var treat_lag21 "21+ Years Later"
label var treat_lag "Year of Funding"

forvalues i=1/9  {
	label var treat_lead`i' "`i' Years Prior"
}
gen ipop2=ipop/100000
*below is new* *XXXXX*
gen imedfaminc2=imedfaminc/1000
replace yeart=3000 if yeart==.
* create MDs per capita *
gen infmdpc=infmd/(popul+1)
* drop 1947 year* * XXXX because keep 1947 treateds and keep lag structure from 1948 on *
drop if year==1947
*add on earlier years so we can re-create lag structure*
drop if year>1975
append using countyyear_1920_1947
sort fcounty1 year
xtset fcounty1 year
gen treatnew_lag0=0
replace treatnew_lag0=f27.treat_lag
forvalues i=1/21{
	gen treatnew_lag`i'=0
	replace treatnew_lag`i'=f27.treat_lag`i'
}
forvalues i=1/9{
	gen treatnew_lead`i'=0
	replace treatnew_lead`i'=f27.treat_lead`i'
}
*below is new* *XXXXX*
drop if fcounty1==29191 
		* this county has pop65 greater than its population *
gen pop65_pct=ipop65/ipop
gen poplt5_pct=ipoplt5/ipop

label var ipop2 "Popn"
label var imedfaminc "Med. Fam Income"
label var pop65_pct "% Pop 65+"
label var poplt5_pct "% Pop <5"
label var infmdpc "NonFed MDs per Capita"
label var inwpop_pct "% Pop NonWh"

*keep if year==1948
* this will drop 22 county/year observations with large swings (greater than 200 bed diff in dff in beds) and 0 beds as an observation *
sort fcounty1 year
gen diff2bd=abs(d2.beds_tot)
egen maxdiff2=max(diff2bd), by(fcounty)
bys fcounty : gen dropvar=1 if maxdiff2>200 & beds_tot==1 & beds_tot[_n-1]>1 & beds_tot[_n+1]>1  & year>=1948
replace dropvar=0 if missing(dropvar)
tab fcounty if dropvar==1
keep if dropvar==0 



***********
* Table 7 *
***********
*** income quintiles ***

xtile quintile_inc48=imedfaminc if year==1948, n(5)
xtile quintile_inc75=imedfaminc if year==1975, n(5)

*tab quintile_inc48, sum(bdpc) mean
*tab quintile_inc75, sum(bdpc) mean

tab quintile_inc48 [aw=ipop], sum(bdpc) mean
tab quintile_inc75 [aw=ipop], sum(bdpc) mean

corr imedfaminc bdpc if year==1948
corr imedfaminc bdpc if year==1975

corr imedfaminc bdpc if year==1948 [aw=ipop]
corr imedfaminc bdpc if year==1975 [aw=ipop]

*** census region quintiles ***
egen statecd=group(stab)
replace statecd=30 if fcounty1>36000 & fcounty1<37000
replace statecd=29 if fcounty1>35000 & fcounty1<36000
replace statecd=26 if fcounty1>32000 & fcounty1<33000
replace statecd=23 if fcounty1>29000 & fcounty1<30000
replace statecd=18 if fcounty1>24000 & fcounty1<25000
replace statecd=8 if fcounty1>12000 & fcounty1<13000
replace statecd=48 if fcounty1>11000 & fcounty1<12000

gen censusreg=""
replace censusreg="SOUTH" if statecd==1
replace censusreg="WEST" if statecd==2
replace censusreg="SOUTH" if statecd==3
replace censusreg="WEST" if statecd==4
replace censusreg="WEST" if statecd==5
replace censusreg="NE" if statecd==6
replace censusreg="SOUTH" if statecd==7
replace censusreg="SOUTH" if statecd==8
replace censusreg="SOUTH" if statecd==9
replace censusreg="WEST" if statecd==10
replace censusreg="MIDWEST" if statecd==11
replace censusreg="MIDWEST" if statecd==12
replace censusreg="MIDWEST" if statecd==13
replace censusreg="MIDWEST" if statecd==14
replace censusreg="SOUTH" if statecd==15
replace censusreg="SOUTH" if statecd==16
replace censusreg="NE" if statecd==17
replace censusreg="SOUTH" if statecd==18
replace censusreg="NE" if statecd==19
replace censusreg="MIDWEST" if statecd==20
replace censusreg="MIDWEST" if statecd==21
replace censusreg="SOUTH" if statecd==22
replace censusreg="MIDWEST" if statecd==23
replace censusreg="WEST" if statecd==24
replace censusreg="MIDWEST" if statecd==25
replace censusreg="WEST" if statecd==26
replace censusreg="NE" if statecd==27
replace censusreg="NE" if statecd==28
replace censusreg="WEST" if statecd==29
replace censusreg="NE" if statecd==30
replace censusreg="SOUTH" if statecd==31
replace censusreg="MIDWEST" if statecd==32
replace censusreg="MIDWEST" if statecd==33
replace censusreg="SOUTH" if statecd==34
replace censusreg="WEST" if statecd==35
replace censusreg="NE" if statecd==36
replace censusreg="NE" if statecd==37
replace censusreg="SOUTH" if statecd==38
replace censusreg="MIDWEST" if statecd==39
replace censusreg="SOUTH" if statecd==40
replace censusreg="SOUTH" if statecd==41
replace censusreg="WEST" if statecd==42
replace censusreg="NE" if statecd==43
replace censusreg="WEST" if statecd==44
replace censusreg="SOUTH" if statecd==45
replace censusreg="MIDWEST" if statecd==46
replace censusreg="WEST" if statecd==47
replace censusreg="SOUTH" if statecd==48


tab censusreg if year==1948, sum(bdpc) mean
tab censusreg if year==1975, sum(bdpc) mean

tab censusreg if year==1948 [aw=ipop], sum(bdpc) mean
tab censusreg if year==1975 [aw=ipop], sum(bdpc) mean

egen censusreg1=group(censusreg )

corr bdpc censusreg1 if year==1948
corr bdpc censusreg1 if year==1975


*** breakout by rural/nonrural ***

	egen rural2=mean(rural), by (fcounty1)
	gen rur3=1 if rural2==1
	replace rur3=0 if rural2==0
	replace rur3=0 if rural2>0 & rural2<1
	replace rur3=1 if missing(rural2)
	drop rural rural2
	rename rur3 rural

tab rural if year==1948, sum(bdpc) mean 
tab rural if year==1975, sum(bdpc) mean 

tab rural if year==1948 [aw=ipop], sum(bdpc) mean 
tab rural if year==1975 [aw=ipop], sum(bdpc) mean 

corr bdpc rural if year==1948
corr bdpc rural if year==1975



*** variance overall of bedspc ***
summ  bdpc if year==1948, det
summ  bdpc if year==1975, det

summ  bdpc if year==1948 [aw=ipop], det
summ  bdpc if year==1975 [aw=ipop], det
