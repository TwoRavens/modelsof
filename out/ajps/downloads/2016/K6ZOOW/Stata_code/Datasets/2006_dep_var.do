***************************************************************************
* File:               2006_dep_var.do
* Author:             Miguel R. Rueda
* Description:        Creates dataset with total monitors' reports per municipality for 2006. 
* Created:            September - 22 - 2015
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************





 
cd "\Datasets\Dep_vars\"


*Aggregating congresional election reports
use 2006c_m.dta, clear

gen municipio=lower(municipality)
drop municipality

foreach var in  intimidation neg_t_buying vote_buying moving_votes{
gen `var'_n=real(`var')
drop `var'
rename `var'_n `var'
}
 
replace municipio="barrancabermeja" if municipio=="barranca"

collapse (sum) moving_votes vote_buying neg_t_buying intimidation ,by(municipio)
gen year=2006

order municipio year



generate var7 = 63001 in 1
replace var7 = 68081 in 2
replace var7 = 11001 in 3
replace var7 = 68001 in 4
replace var7 = 76001 in 5
replace var7 = 68276 in 6
replace var7 = 68307 in 7
replace var7 = 68547 in 8
replace var7 = 68979 in 9
replace var7 = 70771 in 10

rename var7 muni_code

sort muni_code year

drop municipio
gen type=1 

gen total_moe= vote_buying+neg_t_buying+moving_votes+neg_t_buying+intimidation

save 2006cmuni.dta, replace




