***********
* Table 7 *
***********

* use data and generate followers' mean adjusted quantities

use "Prepared data"

generate opnumsec = 11 if numfirst == 3
replace opnumsec = 10 if numfirst == 4
replace opnumsec = 10 if numfirst == 5
replace opnumsec = 9 if numfirst == 6
replace opnumsec = 8 if numfirst == 7
replace opnumsec = 8 if numfirst == 8
replace opnumsec = 8 if numfirst == 9
replace opnumsec = 7 if numfirst == 10
replace opnumsec = 7 if numfirst == 11
replace opnumsec = 6 if numfirst == 12
replace opnumsec = 6 if numfirst == 13
replace opnumsec = 5 if numfirst == 14
replace opnumsec = 5 if numfirst == 15
label variable opnumsec "second mover's optimal number"

generate adnumsec = abs(numsec - opnumsec)
label variable adnumsec "second mover's adjusted number (if 0 = optimal number/best response)"

* generate treatment dummy variables

tabulate treatment, generate(treatment)
label variable treatment4 "stackrand"
label variable treatment2 "loaded"
label variable treatment1 "neutral"
label variable treatment3 "team"

* generate round dummy variables

tabulate round, generate(round)

* generate leader dummy variables

tabulate idfirst if treatment == 4, generate(sleader)
tabulate idfirst if treatment == 2, generate(lleader)
tabulate idfirst if treatment == 1, generate(nleader)
tabulate idfirst if treatment == 3, generate(tleader)

replace sleader1 = 0 if sleader1 == .
replace sleader2 = 0 if sleader2 == .
replace sleader3 = 0 if sleader3 == .
replace sleader4 = 0 if sleader4 == .
replace sleader5 = 0 if sleader5 == .
replace sleader6 = 0 if sleader6 == .
replace sleader7 = 0 if sleader7 == .
replace sleader8 = 0 if sleader8 == .
replace sleader9 = 0 if sleader9 == .
replace sleader10 = 0 if sleader10 == .
replace sleader11 = 0 if sleader11 == .
replace sleader12 = 0 if sleader12 == .
replace sleader13 = 0 if sleader13 == .
replace sleader14 = 0 if sleader14 == .
replace sleader15 = 0 if sleader15 == .
replace sleader16 = 0 if sleader16 == .
replace sleader17 = 0 if sleader17 == .
replace sleader18 = 0 if sleader18 == .
replace sleader19 = 0 if sleader19 == .
replace sleader20 = 0 if sleader20 == .
replace sleader21 = 0 if sleader21 == .
replace sleader22 = 0 if sleader22 == .

replace lleader1 = 0 if lleader1 == .
replace lleader2 = 0 if lleader2 == .
replace lleader3 = 0 if lleader3 == .
replace lleader4 = 0 if lleader4 == .
replace lleader5 = 0 if lleader5 == .
replace lleader6 = 0 if lleader6 == .
replace lleader7 = 0 if lleader7 == .
replace lleader8 = 0 if lleader8 == .
replace lleader9 = 0 if lleader9 == .
replace lleader10 = 0 if lleader10 == .
replace lleader11 = 0 if lleader11 == .
replace lleader12 = 0 if lleader12 == .
replace lleader13 = 0 if lleader13 == .
replace lleader14 = 0 if lleader14 == .

replace nleader1 = 0 if nleader1 == .
replace nleader2 = 0 if nleader2 == .
replace nleader3 = 0 if nleader3 == .
replace nleader4 = 0 if nleader4 == .
replace nleader5 = 0 if nleader5 == .
replace nleader6 = 0 if nleader6 == .
replace nleader7 = 0 if nleader7 == .
replace nleader8 = 0 if nleader8 == .
replace nleader9 = 0 if nleader9 == .
replace nleader10 = 0 if nleader10 == .
replace nleader11 = 0 if nleader11 == .
replace nleader12 = 0 if nleader12 == .
replace nleader13 = 0 if nleader13 == .
replace nleader14 = 0 if nleader14 == .
replace nleader15 = 0 if nleader15 == .
replace nleader16 = 0 if nleader16 == .
replace nleader17 = 0 if nleader17 == .
replace nleader18 = 0 if nleader18 == .
replace nleader19 = 0 if nleader19 == .
replace nleader20 = 0 if nleader20 == .
replace nleader21 = 0 if nleader21 == .

replace tleader1 = 0 if tleader1 == .
replace tleader2 = 0 if tleader2 == .
replace tleader3 = 0 if tleader3 == .
replace tleader4 = 0 if tleader4 == .
replace tleader5 = 0 if tleader5 == .
replace tleader6 = 0 if tleader6 == .
replace tleader7 = 0 if tleader7 == .
replace tleader8 = 0 if tleader8 == .
replace tleader9 = 0 if tleader9 == .
replace tleader10 = 0 if tleader10 == .
replace tleader11 = 0 if tleader11 == .
replace tleader12 = 0 if tleader12 == .

