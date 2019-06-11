cd "~/Research/Veto Overrides/Data/"
set more off
set mem 100m
use housedata, clear
replace coord1 = -coord1 if pres == 0
by congress: egen vetoplayer = pctile(coord1), p(67)
gen vetodist = coord1 - vetoplayer
gen err = 0
gen vetodist_realized = vetodist

program define votesim, rclass
	syntax [if]
	marksample touse
	replace err = rnormal(0, se1) if `touse'
	replace vetodist_realized = vetodist + err if `touse'
	_pctile vetodist_realized if `touse', percentiles(67)
	local vetoplayer_realized = r(r1)
	return scalar v = `vetoplayer_realized'
end

foreach c of numlist 93/110 {
	preserve
	simulate vetoP=r(v), reps(10000) saving(vetosimDataHouse`c', replace): votesim if congress == `c'
	restore
}

foreach c of numlist 93/110 {
	
	quietly use vetosimDataHouse`c', clear
	quietly gen veto = (vetoP > 0)
	quietly summ
	display as text "House `c':      " 1 - r(mean)
}
