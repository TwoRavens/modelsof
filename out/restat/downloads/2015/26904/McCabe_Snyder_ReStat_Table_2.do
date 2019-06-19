log using McCabe_Snyder_ReStat_Table_2, replace

**********************************************************************
*
* Program McCabe_Snyder_ReStat_Table_2.DO
* 
* Runs regressions behind Table 2 based on information collected by
* research assistants on subsample of 1,500 observations.  Regressions
* use panel-count-data specification, regression number of references
* on year dummies, which are the variables of interest (giving 
* percent increase 1985 to 1995 and 1995 to 2005). 
*
* McCabe & Snyder August 2013
*
**********************************************************************

* Set initial Stata parameters
version 12
set more 1

use McCabe_Snyder_ReStat_references
codebook

gen t1995 = pyear == 1995
gen t2005 = pyear == 2005

gen lnpages = ln(pages)
gen lnref = ln(ref)
gen lnrefpage = ln(ref/pages)

encode jrnlfull, gen(journal)
xtset journal

* Run regressions in two ways so can get period-over-period
* increase as well as increase over combined period.


* First way: t1995 variable captures 1985-95 increase 
* and t2005 variable captures combined 1985-2005 increase.

xtreg lnpages t1995 t2005, fe cluster(journal)
test t1995 = t2005

xtreg lnrefpage t1995 t2005, fe cluster(journal)
test t1995 = t2005

xtreg lnref t1995 t2005, fe cluster(journal)
test t1995 = t2005


* Redefine so t1995 variable still captures 1985-95 increase
* but t2005 variable captures just 1995-2005 increase.

replace t1995 = 1 if t2005 == 1

xtreg lnpages t1995 t2005, fe cluster(journal)

xtreg lnrefpage t1995 t2005, fe cluster(journal)

xtreg lnref t1995 t2005, fe cluster(journal)




