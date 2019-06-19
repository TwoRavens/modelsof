clear all

// create variables for individual unemployment history for each sub-table
//////////////////////////////////////////////////////////////////////////

foreach year of numlist 2006 2007{
foreach qqq of numlist 1(1)4{
foreach hhh of numlist 1 2{

use data/fna`year'_q`qqq'_h`hhh'_small

gen y0 = year(datedeb)
gen inS = (y0 == 2002) + (y0 == 2004)

// number each individual's unemployment spell during the period of interest (inflow 2002 and 2004)
bys indiv inddtns inS (datedeb): gen ns = _n
replace ns = 0 if inS == 0

// period y0-2,y0
/////////////////

// we create the following variables:
// - nus2: number of unemployment spells during the two year period before the start of the current unemployment spell
// - duru2: time spent unemployed over the last two years
// - durZ2: time spent training over the last two years
// - pZ2: proportion of unemployment spells with training among those overlaping the last two years
// - durpreZ2: average duration between start of unemployment spell and start of first training, over the last two years CONDITIONALLY on pZ2 > 0

gen nus2 = .
gen duru2 = .
gen durZ2 = .
gen pZ2 = .
gen durpreZ2 = .

// we create these variable for each unemployment spell starting in 2002 or 2004
su ns
local nsmax = r(max)
foreach nn of numlist 1(1)`nsmax'{
	gen nsnn = (ns == `nn')
	// start and end dates of the two year period before the start of the unemployment spell nn
	bys indiv inddtns (nsnn): gen ddns = datedeb[_N]
	bys indiv inddtns (nsnn): gen dd2 = datedeb[_N] - 365 * 2
	format %d ddns dd2
	// identify which spells were on-going during this period and censor their starting date
	gen inSns2 = (datedeb < ddns) * (datefin > dd2)
	gen datedeb_ns = max(datedeb,dd2) if inSns2 == 1
	// number of unemployment spells in the two year period before the start of the unemployment spell nn
	bys indiv inddtns inSns2: gen nus2_ns = _N if inSns2 == 1
	// time spent unemployed during the last two years
	bys indiv inddtns inSns2: egen duru2_ns = sum(datefin - datedeb_ns)
	replace duru2_ns = . if inSns2 == 0
	// time spent training over the last two years (at most four training spells per unemployment spell)
	gen dZ2 = 0
	foreach nz of numlist 1(1)4{
		gen inSns2z = inSns2 * (dtdebfor`nz' < dtfinfor`nz') * (dtfinfor`nz' > dd2)
		gen dtdebfor_ns = max(dtdebfor`nz',dd2)
		replace dZ2 = dZ2 + (dtfinfor`nz' - dtdebfor_ns) * inSns2z
		drop inSns2z dtdebfor_ns
	}
	bys indiv inddtns inSns2: egen durZ2_ns = sum(dZ2)
	replace durZ2_ns = . if inSns2 == 0
	// proportion of unemployment spells with training among those overlaping the last two years
	gen inSz = inSns2 * (dtdebfor1 < dtfinfor1)
	bys indiv inddtns inSns2: egen pZ2_ns = mean(inSz)
	replace pZ2_ns = . if inSns2 == 0
	// average duration between start of unemployment spell and start of first training over the last two years
	gen dpreZ2 = (dtdebfor1 - datedeb) if inSz == 1
	bys indiv inddtns inSz: egen durpreZ2_ns = mean(dpreZ2)
	replace durpreZ2_ns = . if inSz == 0
	// update variables of interest
	foreach vv of varlist nus2 duru2 durZ2 pZ2 durpreZ2{
		bys indiv inddtns (`vv'_ns): replace `vv'_ns = `vv'_ns[1]
		replace `vv' = `vv'_ns if nsnn == 1
		replace `vv' = 0 if `vv' == . & nsnn == 1
	}
	drop nsnn ddns dd2 inSns2 dZ2 inSz dpreZ2 *_ns
}

// period between y0 - 7 and y0-2
/////////////////////////////////

// we create the following variables:
// - nus72: number of unemployment spells that started between y0-7 and y0 - 2 and ended before y0-2
// - duru72: time spent unemployed between y0 - 7 and y0 - 2
// - durZ72: time spent training between y0 - 7 and y0 - 2
// - pZ72: proportion of unemployment spells with training among those that started between y0-7 and y0 - 2 and ended before y0-2
// - durpreZ72: average duration between start of unemployment spell and start of first training CONDITIONALLY on pZ72 > 0

gen nus72 = .
gen duru72 = .
gen durZ72 = .
gen pZ72 = .
gen durpreZ72 = .

// we create these variable for each unemployment spell starting in 2002 or 2004
su ns
local nsmax = r(max)

foreach nn of numlist 1(1)`nsmax'{
	gen nsnn = (ns == `nn')
	// define , y0 - 7 and y0 - 2 for the unemployment spell nn
	bys indiv inddtns (nsnn): gen dd2 = mdy(month(datedeb[_N]),day(datedeb[_N]),year(datedeb[_N]) - 2)
	bys indiv inddtns (nsnn): gen dd7 = mdy(month(datedeb[_N]),day(datedeb[_N]),year(datedeb[_N]) - 7)
	format %d dd2 dd7
	// identify which spells started durin [y0 - 7, y0 - 2] and either ended before y0 - 2 or are censored at y0 - 2
	gen inSns72end = (datefin > dd7) * (datefin <= dd2)
	gen inSns72cs = (datedeb < dd2) * (datefin > dd2)
	gen inSns72 = inSns72end + inSns72cs
	gen datedeb_ns = max(datedeb,dd7) if inSns72 == 1
	gen datefin_ns = min(datefin,dd2) if inSns72 == 1
	// number of unemployment spells that ended between y0 - 7 and y0 - 2
	bys indiv inddtns inSns72: egen nus72_ns = sum(inSns72end)
	replace nus72_ns = . if inSns72 == 0
	// time spent unemployed between y0 - 7 and y0 - 2
	bys indiv inddtns inSns72: egen duru72_ns = sum(datefin_ns - datedeb_ns)
	replace duru72_ns = . if inSns72 == 0
	// time spent training between y0- 7 and y0 - 2(at most four training spells per unemployment spell)
	gen dZ72 = 0
	foreach nz of numlist 1(1)4{
		gen inSns72z = inSns72 * (dtdebfor`nz' < dtfinfor`nz') * (dtfinfor`nz' > dd7) * (dtdebfor`nz' < dd2)
		gen dtdebfor_ns = max(dtdebfor`nz',dd7)
		gen dtfinfor_ns = min(dtfinfor`nz',dd2)
		replace dZ72 = dZ72 + (dtfinfor_ns - dtdebfor_ns) * inSns72z
		drop inSns72z dtdebfor_ns dtfinfor_ns
	}
	bys indiv inddtns inSns72: egen durZ72_ns = sum(dZ72)
	replace durZ72_ns = . if inSns72 == 0
	// proportion of unemployment spells with training among those ending between y0 - 7 and y0 - 2
	gen inSz = inSns72end * (dtdebfor1 < dtfinfor1)
	bys indiv inddtns inSns72end: egen pZ72_ns = mean(inSz)
	bys indiv inddtns (inSns72end): replace pZ72_ns = pZ72_ns[_N]
	replace pZ72_ns = . if inSns72 == 0
	// average duration between start of unemployment spell and start of first training if spell ends between y0 - 7 and y0 - 2
	gen dpreZ72 = (dtdebfor1 - datedeb) if inSz == 1
	bys indiv inddtns inSz: egen durpreZ72_ns = mean(dpreZ72)
	replace durpreZ72_ns = . if inSz == 0
	// update variables of interest
	foreach vv of varlist nus72 duru72 durZ72 pZ72 durpreZ72{
		bys indiv inddtns (`vv'_ns): replace `vv'_ns = `vv'_ns[1]
		replace `vv' = `vv'_ns if nsnn == 1
		replace `vv' = 0 if `vv' == . & nsnn == 1
	}
	drop nsnn dd7 dd2 inSns72* dZ72 inSz dpreZ72 *_ns
}

// keep inflow of 2002 and 2004
keep if inS == 1

save data/fna`year'_q`qqq'_h`hhh'_inflow, replace
}
}
}

// append all sub-tables and check repetitions
//////////////////////////////////////////////

drop _all
set obs 1
gen indiv = ""
save data/inflow, replace

foreach year of numlist 2006 2007{
foreach qqq of numlist 1(1)4{
foreach hhh of numlist 1 2{
	use data/fna`year'_q`qqq'_h`hhh'_inflow
	gen fna_y = `year'
	gen fna_q = `qqq'
	gen half = `hhh'
	append using data/inflow
	bys indiv inddtns (datedeb): gen repeat = (datedeb[1] == datedeb[2])
	tab repeat
	drop if repeat == 1 & fna_y == `year' & fna_q == `qqq' & half == `hhh'
	drop repeat
	drop if indiv == ""
	save data/inflow, replace
}
}
}

// match coderome with bmo letter codes (occup_bmo) and then compute occup_fna from cdtmet
//////////////////////////////////////////////////////////////////////////////////////////

destring indrom1, replace
rename indrom1 coderome

// duplicate spell if coderome corresponds to several bmo letter codes, none of which is C
gen dupli = 1
foreach rr of numlist 44133 44311 44314 44315 44316 44321 44322 44324 44331 44332 45121 45414 45421 46114 47231 44214 44313{
	replace dupli = 2 if coderome == `rr'
}
replace dupli = 3 if coderome == 44341
expand dupli
bys indiv inddtns datedeb: gen sub_rome = _n
drop dupli

// merge with rome_bmo
sort coderome sub_rome
merge coderome sub_rome using data/rome_bmo
tab _merge
keep if _merge == 3
drop _merge

// use cdtmet when coderome corresponds to several bmo letter codes, one of which is C
gen exec = (cdtmet == 1 | cdtmet == 2 | cdtmet == 4 | cdtmet == 5 | cdtmet == 6 | cdtmet == 35 | cdtmet == 41 | cdtmet == 44    /*
*/        | cdtmet == 46 | cdtmet == 48 | cdtmet == 49 | cdtmet == 50 | cdtmet == 54 | cdtmet == 57 | cdtmet == 67 | cdtmet == 68 | cdtmet == 69)
foreach rr of numlist 32311 32321{
	replace bmo1 = "A" if exec == 0 & coderome == `rr'
}
foreach rr of numlist 61223 61224 61231 61233{
	replace bmo1 = "T" if exec == 0 & coderome == `rr'
}
foreach rr of numlist 33111 33121 33122 33211 33212 33215 33224 33225 33226 61311 61312 61313{
	replace bmo1 = "V" if exec == 0 & coderome == `rr'
}
foreach rr of numlist 32311 32321 61223 61224 61231 61233 33111 33121 33122 33211 33212 33215 33224 33225 33226 61311 61312 61313{
	replace bmo1 = "C" if exec == 1 & coderome == `rr'
}
rename bmo1 occup_bmo
drop exec codebmo intitulrome intitulbmo

// compute occup_fna from cdtmet
gen occup_fna = ""
foreach cm of numlist 36(1)40 60 66 76{
	replace occup_fna = "A" if cdtmet == `cm'
}
foreach cm of numlist 1 2 4 5 6 35 41 44 46 48 49 50 53 54 57 67 68 69{
	replace occup_fna = "C" if cdtmet == `cm'
}
foreach cm of numlist 51 52 55 56 59{
	replace occup_fna = "S" if cdtmet == `cm'
}
foreach cm of numlist 42 43 45 47 58 70 72(1)75{
	replace occup_fna = "V" if cdtmet == `cm'
}
foreach cm of numlist 7 8 9{
	replace occup_fna = "T" if cdtmet == `cm'
}
foreach cm of numlist 10(1)13 33{
	replace occup_fna = "O" if cdtmet == `cm'
}
foreach cm of numlist 14(1)31 65{
	replace occup_fna = "I" if cdtmet == `cm'
}
foreach cm of numlist 0 32 34 61(1)64 71 77 78 98{
	replace occup_fna = "Z" if cdtmet == `cm'
}
tab cdtmet if occup_fna == ""
replace occup_fna = "Z" if occup_fna == ""

//
gen m0 = month(datedeb)
gen y_id2004 = (y0 == 2004)

gen occup = occup_bmo

// individual characteristics
rename sexe11 X_male
gen X_age = int((mdy(1,1,y0) - inddtns) / 365)
gen X_age2 = (X_age)^2
rename sal1 X_refwage
rename ltauxin1 X_ub
rename lduraff X_duraff
tab m0, gen(X_m)
drop X_m1

// individual unemployment history
gen Xh_nus2  = nus2
gen Xh_duru2 = (nus2 > 0) * duru2
gen Xh_durZ2 = (nus2 > 0) * durZ2
gen Xh_nus72  = nus72
gen Xh_duru72 = duru72
gen Xh_durZ72 = durZ72

keep y0 m0 date* dtdebfor1 dtfinfor1 sortiemp regionU dep occup y_id* X_* Xh*

compress
save data/inflow, replace


