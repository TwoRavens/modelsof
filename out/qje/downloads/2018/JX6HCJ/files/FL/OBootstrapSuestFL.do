
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
		matrix B = J(1,500,.)
		global j = 0
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
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		if ("`cens'" ~= "") capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', cens(`cens') iterate(50)
		if ("`cens'" == "") capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', iterate(50)
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}	
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"
end

****************************************
****************************************



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

*In order to use consistent weights for suest, have to inverse weight the unweighted regressions

reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if S == 1 &  white, robust
gen subsample5 = e(sample)
sum tweight if subsample5 == 1
global mean5 = r(mean)
foreach var in giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems {
	gen double E`var' = `var'*sqrt($mean5/tweight) if subsample5 == 1
	}
gen Econst = sqrt($mean5/tweight) if subsample5 == 1

global Emanip Eaud_republ Eaud_econdis Eaud_govtben Eaud_prephur Eaud_church Eaud_crime Eaud_helpoth Eaud_contrib Eaud_loot Ecityslidell Evar_fullstakes Evar_racesalient
global Ecntrldems Eage Eage2 Eblack Eother Eedudo Eedusc Eeducp Elnhhinc Edualin Emarried Emale Esinglemale Esouth Ework Edisabled Eretired Edcharkatrina Elcharkatrina Edchartot2005 Elchartot2005

reg Egiving Epicshowb_sib Epicraceb_sib Epicobscur_sib Epicshowblack Epicraceb Epicobscur $Emanip Esubj_iden_blk $Ecntrldems Econst [aw = tweight] if S == 1 & white, robust noconstant

reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems if S == 1 & black, robust
gen subsample6 = e(sample)
sum tweight if subsample6 == 1
global mean6 = r(mean)
foreach var in giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems { 
	gen double F`var' = `var'*sqrt($mean6/tweight) if subsample6 == 1
	}
gen Fconst = sqrt($mean6/tweight) if subsample6 == 1

global Fmanipb Faud_republ Faud_econdis Faud_govtben Faud_prephur Faud_church Faud_crime Faud_helpoth Faud_contrib Faud_loot Fcityslidell 
global Fcntrldems Fage Fage2 Fblack Fother Fedudo Fedusc Feducp Flnhhinc Fdualin Fmarried Fmale Fsinglemale Fsouth Fwork Fdisabled Fretired Fdcharkatrina Flcharkatrina Fdchartot2005 Flchartot2005

reg Fgiving Fpicshowb_sib Fpicraceb_sib Fpicobscur_sib Fpicshowblack Fpicraceb Fpicobscur $Fmanipb Fsubj_iden_blk $Fcntrldems Fconst [aw = tweight] if S == 1 & black, robust noconstant


*Table 3 
global i = 0
mycmd (picshowblack picraceb picobscur $manip) reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $manip) reg giving picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip) reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1 & ~other, robust
mycmd (picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [aw=tweight] if S == 1 & ~other, robust
mycmd (Epicshowb_sib Epicraceb_sib Epicobscur_sib Epicshowblack Epicraceb Epicobscur $Emanip) reg Egiving Epicshowb_sib Epicraceb_sib Epicobscur_sib Epicshowblack Epicraceb Epicobscur $Emanip Esubj_iden_blk $Ecntrldems Econst [aw = tweight] if S == 1 & white, robust noconstant
mycmd (Fpicshowb_sib Fpicraceb_sib Fpicobscur_sib Fpicshowblack Fpicraceb Fpicobscur $Fmanipb) reg Fgiving Fpicshowb_sib Fpicraceb_sib Fpicobscur_sib Fpicshowblack Fpicraceb Fpicobscur $Fmanipb Fsubj_iden_blk $Fcntrldems Fconst [aw = tweight] if S == 1 & black, robust noconstant

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

*Table 4 
global i = 0
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)
matrix B4 = B[1,1..$j]

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
global m1 = r(mean)
foreach var in giving picshowblack picraceb picobscur $nraudb $cntrldems {
	quietly generate double A`var' = `var'*sqrt(mweight/$mean1)*sqrt($m1/tweight) if subsample1 == 1
	}
quietly generate Aconst = sqrt(mweight/$mean1)*sqrt($m1/tweight) if subsample1 == 1
reg Agiving Apicshowblack Apicraceb Apicobscur $Anraudb $Acntrldems Aconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant

reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [aw=mweight] if S == 1 & white & surveyvariant==1, robust
gen subsample2 = e(sample)
quietly sum mweight if subsample2 == 1
global mean2 = r(mean)
quietly sum tweight if subsample2 == 1
global m2 = r(mean)
foreach var in hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems {
	quietly generate double B`var' = `var'*sqrt(mweight/$mean2)*sqrt($m2/tweight) if subsample2 == 1
	}
quietly generate Bconst = sqrt(mweight/$mean2)*sqrt($m2/tweight) if subsample2 == 1
reg Bhypgiv_tc500 Bpicshowblack Bpicraceb Bpicobscur $Bnraudb $Bcntrldems Bconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant

reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [aw=mweight] if S == 1 & white & surveyvariant==1, robust
gen subsample3 = e(sample)
quietly sum mweight if subsample3 == 1
global mean3 = r(mean)
quietly sum tweight if subsample3 == 1
global m3 = r(mean)
foreach var in subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems {
	quietly generate double C`var' = `var'*sqrt(mweight/$mean3)*sqrt($m3/tweight) if subsample3 == 1
	}
quietly generate Cconst = sqrt(mweight/$mean3)*sqrt($m3/tweight) if subsample3 == 1
reg Csubjsupchar Cpicshowblack Cpicraceb Cpicobscur $Cnraudb $Ccntrldems Cconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant

reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [aw=mweight] if S == 1 & white & surveyvariant==1, robust
gen subsample4 = e(sample)
quietly sum mweight if subsample4 == 1
global mean4 = r(mean)
quietly sum tweight if subsample4 == 1
global m4 = r(mean)
foreach var in subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems {
	quietly generate double D`var' = `var'*sqrt(mweight/$mean4)*sqrt($m4/tweight) if subsample4 == 1
	}
quietly generate Dconst = sqrt(mweight/$mean4)*sqrt($m4/tweight) if subsample4 == 1
reg Dsubjsupgov Dpicshowblack Dpicraceb Dpicobscur $Dnraudb $Dcntrldems Dconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant


*Table 5 
global i = 0
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Apicshowblack Apicraceb Apicobscur $Anraudb) reg Agiving Apicshowblack Apicraceb Apicobscur $Anraudb $Acntrldems Aconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack picraceb picobscur $nraud1) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)
mycmd (picshowblack $nraud) reg giving picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Bpicshowblack Bpicraceb Bpicobscur $Bnraudb) reg Bhypgiv_tc500 Bpicshowblack Bpicraceb Bpicobscur $Bnraudb $Bcntrldems Bconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack picraceb picobscur $nraud1) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)
mycmd (picshowblack $nraud) reg hypgiv_tc500 picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Cpicshowblack Cpicraceb Cpicobscur $Cnraudb) reg Csubjsupchar Cpicshowblack Cpicraceb Cpicobscur $Cnraudb $Ccntrldems Cconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) oprobit subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack $nraud) reg subjsupchar picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Dpicshowblack Dpicraceb Dpicobscur $Dnraudb) reg Dsubjsupgov Dpicshowblack Dpicraceb Dpicobscur $Dnraudb $Dcntrldems Dconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) oprobit subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack $nraud) reg subjsupgov picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

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
		mycmd (i*`X' $manip) reg `var' i*`X' $manip `X' $cntrldems if S == 1 & $mycondition, 
		}
	}
global mycondition="black"
foreach X in ethclosed soccon_difd oppblkd {
	foreach var in giving hypgiv_tc500 subjsupchar subjsupgov {
		mycmd (i*`X' $manipb) reg `var' i*`X' $manip `X' $cntrldems if S == 1 & $mycondition, 
		}
	}

quietly suest $M, robust
test $test 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
gen obs = _n
save aaa, replace

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*Table 3 
global i = 0
mycmd (picshowblack picraceb picobscur $manip) reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $manip) reg giving picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip) reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [aw=tweight] if S == 1 & ~other, robust
mycmd (picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [aw=tweight] if S == 1 & ~other, robust
mycmd (Epicshowb_sib Epicraceb_sib Epicobscur_sib Epicshowblack Epicraceb Epicobscur $Emanip) reg Egiving Epicshowb_sib Epicraceb_sib Epicobscur_sib Epicshowblack Epicraceb Epicobscur $Emanip Esubj_iden_blk $Ecntrldems Econst [aw = tweight] if S == 1 & white, robust noconstant
mycmd (Fpicshowb_sib Fpicraceb_sib Fpicobscur_sib Fpicshowblack Fpicraceb Fpicobscur $Fmanipb) reg Fgiving Fpicshowb_sib Fpicraceb_sib Fpicobscur_sib Fpicshowblack Fpicraceb Fpicobscur $Fmanipb Fsubj_iden_blk $Fcntrldems Fconst [aw = tweight] if S == 1 & black, robust noconstant

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 4 
global i = 0
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [aw=tweight] if S == 1 & black, robust

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table 5 
global i = 0
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Apicshowblack Apicraceb Apicobscur $Anraudb) reg Agiving Apicshowblack Apicraceb Apicobscur $Anraudb $Acntrldems Aconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack picraceb picobscur $nraud1) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)
mycmd (picshowblack $nraud) reg giving picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Bpicshowblack Bpicraceb Bpicobscur $Bnraudb) reg Bhypgiv_tc500 Bpicshowblack Bpicraceb Bpicobscur $Bnraudb $Bcntrldems Bconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack picraceb picobscur $nraud1) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)
mycmd (picshowblack $nraud) reg hypgiv_tc500 picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Cpicshowblack Cpicraceb Cpicobscur $Cnraudb) reg Csubjsupchar Cpicshowblack Cpicraceb Cpicobscur $Cnraudb $Ccntrldems Cconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) oprobit subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack $nraud) reg subjsupchar picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (Dpicshowblack Dpicraceb Dpicobscur $Dnraudb) reg Dsubjsupgov Dpicshowblack Dpicraceb Dpicobscur $Dnraudb $Dcntrldems Dconst [aw=tweight] if S == 1 & white & surveyvariant==1, robust noconstant
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [aw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud black other [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) oprobit subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, robust
mycmd (picshowblack $nraud) reg subjsupgov picshowblack $nraud $cntrldems [aw=tweight] if S == 1 & white & ~picobscur, robust

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}

*Table 6 
global i = 0
global mycondition="white"
foreach X in ethclosed soccon_difd oppblkd {
	foreach var in giving hypgiv_tc500 subjsupchar subjsupgov {
		mycmd (i*`X' $manip) reg `var' i*`X' $manip `X' $cntrldems if S == 1 & $mycondition, 
		}
	}
global mycondition="black"
foreach X in ethclosed soccon_difd oppblkd {
	foreach var in giving hypgiv_tc500 subjsupchar subjsupgov {
		mycmd (i*`X' $manipb) reg `var' i*`X' $manip `X' $cntrldems if S == 1 & $mycondition, 
		}
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestFL, replace

erase aa.dta
erase aaa.dta

