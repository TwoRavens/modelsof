set matsize 5000
* load public replication data
use repdata_public.dta, clear

/* Important Note:
In order to replicate all analysis you need access to the "PETRA" data, which you can obtain from the 

Swiss Federal Statistical Office
Espace de l'Europe 10, 2010 Neuchatel, Switzerland

after signing a data protection and licensing agreement.

The full name of the data (in German) is:
Statistik der auslaendischen Wohnbevoelkerung (PETRA), 1991-2009

From the PETRA data (save as petra.dta), you need the following variables
nat_rate_ord: Naturalization rate ordinary
nat_rate_fac: Naturalization rate facilitated 
ordinary: Number of Naturalizations 
eligible: no of elegible immigrants

The first line merges the petra.dta with the repdata_public.dta   

In order to run the code, you need the following ado files:

eststo from package st0085_2
mat2txt from package mat2txt
outreg2 from pagackage outreg2
*/

net describe st0085_2, from(http://www.stata-journal.com/software/sj14-2)
net install st0085_2, replace
net describe mat2txt, from(http://fmwww.bc.edu/RePEc/bocode/m)
net install mat2txt, replace
net describe outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o)
net install outreg2, replace

/* Merge repdata_public.dta with protected petra.dta */

merge 1:1 bfs year using petra.dta

/* Tables */

/* Table 1: Effect of Direct Democracy on Naturalization Rates */
xtset bfs year, yearly
mean nat_rate_ord if institution_dummyB==1 & eligible!=0
mean nat_rate_ord if institution_dummyB==1 & sprachreg =="G" & eligible!=0

global treat1 = "institution_dummyB ib1.institution_linearB"
matrix res = J(1,3,.)
local append replace

* All munis
 foreach p of global treat1 {
  xtreg  nat_rate_ord  `p' i.year, fe cluster(bfs) , if eligible!=0
  outreg2 using tab1.xls , excel  stats(coef se pval ) noaster cttop("All") dec(2)  sortvar(institution_dummyB 2.institution_linearB  0.institution_linearB) ///
  keep(institution_dummyB 0.institution_linearB  2.institution_linearB) `append'
  if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.00 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.00 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
  local append append
}
* german speaking
foreach p of global treat1 {
  xtreg  nat_rate_ord  `p' i.year, fe cluster(bfs) , if sprachreg =="G" & eligible!=0
  outreg2 using tab1.xls , excel  stats(coef se pval ) noaster cttop("Ger") dec(2) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
  keep(institution_dummyB 0.institution_linearB  2.institution_linearB) `append'
  if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.19 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}
mat res = res[2...,1...]
matlist res


/* Table 2: Successful Appeals and Average Naturalization Rates under Representative and Direct Democracy */

*** under RD ***
eststo:  xtreg  nat_rate_ord  L1.prop_gutheissungen  i.year, fe cluster(bfs) , if eligible!=0 & L1.institution_dummyB==0 & institution_dummyB==0
eststo:  xtreg  nat_rate_ord  i.L1prop_gutheissungengr  i.year, fe cluster(bfs) , if eligible!=0 & L1.institution_dummyB==0 & institution_dummyB==0

eststo:  xtreg  nat_rate_ord  L1.prop2_gutheissungen  i.year, fe cluster(bfs) , if eligible!=0 & L1.institution_dummyB==0 & institution_dummyB==0
eststo:  xtreg  nat_rate_ord  i.L1prop2_gutheissungengr  i.year, fe cluster(bfs) , if eligible!=0 & L1.institution_dummyB==0 & institution_dummyB==0

*** under DD ***
eststo:  xtreg  nat_rate_ord  L1.prop_gutheissungen  i.year, fe cluster(bfs) , if eligible!=0 & L1.institution_dummyB==1 & institution_dummyB==1 
eststo:  xtreg  nat_rate_ord  i.L1prop_gutheissungengr  i.year, fe cluster(bfs) , if eligible!=0 & L1.institution_dummyB==1 & institution_dummyB==1 

eststo:  xtreg  nat_rate_ord  L1.prop2_gutheissungen  i.year, fe cluster(bfs) , if eligible!=0 & L1.institution_dummyB==1 & institution_dummyB==1 
eststo:  xtreg  nat_rate_ord  i.L1prop2_gutheissungengr  i.year, fe cluster(bfs) , if eligible!=0 & L1.institution_dummyB==1 & institution_dummyB==1 
esttab * using tab2.tex, varlabels(_cons \_cons) label  cells(b(fmt(%9.2f)) se(par)) noomitted   depvars nobaselevels  varwidth(50) replace

* means
sum nat_rate_ord if  eligible!=0 & L1.institution_dummyB==0 & institution_dummyB==0 & L1.prop_gutheissungen!=.
sum nat_rate_ord if  eligible!=0 & L1.institution_dummyB==1 & institution_dummyB==1 & L1.prop_gutheissungen!=.


/* Figures */

/* Figure 1: Trends in Naturalization Institutions */
tab  institution_linearB, gen(dd_institution_linearB)
preserve
collapse dd* institution_linearB, by(year)
saveold fig1.dta , replace version(12)
restore

/* Figure 2: Effect of Direct Democracy on Naturalization Rates */
preserve
drop if year==2010 | year==1990

* drop if institution is constant
gen     keepin = 1
bysort  bfs: egen inst_mean = mean(institution_dummy)
replace keepin = 0 if inst_mean == 1 | inst_mean==0 | inst_mean==.

* drop backswitchers from rep to direct dem
gen     switch = D1.institution_dummy
egen    backswitch = min(switch), by(bfs)
replace keepin = 0 if backswitch ==  1
keep if keepin==1 

* year of change
gen     change_year = 0
bysort  bfs: replace change_year = 1 if institution_dummy[_n]!=institution_dummy[_n-1]
replace change_year = 0 if year==1991

* event year varibale */
gen    year_of_change = change_year * year
bysort bfs: egen year_of_change2 = max(year_of_change)
gen    year_zero = year - year_of_change2

* drop if elegible = 0
reg  nat_rate_ord if  eligible!=0
keep if e(sample)

* sign rank test
tsset    bfs year_zero
gen      delta = S2.nat_rate_ord  
signrank delta = 0 if year_zero==0

* back of the envelope calculation
sum ordinary if year_zero>=0
di r(sum)

keep nat_rate_ord year_zero bfs
saveold fig2.dta , replace version(12)
restore


/* Figure 3: Dynamic Effect of Direct Democracy on Naturalization Rates & */
/* Figure 4: Dynamic Effect of Direct Democracy on Facilitated Naturalization Rates (Placebo Outcome) */
preserve
drop if year==2010 | year==1990

tsset  bfs year
bysort bfs: gen number = _n
bysort bfs: egen max_number = max(number)

cap gen     institution_dummy = .
replace     institution_dummy = 1 if institution_linearB==1   // RD 1
replace     institution_dummy = 0 if institution_linearB==2   // DD 2


* drop if institution is constant or missing
gen     keepin = 1
bysort bfs: egen inst_mean = mean(institution_dummy)
replace keepin = 0 if inst_mean == 1 | inst_mean==0 | inst_mean==.
* drop backswitchers from rep to direct dem
gen     switch = D1.institution_dummy
egen    backswitch = min(switch), by(bfs)
replace keepin = 0 if backswitch ==  -1

bysort bfs: egen miss_nat_rate = count(nat_rate_ord)
keep if keepin==1
keep if miss_nat_rate==19

* lags and leads
bysort bfs: gen institution_change = (institution_dummy[_n]-institution_dummy[_n-1])
replace institution_change = 0 if institution_change == . & number==1

bysort bfs: gen institution_change_F1 = institution_change[_n-1]
replace institution_change_F1 = 0 if institution_change_F1 == . & number==1

bysort bfs: gen institution_change_F2 = institution_change[_n-2]
replace institution_change_F2 = 0 if institution_change_F2 == . & (number==1|number==2)

bysort bfs: gen institution_change_F3 = institution_change[_n-3]
replace institution_change_F3 = 0 if institution_change_F3 == . & (number==1|number==2|number==3)
bysort bfs: replace institution_change_F3 = 1 if institution_change_F3[_n-1] ==1

bysort bfs: gen institution_change_L1 = institution_change[_n+1]
replace institution_change_L1 = 0 if institution_change_L1 == . & number==max_number

bysort bfs: gen institution_change_L2 = institution_change[_n+2]
replace institution_change_L2 = 0 if institution_change_L2 == . & (number==max_number|number==max_number-1)

bysort bfs: gen institution_change_L3 = institution_change[_n+3]
replace institution_change_L3 = 0 if institution_change_L3 == . & (number==max_number|number==max_number-1|number==max_number-2)

bysort bfs: gen institution_change_L4 = institution_change[_n+4]
replace institution_change_L4 = 0 if institution_change_L4 == . ///
& (number==max_number|number==max_number-1|number==max_number-2|number==max_number-3)

bysort bfs: gen institution_change_L5 = institution_change[_n+5]
replace institution_change_L5 = 0 if institution_change_L5 == . ///
& (number==max_number|number==max_number-1|number==max_number-2|number==max_number-3|number==max_number-4)

* regression for figure 3
xtset bfs year, yearly

xtreg  nat_rate_ord    institution_change_F3 institution_change_F2 institution_change_F1 ///
institution_change institution_change_L1 institution_change_L2 institution_change_L3 institution_change_L4 institution_change_L5  ///
 I.year, fe cluster(bfs), if eligible!=0  

 
mat cc1 = J(1,2,0)
foreach x of varlist institution_change_F3 institution_change_F2 institution_change_F1 ///
institution_change institution_change_L1 institution_change_L2 institution_change_L3 institution_change_L4 institution_change_L5 {
lincom `x' 
mat cc = `r(estimate)' , `r(se)'
mat rownames cc = `x'
mat cc1 = cc1 \ cc
}
mat cc1 = cc1[2...,1...]
matlist cc1
mat2txt , matrix(cc1) saving(fig3.txt) replace 

* regression for figure 4
xtset bfs year, yearly
xtreg  nat_rate_fac    institution_change_F3 institution_change_F2 institution_change_F1 ///
institution_change institution_change_L1 institution_change_L2 institution_change_L3 institution_change_L4 institution_change_L5  ///
 I.year, fe cluster(bfs), if eligible!=0 
 
mat cc1 = J(1,2,0)
foreach x of varlist institution_change_F3 institution_change_F2 institution_change_F1 ///
institution_change institution_change_L1 institution_change_L2 institution_change_L3 institution_change_L4 institution_change_L5 {
lincom `x' 
mat cc = `r(estimate)' , `r(se)'
mat rownames cc = `x'
mat cc1 = cc1 \ cc
}
mat cc1 = cc1[2...,1...]
matlist cc1
mat2txt , matrix(cc1) saving(fig4.txt) replace 
restore


/* Figure 5: Effect of Direct Democracy on Naturalization Rates by Country of Origin */
matrix res = J(1,5,.)
* all munis
foreach y of varlist nat_rate_ord nat_rate_ord_yutu nat_rate_ord_richeu nat_rate_ord_southeu {

  mean `y' if institution_dummyB==1
  mat meansub = r(table)
  scalar meansub = meansub[1,1]
  
  xtreg  `y'  institution_dummyB i.year   , fe cluster(bfs) 
  lincom -100*(institution_dummyB / meansub)
  matrix temp = r(estimate) , r(se) , r(estimate)-1.96*r(se) , r(estimate)+1.96*r(se) , meansub
  matrix rownames temp = `y'
  matrix res = res \ temp
  
}
mat res = res[2...,1...]
mat2txt , matrix(res) saving(fig5a.txt) replace

* german speaking
matrix res = J(1,5,.)
foreach y of varlist nat_rate_ord nat_rate_ord_yutu nat_rate_ord_richeu nat_rate_ord_southeu {

  mean `y' if institution_dummyB==1 & sprachreg =="G" 
  mat meansub = r(table)
  scalar meansub = meansub[1,1]
  
  xtreg  `y'  institution_dummyB i.year   , fe cluster(bfs) , if sprachreg =="G" 
  lincom -100*(institution_dummyB / meansub)
  matrix temp = r(estimate) , r(se) , r(estimate)-1.96*r(se) , r(estimate)+1.96*r(se) , meansub
  matrix rownames temp = `y'
  matrix res = res \ temp
  
}
mat res = res[2...,1...]
mat2txt , matrix(res) saving(fig5b.txt) replace

/* Figure 6: Effect of Direct Democracy and Voter Preferences */
xtreg  nat_rate_ord c.institution_dummyB##c.svpconstzero i.year  , fe cluster(bfs), if eligible
mat cc1 = J(1,3,0)
forvalues i = 0/100 {
lincom institution_dummyB + c.institution_dummyB#c.svpconstzero *`i'
mat cc = `r(estimate)' , `r(se)' , `i'
mat cc1 = cc1 \ cc
}
numlist "0(1)101"
mat rownames cc1 = `r(numlist)'
mat2txt , matrix(cc1) saving(fig6.txt) replace

preserve
keep    svpconstzero  bfs
saveold svpconstzero.dta, replace version(12)
restore


/* SI Appendix */

/* Table B.1: Naturalization Regimes in Swiss Municipalities (1990-2010) */
preserve
gen one = 1
collapse (count) one , by(inst year) , if  nat_rate_ord!=.
saveold tabb1.dta, replace version(12)
restore

/* Table B.2: Average Naturalization Rates by Regime  */
mean  nat_rate_ord , over(institution_linearB) cluster(bfs)
matlist r(table) , format(%9.2f)
mean  nat_rate_ord , cluster(bfs)
matlist r(table) , format(%9.2f)
tab institution_linearB if nat_rate_ord!=. , mis


/* Table B.3: Robustness Checks: Effect of Direct Democracy on Naturalization Rates */
capture drop time*
gen t=year-1990
gen t2=t^2
xi i.year  i.bfs*t i.bfs*t2, prefix(dd)
drop ddbfs_*

gen cclnpop =log(swiss_pop + foreign_pop)
gen ccL1_ratio_foreign_swiss = L1_ratio_foreign_swiss
gen ccue_rate = ue_rate
gen ccsvpzero = svpzero

set more off, permanently
local append replace
matrix res = J(1,3,.)
global treat1 = "institution_dummyB ib1.institution_linearB"

** All Municipalities
* covariates
log using "TabB3a.smcl" , replace
foreach p of global treat1 {
 xtreg   nat_rate_ord  `p' ddyear*  cc*         , fe cluster(bfs) , if eligible!=0  
 outreg2 using tabb3.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
 keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("All") dec(2) `append'
   if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.00 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.00 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
 local append append
}
* muni specific time quad trends
foreach p of global treat1 {
 xtreg   nat_rate_ord  `p' ddyear* ddbfsXt*     , fe cluster(bfs) , if eligible!=0  
 outreg2 using tabb3.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
 keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("All") dec(2) append
   if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.00 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.00 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}
