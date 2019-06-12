cd "U:\"
use "psm_selection.dta", clear

local X POPDENS SHAREFOREIGNER SHAREYOUNG SHAREOLD SHAREOPENSPACE INCOME SHAREALL SHARENOTACTIVE SHARELOWINCOME SHAREOWN CYMEDIAN CYlt1945 CY19451970 
global n = _N
local h = 1.06*($n^(1/5))
global zT = 0.01

g weight = 0 
g SCORE = 0

quietly forvalues i = 1(1)$n {
nois _dots `i' 0

replace weight = 1/(sqrt((XCOORD-XCOORD[`i'])^2+(YCOORD-YCOORD[`i'])^2)/1000)

probit VOG `X' [iweight = weight]

predict SCORE_t, pr
replace SCORE = SCORE_t[`i'] in `i'
drop SCORE_t

}

gsort -SCORE
order SCORE, after(VOG)

* Matching
g SCOREdiff = 0
g INCLUDED1 = 0
g INCLUDED2 = 0
g INCLUDED3 = 0

quietly forvalues i = 1(1)$n {
	
	if VOG[`i'] == 1 {
	replace SCOREdiff = abs(SCORE-SCORE[`i'])
	
	replace INCLUDED1 = 1 in `i' // Calipher matching
	replace INCLUDED2 = 1 in `i' // Nearest-neighbour with replacement
	replace INCLUDED3 = 1 in `i' // Nearest-neighbour without replacement
	
	replace SCOREdiff = 100 if VOG==1
	
	replace INCLUDED1 = 1 if abs(SCOREdiff) < $zT & SCORE> $zT // Calipher matching
	
	summ SCOREdiff
	replace INCLUDED2 = 1 if SCOREdiff == r(min) // Nearest-neighbour with replacement
	
	replace SCOREdiff = 100 if INCLUDED3 == 1
	summ SCOREdiff
	replace INCLUDED3 = 1 if SCOREdiff == r(min) // Nearest-neighbour without replacement
	
	}
	
	}
	
order INCLUDED*, after(SCORE)

local X SCORE POPDENS SHAREFOREIGNER SHAREYOUNG SHAREOLD SHAREOPENSPACE INCOME SHAREALL SHARENOTACTIVE SHARELOWINCOME SHAREOWN CYMEDIAN CYlt1945 CY19451970 
summ `X' SCORE if VOG==1
summ `X' SCORE if VOG==0 & INCLUDED1==1
summ `X' SCORE if VOG==0 & INCLUDED2==1
summ `X' SCORE if VOG==0 & INCLUDED3==1
	
	keep POSTCODE INCLUDED*
	rename POSTCODE pc4
	rename (INCLUDED1 INCLUDED2 INCLUDED3) (PSM_C PSM_NNwR PSM_NNwoR)


save "psm.dta", replace
