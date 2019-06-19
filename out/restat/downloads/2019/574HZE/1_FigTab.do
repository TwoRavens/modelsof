* Date: April 18, 2019
* Purpose: Figures & tables

cls
clear all 
set more off
capture log close

cd "D:\Dropbox\data"

********************************************************************************
* Figures
********************************************************************************

use pricing.dta, clear

capture drop t0 t1
gen t0= mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2004","DMY"))
gen t1= mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2014","DMY"))

gen launchyr = yofd(dofm(mdate))
sort uscclass genericname 

* Figure 3

twoway scatter wac_unit yr if partb_cms==1 & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters" & priority~=., ///
       tlabel(1999(1)2010, format(%tyCCYY)) ///
	   xtitle("Year",size(medlarge) height(6)) ytitle("WAC at Launch", size(medlarge) height(6)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xsc(lsty(none)) ysc(lsty(none)) ylab(,nogrid) ///
	   plotregion(m(l=2 b=2) lcolor(black))

* Figure 4 (the coefficients from the regression below were used to make Figure 4)

reg lnwac_unit partb_cms yrfe5-yrfe15 partbyrfe5-partbyrfe15 priority chml_newmol mon_bra_usc mon_gen_usc mon_gen_mol if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0) | partbexception==1) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters" 
                           
* Figure 5

insheet using chemodata20140825-nme.csv, c clear 

gen     lyg=.
replace lyg=dos         if missing(lyg)
replace lyg=dpfs        if missing(lyg)
replace lyg=dpfs        if inlist(drug,"afatinib","crizotinib")
gen plyg=price/lyg
gen plygmin=min(plyg,600)
gen plyg_partb=plygmin if partb==1

#delimit;
twoway
(scatter plyg_partb approvaldate, c(none)
yscale(range(0 500) outergap(*1)) 
ylabel( 0(100)500,labs(medsmall) format(%12.0fc) nogrid angle(horizontal))
ytitle("Price per life year gained" "(thousands of 2013 dollars)", margin(r+2))
xscale(range(13149 19723))
xlabel(13189(730)19723, labs(medsmall))
xtitle("Approval date", margin(t+2))
msize(medium) lwidth(none) lcolor(none) mlcolor(black) mfcolor(black)  msymbol(O)
bgcolor(white)
graphr(color(white) margin(r+3 b+2) lstyle(none) lcolor(white)) 
plotregion(lstyle(outline) lwidth(thin) lcolor(white)) 
legend(off)
xline(16437, lp(dash) lc(black)))
;
#delimit cr
						   
********************************************************************************
* Tables
********************************************************************************

* Table 3

use pricing.dta, clear

capture drop t0 t1
gen t0= mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2004","DMY"))
gen t1= mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2014","DMY"))

gen launchyr = yofd(dofm(mdate))
gen partbt1=partb_cms*t1
gen nmepartbt1=chml_newmol*partbt1

sort uscclass genericname

sum partb_cms wac_unit wac_unit10 lnwac_unit priority chml_newmol mon_bra_usc mon_gen_usc mon_gen_mol ///
if (partb_cms==1 & wac_unit<10000) & t0==1 & over6mon==0 & drugformcode=="milliliters" & priority~=. ///
& mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")), sep(0)	   

sum partb_cms wac_unit wac_unit10 lnwac_unit priority chml_newmol mon_bra_usc mon_gen_usc mon_gen_mol  ///
if (notpartb_70==1 & countpartb5==0) & t0==1 & over6mon==0 & drugformcode=="milliliters" & priority~=. ///
& mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")), sep(0)	   

sum partb_cms wac_unit wac_unit10 lnwac_unit priority chml_newmol mon_bra_usc mon_gen_usc mon_gen_mol ///
if partbexception==1 & t0==1 & over6mon==0 & drugformcode=="milliliters" & priority~=. ///
& mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")), sep(0)	   

* Table 4

use pricing.dta, clear

gen t0= mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2004","DMY"))
gen t1= mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2014","DMY"))

gen launchyr = yofd(dofm(mdate))
gen partbt1=partb_cms*t1
gen nmepartbt1=chml_newmol*partbt1

sort uscclass genericname

sum partb_cms wac_unit wac_unit10 lnwac_unit priority chml_newmol mon_bra_usc mon_gen_usc mon_gen_mol ///
if (partb_cms==1 & wac_unit<10000) & t1==1 & over6mon==0 & drugformcode=="milliliters" & priority~=. ///
& mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")), sep(0)	   

sum partb_cms wac_unit wac_unit10 lnwac_unit priority chml_newmol mon_bra_usc mon_gen_usc mon_gen_mol  ///
if (notpartb_70==1 & countpartb5==0) & t1==1 & over6mon==0 & drugformcode=="milliliters" & priority~=. ///
& mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")), sep(0)	   