* generate follower dummy variables

tabulate idsec if treatment == 4, generate(sfollower)
tabulate idsec if treatment == 2, generate(lfollower)
tabulate idsec if treatment == 1, generate(nfollower)
tabulate idsec if treatment == 3, generate(tfollower)

replace sfollower1 = 0 if sfollower1 == .
replace sfollower2 = 0 if sfollower2 == .
replace sfollower3 = 0 if sfollower3 == .
replace sfollower4 = 0 if sfollower4 == .
replace sfollower5 = 0 if sfollower5 == .
replace sfollower6 = 0 if sfollower6 == .
replace sfollower7 = 0 if sfollower7 == .
replace sfollower8 = 0 if sfollower8 == .
replace sfollower9 = 0 if sfollower9 == .
replace sfollower10 = 0 if sfollower10 == .
replace sfollower11 = 0 if sfollower11 == .
replace sfollower12 = 0 if sfollower12 == .
replace sfollower13 = 0 if sfollower13 == .
replace sfollower14 = 0 if sfollower14 == .
replace sfollower15 = 0 if sfollower15 == .
replace sfollower16 = 0 if sfollower16 == .
replace sfollower17 = 0 if sfollower17 == .
replace sfollower18 = 0 if sfollower18 == .
replace sfollower19 = 0 if sfollower19 == .
replace sfollower20 = 0 if sfollower20 == .
replace sfollower21 = 0 if sfollower21 == .
replace sfollower22 = 0 if sfollower22 == .

replace lfollower1 = 0 if lfollower1 == .
replace lfollower2 = 0 if lfollower2 == .
replace lfollower3 = 0 if lfollower3 == .
replace lfollower4 = 0 if lfollower4 == .
replace lfollower5 = 0 if lfollower5 == .
replace lfollower6 = 0 if lfollower6 == .
replace lfollower7 = 0 if lfollower7 == .
replace lfollower8 = 0 if lfollower8 == .
replace lfollower9 = 0 if lfollower9 == .
replace lfollower10 = 0 if lfollower10 == .
replace lfollower11 = 0 if lfollower11 == .
replace lfollower12 = 0 if lfollower12 == .

replace nfollower1 = 0 if nfollower1 == .
replace nfollower2 = 0 if nfollower2 == .
replace nfollower3 = 0 if nfollower3 == .
replace nfollower4 = 0 if nfollower4 == .
replace nfollower5 = 0 if nfollower5 == .
replace nfollower6 = 0 if nfollower6 == .
replace nfollower7 = 0 if nfollower7 == .
replace nfollower8 = 0 if nfollower8 == .
replace nfollower9 = 0 if nfollower9 == .
replace nfollower10 = 0 if nfollower10 == .
replace nfollower11 = 0 if nfollower11 == .
replace nfollower12 = 0 if nfollower12 == .
replace nfollower13 = 0 if nfollower13 == .
replace nfollower14 = 0 if nfollower14 == .
replace nfollower15 = 0 if nfollower15 == .
replace nfollower16 = 0 if nfollower16 == .
replace nfollower17 = 0 if nfollower17 == .
replace nfollower18 = 0 if nfollower18 == .
replace nfollower19 = 0 if nfollower19 == .
replace nfollower20 = 0 if nfollower20 == .
replace nfollower21 = 0 if nfollower21 == .
replace nfollower22 = 0 if nfollower22 == .

replace tfollower1 = 0 if tfollower1 == .
replace tfollower2 = 0 if tfollower2 == .
replace tfollower3 = 0 if tfollower3 == .
replace tfollower4 = 0 if tfollower4 == .
replace tfollower5 = 0 if tfollower5 == .
replace tfollower6 = 0 if tfollower6 == .
replace tfollower7 = 0 if tfollower7 == .
replace tfollower8 = 0 if tfollower8 == .
replace tfollower9 = 0 if tfollower9 == .
replace tfollower10 = 0 if tfollower10 == .
replace tfollower11 = 0 if tfollower11 == .
replace tfollower12 = 0 if tfollower12 == .

* save data

save "Prepared dvr data", replace
clear

* Dummy variable regression for leaders' quantities: LOADED - TEAM

use "Prepared dvr data"

drop if treatment == 4
drop if treatment == 1

