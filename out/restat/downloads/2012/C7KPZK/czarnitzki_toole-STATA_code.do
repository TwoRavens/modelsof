version 9
clear
clear matrix
set more off
cap log close
set matsize 1000
set mem 60m

log using c:/dirk/paper2006/realopt/logs/czarnitzki_toole_results.log, replace

cd c:/dirk/paper2006/realopt


use c:/dirk/paper2006/realpat/czarnitzki-toole-data, clear

* set panel structure
tsset lfdnr jahr


/*
DATA DICTIONARY
Variable Name	Definition
lfdnr:		Firm ID
jahr:		Year
j1-j7:		Year dummies
ind1-ind11:	Industry dummies
bges:		employment
fue:		R&D expenditure
msnew:		PASTINNO as defined in the paper
lagpcm:		PASTPCM as defined in the paper
lnfue:		log of R&D expenditure
lnb:		log of employment
limit:		minimum observed positive value of R&D (needed for tobit regressions as censoring point)
hhi_n3:		Herfindahl index (See HHI in paper)
lnhhi:		log of Herfindahl index.
bonitaet:   	credit rating
lnboni:		log of credit rating
ps:		patent stock per 100 employees
cv_new:		uncertainty measure => UNC_NEW as defined in paper
cv_old:     	uncertainty measure => UNC_OLD as defined in paper
cv_ind:     	uncertainty measure => UNC_IND as defined in paper
psint:		UNC_NEW times ps (patent stock as defined above)
lnprefue:  	 presample R&D for entry stock estimation in Table A.1
d:          	dummy variable = 1 if presample R&D = missing; zero otherwise
demp:		delta.US_emp as defined in paper
iv:		Instrumental variable (industry average of UNC_NEW as defined in paper)
psint_br1:  	Interaction of UNC_NEW with ps and MEDIUM tech industries (see paper, Table 5)
psint_br2:  	Interaction of UNC_NEW with ps and LOW	  tech industries (see paper, Table 5)
psint_br3:  	Interaction of UNC_NEW with ps and HIGH   tech industries (see paper, Table 5)
psint_pimp: 	Interaction of UNC_NEW with ps and survey variable CRUCIAL = 1 (see paper, Table 5)
psint_dont: 	Interaction of UNC_NEW with ps and survey variable CRUCIAL = "missing" (see paper, Table 5)
psint_oth:  	Interaction of UNC_NEW with ps and survey variable CRUCIAL = 0 (see paper, Table 5)
rndint:     	R&D intensity (see robustness check, Table A.1)
*/


* variables
describe
sum






/*---------------------------------------------------------------------------------------

	TABLE 1: Descriptive Statistics

---------------------------------------------------------------------------------------*/


format 	lnfue cv_new cv_old  cv_ind msnew lagpcm bges  ps hhi boni  %9.3f
sum 	fue   cv_new cv_old  cv_ind msnew lagpcm bges  ps hhi boni , format


/*---------------------------------------------------------------------------------------

	TABLE 2: Tobit Regressions

---------------------------------------------------------------------------------------*/

gen y1 = lnfue
gen y2 = lnfue
qui sum lnfue
replace y1 = . if lnfue == r(min)


* Run model with constant only for obtaining LL0 (for the computation of
* McFadden's R^2

qui intreg y1 y2 , cluster(lfdnr)
local ll0 = e(ll)

* Model A: Pooled Cross-section

intreg y1 y2 	cv_new cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11, cluster(lfdnr)
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'


* Model A: Random Effects Panel Tobit

xttobit lnfue 	cv_new          cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11, ll(limit) tobit
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'


* Model B: Pooled Cross-section

intreg y1 y2 	cv_new psint cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11, cluster(lfdnr)
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'


* Model B: Random Effects Panel Tobit

xttobit lnfue 	cv_new psint    cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11, ll(limit) tobit
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'


/*-----------------------------------------------------------------------

	 Table 3: IV Regressions

----------------------------------------------------------------------*/


qui sum lnfue
local cut = r(min)+0.00001
di `cut'


reg cv_new cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11 demp iv, cluster(lfdnr)
testparm demp iv
testparm ind2-ind11
testparm j2-j7
predict res, resid

intreg y1 y2 	cv_new cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11 res, cluster(lfdnr)
testparm ind2-ind11
testparm j2-j7

ivtobit lnfue cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11 (cv_new =  demp iv) , ll(`cut') cluster(lfdnr)
testparm ind*, eq(lnfue)
testparm j*, eq(lnfue)


/*
ivregress 2sls lnfue cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11 (cv_new =  demp iv ) , rob
estat endog
estat first
estat overid
*/

/*-----------------------------------------------------------------------

	 Table 4: Tobit Regressions

----------------------------------------------------------------------*/

gen p0 = ps == 0
sum ps if ps>0, d
cap drop hv*
egen hv1 = pctile(ps) if ps > 0, p(33)
egen hv2 = pctile(ps) if ps > 0, p(67)

sum hv1
replace hv1 = r(mean)
sum hv2
replace hv2 = r(mean)

gen p1 = ps > 0 & ps <=hv1
gen p2 = ps > hv1 & ps <=hv2
gen p3 = ps > hv2

gen u0 = cv_new * p0
gen u1 = cv_new * p1
gen u2 = cv_new * p2
gen u3 = cv_new * p3

* Pooled cross-sectional model

intreg y1 y2 u0 u1 u2 u3 cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11, cluster(lfdnr)
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'
test u0 = u1 = u2 = u3

* panel model
xttobit lnfue 	u0 u1 u2 u3    cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11, ll(limit) tobit
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'
test u0 = u1 = u2 = u3


/*-----------------------------------------------------------------------

	 Table 5: Robustness checks

----------------------------------------------------------------------*/


qui intreg y1 y2 , cluster(lfdnr)
local ll0 = e(ll)


* Model C: Pooled Cross-section
intreg y1 y2 cv_new   psint_br*     cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11, cluster(lfdnr)
test psint_br1 = psint_br2 = psint_br3
testparm ind*
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'


* Model C: Panel model
xttobit lnfue cv_new  psint_br*     cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11, ll(limit)
test psint_br1 = psint_br2 = psint_br3
testparm ind*
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'



preserve

* Model D Pooled cross-sectional models

* use ind8 as reference category for industries.
drop ind8

intreg y1 y2 	cv_new psint_pimp psint_dont psint_oth				 cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind1-ind11, cluster(lfdnr)
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'


* panel model

xttobit lnfue 	cv_new psint_pimp psint_dont psint_oth   cv_old cv_ind msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind1-ind11, ll(limit) tobit
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`ll0'

restore






/*-----------------------------------------------------------------------

    Table A.1:	C O U N T   D A T A   M O D E L S

-----------------------------------------------------------------------*/


* constant only (for McFadden R^2)
poisson rndint , cluster(lfdnr)
local llpois0 = e(ll)

* Model A
poisson rndint 	cv_new cv_old cv_ind  msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11 lnprefue d, cluster(lfdnr)
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`llpois0'

* Model B
poisson rndint 	cv_new psint cv_old cv_ind  msnew lagpcm lnb ps lnhhi lnboni j2-j7 ind2-ind11 lnprefue d, cluster(lfdnr)
testparm ind*, eq(#1)
testparm j*
di "MC-Fadden: " 1-e(ll)/`llpois0'