sum partb_cms wac_unit wac_unit10 lnwac_unit priority chml_newmol mon_bra_usc mon_gen_usc mon_gen_mol ///
if partbexception==1 & t1==1 & over6mon==0 & drugformcode=="milliliters" & priority~=. ///
& mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")), sep(0)	   


* Table 5

capture clear matrix
capture clear mata
set maxvar 10000

use pricing.dta, clear

gen t0= mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2004","DMY"))
gen t1= mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2014","DMY"))

forval i=2005/2010 {
gen post`i'= mdate>=mofd(date("01jan`i'","DMY")) & mdate<=mofd(date("31dec`i'","DMY"))
}

gen partbt1=partb_cms*t1

gen trend0 = (mdate-ym(1999,1))/12 
gen trend1 = (mdate-ym(2005,1))/12

gen trend1t1=trend1*t1
gen nmepartb=chml_newmol*partb_cms
gen nmet1 = chml_newmol*t1
gen prioritypartb = priority*partb_cms
gen orphanpartb = orphan*partb_cms
gen nmetrend1 = chml_newmol*trend1
gen nmetrend1t1 = chml_newmol*trend1t1
gen partbtrend1 = partb_cms*trend1
gen partbtrend1t1 = partb_cms*trend1t1
gen nmepartbt1 = nmepartb*t1

local indepvar1 "trend0 t1 chml_newmol priority"
local indepvar2 "trend0 t1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol"
local indepvar3 "trend0 t1 trend1t1 chml_newmol priority"
local indepvar4 "trend0 t1 trend1t1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol"
local indepvar5 "trend0 t1 post2006 post2007 post2008 post2009 post2010 chml_newmol priority"
local indepvar6 "trend0 t1 post2006 post2007 post2008 post2009 post2010 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol"

forval i= 1/6 {
eststo: quietly areg lnwac_unit10 `indepvar`i''  if (partb_cms==1 & wac_unit<10000)   & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
}
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
eststo clear

* Table 6

set maxvar 20000
set mat 11000

insheet using chemodata20140825-nme.csv, c clear 

gen     lyg=.
replace lyg=dos         if missing(lyg)
replace lyg=dpfs        if missing(lyg)
replace lyg=dpfs        if inlist(drug,"afatinib","crizotinib")
gen post=approvaldate>=mdy(1,1,2005)
gen episodeprice=monthlycostreal*duration/1000
gen lnepisodeprice = ln(episodeprice)
gen plyg=price/lyg
gen lnplyg=ln(plyg)
egen diseaseid = group(disease)

foreach yvar in lnepisodeprice lnplyg {
eststo: quietly reg `yvar' post if partb==1, vce(cl diseaseid)
eststo: quietly reg `yvar' post nme priority if partb==1, vce(cl diseaseid)
}
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
eststo clear

* Table 7

use pricing.dta, clear

gen t0= mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2004","DMY"))
gen t1= mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2014","DMY"))

gen launchyr = yofd(dofm(mdate))
gen partbt1=partb_cms*t1
gen nmepartbt1=chml_newmol*partbt1

local indepvar1 "partbt1 chml_newmol priority yrfe*"
local indepvar2 "partbt1 nmepartbt1 chml_newmol priority yrfe*"
local indepvar3 "partbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"
local indepvar4 "partbt1 nmepartbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"

forval i= 1/4 {
eststo: quietly areg lnwac_unit `indepvar`i''  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
}
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
eststo clear

* Table 8

use pricing.dta, clear

gen t0= mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2004","DMY"))
gen t1= mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2014","DMY"))

gen launchyr = yofd(dofm(mdate))
gen partbt1=partb_cms*t1
gen nmepartbt1=chml_newmol*partbt1

local indepvar1 "partbt1 chml_newmol priority yrfe*"
local indepvar2 "partbt1 nmepartbt1 chml_newmol priority yrfe*"
local indepvar3 "partbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"
local indepvar4 "partbt1 nmepartbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"