* both
foreach p of global treat1 {
 xtreg  nat_rate_ord  `p' ddyear* ddbfsXt*  cc*  , fe cluster(bfs) , if eligible!=0  
 outreg2 using tabb3.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
 keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("All") dec(2) append
   if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.00 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.00 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}

** German Speaking
* covariates
foreach p of global treat1 {
 xtreg  nat_rate_ord  `p' ddyear* cc*          , fe cluster(bfs) , if sprachreg =="G" & eligible!=0 
 outreg2 using tabb3.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
 keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("Ger") dec(2) append
   if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.19 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}
* muni specific time quad trends
foreach p of global treat1 {
 xtreg  nat_rate_ord  `p' ddyear* ddbfsXt*     , fe cluster(bfs) , if sprachreg =="G" & eligible!=0
 outreg2 using tabb3.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
 keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("Ger") dec(2) append
   if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.19 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}
/* both */
foreach p of global treat1 {
  xtreg nat_rate_ord  `p' ddyear* ddbfsXt* cc*  , fe cluster(bfs) , if sprachreg =="G" & eligible!=0
 outreg2 using tabb3.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
 keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("Ger") dec(2) append
   if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.19 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}

mat res = res[2...,1...]
matlist res
log close

/* Table B.4: Robustness: Effect of Direct Democracy on Naturalization Rates (Switchers only) */

