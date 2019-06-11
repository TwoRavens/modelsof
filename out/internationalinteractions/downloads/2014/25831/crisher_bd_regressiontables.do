// Balanced Dyads Tables Do File
// Brian B. Crisher
// Dept. of Politicaly Science, Florida State University
// bcrisher@fsu.edu
// "Inequality Amid Equality: Military Capabilities and Conflict Behavior in Balanced Dyads"
// International Interactions


**************************************
*
* Table 1: Balanced Models: 1946:2001
*
**************************************

*******************************************************************************
// Inititial Values Set Manually to Speed Convergence

// basic reciprocation
probit mzrecip dyadpow jntd6 smldep allies contig150 terr if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mzrecip:`name'"
}

probit mzmid dyadpow jntd6 smldep allies contig150 midpy* if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob mzrecip dyadpow jntd6 smldep allies terr contig150 if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model1

***********************************************************************************
// mutual force reciprocation
probit mutforcerecip dyadpow jntd6 smldep allies contig150 terr if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mutforcerecip:`name'"
}

probit mzmid dyadpow jntd6 smldep allies contig150 midpy* if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob mutforcerecip dyadpow jntd6 smldep allies terr contig150 if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model2

**************************************************************************************
// fatal reciprocation
probit fatalrecip1 dyadpow jntd6 smldep allies contig150 terr if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' fatalrecip1:`name'"
}

probit mzmid dyadpow jntd6 smldep allies contig150 midpy* if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob fatalrecip1 dyadpow jntd6 smldep allies terr contig150 if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model3

*******************************************************************************
// basic reciprocation
probit mzrecip dyadmilpow jntd6 smldep allies contig150 terr if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mzrecip:`name'"
}

probit mzmid dyadmilpow jntd6 smldep allies contig150 midpy* if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob mzrecip dyadmilpow jntd6 smldep allies terr contig150 if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model4

***********************************************************************************
// mutual force reciprocation
probit mutforcerecip dyadmilpow jntd6 smldep allies contig150 terr if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mutforcerecip:`name'"
}

probit mzmid dyadmilpow jntd6 smldep allies contig150 midpy* if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob mutforcerecip dyadmilpow jntd6 smldep allies terr contig150 if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model5

**************************************************************************************
// fatal reciprocation
probit fatalrecip1 dyadmilpow jntd6 smldep allies contig150 terr if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' fatalrecip1:`name'"
}

probit mzmid dyadmilpow jntd6 smldep allies contig150 midpy* if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob fatalrecip1 dyadmilpow jntd6 smldep allies terr contig150 if parity575mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model6


* output for all models
* you cannot overwrite a txt file, delete previous version if rerunning
estout model1 model2 model3 model4 model5 model6, ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab) ///
	stats(N, fmt(a1 %9.3f %9.3f)), using "table1_balanceddyads.txt"


**************************************
*
* Table 2: Interaction Models: 1946:2001
*
**************************************

heckprob mzrecip dyadpow parity575 dyadparity575 jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow parity575 dyadparity575 jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model7

heckprob mutforcerecip dyadpow parity575 dyadparity575 jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow parity575 dyadparity575 jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model8

heckprob fatalrecip1 dyadpow parity575 dyadparity575 jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow parity575 dyadparity575 jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model9

heckprob mzrecip dyadmilpow parity575mr dyadparity575mr jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow parity575mr dyadparity575mr jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model10

heckprob mutforcerecip dyadmilpow parity575mr dyadparity575mr jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow parity575mr dyadparity575mr jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model11

heckprob fatalrecip1 dyadmilpow parity575mr dyadparity575mr jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow parity575mr dyadparity575mr jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model12* 

output for all models
* you cannot overwrite a txt file, delete previous version if rerunning
estout model7 model8 model9 model10 model11 model12, ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab) ///
	stats(N, fmt(a1 %9.3f %9.3f)), using "table2_balanceddyads.txt"
	

// Online Appendix Models

**************************************
*
* Table 3: Contiguous Models: 1946:2001
*
**************************************

/* Basic reciprocation */

heckprob mzrecip dyadpow jntd6 smldep allies terr if powerratio <= .575 & contig150 == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies midpy*) cluster(dyadid) nolog

	estimates store model13

heckprob mzrecip dyadpow jntd6 smldep allies terr if powerratio <= .6 & contig150 == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies midpy*) cluster(dyadid) nolog

	estimates store model14

/* Mutual Use of Force */

heckprob mutforcerecip dyadpow jntd6 smldep allies terr if powerratio <= .575 & contig150 == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies midpy*) cluster(dyadid) nolog

	estimates store model15

