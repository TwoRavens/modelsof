clear
set more off

**Aaron Flaaen
**September 6, 2017
**Last Updated: Sept 6, 2017
**This File Conducts Analysis of UVs Surrounding 2011 March Tohoku Event
**-------------------------------------------------------------------------

cd 

******************************************
********* IMPORTS FIRST  *****************
******************************************

**--------------------------------------------------------------------------
**Step 1: Prep Data
**--------------------------------------------------------------------------


!gunzip analysisdata_manuf_imp_uv.dta.gz
use analysisdata_manuf_imp_uv.dta, clear
!gzip analysisdata_manuf_imp_uv.dta


**1.1 Ensure that the multinational flags are consistent
bys firmid: egen maxflagfor = max(flag_for_mult)
by firmid: egen maxflagus = max(flag_us_mult)
by firmid: egen maxflagjpn = max(japan)

replace flag_for_mult = maxflagfor
replace flag_us_mult = maxflagus
replace japan = maxflagjpn
drop maxflagjpn maxflagus maxflagfor


**1.2 Restrict to Relevant Sample: Only Other Multinationals
replace flag_for_mult = 1 if japan==1
drop if flag_for_mult==0 & flag_us_mult==0 



**Step 1.3 Create additional variables

gen naics3 = substr(naics_code,1,3)
egen numnaics = group(naics3)

egen numfirmprod = group(firmid hs)

egen numfirmprodcountry = group(firmid hs country)

**Generate Monthvar, and Time-Set the Data
gen monthvar = 588
forvalues i = 2(1)12 {
	replace monthvar = 588 + `i' - 1 if month==`i' & year==2009
}
forvalues i = 1(1)12 {
	replace monthvar = 600 + `i' - 1 if month==`i' & year==2010
}
	
forvalues i = 1(1)12 {
	replace monthvar = 612 + `i' - 1 if month==`i' & year==2011
}
forvalues i = 1(1)12 {
	replace monthvar = 624 + `i' - 1 if month==`i' & year==2012
}


tsset numfirmprodcountry monthvar, monthly



**Step 5.3 Run the Regressions

**Create Indicator Variables for Regressions
**For imports, use the imported trade from japan
xi i.monthvar*i.jpn,noomit
forvalues j = 588(1)635 {
	rename _Imonthvar_`j' monthvar_`j'
	rename _ImonXjpn_`j'_1 monXjap_`j'
}


drop *_0

capture erase ../Tables/regs_uv_imp_update.txt  

gen lrel_uv = log(rel_uv)
gen lnonrel_uv = log(nonrel_uv)

***Intermediate (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 jpn if monthvar<624 & intm==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 jpn if monthvar<624 & intm==1, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & intm==1 , absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-INT, Fixed Effects, Firm-Product-Country, Clustering, Firm-product-country, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & intm==1, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-INT, Fixed Effects, Firm-Product-Country, Clustering, Firm-product-country, Sample, 2009-2011)

**JPN Intermediate (Through 2012)
areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 jpn if intm==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 jpn if intm==1, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635  if intm==1 , absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-INT, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635  if intm==1, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-INT, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2012)


**NJPN Intermediate (Through 2011)
areg rel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & njpn==1 & int==1 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-NJPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg nonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & njpn==1 & int==1, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-NJPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

**NJPN Intermediate (Through 2012)
areg rel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if njpn==1 & int==1 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-NJPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg nonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if njpn==1 & int==1, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-NJPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

**NA Intermediate (Through 2011)
areg rel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & na==1 & int==1 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-NA-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg nonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & na==1 & int==1, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-NA-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

**NA Intermediate (Through 2012)
areg rel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if na==1 & int==1 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-NA-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg nonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if na==1 & int==1, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-NA-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

**JPN Final (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 jpn if monthvar<624 & intm==0 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 jpn if monthvar<624 & intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & intm==0 , absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-FIN, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & intm==0, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-FIN, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2011)

