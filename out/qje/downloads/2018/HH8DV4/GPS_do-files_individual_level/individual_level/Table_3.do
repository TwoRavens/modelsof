* Variance decomposition

use ../Data/Individual.dta, clear

foreach i in patience risktaking posrecip negrecip altruism trust{
reg `i' [aweight=wgt],a(ison)
}
   

   
* Regional averages   
   
use ../Data/Country.dta, clear



foreach i in patience risktaking posrecip negrecip altruism trust{

* Western Europe
sum `i' if europe_west==1

* Eastern Europe
sum `i' if europe_east==1

* Neo Europe
sum `i' if western==1

* South and Southeast Asia
sum `i' if (wb_sas==1 | wb_eap==1) & isocode!="AUS"

* North Africa and ME
sum `i' if wb_mena==1

* Sub-Saharan Africa
sum `i' if wb_ssa==1

* South America
sum `i' if wb_lac==1
}