* code complier cantons
capture drop comply
gen     comply = 1
replace comply = 0 if  kanton=="AG"
replace comply = 0 if  kanton=="BL"
replace comply = 0 if  kanton=="BS"
replace comply = 0 if  kanton=="GL"
replace comply = 0 if  kanton=="GR"
replace comply = 0 if  kanton=="JU"
replace comply = 0 if  kanton=="NW"
replace comply = 0 if  kanton=="OW"
replace comply = 0 if  kanton=="SG"
replace comply = 0 if  kanton=="SO"
replace comply = 0 if  kanton=="SZ"
replace comply = 0 if  kanton=="TG"
replace comply = 0 if  kanton=="UR"

* code switchers 
gen     comply1 = 1
cap drop inst_mean switch backswitch
bysort bfs: egen inst_mean = mean(institution_dummyB)  if year!=1990 & year!=2010 
replace comply1 = 0 if inst_mean ==1 | inst_mean ==0 | inst_mean==.
xtset bfs year, yearly
gen switch = D1.institution_dummyB
egen backswitch = max(switch), by(bfs)
replace comply1 = 0 if backswitch == 1
drop backswitch switch inst_mean

mean nat_rate_ord if institution_dummyB==1 & comply==1 & eligible!=0
mean nat_rate_ord if institution_dummyB==1 & comply1==1 & eligible!=0

