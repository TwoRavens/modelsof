/* Analysis.do implements the statistical estimation for the DK Asset Integration Paper */

**************************************************************
*  GENERATE SUMMARY STATISTICS OF LOTTERIES RESPONSES
**************************************************************	

* get data 
	use Data, clear
		
/* ONLY RUN ON SERVER 		
	log using ToMove/SampleSums.log, text replace name(table2)	
**************************************************************
*  GENERATE SUMMARY STATISTICS OF COMPARABLE SAMPLE STATED IN THE TEXT
**************************************************************	
	use Data, clear
	keep pnr
	duplicates drop
	generate insample = 1
	merge m:1 pnr using TempData/DataReg
	egen inmun = max(insample), by(kom)
	drop if inmun~=1 |  age<18 
	global sumvarlist "assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_net wealth_T"
	global demog2 "male age married hsize income"

	replace insample = 0 if insample==.
	tabstat $demog2, by(insample)	stats(mean sd) nototal col(stat) longstub
	tabstat $sumvarlist, by(insample)	stats(mean sd)  nototal col(stat) longstub 
	
	foreach x of global demog2  {
		ttest `x', by(insample)
	} 

	foreach x of global sumvarlist {
		ttest `x', by(insample)
	} 
log close table2

*/


log using ToMove/Table1.log, text replace name(table1)
		
