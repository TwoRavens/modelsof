capture log close
log using patents.log , replace 

***********************************************************************
*** Data from NBER: pat76_06_assg.dta, Dynass.dta  and pdpcohdr.dta ***
***********************************************************************
**prepare the dynass data for match **
use dynass.dta,clear 
duplicates drop pdpass, force 
save dynass.dta,replace 

use pat76_06_assg.dta, clear   // all with assignees

keep appyear asscode assgnum country gyear patent subcat pdpass state nclaims
keep if country == "US"
drop if appyear < 1976 
drop if mi(state)
unique pdpass  // 113,405 unique U.S. assignee 
rename appyear year 

bysort patent (pdpass) : egen asgn_count = count(pdpass)  
gen patfrac = 1/asgn_count  //assign a fraction of the patent to each assignee 

sort pdpass
merge m:1 pdpass using dynass.dta
keep if _m == 3   // Matched  % (867k of 1397k) master obs; Others not in Compustat
drop _m source 

gen gvkey = .
forvalues i = 1/5 {
   replace gvkey = gvkey`i' if begyr`i' <= year & year <= endyr`i'
   }

label variable gvkey "Assignee gvkey"
drop gvkey1-gvkey5 begyr1-begyr5 endyr1-endyr5 pdpco1-pdpco5
drop if mi(gvkey)

***change the state code to geoFIPS (number) ***
rename state state_code
gen int state = . 
run FIPS_upper.do

***sum over multiple assignee to get patents for each company state **
sort gvkey state year 
collapse (sum) patstyr = patfrac, by (gvkey state year)

label variable patstyr "Patents by assignee-state-year"
label variable year "Application year"

**Merge with Compustat to get company inforamtion  **
merge m:1 gvkey year using compustat.dta
 // m:1 for companies spanning several states
 // 47.6k matched out of 316.6k from compustat
unique gvkey if _m == 3  //matched 5,959 companies 
drop if _m==1
drop _m

** companies with zero patents **
sort gvkey year
merge m:1 gvkey using pdpcohdr.dta
drop if _m == 2   /* drop observations from pdpcohdr only  -- no
patent info because not in record, not necessarily because
no patents; dropped only [..] of observations */
drop _m  name cusip cusip pdpco pdpseq begyr endyr _merge  firstyr lastyr

sort gvkey 
replace patstyr = 0 if match != . & patstyr ==.   
drop match 

bysort gvkey state : egen patstttl = total(patstyr)
drop if patstttl <=2  //company-states apply too few patent: outlier 

***industry 
rename sic sic4 
gen sic4str = sic4
destring(sic4) , replace 
gen sic2 = substr(sic4str, 1, 2) 
destring(sic2) , replace
gen sic3 = substr(sic4str, 1, 3) 
destring(sic3) , replace
drop sic4str
run hitech.do

***utsa index ***
merge m:1 state year using utsan.dta
drop if _m == 2
drop _m

***US deflator ***
merge m:1 year using USdeflator.dta 
keep if _m == 3
drop _m
replace gdp_defltr = gdp_defltr/100
replace gpdi_defltr = gpdi_defltr/100

** company-state measures **  
bysort gvkey year (state) : egen patyr = total(patstyr)
gen xrdst = xrd * patstyr/patyr 
gen xrdst_real = xrdst/gpdi_defltr  
gen xrdst_ln = ln(1 + xrdst/gpdi_defltr)   
label variable xrdst_real "R&D by state (real)"
label variable xrdst_ln "R&D by state (ln)"

gen patstyrst = patstyr/patyr if year == utsayr - 1
bysort gvkey state (patstyrst) : replace patstyrst = patstyrst[_n-1] if !mi(patstyrst[_n-1])
gen xrdstpre = xrd * patstyrst 
gen xrdstpre_real = xrd * patstyrst/gpdi_defltr
gen xrdstpre_ln = ln(1 + xrd * patstyrst/gpdi_defltr)   
label variable xrdstpre_real "R&D by state (real)"
label variable xrdstpre_ln "R&D by state (ln)"

gen patstyr_ln = ln(1 + patstyr) 
gen patstyrst_ln = ln(1 + patstyr/patyr)

gen revt_real = revt/gdp_defltr
gen revt_ln = ln(1 + revt/gdp_defltr) if  revt >= 0 
gen rdst_int = (xrdst/gpdi_defltr)/(revt/gdp_defltr)
gen mktbook000 = ((at + (csho*prcc_f) - (ceq+txdb)) / (ceq+txdb))/1000
gen ebitda_real = ebitda/gdp_defltr 
gen ebitda_ln = ln(1 + ebitda/gdp_defltr)
global sample (xrdst >= 0 & revt >= 0 & mktbook000 >= 0) 
label variable revt_real "Revenue (real)"
label variable revt_ln "Revenue (ln)"
label variable ebitda_real "EBITDA (real)"
label variable ebitda_ln "EBITDA (ln)"
label variable mktbook000 "Market-book value ('000)"