mean nat_rate_ord if institution_dummyB==1 & sprachreg =="G" & comply==1 & eligible!=0
mean nat_rate_ord if institution_dummyB==1 & sprachreg =="G" & comply1==1 & eligible!=0


** All municipalities
local append replace
matrix res = J(1,3,.)

* complier cantons only
foreach p of global treat1 {
xtreg  nat_rate_ord  `p' i.year   , fe cluster(bfs) , if comply==1 & eligible!=0
outreg2 using tabb4.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("All") dec(2) `append'
   if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.05 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
local append append
}
* switching munis
foreach p of global treat1 {
xtreg  nat_rate_ord  `p' i.year    , fe cluster(bfs) , if comply1==1 & eligible!=0
 outreg2 using tabb4.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
 keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("All") dec(2) append
    if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 1.90 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}

** German speaking

* complier cantons only
foreach p of global treat1 {
 xtreg  nat_rate_ord  `p' i.year  , fe cluster(bfs) , if sprachreg =="G" & comply==1 & eligible!=0
outreg2 using tabb4.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("Ger") dec(2) append
   if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.46 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}
* switching munis
foreach p of global treat1 {
 xtreg  nat_rate_ord  `p' i.year   , fe cluster(bfs) , if sprachreg =="G" & comply1==1 & eligible!=0
 outreg2 using tabb4.xls , excel  stats(coef se pval ) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
 keep(institution_dummyB 0.institution_linearB  2.institution_linearB) noaster cttop("Ger") dec(2) append
    if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.24 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}


mat res = res[2...,1...]
matlist res'


/* Table B.5: Robustness: Effect of Direct Democracy on Naturalization Rates (Ballot box versus Assembly) */
gen     urne = 0
replace urne = 1 if inst == 1
replace urne = 1 if inst == 3

gen     assembly = 0
replace assembly = 1 if inst == 2
replace assembly = 1 if inst == 4

gen     urne1991 = 1 if urne==1 & year== 1991
egen    urneconst = max(urne1991), by(bfs)

gen     assembly1991 = 1 if assembly==1 & year== 1991
egen    assemblyconst = max(assembly1991), by(bfs)

mean nat_rate_ord if institution_dummyB==1 & urneconst==1 & eligible!=0
mean nat_rate_ord if institution_dummyB==1 &  assemblyconst==1 & eligible!=0

global treat1 = "institution_dummyB"
matrix res = J(1,3,.)

* ballot box
local append replace
 foreach p of global treat1 {
  xtreg  nat_rate_ord  `p' i.year, fe cluster(bfs) , if eligible!=0 & urneconst==1  
  outreg2 using tabb5.xls , excel  stats(coef se pval ) sortvar(institution_dummyB    ) ///
 keep(institution_dummyB   ) noaster cttop("Ballot box") dec(2) `append'
  lincom -1*( `p' / 2.40 )*100
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
 local append append
 }

