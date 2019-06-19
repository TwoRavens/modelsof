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

drop if year==1947
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


** Summary stats**
gen firmstot=firmsfp+firmsnp+firmspb
gen firms_nppub=firmsnp+firmspb
replace daysfp=0 if missing(daysfp)
replace daysnp=0 if missing(daysnp)
replace dayspb=0 if missing(dayspb)

gen daystot=daysfp+daysnp+dayspb
gen days_nppub=daysnp+daysp

gen ipop2=ipop/100000
replace yeart=3000 if yeart==.

* create MDs per capita *
gen infmdpc=infmd/(popul+1)

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

**********************************************

keep if stab=="ALABAMA"|stab=="ARIZONA"|stab=="COLORADO"|stab=="FLORIDA"|stab=="GEORGIA"|stab=="KANSAS"|stab=="KENTUCKY"|stab=="MARYLAND"|stab=="MISSOURI"|stab=="NEW MEXICO"|stab=="NORTH CAROLINA"|stab=="NORTH DAKOTA"|stab=="OKLAHOMA"|stab=="PENNSYLVANIA"|stab=="SOUTH CAROLINA"|stab=="SOUTH DAKOTA"|stab=="TENNESSEE"|stab=="TEXAS"|stab=="VIRGINIA"
drop _merge
sort fcounty
merge fcounty using prioritylist
drop if _merge==2

** create first_treat event **
*drop if year==1947
*sort fcounty year
*bys fcount : gen first_treat=sum(treat_it)