***********************************************
*  TABLE 1: SUMMARY STATISTICS
***********************************************	
	
	* keep one observation per subject
		use Data, replace		
		
		* Do medians
		qui foreach y of global sumvarlist {
		capture drop ave seqN_ seqM insample_
		local wider = 0
		local span  = 0
		local stats=0
		qui summ `y', detail
		local `y'_m = r(mean)
		local `y'_sd = r(sd)
		local median = r(p50)
		generate ave = 0
		while `wider' == 0 {
			* noi display "span `span'"
			replace ave = 1 if abs(`y'-`median') < 1 + `span'
			count if ave == 1
			if r(N) >= 1 {			
				local wider = 1
			}
			else {
				local span = `span' + 1000			
			}
		}
		sort `y'
		egen seqN_ = seq() if ave==1
		egen seqM = median(seqN_)
		replace seqM = floor(seqM) if seqN~=.
		replace ave=0 if seqN_~=seqM
		gen insample_ = ave
		sort `y'
		replace insample_ = 1 if ave[_n+2]==1
		replace insample_ = 1 if ave[_n+1]==1
		replace insample_ = 1 if ave[_n-1]==1
		replace insample_ = 1 if ave[_n-2]==1
		qui summ `y' if insample_==1
		local stats_=r(mean)
		local stats = `stats_'
		noi display "Median for `y' is calculated to be `stats' with s `span'"
		local `y'_median = r(mean)
		
	  }	

		* now generate data to export
		clear
		set obs 1
		generate mean =.
		generate median =.
		generate sd =.
		generate name =""
		local i = 1
		qui foreach y of global sumvarlist {
			
			replace name = "`y'" if name==""
			replace mean = ``y'_m' if mean==.
			replace median = ``y'_median' if median==.
			replace sd = ``y'_sd' if sd==.
			
			local i = `i' +1
			set obs +`i'
		}	
		export excel using ToMove/Table1, replace firstrow(variables)
		
	log close table1
	
**********************************************
*  FIGURE 1: SIMPLE RESPONSES TO THE LOTTERIES
***********************************************		
	use Data, replace
	
	* Reshape and clean up data for lab wealth purposes
	forvalues i = 1/4 {
	generate prize`i'L = VPRIZEA`i'
	generate prize`i'R = VPRIZEB`i'
	generate prob`i'L = probA`i'
	generate prob`i'R = probB`i'
}
	drop VPRIZEA* VPRIZEB* probA* probB*

	* Flag he calibration lotteries
	generate int wilcox=0
	replace wilcox= 1 if substr(qid,1,3)=="wil" | substr(qid,1,4) =="swil"

	* only keep the calibration lotteries
	keep if wilcox==1

	* subject id
	egen int  sid = group(pnr)

	* be sore to have recrod = 1 for this sample
	capture: drop record
	bysort pnr: egen int record = seq()
	tab record

	* rename choice
	label variable choice "Decision choice (0 is lef, 1 is right)"
	tab choice, missing

	* get EV
	generate evL = 0
	generate evR = 0

	forvalues x=1/4 {
		replace evL = evL + prob`x'L*prize`x'L
		replace evR = evR + prob`x'R*prize`x'R
	}

	* get EV of choices
	generate ev = evR*choice
	replace ev = ev+evL if choice==0
	bysort sid: egen evSUM = total(ev)
	generate evDIFF = evL - evR
	bysort qid: summ evDIFF

	* set up variables
	generate w = prize4L
	label variable w "Lab wealth"
	generate evdiff = evR-evL

	sort sid w
	bysort sid: egen int lott= seq()

	generate x = prize3R - w
	generate y = prize4R - w

	tab w, missing

	* lab wealth
	generate LabW = prize4L
	label variable LabW "Value of the certain prize"

	* prize differential
	generate int diff = prize4R - prize3R
	label variable diff "Difference in risky prizes"

	generate int Pgain = prize4R - prize4L
	generate int Ploss = prize3R-prize4L

	tab LabW diff, missing
	tab LabW Pgain
	tab LabW Ploss
	tab LabW evR

	generate int choiceL = 1- choice
	label variable choiceL "Chooses left, safe lottery"

	* predict the safe choice
	generate int safe = 1 - choice
	label variable safe "Chooses the safe lottery"

	* quadratic in w
	generate w2 = w*w
	generate w3 = w2*w

	* id for comparison to other data
	generate int id = sid

	* keep what is neeeded
	keep record lott choiceL LabW safe id sid w w2 w3 diff Pgain Ploss evL evR evdiff

	* picture the lotteries
	bysort w Pgain Ploss: egen int type = seq()

	generate str30 pair = ""
	foreach Pg in 90 135 160 180 240 320 {
		foreach Pl in -300 -225 -160 -150 -120 -80 {
			replace pair = "+`Pg'/`Pl'" if Pgain == `Pg' & Ploss == `Pl'
		
		}
	}

	compress pair
	tab pair if type==1

	generate int Npair=.
	replace Npair = 1 if pai =="+90/-80"
	replace Npair = 2 if pai =="+135/-120"
	replace Npair = 3 if pai =="+160/-150"
	replace Npair = 4 if pai =="+180/-160"
	replace Npair = 5 if pai =="+240/-225"
	replace Npair = 6 if pai =="+320/-300"

	label define gl 1 "+90/-80" 2 "+135/-120" 3 "+160/-150" 4  "+180/-160" 5 "+240/-225" 6 "+320/-300"
	label values Npair gl

	* Random effects probil --- panel, but parametric
	xtset id
	xtprobit choiceL *w w2 w3, re
	predictnl Psafe_xt = predict(pu0), p(PsafeP_xt) ci(PsafeLO_xt PsafeHI_xt) level(95)
	tabstat safe PsafeLO PsafeHI Psafe_xt PsafeLO_xt PsafeHI_xt, stat(mean)
	tabstat safe PsafeLO PsafeHI Psafe_xt PsafeLO_xt PsafeHI_xt, stat(mean) by(w)

	* collaspse for picture
	summ sid if record==1
	local nobs = r(N)
	collapse (mean) safe Psafe_xt PsafeLO_xt PsafeHI_xt, by(w)
	sort w
	twoway (rarea PsafeHI_xt PsafeLO_xt w, sort fcolor(gs14) lcolor(gs14)) (connected Psafe_xt w, sort msize(large) msymbol(circle) lcolor(red) lwidth(thick) connect(direct)), ytitle("Probability" "of a safe" "Choice") ytitle(, size(large) orientation(horizontal)) yline(0.5, lwidth(medthick) lpattern(dash) lcolor(blue)) ylabel(0(0.25)1, labsize(large) angle(horizontal)) xtitle(Lab Wealth) xtitle(, size(large)) xlabel(0(500)3000, labsize(large)) title("Figure 1: Predicted Probability of a" "Risk Averse Choice by Adult Danes" "at Varying Levels of Lab Wealth", size(vlarge)) subtitle("N=`nobs' subjects each making 6 choices for varying lab wealth" "Predictions from a Random Effects Panel Probit model", size(medium)) legend(off) saving(ToMove\AI_figure1, replace)                                                                        
	
log using ToMove/LogTable2.log, text replace name(log1)	
***********************************************
*  TABLE 2: ESTIMATION OF CRRA EUT MODELS
***********************************************	

* get data
	use Data, clear	
	qui tab choice 
	global nLL = r(N)
	generate ll = 0
		
	* Scale all monetary amounts
	global scale 		"10000" 
	* Set the models to contextual
	global contextual 	"y"
	* Set constant on the omega level to help it converge (still bounded omega>0)
	global high 	  	"0.1"
	
	/* LOG PROVIDED FOR SERVER ESTIMATIONS IN ServerLogs directory 	*/
** NO ASSET INTEGRATION - GET LL VALUE **
	ml model lf ML_crra_NAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 = ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0.50 -2, copy) tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace
	nlcom (r: [r]_cons) (mu: exp([LNmu]_cons)) 
	eststo s1
	ml display
			
** FULL ASSET INTEGRATION - GET LL VALUE **
	ml model lf ML_crra_FAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T = ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0.2 -1, copy)  search(off)  tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace
	nlcom (r: [r]_cons) (mu: exp([LNmu]_cons)) 
	eststo s2
	ml display	

	matrix pe = e(b)
	matrix list pe
	matrix cov = e(V)
	matrix list cov
	