**JPN Final (Through 2012)
areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 jpn if intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 jpn if intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if intm==0, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster  addtext(Type, Imp-FIN, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if intm==0, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_imp_update.txt, noparen noaster addtext(Type, Imp-FIN, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2012)

preserve
clear
import delimited regs_uv_imp_update.txt
export excel using "../Tables/regs_uv_update", sheet("T1_imp") sheetmodify firstrow(variables)
restore


******************************************
********* EXPORTS SECOND *****************
******************************************

**--------------------------------------------------------------------------
**Step 1: Prep Data
**--------------------------------------------------------------------------


!gunzip analysisdata_manuf_exp_uv.dta.gz
use analysisdata_manuf_exp_uv.dta, clear
!gzip analysisdata_manuf_exp_uv.dta


**1.1 Ensure that the multinational flags are consistent
bys firmid: egen maxflagfor = max(flag_for_mult)
by firmid: egen maxflagus = max(flag_us_mult)
by firmid: egen maxflagjpn = max(japan)

replace flag_for_mult = maxflagfor
replace flag_us_mult = maxflagus
replace japan = maxflagjpn
drop maxflagjpn maxflagus maxflagfor


**1.2 Restrict to Relevant Sample: Only Other Multinationals
replace flag_for_mult = 1 if japan==1
drop if flag_for_mult==0 & flag_us_mult==0 



**Step 1.3 Create additional variables

gen naics3 = substr(naics_code,1,3)
egen numnaics = group(naics3)

egen numfirmprod = group(firmid hs)

egen numfirmprodcountry = group(firmid hs country)

**Generate Monthvar, and Time-Set the Data
gen monthvar = 588
forvalues i = 2(1)12 {
	replace monthvar = 588 + `i' - 1 if month==`i' & year==2009
}
forvalues i = 1(1)12 {
	replace monthvar = 600 + `i' - 1 if month==`i' & year==2010
}
	
forvalues i = 1(1)12 {
	replace monthvar = 612 + `i' - 1 if month==`i' & year==2011
}
forvalues i = 1(1)12 {
	replace monthvar = 624 + `i' - 1 if month==`i' & year==2012
}


tsset numfirmprodcountry monthvar, monthly


gen lrel_uv = log(rel_uv)
gen lnonrel_uv = log(nonrel_uv)

**Checking on firm-counts
codebook firmid if japan==1 & lrel_uv~=. & intm==1 & na==1
codebook firmid if japan==1 & lnonrel_uv~=. & intm==1 & na==1
codebook firmid if japan==1 & lrel_uv~=. & intm==0 & na==1
codebook firmid if japan==1 & lnonrel_uv~=. & intm==0 & na==1


**Step 5.3 Run the Regressions

**Create Indicator Variables for Regressions
xi i.monthvar*i.japan
forvalues j = 589(1)635 {
	rename _Imonthvar_`j' monthvar_`j'
	rename _ImonXjap_`j'_1 monXjap_`j'
}


capture erase ../Tables/regs_uv_exp_update.txt  

**JPN Intermediate (Through 2011)
areg rel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & jpn==1 & int==1 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-JPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg nonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & jpn==1 & int==1, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-JPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

**JPN Intermediate (Through 2012)
areg rel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if jpn==1 & int==1 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-JPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg nonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if jpn==1 & int==1, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-JPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

**NJPN Intermediate (Through 2011)
areg rel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & njpn==1 & int==1 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NJPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg nonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & njpn==1 & int==1, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NJPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

**NJPN Intermediate (Through 2012)
areg rel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if njpn==1 & int==1 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NJPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg nonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if njpn==1 & int==1, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NJPN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
*/
**NA All (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1  , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-ALL, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-ALL, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1  , absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-ALL, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-ALL, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2011)



**NA Intermediate (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 & intm==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 & intm==1, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 & intm==1 , absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-INT, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 & intm==1, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-INT, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2011)

**CAN Intermediate (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & country=="xxxx" & intm==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-CAN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, CAN 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & country=="xxxx" & intm==1, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-CAN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, CAN 2009-2011)

**MEX Intermediate (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & country=="xxxx" & intm==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-MEX-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, MEX 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & country=="xxxx" & intm==1, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-MEX-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, MEX 2009-2011)

**NA Intermediate (Through 2012)
areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if na==1 & intm==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if na==1 & intm==1, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if na==1 & intm==1 , absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-INT, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if na==1 & intm==1, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-INT, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2012)

**CAN Intermediate (Through 2012)
areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if country=="xxxx" & intm==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-CAN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, CAN 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if country=="xxxx" & intm==1, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-CAN-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, CAN 2009-2012)

**MEX Intermediate (Through 2012)
areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if country=="xxxx" & intm==1 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-MEX-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, MEX 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if country=="xxxx" & intm==1, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-MEX-INT, Fixed Effects, Firm-Product, Clustering, Firm, Sample, MEX 2009-2012)


**JPN Final (Through 2011)
areg rel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & jpn==1 & int==0 , absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-JPN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg nonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & jpn==1 & int==0, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-JPN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

**JPN Final (Through 2012)
areg rel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if jpn==1 & int==0, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-JPN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg nonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if jpn==1 & int==0, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-JPN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

**NJPN Final (Through 2011)
areg rel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & njpn==1 & int==0, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NJPN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg nonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 if monthvar<624 & njpn==1 & int==0, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NJPN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

**NJPN Final (Through 2012)
areg rel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if njpn==1 & int==0, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NJPN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg nonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 if njpn==1 & int==0, absorb(numfirmprod) vce(cluster numfirm)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NJPN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

**NA Final (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 & intm==0 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 & intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2011)

areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 & intm==0 , absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-FIN, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & na==1 & intm==0, absorb(numfirmprodcountry) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-FIN, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2011)

**CAN Intermediate (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & country=="xxxx" & intm==0 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-CAN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, CAN 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & country=="xxxx" & intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-CAN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, CAN 2009-2011)

**MEX Intermediate (Through 2011)
areg lrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & country=="xxxx" & intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-MEX-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, MEX 2009-2011)
areg lnonrel_uv monthvar_597-monthvar_623 monXjap_597-monXjap_623 japan if monthvar<624 & country=="xxxx" & intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-MEX-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, MEX 2009-2011)


**NA Final (Through 2012)
areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if na==1 & intm==0 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if na==1 & intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, 2009-2012)

areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if na==1 & intm==0 , absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-NA-FIN, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if na==1 & intm==0, absorb(numfirmprodcountry) vce(cluster numfirmprodcountry)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-NA-FIN, Fixed Effects, Firm-Product-Country, Clustering, Firm-prod-country, Sample, 2009-2012)

**CAN Final (Through 2012)
areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if country=="xxxx" & intm==0 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-CAN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, CAN 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if country=="xxxx" & intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-CAN-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, CAN 2009-2012)

**MEX Final (Through 2012)
areg lrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if country=="xxxx" & intm==0 , absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster  addtext(Type, Exp-MEX-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, MEX 2009-2012)
areg lnonrel_uv monthvar_597-monthvar_635 monXjap_597-monXjap_635 japan if country=="xxxx" & intm==0, absorb(numfirmprod) vce(cluster numfirmprod)
outreg2 using ../Tables/regs_uv_exp_update.txt, noparen noaster addtext(Type, Exp-MEX-FIN, Fixed Effects, Firm-Product, Clustering, Firm, Sample, MEX 2009-2012)


preserve
clear
import delimited regs_uv_exp_update.txt
export excel using "../Tables/regs_uv_update", sheet("T2_exp") sheetmodify firstrow(variables)
restore