*gen yeart1=year if treat_it==1 & first_treat==1
*by fcounty1: egen yeart12=mean(yeart`i')
*drop yeart1
*rename yeart12 yeart1
*replace first_treat=1 if first_treat>0

********************************************************
*********    try some tabulations    *******************
********************************************************
tab priority if year==1948, mi

tab yeart priority if year==1948, mi
tab priority  first_treat if year<=1950, mi

gen priority1_2=1 if priority==1|priority==2
replace priority1_2=0 if missing(priority1_2)

gen priority3_4=1 if priority==3|priority==3.5 |priority==4
replace priority3_4=0 if missing(priority3_4)

gen priority_rest=1 if priority>4
replace priority_rest=0 if missing(priority_rest)

xi i.priority, noomit

***********************************************************
***********************************************************
********      gen diffs for 5yr change IV      ************
***********************************************************
***********************************************************
**** generate treatment in 1948-1950 = hbtreat ****
drop if year==1947
*egen treat=mean(treat_it) if year<=1950 & year!=1947, by (fcounty1)
*egen treattemp=mean(treat), by (fcounty1)
*gen hbtreat=1 if treattemp!=0
*replace hbtreat=0 if missing(hbtreat)
*drop treat treattemp

*egen treat=mean(treat_it) if year<=1964 & year!=1947, by (fcounty1)
egen treat=mean(treat_it) if year<=1950 & year!=1947, by (fcounty1)
egen treattemp=mean(treat), by (fcounty1)
gen hbtreat=1 if treattemp!=0
replace hbtreat=0 if missing(hbtreat)
drop treat treattemp

** now give 1948-1953 and 1949-1954 changes in deltbeds variable
** will run regression with 1955

sort fcounty1 year
	bys fcounty1:gen beds_lag5= beds_tot[_n-5]
	gen deltbeds=beds_tot-beds_lag5 
	bys fcounty1: gen deltbeds1=deltbeds[_n+1] 
	bys fcounty1: gen deltbeds2=deltbeds[_n+2] 
	bys fcounty1: replace deltbeds=deltbeds1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltbeds=deltbeds2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	order deltb* treat_it hbtreat fcounty year beds_tot beds_l
		gen pctch_bedstot=(beds_tot-beds_lag5)/beds_lag5
		sort fcounty1 year
		bys fcounty1: gen pctch1=pctch_bedstot[_n+1] 
		bys fcounty1: gen pctch2=pctch_bedstot[_n+2] 
		bys fcounty1: replace pctch_bedstot=pctch1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
		bys fcounty1: replace pctch_bedstot=pctch2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltbeds1 deltbeds2 pctch1 pctch2	 

	bys fcounty1:gen bedsnppb_lag5= beds_nppub[_n-5]
	gen deltbeds_nppub=beds_nppub-bedsnppb_lag5 
	bys fcounty1: gen deltbeds1=deltbeds_nppub[_n+1] 
	bys fcounty1: gen deltbeds2=deltbeds_nppub[_n+2] 
	bys fcounty1: replace deltbeds_nppub=deltbeds1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltbeds_nppub=deltbeds2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
		gen pctch_bedsnppub=(beds_nppub-bedsnppb_lag5 )/bedsnppb_lag5 
		sort fcounty1 year
		bys fcounty1: gen pctch1=pctch_bedsnppub[_n+1] 
		bys fcounty1: gen pctch2=pctch_bedsnppub[_n+2] 
		bys fcounty1: replace pctch_bedsnppub=pctch1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
		bys fcounty1: replace pctch_bedsnppub=pctch2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltbeds1 deltbeds2 pctch1 pctch2	 

	bys fcounty1:gen bedsfp_lag5= bdtotfp[_n-5]
	gen deltbeds_fp=bdtotfp-bedsfp_lag5 
	bys fcounty1: gen deltbeds1=deltbeds_fp[_n+1] 
	bys fcounty1: gen deltbeds2=deltbeds_fp[_n+2] 
	bys fcounty1: replace deltbeds_fp=deltbeds1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltbeds_fp=deltbeds2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
		gen pctch_bedsfp=(bdtotfp-bedsfp_lag5)/bedsfp_lag5
		sort fcounty1 year
		bys fcounty1: gen pctch1=pctch_bedsfp[_n+1] 
		bys fcounty1: gen pctch2=pctch_bedsfp[_n+2] 
		bys fcounty1: replace pctch_bedsfp=pctch1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
		bys fcounty1: replace pctch_bedsfp=pctch2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltbeds1 deltbeds2 pctch1 pctch2	 


**logbeds**
	sort fcounty year
	bys fcounty1:gen lbeds_lag5= lbeds_tot[_n-5]
	gen deltlbeds=lbeds_tot-lbeds_lag5 
	bys fcounty1: gen deltlbeds1=deltlbeds[_n+1] 
	bys fcounty1: gen deltlbeds2=deltlbeds[_n+2] 
	bys fcounty1: replace deltlbeds=deltlbeds1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltlbeds=deltlbeds2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	order deltlb* treat_it hbtreat fcounty year beds_tot beds_l
	drop deltlbeds1 deltlbeds2	

	sort fcounty year
	bys fcounty1:gen lbedsnppb_lag5= lbeds_nppub[_n-5]
	gen deltlbeds_nppub=lbeds_nppub-lbedsnppb_lag5 
	bys fcounty1: gen deltlbeds1=deltlbeds_nppub[_n+1] 
	bys fcounty1: gen deltlbeds2=deltlbeds_nppub[_n+2] 
	bys fcounty1: replace deltlbeds_nppub=deltlbeds1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltlbeds_nppub=deltlbeds2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltlbeds1 deltlbeds2	

	sort fcounty year
	bys fcounty1:gen lbedsfp_lag5= lbdtotfp[_n-5]
	gen deltlbeds_fp=lbdtotfp-lbedsfp_lag5 
	bys fcounty1: gen deltlbeds1=deltlbeds_fp[_n+1] 
	bys fcounty1: gen deltlbeds2=deltlbeds_fp[_n+2] 
	bys fcounty1: replace deltlbeds_fp=deltlbeds1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltlbeds_fp=deltlbeds2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltlbeds1 deltlbeds2	

**beds per capita**
	sort fcounty year
	gen bedspc_tot=beds_tot/(ipop/1001)
	gen bedspc_nppub=beds_nppub/(ipop/1001)
	gen bedspc_fp=bdtotfp/(ipop/1001)

	bys fcounty1:gen bedspc_lag5= bedspc_tot[_n-5]
	gen deltbedspc=bedspc_tot-bedspc_lag5 
	bys fcounty1: gen deltbedspc1=deltbedspc[_n+1] 
	bys fcounty1: gen deltbedspc2=deltbedspc[_n+2] 
	bys fcounty1: replace deltbedspc=deltbedspc1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltbedspc=deltbedspc2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltbedspc1 deltbedspc2	

	sort fcounty year
	bys fcounty1:gen bedspc_nppub_lag5= bedspc_nppub[_n-5]
	gen deltbedspc_nppub=bedspc_nppub-bedspc_nppub_lag5
	bys fcounty1: gen deltbedspc1=deltbedspc_nppub[_n+1] 
	bys fcounty1: gen deltbedspc2=deltbedspc_nppub[_n+2] 
	bys fcounty1: replace deltbedspc_nppub=deltbedspc1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltbedspc_nppub=deltbedspc2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltbedspc1 deltbedspc2	

	sort fcounty year
	bys fcounty1:gen bedspc_fp_lag5= bedspc_fp[_n-5]
	gen deltbedspc_fp=bedspc_fp-bedspc_fp_lag5
	bys fcounty1: gen deltbedspc1=deltbedspc_fp[_n+1] 
	bys fcounty1: gen deltbedspc2=deltbedspc_fp[_n+2] 
	bys fcounty1: replace deltbedspc_fp=deltbedspc1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltbedspc_fp=deltbedspc2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltbedspc1 deltbedspc2	

** generate first differences **
	gen ipop2_sq=ipop2^2
	sort fcounty year
	bys fcounty1:gen pop_lag5=ipop2[_n-5]
	bys fcounty1:gen faminc_lag5=imedfaminc[_n-5]
	bys fcounty1:gen nwpop_lag5=inwpop[_n-5]
	bys fcounty1:gen nfmd_lag5=infmd[_n-5]
	bys fcounty1:gen pop65_pct_lag5=pop65_pct[_n-5]
	bys fcounty1:gen poplt5_pct_lag5=poplt5_pct[_n-5]
	bys fcounty1:gen nwpop_pct_lag5=inwpop_pct[_n-5]
	bys fcounty1:gen infmdpc_lag5=infmdpc[_n-5]

	sort fcounty year
	gen deltpop=ipop2-pop_lag5
	bys fcounty1: gen deltpop1=deltpop[_n+1] 
	bys fcounty1: gen deltpop2=deltpop[_n+2] 
	bys fcounty1: replace deltpop=deltpop1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltpop=deltpop2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltpop1 deltpop2

	sort fcounty year
	gen deltfaminc=imedfaminc-faminc_lag5
	bys fcounty1: gen deltfaminc1=deltfaminc[_n+1] 
	bys fcounty1: gen deltfaminc2=deltfaminc[_n+2] 
	bys fcounty1: replace deltfaminc=deltfaminc1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltfaminc=deltfaminc2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltfaminc1 deltfaminc2

	sort fcounty year
	gen deltnwpop=inwpop-nwpop_lag5
	bys fcounty1: gen deltnwpop1=deltnwpop[_n+1] 
	bys fcounty1: gen deltnwpop2=deltnwpop[_n+2] 
	bys fcounty1: replace deltnwpop=deltnwpop1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltnwpop=deltnwpop2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltnwpop1 deltnwpop2

	sort fcounty year
	gen deltinfmdpc=infmdpc-infmdpc_lag5
	bys fcounty1: gen deltinfmdpc1=deltinfmdpc[_n+1] 
	bys fcounty1: gen deltinfmdpc2=deltinfmdpc[_n+2] 
	bys fcounty1: replace deltinfmdpc=deltinfmdpc1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltinfmdpc=deltinfmdpc2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltinfmdpc1 deltinfmdpc2

	sort fcounty year
	gen deltpop65pct=pop65_pct-pop65_pct_lag5
	bys fcounty1: gen deltpop651=deltpop65pct[_n+1] 
	bys fcounty1: gen deltpop652=deltpop65pct[_n+2] 
	bys fcounty1: replace deltpop65pct=deltpop651 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltpop65pct=deltpop652 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltpop651 deltpop652

	sort fcounty year
	gen deltpoplt5pct=poplt5_pct-poplt5_pct_lag5
	bys fcounty1: gen deltpoplt51=deltpoplt5pct[_n+1] 
	bys fcounty1: gen deltpoplt52=deltpoplt5pct[_n+2] 
	bys fcounty1: replace deltpoplt5pct=deltpoplt51 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltpoplt5pct=deltpoplt52 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltpoplt51 deltpoplt52

	sort fcounty year
	gen deltnwpop_pct=inwpop_pct-nwpop_pct_lag5
	bys fcounty1: gen deltnwpop_pct1=deltnwpop_pct[_n+1] 
	bys fcounty1: gen deltnwpop_pct2=deltnwpop_pct[_n+2] 
	bys fcounty1: replace deltnwpop_pct=deltnwpop_pct1 if hbtreat==1 & treat_it[_n-4]==1 & year==1953
	bys fcounty1: replace deltnwpop_pct=deltnwpop_pct2 if hbtreat==1 & treat_it[_n-3]==1 & year==1953
	drop deltnwpop_pct1 deltnwpop_pct1
*********************************************
** deal with rural variable **
	egen rural2=mean(rural), by (fcounty1)
	gen rur3=1 if rural2==1
	replace rur3=0 if rural2==0
	replace rur3=0 if rural2>0 & rural2<1
	replace rur3=1 if missing(rural2)
	drop rural rural2
	rename rur3 rural

sort fcounty1 year
gen deltbedspc49_54_cntrls=deltbedspc if hbtreat==1
bys fcounty1:  replace deltbedspc49_54_cntrls=deltbedspc[_n+1] if hbtreat==0

gen deltbedspc_nppub_49_54_cntrls=deltbedspc_nppub if hbtreat==1
bys fcounty1:  replace deltbedspc_nppub_49_54_cntrls=deltbedspc_nppub[_n+1] if hbtreat==0

gen deltbedspc_fp_49_54_cntrls=deltbedspc_fp if hbtreat==1
bys fcounty1:  replace deltbedspc_fp_49_54_cntrls=deltbedspc_fp[_n+1] if hbtreat==0


gen deltpop49_54_cntrls=deltpop if hbtreat==1
bys fcounty1:  replace deltpop49_54_cntrls=deltpop[_n+1] if hbtreat==0

gen deltfaminc49_54_cntrls=deltfaminc if hbtreat==1
bys fcounty1:  replace deltfaminc49_54_cntrls=deltfaminc[_n+1] if hbtreat==0

gen deltnwpop49_54_cntrls=deltnwpop if hbtreat==1
bys fcounty1:  replace deltnwpop49_54_cntrls=deltnwpop[_n+1] if hbtreat==0

gen deltinfmdpc49_54_cntrls=deltinfmdpc if hbtreat==1
bys fcounty1:  replace deltinfmdpc49_54_cntrls=deltinfmdpc[_n+1] if hbtreat==0

gen deltpop65pct49_54_cntrls=deltpop65pct if hbtreat==1
bys fcounty1:  replace deltpop65pct49_54_cntrls=deltpop65pct[_n+1] if hbtreat==0

gen deltpoplt5pct49_54_cntrls=deltpoplt5pct if hbtreat==1
bys fcounty1:  replace deltpoplt5pct49_54_cntrls=deltpoplt5pct[_n+1] if hbtreat==0

****************************
* Coefficients for Table 2 *
****************************

reg hbtreat priority deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 [aw=ipop2]
   outreg2 using IV_49_54controls_wts, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

ivregress 2sls deltbedspc49_54 (hbtreat =priority) deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 [aw=ipop2]
   outreg2 using IV_49_54controls_wts, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
ivregress 2sls deltbedspc_nppub_49_54 (hbtreat =priority) deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 [aw=ipop2]
   outreg2 using IV_49_54controls_wts, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
ivregress 2sls deltbedspc_fp_49_54 (hbtreat =priority) deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 [aw=ipop2]
   outreg2 using IV_49_54controls_wts, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
reg deltbedspc49_54 hbtreat  deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 [aw=ipop2]
   outreg2 using IV_49_54controls_wts, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** without weights

reg hbtreat priority deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 
   outreg2 using IV_49_54controls_nowts, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

ivregress 2sls deltbedspc49_54 (hbtreat =priority) deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 
   outreg2 using IV_49_54controls_nowts, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
ivregress 2sls deltbedspc_nppub_49_54 (hbtreat =priority) deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 
   outreg2 using IV_49_54controls_nowts, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
ivregress 2sls deltbedspc_fp_49_54 (hbtreat =priority) deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 
   outreg2 using IV_49_54controls_nowts, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
reg deltbedspc49_54 hbtreat  deltpop49_54_cntrls deltfaminc49_54_cntrls deltnwpop49_54_cntrls deltinfmdpc49_54_cntrls deltpop65pct49_54_cntrls deltpoplt5pct49_54_cntrls rural area if year==1953 
   outreg2 using IV_49_54controls_nowts, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

* unweighted F-stat in first stage is 37.90