** TABLE 2: PARTIAL ASSET INTEGRATION **
	matrix start_1 = 0.8, -2, -1.5, -2.5
	set seed 1001
	ml model lf ML_crra_PAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T = ) (LNmu: ) (LNrho: ) (LNomega: ) , cluster(pnr) missing maximize technique(nr) difficult init(start_1, copy)  tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance negh
	nlcom (r: [r]_cons) (omega: $high * exp([LNomega]_cons)) (rho: 1-exp([LNrho]_cons)) (sigma: 1/(exp([LNrho]_cons))) (mu: exp([LNmu]_cons))  	 	
	ml display
	eststo s3
	
	local r = [r]_cons
	local omega = $high * exp([LNomega]_cons)
	local rho = 1-exp([LNrho]_cons)
	local sigma = 1/(exp([LNrho]_cons))
	
	display "omage estimated to `omega'"
	display "sigma estimated to `sigma'"
	
	testnl 1/(exp([LNrho]_cons)) = 1
	testnl 1/(exp([LNrho]_cons)) = 0
	testnl 		$high * exp([LNomega]_cons) = 1
	testnl 		$high * exp([LNomega]_cons) = 0	
	testnl (1/exp([LNrho]_cons) = 0) (($highexp([LNomega]_cons = 0)))
	
	matrix pe = e(b)
	matrix list pe
	matrix cov = e(V)
	matrix list cov

	esttab s3 using ToMove/Table2A.txt, replace label scalars(ll) se  nolabel b(3) star(* 0.10 ** 0.05 *** 0.01)	
	
	log close log1
	
	log using ToMove/ObservedHet.log, text replace name(log1)
	*************************************************
	* OBSERVED HETEROGENIETY CHECK ON NO ASSET INTEGRATION MODLE
	*************************************************	
			
	* get data
	* Generate dummy for the wealthiest 25%
	use Data, clear
	keep pnr wealth_T assets_* liab_* wealth_* income
	duplicates drop
	qui summ wealth_T, detail
	local q4 = r(p75)
	generate q4 = (wealth_T>`q4')
	
	generate net_estates = assets_realesta - liab_mortgage
	generate net_deposits =  assets_banks - liab_bankdebt
	generate net_financial =  assets_stocks + assets_bond	 - liab_private 
	generate net_pension = assets_pension 
	generate net_cars = assets_cars 
	generate net_income = income
	
	foreach x in net_estates net_deposits net_financial  net_pension  net_cars net_income {
		replace `x' = `x'/1000000 	
	}
	
	generate net_wealthS = wealth_net/1000000	
	
	keep pnr q4 net_estates net_deposits net_financial net_pension net_cars net_wealthS net_income
	
	save TempData/controls, replace
	
	use Data, clear
	drop _merge
	merge m:1 pnr using TempData/controls
	generate ll = 0
	generate age2 = age*age
	generate net_income2 = net_income*net_income
	
	/* LOG PROVIDED FOR SERVER ESTIMATIONS IN ServerLogs directory 	*/
	** NO ASSET INTEGRATION BASELINE MODEL **
	ml model lf ML_crra_NAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 = ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0.50 -2, copy) tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance 
	nlcom (r: [r]_cons) (mu: exp([LNmu]_cons)) 
	eststo r1
	ml display

	* Contol of risk aversion on net wealth in millions
	label variable net_wealthS "Net wealth in millions"
	ml model lf ML_crra_NAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 = net_wealthS) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0 0.50 -2, copy) tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance
	nlcom (mu: exp([LNmu]_cons)) 
	eststo r2
	ml display
	
	* Contol of risk aversion on the highestnet wealht  25% individuals
	label variable q4 "Highest 25% wealth"
	ml model lf ML_crra_NAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 = q4) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0 0.50 -2, copy) tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance
	nlcom (r_q4: [r]q4)  (r: [r]_cons) (mu: exp([LNmu]_cons)) 
	eststo r3
	ml display
		
	* Contol of risk aversion on composition of wealth
	ml model lf ML_crra_NAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 = ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0.50 -2, copy) tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance 
	ml model lf ML_crra_NAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 = net_estates net_deposits net_financial net_pension net_cars ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance
	nlcom (mu: exp([LNmu]_cons)) 
	test ([r]net_estates=0) ([r]net_deposits=0) ([r]net_deposits=0) ([r]net_financial=0) ([r]net_pension=0) (net_cars=0)
	eststo r4
	ml display
	
	* Contol of risk aversion on composition of wealth and demographics
	ml model lf ML_crra_NAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 = net_estates net_deposits net_financial net_pension net_cars $demog ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance
	test ([r]net_estates=0) ([r]net_deposits=0) ([r]net_deposits=0) ([r]net_financial=0) ([r]net_pension=0) (net_cars=0)	
	test ([r]age=0) ([r]age2=0) 
	test ([r]age=0) ([r]age2=0)  ([r]male=0)  ([r]married=0) ([r]hsize=0) ([r]net_income=0) ([r]net_income2=0)
	test ([r]age=0) ([r]age2=0)  ([r]male=0)  ([r]married=0) ([r]hsize=0) ([r]net_income=0) ([r]net_income2=0) ([r]net_estates=0) ([r]net_deposits=0) ([r]net_deposits=0) ([r]net_financial=0) ([r]net_pension=0) (net_cars=0)
	nlcom (mu: exp([LNmu]_cons)) 
	eststo r5
	ml display
		
	log close log1	
	
	log using ToMove/LogTable3.log, text replace name(log1)
