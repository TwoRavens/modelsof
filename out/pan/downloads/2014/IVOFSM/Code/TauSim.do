cd "~/Research/Veto Overrides/Data/"
set more off

* House Data
#delimit ;
infix 	int congress 1-4 
		icpsr 6-10 
		statecode 12-13 
		district 14-15 
		str statename 16-23 
		partycode 25-28 
		str name 30-40 
		coord1 41-46 
		coord2 48-53 
		se1 55-60 
		se2 62-67 
		using "Legislator Estimates House 1-110.DAT", clear;
#delimit cr 
*** drop the president ***
drop if strmatch(statename, "USA")

*** President variable: 1 if republican, 0 if democrat ***
gen pres = 0
*Nixon/Ford
replace pres = 1 if (congress >= 93) & (congress <= 94)
*Reagan / Bush I
replace pres = 1 if (congress >= 97) & (congress <= 102)
* Bush II
replace pres = 1 if (congress >= 107) 
keep if congress >= 93

*** compute median player ***
bysort congress: egen mplayer = pctile(coord1), p(50)

gen draw = 0
save housedata, replace

* Senate Data
#delimit ;
infix 	int congress 1-4 
		icpsr 6-10 
		statecode 12-13 
		district 14-15 
		str statename 16-23 
		partycode 25-28 
		str name 30-40 
		coord1 41-46 
		coord2 48-53 
		se1 55-60 
		se2 62-67 
		using "Legislator Estimates Senate 1-110.DAT", clear;
#delimit cr 
*** drop the president ***
drop if strmatch(statename, "USA")
*** President variable: 1 if republican, 0 if democrat ***
gen pres = 0
*Nixon/Ford
replace pres = 1 if (congress >= 93) & (congress <= 94)
*Reagan / Bush I
replace pres = 1 if (congress >= 97) & (congress <= 102)
* Bush II
replace pres = 1 if (congress >= 107) 
keep if congress >= 93

*** compute median player ***
bysort congress: egen mplayer = pctile(coord1), p(50)

gen draw = 0
save senatedata, replace



/* Simulation Program */
program drop _all
program define vetoplayersim, rclass
	replace draw = rnormal(coord1, se1)
	bysort congress: egen vplayer1 = pctile(draw), p(33.33)
	bysort congress: egen vplayer2 = pctile(draw), p(66.66)
	gen vplayer = vplayer1 if pres == 0
	replace vplayer = vplayer2 if pres == 1
	replace vplayer = abs(vplayer - mplayer)
	foreach c of numlist 93/110 {
		summ vplayer if congress == `c'
		return scalar vplayer_`c'=r(mean)
	}
	drop vplayer vplayer1 vplayer2
end


/* Run House simulations */
use housedata, clear
# delimit ;
simulate   vplayer_93=r(vplayer_93) 
		vplayer_94=r(vplayer_94) 
		vplayer_95=r(vplayer_95)
		vplayer_96=r(vplayer_96)
		vplayer_97=r(vplayer_97)
		vplayer_98=r(vplayer_98)
		vplayer_99=r(vplayer_99)
		vplayer_100=r(vplayer_100)
		vplayer_101=r(vplayer_101)
		vplayer_102=r(vplayer_102)
		vplayer_103=r(vplayer_103)
		vplayer_104=r(vplayer_104)
		vplayer_105=r(vplayer_105)
		vplayer_106=r(vplayer_106)
		vplayer_107=r(vplayer_107)
		vplayer_108=r(vplayer_108)
		vplayer_109=r(vplayer_109)
		vplayer_110=r(vplayer_110), 
		reps(10000) saving(housesims, replace): vetoplayersim;
#delimit cr

use housesims, clear
collapse (p95) vplayer_93-vplayer_110
xpose, clear
rename v1 tau_up_h
gen congress = 92 + _n
order congress tau_up_h
save house_tau_up, replace

/* Run Senate simulations */
use senatedata, clear
# delimit ;
simulate   vplayer_93=r(vplayer_93) 
		vplayer_94=r(vplayer_94) 
		vplayer_95=r(vplayer_95)
		vplayer_96=r(vplayer_96)
		vplayer_97=r(vplayer_97)
		vplayer_98=r(vplayer_98)
		vplayer_99=r(vplayer_99)
		vplayer_100=r(vplayer_100)
		vplayer_101=r(vplayer_101)
		vplayer_102=r(vplayer_102)
		vplayer_103=r(vplayer_103)
		vplayer_104=r(vplayer_104)
		vplayer_105=r(vplayer_105)
		vplayer_106=r(vplayer_106)
		vplayer_107=r(vplayer_107)
		vplayer_108=r(vplayer_108)
		vplayer_109=r(vplayer_109)
		vplayer_110=r(vplayer_110), 
		reps(10000) saving(senatesims, replace): vetoplayersim;
#delimit cr

use senatesims, clear
collapse (p95) vplayer_93-vplayer_110
xpose, clear
rename v1 tau_up_s
gen congress = 92 + _n
order congress tau_up_s
save senate_tau_up, replace

/* Merge with veto data, probit */
insheet using "veto data.csv", clear
merge congress using house_tau_up, sort uniqusing nokeep
drop _merge
merge congress using senate_tau_up, sort uniqusing nokeep
drop _merge

gen tau_up = max(tau_up_h, tau_up_s)
dprobit overridden tau_up
estimates store dprobit
esttab dprobit using probittable.tex, replace nostar title("Probit Estimates of Marginal Effect of Tau on Probability of Override")