* assembly
 foreach p of global treat1 {
  xtreg  nat_rate_ord  `p' i.year, fe cluster(bfs) , if eligible!=0 & assemblyconst==1 
  outreg2 using tabb5.xls , excel  stats(coef se pval ) sortvar(institution_dummyB    ) ///
 keep(institution_dummyB   ) noaster cttop("Assembly all ") dec(2) `append'
  lincom -1*( `p' / 1.99 )*100
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
 }
mat res = res[2...,1...]
matlist res'


/* Table B.6: Effect of Direct Democracy on Facilitated Naturalization Rates (Placebo Outcome) */
xtset bfs year, yearly
mean nat_rate_fac if institution_dummyB==1 
mean nat_rate_fac if institution_dummyB==1 & sprachreg =="G" 

matrix res = J(1,3,.)
local append replace
global treat1 = "institution_dummyB ib1.institution_linearB"

* all munis
 foreach p of global treat1 {
  xtreg  nat_rate_fac  `p' i.year, fe cluster(bfs)  
  outreg2 using tabb6.xls , excel  stats(coef se pval ) noaster cttop("All") dec(2) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
  keep(institution_dummyB 0.institution_linearB  2.institution_linearB) `append'
      if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.18 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
  local append append
}
* german speaking
foreach p of global treat1 {
  xtreg  nat_rate_fac  `p' i.year, fe cluster(bfs) , if sprachreg =="G" & eligible!=0
  outreg2 using tabb6.xls , excel  stats(coef se pval ) noaster cttop("Ger") dec(2) sortvar(institution_dummyB 2.institution_linearB 0.institution_linearB  ) ///
  keep(institution_dummyB 0.institution_linearB  2.institution_linearB) `append'
      if "`p'" == "institution_dummyB" {
   lincom -1*( `p' / 2.04 )*100
  } 
  else {
   lincom -1*( 2.institution_linearB / 2.19 )*100
  }
  matrix temp = round(r(estimate),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2)
  matrix res = res \ temp
}
mat res = res[2...,1...]
matlist res'


/* Table B.7: Interaction of Direct Democracy and Voter Preferences */
local append replace
eststo clear

* interaction
global treat1 = "c.institution_dummyB##c.svpconstzero ib1.institution_linearB##c.svpconstzero"
foreach p of global treat1 {
eststo: xtreg  nat_rate_ord  `p' i.year    , fe cluster(bfs) , if eligible!=0 
outreg2 using tabb7.xls , excel  stats(coef se ) noaster cttop("All") dec(3) `append'
local append append
}
foreach p of global treat1 {
eststo:  xtreg  nat_rate_ord  `p' i.year   , fe cluster(bfs) , if sprachreg =="G" &  eligible!=0
outreg2 using tabb7.xls , excel  stats(coef se ) noaster cttop("Ger") dec(3) `append'
}

* non linear interaction
global treat1 = "c.institution_dummyB##i.svpconstzerogr ib1.institution_linearB##i.svpconstzerogr"
foreach p of global treat1 {
eststo: xtreg  nat_rate_ord  `p' i.year    , fe cluster(bfs) , if eligible!=0 
outreg2 using tabb7.xls , excel  stats(coef se ) noaster cttop("All") dec(3) `append'
}
foreach p of global treat1 {
eststo:  xtreg nat_rate_ord  `p' i.year    , fe cluster(bfs) , if sprachreg =="G"  &  eligible!=0
outreg2 using tabb7.xls , excel  stats(coef se ) noaster cttop("Ger") dec(3) `append'
}
esttab * using tabb7.tex, varlabels(_cons \_cons) label  cells(b(fmt(%9.3f)) se(par)) noomitted   depvars nobaselevels  varwidth(50) replace

/* Figure B.1: Effect of Direct Democracy and SVP Vote Shares (Nonlinear Interaction) */
xtreg  nat_rate_ord institution_dummyB##svpconstzerogr i.year , fe cluster(bfs), if eligible!=0
mat cc1 = J(1,3,0)
lincom 1.institution_dummyB
mat cc = `r(estimate)' , `r(se)' , 0
mat cc1 = cc1 \ cc
lincom 1.institution_dummyB + 1.institution_dummyB#1.svpconstzerogr
mat cc = `r(estimate)' , `r(se)' , 1
mat cc1 = cc1 \ cc
lincom 1.institution_dummyB + 1.institution_dummyB#2.svpconstzerogr
mat cc = `r(estimate)' , `r(se)' , 2
mat cc1 = cc1 \ cc
numlist "0(1)3"
mat rownames cc1 = `r(numlist)'
mat2txt , matrix(cc1) saving(figb1.txt) replace 

/* Table B.8: Interaction of Direct Democracy and SVP Seat Share */
xtset bfs year, yearly
mean nat_rate_ord if institution_dummyB==1 & eligible!=0 & svp_exe2_const_100!=. 
mean nat_rate_ord if institution_dummyB==1 & eligible!=0 & svp_exe2_const_100!=. & sprachreg =="G" 

local append replace
eststo clear

* interaction
global treat1 = "c.institution_dummyB##c.svp_exe2_const_100 ib1.institution_linearB##c.svp_exe2_const_100"
foreach p of global treat1 {
eststo:  xtreg  nat_rate_ord  `p' i.year    , fe cluster(bfs) , if eligible!=0 
outreg2 using tabb8.xls , excel  stats(coef se  ) noaster cttop("All") dec(3) `append'
local append append
}
foreach p of global treat1 {
eststo:   xtreg  nat_rate_ord  `p' i.year   , fe cluster(bfs) , if sprachreg =="G" &  eligible!=0
outreg2 using tabb8.xls , excel  stats(coef se  ) noaster cttop("Ger") dec(3) `append'
}
* non linear interaction
global treat1 = "c.institution_dummyB##i.svp_exe2constgr ib1.institution_linearB##i.svp_exe2constgr"
foreach p of global treat1 {
eststo:  xtreg  nat_rate_ord  `p' i.year    , fe cluster(bfs) , if eligible!=0 
outreg2 using tabb8.xls , excel  stats(coef se  ) noaster cttop("All") dec(3) `append'
}
foreach p of global treat1 {
eststo:   xtreg nat_rate_ord  `p' i.year    , fe cluster(bfs) , if sprachreg =="G"  &  eligible!=0
outreg2 using tabb8.xls , excel  stats(coef se  ) noaster cttop("Ger") dec(3) `append'
}
esttab * using tabb8.tex, varlabels(_cons \_cons) label  cells(b(fmt(%9.3f)) se(par)) noomitted   depvars nobaselevels  varwidth(50) replace

preserve
keep    svp_exe2_const_100 bfs
saveold svp_exe2_const_100.dta, replace version(12)
restore

/* Figure B.2: Effect of Direct Democracy and SVP Seat Shares */

* interaction plot (nonlinear)
xi: xtreg  nat_rate_ord institution_dummyB##svp_exe2constgr i.year , fe cluster(bfs), ///
	if eligible!=0 
mat cc1 = J(1,3,0)
lincom 1.institution_dummyB
mat cc = `r(estimate)' , `r(se)' , 0
mat cc1 = cc1 \ cc
lincom 1.institution_dummyB + 1.institution_dummyB#1.svp_exe2constgr 
mat cc = `r(estimate)' , `r(se)' , 1
mat cc1 = cc1 \ cc
lincom 1.institution_dummyB + 1.institution_dummyB#2.svp_exe2constgr 
mat cc = `r(estimate)' , `r(se)' , 2
mat cc1 = cc1 \ cc
numlist "0(1)3"
mat rownames cc1 = `r(numlist)'
mat2txt , matrix(cc1) saving(figb2.txt) replace 


/* Table B.9: Effect of Direct Democracy on Naturalization Rates by Country of Origin */

* all munis
matrix res = J(1,5,.)
eststo clear

foreach y of varlist nat_rate_ord_southeu nat_rate_ord_richeu nat_rate_ord_yutu   {

  mean `y' if institution_dummyB==1
  mat meansub = r(table)
  scalar meansub = meansub[1,1]
  
  eststo:  xtreg  `y'  institution_dummyB i.year   , fe cluster(bfs) 
  lincom -100*(institution_dummyB / meansub)
  matrix temp = round(r(estimate),2) , round(r(se),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2) , meansub
  matrix rownames temp = `y'
  matrix res = res \ temp

  eststo:  xtreg  `y'  ib1.institution_linearB i.year   , fe cluster(bfs) 
  lincom -100*(2.institution_linearB / meansub)
  matrix temp = round(r(estimate),2) , round(r(se),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2) , meansub
  matrix rownames temp = `y'
  matrix res = res \ temp
  
  
}
mat res = res[2...,1...]
esttab * using tabb9a.tex, varlabels(_cons \_cons) label  cells(b(fmt(%9.2f)) se(par)) noomitted   depvars nobaselevels  varwidth(50) replace
matlist res

* german speaking
matrix res = J(1,5,.)
eststo clear

foreach y of varlist nat_rate_ord_southeu nat_rate_ord_richeu nat_rate_ord_yutu   {

  mean `y' if institution_dummyB==1  & sprachreg =="G"
  mat meansub = r(table)
  scalar meansub = meansub[1,1]
  
  eststo:  xtreg  `y'  institution_dummyB i.year   , fe cluster(bfs) , if sprachreg =="G"
  lincom -100*(institution_dummyB / meansub)
  matrix temp = round(r(estimate),2) , round(r(se),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2) , meansub
  matrix rownames temp = `y'
  matrix res = res \ temp

  eststo:  xtreg  `y'  ib1.institution_linearB i.year   , fe cluster(bfs) , if sprachreg =="G"
  lincom -100*(2.institution_linearB / meansub)
  matrix temp = round(r(estimate),2) , round(r(se),2) , round(r(estimate)-1.96*r(se),2) , round(r(estimate)+1.96*r(se),2) , meansub
  matrix rownames temp = `y'
  matrix res = res \ temp
  
  
}
mat res = res[2...,1...]
esttab * using tabb9b.tex, varlabels(_cons \_cons) label  cells(b(fmt(%9.2f)) se(par)) noomitted   depvars nobaselevels  varwidth(50) replace
matlist res


/* Appendix D */
use "ESS1-6e01_0_F1.dta", clear

recode imwbcnt imueclt (0/4=1) (5/10=0)
recode imdfetn impcntr imsmetn (1/2=0) (3/4=1)

svyset  idno [ pweight =  pspwght]

foreach x of varlist imwbcnt imdfetn impcntr imsmetn imueclt {

levelsof cntry, local(levels)
capture matrix drop temp res

foreach l of local levels {
 svy: reg `x'  if cntry=="`l'"
 lincom _cons * 100
 mat res =  r(estimate) , r(se)
 mat rownames res = `l'
 mat temp = res \ nullmat(temp)
 }
matlist temp
mat2txt, matrix(temp) saving("`x'") replace
}









