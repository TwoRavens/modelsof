

log using "bits/results/5_bits other stuff.smcl", replace

set more off

**NOTE: I was having trouble with the matched data sets so UNLIKE aid and PTAs, this analysis of BITS is all on the full data set.

*****************************************
** subset by allies
*****************************************

cd "bits/madedata"

  local lags ///
  l2jchgdplag2 l3jchgdplag2 l4jchgdplag2 l5jchgdplag2 /// *host GDP growth: jchgdplag2
  l2jfdilag l3jfdilag l4jfdilag l5jfdilag /// *host net FDI inflows (% of GDP) t-1: jfdilag  l2jca_gdp l3jca_gdp l4jca_gdp l5jca_gdp /// *host capital account/gdp: jca_gdp
  l2tradgdp l3tradgdp l4tradgdp l5tradgdp /// *dyadic trade (% of hosts GDP): tradgdp
 
 
*****************************************
** subset by allies
*****************************************

*use "mahmatches_iccprbit.dta", clear
use "iccprRatEpisodeDat.dta", clear
xtset dyad
logit bit012345 treated l1* if alliance==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if alliance==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1


use "opt1RatEpisodeDat.dta", clear
xtset dyad
logit bit012345 treated l1* if alliance==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if alliance==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1


use "catRatEpisodeDat.dta", clear
xtset dyad
logit bit012345 treated l1* if alliance==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if alliance==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1


use "art22RatEpisodeDat.dta", clear
xtset dyad
logit bit012345 treated l1* if alliance==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if alliance==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1



*******************************************
** subset by major trading partners
*******************************************
 
 
use "iccprRatEpisodeDat.dta", clear
xtset dyad
_pctile tradgdp, p(50)
gen tmp = tradgdp > `r(r1)'
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "opt1RatEpisodeDat.dta", clear
xtset dyad
_pctile tradgdp, p(50)
gen tmp = tradgdp > `r(r1)'
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "catRatEpisodeDat.dta", clear
xtset dyad
_pctile tradgdp, p(50)
gen tmp = tradgdp > `r(r1)'
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "art22RatEpisodeDat.dta", clear
xtset dyad
_pctile tradgdp, p(50)
gen tmp = tradgdp > `r(r1)'
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1



*******************************************
** Europe on ex-colonies and US w LA
*******************************************

**********************************
** US aid to Latin America
**********************************

use "iccprRatEpisodeDat.dta", clear
xtset dyad
rename host countryname
run "../../pta/scripts/Make world bank geographic regions.09.03.07.do"
rename countryname host
logit bit012345 treated l1* if home=="United States of America" & region_Latin==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if home=="United States of America" & region_Latin==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "opt1RatEpisodeDat.dta", clear
xtset dyad
rename host countryname
run "../../pta/scripts/Make world bank geographic regions.09.03.07.do"
rename countryname host
logit bit012345 treated l1* if home=="United States of America" & region_Latin==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if home=="United States of America" & region_Latin==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "catRatEpisodeDat.dta", clear
xtset dyad
rename host countryname
run "../../pta/scripts/Make world bank geographic regions.09.03.07.do"
rename countryname host
logit bit012345 treated l1* if home=="United States of America" & region_Latin==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if home=="United States of America" & region_Latin==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "art22RatEpisodeDat.dta", clear
xtset dyad
rename host countryname
run "../../pta/scripts/Make world bank geographic regions.09.03.07.do"
rename countryname host
logit bit012345 treated l1* if home=="United States of America" & region_Latin==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if home=="United States of America" & region_Latin==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1



********************************
** Europe with former colonies
********************************


use "iccprRatEpisodeDat.dta", clear
xtset dyad
merge 1:1 year home host using "../rawdata/colonies.dta"
egen colonial = max(dyad_colony), by(host home)
drop if dyad==.
logit bit012345 treated l1* if colonial==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if colonial==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "opt1RatEpisodeDat.dta", clear
xtset dyad
merge 1:1 year home host using "../rawdata/colonies.dta"
egen colonial = max(dyad_colony), by(host home)
drop if dyad==.
logit bit012345 treated l1* if colonial==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if colonial==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "catRatEpisodeDat.dta", clear
xtset dyad
merge 1:1 year home host using "../rawdata/colonies.dta"
egen colonial = max(dyad_colony), by(host home)
drop if dyad==.
logit bit012345 treated l1* if colonial==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if colonial==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "art22RatEpisodeDat.dta", clear
xtset dyad
merge 1:1 year home host using "../rawdata/colonies.dta"
egen colonial = max(dyad_colony), by(host home)
drop if dyad==.
logit bit012345 treated l1* if colonial==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if colonial==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1



*******************************************
* The effect on transition countries -- they should be most susceptible to external legitimation?
*******************************************

insheet using "../../pta/rawdata/regime type.csv", comma clear
rename name countryname
run "../../pta/scripts/Standardize Country Names.do"
run "../../pta/scripts/Standardize Country Codes.do"
drop if countrycode_g=="Country Code (Gleditsch)"
*gen name_1="France"
gen name_2=countryname
drop countryname
save "../junk/beth regime type for merge.dta", replace

use "iccprRatEpisodeDat.dta", clear
xtset dyad
rename host name_2
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if home==""
egen tmp = max(trans7), by(name_2)
rename name_2 host
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1


use "opt1RatEpisodeDat.dta", clear
xtset dyad
rename host name_2
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if home==""
egen tmp = max(trans7), by(name_2)
rename name_2 host
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1


use "catRatEpisodeDat.dta", clear
xtset dyad
rename host name_2
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if home==""
egen tmp = max(trans7), by(name_2)
rename name_2 host
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1


use "art22RatEpisodeDat.dta", clear
xtset dyad
rename host name_2
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if home==""
egen tmp = max(trans7), by(name_2)
rename name_2 host
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

*******************************************
** subset by middle and low income (bottom 50 %)
*******************************************

use "iccprRatEpisodeDat.dta", clear
xtset dyad
_pctile jgdp, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
gen tmp = jgdp<`r(r1)'
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "opt1RatEpisodeDat.dta", clear
xtset dyad
_pctile jgdp, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
gen tmp = jgdp<`r(r1)'
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "catRatEpisodeDat.dta", clear
xtset dyad
_pctile jgdp, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
gen tmp = jgdp<`r(r1)'
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "art22RatEpisodeDat.dta", clear
xtset dyad
_pctile jgdp, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
gen tmp = jgdp<`r(r1)'
logit bit012345 treated l1* if tmp==1, cluster(dyad) l(90)
logit bit012345 treated l1* `lags' if tmp==1, cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

cd "../.."


log close