***********************************************
*  TABLE 3: ESTIMATION OF CRRA RDEU MODELS
***********************************************		
	
	* GET DATA
	use Data, clear	
	qui tab choice 
	global nLL = r(N)
	generate ll = 0
	set seed 1001
	
	* initially set estimation to EUT
	constraint define 1 [gamma]_cons=1
	
	* Make sure data is cleaned up for speed of estimation
	foreach x in A B {
		foreach y in 1 2 3 4 {
			generate int Iprob`x'`y' = round(prob`x'`y'*100)
		}		
	}
	foreach x in A B {
		foreach y in 1 2 3 4 {
			replace Iprob`x'`y' = Iprob`x'`y'/100
		}		
	}
	constraint define 2 [LNphi]_cons= 0
	
	/* LOG PROVIDED FOR SERVER ESTIMATIONS IN ServerLogs directory 	*/ 
	
	* NO ASSET INTEGRATION ON CONSTRAINED 1-COEF PRELEC
	ml model lf ML_crra_NAI_P1 (r: choice IprobA1 IprobA2 IprobA3 IprobA4 IprobB1 IprobB2 IprobB3 IprobB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0.5 0 -2, copy) tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace   const(2)
	* let go of phi
	ml model lf ML_crra_NAI_P1 (r: choice IprobA1 IprobA2 IprobA3 IprobA4 IprobB1 IprobB2 IprobB3 IprobB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue 			tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace   
	* NO ASSET INTEGRATION ON UNCONSTRAINED 2-COEF PRELEC
	ml model lf ML_crra_NAI_P (r: choice IprobA1 IprobA2 IprobA3 IprobA4 IprobB1 IprobB2 IprobB3 IprobB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: ) (LNeta: )  (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue 	tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace   
	nlcom (r: [r]_cons) (phi: exp([LNphi]_cons))  (eta: exp([LNeta]_cons)) (mu: exp([LNmu]_cons)) 
	ml display
	eststo s7
	
	* FULL ASSET INTEGRATIONON CONSTRAINED 1-COEF PRELEC
	ml model lf ML_crra_FAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: )  (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0.1 0 -2, copy) 	tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace const(2)
	* let go of phi
	ml model lf ML_crra_FAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: )  (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue 				tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace 
	* FULL ASSET INTEGRATIONON ON UNCONSTRAINED 2-COEF PRELEC
	ml model lf ML_crra_FAI_P (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = )  (LNphi: )  (LNeta: )  (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue 	tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)
	nlcom (r: [r]_cons) (phi: exp([LNphi]_cons))  (eta: exp([LNeta]_cons)) (mu: exp([LNmu]_cons)) 
	eststo s8
	
	* TABLE 3: PARTIAL ASSET INTEGRATION ON CONSTRAINED 1-COEF PRELEC - UNCONSTRAINED
	matrix start_1 = 0.8, 0, -2, -1.5, -2.5
	ml model lf ML_crra_PAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)  (LNphi: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult init(start_1, copy) tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)	 const(2)
	* let go of phi - UNCONSTRAINED
	ml model lf ML_crra_PAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)  (LNphi: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult continue tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)	 
	* PARTIAL ASSET INTEGRATION ON UNCONSTRAINED 2-COEF PRELEC - UNCONSTRAINED
	ml model lf ML_crra_PAI_P (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)   (LNphi: )  (LNeta: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult continue tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)	  negh hess 
	ml display
	nlcom (r: [r]_cons) (omega: $high * exp([LNomega]_cons)) (rho: 1-exp([LNrho]_cons)) (sigma: 1/(exp([LNrho]_cons))) (phi: exp([LNphi]_cons))  (eta: exp([LNeta]_cons)) (mu: exp([LNmu]_cons)) 
	ml display
	eststo s10
	
	local r = [r]_cons
	local omega = $high * exp([LNomega]_cons)
	local rho = 1-exp([LNrho]_cons)
	local sigma = 1/exp([LNrho]_cons)
	local eta = exp([LNeta]_cons)
	local phi = exp([LNphi]_cons)
	display "omaga estimated to `omega'"
	display "sigma estimated to `sigma'"

	testnl 1/(exp([LNrho]_cons)) = 1
	testnl 1/(exp([LNrho]_cons)) = 0
	testnl 		$high * exp([LNomega]_cons) = 1
	testnl 		$high * exp([LNomega]_cons) = 0	
	testnl (1/exp([LNrho]_cons) = 0) (($highexp([LNomega]_cons = 0)))
	testnl (exp([LNphi]_cons = 1)) ((exp([LNeta]_cons) = 1))

	esttab s10 using ToMove/Table3A.txt, replace label scalars(ll) se  nolabel b(3) star(* 0.10 ** 0.05 *** 0.01)	
	
	log close log1
	
****************************************************************************'
* APPENDIX A: 
****************************************************************************		
	
log using ToMove/AppendixAFigures.log, text replace name(log1)	
****************************************************************************'
* APPENDIX A: FIGURE
****************************************************************************		

use Data, clear
* get EV 
des pr*
generate evA = 0
generate evB = 0
forvalues x = 1(1)4 {
	replace evA = evA + probA`x'*VPRIZEA`x'
	replace evB = evB + probB`x'*VPRIZEB`x'

}

summ ev*

* assume choice is choic of B
generate int choiceB = choice
replace choiceB = 1 - choiceB if substr(qid, 1,2 ) =="ls"

