** Run the main models
** This script assumes that the current working directory is the top level of the archive

capture mkdir "bits/results"
log using "bits/results/3_bit matching models.smcl", replace

set more off

cd "bits/madedata/"

** these are the covariates that I lag 5 years instead of just 1
local lags ///
/*  l2mjfdi l3mjfdi l4mjfdi l5mjfdi ///  *avg annual global fdi flows: mjfdi
*/  l2jextract l3jextract l4jextract l5jextract  /// *host extractive industries/exports: jextract
/*  l2jcorruption l3jcorruption l4jcorruption l5jcorruption */ /// *perceptions of host corruption: jcorruption
  l2jgdp l3jgdp l4jgdp l5jgdp /// *host GDP(ln): jgdp
  l2jgdpcap l3jgdpcap l4jgdpcap l5jgdpcap /// *host GDP/capita: jgdpcap
  l2jchgdplag2 l3jchgdplag2 l4jchgdplag2 l5jchgdplag2 /// *host GDP growth: jchgdplag2
  l2jfdilag l3jfdilag l4jfdilag l5jfdilag /// *host net FDI inflows (% of GDP) t-1: jfdilag  l2jca_gdp l3jca_gdp l4jca_gdp l5jca_gdp /// *host capital account/gdp: jca_gdp
/*  l2jdem l3jdem l4jdem l5jdem ///  *host democracy: jdem
  l2jpriv l3jpriv l4jpriv l5jpriv */ /// *host privatization record: jpriv
  l2sfdi l3sfdi l4sfdi l5sfdi /// *home net fdi outflows (% of GDP): sfdi
  l2tradgdp l3tradgdp l4tradgdp l5tradgdp /// *dyadic trade (% of hosts GDP): tradgdp
  
  local lags ///
  l2jchgdplag2 l3jchgdplag2 l4jchgdplag2 l5jchgdplag2 /// *host GDP growth: jchgdplag2
  l2jfdilag l3jfdilag l4jfdilag l5jfdilag /// *host net FDI inflows (% of GDP) t-1: jfdilag  l2jca_gdp l3jca_gdp l4jca_gdp l5jca_gdp /// *host capital account/gdp: jca_gdp
  l2tradgdp l3tradgdp l4tradgdp l5tradgdp /// *dyadic trade (% of hosts GDP): tradgdp
 
  
** iccpr
use "mahmatches_iccprbit.dta", clear
xtset dyad
logit bit012345 treated l1*, cluster(dyad) l(90)
logit bit012345 treated l1* `lags', cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1


use "mahmatches_iccprbit_Ratifiers.dta", clear
xtset dyad
logit bit012345 treated l1*, cluster(dyad) l(90)
logit bit012345 treated l1* `lags', cluster(dyad) l(90)
cd "../results/"
outreg2 using fulltable, word replace 2aster 
cd "../madedata/"
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

  ** quantities of interest
