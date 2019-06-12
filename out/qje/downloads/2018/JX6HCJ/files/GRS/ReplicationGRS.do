
use Crime.dta, clear

*Table 3 - All okay - first stage regressions, not included in analysis
areg sm highnumber if cohort > 1957 & cohort < 1963, robust absorb(cohort)
regress sm highnumber if cohort == 1958, robust
regress sm highnumber if cohort == 1959, robust
regress sm highnumber if cohort == 1960, robust
regress sm highnumber if cohort == 1961, robust
regress sm highnumber if cohort == 1962, robust

*Table 4 - All okay - itts duplicate other regs
areg crimerate highnumber if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate highnumber indigenous naturalized dist* if cohort > 1957 & cohort < 1963, robust absorb(cohort)
xi: ivreg crimerate (sm = highnumber) i.cohort if cohort > 1957 & cohort < 1963, robust 
xi: ivreg crimerate (sm = highnumber) indigenous naturalized dist* i.cohort if cohort > 1957 & cohort < 1963, robust 
areg crimerate highnumber if cohort > 1928 & cohort < 1966, robust absorb(cohort)
areg crimerate highnumber if cohort > 1928 & cohort < 1957, robust absorb(cohort)
areg crimerate highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)

*Table 5 - All okay
gen hnmalvinas = highnumber*malvinas
areg crimerate highnumber hnmalvinas if cohort > 1928 & cohort < 1966, absorb(cohort) robust
areg crimerate highnumber hnmalvinas if cohort > 1956 & cohort < 1966, absorb(cohort) robust
areg crimerate highnumber navy if cohort > 1928 & cohort < 1966, absorb(cohort) robust
areg crimerate highnumber navy if cohort > 1956 & cohort < 1966, absorb(cohort) robust

*Table 6 - All okay
xi: ivreg arms (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg property (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg sexual (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg murder (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg threat (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg drug (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg whitecollar (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 

*Table 7 - All okay - itts duplicate other regs
areg formal highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
xi: ivreg formal (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
areg formal highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
areg unemployment highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
xi: ivreg unemployment (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
areg unemployment highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
areg income highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
xi: ivreg income (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
areg income highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)


use Crime.dta, clear
tab cohort if cohort > 1957 & cohort < 1963, gen(COHORT)
gen hnmalvinas = highnumber*malvinas

*Table 4 
foreach specification in " " "indigenous naturalized dist*" {
	areg crimerate highnumber `specification' if cohort > 1957 & cohort < 1963, robust absorb(cohort)
	}

foreach specification in "cohort > 1928 & cohort < 1966" "cohort > 1928 & cohort < 1957" "cohort > 1956 & cohort < 1966" {
	areg crimerate highnumber if `specification', robust absorb(cohort)
	}


*Table 5 
foreach specification in "hnmalvinas" "navy" {
	foreach period in "cohort > 1928 & cohort < 1966" "cohort > 1956 & cohort < 1966" {
		areg crimerate highnumber `specification' if `period', absorb(cohort) robust
		}
	}

*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
foreach var in arms property sexual murder threat drug whitecollar {
	ivreg `var' (sm = highnumber) COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
foreach var in arms property sexual murder threat drug whitecollar {
	reg `var' highnumber COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

*Table 7
foreach var in formal unemployment income {
	areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
	}

save DatGRS, replace