*Fraction choosing b
bysort qid: egen fractionB = mean(choiceB)

* EV difference
generate evDIFF = evA- evB
sort evDIFF

* save data before collapsing 
save TempData/temp, replace

* Collapse to do aggregate graph
collapse (mean) evDIFF fractionB, by(qid)
sort evDIFF
list qid evDIFF fractionB, noobs

twoway (lpolyci fractionB evDIFF), ///
ytitle("Fraction" "Choosing" "OptionB") ///
ytitle(, orientation(horizontal)) ///
ylabel(, labsize(medlarge) angle(horizontal)) ///
xtitle(EV of Option A Minus EV of Option B) ///
xtitle(, size(medlarge)) ///
ylabel(0(0.25)1) ///
scheme(s1color) ///
legend(off) ///
xline(0) ///
title("Figure A1: Relationship Between EV Difference" "and Raw Choice Probabilities") ///
legend(off) saving(ToMove/figureA1, replace)  

* At wealth level
use TempData/temp, replace
qui sum wealth_net, detail
generate wealthG = ""
replace  wealthG = "1. Lowest 25% Wealth"  if wealth_net<r(p25)
replace  wealthG = "2. Mid 25-50% Wealth"  if wealth_net>r(p25) & wealth_net<r(p50)
replace  wealthG = "3. Mid 50-75% Wealth"  if wealth_net>r(p50) & wealth_net<r(p75)
replace  wealthG = "4. Highest 25% Wealth" if wealth_net>r(p75)
collapse (mean) evDIFF fractionB, by(qid wealthG)
sort wealthG evDIFF
list wealthG qid evDIFF fractionB, noobs

twoway (lpolyci fractionB evDIFF),  by(wealthG, legend(off) note("")) ///
ytitle("Fraction" "Choosing" "OptionB") ///
ytitle(, orientation(horizontal)) ///
ylabel(, labsize(medlarge) angle(horizontal)) ///
xtitle(EV of Option A Minus EV of Option B) ///
xtitle(, size(medlarge)) ///
legend(off) ///
ylabel(0(0.25)1) ///
title("") ///
legend(off) saving(raw_choices, replace)  scheme(s1color)	
graph combine raw_choices.gph, title("Figure A2: Relationship Between EV Difference" "and Raw Choice Probabilities") ///
saving(ToMove/figureA2, replace) scheme(s1color)	
log close log1
	
log using ToMove/AppendixATables.log, text replace name(log1)	

**************************************************************
*  APPENDIX A: TABLES 
**************************************************************	

use Data, clear	
keep VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 qid probA1 probB1 probA2 probB2 probA3 probB3 probA4 probB4 sampleIDX 
duplicates drop
sort sampleIDX qid VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 
egen scale = seq(), by(sampleIDX qid)
egen lotteryN = seq() , by(sampleIDX scale)
drop VPRIZEA1 VPRIZEB1 probA1 probB1
foreach x in 1 2 3 {
	local xx  = `x' +1
	foreach y in A B {	
		foreach z in prob {
			rename `z'`y'`xx'  `z'`y'`x'
		}
		foreach z in VPRIZE {
			rename `z'`y'`xx'  prize`y'`x'
		}
	}	
}

** FIRST EXPERIMENT 
* Low stake lotteries
list qid prizeA1 probA1 prizeA2 probA2 prizeA3 probA3 prizeB1 probB1 prizeB2 probB2 prizeB3 probB3 if sampleIDX==1 & scale==1, noobs

* mid stake lotteries 
list qid prizeA1 probA1 prizeA2 probA2 prizeA3 probA3 prizeB1 probB1 prizeB2 probB2 prizeB3 probB3 if sampleIDX==1 & scale==2, noobs

* High stake lotteries 
list qid prizeA1 probA1 prizeA2 probA2 prizeA3 probA3 prizeB1 probB1 prizeB2 probB2 prizeB3 probB3 if sampleIDX==1 & scale==3, noobs

** SECOND EXPERIMENT	
* Second round sample of 222  individuals
list qid prizeA1 probA1 prizeA2 probA2 prizeA3 probA3 prizeB1 probB1 prizeB2 probB2 prizeB3 probB3 if sampleIDX==3 & scale==1, noobs