constraint 1 round1 + round2 + round3 + round4 + round5 + round6 + round7 + round8 + round9 + round10 = 0
constraint 2 lleader1 + lleader2 + lleader3 + lleader4 + lleader5 + lleader6 + lleader7 + lleader8 + lleader9 + lleader10 + lleader11 + lleader12 + lleader13 + lleader14 = 0
constraint 3 tleader1 + tleader2 + tleader3 + tleader4 + tleader5 + tleader6 + tleader7 + tleader8 + tleader9 + tleader10 + tleader11 + tleader12 = 0
cnsreg numfirst treatment3 round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 lleader1 lleader2 lleader3 lleader4 lleader5 lleader6 lleader7 lleader8 lleader9 lleader10 lleader11 lleader12 lleader13 lleader14 tleader1 tleader2 tleader3 tleader4 tleader5 tleader6 tleader7 tleader8 tleader9 tleader10 tleader11 tleader12, constraints(1-3)

test _cons == 12

predict r, residuals
kdensity r, normal
sktest r

clear

* Dummy variable regression for followers' adjusted quantities: LOADED - TEAM

use "Prepared dvr data"

drop if treatment == 4
drop if treatment == 1

constraint 1 round1 + round2 + round3 + round4 + round5 + round6 + round7 + round8 + round9 + round10 = 0
constraint 2 lfollower1 + lfollower2 + lfollower3 + lfollower4 + lfollower5 + lfollower6 + lfollower7 + lfollower8 + lfollower9 + lfollower10 + lfollower11 + lfollower12 = 0
constraint 3 tfollower1 + tfollower2 + tfollower3 + tfollower4 + tfollower5 + tfollower6 + tfollower7 + tfollower8 + tfollower9 + tfollower10 + tfollower11 + tfollower12 = 0
cnsreg adnumsec treatment3 round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 lfollower1 lfollower2 lfollower3 lfollower4 lfollower5 lfollower6 lfollower7 lfollower8 lfollower9 lfollower10 lfollower11 lfollower12 tfollower1 tfollower2 tfollower3 tfollower4 tfollower5 tfollower6 tfollower7 tfollower8 tfollower9 tfollower10 tfollower11 tfollower12, constraints(1-3)

predict r, residuals
kdensity r, normal
sktest r

clear

* Dummy variable regression for leaders' quantities: NEUTRAL - TEAM

use "Prepared dvr data"

drop if treatment == 4
drop if treatment == 2

constraint 1 round1 + round2 + round3 + round4 + round5 + round6 + round7 + round8 + round9 + round10 = 0
constraint 2 nleader1 + nleader2 + nleader3 + nleader4 + nleader5 + nleader6 + nleader7 + nleader8 + nleader9 + nleader10 + nleader11 + nleader12 + nleader13 + nleader14 + nleader15 + nleader16 + nleader17 + nleader18 + nleader19 + nleader20 + nleader21 = 0
constraint 3 tleader1 + tleader2 + tleader3 + tleader4 + tleader5 + tleader6 + tleader7 + tleader8 + tleader9 + tleader10 + tleader11 + tleader12 = 0
cnsreg numfirst treatment3 round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 nleader1 nleader2 nleader3 nleader4 nleader5 nleader6 nleader7 nleader8 nleader9 nleader10 nleader11 nleader12 nleader13 nleader14 nleader15 nleader16 nleader17 nleader18 nleader19 nleader20 nleader21 tleader1 tleader2 tleader3 tleader4 tleader5 tleader6 tleader7 tleader8 tleader9 tleader10 tleader11 tleader12, constraints(1-3)

test _cons == 12

predict r, residuals
kdensity r, normal
sktest r

clear

* Dummy variable regression for followers' adjusted quantities: NEUTRAL - TEAM

use "Prepared dvr data"

drop if treatment == 4
drop if treatment == 2

constraint 1 round1 + round2 + round3 + round4 + round5 + round6 + round7 + round8 + round9 + round10 = 0
constraint 2 nfollower1 + nfollower2 + nfollower3 + nfollower4 + nfollower5 + nfollower6 + nfollower7 + nfollower8 + nfollower9 + nfollower10 + nfollower11 + nfollower12 + nfollower13 + nfollower14 + nfollower15 + nfollower16 + nfollower17 + nfollower18 + nfollower19 + nfollower20 + nfollower21 + nfollower22 = 0
constraint 3 tfollower1 + tfollower2 + tfollower3 + tfollower4 + tfollower5 + tfollower6 + tfollower7 + tfollower8 + tfollower9 + tfollower10 + tfollower11 + tfollower12 = 0
cnsreg adnumsec treatment3 round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 nfollower1 nfollower2 nfollower3 nfollower4 nfollower5 nfollower6 nfollower7 nfollower8 nfollower9 nfollower10 nfollower11 nfollower12 nfollower13 nfollower14 nfollower15 nfollower16 nfollower17 nfollower18 nfollower19 nfollower20 nfollower21 nfollower22 tfollower1 tfollower2 tfollower3 tfollower4 tfollower5 tfollower6 tfollower7 tfollower8 tfollower9 tfollower10 tfollower11 tfollower12, constraints(1-3)

predict r, residuals
kdensity r, normal
sktest r

* clear data

clear