foreach var in utsan{
   su revt_real if $sample
   local revt_avg_ln = ln(1 + r(mean)) 
   gen `var'_revt = `var' * (revt_ln - `revt_avg_ln') 
   gen `var'_hitech1 = `var' * hitech1
   gen `var'_hitech2 = `var' * hitech2
   }
label variable utsan_revt "UTSA x revenue (ln)"
label variable utsan_hitech1 "UTSA x hitech"
label variable utsan_hitech2 "UTSA x hitech (def2)"


replace patstyrst = patstyr/patyr if year == 1988 & (utsayr >= 1998 | mi(utsayr))
 // states that enacted utsa after study period
bysort gvkey state (patstyrst) : replace patstyrst = patstyrst[_n-1] ///
   if !mi(patstyrst[_n-1])
replace xrdstpre_real = xrd * patstyrst /gpdi_defltr
replace xrdstpre_ln = ln(1 + (xrd * patstyrst)/gpdi_defltr)

drop if mi(state)
gen long gvkeyst = gvkey *100 +state 
compress
save patent_cpstat.dta , replace
  
****************
*** Analysis ***
****************

use patent_cpstat.dta , clear

** analysis **
global method  xtivreg2  // xtivreg2  areg 
global depvar xrdstpre_ln   
global cntrvar revt_ln ebitda_ln mktbook000 
global utsavar utsan utsan_revt utsan_hitech1 
global sample (xrdst >= 0 & revt >= 0 & mktbook000 >= 0) 
global excldef (sic3 != 372 & sic3 != 376 & sic3 != 381) 
global options fe cluster(state gvkey)  
global outfile patent 

xtset gvkeyst year
  
xi: $method $depvar $cntrvar $utsavar i.year if $sample & $excldef , ///
   $options   //54 observations not used 

gen smpl_ed = 1 if e(sample)

summ revt_real if smpl_ed == 1
global revt_avg = ln(1 + r(mean))
summ utsan if smpl_ed == 1 
global utsan_avg = r(mean)

su patstyr if smpl_ed ==1 
global patstyr_avg = r(mean) 
su patyr if smpl_ed == 1
global patyr_avg = r(mean)  
su patstyrst if smpl_ed == 1 
global patstyrst_avg = r(mean) 
su xrdst_real if smpl_ed == 1 
global xrdst_ravg = r(mean) 
su xrdstpre_real if smpl_ed == 1 
global xrdstpre_ravg = r(mean) 


foreach ind in 283 284 356 357 {
  summ revt_real if smpl_ed == 1 & sic3 == `ind'
  local revt_diff`ind' = ln(1 + r(mean)) - $revt_avg
  summ hitech1 if smpl_ed == 1 & sic3 == `ind'
  local ht`ind' = r(mean)
  }
  
foreach ind in 283 284 356 357{  
 lincom $utsan_avg*utsan + $utsan_avg *`revt_diff`ind''*utsan_revt + $utsan_avg *`ht`ind''*utsan_hitech1 
 global es`ind' : di  %05.3f r(estimate)*(1+1/$xrdstpre_ravg)
 global se`ind' : di  %05.3f r(se)*(1+1/$xrdstpre_ravg)
 test $utsan_avg*utsan + $utsan_avg *`revt_diff`ind''*utsan_revt + $utsan_avg *`ht`ind''*utsan_hitech1  = 0
 global p`ind' : di  %05.3f r(p) 
 global est`ind' = "${es`ind'}" 
 if ${p`ind'}<=0.1{
 global est`ind' = "${est`ind'}*" 
 }
 if ${p`ind'}<=0.05{
 global est`ind' = "${est`ind'}*" 
 }
 if ${p`ind'}<=0.01{
 global est`ind' = "${est`ind'}*" 
 }
 }
global outregopt1 landscape plain coljust(lc) varlabels se starlevels(10 5 1) ///
   starloc(1) summstat(r2 \N \ N_clust2 \N_g) ///
	summtitles("R2" \ "Observations" \"Companies" \ "Companies-states") ///
	addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes" \ ///
   "Drugs" , "$est283" \ "s.e.", "$se283" \ "p-value", "$p283" \ ///
   "Soaps and cleaners" ,"$est284" \ "s.e.", "$se284" \ "p-value", "$p284" \ ///
   "Industrial machinery" , "$est356" \ "s.e.", "$se356" \ "p-value", "$p356" \ ///
   "Computers and office eqpt" , "$est357" \ "s.e.", "$se357" \ "p-value", "$p357") 
outreg using $outfile , $outregopt1 replace  ///
   keep($cntrvar $utsavar ) ctitles("VARIABLES", "Conditional R&D") ///
   note("Dependent variable: conditional R&D by company-state-year" \  ///
     "Robust standard errors clustered by state and company" )  ///
   title("Table . Conditional on pre-UTSA patent ($S_DATE)") 
  
log close 
