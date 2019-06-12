global cluster = ""

use DatMMW2, clear

global i = 1
global j = 1

*Table 2 
mycmd (treat1 treat2 treat3 treat4) reg tookup treat1 treat2 treat3 treat4, robust
mycmd (treat1 treat2 treat3 treat4) areg tookup treat1 treat2 treat3 treat4, robust absorb(strata)

*Table 3
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust

