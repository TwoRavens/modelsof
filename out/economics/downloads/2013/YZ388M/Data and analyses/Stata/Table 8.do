***********
* Table 8 *
***********

* use data

use "Prepared data"

* generate intercept round dummy variables

tabulate round, generate(round)

* generate follower intercept dummy variables

tabulate idsec if treatment == 2, generate(lfollower)
tabulate idsec if treatment == 1, generate(nfollower)
tabulate idsec if treatment == 3, generate(tfollower)

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

* generate round slope dummy variables

generate round1nf = round1*numfirst
generate round2nf = round2*numfirst
generate round3nf = round3*numfirst
generate round4nf = round4*numfirst
generate round5nf = round5*numfirst
generate round6nf = round6*numfirst
generate round7nf = round7*numfirst
generate round8nf = round8*numfirst
generate round9nf = round9*numfirst
generate round10nf = round10*numfirst

* generate follower slope dummy variables

generate lfollower1nf = lfollower1*numfirst
generate lfollower2nf = lfollower2*numfirst
generate lfollower3nf = lfollower3*numfirst
generate lfollower4nf = lfollower4*numfirst
generate lfollower5nf = lfollower5*numfirst
generate lfollower6nf = lfollower6*numfirst
generate lfollower7nf = lfollower7*numfirst
generate lfollower8nf = lfollower8*numfirst
generate lfollower9nf = lfollower9*numfirst
generate lfollower10nf = lfollower10*numfirst
generate lfollower11nf = lfollower11*numfirst
generate lfollower12nf = lfollower12*numfirst

generate nfollower1nf = nfollower1*numfirst
generate nfollower2nf = nfollower2*numfirst
generate nfollower3nf = nfollower3*numfirst
generate nfollower4nf = nfollower4*numfirst
generate nfollower5nf = nfollower5*numfirst
generate nfollower6nf = nfollower6*numfirst
generate nfollower7nf = nfollower7*numfirst
generate nfollower8nf = nfollower8*numfirst
generate nfollower9nf = nfollower9*numfirst
generate nfollower10nf = nfollower10*numfirst
generate nfollower11nf = nfollower11*numfirst
generate nfollower12nf = nfollower12*numfirst
generate nfollower13nf = nfollower13*numfirst
generate nfollower14nf = nfollower14*numfirst
generate nfollower15nf = nfollower15*numfirst
generate nfollower16nf = nfollower16*numfirst
generate nfollower17nf = nfollower17*numfirst
generate nfollower18nf = nfollower18*numfirst
generate nfollower19nf = nfollower19*numfirst
generate nfollower20nf = nfollower20*numfirst
generate nfollower21nf = nfollower21*numfirst
generate nfollower22nf = nfollower22*numfirst

generate tfollower1nf = tfollower1*numfirst
generate tfollower2nf = tfollower2*numfirst
generate tfollower3nf = tfollower3*numfirst
generate tfollower4nf = tfollower4*numfirst
generate tfollower5nf = tfollower5*numfirst
generate tfollower6nf = tfollower6*numfirst
generate tfollower7nf = tfollower7*numfirst
generate tfollower8nf = tfollower8*numfirst
generate tfollower9nf = tfollower9*numfirst
generate tfollower10nf = tfollower10*numfirst
generate tfollower11nf = tfollower11*numfirst
generate tfollower12nf = tfollower12*numfirst

* Dummy variable regression for LOADED

constraint 1 round1 + round2 + round3 + round4 + round5 + round6 + round7 + round8 + round9 + round10 = 0
constraint 2 lfollower1 + lfollower2 + lfollower3 + lfollower4 + lfollower5 + lfollower6 + lfollower7 + lfollower8 + lfollower9 + lfollower10 + lfollower11 + lfollower12 = 0
constraint 3 round1nf + round2nf + round3nf + round4nf + round5nf + round6nf + round7nf + round8nf + round9nf + round10nf = 0
constraint 4 lfollower1nf + lfollower2nf + lfollower3nf + lfollower4nf + lfollower5nf + lfollower6nf + lfollower7nf + lfollower8nf + lfollower9nf + lfollower10nf + lfollower11nf + lfollower12nf = 0
cnsreg numsec numfirst round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 lfollower1 lfollower2 lfollower3 lfollower4 lfollower5 lfollower6 lfollower7 lfollower8 lfollower9 lfollower10 lfollower11 lfollower12 round1nf round2nf round3nf round4nf round5nf round6nf round7nf round8nf round9nf round10nf lfollower1nf lfollower2nf lfollower3nf lfollower4nf lfollower5nf lfollower6nf lfollower7nf lfollower8nf lfollower9nf lfollower10nf lfollower11nf lfollower12nf if treatment==2, constraint(1-4)

test _cons == 12.09
test numfirst == 0.49

predict r, residuals
kdensity r, normal
sktest r

* Dummy variable regression for NEUTRAL

constraint 1 round1 + round2 + round3 + round4 + round5 + round6 + round7 + round8 + round9 + round10 = 0
constraint 2 nfollower1 + nfollower2 + nfollower3 + nfollower4 + nfollower5 + nfollower6 + nfollower7 + nfollower8 + nfollower9 + nfollower10 + nfollower11 + nfollower12 + nfollower13 + nfollower14 + nfollower15 + nfollower16 + nfollower17 + nfollower18 + nfollower19 + nfollower20 + nfollower21 + nfollower22 = 0
constraint 3 round1nf + round2nf + round3nf + round4nf + round5nf + round6nf + round7nf + round8nf + round9nf + round10nf = 0
constraint 4 nfollower1nf + nfollower2nf + nfollower3nf + nfollower4nf + nfollower5nf + nfollower6nf + nfollower7nf + nfollower8nf + nfollower9nf + nfollower10nf + nfollower11nf + nfollower12nf + nfollower13nf + nfollower14nf + nfollower15nf + nfollower16nf + nfollower17nf + nfollower18nf + nfollower19nf + nfollower20nf + nfollower21nf + nfollower22nf = 0
cnsreg numsec numfirst round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 nfollower1 nfollower2 nfollower3 nfollower4 nfollower5 nfollower6 nfollower7 nfollower8 nfollower9 nfollower10 nfollower11 nfollower12 nfollower13 nfollower14 nfollower15 nfollower16 nfollower17 nfollower18 nfollower19 nfollower20 nfollower21 nfollower22 round1nf round2nf round3nf round4nf round5nf round6nf round7nf round8nf round9nf round10nf nfollower1nf nfollower2nf nfollower3nf nfollower4nf nfollower5nf nfollower6nf nfollower7nf nfollower8nf nfollower9nf nfollower10nf nfollower11nf nfollower12nf nfollower13nf nfollower14nf nfollower15nf nfollower16nf nfollower17nf nfollower18nf nfollower19nf nfollower20nf nfollower21nf nfollower22nf if treatment==1, constraint(1-4)

test _cons == 12.09
test numfirst == 0.49

predict rr, residuals
kdensity rr, normal
sktest rr

* Dummy variable regression for TEAM

constraint 1 round1 + round2 + round3 + round4 + round5 + round6 + round7 + round8 + round9 + round10 = 0
constraint 2 tfollower1 + tfollower2 + tfollower3 + tfollower4 + tfollower5 + tfollower6 + tfollower7 + tfollower8 + tfollower9 + tfollower10 + tfollower11 + tfollower12 = 0
constraint 3 round1nf + round2nf + round3nf + round4nf + round5nf + round6nf + round7nf + round8nf + round9nf + round10nf = 0
constraint 4 tfollower1nf + tfollower2nf + tfollower3nf + tfollower4nf + tfollower5nf + tfollower6nf + tfollower7nf + tfollower8nf + tfollower9nf + tfollower10nf + tfollower11nf + tfollower12nf = 0
cnsreg numsec numfirst round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 tfollower1 tfollower2 tfollower3 tfollower4 tfollower5 tfollower6 tfollower7 tfollower8 tfollower9 tfollower10 tfollower11 tfollower12 round1nf round2nf round3nf round4nf round5nf round6nf round7nf round8nf round9nf round10nf tfollower1nf tfollower2nf tfollower3nf tfollower4nf tfollower5nf tfollower6nf tfollower7nf tfollower8nf tfollower9nf tfollower10nf tfollower11nf tfollower12nf if treatment==3, constraint(1-4)

test _cons == 12.09
test numfirst == 0.49

predict rrr, residuals
kdensity rrr, normal
sktest rrr

* clear data

clear
