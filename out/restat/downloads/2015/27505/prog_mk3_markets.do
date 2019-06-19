clear all

// match coderome with bmo letter codes (occup_bmo) and then compute occup_fna from cdtmet
//////////////////////////////////////////////////////////////////////////////////////////

cap program drop getoccup
program define getoccup
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
end

// append all sub-tables from the FNA, get bmo codes and check repetitions
//////////////////////////////////////////////////////////////////////////

drop _all
set obs 1
gen indiv = ""
save data/fna_markets, replace
foreach year of numlist 2006 2007{
foreach qqq of numlist 1(1)4{
foreach hhh of numlist 1 2{
	use data/fna`year'_q`qqq'_h`hhh'_small
	keep indiv inddtns datedeb datefin dt* cdtmet regionU dep indrom1
	drop if year(datefin) <= 2001
	getoccup
	gen fna_y = `year'
	gen fna_q = `qqq'
	gen half = `hhh'
	append using data/fna_markets
	bys indiv inddtns (datedeb): gen repeat = (datedeb[1] == datedeb[2])
	tab repeat
	drop if repeat == 1 & fna_y == `year' & fna_q == `qqq' & half == `hhh'
	drop repeat
	drop if indiv == ""
	save data/fna_markets, replace
}
}
}

// number unemployed workers for each month during the observation period
/////////////////////////////////////////////////////////////////////////
use data/fna_markets, clear
keep regionU dep occup_bmo datedeb datefin
qui forv yy = 2002/2005{
	gen u`yy' = 0
	forv mm = 1/12{
		replace u`yy' = u`yy' + inrange(mdy(`mm',15,`yy'), datedeb, datefin)/12
	}
}
collapse (sum) u*, by(regionU dep occup_bmo)
expand 5
bys dep occup: gen year = 2001+_n
gen u = .
forv yy = 2002/2005{
	replace u = u`yy' if year==`yy'
}
drop u200*
compress
rename occup_bmo occup
sort regionU dep occup year
save data/u, replace

// number of vacancies (only available by region before 2004)
/////////////////////////////////////////////////////////////
use data/bmo, clear
expand 5
bys dep occup: gen year = 2001+_n
gen vd = .
gen vr = .
forv yy = 2002/2006{
	replace vr = vr`yy' if year==`yy'
	if `yy'>=2005 replace vd = vd`yy' if year==`yy'
}
// before 2004: weight dep according to relative v in 2005
gen y05 = (year==2005)
bys dep occup (y05): gen wd = vd[_N]/vr[_N]
gen v = vd if year>=2005
replace v = round(vr*wd,1) if year<=2004
keep regionU dep occup year v vr wd
compress
sort regionU dep occup year
save data/v, replace

// create smaller geographical zones (no zone for aquitaine and limousin as they will be dropped eventually)
////////////////////////////////////
use data/u, clear
keep regionU dep
bys regionU dep: keep if _n==1

gen zone = ""

replace zone = "isere" if regionU=="alpes" & dep==38
replace zone = "alpes" if regionU=="alpes" & dep~=38

replace zone = "bouches du rhone" if regionU=="alpesprove" & dep==13
replace zone = "alpes prov" if regionU=="alpesprove" & dep~=13

replace zone = "bas rhin" if regionU=="alsace" & dep==67
replace zone = "haut rhin" if regionU=="alsace" & dep==68

replace zone = "puy de dome" if regionU=="auvergne" & dep==63
replace zone = "auvergne" if regionU=="auvergne" & dep~=63

replace zone = "calvados" if regionU=="bassenorm" & dep==14
replace zone = "basse normandie" if regionU=="bassenorm" & dep~=14

replace zone = "cotes d'or" if regionU=="bourgogne" & dep==21
replace zone = "saone et loire" if regionU=="bourgogne" & dep==71
replace zone = "bourgogne" if regionU=="bourgogne" & dep~=21 & dep~=71

replace zone = "cotes d'armor" if regionU=="bretagne" & dep==22
replace zone = "finistere" if regionU=="bretagne" & dep==29
replace zone = "ille et vilaine" if regionU=="bretagne" & dep==35
replace zone = "morbihan" if regionU=="bretagne" & dep==56

replace zone = "indre et loire" if regionU=="centre" & dep==37
replace zone = "loiret" if regionU=="centre" & dep==45
replace zone = "centre" if regionU=="centre" & dep~=37 & dep~=45

replace zone = "champagne" if regionU=="champagne"

replace zone = "alpes maritimes" if regionU=="cote" & dep==6
replace zone = "var" if regionU=="cote" & dep==83

replace zone = "doubs" if regionU=="franche" & dep==25
replace zone = "franche" if regionU=="franche" & dep~=25

replace zone = "eure" if regionU=="hautenorm" & dep==27
replace zone = "seine maritime" if regionU=="hautenorm" & dep==76

replace zone = "paris" if regionU=="idf" & dep==75
replace zone = "seine et marne" if regionU=="idf" & dep==77
replace zone = "yvelines" if regionU=="idf" & dep==78
replace zone = "essonne" if regionU=="idf" & dep==91
replace zone = "hauts de seine" if regionU=="idf" & dep==92
replace zone = "seine st denis" if regionU=="idf" & dep==93
replace zone = "val de marne" if regionU=="idf" & dep==94
replace zone = "val d'oise" if regionU=="idf" & dep==95

replace zone = "gard" if regionU=="languedoc" & dep==30
replace zone = "herault" if regionU=="languedoc" & dep==34
replace zone = "pyrenees orientales" if regionU=="languedoc" & dep==66
drop if regionU=="languedoc" & (dep==11 | dep==48)

replace zone = "moselle" if regionU=="lorraine" & dep==57
replace zone = "lorraine" if regionU=="lorraine" & dep~=57

replace zone = "haute garonne" if regionU=="midi" & dep==31
replace zone = "midi" if regionU=="midi" & dep~=31

replace zone = "nord" if regionU=="nord"

replace zone = "pas de calais" if regionU=="pasdecalais"

replace zone = "loire atlantique" if regionU=="paysdeloire" & dep==44
replace zone = "maine et loire" if regionU=="paysdeloire" & dep==49
replace zone = "vendee" if regionU=="paysdeloire" & dep==85
replace zone = "paysdeloire" if regionU=="paysdeloire" & dep~=44 & dep~=49 & dep~=85

replace zone = "oise" if regionU=="picardie" & dep==60
replace zone = "picardie" if regionU=="picardie" & dep~=60

replace zone = "charente maritime" if regionU=="poitou" & dep==17
replace zone = "poitou" if regionU=="poitou" & dep~=17

replace zone = "rhone" if regionU=="vallees" & dep==69
replace zone = "loire" if regionU=="vallees" & dep==42
replace zone = "vallees" if regionU=="vallees" & dep~=69 & dep~=42

compress
sort dep
save data/zone, replace

// macro-indicator table ready-to-merge with inflow micro table
///////////////////////////////////////////////////////////////
use data/u, clear
merge 1:1 dep occup year using data/v
keep if _merge==3
drop _merge
keep if year<=2005
gen y_id2004 = year>=2004
sort dep
merge m:1 dep using data/zone
keep if _merge==3
drop _merge
drop if regionU == "aquitaine" | regionU == "limousin"
foreach vv of varlist u v{
	bys regionU occup y_id2004: egen `vv'_regionU = sum(`vv')
	bys zone occup y_id2004: egen `vv'_zone = sum(`vv')
}
gen th_regionU = v_region/u_region
gen th_zone = v_zone/u_zone
bys regionU zone occup y_id2004 (year): keep if _n==1
keep regionU zone dep occup y_id2004 u_* v_* th_*
compress
sort dep occup y_id2004
save data/uv, replace


