clear all

forv year = 2006/2007{
forv qqq = 1/4{
forv hhh = 1/2{

use data/fna`year'_q`qqq'_h`hhh'

// count unemployment spells
//gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen nspell = _n

// drop some variables
drop cdd1 diph1 dipl1 durchom1 emp1 noduraff1 noqual1 notaux1 nprevm21 ldurcum21 qualnr qualsup salnr siren td* tf*

// code date variables
foreach vv of varlist datedeb datefin dtdeb* dtfin* inddtns{
	replace `vv' = mdy(int((`vv' - int(`vv'/ 10000) * 10000) / 100),    /*
	*/	   	       `vv'- int(`vv'/ 10000) * 10000 - int((`vv'- int(`vv'/ 10000) * 10000) / 100) * 100,     /*
	*/			 int(`vv'/ 10000))
	format %d `vv'
}

// infer cdtmet from other spells
replace cdtmet = "" if cdtmet == "XX"
destring cdtmet, replace
bys indiv inddtns (nspell): gen new = (cdtmet ~= cdtmet[_n - 1]) * (_n > 1) + (_n == 1)
bys indiv inddtns (nspell): gen group = sum(new)
sort indiv inddtns nspell
gen newcdt = cdtmet[_n - 1] if group >= 2 & cdtmet >= 98
replace newcdt = cdtmet if newcdt == .
bys indiv inddtns group (newcdt): replace newcdt = newcdt[1]
sort indiv inddtns nspell
replace newcdt = cdtmet[_n + 1] if group == 1 & cdtmet >= 98 & group[_n + 1] == 2
bys indiv inddtns group (newcdt): replace newcdt = newcdt[1]
replace cdtmet = newcdt
drop newcdt

// create region Unedic
drop if dep == "9A" | dep == "9B" | dep == "9C" | dep == "9D" | dep == "9E" | dep == "2A" | dep == "2B"
destring dep, replace
drop if dep >= 96
gen regionU = ""
replace regionU = "alsace" if dep == 67 | dep == 68
replace regionU = "alpes" if dep == 01 | dep == 38 | dep == 73 | dep == 74
replace regionU = "alpesprove" if dep == 04 | dep == 05 | dep == 13 | dep == 84
replace regionU = "auvergne" if dep == 03 | dep == 15 | dep == 43 | dep == 63
replace regionU = "bassenorm" if dep == 14 | dep == 50 | dep == 61
replace regionU = "bourgogne" if dep == 21 | dep == 58 | dep == 71 | dep == 89
replace regionU = "bretagne" if dep ==22 | dep == 29 | dep == 35 | dep == 56
replace regionU = "centre" if dep == 18 | dep == 28 | dep == 36 | dep == 37 | dep == 41 | dep == 45
replace regionU = "champagne" if dep == 08 | dep == 10 | dep == 51 | dep == 52
replace regionU = "cote" if dep == 06 | dep == 83
replace regionU = "franche" if dep == 25 | dep == 39 | dep == 70 | dep == 90
replace regionU = "domtom" if dep == 97
replace regionU = "hautenorm" if dep == 27 | dep == 76
replace regionU = "idf" if dep == 75 | dep == 77 |dep == 78 | dep == 91 | dep == 92   /*
*/                          | dep == 93 |dep == 94 | dep == 95
replace regionU = "languedoc" if dep == 11 | dep == 30 | dep == 34 | dep == 48 | dep == 66
replace regionU = "limousin" if dep == 19 | dep == 23 | dep == 87
replace regionU = "lorraine" if dep == 54 | dep == 55 | dep == 57 | dep == 88
replace regionU = "midi" if dep == 09 | dep == 12 |dep == 31 | dep == 32 | dep == 46   /*
*/                          | dep == 65 |dep == 81 | dep == 82
replace regionU = "nord" if dep == 59
replace regionU = "pasdecalais" if dep == 62
replace regionU = "paysdeloire" if dep == 44 | dep == 49 | dep == 53 | dep == 72 | dep == 85
replace regionU = "picardie" if dep == 02 | dep == 60 | dep == 80
replace regionU = "poitou" if dep == 16 | dep == 17 | dep == 79 | dep == 86
replace regionU = "vallees" if dep == 07 | dep == 26 | dep == 42 | dep == 69

replace regionU = "aquitaine" if regionU == ""

compress

save data/fna`year'_q`qqq'_h`hhh'_small, replace
}
}
}
