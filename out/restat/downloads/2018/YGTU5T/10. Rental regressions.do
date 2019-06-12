********************************************************************************
*                                                                              *
*                      REGRESSIONS USING WOON DATA                             *
*                                                                              *
********************************************************************************

cd "U:\" \\ Set directory
use  "woon0215.dta", clear
set matsize 11000

global depvar1 logrentsqm
global depvar2 moveprop
global house logsize rooms type_terraced type_semidetached type_detached floor floorsbuilding elevator garage centralheating maintgood constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000 
global neighbourhood logincome logpopdens shforeign shyoung shold hhsize luinfr luind luopens luwater
global year year_*
global fe pc4
global se pc4
global c = 7.3

// Drop observations
drop if kwadjacent == 1
*keep if kwdistcentroid > 2.5 | inkw == 1
drop if constryear > 2006
drop if movedw2yrs == 0




//  1,459 observaties sociale huur en 304 observaties in vrije sector

local h2 = 7.3837526
local h3 = 6.8237911
local h4 = 8.8504175
local h5 = 8.8899842

local h7 = 6.3243634
local h8 = 6.3249381
local h9 = 6.3226965
local h10 = 6.350239


// Private rental sector
qui xtivreg2  $depvar1 kw $house $year, cluster($se) i($fe) fe, if socialrent == 0 & movedw2yrs==1
qui estimates store r1
qui xtivreg2 $depvar1 kw $house $year,  cluster($se) i($fe) fe, if socialrent == 0 & movedw2yrs==1 & (zscore > $c - `h2') & (zscore < $c + `h2') & kwexcl == 0 
qui estimates store r2
qui xtivreg2 $depvar1 (kw=scorerule) $house $year,  cluster($se) i($fe) fe, if socialrent == 0 & movedw2yrs==1 & (zscore > $c - `h3') & (zscore < $c + `h3') 
qui estimates store r3
qui xtivreg2 $depvar1 (kw=scorerule) $house $neighbourhood $year, cluster($se) i($fe) fe, if socialrent == 0 & movedw2yrs==1 & (zscore > $c - `h4') & (zscore < $c + `h4') 
qui estimates store r4
qui xtivreg2 $depvar1 (kw_*=scorerule_*) $house $neighbourhood $year, cluster($se) i($fe) fe, if socialrent == 0 & movedw2yrs==1 & (zscore > $c - `h5') & (zscore < $c + `h5') 
qui estimates store r5

// Social rental sector
qui xtivreg2  $depvar1 kw $house $year, cluster($se) i($fe) fe, if socialrent == 1 & movedw2yrs==1 
qui estimates store r6
qui xtivreg2  $depvar1 kw $house $year, cluster($se) i($fe) fe, if socialrent == 1 & movedw2yrs==1 & (zscore > $c - `h7') & (zscore < $c + `h7') & kwexcl == 0
qui estimates store r7
qui xtivreg2 $depvar1 (kw=scorerule) $house $year, cluster($se) i($fe) fe, if socialrent == 1 & movedw2yrs==1 & (zscore > $c - `h8') & (zscore < $c + `h8') 
qui estimates store r8
qui xtivreg2 $depvar1 (kw=scorerule) $house $neighbourhood $year, cluster($se)  i($fe) fe, if socialrent == 1 & movedw2yrs==1 & (zscore > $c - `h9') & (zscore < $c + `h9') 
qui estimates store r9
qui xtivreg2 $depvar1 (kw_*=scorerule_*) $house $neighbourhood $year, cluster($se)  i($fe) fe, if socialrent == 1 & movedw2yrs==1 & (zscore > $c - `h10') & (zscore < $c + `h10') 
qui estimates store r10

estimates table r1 r2 r3 r4 r5, b(%8.3f) se(%8.3f) p(%8.3f) stats(r2 N widstat) keep(kw* ) title(table 2 - logrent)
estimates table r6 r7 r8 r9 r10, b(%8.3f) se(%8.3f) p(%8.3f) stats(r2 N widstat) keep(kw* ) title(table 2 - logrent)

/// Export results
order rentsqm kw zscore size rooms type_appartment type_terraced type_semidetached type_detached floor floorsbuilding elevator garage maintgood centralheating constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000
preserve
keep if socialrent == 0 & rentsqm !=.
outreg2 using "Results\Table B4a", replace sum(log) label word keep(rentsqm kw zscore size rooms type_appartment type_terraced type_semidetached type_detached floor floorsbuilding elevator garage maintgood centralheating constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000)
restore
preserve
keep if socialrent == 1 & rentsqm !=.
outreg2 using "Results\Table B4b", replace sum(log) label word keep(rentsqm kw zscore size rooms type_appartment type_terraced type_semidetached type_detached floor floorsbuilding elevator garage maintgood centralheating constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000)
restore

qui estimates restore r1
qui outreg2 using "Results\Table 6", label aster replace word title(Baseline results - first-differences) ctitle(OLS) nocon alpha(0.01, 0.05, 0.10, 0.15) keep(kw* )symbol(***, **, *, +) 
qui estimates restore r2
qui outreg2 using "Results\Table 6", append label aster word ctitle(OLS) nocon alpha(0.01, 0.05, 0.10, 0.15) keep(kw*) symbol(***, **, *, +) 
qui estimates restore r3
qui outreg2 using "Results\Table 6", append label aster nor2 word ctitle(IV) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) keep(kw* )  symbol(***, **, *, +) 
qui estimates restore r4
qui outreg2 using "Results\Table 6", append label aster nor2 word ctitle(IV) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) keep(kw* )  symbol(***, **, *, +) 
qui estimates restore r5
qui outreg2 using "Results\Table 6", append label aster nor2 word ctitle(IV) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) keep(kw* )  symbol(***, **, *, +) 
qui estimates restore r6
qui outreg2 using "Results\Table 6", append label aster word ctitle(OLS) nocon alpha(0.01, 0.05, 0.10, 0.15) keep(kw* ) symbol(***, **, *, +) 
qui estimates restore r7
qui outreg2 using "Results\Table 6", append label aster word ctitle(OLS) nocon alpha(0.01, 0.05, 0.10, 0.15) keep(kw* ) symbol(***, **, *, +) 
qui estimates restore r8
qui outreg2 using "Results\Table 6", append label aster nor2 word ctitle(IV) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) keep(kw* )  symbol(***, **, *, +) 
qui estimates restore r9
qui outreg2 using "Results\Table 6", append label aster nor2 word ctitle(IV) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) keep(kw* )  symbol(***, **, *, +) 
qui estimates restore r10
    outreg2 using "Results\Table 6", append label aster nor2 word ctitle(IV) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) keep(kw* )    symbol(***, **, *, +) 
