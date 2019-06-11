
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [aw] [if] [in] [, robust cens(string) noconstant]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "regress") {
		quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', `constant'
		quietly generate Ssample$i = e(sample)
		quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, `constant'
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, `constant'
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		}
	else {
		if ("`cens'" ~= "") quietly `cmd' `dep' `testvars' `anything' [`weight' `exp'] `if' `in', cens(`cens')
		if ("`cens'" == "") quietly `cmd' `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		if ("`cens'" ~= "") quietly `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', cens(`cens')
		if ("`cens'" == "") quietly `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', 
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

use DatFL, clear

global manip aud_republ aud_econdis aud_govtben aud_prephur aud_church aud_crime aud_helpoth aud_contrib aud_loot cityslidell var_fullstakes var_racesalient
global cntrldems age age2 black other edudo edusc educp lnhhinc dualin married male singlemale south work disabled retired dcharkatrina lcharkatrina dchartot2005 lchartot2005
global cntrlx    age age2 black other edudo edusc educp lnhhinc dualin married male singlemale south work disabled retired
global addcntrl1  hfh_effective lifepriorities_help lifepriorities_mony
global nraud nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot cityslidell var_fullstakes var_racesalient

global manipb aud_republ aud_econdis aud_govtben aud_prephur aud_church aud_crime aud_helpoth aud_contrib aud_loot cityslidell 
global nraudb nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot cityslidell 
global nraud1 nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot var_fullstakes var_racesalient

matrix B = J(1004,2,.)
global j = 1

*In order to use consistent weights for suest, have to inverse weight the unweighted regressions

reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if S == 1 &  white, robust
gen subsample1 = e(sample)
sum tweight if subsample1 == 1
foreach var in giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems {
	gen double A`var' = `var'*sqrt(r(mean)/tweight) if subsample1 == 1
	}
gen Aconst = sqrt(r(mean)/tweight) if subsample1 == 1

global Amanip Aaud_republ Aaud_econdis Aaud_govtben Aaud_prephur Aaud_church Aaud_crime Aaud_helpoth Aaud_contrib Aaud_loot Acityslidell Avar_fullstakes Avar_racesalient
global Acntrldems Aage Aage2 Ablack Aother Aedudo Aedusc Aeducp Alnhhinc Adualin Amarried Amale Asinglemale Asouth Awork Adisabled Aretired Adcharkatrina Alcharkatrina Adchartot2005 Alchartot2005

reg Agiving Apicshowb_sib Apicraceb_sib Apicobscur_sib Apicshowblack Apicraceb Apicobscur $Amanip Asubj_iden_blk $Acntrldems Aconst [aw = tweight] if S == 1 & white, robust noconstant

reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems if S == 1 & black, robust
gen subsample2 = e(sample)
sum tweight if subsample2 == 1
foreach var in giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems { 
	gen double B`var' = `var'*sqrt(r(mean)/tweight) if subsample2 == 1
	}
gen Bconst = sqrt(r(mean)/tweight) if subsample2 == 1

global Bmanipb Baud_republ Baud_econdis Baud_govtben Baud_prephur Baud_church Baud_crime Baud_helpoth Baud_contrib Baud_loot Bcityslidell 
global Bcntrldems Bage Bage2 Bblack Bother Bedudo Bedusc Beducp Blnhhinc Bdualin Bmarried Bmale Bsinglemale Bsouth Bwork Bdisabled Bretired Bdcharkatrina Blcharkatrina Bdchartot2005 Blchartot2005

reg Bgiving Bpicshowb_sib Bpicraceb_sib Bpicobscur_sib Bpicshowblack Bpicraceb Bpicobscur $Bmanipb Bsubj_iden_blk $Bcntrldems Bconst [aw = tweight] if S == 1 & black, robust noconstant


*Table 3 
global i = 0
mycmd (picshowblack $manip) reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack $manip) reg giving picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowb_resb picshowblack $manip) reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1 & ~other, robust
mycmd (picshowb_sib picshowblack $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [aw=tweight] if S == 1 & ~other, robust
mycmd (Apicshowb_sib Apicshowblack $Amanip) reg Agiving Apicshowb_sib Apicraceb_sib Apicobscur_sib Apicshowblack Apicraceb Apicobscur $Amanip Asubj_iden_blk $Acntrldems Aconst [aw = tweight] if S == 1 & white, robust noconstant
mycmd (Bpicshowb_sib Bpicshowblack $Bmanipb) reg Bgiving Bpicshowb_sib Bpicraceb_sib Bpicobscur_sib Bpicshowblack Bpicraceb Bpicobscur $Bmanipb Bsubj_iden_blk $Bcntrldems Bconst [aw = tweight] if S == 1 & black, robust noconstant

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)


*Table 4 
global i = 0
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

capture drop A* B* subsample1 subsample2
*Adjustments so that mweighted regressions can be run with tweights

global Acntrldems Aage Aage2 Ablack Aother Aedudo Aedusc Aeducp Alnhhinc Adualin Amarried Amale Asinglemale Asouth Awork Adisabled Aretired Adcharkatrina Alcharkatrina Adchartot2005 Alchartot2005
global Anraudb Anraudworthy Aaud_republ Aaud_econdis Aaud_govtben Aaud_church Aaud_loot Acityslidell 

global Bcntrldems Bage Bage2 Bblack Bother Bedudo Bedusc Beducp Blnhhinc Bdualin Bmarried Bmale Bsinglemale Bsouth Bwork Bdisabled Bretired Bdcharkatrina Blcharkatrina Bdchartot2005 Blchartot2005
global Bnraudb Bnraudworthy Baud_republ Baud_econdis Baud_govtben Baud_church Baud_loot Bcityslidell 

