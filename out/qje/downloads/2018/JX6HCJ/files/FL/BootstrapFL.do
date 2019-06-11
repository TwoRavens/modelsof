

capture program drop mycmd
program define mycmd
	syntax anything [pw aw] [if] [in] [, robust cens(string)]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	if ("`cens'" == "") `anything' [`weight' `exp'] `if' `in', `robust' 
	if ("`cens'" ~= "") `anything' [`weight' `exp'] `if' `in', cens(`cens') `robust' 
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse' 
			if ("`cens'" == "") capture `anything' [`weight' `exp'] `if' `in', `robust' 
			if ("`cens'" ~= "") capture `anything' [`weight' `exp'] `if' `in', cens(`cens') `robust' 
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
				}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
end


*******************

global cluster = ""

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

use ip\BS1, clear
forvalues i = 2/74 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/74 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapFL, replace