forval i= 1/4 {
eststo: quietly areg lnwac_unit `indepvar`i''  if ((partb_cms==1 & wac_unit<10000) | partbexception==1) & (t0==1 | t1==1) & mdate>=mofd(date("01jan`yr0'","DMY")) & mdate<=mofd(date("31dec`yr1'","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode4) vce(cl usccode5)
}
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
eststo clear

* Table A.2

use pricing.dta, clear

gen t0= mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2003","DMY"))
gen t1= mdate>=mofd(date("01jan2006","DMY")) & mdate<=mofd(date("31dec2014","DMY"))
gen partbt1=partb_cms*t1
gen nmepartbt1=chml_newmol*partbt1

gen trend0partb=0
gen trend1partbt1=0
gen nmepartb=chml_newmol*partb_cms
gen nmet1 = chml_newmol*t1
gen prioritypartb = priority*partb_cms
gen orphanpartb = orphan*partb_cms
 
local indepvar1 "partbt1 chml_newmol priority yrfe*"
local indepvar2 "partbt1 nmepartbt1 chml_newmol priority yrfe*"
local indepvar3 "partbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"
local indepvar4 "partbt1 nmepartbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"

eststo: quietly areg lnwac_unit `indepvar1'  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
eststo: quietly areg lnwac_unit `indepvar2'  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
eststo: quietly areg lnwac_unit `indepvar3'  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
eststo: quietly areg lnwac_unit `indepvar4'  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
capture eststo clear

* Table A.3

gen nmepartb=chml_newmol*partb_cms

local indepvar1 "partbt1 chml_newmol priority yrfe*"
local indepvar2 "partbt1 nmepartbt1 chml_newmol priority yrfe*"
local indepvar3 "partbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"
local indepvar4 "partbt1 nmepartbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"

forval i= 1/4 {
eststo: quietly areg lnwac_unit `indepvar`i''  if ((partb_cms==1 & wac_unit<10000) | (notpartb_80==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
}
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
eststo clear

* Table A.4

use pricing.dta, clear

gen t0= mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2001","DMY"))
gen t1= mdate>=mofd(date("01jan2002","DMY")) & mdate<=mofd(date("31dec2004","DMY"))
gen partbt1=partb_cms*t1
gen nmepartbt1=chml_newmol*partbt1

local indepvar1 "partbt1 chml_newmol priority yrfe*"
local indepvar2 "partbt1 chml_newmol priority yrfe* nmepartbt1"
local indepvar3 "partbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"
local indepvar4 "partbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe* nmepartbt1"

forval i= 1/4 {
eststo: quietly areg lnwac_unit `indepvar`i''  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2004","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
}
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
capture eststo clear

* Table A.5

use pricing.dta, clear

gen t0= mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2007","DMY"))
gen t1= mdate>=mofd(date("01jan2008","DMY")) & mdate<=mofd(date("31dec2010","DMY"))
gen partbt1=partb_cms*t1
gen nmepartbt1=chml_newmol*partbt1

local indepvar1 "partbt1 chml_newmol priority yrfe*"
local indepvar2 "partbt1 chml_newmol priority yrfe* nmepartbt1"
local indepvar3 "partbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe*"
local indepvar4 "partbt1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol yrfe* nmepartbt1"

forval i= 1/4 {
eststo: quietly areg lnwac_unit `indepvar`i''  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", absorb(usccode5) vce(cl usccode5)
}
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
capture eststo clear

* Table A.6

use pricing.dta, clear
gen launchyr = yofd(dofm(mdate))
sort uscclass genericname 
browse uscclass ndc genericname strength dosageform drugformcode launchyr wac_unit partb_cms if partb_cms==1 & over6mon==0 & priority~=. & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY"))

* Table A.7

use pricing.dta, clear
gen launchyr = yofd(dofm(mdate))
sort uscclass genericname 
browse uscclass ndc genericname strength dosageform drugformcode launchyr wac_unit partb_cms if partbexception==1 & over6mon==0 & priority~=. & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY"))

* Table A.8

use pricing.dta, clear
gen launchyr = yofd(dofm(mdate))
sort uscclass genericname 
browse uscclass ndc genericname strength dosageform drugformcode launchyr wac_unit partb_cms if (notpartb_70==1 & countpartb5==0) & over6mon==0 & priority~=. & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY"))

* Table A.9

use pricing.dta, clear

gen t0= mdate>=mofd(date("01jan1996","DMY")) & mdate<=mofd(date("31dec2004","DMY"))
gen t1= mdate>=mofd(date("01jan2005","DMY")) & mdate<=mofd(date("31dec2014","DMY"))
gen partbt1=partb_cms*t1
gen nmepartbt1=chml_newmol*partbt1

replace mms=0 if (mms==. & partb_cms==0) 
gen mmspartbt1 = mms*partbt1
gen mmspartb = mms*partb_cms

replace mms_usc=0 if (mms_usc==. & partb_cms==0) 
gen mmsuscpartbt1 = mms_usc*partbt1
gen mmsuscpartb = mms_usc*partb_cms

local indepvar1 "mmspartbt1 mmspartb  t1 chml_newmol priority"
local indepvar2 "mmspartbt1 mmspartb  t1 chml_newmol priority mon_bra_usc mon_gen_usc mon_gen_mol"

eststo: quietly reg lnwac_unit10 `indepvar1'  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", vce(cl usccode5)
eststo: quietly reg lnwac_unit10 `indepvar2'  if ((partb_cms==1 & wac_unit<10000) | (notpartb_70==1 & countpartb5==0)) & (t0==1 | t1==1) & mdate>=mofd(date("01jan1999","DMY")) & mdate<=mofd(date("31dec2010","DMY")) & over6mon==0 & drugformcode=="milliliters", vce(cl usccode5)                                              
esttab, se r2(2) ar2(2) star(* 0.1 ** 0.05 *** 0.01)
capture eststo clear
