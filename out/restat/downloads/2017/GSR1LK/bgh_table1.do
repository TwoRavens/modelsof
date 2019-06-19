/*This file creates the output displayed in Table 1 and discussed in 
Section 3.1.*/

use data-final.dta, clear

******************************************************************************
** This block produces output for Columns (1) through (5) of Table 1 ***
******************************************************************************
foreach varnam in fullsample nohsged gtehsged kidctge2 kidctlt2 ykidlt6 ykidge6 ///
	marnvr martogapt anyadcpq7 noadcpq7 anyernpq7 noernpq7 npqern0 npqernl ///
	npqernhi ernpq7lo ernpq7hi  {
	pause
	di "Variable is `varnam', unconditional, unweighted"
	* mean diffs;
	qui reg ernq e if quarter>=1 & quarter<=7 & `varnam'==1 , cluster(id)
	di as text "Mean diff is " as result %6.0f _b[e]
	matrix V = e(V)
	local tmp = el(V,1,1)
	local dofr=e(df_r)
	local ci = invttail(`dofr',0.025)
	local lbdm= -`ci'*(`tmp'^.5) + _b[e]
	local ubdm= +`ci'*(`tmp'^.5) + _b[e]
	di as text "CI " as result %6.0f `lbdm' as text ","  as result %6.0f `ubdm'
	qui su ernq if quarter>=1 & quarter<=7 & `varnam' ==1 & e==0 
	* control mean
	di as text "control mean is " as result %6.0f r(mean)
	di as text "control N is " as result %8.0f r(N)
	** unweighted share in control group
	qui su `varnam' if e==0 
	di as text "unweighted control share in group is " as result %6.2f r(mean)
	* treatment mean
	qui su ernq if quarter>=1 & quarter<=7 & `varnam' ==1 & e==1 
	di as text "treatment N is " as result %8.0f r(N)
	** unweighted share in treatment group
	qui su `varnam' if e==1 
	di as text "unweighted treatment share in group is " as result %6.2f r(mean) 
	di as text ""
	}

******************************************************************************
** This block produces F-statistics and p-values in Table 1
******************************************************************************
*** Education
for any nohsged gtehsged misshsged: gen e_X = e*X
reg ernq nohsged misshsged e e_nohsged e_misshsged  ///
	if quarter>=1 & quarter<=7 & (nohsged + gtehsged==1), cluster(id)
testparm e_nohsged e_misshsged

** Age of youngest kid;
for any ykidlt6 ykidge6 missykidlt6: gen e_X = e* X
reg ernq ykidlt6  missykidlt6 e e_ykidlt6 e_missykidlt6  ///
	if quarter>=1 & quarter<=7, cluster(id)
testparm e_ykidlt6 

* Number of children;
for any kidctge2 misskidctge2: gen e_X = e* X
reg ernq kidctge2 misskidctge2 e e_kidctge2 e_misskidctge2  ///
	if quarter>=1 & quarter<=7 & (kidctge2 + kidctlt2==1), cluster(id)
testparm e_kidctge2 e_misskidctge2

** Marital status;
for any marnvr missmarnvr: gen e_X = e* X
reg ernq marnvr missmarnvr e e_marnvr e_missmarnvr  ///
	if quarter>=1 & quarter<=7 & (marnvr + martogapt==1), cluster(id)
testparm e_marnvr e_missmarnvr

*** Level of earnings 7Q pre-RA;
for any vernpq70 ernpq7lo : gen e_X = e*X
reg ernq vernpq70 ernpq7lo e_vernpq70 e_ernpq7lo e  ///
	if quarter>=1 & quarter<=7, cluster(id)
testparm e_vernpq70 e_ernpq7lo

** Share of quarters pre-RA with hi low med earnings;
for any npqern0 npqernlo: gen e_X = e*X
reg ernq npqern0 npqernlo e_npqern0 e_npqernlo e  ///
	if quarter>=1 & quarter<=7  , cluster(id)
testparm e_npqern0 e_npqernlo

** AFDC 7 quarters before RA;
gen e_anyadcpq7 = e* anyadcpq7
reg ernq anyadcpq7 e e_anyadcpq7  if quarter>=1 & quarter<=7 , cluster(id)
testparm e_anyadcpq7