heckprob mutforcerecip dyadpow jntd6 smldep allies terr if powerratio <= .6 & contig150 == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies midpy*) cluster(dyadid) nolog

	estimates store model16

/* Reciprocation with 1+ Fatality */

heckprob fatalrecip1 dyadpow jntd6 smldep allies terr if powerratio <= .575 & contig150 == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies midpy*) cluster(dyadid) nolog

	estimates store model17
	
heckprob fatalrecip1 dyadpow jntd6 smldep allies terr if powerratio <= .6 & contig150 == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies midpy*) cluster(dyadid) nolog

	estimates store model18

* output for all models
* you cannot overwrite a txt file, delete previous version if rerunning
estout model13 model14 model15 model16 model17 model18, ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab) ///
	stats(N, fmt(a1 %9.3f %9.3f)), using "table3_balanceddyads.txt"


**************************************
*
* Table 4: Balanced Dyads 0.5-0.6: 1946:2001
*
**************************************

*******************************************************************************
// basic reciprocation
probit mzrecip dyadpow jntd6 smldep allies contig150 terr if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mzrecip:`name'"
}

probit mzmid dyadpow jntd6 smldep allies contig150 midpy* if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob mzrecip dyadpow jntd6 smldep allies terr contig150 if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0)

	estimates store model19

***********************************************************************************
// mutual force reciprocation
probit mutforcerecip dyadpow jntd6 smldep allies contig150 terr if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mutforcerecip:`name'"
}

probit mzmid dyadpow jntd6 smldep allies contig150 midpy* if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob mutforcerecip dyadpow jntd6 smldep allies terr contig150 if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model20

**************************************************************************************
// fatal reciprocation
probit fatalrecip1 dyadpow jntd6 smldep allies contig150 terr if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' fatalrecip1:`name'"
}

probit mzmid dyadpow jntd6 smldep allies contig150 midpy* if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob fatalrecip1 dyadpow jntd6 smldep allies terr contig150 if parity6 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model21

*******************************************************************************
// basic reciprocation
probit mzrecip dyadmilpow jntd6 smldep allies contig150 terr if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mzrecip:`name'"
}

probit mzmid dyadmilpow jntd6 smldep allies contig150 midpy* if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob mzrecip dyadmilpow jntd6 smldep allies terr contig150 if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model22

***********************************************************************************
// mutual force reciprocation
probit mutforcerecip dyadmilpow jntd6 smldep allies contig150 terr if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mutforcerecip:`name'"
}

probit mzmid dyadmilpow jntd6 smldep allies contig150 midpy* if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob mutforcerecip dyadmilpow jntd6 smldep allies terr contig150 if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model23

**************************************************************************************
// fatal reciprocation
probit fatalrecip1 dyadmilpow jntd6 smldep allies contig150 terr if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' fatalrecip1:`name'"
}

probit mzmid dyadmilpow jntd6 smldep allies contig150 midpy* if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

set more off
heckprob fatalrecip1 dyadmilpow jntd6 smldep allies terr contig150 if parity6mr == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0) nolog

	estimates store model24

* output for all models
* you cannot overwrite a txt file, delete previous version if rerunning
estout model19 model20 model21 model22 model23 model24, ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab) ///
	stats(N, fmt(a1 %9.3f %9.3f)), using "table4_balanceddyads.txt"



**************************************
*
* Table 5: All Dyads and Parity 0.5-0.6: 1946:2001
*
**************************************

heckprob mzrecip dyadpow parity6 dyadparity6 jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow parity6 dyadparity6 jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model25

heckprob mutforcerecip dyadpow parity6 dyadparity6 jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow parity6 dyadparity6 jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model26

heckprob fatalrecip1 dyadpow parity6 dyadparity6 jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow parity6 dyadparity6 jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model27

heckprob mzrecip dyadmilpow parity6mr dyadparity6mr jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow parity6mr dyadparity6mr jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model28

heckprob mutforcerecip dyadmilpow parity6mr dyadparity6mr jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow parity6mr dyadparity6mr jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model29

heckprob fatalrecip1 dyadmilpow parity6mr dyadparity6mr jntd6 smldep allies terr contig150 if pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadmilpow parity6mr dyadparity6mr jntd6 smldep allies contig150 midpy*) cluster(dyadid) nolog

	estimates store model30

estout model25 model26 model27 model28 model29 model30, ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab) ///
	stats(N, fmt(a1 %9.3f %9.3f)), using "table5_balanceddyads.txt"