* Now do lottery prizes with probabilities
foreach x in 1 2 3 {
	local xx  = `x' +3
	foreach y in B {	
		foreach z in prob {
			rename `z'`y'`x'  `z'A`xx'
		}
		foreach z in prize {
			rename `z'`y'`x'  prizeA`xx'
		}
	}	
}
egen obs = seq()
reshape long prizeA probA, i(obs) j(prizeN)
drop if prob==.
rename prizeA prize
renam probA prob
drop if prob==0
save TempData/temp, replace

* List overall prizes 
tab prize
* count different prizes
egen prizeG = group(prize)
qui summ prizeG
local prizeGN = r(max)
display "There are `prizeGN' different  prizes"

* List overall probabilities
tab prob
* count different prizes
egen probG = group(prob)
qui summ probG
local probGN = r(max)
display "There are `probGN' different probabilities"

* First experiment
* Prizes of scale 1
use TempData/temp, clear
keep if scale ==1 & sampleIDX==1
* List overall prizes 
tab prize
* count different prizes
egen prizeG = group(prize)
qui summ prizeG
local prizeGN = r(max)
display "There are `prizeGN' different  prizes"

* Prizes of scale 2
use TempData/temp, clear
keep if scale ==2 & sampleIDX==1
* List overall prizes 
tab prize
* count different prizes
egen prizeG = group(prize)
qui summ prizeG
local prizeGN = r(max)
display "There are `prizeGN' different  prizes"

* Prizes of scale 3
use TempData/temp, clear
keep if scale ==3 & sampleIDX==1
* List overall prizes 
tab prize
* count different prizes
egen prizeG = group(prize)
qui summ prizeG
local prizeGN = r(max)
display "There are `prizeGN' different  prizes"

* List overall probabilities
tab prob
* count different prizes
egen probG = group(prob)
qui summ probG
local probGN = r(max)
display "There are `probGN' different probabilities"

* Second experiment
use TempData/temp, clear
keep if sampleIDX==3

* List overall prizes 
tab prize
* count different prizes
egen prizeG = group(prize)
qui summ prizeG
local prizeGN = r(max)
display "There are `prizeGN' different prizes"

* List overall probabilities
tab prob
* count different prizes
egen probG = group(prob)
qui summ probG
local probGN = r(max)
display "There are `probGN' different probabilities"

log close log1

*******************************************************
* APPENDIX B: 
*******************************************************

log using AppendixB_Figures, text replace name(log1)
*******************************************************
* APPENDIX B: FIGURES GET NUMBERS FOR THE WEIGTING FUNCTIONS
*******************************************************

	* estimate models to get coefficients
	use Data, clear	
	qui tab choice 
	global nLL = r(N)
	generate ll = 0
	set seed 1001
	
	* initially set estimation to EUT
	constraint define 1 [gamma]_cons=1
	
	* Make sure data is cleaned up for speed of estimation
	foreach x in A B {
		foreach y in 1 2 3 4 {
			generate int Iprob`x'`y' = round(prob`x'`y'*100)
		}		
	}
	foreach x in A B {
		foreach y in 1 2 3 4 {
			replace Iprob`x'`y' = Iprob`x'`y'/100
		}		
	}
	constraint define 2 [LNphi]_cons= 0
	
	* NO ASSET INTEGRATION ON CONSTRAINED 1-COEF PRELEC
	qui ml model lf ML_crra_NAI_P1 (r: choice IprobA1 IprobA2 IprobA3 IprobA4 IprobB1 IprobB2 IprobB3 IprobB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0.5 0 -2, copy) tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace   const(2)
	* let go of phi
	qui ml model lf ML_crra_NAI_P1 (r: choice IprobA1 IprobA2 IprobA3 IprobA4 IprobB1 IprobB2 IprobB3 IprobB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: ) (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue 			tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace   
	* NO ASSET INTEGRATION ON UNCONSTRAINED 2-COEF PRELEC
	qui ml model lf ML_crra_NAI_P (r: choice IprobA1 IprobA2 IprobA3 IprobA4 IprobB1 IprobB2 IprobB3 IprobB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: ) (LNeta: )  (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue 	tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace   
	local etaN = exp([LNeta]_cons)
	local phiN = exp([LNphi]_cons)
	display "Eta estimated to `etaN' under the NO-ASSET INTEGRATION"
	display "Phi estimated to `phiN' under the NO-ASSET INTEGRATION"
	
	* FULL ASSET INTEGRATIONON CONSTRAINED 1-COEF PRELEC
	qui ml model lf ML_crra_FAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: )  (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult init(0.1 0 -2, copy) 	tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace const(2)
	* let go of phi
	qui ml model lf ML_crra_FAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = ) (LNphi: )  (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue 				tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace 
	* FULL ASSET INTEGRATIONON ON UNCONSTRAINED 2-COEF PRELEC
	qui ml model lf ML_crra_FAI_P (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  = )  (LNphi: )  (LNeta: )  (LNmu: ) , cluster(pnr) missing maximize technique(nr) difficult continue 	tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)
	local etaF = exp([LNeta]_cons)
	local phiF = exp([LNphi]_cons)
	display "Eta estimated to `etaF' under the FULL-ASSET INTEGRATION"
	display "Phi estimated to `phiF' under the FULL-ASSET INTEGRATION"
	
	* PARTIAL ASSET INTEGRATION ON CONSTRAINED 1-COEF PRELEC - UNCONSTRAINED
	matrix start_1 = 0.8, 0, -2, -1.5, -2.5
	qui ml model lf ML_crra_PAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)  (LNphi: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult init(start_1, copy) tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)	 const(2)
	* let go of phi - UNCONSTRAINED
	qui ml model lf ML_crra_PAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)  (LNphi: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult continue tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)	 
	* PARTIAL ASSET INTEGRATION ON UNCONSTRAINED 2-COEF PRELEC - UNCONSTRAINED
	qui ml model lf ML_crra_PAI_P (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)   (LNphi: )  (LNeta: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult continue tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)	  negh hess 
	local etaP = exp([LNeta]_cons)
	local phiP = exp([LNphi]_cons)
	display "Eta estimated to `etaP' under the PARTIAL-ASSET INTEGRATION"
	display "Phi estimated to `phiP' under the PARTIAL-ASSET INTEGRATION"
	
