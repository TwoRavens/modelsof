* Loading the data

import delimited prod_dataregression.tab
global cov2 "prgroup govown foreign medium small age age2"

* Managing the data

keep if yr<1997
drop yeardum9-yeardum14

tsset id yr

* Generating output

* Column 1 - xi: reg tfp1000 lagtariff  $cov2 i.yr , robust cluster(companyname)
* Column 2 - xi: areg tfp1000 lagtariff  $cov2 i.yr , absorb(industrycode) cluster(companyname)

* Columns 3, 4
xi: areg tfp1000 lagtariff  $cov2 i.yr , absorb(companyname) cluster(companyname) 
xi: areg tfp1000 lagtariff  $cov2 i.yr if  exist90_96==1, absorb(companyname) cluster(companyname)

* Columns 5, 6, 7
xi: areg tfp1000 lagtariff lagtfp1000  $cov2 i.yr , absorb(companyname) cluster(companyname)
xtabond tfp1000 lagtariff yeardum* age age2, robust
xtabond tfp1000 lagtariff yeardum* age age2, robust lag(2)

* Save the results for use in R
save "trade_liberalization.dta"
