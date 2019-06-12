
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [,robust cens(string)]
	gettoken testvars anything: anything, match(match)
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

capture program drop mycmd1
program define mycmd1
	syntax anything [aw pw] [if] [in] [,robust cens(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`cens'" == "") {
		quietly `anything' [`weight' `exp'] `if' `in', `robust'
		}
	else {
		quietly `anything' [`weight' `exp'] `if' `in', cens(`cens')
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
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
matrix B = J(260,2,.)

global i = 1
global j = 1

*Table 3 
mycmd (picshowblack $manip) reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack $manip) reg giving picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowb_resb picshowblack $manip) reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1 & ~other, robust
mycmd (picshowb_sib picshowblack $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [pw=tweight] if S == 1 & ~other, robust
mycmd (picshowb_sib picshowblack $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if S == 1 &  white, robust
mycmd (picshowb_sib picshowblack $manipb) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems if S == 1 & black, robust

*Table 4 
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust

*Table 5 
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)
mycmd (picshowblack nraudworthy aud_econdis) reg giving picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)
mycmd (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) oprobit subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) oprobit subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust

*Table 6 
global mycondition="white"
mycmd (int1_picshowb int0_picshowb) interactdd giving ethclosed
mycmd (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 ethclosed
mycmd (int1_picshowb int0_picshowb) interactdd subjsupchar ethclosed
mycmd (int1_picshowb int0_picshowb) interactdd subjsupgov ethclosed
mycmd (int1_picshowb int0_picshowb) interactdd giving soccon_difd
mycmd (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 soccon_difd
mycmd (int1_picshowb int0_picshowb) interactdd subjsupchar soccon_difd
mycmd (int1_picshowb int0_picshowb) interactdd subjsupgov soccon_difd
mycmd (int1_picshowb int0_picshowb) interactdd giving oppblkd
mycmd (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 oppblkd
mycmd (int1_picshowb int0_picshowb) interactdd subjsupchar oppblkd
mycmd (int1_picshowb int0_picshowb) interactdd subjsupgov oppblkd
global mycondition="black"
mycmd (int1_picshowb int0_picshowb) interactdd giving ethclosed
mycmd (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 ethclosed
mycmd (int1_picshowb int0_picshowb) interactdd subjsupchar ethclosed
mycmd (int1_picshowb int0_picshowb) interactdd subjsupgov ethclosed
mycmd (int1_picshowb int0_picshowb) interactdd giving soccon_difd
mycmd (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 soccon_difd
mycmd (int1_picshowb int0_picshowb) interactdd subjsupchar soccon_difd
mycmd (int1_picshowb int0_picshowb) interactdd subjsupgov soccon_difd
mycmd (int1_picshowb int0_picshowb) interactdd giving oppblkd
mycmd (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 oppblkd
mycmd (int1_picshowb int0_picshowb) interactdd subjsupchar oppblkd
mycmd (int1_picshowb int0_picshowb) interactdd subjsupgov oppblkd

generate Strata = (ppethm == 2)
generate N = _n
sort Strata N
generate Order = _n
generate double U = .
mata Y = st_data(.,("picshowblack", "picraceb", "picobscur", "aud_republ", "aud_econdis", "aud_govtben", "aud_prephur", "aud_church", "aud_crime", "aud_helpoth", "aud_contrib", "aud_loot", "cityslidell", "nraudworthy", "var_fullstakes", "var_racesalient", "surveyvariant"))

mata ResF = J($reps,74,.); ResD = J($reps,74,.); ResDF = J($reps,74,.); ResB = J($reps,260,.); ResSE = J($reps,260,.)
forvalues c = 1/$reps {
	matrix FF = J(74,3,.)
	matrix BB = J(260,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort Strata U 
	mata st_store(.,("picshowblack", "picraceb", "picobscur", "aud_republ", "aud_econdis", "aud_govtben", "aud_prephur", "aud_church", "aud_crime", "aud_helpoth", "aud_contrib", "aud_loot", "cityslidell", "nraudworthy", "var_fullstakes", "var_racesalient", "surveyvariant"),Y)

quietly replace picshowb_resb   = picshowblack * black
quietly replace picobscur_resb  = picobscur    * black
quietly replace picraceb_resb   = picraceb     * black
quietly replace picshowb_sib  = picshowblack * subj_iden_blk
quietly replace picraceb_sib  = picraceb     * subj_iden_blk
quietly replace picobscur_sib = picobscur    * subj_iden_blk

global i = 1
global j = 1

*Table 3 
mycmd1 (picshowblack $manip) reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack $manip) reg giving picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowb_resb picshowblack $manip) reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1 & ~other, robust
mycmd1 (picshowb_sib picshowblack $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [pw=tweight] if S == 1 & ~other, robust
mycmd1 (picshowb_sib picshowblack $manip) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if S == 1 &  white, robust
mycmd1 (picshowb_sib picshowblack $manipb) reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems if S == 1 & black, robust

*Table 4 
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust

*Table 5 
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)
mycmd1 (picshowblack nraudworthy aud_econdis) reg giving picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)
mycmd1 (picshowblack nraudworthy aud_econdis) reg hypgiv_tc500 picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) oprobit subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupchar picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) oprobit subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
mycmd1 (picshowblack nraudworthy aud_econdis) reg subjsupgov picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust

*Table 6 
global mycondition="white"
mycmd1 (int1_picshowb int0_picshowb) interactdd giving ethclosed
mycmd1 (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 ethclosed
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupchar ethclosed
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupgov ethclosed
mycmd1 (int1_picshowb int0_picshowb) interactdd giving soccon_difd
mycmd1 (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 soccon_difd
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupchar soccon_difd
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupgov soccon_difd
mycmd1 (int1_picshowb int0_picshowb) interactdd giving oppblkd
mycmd1 (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 oppblkd
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupchar oppblkd
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupgov oppblkd
global mycondition="black"
mycmd1 (int1_picshowb int0_picshowb) interactdd giving ethclosed
mycmd1 (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 ethclosed
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupchar ethclosed
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupgov ethclosed
mycmd1 (int1_picshowb int0_picshowb) interactdd giving soccon_difd
mycmd1 (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 soccon_difd
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupchar soccon_difd
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupgov soccon_difd
mycmd1 (int1_picshowb int0_picshowb) interactdd giving oppblkd
mycmd1 (int1_picshowb int0_picshowb) interactdd hypgiv_tc500 oppblkd
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupchar oppblkd
mycmd1 (int1_picshowb int0_picshowb) interactdd subjsupgov oppblkd

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..74] = FF[.,1]'; ResD[`c',1..74] = FF[.,2]'; ResDF[`c',1..74] = FF[.,3]'
mata ResB[`c',1..260] = BB[.,1]'; ResSE[`c',1..260] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/74 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/260 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherRedFL, replace