estsimp logit bit012345 treated l1* `lags', cluster(dyad) l(90)
set seed 1234
setx  (treated) 0 (l1* `lags') median
simqi, pr listx level(90)
setx  (treated) 1 (l1* `lags') median
simqi, pr listx level(90)
simqi, fd(pr) listx changex(treated 0 1) level(90)

** for the table of m values
simqi, fd(pr) listx changex(treated 0 1) level(98)
simqi, fd(pr) listx changex(treated 0 1) level(90)
simqi, fd(pr) listx changex(treated 0 1) level(80)
simqi, fd(pr) listx changex(treated 0 1) level(70)
simqi, fd(pr) listx changex(treated 0 1) level(60)
simqi, fd(pr) listx changex(treated 0 1) level(50)


** opt1  
use "mahmatches_opt1bit.dta", clear
xtset dyad
logit bit012345 treated l1*, cluster(dyad) l(90)
logit bit012345 treated l1* `lags', cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_opt1bit_Ratifiers.dta", clear
xtset dyad
logit bit012345 treated l1*, cluster(dyad) l(90)
logit bit012345 treated l1* `lags', cluster(dyad) l(90)
cd "../results/"
outreg2 using fulltable, word append 2aster 
cd "../madedata/"
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

  ** quantities of interest
estsimp logit bit012345 treated l1* `lags', cluster(dyad) l(90)
set seed 1234
setx  (treated) 0 (l1* `lags') median
simqi, pr listx level(90)
setx  (treated) 1 (l1* `lags') median
simqi, pr listx level(90)
simqi, fd(pr) listx changex(treated 0 1) level(90)

** for the table of m values
simqi, fd(pr) listx changex(treated 0 1) level(98)
simqi, fd(pr) listx changex(treated 0 1) level(90)
simqi, fd(pr) listx changex(treated 0 1) level(80)
simqi, fd(pr) listx changex(treated 0 1) level(70)
simqi, fd(pr) listx changex(treated 0 1) level(60)
simqi, fd(pr) listx changex(treated 0 1) level(50)


** cat
use "mahmatches_catbit.dta", clear
xtset dyad
logit bit012345 treated l1*, cluster(dyad) l(90)
logit bit012345 treated l1* `lags', cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_catbit_Ratifiers.dta", clear
xtset dyad
logit bit012345 treated l1*, cluster(dyad) l(90)
logit bit012345 treated l1* `lags', cluster(dyad) l(90)
cd "../results/"
outreg2 using fulltable, word append 2aster 
cd "../madedata/"
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

  ** quantities of interest
estsimp logit bit012345 treated l1* `lags', cluster(dyad) l(90)
set seed 1234
setx  (treated) 0 (l1* `lags') median
simqi, pr listx level(90)
setx  (treated) 1 (l1* `lags') median
simqi, pr listx level(90)
simqi, fd(pr) listx changex(treated 0 1) level(90)

** for the table of m values
simqi, fd(pr) listx changex(treated 0 1) level(98)
simqi, fd(pr) listx changex(treated 0 1) level(90)
simqi, fd(pr) listx changex(treated 0 1) level(80)
simqi, fd(pr) listx changex(treated 0 1) level(70)
simqi, fd(pr) listx changex(treated 0 1) level(60)
simqi, fd(pr) listx changex(treated 0 1) level(50)



** art22
use "mahmatches_art22bit.dta", clear
xtset dyad
** some of the controls predict failure perfectly 
drop l1comcol l1comlang
*logit bit012345 treated l1*, cluster(dyad) l(90)
  ** The model can't converge
*logit bit012345 treated l1* `lags', cluster(dyad) l(90)
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1


use "mahmatches_art22bit_Ratifiers.dta", clear
xtset dyad
tab bit012345 if e(sample)==1
** the full slate of controls is :l1alliance l1bitcount l1coldwar l1comcol l1comlang l1jca_gdp l1jchgdplag2 l1jcl2 l1jcorruption l1jdem l1jextract l1jfdilag l1jgdp l1jgdpcap l1jillit l1jlaworder l1jmsbit l1jpriv l1jrelbit l1jtotemb l1juse_dich l1mjfdi l1physint l1sfdi l1stb l1tradgdp
*local l1controls l1alliance l1bitcount l1jca_gdp l1jchgdplag2 l1jcorruption l1jdem l1jextract l1jfdilag l1jgdp l1jillit l1jlaworder l1jpriv l1jtotemb l1physint l1sfdi l1tradgdp
logit bit012345 treated l1*, cluster(dyad) l(90)
logit bit012345 treated l1* `lags', cluster(dyad) l(90)
cd "../results/"
outreg2 using fulltable, word append 2aster 
cd "../madedata/"
tab treated if e(sample)==1
tab bit012345 if e(sample)==1
tab year if e(sample)==1

  ** quantities of interest
  drop l1comcol
estsimp logit bit012345 treated l1* `lags', cluster(dyad) l(90)
set seed 1234
setx  (treated) 0 (l1* `lags') median
simqi, pr listx level(90)
setx  (treated) 1 (l1* `lags') median
simqi, pr listx level(90)
simqi, fd(pr) listx changex(treated 0 1) level(90)

** for the table of m values
simqi, fd(pr) listx changex(treated 0 1) level(98)
simqi, fd(pr) listx changex(treated 0 1) level(90)
simqi, fd(pr) listx changex(treated 0 1) level(80)
simqi, fd(pr) listx changex(treated 0 1) level(70)
simqi, fd(pr) listx changex(treated 0 1) level(60)
simqi, fd(pr) listx changex(treated 0 1) level(50)

cd "../.."

log close