global Ccntrldems Cage Cage2 Cblack Cother Cedudo Cedusc Ceducp Clnhhinc Cdualin Cmarried Cmale Csinglemale Csouth Cwork Cdisabled Cretired Cdcharkatrina Clcharkatrina Cdchartot2005 Clchartot2005
global Cnraudb Cnraudworthy Caud_republ Caud_econdis Caud_govtben Caud_church Caud_loot Ccityslidell 

global Dcntrldems Dage Dage2 Dblack Dother Dedudo Dedusc Deducp Dlnhhinc Ddualin Dmarried Dmale Dsinglemale Dsouth Dwork Ddisabled Dretired Ddcharkatrina Dlcharkatrina Ddchartot2005 Dlchartot2005
global Dnraudb Dnraudworthy Daud_republ Daud_econdis Daud_govtben Daud_church Daud_loot Dcityslidell 

reg giving picshowblack picraceb picobscur $nraudb $cntrldems [aw=mweight] if S == 1 & white & surveyvariant==1, robust
gen subsample1 = e(sample)
quietly sum mweight if subsample1 == 1
global mean1 = r(mean)
quietly sum tweight if subsample1 == 1
global mean2 = r(mean)
foreach var in giving picshowblack picraceb picobscur $nraudb $cntrldems {
	quietly generate double A`var' = `var'*sqrt(mweight/$mean1)*sqrt($mean2/tweight) if subsample1 == 1
	}
quietly generate Aconst = sqrt(mweight/$mean1)*sqrt($mean2/tweight) if subsample1 == 1
reg Agiving Apicshowblack Apicraceb Apicobscur $Anraudb $Acntrldems Aconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant

reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [aw=mweight] if S == 1 & white & surveyvariant==1, robust
gen subsample2 = e(sample)
quietly sum mweight if subsample2 == 1
global mean1 = r(mean)
quietly sum tweight if subsample2 == 1
global mean2 = r(mean)
foreach var in hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems {
	quietly generate double B`var' = `var'*sqrt(mweight/$mean1)*sqrt($mean2/tweight) if subsample2 == 1
	}
quietly generate Bconst = sqrt(mweight/$mean1)*sqrt($mean2/tweight) if subsample2 == 1
reg Bhypgiv_tc500 Bpicshowblack Bpicraceb Bpicobscur $Bnraudb $Bcntrldems Bconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant

reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [aw=mweight] if S == 1 & white & surveyvariant==1, robust
gen subsample3 = e(sample)
quietly sum mweight if subsample3 == 1
global mean1 = r(mean)
quietly sum tweight if subsample3 == 1
global mean2 = r(mean)
foreach var in subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems {
	quietly generate double C`var' = `var'*sqrt(mweight/$mean1)*sqrt($mean2/tweight) if subsample3 == 1
	}
quietly generate Cconst = sqrt(mweight/$mean1)*sqrt($mean2/tweight) if subsample3 == 1
reg Csubjsupchar Cpicshowblack Cpicraceb Cpicobscur $Cnraudb $Ccntrldems Cconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant

reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [aw=mweight] if S == 1 & white & surveyvariant==1, robust
gen subsample4 = e(sample)
quietly sum mweight if subsample4 == 1
global mean1 = r(mean)
quietly sum tweight if subsample4 == 1
global mean2 = r(mean)
foreach var in subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems {
	quietly generate double D`var' = `var'*sqrt(mweight/$mean1)*sqrt($mean2/tweight) if subsample4 == 1
	}
quietly generate Dconst = sqrt(mweight/$mean1)*sqrt($mean2/tweight) if subsample4 == 1
reg Dsubjsupgov Dpicshowblack Dpicraceb Dpicobscur $Dnraudb $Dcntrldems Dconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant


*Table 5 
global i = 0
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Apicshowblack Anraudworthy Aaud_econdis) reg Agiving Apicshowblack Apicraceb Apicobscur $Anraudb $Acntrldems Aconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Bpicshowblack Bnraudworthy Baud_econdis) reg Bhypgiv_tc500 Bpicshowblack Bpicraceb Bpicobscur $Bnraudb $Bcntrldems Bconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Cpicshowblack Cnraudworthy Caud_econdis) reg Csubjsupchar Cpicshowblack Cpicraceb Cpicobscur $Cnraudb $Ccntrldems Cconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) oprobit subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Dpicshowblack Dnraudworthy Daud_econdis) reg Dsubjsupgov Dpicshowblack Dpicraceb Dpicobscur $Dnraudb $Dcntrldems Dconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) oprobit subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)


foreach var in ethclosed soccon_difd oppblkd {
	gen i1p1`var' = `var'*picshowblack
	gen i1p2`var' = `var'*picraceb
	gen i1p3`var' = `var'*picobscur
	gen i0p1`var' = (1-`var')*picshowblack
	gen i0p2`var' = (1-`var')*picraceb
	gen i0p3`var' = (1-`var')*picobscur
	}

*Table 6 
global i = 0
global mycondition="white"
foreach X in ethclosed soccon_difd oppblkd {
	foreach var in giving hypgiv_tc500 subjsupchar subjsupgov {
		mycmd (i1p1`X' i0p1`X') reg `var' i*`X' $manip `X' $cntrldems if S == 1 & $mycondition, 
		}
	}
global mycondition="black"
foreach X in ethclosed soccon_difd oppblkd {
	foreach var in giving hypgiv_tc500 subjsupchar subjsupgov {
		mycmd (i1p1`X' i0p1`X') reg `var' i*`X' $manip `X' $cntrldems if S == 1 & $mycondition, 
		}
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

drop _all
svmat double F
svmat double B
save results/SuestredFL, replace