log close log1	
	
log using ToMove/AppendixB_Figures.log, text replace name(log1)
*******************************************************
* APPENDIX B: FIGURES 
*******************************************************

* FIGURE B3
clear
set obs 1

* initial picture of pwf
local phi = 0.8632939
local eta = 0.9638748
local phi_ = string(`phi', "%3.2f")
local eta_ = string(`eta', "%3.2f")
graph twoway function y = exp( (-`eta') * (-ln(x) )^`phi'), clpattern(dash) clwidth(thick) clcolor(blue) || function y=x, clpattern(solid) clcolor(black) legend(off) ytitle("{&omega}(p)   ", orient(horizontal) size(vlarge)) xtitle("p", size(vlarge)) ylabel(0(.1)1, nogrid angle(horizontal)) xlabel(0(.1)1, nogrid angle(horizontal)) xline(0.5) yline(0.5) xsize(1) ysize(1) saving(TempData/tmp1G, replace)

* now calculate the decision weights for uniform-probability lottery
* look at probability weights for various settings
foreach ncases in 7 6 5 4 3 2 {

qui {

local inc=100/`ncases'

forvalues x=0/100 {
    generate p`x'=.
    generate prob`x'=.
}

forvalues x=0(`inc')100 {
    local xx=round(`x',1)
    local xxx=`x'/100
    replace p`xx' = (exp( (-`eta') * (-ln(`xxx') )^`phi'))
    replace prob`xx'=`x'/100
}
replace p0=0
replace p100=1
replace prob0=0
replace prob100=1

summ
generate row=1
reshape long p prob, i(row) j(pr)
drop if prob==.

generate p_inc=p[_n]-p[_n-1]
drop if p_inc==.

egen prizesG=seq(), from(`ncases') to(1)
egen prizesL=seq(), from(1) to(`ncases')
generate ncases=`ncases'

}

list prizesG prizesL prob p p_inc ncases, noobs
save TempData/prob`ncases', replace

drop if prizesG>1
drop row p prob p_inc ncases prizesG prizesL pr
set obs 1

}

* collate
use TempData/prob2, clear
foreach ncases in 7 6 5 4 3 {
    append using TempData/prob`ncases'
    erase TempData/prob`ncases'.dta
}
erase TempData/prob2.dta

tab ncases
tab prizesG

summ ncases
local Nprizes=r(max)
drop if prizesG>`Nprizes'

* get some EUT lines
generate p_incEUT = 1/ncases
local text "Worst to Best"
twoway (connected p_incEUT prizesG if ncases==3, clpattern(solid) clcolor(black) mcolor(black)) (connected p_inc prizesG if ncases==3, clpattern(dash) clwidth(thick) clcolor(blue) mcolor(blue)), ytitle("Decision" "Weight", size(large) orientation(horizontal)) ylabel(0(.1)0.5, angle(horizontal)) xtitle(Prize (`text'), size(large)) xlabel(1(1)3) legend(off) saving(TempData/tmp2G, replace)
gr combine TempData/tmp1G.gph TempData/tmp2G.gph, title("Figure B3: Probability Weighting and Decision Weights" "for Baseline Wealth Between 10,000 kroner and 100,000 kroner") subtitle("RDU Estimates: {&eta}=`eta_',  {&phi}=`phi_'") saving(ToMove/AI_figureB3, replace) imargin(tiny)

* clean up
erase TempData/tmp1G.gph
erase TempData/tmp2G.gph

* FIGURE B4


clear
set obs 1

* initial picture of pwf
local phi = 1.015689 
local eta = 0.9414583
local phi_ = string(`phi', "%3.2f")
local eta_ = string(`eta', "%3.2f")
graph twoway function y = exp( (-`eta') * (-ln(x) )^`phi'), clpattern(dash) clwidth(thick) clcolor(blue) || function y=x, clpattern(solid) clcolor(black) legend(off) ytitle("{&omega}(p)   ", orient(horizontal) size(vlarge)) xtitle("p", size(vlarge)) ylabel(0(.1)1, nogrid angle(horizontal)) xlabel(0(.1)1, nogrid angle(horizontal)) xline(0.5) yline(0.5) xsize(1) ysize(1) saving(TempData/tmp1G, replace)


* now calculate the decision weights for uniform-probability lottery

* look at probability weights for various settings
foreach ncases in 7 6 5 4 3 2 {

qui {

local inc=100/`ncases'

forvalues x=0/100 {
    generate p`x'=.
    generate prob`x'=.
}

forvalues x=0(`inc')100 {
    local xx=round(`x',1)
    local xxx=`x'/100
    replace p`xx' = (exp( (-`eta') * (-ln(`xxx') )^`phi'))
    replace prob`xx'=`x'/100
}
replace p0=0
replace p100=1
replace prob0=0
replace prob100=1

summ
generate row=1
reshape long p prob, i(row) j(pr)
drop if prob==.

generate p_inc=p[_n]-p[_n-1]
drop if p_inc==.

egen prizesG=seq(), from(`ncases') to(1)
egen prizesL=seq(), from(1) to(`ncases')
generate ncases=`ncases'

}

list prizesG prizesL prob p p_inc ncases, noobs
save TempData/prob`ncases', replace

drop if prizesG>1
drop row p prob p_inc ncases prizesG prizesL pr
set obs 1

}

* collate
use TempData/prob2, clear
foreach ncases in 7 6 5 4 3 {
    append using TempData/prob`ncases'
    erase TempData/prob`ncases'.dta
}
erase TempData/prob2.dta

tab ncases
tab prizesG

summ ncases
local Nprizes=r(max)
drop if prizesG>`Nprizes'

* get some EUT lines
generate p_incEUT = 1/ncases

local text "Worst to Best"

twoway (connected p_incEUT prizesG if ncases==3, clpattern(solid) clcolor(black) mcolor(black)) (connected p_inc prizesG if ncases==3, clpattern(dash) clwidth(thick) clcolor(blue) mcolor(blue)), ytitle("Decision" "Weight", size(large) orientation(horizontal)) ylabel(0(.1)0.5, angle(horizontal)) xtitle(Prize (`text'), size(large)) xlabel(1(1)3) legend(off) saving(TempData/tmp2G, replace)

gr combine TempData/tmp1G.gph TempData/tmp2G.gph, title("Figure B4: Probability Weighting and Decision Weights" "for Baseline Wealth Between 100,000 kroner and 500,000 kroner") subtitle("RDU Estimates: {&eta}=`eta_',  {&phi}=`phi_'") saving(ToMove/AI_figureB4, replace) imargin(tiny)

* clean up
erase TempData/tmp1G.gph
erase TempData/tmp2G.gph

log close log1

*******************************************************
* APPENDIX C: 
*******************************************************

log using ToMove/AppendixC_Figures.log, text replace name(log1)
*******************************************************
* APPENDIX C: FIGURES
*******************************************************

clear
set obs 1

* curvature of utility function
local r = 0.48
local r_ = string(`r', "%3.2f")

* initial picture of pwf
local phi = 0.84
local eta = 1.12
local phi_ = string(`phi', "%3.2f")
local eta_ = string(`eta', "%3.2f")
graph twoway function y = exp( (-`eta') * (-ln(x) )^`phi'), clpattern(dash) clwidth(thick) clcolor(blue) || function y=x, clpattern(solid) clcolor(black) legend(off) ytitle("{&omega}(p)   ", orient(horizontal) size(vlarge)) xtitle("p", size(vlarge)) ylabel(0(.1)1, nogrid angle(horizontal)) xlabel(0(.1)1, nogrid angle(horizontal)) xline(0.5) yline(0.5) xsize(1) ysize(1) saving(TempData/tmp1G, replace)


* now calculate the decision weights for uniform-probability lottery
* look at probability weights for various settings
foreach ncases in 7 6 5 4 3 2 {

qui {

local inc=100/`ncases'

forvalues x=0/100 {
    generate p`x'=.
    generate prob`x'=.
}

forvalues x=0(`inc')100 {
    local xx=round(`x',1)
    local xxx=`x'/100
    replace p`xx' = (exp( (-`eta') * (-ln(`xxx') )^`phi'))
    replace prob`xx'=`x'/100
}
replace p0=0
replace p100=1
replace prob0=0
replace prob100=1

summ
generate row=1
reshape long p prob, i(row) j(pr)
drop if prob==.

generate p_inc=p[_n]-p[_n-1]
drop if p_inc==.

egen prizesG=seq(), from(`ncases') to(1)
egen prizesL=seq(), from(1) to(`ncases')
generate ncases=`ncases'

}

list prizesG prizesL prob p p_inc ncases, noobs
save TempData/prob`ncases', replace

drop if prizesG>1
drop row p prob p_inc ncases prizesG prizesL pr
set obs 1

}

* collate
use TempData/prob2, clear
foreach ncases in 7 6 5 4 3 {
    append using TempData/prob`ncases'
    erase TempData/prob`ncases'.dta
}
erase TempData/prob2.dta

tab ncases
tab prizesG

summ ncases
local Nprizes=r(max)
drop if prizesG>`Nprizes'

* get some EUT lines
generate p_incEUT = 1/ncases

local text "Worst to Best"
twoway (connected p_incEUT prizesG if ncases==3, clpattern(solid) clcolor(black) mcolor(black)) (connected p_inc prizesG if ncases==3, clpattern(dash) clwidth(thick) clcolor(blue) mcolor(blue)), ytitle("Decision" "Weight", size(large) orientation(horizontal)) ylabel(0(.1)0.5, angle(horizontal)) xtitle(Prize (`text'), size(large)) xlabel(1(1)3) legend(off) saving(TempData/tmp2G, replace)
gr combine TempData/tmp1G.gph TempData/tmp2G.gph, title("Figure C1: Probability Weighting and Decision Weights" "With Partial Asset Integration") subtitle("RDU Estimates: r = `r_',  {&eta}=`eta_',  {&phi}=`phi_'") saving(ToMove/AI_figureC1, replace) imargin(tiny)

* clean up
erase TempData/tmp1G.gph
erase TempData/tmp2G.gph
		
log close log1		

exit
		
		
		
