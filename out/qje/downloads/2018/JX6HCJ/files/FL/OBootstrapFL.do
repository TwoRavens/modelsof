
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [pw aw] [if] [in] [, cens(string) robust]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	if ("`cens'" == "") `anything' [`weight' `exp'] `if' `in', `robust' 
	if ("`cens'" ~= "") `anything' [`weight' `exp'] `if' `in', cens(`cens') `robust' 
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

capture program drop mycmd1
program define mycmd1
	syntax anything [pw aw] [if] [in] [, cens(string) robust]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	if ("`cens'" == "") capture `anything' [`weight' `exp'] `if' `in', `robust' 
	if ("`cens'" ~= "") capture `anything' [`weight' `exp'] `if' `in', cens(`cens') `robust' 
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 74
global b = 1004

matrix F = J($a,4,.)
matrix B = J($b,2,.)

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

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
gen obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

global i = 1
global j = 1

*Table 3 
mycmd1 (picshowblack picraceb picobscur $manip) reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack picraceb picobscur $manip) reg giving picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip) reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1 & ~other, robust
mycmd1 (picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [pw=tweight] if S == 1 & ~other, robust
mycmd1 (picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if S == 1 &  white, robust
mycmd1 (picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems if S == 1 & black, robust

*Table 4 
mycmd1 (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraudb) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraudb) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraudb) reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraudb) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust

*Table 5 
mycmd1 (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraudb) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd1 (picshowblack picraceb picobscur $nraud1) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd1 (picshowblack picraceb picobscur $nraud1) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraud) cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)
mycmd1 (picshowblack $nraud) reg giving picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraudb) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd1 (picshowblack picraceb picobscur $nraud1) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd1 (picshowblack picraceb picobscur $nraud1) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraud) cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)
mycmd1 (picshowblack $nraud) reg hypgiv_tc500 picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraudb) reg subjsupchar  picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd1 (picshowblack picraceb picobscur $nraud1) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd1 (picshowblack picraceb picobscur $nraud1) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraud) oprobit subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack $nraud) reg subjsupchar picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraudb) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd1 (picshowblack picraceb picobscur $nraud1) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd1 (picshowblack picraceb picobscur $nraud1) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraud) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack picraceb picobscur $nraud) oprobit subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack $nraud) reg subjsupgov picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust

*Table 6 
global mycondition="white"
mycmd1 (int* $manip) interactdd giving ethclosed
mycmd1 (int* $manip) interactdd hypgiv_tc500 ethclosed
mycmd1 (int* $manip) interactdd subjsupchar ethclosed
mycmd1 (int* $manip) interactdd subjsupgov ethclosed
mycmd1 (int* $manip) interactdd giving soccon_difd
mycmd1 (int* $manip) interactdd hypgiv_tc500 soccon_difd
mycmd1 (int* $manip) interactdd subjsupchar soccon_difd
mycmd1 (int* $manip) interactdd subjsupgov soccon_difd
mycmd1 (int* $manip) interactdd giving oppblkd
mycmd1 (int* $manip) interactdd hypgiv_tc500 oppblkd
mycmd1 (int* $manip) interactdd subjsupchar oppblkd
mycmd1 (int* $manip) interactdd subjsupgov oppblkd
global mycondition="black"
mycmd1 (int* $manipb) interactdd giving ethclosed
mycmd1 (int* $manipb) interactdd hypgiv_tc500 ethclosed
mycmd1 (int* $manipb) interactdd subjsupchar ethclosed
mycmd1 (int* $manipb) interactdd subjsupgov ethclosed
mycmd1 (int* $manipb) interactdd giving soccon_difd
mycmd1 (int* $manipb) interactdd hypgiv_tc500 soccon_difd
mycmd1 (int* $manipb) interactdd subjsupchar soccon_difd
mycmd1 (int* $manipb) interactdd subjsupgov soccon_difd
mycmd1 (int* $manipb) interactdd giving oppblkd
mycmd1 (int* $manipb) interactdd hypgiv_tc500 oppblkd
mycmd1 (int* $manipb) interactdd subjsupchar oppblkd
mycmd1 (int* $manipb) interactdd subjsupgov oppblkd

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\OBootstrapFL, replace

erase aa.dta
erase aaa.dta

