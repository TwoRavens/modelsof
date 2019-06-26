set scheme s1color

use SEA_JPR_replication_data, clear

*Note that the figures will only generate if the simqi.ado file is replaced by the modified one that Travis Braidwood has created: http://travisbraidwood.altervista.org/dataverse.html

*Model 1
nbreg sea_mil mil_ratio_max prim_ratio_mil_wtavg mil_size gdppc cohen, cluster(mcode) level(90)

*Model 2
nbreg sea_mil mil_ratio_max labor_fem_mil_wtavg mil_size gdppc cohen, cluster(mcode) level(90)

*Model 3
nbreg sea_mil mil_ratio_max mv1_mil_wtavg mil_size gdppc cohen, cluster(mcode) level(90)

*Model 4
nbreg sea_mil mil_ratio_max prim_ratio_mil_wtavg polity_mil_wtavg  mil_size gdppc cohen, cluster(mcode) level(90)

*Model 5
nbreg sea_mil mil_ratio_max labor_fem_mil_wtavg polity_mil_wtavg  mil_size gdppc cohen, cluster(mcode) level(90)

*Model 6
nbreg sea_mil mil_ratio_max mv1_mil_wtavg polity_mil_wtavg  mil_size gdppc cohen, cluster(mcode) level(90)

*Model 7
nbreg sea_mil mil_ratio_max prim_ratio_mil_wtavg  gdppc_mil_wtavg mil_size gdppc cohen, cluster(mcode) level(90)

*Model 8
nbreg sea_mil mil_ratio_max labor_fem_mil_wtavg gdppc_mil_wtavg mil_size gdppc cohen, cluster(mcode) level(90)

*Model 9
nbreg sea_mil mil_ratio_max mv1_mil_wtavg  gdppc_mil_wtavg mil_size gdppc cohen, cluster(mcode) level(90)

*Model 10
nbreg sea_pol pol_ratio_max prim_ratio_pol_wtavg pol_size gdppc cohen, cluster(mcode) level(90)

* Model 11
nbreg sea_pol pol_ratio_max labor_fem_pol_wtavg pol_size gdppc cohen, cluster(mcode) level(90)

*Model 12
nbreg sea_pol pol_ratio_max mv1_pol_wtavg pol_size gdppc cohen, cluster(mcode) level(90)

*Figure 2		
use SEA_JPR_replication_data, clear
estsimp nbreg sea_mil mil_ratio_max prim_ratio_mil_wtavg mil_size gdppc cohen, cluster(mcode)
preserve
local a =0 
setx mean 
setx mil_ratio_max (`a') mil_size 10000 gdppc 1000
simqi, level(90)
macro list
scalar list 
postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= .1  {
qui simqi , level(90)
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+.005
setx mil_ratio_max (`a') 
display "." _c 
}
display ""
postclose mypost 
use simresults, clear 
sum
gen MV = 0+.005*(_n-1) 
gsort prediction upper lower -MV 
version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
		ytitle("Expected Count of SEA for Military Contingents") xtitle("Proportion of Women in the PKO Military Contingents")	note("Note: p=0.039 in a two-tailed test.") legend(off)	 scheme(s1color)

		

* Figure 3
use SEA_JPR_replication_data, clear
estsimp nbreg sea_pol pol_ratio_max prim_ratio_pol_wtavg pol_size gdppc cohen, cluster(mcode)
preserve
local a =0 
setx mean 
setx pol_ratio_max (`a') gdppc 1000 pol_size 1500
simqi, level(90)
macro list
scalar list 
postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= .25  {
qui simqi , level(90)
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+.01
setx pol_ratio_max (`a') 
display "." _c 
}
display ""
postclose mypost 
use simresults, clear 
sum
gen MV = 0+.01*(_n-1) 
gsort prediction upper lower -MV 
version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
		ytitle("Expected Count of SEA for Police Contingents") xtitle("Proportion of Women in the PKO Police Contingents")	note("Note: p=0.017 in a two-tailed test.") legend(off)	 scheme(s1color)
		
		


*Figure 4
use SEA_JPR_replication_data, clear
estsimp nbreg sea_mil mil_ratio_max prim_ratio_mil_wtavg mil_size gdppc cohen, cluster(mcode)
preserve
local a =70 
setx mean 
setx prim_ratio_mil_wtavg (`a') mil_size 10000 gdppc 1000
simqi, level(90)
macro list
scalar list 
postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= 102  {
qui simqi , level(90)
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+2 
setx prim_ratio_mil_wtavg (`a') 
display "." _c 
}
display ""
postclose mypost 
use simresults, clear 
sum
gen MV = 70+2*(_n-1) 
gsort prediction upper lower -MV 
version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
		ytitle("Expected Count of SEA for Military Contingents") xtitle("Weighted Average of the Contributing Countries' Primary School Female Ratio")	note("Note: p=0.019 in a two-tailed test.")	legend(off) scheme(s1color)



*Figure 5
use SEA_JPR_replication_data, clear
estsimp nbreg sea_mil mil_ratio_max labor_fem_mil_wtavg mil_size gdppc cohen, cluster(mcode)
preserve
local a =40 
setx mean 
setx labor_fem_mil_wtavg (`a') mil_size 10000 gdppc 1000
simqi, level(90)
macro list
scalar list 
postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= 78  {
qui simqi , level(90)
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+2 
setx labor_fem_mil_wtavg (`a') 
display "." _c 
}
display ""
postclose mypost 
use simresults, clear 
sum
gen MV = 40+2*(_n-1) 
gsort prediction upper lower -MV 
version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
		ytitle("Expected Count of SEA for Military Contingents") xtitle("Weighted Average of the Contributing Countries' Female Labor Participation")	note("Note: p=0.023 in a two-tailed test.") legend(off)	 scheme(s1color)



* Figure 6
use SEA_JPR_replication_data, clear
estsimp nbreg sea_mil mil_ratio_max mv1_mil_wtavg mil_size gdppc cohen, cluster(mcode)
preserve
local a =1 
setx mean 
setx mv1_mil_wtavg (`a') mil_size 10000 gdppc 1000
simqi, level(90)
macro list
scalar list 
postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= 4  {
qui simqi , level(90)
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+.2 
setx mv1_mil_wtavg (`a') 
display "." _c 
}
display ""
postclose mypost 
use simresults, clear 
sum
gen MV = 1+.2*(_n-1) 
gsort prediction upper lower -MV 
version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
		ytitle("Expected Count of SEA for Military Contingents") xtitle("Weighted Average of the Contributing Countries' Security Index for Women")	note("Note: p=0.167  in a two-tailed test.") legend(off)	 scheme(s1color)



*Figure 7
use SEA_JPR_replication_data, clear
estsimp nbreg sea_pol pol_ratio_max labor_fem_pol_wtavg pol_size gdppc cohen, cluster(mcode)
preserve
local a =40 
setx mean 
setx labor_fem_pol_wtavg (`a') gdppc 1000 pol_size 1500
simqi, level(90)
macro list
scalar list 
postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= 78  {
qui simqi , level(90)
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+2 
setx labor_fem_pol_wtavg (`a') 
display "." _c 
}
display ""
postclose mypost 
use simresults, clear 
sum
gen MV = 40+2*(_n-1) 
gsort prediction upper lower -MV 
version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(maroon) sort ///
		ytitle("Expected Count of SEA for Police Contingents") xtitle("Weighted Average of the Police Contributing Countries' Female Labor Participation")	note("Note: p=0.003 in a two-tailed test.") legend(off)	 scheme(s1color)


