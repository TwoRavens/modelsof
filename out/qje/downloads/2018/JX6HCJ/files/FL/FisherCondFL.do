
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cens(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	if ("`cens'" == "") {
		`anything' [`weight' `exp'] `if' `in', `robust'
		}
	else {
		`anything' [`weight' `exp'] `if' `in', cens(`cens')
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop interactdd
  program define interactdd
  capture drop int?_*
  qui gen int1_picshowb  =    `2'   * picshowblack 
  qui gen int1_picraceb  =    `2'   * picraceb     
  qui gen int1_picobscur =    `2'   * picobscur    
  qui gen int0_picshowb  =  (1-`2') * picshowblack 
  qui gen int0_picraceb  =  (1-`2') * picraceb     
  qui gen int0_picobscur =  (1-`2') * picobscur    
  reg `1' int?_* $manip `2' $cntrldems if S ==1 & $mycondition, robust
end

****************************************
****************************************


use DatFL, clear

global manip aud_republ aud_econdis aud_govtben aud_prephur aud_church aud_crime aud_helpoth aud_contrib aud_loot cityslidell var_fullstakes var_racesalient
global cntrldems age age2 black other edudo edusc educp lnhhinc dualin married male singlemale south work disabled retired dcharkatrina lcharkatrina dchartot2005 lchartot2005
global cntrlx    age age2 black other edudo edusc educp lnhhinc dualin married male singlemale south work disabled retired
global addcntrl1  hfh_effective lifepriorities_help lifepriorities_mony
global nraud nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot cityslidell var_fullstakes var_racesalient

*I add, to drop treatment variables which are dropped certain regressions so that my extracted treatment covariance matrices don't have blanks
global manipb aud_republ aud_econdis aud_govtben aud_prephur aud_church aud_crime aud_helpoth aud_contrib aud_loot cityslidell 
global nraudb nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot cityslidell 
global nraud1 nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot var_fullstakes var_racesalient

matrix F = J(74,4,.)
matrix B = J(1004,2,.)

global i = 1
global j = 1

*Table 3 
mycmd (picshowblack picraceb picobscur $manip) reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $manip) reg giving picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip) reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1 & ~other, robust
mycmd (picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [pw=tweight] if S == 1 & ~other, robust
mycmd (picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if S == 1 &  white, robust
mycmd (picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems if S == 1 & black, robust

*Table 4 
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust

*Table 5 
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)
mycmd (picshowblack $nraud) reg giving picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)
mycmd (picshowblack $nraud) reg hypgiv_tc500 picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg subjsupchar  picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) oprobit subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack $nraud) reg subjsupchar picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraudb) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud1) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack picraceb picobscur $nraud) oprobit subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack $nraud) reg subjsupgov picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust

*Table 6 
global mycondition="white"
mycmd (int* $manip) interactdd giving ethclosed
mycmd (int* $manip) interactdd hypgiv_tc500 ethclosed
mycmd (int* $manip) interactdd subjsupchar ethclosed
mycmd (int* $manip) interactdd subjsupgov ethclosed
mycmd (int* $manip) interactdd giving soccon_difd
mycmd (int* $manip) interactdd hypgiv_tc500 soccon_difd
mycmd (int* $manip) interactdd subjsupchar soccon_difd
mycmd (int* $manip) interactdd subjsupgov soccon_difd
mycmd (int* $manip) interactdd giving oppblkd
mycmd (int* $manip) interactdd hypgiv_tc500 oppblkd
mycmd (int* $manip) interactdd subjsupchar oppblkd
mycmd (int* $manip) interactdd subjsupgov oppblkd
global mycondition="black"
mycmd (int* $manipb) interactdd giving ethclosed
mycmd (int* $manipb) interactdd hypgiv_tc500 ethclosed
mycmd (int* $manipb) interactdd subjsupchar ethclosed
mycmd (int* $manipb) interactdd subjsupgov ethclosed
mycmd (int* $manipb) interactdd giving soccon_difd
mycmd (int* $manipb) interactdd hypgiv_tc500 soccon_difd
mycmd (int* $manipb) interactdd subjsupchar soccon_difd
mycmd (int* $manipb) interactdd subjsupgov soccon_difd
mycmd (int* $manipb) interactdd giving oppblkd
mycmd (int* $manipb) interactdd hypgiv_tc500 oppblkd
mycmd (int* $manipb) interactdd subjsupchar oppblkd
mycmd (int* $manipb) interactdd subjsupgov oppblkd

generate Strata = (ppethm == 2)
generate N = _n
sort Strata N

global i = 0
*Table 3
foreach var in picshowblack picraceb picobscur $manip {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $manip"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $manip {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $manip"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/70 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

*Table 4 
foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraudb {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraudb"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraudb {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraudb"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraudb {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraudb"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraudb {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraudb"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 5 
foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraudb {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraudb"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud1 {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud1"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud1 {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud1"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack $nraud {
	global i = $i + 1
	local a = "picshowblack $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg giving picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraudb {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraudb"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud1 {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud1"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud1 {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud1"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack $nraud {
	global i = $i + 1
	local a = "picshowblack $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg hypgiv_tc500 picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraudb {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraudb"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar  picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud1 {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud1"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud1 {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud1"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar  picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') oprobit subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack $nraud {
	global i = $i + 1
	local a = "picshowblack $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupchar picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraudb {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraudb"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud1 {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud1"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud1 {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud1"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack picraceb picobscur $nraud {
	global i = $i + 1
	local a = "picshowblack picraceb picobscur $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') oprobit subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in picshowblack $nraud {
	global i = $i + 1
	local a = "picshowblack $nraud"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg subjsupgov picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/408 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}




matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondFL, replace


